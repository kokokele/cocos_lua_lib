--[[
	新手引导流程管理
	Author: Wei Long
	Date: 2014-12-11 16:58:29
	==================================================
	强制引导、对话框、非强制引导、二次引导
]]

local GuideManager = class("GuideManager")

GuideManager.id = 105
GuideManager.step = 1
GuideManager.subStep = 1
GuideManager.container = nil
GuideManager.guide = nil
GuideManager.dialog = nil
GuideManager.blank = nil
GuideManager.cfg = nil
GuideManager.model = nil
-- 1:playing 2:pausing 3:stopping
GuideManager.status = 0

-- 新手引导是否触发(此值做预留值，如何获取需要再做协商,暂时先由前端判断)
GuideManager.prepareOk = true
local model = qy.Model.Guide

-- 测试是否触发新手引导
function GuideManager:checkGuide()
	return self.prepareOk
end

function GuideManager:registerContainer(c)
	cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/plist/common_noalpha.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/plist/common.plist")
    cc.SpriteFrameCache:getInstance():addSpriteFrames("Resources/plist/head_icon.plist")

    -- 注册各个场景容器
    self.step = model:getStep()
    self.subStep = model:getSubStep()
    self:hide()

    if self.step == 1 then
    	local item = model:getAtStep(self.step, self.subStep)
    	qy.Model.Battle:setBattleData({
            battleType = 1,--战场类型 1为副本pve 2 pvp
            chapterType = 1,--章节类型 1为普通章节 2为精英章节
            guanKaId = item.guanka_:get(), -- 关卡ID
        })
    	self.container = qy.Scene.Drama.new()
    	-- self.container = qy.Scene.Battle.new()

        qy.App:pushScene(self.container)
    elseif self.step >= 2 then
    	if model:getStepData(self.step) then
    		self.container = c
    		self:start()
    	else
    		return
    	end
    end
end

-- 切换secene
function GuideManager:changeScene(c)
	self:changeContainer(c)
	qy.App:popScene()
	self.guide = nil
	qy.App:pushScene(self.container)
	-- if model:getStep(self.step) then
 --    	self:start()
	-- end
end

-- 切换容器
function GuideManager:changeContainer(c)
	-- self:hide()
	self.container = c
end

-- 启动一个新step从初始子步骤开始
function GuideManager:start()
	-- self.cfg = qy.Helper.static.guide
	self:gotoAndPlay()
end

-- 重新播放暂停后的引导
function GuideManager:play()
	print("GuideManager:play")
	self:hideBlank()
	self:next()
end

-- 播放
function GuideManager:gotoAndPlay()
	-- print("gotoAndPlay===========>>>>>>",self.step,"  ",self.subStep)
	local nextSubStep = model:getNextSubStep()
	local item = model:getAtStep(self.step, self.subStep)
	local type = nil
	if item then
		if self.step > 0 and self.subStep > 0 then
			self.id = item.id_:get()
			self:show()
			type = item.type_:get()
			qy.Event.dispatch(qy.Event.GUIDE_CHANGE, type)
		end
	end
end

-- 跳到指定步骤
function GuideManager:gotoAndPlayByID(id)
	print("GuideManager:gotoAndPlayByID" .. id)
	self.id = id
	local item = model:getCfgStep(id)
	self.step = item.step
	self.subStep = item.sub_step
	model:saveSubStep(self.subStep)
	self:show()
end

-- 暂停，画面停留在当前引导界面且不再监听任何操作直到重新start或play
function GuideManager:pause()
	print("GuideManager:pause")
	self:showBlank()	
end

function GuideManager:stop()
	print("GuideManager:stop")
	self:hide()
	qy.Event.dispatch(qy.Event.GUIDE_ENDED)
end

function GuideManager:ended()
	print("GuideManager:ended")
	-- self.prepareOk = false
	qy.IS_NEW = false
	qy.Event.dispatch(qy.Event.GUIDE_ENDED)
end

function GuideManager:getNextStep(callback)
	local list = model.step_list

	if self.subStep < #list[self.step].sub then
		-- next
		self.subStep = self.subStep + 1
		callback()
	else
		-- 大步骤结束
		if list[self.step + 1] then	
			-- 进入下一个大步骤
			self.subStep = 1
			self:beginNextStep(callback)
		else
			-- 没有下一个大步骤
			self.subStep = 1
			self:beginNextStep(callback)
			self.step = 1000
			self.subStep = 0 
			self:ended()
		end
	end
	model:saveSubStep(self.subStep)
end

function GuideManager:beginNextStep(callback)
	model:saveStep(self.step + 1, 1, self.id,function()
		self.subStep = 1
		self.step = self.step + 1 >= 6 and model:getNextStep() or self.step + 1
		self.id = 0
		qy.Event.dispatch(qy.Event.GUIDE_END)
		self:hide()
		callback()
	end)
	-- self:ended()
end

function GuideManager:next()
	local nextSubStep = model:getNextSubStep() or 0
	local item = model:getAtStep(self.step, self.subStep)

	if not item then
		return
	end

	qy.TalkingData:mission(string.format("newplayer-%s-%s", self.step, self.subStep))

	if nextSubStep > self.id and item.next_substep_:get() then
		self:gotoAndPlayByID(model:findNextSubStep())
		-- self:gotoAndPlayByID(item.next_substep_:get())
	else
		if model:getStepData(self.step) then
			self:getNextStep(function()
				if qy.IS_NEW then
					self:gotoAndPlay()
				end
			end)
		end
	end
	
