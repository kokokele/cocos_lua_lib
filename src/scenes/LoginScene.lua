--[[
    说明：登录场景
]]

local LoginScene = class("LoginScene", app.scenes.BaseScene)

function LoginScene:ctor()
    LoginScene.super.ctor(self)

    local view = class("view1", app.V)
    function view:ctor()
    	view.super.ctor(self)
    end

    local v = view.new()
    
    v:addCSB("LoginSceneSkin")

    v:InjectView("Button_1", "btn")

    v:OnClick("Button_1", function()
    		print("Button_1")
    	end)

    self:addChild(v)


    local vo = app.entitys.TestVO
    --vo.id_:set(123)

    local l1 = vo:addObserver("id", function(id)
        print("my_id:", id)
        end)

    print(l1)

    --vo:removeObserver(l1)

    vo.id_:set(456)

    vo.id_:set(789)

end

return LoginScene