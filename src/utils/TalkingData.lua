--[[

]]

local TalkingData = class("TalkingData")

if device.platform == "ios" then
    TalkingData.luaoc = require "cocos.cocos2d.luaoc"
elseif device.platform == "android" then
    TalkingData.luaj = require "cocos.cocos2d.luaj"
end

function TalkingData:doAction(action, args)
    if QY_SDK ~= "haima" then
        return
    end
    if device.platform == "ios" then
        local params = {action = action}
        for k, v in pairs(args or {}) do
            params[k] = v
        end
        self.luaoc.callStaticMethod("TalkingDataLua", "doAction", params)
    elseif device.platform == "android" then
        local className = "org/cocos2dx/lua/TalkingDataLua"
        self.luaj.callStaticMethod(className, "startAction", {action}, "(Ljava/lang/String;)V")
        for key, value in pairs(args or {}) do
            self.luaj.callStaticMethod(className, "addParam", {key, value}, "(Ljava/lang/String;Ljava/lang/String;)V")
        end
        self.luaj.callStaticMethod(className, "doAction", {}, "()V")
    end
end

function TalkingData:init()
    self:doAction("td.init", {
        appid = "52099CC93E0961CC3AFFDA62124B3DC8",
        channelid = QY_SDK
    })
end

--[[
    {
        name = xxx,
        level = xxx,
        sec = xxxx
    }
]]
function TalkingData:setInfo(infos)
    infos.accountid = qy.Model.User.pid_:get()
    self:doAction("td.setInfo", infos)
end

function TalkingData:mission(value)
    if self._misionvalue then
        self:doAction("td.mission", {name = "completed", value = self._misionvalue})
    end
    self._misionvalue = value
    self:doAction("td.mission", {name = "begin", value = self._misionvalue})
end

function TalkingData:getDeviceId()
    -- if device.platform == "ios" then
    --     local ok, ret = self.luaoc.callStaticMethod("TalkingDataGA", "getDeviceId")
    --     if ok then
    --         return ret
    --     end
    -- end

    return cc.UserDefault:getInstance():getStringForKey("uuid")
end

TalkingData:init()

return TalkingData