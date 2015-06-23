local ArmatureManager = class("ArmatureManager")

local allArmature = {}
-- setmetatable(allArmature, {__mode = 'v'})
function ArmatureManager.addArmature(arm)
	-- body
	local isadd = true

	if next(allArmature) == nil then
		table.insert(allArmature, arm)
	else
		for k,v in pairs(allArmature) do
			if  v == arm then
				isadd = false
				break;
			end
		end
		if isadd then
			table.insert(allArmature, arm)
		end
	end
	
end

function ArmatureManager.removeArmature(arm)
	-- body
	local t = {}

	for k,v in pairs(allArmature) do
		if v == arm then
			table.insert(t, k)
		end
	end
	-- if #t > 1 then
	-- 	print("==========================================================================================================================  多个相同")
	-- end
	for k,v in pairs(t) do
		table.remove(allArmature, v)
	end
	-- print("matureManager.removeArmature(ar", #allArmature)
end

function ArmatureManager.removeAllArmature()
	-- body
	allArmature = {}

end

function ArmatureManager.pause()
 	-- body
 	-- print("ArmatureManager.resume()ArmatureManager.resume()ArmatureManager.resume()========================", #allArmature)
 	-- collectgarbage()
 	-- print("ArmatureManager.resume()ArmatureManager.resume()ArmatureManager.resume()========================", #allArmature)
 	for k,v in pairs(allArmature) do
 		-- print(k,v)
 		-- print(" ArmatureManager.pause() ArmatureManager.pause()======", k)
 		-- if v== nil then
 		-- 	print("==========================================================================================================================  有空")
 		-- end

 		v:pause()
 		v:setColor(cc.c3b(80,80,80))
 	end
 end

 function ArmatureManager.resume()
 	-- body

 	-- print("ArmatureManager.resume()ArmatureManager.resume()ArmatureManager.resume()========================", #allArmature)
 	-- collectgarbage()
 	-- print("ArmatureManager.resume()ArmatureManager.resume()ArmatureManager.resume()========================", #allArmature)
 	for k,v in pairs(allArmature) do
 		-- print(k,v)
 		-- print(" ArmatureManager.resume()ArmatureManager.resume()======", k)
 		-- if v== nil then
 		-- 	print("==========================================================================================================================  有空")
 		-- end
 		v:resume()
 		v:setColor(cc.c3b(255,255,255))
 	end
end

function ArmatureManager.removeAtEnd(armature, callfunc)
	local function animationEvent(armatureBack,movementType,movementID)
        if movementType == ccs.MovementEventType.complete then
            armatureBack:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(callfunc)))
        end
    end

    armature:getAnimation():setMovementEventCallFunc(animationEvent)
end
    
return ArmatureManager


