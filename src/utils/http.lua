--[[
    说明: Http请求库

    TODO: 实现队列功能, 加入协程

    usage:
        qy.Http.new(qy.Http.Request.new(params[, qy.Http.GET | qy.Http.POST]):send(function(response)
            print(response.code, response.data)
        end))
]]

local Http = class("Http")

-- 请求方法常量
Http.GET = "GET"
Http.POST = "POST"

Http.Request = class("HttpRequest")
Http.Response = class("HttpResponse")

local ERROR_COUNT = 0
local IGNORE_ERROR_M = {
    ["User.fresh"] = true,
    ["System.getSecs"] = true,
    ["System.login"] = true
}

function Http:ctor(request)
    self.request = request
    self._isshowloading = true
end

function Http:setShowLoading(flag)
    self._isshowloading = flag
    return self
end

function Http:send(callback)
    if self._isshowloading then
        qy.Event.dispatch(qy.Event.SERVICE_LOADING)
    end

    if qy.DEBUG then
        print("url: " .. self.request.url:toStr())
        print("params: " ..qy.json.encode(self.request.params))
    end

    local xhr = cc.XMLHttpRequest:new()

    local function onReadyStateChange()
        if qy.DEBUG then
            print("http response: ")
            print(" ", xhr.status)
            print(" ", xhr.response)
        end

        if xhr.status == 200 then
            local jdata = qy.json.decode(xhr.response)

            -- 返回数据不是json，服务器发生错误
            if jdata == nil and not IGNORE_ERROR_M[self.request.params.m] then
                if ERROR_COUNT < 2 then
                    ERROR_COUNT = ERROR_COUNT + 1
                    qy.Http.new(qy.Http.Request.new({
                        ["m"] = "User.get_last_data"
                    })):send(function(response, request)
                    end)
                    return
                else
                    qy.Widget.Toast.make("tid#note_11"):show()
                end
            else
                if jdata.s == "OK" then
                    -- 更新数据
                    if qy.Model.Game.isinit and self.request.params.m ~= "User.get" and jdata.d then
                        qy.Model.Game:upData(jdata.d)
                    end

                    -- 回调数据
                    if callback then
                        callback(Http.Response.new(xhr.status, jdata), self.request)
                    end
                else
                    qy.Widget.Toast.make(qy.res.ERROR_CODE[tostring(jdata.s)]):show()
                    if qy.DEBUG then
                        print("errorcode: " .. jdata.s)
                    end
                end
            end
        else
            qy.Widget.Toast.make("tid#note_11"):show()
            if qy.DEBUG then
                print("responsecode: " .. xhr.status)
            end
        end

        if self._isshowloading then
            qy.Event.dispatch(qy.Event.SERVICE_LOADING_DONE)
        end

        ERROR_COUNT = 0
    end

    local sessionId = qy.Model.User:getSessionId()
    if sessionId then
        xhr:setRequestHeader("PHPSESSID", sessionId)
    end
    
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_STRING
    xhr:open(self.request.method, self.request.url:toStr())
    xhr:registerScriptHandler(onReadyStateChange)
    
    xhr:send(self.request:getParamsStr())
end

function Http.Request:ctor(params, method)
    self.url = self:URL()
    self.params = params
    self.method = method or Http.POST
end

function Http.Request:URL()
    return {
        scheme = qy.SERVER_SCHEME,
        domain = qy.SERVER_DOMAIN,
        port = qy.SERVER_PORT,
        path = qy.SERVER_PATH,

        toStr = function(self)
            return string.format("%s://%s:%s/%s", self.scheme, self.domain, self.port, self.path)
        end
    }
end

function Http.Request:getParamsStr()
    return self.method == Http.POST and qy.json.encode(self.params) or nil
end

-- data: 返回数据
-- request: 请求的对象
function Http.Response:ctor(code, data, request)
    self.code = code
    self.data = data
    self.request = request
end

return Http