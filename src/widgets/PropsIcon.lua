--[[
    通用道具ICON
]]

local PropsIcon = qy.View.Base.extend("PropsIcon", "widget/PropsIcon")

function PropsIcon:ctor(data, isShowName)
    PropsIcon.super.ctor(self)

    local nums = nil -- 个数
----------------
-- 读取本地数据表
    local localTable = qy.Helper.static.hero
    local tag = nil
    if type(data) == "table" then
        tag = data.tag
    elseif type(data) == "string" then
        tag = data
    end
    
    local oneData = localTable[tostring(tag)]

----------------
-- 渲染UI
    self:InjectView("daoju")
    self:InjectView("daojuBox")
    self:InjectView("nums")
    self:InjectView("name")
    
    if data.num == nil or data.num == 1 then
        nums = 1
    else
        nums = data.num
    end
    
    local quality = oneData.quality
    if oneData.type ~= "tool" then
        quality = 1
    end
    
    self.types = oneData.type
    self.quality = quality
    self.nameStr = qy.I18N.getString(oneData.name)
    self.id = data.tag

    local tag = tonumber(data.tag) > 70000 and tonumber(data.tag) - 70000 or tonumber(data.tag) > 8000 and tonumber(data.tag) - 2000 or data.tag
    self.daoju:setSpriteFrame("Resources/common/icon/" .. tag .. ".jpg")
    local spStr = string.format("Resources/common/icon/frame_item_%d.png", quality)
    self.daojuBox:setSpriteFrame(spStr)
    self.nums:setString(nums)
    self.name:setString(self.nameStr)
    if tonumber(tag) < 5000 then
        self.daoju:setScale(86/self.daoju:getContentSize().width)
    end
    if not isShowName then
        self.name:setVisible(false)
    end
end

return PropsIcon