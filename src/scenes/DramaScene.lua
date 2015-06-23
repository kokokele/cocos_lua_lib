--[[
	新手剧情
]]

local DramaScene = class("DramaScene", qy.Scene.Base)

function DramaScene:ctor()
    DramaScene.super.ctor(self)

    self:push(qy.Controller.Drama.new())
end

return DramaScene