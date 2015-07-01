--[[


]]

local BaseViewModel =  class("BaseViewModel")

function BaseViewModel:ctor (view)
    self.V = view
end

function BaseViewModel:init()
end

-- 需要子类实现
function BaseViewModel:clickHandler(sender, clickPos)
    assert(false, "BaseViewModel:clickHandler需要子类实现")
end

return BaseViewModel
