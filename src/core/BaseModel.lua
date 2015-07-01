--[[
    说明: 模型基类
]]

local BaseModel = class("BaseModel", app.D)

function BaseModel:dispatchEvent(name, usedata)
    qy.Event.dispatch(name, usedata)
end


return BaseModel
