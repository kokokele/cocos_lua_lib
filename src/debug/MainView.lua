--[[
    说明: Debug主界面
]]

local MainView = class("MainView", function()
    return qy.Dialog.Base.new()
end)

function MainView:ctor()
    local button = ccui.Button:create()
    button:setTouchEnabled(true)
    button:setScale9Enabled(true)
    button:setCapInsets(cc.rect(10, 10, 10, 10))
    button:setContentSize(cc.size(200, 35))
    button:loadTextures("Default/Button_Normal.png", "Default/Button_Press.png", "")
    button:setPosition(cc.p(display.size.width / 2.0, 50))
    button:setTitleText("确 定")
    button:setTitleColor(cc.c3b(0, 0, 0))
    button:setTitleFontSize(22)
    button:setTitleFontName(qy.res.FONT_NAME)
    self:addChild(button)

    local textField = ccui.TextField:create()
    textField:setTouchEnabled(true)
    textField:setFontName(qy.res.FONT_NAME)
    textField:setFontSize(30)
    textField:setPlaceHolder("输入代理服务器IP地址")
    textField:setPosition(cc.p(display.size.width / 2.0, display.size.height / 2.0))
    self:addChild(textField) 

    self:OnClick(button, function(sender)
        qy.proxy_ip = textField:getString()
        self:dismiss()
    end)

    if qy.proxy_ip then
        textField:setString(qy.proxy_ip)
    end
end

return MainView