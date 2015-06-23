--[[
    说明: 模型基类
]]

local BaseModel = class("BaseModel", qy.Entity.Base)

function BaseModel:dispatchEvent(name, usedata)
    qy.Event.dispatch(name, usedata)
end

function BaseModel:setarray(name)
    self:setproperty({name, {}})
end

function BaseModel:setmap(name)
    self:setproperty({name, {},
        get = function(map, key)
            return key and map.value[tostring(key)] or map.value
        end,
        set = function(map, key, value)
            map.value[tostring(key)] = value
        end
    })
end

return BaseModel