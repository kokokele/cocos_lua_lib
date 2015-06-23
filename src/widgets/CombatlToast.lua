--[[
    说明: 提示小浮层
    作者: 林国锋
    日期: 2014-12-23

    usage:
        qy.Widget.CombatlToast.make("内容", 1, cc.p(480, 320)):show()
]]

local CombatlToast = qy.View.Base.extend("CombatlToast", "widget/CombatlToast")

function CombatlToast:ctor()
    CombatlToast.super.ctor(self)

    self:InjectView("Text_combatl")

    self:setOpacity(0)
    self:setPosition(cc.p(display.size.width / 2, display.size.height * 0.5))
end

function CombatlToast:show(parent, combatl)
    self.Text_combatl:setString("+" .. combatl)
    self:addTo(parent, 1000)
    self:setOpacity(255)

    local moveAndFadeOut = cc.Spawn:create(cc.FadeOut:create(0.5), cc.MoveBy:create(0.4, cc.p(0, 100)))
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), moveAndFadeOut, cc.CallFunc:create(function()
        self:removeFromParent()
    end)))
end

return CombatlToast