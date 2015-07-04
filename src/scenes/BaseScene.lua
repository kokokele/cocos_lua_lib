
local BaseScene = class("BaseScene", cc.Scene)

function BaseScene:ctor()
    print("BaseScene:ctor")

    self._viewStack = app.core.ViewStack.new()
    self._viewStack:addTo(self)

    self._popupContainer = cc.Node:create()
    self._popupContainer:setLocalZOrder(10)
    self._popupContainer:addTo(self)

    self._loading = app.Loading.new()
    self._loading:setLocalZOrder(20)
    self._loading:addTo(self)

    self._toast = cc.Node:create()
    self._toast:setLocalZOrder(30)
    self._toast:addTo(self)


    self:registerScriptHandler(function(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
end

function BaseScene:getPopContainer()
    return self._popupContainer
end

function BaseScene:getToastContainer()
    return self._toast
end

function BaseScene:getLoading()
    return self._loading
end

function BaseScene:push(layer)
    self._viewStack:push(layer)
end

function BaseScene:pop()
    self._viewStack:pop()
end

function BaseScene:replace(layer)
    self._viewStack:replace(layer)
end

function BaseScene:popToRoot()
    self._viewStack:popToRoot()
end

function BaseScene:onEnter()
end

function BaseScene:onExit()
end

function BaseScene:onCleanup()
end

return BaseScene
