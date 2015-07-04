--
-- Author: Your Name
-- Date: 2015-05-27 17:24:25
--
local Loading = class("Loading", app.V)

Loading.style = {
    ["skin"] = app.config.Theme .. ".LoadingSkin",
    ["bgOpacity"] = 120
}

function Loading:ctor()
    self:addCSB(self.style.skin)
    self:setVisible(false)

    self:render()
end

function Loading:render()
    self:setPosition(display.center )

    self._layout = ccui.Layout:create()
    self._layout:setContentSize(cc.size(display.width, display.height))
    self._layout:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    self._layout:setBackGroundColorType(1)              -- 填充方式
    self._layout:setBackGroundColorOpacity(self.style.bgOpacity)         -- 颜色透明度
    self._layout:setTouchEnabled(true)

    self._layout:setPosition(-self:getPositionX(), -self:getPositionY())
    self:addChild(self._layout, -1)
end

function Loading.on()
    display:getRunningScene():getLoading():setVisible(true)
end

function Loading:off()
	display:getRunningScene():getLoading():setVisible(false)
end



return Loading