end

function GuideManager:back()
	self:getBackStep()
	self:gotoAndPlay()
end

function GuideManager:getBackStep()
	local list = model.step_list
	if self.subStep > 1 then
		-- back
		self.subStep = self.subStep - 1
	else
		-- 大步骤结束
		if list[self.step].last_step > 0 then
			-- 上一个大步骤
			self.step = list[self.step].last_step
			self.subStep = #list[self.step].sub
		else
			-- 无上一个大步骤
			self.step = 0
			self.subStep = 0 
		end
		model:saveStep(self.step, self.subStep, self.id)
	end
	model:saveSubStep(self.subStep)
end

-- 注册需要引导的目标对象
function GuideManager:register(id, target, callback)
	-- 每次都要重新注册，因为如果弹窗出现过后再销毁，下次出现的弹窗不是同一个对象
	qy.Model.Guide:register(id, target, callback)
end

function GuideManager:show()
	local guideType = model:getCurrentType(self.id)
	print("guideType :" .. guideType .. "  " .. self.id)
	-- cc.Director:getInstance():pause()
	if guideType == 0 then
		-- 空白 
		self:showBlank()
		-- self:hideGuide()
		self:hideDialog()
		local item = model:getAtStep(self.step, self.subStep)
		local delay = item.delayTime_:get()
		if delay then
			performWithDelay(qy.App.runningScene, function()
	            self:next()
	        end, delay)
		end
	elseif guideType == 1 or guideType == 2 or guideType == 3 then
		--字幕
		-- self:hideGuide()
		self:hideBlank()
		self:showDialog()
	elseif guideType == 4 then
		--暂停教学 
		self:showGuide()
		self:hideDialog()
		self:hideBlank()
	elseif guideType == 5 then
		-- 与 0 功能类似，区别在于 0 属于强引导 5 属于弱引导
		self:hideBlank()
		self:hideGuide()
		self:hideDialog()
	elseif guideType == 6 then
		model:saveSubStep(self.subStep)
		self:next()
	elseif guideType == 101 then
		self:showBlank()
		self:hideGuide()
		self:hideDialog()
	elseif guideType == 102 then
		self:hideBlank()
		self:hideGuide()
		self:hideDialog()
		qy.Model.User:testNameIsEmpty()
		-- self:next()
	end
end

function GuideManager:hide()
	self:hideBlank()
	self.blank = nil
	self:hideDialog()
	self.dialog = nil
	self:hideGuide()
	self.guide = nil
end

function GuideManager:showBlank()
	if not self.blank then
		self.blank = qy.View.Guide.Blank.new(self)
		self.blank:setLocalZOrder(21)
		self.blank:addTo(qy.App.runningScene)
	end
	self.blank:setVisible(true)
end

function GuideManager:hideBlank()
	if self.blank then
		self.blank:setVisible(false)
	end
end

-- 显示引导层、背景、蒙版及其箭头
function GuideManager:showGuide()
	if not self.guide then
		self.guide = qy.View.Guide.Guide.new(self)
		self.guide:setLocalZOrder(30)
		self.guide:addTo(qy.App.runningScene)
	end
	self.guide:init(self)
	self.guide:setVisible(true)
end

function GuideManager:hideGuide()
	if self.guide then
		self.guide:setVisible(false)
	end
end

function GuideManager:showDialog()
	if not self.dialog then
		self.dialog = qy.View.Guide.Speak.new(self)
		self.dialog:setLocalZOrder(23)
		self.dialog:addTo(qy.App.runningScene)
	else
		self.dialog:setVisible(true)
	end
	local data = model:getAtStep(self.step, self.subStep)
	self.dialog:setData(data)
	
end

function GuideManager:hideDialog()
	if self.dialog then
		self.dialog:setVisible(false)
	end
end

-- 根据不同type判断当前应该暂停还是其他动作
function GuideManager:setState(view)	
	local guideType = model:getCurrentType(self.id)
	local director = cc.Director:getInstance()
	if guideType == 0 or guideType == 5 then
		-- 空白
		-- director:resume()
		-- 如果战斗是待机状态，需要唤醒
		if view then
			if view.battleData.pauseGame then
				view:tutorialResume()
			end

			if self.id == 117 then
	    		view:continueGame()		    		
	    	end
			if self.id == 134 then
				view:setBattleWin(true)
			end
		end
	elseif guideType == 1 or guideType == 2 or guideType == 3 then
		--字幕
		if view then
			view:tutorialPause()
		end
	elseif guideType == 4 then
		local item = model:getAtStep(self.step, self.subStep)
		if item.sound_:get() then
			qy.M.playEffect("sound/guide/" .. item.sound_:get() .. ".mp3")
		end
		--暂停教学
	elseif guideType == 101 then
		--释放龙王技能
		view:tutorialResume()
		view:startBossSkill()
	end
end

-- 延时
function GuideManager:delay(time)
	performWithDelay(self.container, function()
		self:next()
	end, time)
end

return GuideManager