--[[

zp
弹窗基类
]]

local BasePopup = class("BasePopup", app.V)

BasePopup.style  = {
    ["skin"] = "",
    ["bgOpacity"] = 160,
    ["width"] = 0,
    ["height"] = 0,
    ["gap"] = 0,
    ["baseSkin"] = app.config.Theme .. ".PopupSkin"
}

function BasePopup:ctor()
    assert(#self.style.skin > 0, "需要Popup需要皮肤文件")

    self.baseSkin = self:addCSB(self.style.baseSkin)
    self:InjectView("Bg")
    self:InjectView("Button_Close", "close")

    assert(self.Bg, "popupSkin: Bg不存在")

    local w = self.style.width
    local h = self.style.height
    local gap = self.style.gap

    -- center
    local cx = (display.width - w) / 2
    local cy = (display.height - h) / 2

    --  根据相对位置调整close位置
    if self.close then

        local xoffset = (w - self.Bg:getContentSize().width)
        local yoffset = (h - self.Bg:getContentSize().height)

        self.close:move(self.close:getPositionX() + xoffset +  cx, self.close:getPositionY() + yoffset + cy)

        self:OnClick("Button_Close", function()
            self:dismiss()
        end)
    end

    self.skin = self:addCSB(self.style.skin, self.Bg)

    if w == 0 then self.style.width = self.skin:getContentSize().width end
    if h == 0 then self.style.height = self.skin:getContentSize().height end

    self.Bg:setContentSize(w + gap * 2, h + gap * 2)
    self.Bg:move((display.width - w) / 2, (display.height - h) / 2)

    self.skin:move(gap, gap)

    --子类实现
    self:adjust()
end

function BasePopup:show()

    display:getRunningScene():getPopContainer():addChild(self)

    local layout = ccui.Layout:create()
    layout:setContentSize(display.size)
    layout:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    layout:setBackGroundColorType(1)              -- 填充方式
    layout:setBackGroundColorOpacity(self.style.bgOpacity)         -- 颜色透明度
    layout:setTouchEnabled(true)


    self:showAction()
end

function BasePopup:showAction()

    local delay = cc.Director:getInstance():getAnimationInterval() - (1.0 / 60)

    self:setPositionY(-500)

    self:runAction(cc.MoveTo:create(0.2, cc.p(0, 0) ))

end


function BasePopup:dismiss()

    self:runAction(cc.Sequence:create(
        cc.MoveTo:create(0.1, cc.p(0, -500)),
        cc.CallFunc:create(function()
            self:removeFromParent()
        end)
     ))

end

-- 子类实现 局部皮肤调整
function BasePopup:adjust()
end


return BasePopup
