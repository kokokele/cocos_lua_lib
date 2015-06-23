--[[
    特效管理
    黄晨
]]

local Effects = class("Effects")

Effects.TOUCH_EFFECT_TIME = 0.05

-- node整体缩放
function Effects:nodeTouchBegan(node, scale)
    node:runAction(cc.ScaleTo:create(self.TOUCH_EFFECT_TIME, scale or 1.05))
end

function Effects:nodeTouchEnd(node, scale)
    node:runAction(cc.ScaleTo:create(self.TOUCH_EFFECT_TIME, scale or 1))
end

return Effects