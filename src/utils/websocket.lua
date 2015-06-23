local WS = class("WS")

local _ws = nil
local _islogined = false

local _message_route = {
    ["Index.message"] = qy.Model.Chat,
    ["Index.history"] = qy.Model.Chat
}

function WS:connect()
    local currentZone = qy.Model.Area.currentZone_:get()
    _ws = cc.WebSocket:create("ws://" .. currentZone.socket_host_:get() .. ":" .. currentZone.socket_port_:get())
    _ws:registerScriptHandler(function(data)
        self:onOpen(data)
    end,cc.WEBSOCKET_OPEN)
    _ws:registerScriptHandler(function(data)
        self:onMessage(qy.json.decode(data or {}))
    end,cc.WEBSOCKET_MESSAGE)
    _ws:registerScriptHandler(function(data)
        self:onClose(data)
    end,cc.WEBSOCKET_CLOSE)
    _ws:registerScriptHandler(function(data)
        self:onError(data)
    end,cc.WEBSOCKET_ERROR)
end

function WS:login(id, name, sec, level, icon)
    self._loginparams = {
        id = id,
        name = name,
        sec = sec,
        level = level or 1,
        icon = icon or ""
    }

    self:connect()
end

function WS:upinfo(info)
    if _ws == nil then
        return
    end
    self._loginparams.name = info.name or self._loginparams.name
    self._loginparams.level = info.level or self._loginparams.level
    self:send({
        m = "Index.update_user_info",
        p = info
    })
end

function WS:send(data)
    if _ws == nil then
        self:connect()
    end

    -- 等待建立
    if _islogined == false then
        while cc.WEBSOCKET_STATE_OPEN ~= _ws:getReadyState() do
        end
    end

    _ws:sendString(qy.json.encode(data))
    print(qy.json.encode(data))
end

function WS:onOpen(data)
    print("onOpen")

    -- 建立链接后进行登录
    self:send({
        m = "Index.login",
        p = self._loginparams
    })
end

function WS:onMessage(data)
    if data.msg and data.msg == "heartbeat" then
    else
        print("onMessage", qy.json.encode(data))

        -- 登录回调
        if data.m == "Index.login" then
            _islogined = data.code == "OK"
            -- 登录成功后获取历史记录
            self:send({
                m = "Index.history",
                p = { sec = self._loginparams.sec }
            })
        else
            local model = _message_route[data.m or ""]
            if model then
                model:onMessage(data)
            end
        end
    end
end

function WS:onClose(data)
    print("onClose")
    _ws = nil
    _islogined = false
end

function WS:onError(data)
    print("onError", data)
    _ws = nil
    _islogined = false
end

return WS