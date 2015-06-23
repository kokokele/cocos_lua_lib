local object = class("qy.object")

function object:ctor(name, value)
    
end

function object:get()
    return self.value
end

function object:set(value)
    self.value = value
end

return object