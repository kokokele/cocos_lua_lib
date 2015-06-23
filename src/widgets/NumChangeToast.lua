--[[
    说明: 提示小浮层
    作者: 蒋明明
    日期: 2015-4-27
]]

local NumChangeToast = qy.View.Base.extend("NumChangeToast", "widget/NumChangeToast")

function NumChangeToast:ctor()
    NumChangeToast.super.ctor(self)

    self:InjectView("Text_Num")

    self:setOpacity(0)
    -- self:setPosition(cc.p(display.size.width / 2, display.size.height * 0.5))
end

function NumChangeToast:show(parent, num)
    self.Text_Num:setString("+" .. num)
    self:addTo(parent, 1000)
    self:setOpacity(255)

    local moveAndFadeOut = cc.Spawn:create(cc.FadeOut:create(0.5), cc.MoveBy:create(0.4, cc.p(0, 100)))
    self:runAction(cc.Sequence:create(cc.DelayTime:create(1.8), moveAndFadeOut, cc.CallFunc:create(function()
        self:removeFromParent()
    end)))
end

return NumChangeToast