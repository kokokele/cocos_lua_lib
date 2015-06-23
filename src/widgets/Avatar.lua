--[[
    说明：玩家头像
    作者：林国锋 <guofeng@9173.com>
]]

local Avatar = class("Avatar", qy.View.Base)

function Avatar:ctor(onClicked)
    Avatar.super.ctor(self)

    self:InjectView("Image_1")
    self.Image_1:setSwallowTouches(false)
    self:OnClick("Image_1", onClicked)
end

return Avatar