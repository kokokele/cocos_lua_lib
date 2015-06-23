--[[
    说明：主场景
]]

local MainScene = class("MainScene", qy.Scene.Base)

function MainScene:ctor()
    MainScene.super.ctor(self)

    self:createBackground()

    self.FloatingActionButton = qy.Widget.FloatingActionButton.new({
            -- 显示英雄
            ["onShowHero"] = function(view)
                self:push(qy.Controller.Hero.new())
            end,

            ["onShowBoss"] = function(view)
                self:push(qy.Controller.Pet.new())
            end,

            -- 显示背包
            ["onShowBackpack"] = function(view)
                self:push(qy.Controller.Backpack.new())
            end,

            -- 显示任务
            ["onShowTask"] = function(touchPos)
                qy.Event.dispatch(qy.Event.CONTROLLER_SHOW_TASK)
            end,

            -- 显示活动
            ["onShowActivity"] = function(view)
                self:push(qy.Controller.DailyActivity.new())
            end,

            -- 显示成就
            ["onShowAchievement"] = function(view)
                self:push(qy.Controller.Backpack.new())
            end,

            ["onBack"] = function()
                local currentController = self.controllerStack:currentView()
                
                -- 执行控制器的onBackClicked
                if currentController then
                    qy.M.playEffect("UI2.mp3")
                    currentController:onBackClicked()
                end

                -- 新手引导
                if qy.IS_NEW then
                    -- qy.Manager.Guide:next()
                end
            end,
            ["onBuySpirit"] = function(touchPos)
                qy.Dialog.BuySpirit.new():show(touchPos)
            end,
            ["onBuyMoney"] = function(touchPos)
                qy.Model.BuyMoney.list = {}
                qy.Dialog.BuyMoney.new():show(touchPos)
            end,
            ["onRecharge"] = function(touchPos)
                if qy.Model.User.recharge_enable_:get() then
                    qy.Dialog.Recharge.new():show(touchPos)
                else
                    qy.Widget.Toast.make("tid#note_44"):show()
                end
            end
        }
    )
    self.FloatingActionButton:addTo(self)

    -- 启动主控制器
    self:push(qy.Controller.Main.new())

    -- 公告
    -- qy.Service.Notice:list(function()
--        self:showDialog(qy.Dialog.Notice.new())
    -- end)
end

function MainScene:showActivityController()
    if qy.Model.Guide:testActivity() then
        qy.Service.Trial:getInfo(function()
            self:push(qy.Controller.Trial.new())
        end)
    else
        local noOpenDialog = qy.Dialog.NoOpen.new()
        noOpenDialog:show()
        noOpenDialog:render(1)
    end
end

function MainScene:showPveController()
    self:push(qy.Controller.Pve.new())
end

function MainScene:showAltarController()
    if qy.Model.Guide:testAltar() then
        qy.Service.Altar:requestInfo(function()
            self:push(qy.Controller.Altar.new())
        end)
    else
        local noOpenDialog = qy.Dialog.NoOpen.new()
        noOpenDialog:show()
        noOpenDialog:render(4)
    end
end

function MainScene:showKillingController()
    if qy.Model.Guide:testKillzone() then
        qy.Service.Killing:requestInfo(function()
            self:push(qy.Controller.Killing.new())
        end)
    else
        local noOpenDialog = qy.Dialog.NoOpen.new()
        noOpenDialog:show()
        noOpenDialog:render(3)
    end
end

function MainScene:showArenaController()
    if qy.Model.Guide:testArena() then
        self:push(qy.Controller.Pvp.new())
    else
        local noOpenDialog = qy.Dialog.NoOpen.new()
        noOpenDialog:show()
        noOpenDialog:render(2)
    end
end

function MainScene:push(controller)
    local cName = controller.__cname
    
    -- 如果当前只有1个Controller, 使用push的方式
    local currentController = self.controllerStack:currentView()
    if self.controllerStack:size() == 1 or (currentController and currentController.__cname == "PveController") then
        MainScene.super.push(self, controller)
    else
        MainScene.super.replace(self, controller)
    end
    
    -- 处理菜单
    self.FloatingActionButton:setCurrentController(cName)
end

function MainScene:pop()
    MainScene.super.pop(self)

    -- 可能被执行了finish
    local currentController = self.controllerStack:currentView()
    
    -- 重置设置当前的Controller 
    self.FloatingActionButton:setCurrentController(currentController.__cname)
end

function MainScene:popToRoot()
    MainScene.super.popToRoot(self)
    -- 可能被执行了finish
    local currentController = self.controllerStack:currentView()
    
    -- 重置设置当前的Controller 
    self.FloatingActionButton:setCurrentController(currentController.__cname)
end

