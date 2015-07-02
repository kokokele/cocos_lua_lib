--[[


]]

local BaseViewModel =  class("BaseViewModel")

function BaseViewModel:ctor (viewClass)
    self.V = viewClass.new()
    self.V:setVM(self)
    self:init()
end

function BaseViewModel:init()
end

-- 需要子类实现
function BaseViewModel:clickHandler(name)
    assert(false, "BaseViewModel:clickHandler需要子类实现")
end

-- 子类实现
function onExit ()

end

return BaseViewModel
