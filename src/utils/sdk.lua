local SDK = class("SDK")

if device.platform == "ios" then
    SDK.luaoc = require "cocos.cocos2d.luaoc"
elseif device.platform == "android" then
    SDK.luaj = require "cocos.cocos2d.luaj"
end

function SDK:doAction(action, args)
    if QY_SDK ~= "default" and device.platform == "ios" then
        local params = {action = action}
        for k, v in pairs(args or {}) do
            params[k] = v
        end
        self.luaoc.callStaticMethod("SDK", "doAction", params)
    else
        if args.callback then
            args.callback()
        end
    end
end

function SDK:init(callback)
    self:doAction("sdk.init", {callback = callback})
end

function SDK:login(callback)
    self:doAction("sdk.login", {callback = callback})
end

return SDK