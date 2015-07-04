--[[

]]

local BaseView = class("BaseView", cc.Node)

function BaseView:ctor()
    --NodeEx.lua
    -- print("BaseView.ctor()")
    self:enableNodeEvents()
end

function BaseView:setVM(viewModel)
    self.VM = viewModel
    self:init()
    return self
end

-- 子类实现
function BaseView:init()
end


function BaseView:show()
    display:getRunningScene():push(self)
    return self
end


function BaseView:addCSB(csbFile, parent)
    --local result =  require("csd." .. csbFile).create()
    --local timeline = result["animation"]

    local name = require "csd.MainLayer"

    local node = type(csbFile) == "string" and require("csd." .. csbFile).create()["root"] or cc.Node:create()

    -- node:runAction(timeline)
    --timeline:gotoFrameAndPlay(0, true)
    if node.setBackGroundColorOpacity then
        node:setBackGroundColorOpacity(0)
    end
    local originSize = node:getContentSize()
    if (originSize.width == 960 and originSize.height == 640) or (originSize.width == 0 and originSize.height == 0) then
        node:setContentSize(cc.Director:getInstance():getVisibleSize())
        ccui.Helper:doLayout(node)
    end

    node:setCascadeColorEnabled(true)
    node:setCascadeOpacityEnabled(true)

    if parent then parent:add(node)
    else self:add(node) end

    return node
end


-- 继承
function BaseView.extend(name, csbFile)
    local InheritView = class(name, BaseView)
    if csbFile then
        -- 重写__create函数, 引入皮肤
        InheritView.__create = function()
            return InheritView.super.__create(csbFile)
        end
    end
    return InheritView
end

-- 查找子节点 支持递归搜索
-- namd:        子节点名称
-- recursive:   是否使用递归查找, 默认是
function BaseView:findViewByName(name, recursive)
    local child = nil

    if recursive or recursive == nil then
        self:enumerateChildren("//" .. name, function(ret)
            child = ret
        end)
    else
        child = self:getChildByName(name)
    end

    return child
end

function BaseView:findViewByTag(tag)
    return self:getChildByTag(tag)
end

function BaseView:addView(view)
    self:addChild(view)
end

function BaseView:addTo(parent, localZOrder)
    if localZOrder then
        self:setLocalZOrder(localZOrder)
    end
    parent:addChild(self)
end

-- 注入一个视图, bindName如果不为空则
-- 创建 self.View.bindName = view
-- 否则 self.View.name = view
-- namd:        需要绑定的节点名称
-- bindName:    绑定给表的元素名称
-- 引入self.View是防止与其它变量冲突
function BaseView:InjectView(name, bindName)
    -- self.View = self.View or {}

    -- if not self.View[bindName or name] then
    --     self.View[bindName or name] = self:findViewByName(name, true)
    -- end

    if not self[bindName or name] then
        self[bindName or name] = self:findViewByName(name, true)
    end
end

--[[
    注入一个自定义视图, 只支持一级继承

    name
    CustomView
    ... 调用ctor构造函数的参数列表

    usage:
        self:InjectCustomView("Icon", qy.Widget.Icon, {
            ["onClick"] = function(icon)
                print("____" .. icon:getTag())
            end
        })
]]
function BaseView:InjectCustomView(name, CustomView, ...)
    local node = self:findViewByName(name, true)
    if node then
        -- 拷贝子类的方法
        -- for k,v in pairs(CustomView) do node[k] = v end
        setmetatableindex(node, CustomView)
        -- 调用构造函数
        node:ctor(...)
        -- 绑定
        self[name] = node
    end
end

function BaseView:click(name)
    self:OnClick(name, function()
        self.VM:eventHandler(name)
    end)
end

-- 给一个view注入一个点击的事件
function BaseView:OnClick(name, endedFunc, eventFunc)
    assert(endedFunc, "endedFunc 不能为空")
    assert(name, "name 不能为空")

    local view = type(name) ~= "string" and name or self[name] or self:findViewByName(name, true)
    if view then
        if view.setZoomScale and view.setPressedActionEnabled then
            view:setZoomScale(0.05)
            view:setPressedActionEnabled(true)
        end
        view:setTouchEnabled(true)
        view:addTouchEventListener(function(sender, eventType)
            if eventFunc then
                eventFunc(sender, eventType)
            end

            if eventType == ccui.TouchEventType.ended then
                endedFunc(sender, view:getWorldPosition())
            end
        end)
    end
end


function BaseView:onEnter()

end

function BaseView:onExit()
    if self.VM then self.VM:onExit() end
end

return BaseView
