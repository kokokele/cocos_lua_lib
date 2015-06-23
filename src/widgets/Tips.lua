--[[
    说明: tips
    作者: 蒋明明
    日期: 2015-4-23

    usage:
        qy.Widget.Toast.make("内容", 1, cc.p(480, 320)):show()
]]

local Tips = qy.View.Base.extend("Tips", "widget/Tips")

function Tips:ctor()
    Tips.super.ctor(self)

    self:InjectView("Name")
    self:InjectView("Desc")

    self.Desc:getVirtualRenderer():setLineHeight(22)
    self.Desc:fixSize(cc.size(280, 50))
end

function Tips.make(name, desc, node, forward)
    local tips = qy.App.runningScene.tips
    tips.Name:setString(qy.I18N.getString(name) or name)
    tips.Desc:setString(qy.I18N.getString(desc) or desc)

    local position = node:getParent():convertToWorldSpace(cc.p(node:getPositionX(),node:getPositionY()))

    position.x = position.x + 350 > display.width and display.width - 350 or position.x

    local finalPosition = not forward and cc.p(position.x + 25, position.y - 30) or  forward == "up" and cc.p(position.x - 25, position.y + 30) or cc.p(position.x + 25, position.y - 30)
    tips:setPosition(finalPosition)
    return tips
end

function Tips:show()
    self:setVisible(true)
    self:setOpacity(0)
    self:runAction(cc.FadeIn:create(0.2))
end

function Tips:hide()
    self:runAction(cc.FadeOut:create(0.2))
    self:setVisible(false)
end

return Tips