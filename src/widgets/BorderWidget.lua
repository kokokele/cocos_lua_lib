--[[
    说明: 边框（公告）
]]

local BorderWidget = qy.View.Base.extend("BorderWidget", "widget/BorderWidget")

function BorderWidget:ctor()
    BorderWidget.super.ctor(self)

	self:InjectView("Border")
    self:InjectView("Corner1")
    self:InjectView("Corner2")
    self:InjectView("Corner3")
    self:InjectView("Corner4")
end

-- 设置高度
function BorderWidget:setHeight(entity)
	local textHeight = entity.height_:get()
	local imageHeight = entity.picHeight_:get()
	local totalHeight = textHeight + imageHeight + 40
	self.Border:setContentSize(cc.size(505, totalHeight))
	self.Corner1:setPositionY(totalHeight - 19)
	self.Corner2:setPositionY(totalHeight - 19)
end

return BorderWidget