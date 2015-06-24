
local TestVO = class("TestVO", app.D)

function TestVO:ctor()
	print("testVO:Ctor")
	self:setproperty({"id", 1, didSet= function(v)
		end})
end


local vo = TestVO.new()

return vo