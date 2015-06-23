--[[
    说明: 菜单
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-11-14
]]

local FloatingActionButton = qy.View.Base.extend("FloatingActionButton", "widget/FloatingActionButton")

function FloatingActionButton:ctor(delegate)
    FloatingActionButton.super.ctor(self)

    -- 注入视图
    self:InjectView("MenuPanel")        -- 下拉菜单面板
    self:InjectView("Node_money")
    self:InjectView("Node_gem")
    self:InjectView("Node_spirit")
    self:InjectView("Btn_back")
    self:InjectView("Btn_action")
    self:InjectView("Btn_backpack")
    self:InjectView("Btn_hero")
    self:InjectView("Btn_boss")
    self:InjectView("Background")       -- 半透明背景

    self:InjectView("Toast_spirit")
    self:InjectView("Text_title")
    self:InjectView("MenuBackground")
    self:InjectView("Btn_ranking")

    self:InjectView("UI_tips")
    self:InjectView("UI_herotips")
    self:InjectView("UI_tasktips")
    self:InjectView("UI_moneyicon")
    self:InjectView("UI_gemicon")
    self:InjectView("UI_spiriticon")
    self:InjectView("Particle_1")
    self:InjectView("Particle_2")
    self:InjectView("Particle_3")
    self:InjectView("Particle_4")

    self.Text_title:setLineHeight(24)
    self.Toast_spirit:setVisible(false)

    -- 绑定动作 
    self:OnClick(self.Btn_back, delegate.onBack)

    -- 私有动作
    self:OnClick("Btn_action", function()
        self:swapMenuPanelStatus()
    end)

    self:OnClick("Btn_money", function(sender, touchPos)
        qy.M.playEffect("UI2.mp3")
        if delegate and delegate.onBuyMoney then
            delegate.onBuyMoney(touchPos)
        end
    end, function(view, eventType)
        if eventType == ccui.TouchEventType.began then
            qy.Effects:nodeTouchBegan(self.Node_money)
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            qy.Effects:nodeTouchEnd(self.Node_money)
        end
    end)

    self:OnClick("Btn_ranking", function(touchPoint)
        qy.Dialog.Ranking.Main.new():show()
    end)

    self:OnClick("Btn_gem", function(sender, touchPos)
        qy.M.playEffect("UI2.mp3")
        if delegate and delegate.onRecharge then
            delegate.onRecharge(touchPos)
        end
    end, function(view, eventType)
        if eventType == ccui.TouchEventType.began then
            qy.Effects:nodeTouchBegan(self.Node_gem)
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            qy.Effects:nodeTouchEnd(self.Node_gem)
        end
    end)

    self:OnClick("Node_spirit", function()
    end, function(view, eventType)
        if eventType == ccui.TouchEventType.began then
            self.Toast_spirit:setVisible(true)
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self.Toast_spirit:setVisible(false)
        end
    end)

    -- 透明背景点击动作
    self:OnClick(self.Background, function()
        self:swapMenuPanelStatus()
    end)
    
    -- 显示背包
    self:OnClick(self.Btn_backpack, function(sender)
        if delegate and delegate.onShowBackpack then
            qy.M.playEffect("UI2.mp3")
            delegate.onShowBackpack(self)
        end
    end)

    -- 显示英雄
    self:OnClick(self.Btn_hero, function(sender)
        if delegate and delegate.onShowHero then
            qy.M.playEffect("UI2.mp3")
            delegate.onShowHero(self)
        end
    end)

    -- 显示召唤兽
    self:OnClick(self.Btn_boss, function(sender)
        if delegate and delegate.onShowHero then
            qy.M.playEffect("UI2.mp3")
            delegate.onShowBoss(self)
        end
    end)

    -- 显示任务
    self:InjectView("b_rw")
    self:OnClick(self.b_rw, function(sender, touchPos)
        if delegate and delegate.onShowTask then
            qy.M.playEffect("UI2.mp3")
            delegate.onShowTask(touchPos)
        end
    end)

    -- 购买体力
    self:OnClick("Btn_buySpirit", function(sender, touchPos)
        qy.M.playEffect("UI2.mp3")
        if delegate and delegate.onBuySpirit then
            delegate.onBuySpirit(touchPos)
        end
    end)

    -- 按钮对应的控制器名称
    self._controllerNames = {
        ["HeroController"] = self.Btn_hero,
        ["BackpackController"] = self.Btn_backpack,
        ["BossController"] = self.Btn_boss
    }

    -- 渲染UI
    self.Text_spirit = ccui.TextAtlas:create()
    self.Text_spirit:setProperty("0", "Resources/common/number/num1.png", 13, 21, "0")
    self.Text_spirit:setAnchorPoint(cc.p(0.5, 0.5))
    self.Text_spirit:setPosition(-45, 11)
    self.UI_spiriticon:addChild(self.Text_spirit)

    self.Text_spiritMax = ccui.TextAtlas:create()
    self.Text_spiritMax:setProperty("0", "Resources/common/number/num1.png", 13, 21, "0")
    self.Text_spiritMax:setAnchorPoint(cc.p(0, 0))
    self.Text_spiritMax:setPosition(15, 0)
    self.UI_spiriticon:addChild(self.Text_spiritMax)

    self.Text_money = ccui.TextAtlas:create()
    self.Text_money:setProperty("0", "Resources/common/number/num1.png", 13, 21, "0")
    self.Text_money:setAnchorPoint(cc.p(0.5, 0.5))
    self.Text_money:setPosition(60, 24)
    self.UI_moneyicon:addChild(self.Text_money)

    self.Text_gem = ccui.TextAtlas:create()
    self.Text_gem:setProperty("0", "Resources/common/number/num1.png", 13, 21, "0")
    self.Text_gem:setAnchorPoint(cc.p(0.5, 0.5))
    self.Text_gem:setPosition(60, 24)
    self.UI_gemicon:addChild(self.Text_gem)

    self.delegate = delegate

    self:setUserSpirit()
    self:setUserMoney()
    self:setUserGem()
    self:showParticle()

    self.MenuPanel_x = self.MenuPanel:getPositionX()
    self.MenuPanel_y = self.MenuPanel:getPositionY()
