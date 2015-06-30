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
}

function BasePopup:ctor()
    assert(#self.style.skin > 0, "需要Popup需要皮肤文件")
    self.skin = self:addCSB(self.style.skin)
    self:addChild(self.skin)

    if self.style.width == 0 then self.style.width = self.skin:getContentSize().width end
    if self.style.height == 0 then self.style.height = self.skin:getContentSize().height end


    print(display.width, self.skin:getContentSize().width)
    self.skin:move((display.width - self.style.width) / 2, (display.height - self.style.height) / 2)
end

function BasePopup:show()
    app.runningScene():addChild(self)

    local layout = ccui.Layout:create()
    layout:setContentSize(display.size)
    layout:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    layout:setBackGroundColorType(1)              -- 填充方式
    layout:setBackGroundColorOpacity(self.style.bgOpacity)         -- 颜色透明度
    layout:setTouchEnabled(true)


end


function BasePopup:dissmiss()
    app.runningScene():removeChild(self)
end


return BasePopup
