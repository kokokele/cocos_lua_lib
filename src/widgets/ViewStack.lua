--[[
    说明: 视图栈, 用于先入后出的方式管理视图
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-11-11
]]

local ViewStack = class("ViewStack", qy.View.Base)

function ViewStack:ctor()
    ViewStack.super.ctor(self)

    self._views = {}
end

-- 压入一个视图, 原来正在显示的视图将被暂时移除
function ViewStack:push(view, cleanup)
    if view then
        self:removeAllChildren(cleanup == nil and true or cleanup)
    
        view:retain()
        table.insert(self._views, view)
        self:addChild(view)
    end
end

-- 弹窗一个视图, 之前被临时移除的视图会重新被显示
function ViewStack:pop()
    local view = table.remove(self._views)
    if view then
        view:release()
        self:removeChild(view)

        view = self:currentView()
        if view then
            self:addChild(view)
        end
    end
end

-- 替换当前视图为view, 被替换的视图将被永久删除
function ViewStack:replace(view)
    if view then
        -- 删除当前视图
        local oldview = table.remove(self._views)
        if oldview then
            oldview:release()
            self:removeChild(oldview)
        end
        -- 替换成新的视图
        view:retain()
        table.insert(self._views, view)
        self:addChild(view)
    end
end

-- 弹出所有视图, 除了第一个
function ViewStack:popToRoot()
    local view = self._views[1]
    self:removeAllChildren()
    self:push(view)
    self._views = {}
    table.insert(self._views, view)
end

function ViewStack:clean()
    self:removeAllChildren()
    self._views = {}
end

-- 获取当前正在显示的视图
function ViewStack:currentView()
    return self._views[#self._views]
end

function ViewStack:size()
    return #self._views
end

return ViewStack