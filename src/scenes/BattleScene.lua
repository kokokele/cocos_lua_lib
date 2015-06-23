--[[

]]

-- local BattleScene = class("BattleScene", function()
--     return qy.Scene.Base.new()
-- end)

local BattleScene = class("BattleScene", qy.Scene.Base)

function BattleScene:ctor()
    -- local label = cc.Label:createWithSystemFont("战斗场景","",30)
    -- label:setPosition(480,320)
    -- self:addChild(label)

    -- local battle = require("game.gameLayer.battle.Battle").new()

    -- print(battle.battleData.name)

    -- self:addChild(battle)
    -- qy.Manager.Guide:registerContainer(self)
    BattleScene.super.ctor(self)
    self:push(qy.Controller.Battle.new())
end

function BattleScene:onEnter()
	BattleScene.super.onEnter(self)

    self.listener = qy.Event.add(qy.Event.USER_LEVEL_CHANGED, function(event)
        if qy.Model.User.info.level_:get() > 1 then
            qy.M.playEffect("UI2.mp3")
            qy.Dialog.UserUpgrade.new():show()
        end
    end)

    self.listener_2 = qy.Event.add(qy.Model.Name.Event.IsEmpty, function()
        qy.Dialog.Name.new(qy.Model.User.info.name_:get()):show()
    end)

	-- 只有在初始引导的时候才会进入
	if qy.IS_NEW and qy.Manager.Guide.step == 1 then
		qy.Manager.Guide:start()
	end
end

function BattleScene:onExit()
    BattleScene.super.onExit(self)

    qy.Event.remove(self.listener)
    qy.Event.remove(self.listener_2)
end

return BattleScene