
local BaseScene = class("BaseScene", cc.Scene)

function BaseScene:ctor()
    -- self.controllerStack = qy.Widget.ViewStack.new()
    -- self.controllerStack:addTo(self)

    -- self.dialogStack = qy.Widget.ViewStack.new()
    -- self.dialogStack:setLocalZOrder(10)
    -- self.dialogStack:addTo(self)

    -- self.toast = qy.Widget.Toast.new()
    -- self.toast:setLocalZOrder(20)
    -- self.toast:addTo(self)

    -- self.tips = qy.Widget.Tips.new()
    -- self.tips:setLocalZOrder(20)
    -- self.tips:setVisible(false)
    -- self.tips:addTo(self)

    -- self.loading = qy.View.LoadService.new()
    -- self.loading:setLocalZOrder(10000)
    -- self.loading:setVisible(false)
    -- self.loading:addTo(self)

    -- self.NewContentOpen = qy.View.NewContentOpen.new()
    -- self.NewContentOpen:setLocalZOrder(30)
    -- self.NewContentOpen:addTo(self)

    -- self:registerScriptHandler(function(event)
    --     if event == "enter" then
    --         self:onEnter()
    --     elseif event == "exit" then
    --         self:onExit()
    --     end
    -- end)
end

function BaseScene:createBackground()
    local backgroundidx = 1
    local background = ccui.ImageView:create("Resources/common/background/all_1.jpg")
    background:setPosition(display.center)
    self:addChild(background, -1)

    -- 监听更新背景事件
    self.listener_c = qy.Event.add(qy.Event.CHANGE_BACKGROUND, function(event)
        local idx = tonumber(event._usedata)
        if idx and idx ~= backgroundidx then
            background:loadTexture("Resources/common/background/all_" .. idx .. ".jpg")
            display.removeImage("Resources/common/background/all_" .. backgroundidx .. ".jpg")
            backgroundidx = idx
        end
    end)
end

function BaseScene:push(controller)
    self.controllerStack:push(controller)
end

function BaseScene:pop()
    self.controllerStack:pop()
end

function BaseScene:replace(controller)
    self.controllerStack:replace(controller)
end

function BaseScene:popToRoot()
    self.controllerStack:popToRoot()
end

--[[
    显示一个弹窗, 有多种可能
    1. 显示第2个
]]
function BaseScene:showDialog(dialog)
    self.dialogStack:push(dialog, false)
end

function BaseScene:currentDialog()
    return self.dialogStack:currentView()
end

-- 关闭一个弹窗
function BaseScene:dismissDialog()
    self.dialogStack:pop()
end

function BaseScene:onEnter()
    qy.App.runningScene = self

    self.listener_a = qy.Event.add(qy.Event.SERVICE_LOADING, function(event)
        self.loading:setVisible(true)
    end)

    self.listener_b = qy.Event.add(qy.Event.SERVICE_LOADING_DONE, function(event)
        self.loading:setVisible(false)
    end)
end

function BaseScene:onExit()
    qy.Event.remove(self.listener_a)
    qy.Event.remove(self.listener_b)
end

function BaseScene:onCleanup()
    qy.Event.remove(self.listener_c)
end

return BaseScene