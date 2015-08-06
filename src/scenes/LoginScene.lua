--[[
    说明：登录场景
]]

local LoginScene = class("LoginScene", app.scenes.BaseScene)

function LoginScene:ctor()
    LoginScene.super.ctor(self)
end


function LoginScene:onEnter()
    app.ViewCenter:appear("__Main")

    --local view = app.main.MainV.new()
    -- self:add(view)

end

return LoginScene