end

-- 粒子效果
function FloatingActionButton:showParticle()
    self.Particle_1:stopSystem()
    self.Particle_2:stopSystem()
    self.Particle_3:stopSystem()
    self.Particle_4:stopSystem()

    local delay = 2.5
    self:runAction(cc.RepeatForever:create(cc.Sequence:create(
        cc.CallFunc:create(function()
            self.Particle_1:resetSystem()
        end), 
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function()
            self.Particle_1:stopSystem()
            self.Particle_2:resetSystem()
        end), 
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function()
            self.Particle_2:stopSystem()
            self.Particle_3:resetSystem()
        end), 
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function()
            self.Particle_3:stopSystem()
            self.Particle_4:resetSystem()
        end), 
        cc.DelayTime:create(delay),
        cc.CallFunc:create(function()
            self.Particle_4:stopSystem()
        end), 
        cc.DelayTime:create(1)
    )))
end

-- 设置体力
function FloatingActionButton:setUserSpirit()
    self.Text_spiritMax:setString(qy.Model.User.info.maxSpirit_:get())

    local isRed = qy.Model.User.Spirit.spirit_:get() > qy.Model.User.info.maxSpirit_:get()
    self.Text_spirit:setColor(isRed and cc.c3b(98, 246, 0) or cc.c3b(255, 255, 255))
    self.Text_spirit:setStringWithAnim(qy.Model.User.Spirit.spirit_:get())
end

-- 设置金币
function FloatingActionButton:setUserMoney()
    qy.M.playEffect("UI11.mp3")
    self.Text_money:setStringWithAnim(qy.Model.User.info.money_:get())
end

-- 设置钻石
function FloatingActionButton:setUserGem()
    self.Text_gem:setStringWithAnim(qy.Model.User.info.gem_:get())
end

--[[
设置当前显示的Controller
    如果当前显示的是MainController则
        1. 不显示返回按钮
        2. 判断下拉菜单状态
]]
function FloatingActionButton:setCurrentController(cName)
    self._controllerName = cName
    
    -- 返回按钮状态 
    self.Btn_back:setVisible(cName ~= "MainController")
   
    -- 强制下拉菜单为关闭状态
    if qy.IS_NEW and (qy.Manager.Guide.step == 6 or qy.Manager.Guide.step == 10) then
        self:swapMenuPanelStatus(false)
    else
        self:swapMenuPanelStatus(cName == "MainController" and self._status or false)
    end
    
    -- 按钮状态
    for key, var in pairs(self._controllerNames) do
        var:setEnabled(key ~= cName)
        var:setBright(key ~= cName)
    end

    self:setTopVisible(cName ~= "PetController" and cName ~= "AltarController")
end

function FloatingActionButton:setTopVisible(visible)
    self.Btn_action:setVisible(visible)
    self.Node_money:setVisible(visible)
    self.Node_gem:setVisible(visible)
    self.Node_spirit:setVisible(visible)
end

