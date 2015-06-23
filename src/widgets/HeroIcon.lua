--[[
    说明: 英雄头像图标, 继承于Icon.lua
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-11-26
]]

-- 品质边框
local ClassTexture = { "frame_hero_1.png", "frame_hero_2.png", "frame_hero_3.png", "frame_hero_4.png", "frame_hero_5.png" }

local HeroIcon = qy.View.Base.extend("HeroIcon", "widget/HeroIcon")

function HeroIcon:ctor(delegate)
    self:InjectView("Class")
    self:InjectView("Avatar")
    self:InjectView("Text_num")
    self:InjectView("Level")
    self:InjectView("Levelbg")
    self:InjectView("Selected")
    self:InjectView("ProgressBar")

    self:InjectView("Ui_grade1")
    self:InjectView("Ui_grade2")

    self:InjectView("Node_star")
    self:InjectView("Ui_star1")
    self:InjectView("Ui_star2")
    self:InjectView("Ui_star3")
    self:InjectView("Ui_star4")
    self:InjectView("Ui_star5")

    self:InjectView("Text_summon")

    self.Level:enableOutline(cc.c4b(0, 0, 0, 255), 1)
    self.Avatar:setSwallowTouches(false)

    if delegate then
        self:OnClick(self.Avatar, function(sender, touchPos)
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
                self._origin_scale = self:getScale()
                qy.Effects:nodeTouchBegan(self, self._origin_scale + 0.05)
            elseif eventType == ccui.TouchEventType.moved then
            else
                qy.Effects:nodeTouchEnd(self, self._origin_scale)
            end
        end)
    end

    self.Text_num:enableOutline(cc.c4b(0, 0, 0, 200), 1)
end

function HeroIcon:setData(heroEntity)
    self:setVisible(heroEntity ~= nil)

    if heroEntity then
        self:setActivate(heroEntity.isopen_:get())

        self.Text_num:setString(heroEntity.soulnum_:get() .. "/" .. heroEntity.needsoul_:get())
        self.ProgressBar:setPercent(heroEntity.soulnum_:get() / heroEntity.needsoul_:get() * 100)

        self.Text_num:setVisible(not heroEntity.isopen_:get())
        self.ProgressBar:getParent():setVisible(not heroEntity.isopen_:get())
        self.Text_summon:setVisible(not heroEntity.isopen_:get() and heroEntity.soulnum_:get() >= heroEntity.needsoul_:get())

        self.Levelbg:setVisible(heroEntity.level_:get() > 0)
        self.Level:setVisible(heroEntity.level_:get() > 0)
        self.Level:setString(heroEntity.level_:get())

        local _d = qy.Helper.static.hero[tostring(heroEntity.icon_:get())]
        -- print("_d.icon==", _d.icon)
        self.Avatar:loadTexture("Resources/common/icon/" .. _d.icon .. ".jpg", ccui.TextureResType.plistType)
        -- 品阶
        self:setGradeAndLevel(heroEntity.grade_:get(), heroEntity.isopen_:get() and heroEntity.gradelevel_:get() or 0)

        -- 星级
        for i = 1, 5 do
            self["Ui_star" .. i]:setVisible(heroEntity.isopen_:get() and heroEntity.star_:get() >= i)
        end

        self.Node_star:setPositionX(55 - 11 * heroEntity.star_:get())
    end
end

function HeroIcon:setData2(data)
    self:setVisible(data ~= nil)
    if data then
        self.Level:setString(data.level)

        self.Text_num:setVisible(false)
        self.ProgressBar:getParent():setVisible(false)
        self.Text_summon:setVisible(false)

        local tag = tonumber(data.tag) > 4100 and tonumber(data.tag) - 100 or data.tag
        self.Avatar:loadTexture("Resources/common/icon/" .. tag .. ".jpg", ccui.TextureResType.plistType)

        -- 品阶
        self:setGradeAndLevel(data.grade, data.grade_level)

        -- 星级
        for i = 1, 5 do
            self["Ui_star" .. i]:setVisible(tonumber(data.star) >= i)
        end

        self.Node_star:setPositionX(48 - 10 * data.star)
    end
end

-- 设置激活
function HeroIcon:setActivate(flag)
    local color = flag and cc.c3b(255,255,255) or cc.c3b(90,90,90)
    self.Class:setColor(color)
    self.Avatar:setColor(color)
    self.Level:setColor(color)
    self.Levelbg:setColor(color)
    self.Node_star:setColor(color)
    for i = 1, 2 do
        self["Ui_grade" .. i]:setColor(color)
    end
end

function HeroIcon:setGradeAndLevel(grade, gradelevel)
    self.Class:setSpriteFrame("Resources/common/icon/" .. ClassTexture[math.min(tonumber(grade), 5)])
    for i = 1, 2 do
        self["Ui_grade" .. i]:setVisible(gradelevel > 0)
        if gradelevel > 0 then
            self["Ui_grade" .. i]:setSpriteFrame(string.format("Resources/common/icon/frame_grade_%s_%s.png", grade, gradelevel))
        end
    end
end

function HeroIcon:selected(flag)
    self.Selected:setVisible(flag)
    self:setActivate(not flag)
end

return HeroIcon