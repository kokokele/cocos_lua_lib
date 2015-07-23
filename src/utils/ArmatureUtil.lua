--[[

动画管理类
zp
2015-7-23
]]

--------------------------------------------------
local ArmatureFileCache = {}

local allArmature = {}


local ArmatureUtil  = class("ArmatureUtil")

--[[
使用说明:

local q = qy.ArmatureUtil.create("skill/" .. skillName, skillName):addToParent(self):play()
-- 设置播放时间比例
q:getArmature():getAnimation():setSpeedScale(0.5)
q:addMovementEventListenr(function(type)
    if type == "end" then q:clear() end
end)

q:addFrameEventListener(function(type)
    if type == "end" then q:clear() end
end)

]]

function ArmatureUtil.create(file, aniName)

    local ins = ArmatureUtil.new(file, aniName)
	return ins
end

function ArmatureUtil:ctor(file, aniName)

    self._file = file
    self._aniName = aniName

    ArmatureFileCache.addArmatureFile(file)

    local ani = ccs.Armature:create(aniName)

    self._armature = ani

end

function ArmatureUtil:play()
    if self._armature then self._armature:getAnimation():playWithIndex(0) end

    return self
end


--
function ArmatureUtil:addFrameEventListener(callback)
    self._armature:getAnimation():setFrameEventCallFunc(function(armature, movementType, movementID)
        -- print("setFrameEventCallFunc:", movementType, movementID)

        if callback then
           callback(movementType, armature)
        end
    end)

    return self
end


function ArmatureUtil:addMovementEventListenr(callback)

    self._armature:getAnimation():setMovementEventCallFunc(function(armature, movementType, movementID)
        if callback then
            callback(movementType, armature)
        end
	end)

    return self
end

function ArmatureUtil:addToParent(parent)
    parent:addChild(self._armature)

    return self
end

function ArmatureUtil:stop()
    self._armature:getAnimation():stop()
    return self
end

function ArmatureUtil:getArmature()
    return self._armature
end

function ArmatureUtil:clear()
    if self._armature then
        self._armature:removeFromParent()
        ArmatureFileCache.removeArmatureFile(self._file)
    end

    return self
end

function ArmatureUtil.clearAll()
    ArmatureFileCache.removeAllArmatureFiles()
end

---------------------------------------------------------------------


local function addArmatureFileInfo(url)

	local pvr = url .. "/animate.pvr.ccz"
	local plist = url .. "/animate.plist"
	local xml = url .. "/animate.xml"

	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pvr, plist, xml)
end


local function removeArmatureFileInfo(url)

    local pvr = url .. "/animate.pvr.ccz"
	local plist = url .. "/animate.plist"
	local xml = url .. "/animate.xml"

	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(xml)
	cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
    cc.Director:getInstance():getTextureCache():removeTextureForKey(pvr)
end

----------------------------------------------------------


function ArmatureFileCache.addArmatureFile(file)

	local isadd = false

	if #allArmature == 0 then
		table.insert(allArmature, file)
		addArmatureFileInfo(file)
	else
		for k,v in pairs(allArmature) do
			if  v == file then
				isadd = true
				break;
			end
		end
		if not isadd then
			table.insert(allArmature, file)
			addArmatureFileInfo(file)
		end
	end

end

function ArmatureFileCache.removeArmatureFile(file)

	for i,v in ipairs(allArmature) do
		if v ==  file then
			table.remove(allArmature, i)
			removeArmatureFileInfo(v)
            break
		end
	end

end

function ArmatureFileCache.removeAllArmatureFiles()
	for i,v in ipairs(allArmature) do
		removeArmatureFileInfo(v)
	end
	allArmature = {}
end





return ArmatureUtil
