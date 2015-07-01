--[[
    说明：登录场景
]]

local LoginScene = class("LoginScene", app.scenes.BaseScene)

function LoginScene:ctor()
    LoginScene.super.ctor(self)

    -- local view = class("view1", app.V)
    -- function view:ctor()
    -- 	view.super.ctor(self)
    -- end
    --
    -- local v = view.new()
    --
    -- v:addCSB("LoginSceneSkin")
    --
    -- v:InjectView("Button_1", "btn")
    --
    -- v:OnClick("Button_1", function()
    -- 		print("Button_1")
    -- 	end)
    --
    -- self:addChild(v)
    --
    --
    -- local vo = app.entitys.TestVO
    -- vo.testSignal:add(function(param)
    --   print("param:", param)
    -- end)
    --
    --
    -- vo:fireSignal()
    --
    -- vo.testSignal:addOnce(function(param)
    --   print("once_param:", param)
    -- end)
    --
    -- local vo1 = app.entitys.TestVO
    -- local vo2 = app.entitys.TestVO
    --
    -- vo:fireSignal()
    --
    -- vo:fireSignal()





    -- --vo.id_:set(123)
    --
    -- local l1 = vo:addObserver("id", function(id)
    --     print("my_id:", id)
    --     end)
    --
    -- print(l1)
    --
    -- --vo:removeObserver(l1)
    --
    -- vo.id_:set(456)
    --
    -- vo.id_:set(789)



end


function LoginScene:onEnter()
    app.ViewCenter:appear("__Main")

    --local view = app.main.MainV.new()
    -- self:add(view)

end

return LoginScene
