--[[

zp
弹窗基类
]]

local BasePopup = class("BasePopup", app.V)

local defaultStyle = class("defaultStyle")


function BasePopup:ctor()
    BasePopup.super.ctor(self)

    self.defaultStyle = {
        ["skin"] = "",
        ["bgOpacity"] = 160,
        ["width"] = 0,
        ["height"] = 0,
        ["gap"] = 0,
        ["baseSkin"] = app.config.Theme .. ".PopupSkin"
    }

    if self.style then
        if self.style.skin then self.defaultStyle.skin = self.style.skin end
        if self.style.bgOpacity then self.defaultStyle.bgOpacity = self.style.bgOpacity end
        if self.style.width then self.defaultStyle.width = self.style.width end
        if self.style.height then self.defaultStyle.height = self.style.height end
    end

    assert(#self.defaultStyle.skin > 0, "需要Popup需要皮肤文件")

    self:render()
end

function BasePopup:render ()
    -- self._layout = ccui.Layout:create()
    -- self._layout:setContentSize(cc.size(display.width, display.height))
    -- self._layout:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    -- self._layout:setBackGroundColorType(1)              -- 填充方式
    -- self._layout:setBackGroundColorOpacity(190)         -- 颜色透明度
    -- self._layout:setTouchEnabled(true)
    -- self:addChild(self._layout, -1)


    self.baseSkin = self:addCSB(self.defaultStyle.baseSkin)
    self:InjectView("Bg")
    self:InjectView("Button_Close", "close")

    assert(self.Bg, "popupSkin: Bg不存在")

    local w = self.defaultStyle.width
    local h = self.defaultStyle.height
    local gap = self.defaultStyle.gap

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

    self.skin = self:addCSB(self.defaultStyle.skin, self.Bg)

    if w == 0 then self.defaultStyle.width = self.skin:getContentSize().width end
    if h == 0 then self.defaultStyle.height = self.skin:getContentSize().height end

    self.Bg:setContentSize(w + gap * 2, h + gap * 2)
    self.Bg:move((display.width - w) / 2, (display.height - h) / 2)

    self.skin:move(gap, gap)

    --子类实现
    self:adjust()
end

function BasePopup:show()
    self:init()
    display:getRunningScene():getPopContainer():addChild(self)

    local layout = ccui.Layout:create()
    layout:setContentSize(display.size)
    layout:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    layout:setBackGroundColorType(1)              -- 填充方式
    layout:setBackGroundColorOpacity(self.defaultStyle.bgOpacity)         -- 颜色透明度
    layout:setTouchEnabled(true)

    self:addChild(layout, -1)



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
