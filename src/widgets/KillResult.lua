--[[
    说明: 杀戮战场结算
]]

local KillResult = qy.View.Base.extend("KillResult", "widget/KillResult")

function KillResult:ctor()
	KillResult.super.ctor(self)
	
	self:InjectView("Title")
	self:InjectView("Bg2")
	self:InjectView("Hard_num")
	self:InjectView("Kill_num")
	self:InjectView("Bg2")
	self:InjectView("Content")
	self:InjectView("Num_1")
	self:InjectView("Num_2")
	self:InjectView("Num_3")
	self:InjectView("LoadingBar")
	self:InjectView("Kill")
	self:InjectView("Text_9_Copy")
	self:InjectView("Text_9_Copy_Copy_0")
	self:InjectView("Text_9_Copy_Copy_0_0")

	self.totalNum = ccui.TextAtlas:create()
    self.totalNum:setProperty(tostring("12345"), "Resources/common/number/rank.png", 36, 58, "0")
	self.totalNum:setAnchorPoint(cc.p(0, 0.5))
	self.totalNum:setPosition(cc.p(200, 25))
	self.totalNum:setScale(0.7)
	self.Bg2:addChild(self.totalNum)

	self.Kill_num:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
	self.Hard_num:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
	self.Title:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
	self.Kill:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
	self.Text_9_Copy:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
	self.Text_9_Copy_Copy_0:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
	self.Text_9_Copy_Copy_0_0:enableShadow(cc.c4f(0, 0, 0, 180),cc.size(2, -2))
end

-- 
function KillResult:setData(data)
	self.Kill_num:setString(data.star)
	self.Hard_num:setString("X" .. data.add_ratio)
	self.totalNum:setString(data.score)
	local maxNum = qy.Helper.static.setting.killzone_dead_max_num
	self.Num_1:setString("歼敌" .. maxNum / 4)
	self.Num_2:setString("歼敌" .. maxNum / 2)
	self.Num_3:setString("歼敌" .. maxNum / 4 * 3)
	local width = math.min(maxNum, data.star) / maxNum * 100
	self.LoadingBar:setPercent(width)
	
	self.Title:setString(data.title .. "歼敌分数")
end

return KillResult