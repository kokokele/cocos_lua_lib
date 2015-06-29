--[[
zp


]]

local Observer = class("Observer")


Observer._pool = {}

function Observer:addObserver(name, fun)

    assert(type(fun) == "function", "BaseEntity:addObserver(): 参数fun必须为function")
    -- assert(self[name .. "_"], "BaseEntity:addObserver(): name=" .. name .. "不存在!")

    if not self._pool[name] then
        self._pool[name] = {}
    end

    table.insert(self._pool[name], fun)

    return name .. "_" ..#self._pool[name]

end

function Observer:fire(name, ...)
     if self._pool[name] then
        for i, fun in ipairs(self._pool[name]) do
            if type(fun) == "function" then fun(...) end
        end
    end
end

function Observer:removeObserver(handler)
    local h = string.split(handler, "_")

    if h[1] and h[2]  and tonumber(h[2]) then
        if self._pool[h[1]]  then
            table.remove(self._pool[h[1]], tonumber(h[2]))
        end
    end
end

function Observer:clearObserver(name)
    if self[name .. "_"] then
        if self._pool[name] then self._pool[name] = {} end
    end
end

return Observer