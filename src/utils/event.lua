--[[
    说明: 事件工具类
]]

local Event = {}

Event.Dispatcher = cc.Director:getInstance():getEventDispatcher()

-- 增加一个事件监听
-- name: 事件名称
-- func: 事件回调
-- fixedPriority: 优化级, 默认为1
function Event.add(name, func, fixedPriority)
    local listener = cc.EventListenerCustom:create(name, func)
    Event.Dispatcher:addEventListenerWithFixedPriority(listener, fixedPriority or 1)
    return listener
end

-- 删除一个事件监听
function Event.remove(listener)
    if listener then
        Event.Dispatcher:removeEventListener(listener)
    end
end

-- 触发一个事件监听
function Event.dispatch(name, usedata)
    local event = cc.EventCustom:new(name)
    event._usedata = usedata
    event.data = usedata
    Event.Dispatcher:dispatchEvent(event)
end

return Event
