--[[


]]


local MainV = class("MainV", app.V)

function MainV:ctor()
    local pp = app.main.MainPP.new()
    self:add(pp)
end

return MainV
