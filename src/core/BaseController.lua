--[[


]]

local BaseController = class("BaseController", qy.View)

function BaseController:ctor()
    BaseController.super.ctor(self)
end

function BaseController:start()
    app.runningScene():push(self)
end

function BaseController:finish()
    app.runningScene():pop()
end

function BaseController:addEvent(name, listener)
    self._events = self._events or {}
    self._events[name] = app.Event.add(name, listener)
end

function BaseController:removeEvent(name)
    app.Event.remove(self._events[name])
    self._events[name] = nil
end

function BaseController:removeAllEvents()
    if self._events then
        for name, _ in pairs(self._events) do
            self:removeEvent(name)
        end
    end
end


return BaseController