-- 交换下拉菜单状态: 显示或隐藏
function FloatingActionButton:swapMenuPanelStatus(status)
    qy.M.playEffect("UI6.mp3")
    self.MenuPanel:setVisible(status == nil and not self.MenuPanel:isVisible() or status)

    -- self.MenuBackground:runAction(cc.ScaleTo:create(0.1, 1, self.MenuPanel:isVisible() and 1 or 0.01))
    
    -- 如果不是在MainController下, 需要显示半透明背景 
    self.Background:setVisible(self._controllerName ~= "MainController" and self.MenuPanel:isVisible())


    local flag = self.MenuPanel:isVisible()
    local func1 = cc.MoveTo:create(0.2, cc.p(self.MenuPanel_x, self.MenuPanel_y - 100))
    local func2 = cc.MoveTo:create(0.05, cc.p(self.MenuPanel_x, self.MenuPanel_y))
    local func3 = cc.MoveTo:create(0.1, cc.p(self.MenuPanel_x, self.MenuPanel_y + 700))
    -- local func4 = cc.MoveTo:create(0.05, cc.p(MenuPanel_x, MenuPanel_y))

    local func4 = flag and cc.Sequence:create(func1, func2) or func3
    self.MenuPanel:runAction(func4)
   
    -- 对MainController里下拉菜单的状态记录
    if self._controllerName == "MainController" then
        self._status = self.MenuPanel:isVisible()
    end

    -- 按钮状态
    local isShow = self.MenuPanel:isVisible()
    self.Btn_action:loadTextureNormal("Resources/common/menu/btn_dropdown" .. (isShow and 3 or 1) .. ".png", ccui.TextureResType.plistType)
    self.Btn_action:loadTexturePressed("Resources/common/menu/btn_dropdown" .. (isShow and 4 or 2) .. ".png", ccui.TextureResType.plistType)
end

-- 新手引导相关
function FloatingActionButton:guide(delegate)
    local manager = qy.Manager.Guide
    local model = qy.Model.Guide

    local item = qy.Model.Guide:getAtStep(model:getStep(), model:getSubStep())
    local steps2 = qy.Helper.static.guideGuanka
    for i, v in pairs(steps2) do
        local step = v.hero_map
        if step and step["floatingBack"] then
            manager:register(step["floatingBack"], self.Btn_back, function()
                -- delegate.onBack()
                qy.App.runningScene:popToRoot()
                self:swapMenuPanelStatus(false)
            end)
        end
        if step and step["floatAction"] then
            manager:register(step["floatAction"], self.Btn_action, function()
                self:swapMenuPanelStatus()
            end)
        end
        if step and step["floatHero"] then
            manager:register(step["floatHero"], self.Btn_hero, function()
                delegate.onShowHero(self)
            end)
        end
        if step and step["floatTask"] then
            manager:register(step["floatTask"], self.b_rw, function()
                qy.M.playEffect("UI2.mp3")
                delegate.onShowTask(self.b_rw:getWorldPosition())
            end)
        end
    end
end

function FloatingActionButton:onEnter()
    self:guide(self.delegate)

    self:addEvent(qy.Event.USER_SPIRIT_CHANGED, function(event)
        self:setUserSpirit()
    end)

    self:addEvent(qy.Event.USER_MONEY_CHANGED, function(event)
        self:setUserMoney()
    end)

    self:addEvent(qy.Event.USER_GEM_CHANGED, function(event)
        self:setUserGem()
    end)

    self:addEvent(qy.Event.USER_LEVEL_CHANGED, function(event)
        if qy.Model.User.info.level_:get() > 1 then
            qy.M.playEffect("UI2.mp3")
            qy.Dialog.UserUpgrade.new():show()
        end
    end)

    -- 小红点事件
    self:addEvent(qy.Event.TIPS_SHOW, function(event)
        self.UI_tips:setVisible(qy.Model.Tips.is_show_:get())
        self.UI_herotips:setVisible(qy.Model.Tips.is_show_hero_:get())
        self.UI_tasktips:setVisible(qy.Model.Tips.is_show_task_:get())
    end)

    -- 体力恢复时间
    qy.Timer.create("toast_spirit", function()
        local spirit = qy.Model.User.Spirit.spirit_:get()
        local max_spirit = qy.Model.User.info.maxSpirit_:get()
        local last_recover_time = qy.Model.User.Spirit.time_:get()
        local recover_time = qy.Helper.static.setting.spirit_point_recover_time
        local os_time = os.time()
        local currentTime = os.date("%X", os_time)
        local buyTime = (qy.Model.User.daily.buy_spirit_point_cnt or 0) .. "/" .. qy.Model.User.Vip.spiritbuycountmax_:get()
        local nextRecoverTime = os.date("!%X", last_recover_time + recover_time - os_time)
        local recoverAllTime = os.date("!%X", last_recover_time + recover_time * (max_spirit - spirit) - os.time())
        local recoverTime = os.date("!%X", recover_time)
        if spirit < max_spirit then
            self.Text_title:setString(string.format("当前时间：%s\n已买体力次数：%s\n下次体力恢复：%s\n恢复全部体力：%s\n恢复时间间隔：%s",
                currentTime,
                buyTime,
                nextRecoverTime,
                recoverAllTime,
                recoverTime
            ))
            self.Text_title:setPositionY(135)
            self.Toast_spirit:setContentSize(cc.size(250, 150))
        else
            self.Text_title:setString(string.format("当前时间：%s\n已买体力次数：%s\n体力已回满",
                currentTime,
                buyTime
            ))
            self.Text_title:setPositionY(87)
            self.Toast_spirit:setContentSize(cc.size(250, 102))
        end
    end, 1)
end

function FloatingActionButton:onExit()
    qy.Timer.remove("toast_spirit")
    self:removeAllEvents()
end

return FloatingActionButton