function MainScene:onEnter()
    MainScene.super.onEnter(self)

    self.listener_1 = qy.Event.add(qy.Event.CONTROLLER_SHOW_ACTIVITY, function()
        self:showActivityController()
    end)
    self.listener_2 = qy.Event.add(qy.Event.CONTROLLER_SHOW_PVE, function()
        self:showPveController()
    end)
    self.listener_3 = qy.Event.add(qy.Event.CONTROLLER_SHOW_ALTAR, function()
        self:showAltarController()
    end)
    self.listener_4 = qy.Event.add(qy.Event.CONTROLLER_SHOW_KILLING, function()
        self:showKillingController()
    end)
    self.listener_5 = qy.Event.add(qy.Event.CONTROLLER_SHOW_ARENA, function()
        self:showArenaController()
    end)

    self.listener_6 = qy.Event.add(qy.Event.OPEN_NEW_CONTENT, function(event)
        local enablePlay = false
        if qy.Model.NewContentOpen:testAltar() then
            self.NewContentOpen:setImg(1)
            enablePlay = true
        elseif qy.Model.NewContentOpen:testArena() then
            self.NewContentOpen:setImg(2)
            enablePlay = true
        elseif qy.Model.NewContentOpen:testKillzone() then
            self.NewContentOpen:setImg(3)
            enablePlay = true
        elseif qy.Model.NewContentOpen:testActivity() then
            self.NewContentOpen:setImg(4)
            enablePlay = true
        elseif qy.Model.NewContentOpen:testTask() then
            self.NewContentOpen:setImg(5)
            enablePlay = true
        elseif qy.Model.NewContentOpen:testShop() then
            self.NewContentOpen:setImg(6)
            enablePlay = true
        elseif qy.Model.NewContentOpen:testElite() then
            self.NewContentOpen:setImg(7)
            enablePlay = true
        elseif qy.Model.NewContentOpen.shop_2 then
            self.NewContentOpen:setImg(8)
            enablePlay = true
        elseif qy.Model.NewContentOpen.shop_3 then
            self.NewContentOpen:setImg(9)
            enablePlay = true
        end

        if enablePlay then
            self.NewContentOpen:play()
        end
    end)

    self.listener_7 = qy.Event.add(qy.Event.CONTROLLER_SHOW_SHOP, function(event)
        local idx = event._usedata
        qy.Service.Shop:getShopList(function(t)
            self:push(qy.Controller.Shop.new(idx))
        end)
    end)

    self.listener_8 = qy.Event.add(qy.Event.CONTROLLER_SHOW_ELITE, function()
        self.dialogStack:clean()
        self:popToRoot()
        local pveController = qy.Controller.Pve.new()
        pveController:showChapter("7", "1", "1")
        self:push(pveController)
    end)

    self.listener_9 = qy.Event.add(qy.Event.CONTROLLER_SHOW_TASK, function()
        if qy.Model.Task:testOpen() then
            qy.Service.Task:getTaskList(function()
                qy.Dialog.Task.new():show()
            end)
        else
            qy.Widget.Toast.make(qy.I18N.getString("tid#note_44")):show()
        end
    end)

    self.listener_10 = qy.Event.add(qy.Model.Name.Event.IsEmpty, function()
        qy.Dialog.Name.new(qy.Model.User.info.name_:get()):show()
    end)

    qy.Event.dispatch(qy.Event.TIPS_SHOW)
    if not qy.IS_NEW then
        qy.Event.dispatch(qy.Event.OPEN_NEW_CONTENT)   -- 主要是从关卡回来
    end
    qy.Event.dispatch(qy.Event.USER_SPIRIT_CHANGED)  -- 战斗回来
    qy.Event.dispatch(qy.Event.USER_MONEY_CHANGED)  -- 战斗回来
    -- 
-- self.NewContentOpen:play()
    qy.Model.Guide:checkIsNewBie()
    
    if qy.IS_NEW then
        qy.Manager.Guide:registerContainer(self)
    end

    if (not qy.IS_NEW and not qy.Model.Notice.isShowed) and cc.Application:getInstance():getTargetPlatform() ~= 2 then
        qy.M.playEffect("UI2.mp3")
        qy.Dialog.Notice.new():show()
        
        qy.Model.Notice.isShowed = true
    end
end

function MainScene:onExit()
    MainScene.super.onExit(self)

    qy.Event.remove(self.listener_1)
    qy.Event.remove(self.listener_2)
    qy.Event.remove(self.listener_3)
    qy.Event.remove(self.listener_4)
    qy.Event.remove(self.listener_5)
    qy.Event.remove(self.listener_6)
    qy.Event.remove(self.listener_7)
    qy.Event.remove(self.listener_8)
    qy.Event.remove(self.listener_9)
    qy.Event.remove(self.listener_10)
end

return MainScene