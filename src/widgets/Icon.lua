local Icon = class("Icon", qy.View.Base)

Icon.__create = function(delegate, csbFile)
    return Icon.super.__create(csbFile or "widget/Icon")
end

cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/plist/common.plist")
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/plist/common_noalpha.plist")
cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/plist/head_icon.plist")

local soul_points = {cc.p(0, 20), cc.p(0, 82.95), cc.p(60, 82.95), cc.p(82.95, 60), cc.p(82.95, 0), cc.p(20, 0)}
local item_points = {cc.p(0, 0), cc.p(0, 82.95), cc.p(82.95, 82.95), cc.p(82.95, 0)}

-- 继承
function Icon.extend(name, csbFile)
    local InheritView = class(name, Icon)
    if csbFile then
        InheritView.__create = function(delegate)
            return InheritView.super.__create(delegate, csbFile)
        end
    end
    return InheritView
end

function Icon:ctor(delegate)
    Icon.super.ctor(self)

    self:InjectView("UI_class")
    self:InjectView("UI_soul")
    self:InjectView("Text_num")
    
    self.UI_class:setSwallowTouches(false)

    if delegate then
        self:OnClick(self.UI_class, function(sender, touchPos)
            if delegate.onClick then
                delegate.onClick(self, touchPos)
            end
        end, function(sender, eventType)
            if delegate.onTouchEvent then
                delegate.onTouchEvent(self, eventType)
            end
            -- 点击效果
            if eventType == ccui.TouchEventType.began then
                -- 记录原来的缩放大小
                if not self._origin_scale then
                    self._origin_scale = self:getScale()
                end
                qy.Effects:nodeTouchBegan(self, self._origin_scale + 0.05)
            elseif eventType == ccui.TouchEventType.moved then
            else
                qy.Effects:nodeTouchEnd(self, self._origin_scale)
            end
        end)
    end

    self._clippingNode = cc.ClippingNode:create()
    self._clippingNode:setPosition(-79 / 2.0, -79 / 2.0)

    self._stencil = cc.DrawNode:create()
    self._clippingNode:setStencil(self._stencil)

    self._avatar = cc.Sprite:create()
    self._avatar:setAnchorPoint(cc.p(0, 0))
    self._clippingNode:addChild(self._avatar)

    self:addChild(self._clippingNode)

    self.UI_class:setLocalZOrder(10)
    self.UI_soul:setLocalZOrder(10)
    self.Text_num:setLocalZOrder(10)
    self.Text_num:enableOutline(cc.c4b(0, 0, 0, 200), 1)
end

function Icon:setData(iconEntity)
    self:setVisible(iconEntity ~= nil)
    if iconEntity then
        if iconEntity.num_ and self.Text_num:isVisible() then
            self.Text_num:setString(iconEntity.num_:get())
            self.Text_num:setAnchorPoint(cc.p(1, 0.5))
            self.Text_num:setPositionX(37.25)
        end
        if iconEntity.level_ and self.Text_num:isVisible() then
            self.Text_num:setString(iconEntity.level_:get())
            self.Text_num:setAnchorPoint(cc.p(0, 0.5))
            self.Text_num:setPositionX(-37.25)
        end
        self._avatar:setSpriteFrame(iconEntity.img_:get())
        self._avatar:setScale(iconEntity.type_:eq(1) and 0.81 or 1.05)
        self.UI_class:loadTexture(iconEntity.grade_:get(), ccui.TextureResType.plistType)
        self.UI_soul:setVisible(iconEntity.soul_:get() ~= nil)
        if iconEntity.soul_:get() then
            self.UI_soul:setSpriteFrame(iconEntity.soul_:get())
            self.UI_soul:setFlippedX(iconEntity.isfilp_:get())
            self.UI_soul:setPosition(iconEntity.isfilp_:get() and -23.96 or -26.57, iconEntity.isfilp_:get() and 22.61 or 27.66)
        end

        if not iconEntity.type_:eq(self._lasttype or -1) then
            self._lasttype = iconEntity.type_:get()
            self._stencil:clear()
            if iconEntity.type_:eq(1) then
                self._stencil:drawPolygon(soul_points, table.getn(soul_points), cc.c4f(1,0,0,0.5), 0, cc.c4f(0,0,1,1))
            else
                self._stencil:drawPolygon(item_points, table.getn(item_points), cc.c4f(1,0,0,0.5), 0, cc.c4f(0,0,1,1))
            end
        end
    end
end

function Icon:setNum(num)
    self.Text_num:setString(num)
end

function Icon:setNumVisible(visible)
    self.Text_num:setVisible(visible)
end

function Icon:setOpen(flag)
    local color = flag and cc.c3b(255,255,255) or cc.c3b(90,90,90)
    self.UI_class:setColor(color)
    self.UI_soul:setColor(color)
    self._avatar:setColor(color)
end

return Icon