--[[


]]

local BaseViewModel =  class("BaseViewModel")

function BaseViewModel:ctor ()
end

function BaseViewModel:initView (viewClass)
    self.V = viewClass.new()
    self.V:setVM(self)
end

function BaseViewModel:init()
end

-- 需要子类实现
function BaseViewModel:eventHandler(name)
    assert(false, "BaseViewModel:eventHandler需要子类实现")
end

-- 子类实现
function onExit ()

end

return BaseViewModel
