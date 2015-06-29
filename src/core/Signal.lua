--
-- Author: zp
-- Date: 2015-06-29 16:38:40
--


local Singal = class("Singal")


Singal._pool = {}

function Singal:add(fun)

    assert(type(fun) == "function", "BaseEntity:addObserver(): 参数fun必须为function")

    table.insert(self._pool, {["fun"] = fun, ["once"] = 0})
end

-- 只执行一次x
function Singal:addOnce(fun)

	assert(type(fun) == "function", "BaseEntity:addObserver(): 参数fun必须为function")
	table.insert(self._pool, {["fun"] = fun, ["once"] = 1})
end

function Singal:fire(...)
     if #self._pool  > 0 then
        for i, obj in ipairs(self._pool) do
            obj.fun(...)
            if obj.once == 1 then
              table.remove(self._pool, i)
            end
        end
    end
end

function Singal:remove(handler)

    for i,v in ipairs(self._pool) do
      if v == handler then
        table.remove(self._pool, i)
        break
      end
    end
end



function Singal:clearAll(name)
  self._pool = {}
end

return Singal
