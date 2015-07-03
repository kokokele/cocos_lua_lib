--[[

zp
基础icon
]]

local BaseIcon = class("BaseIcon", app.V)

BaseIcon.style = {
    ["skin"] = app.config.Theme .. ".IconSkin"
}

function BaseIcon:ctor()

    self:addCSB(self.style.skin)

    self:InjectView("icon")
    self:InjectView("frame")
end

function BaseIcon:render(url, eventHandler)

    self.icon:loadTexture(url, ccui.TextureResType.plistType)

    if eventHandler then
        self:OnClick(self.icon, function(sender, touchPos)
            eventHandler(self, touchPos)
        end,

        function(sender, eventType)

            -- 点击效果
            if eventType == ccui.TouchEventType.began then
                -- 记录原来的缩放大小
                if not self._origin_scale then
                    self._origin_scale = self:getScale()
                end
                self:runAction(cc.ScaleTo:create(0.05, self._origin_scale * 1.05))

            elseif eventType == ccui.TouchEventType.moved then
            else
                self:runAction(cc.ScaleTo:create(0.05, self._origin_scale))
            end
        end
        )--end
    end

end

return BaseIcon
