--[[

]]

local ViewCenter = class("ViewCenter")



function ViewCenter:ctor()
    self.pool = {}
    self.views = require("ViewCenterConfig")
end

function ViewCenter:appear(key)

    local obj =  self.pool[key]

    if obj == nil then
        local views = self.views[key]
        local viewClass = nil
        local viewModelClass = nil

        if #views == 2 then
            viewClass = app[views[1]][views[2]]
            viewModelClass = app[views[1]][views[2] .. "M"]

        elseif #views == 3 then
            viewClass = app[views[1]][views[2]][views[3]]
            viewModelClass = app[views[1]][views[2]][views[3] .. "M"]

        elseif #views == 4 then
            viewClass = app[views[1]][views[2]][views[3]][views[4]]
            viewModelClass = app[views[1]][views[2]][views[3]][views[4] .. "M"]
        end

        vm = viewModelClass.new()
        obj = {["vm"] = vm, ["viewClass"] = viewClass}
        self.pool[key] = obj
    end

    obj.vm:initView(obj.viewClass)
    obj.vm:init()


    -- viewClass.new():initVM(viewModelClass)

end

return ViewCenter.new()
