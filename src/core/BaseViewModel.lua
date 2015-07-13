--[[


]]

local BaseViewModel =  class("BaseViewModel")

function BaseViewModel:ctor ()
end

function BaseViewModel:initView (viewClass)

    self.viewClass = viewClass
end

function BaseViewModel:showView ()

    self.V = self.viewClass.new()
    self.V:setVM(self)

    self.V:show()

end

function BaseViewModel:hideView ()
    if self.V then self.V:dismiss() end
end

function BaseViewModel:init()
end

-- 需要子类实现
function BaseViewModel:eventHandler(name)
    assert(false, "BaseViewModel:eventHandler需要子类实现")
end


function BaseViewModel:_onExit ()
    -- self.V:release()
    self:onExit()
end

-- 子类实现
function BaseViewModel:onExit ()

end

return BaseViewModel
