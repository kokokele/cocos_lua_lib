--[[
    说明：登录场景
]]

local LoginScene = class("LoginScene", app.p.scenes.BaseScene)

function LoginScene:ctor()
    LoginScene.super.ctor(self)

    -- local view = class("view1", qy.V)
    -- function view:ctor()
    -- 	view.super.ctor(self)
    -- end

    -- local v = view.new()
    -- v:addCSB("LoginSceneSkin")

    -- v:InjectView("Button_1", "btn")
    -- v:OnClick("Button_1", function()
    -- 		print("Button_1")
    -- 	end)

    -- self:addChild(v)

end

return LoginScene