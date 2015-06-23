--[[
	背景音乐&音效管理类
	黄晨 <laoxieit@163.com>
]]

local QYPlaySound = class("QYPlaySound")

QYPlaySound.musiceVolume = 1.0
QYPlaySound.effectVolume = 1.0
QYPlaySound.musiceOn = cc.UserDefault:getInstance():getBoolForKey("local_MusicOn", true)
QYPlaySound.effectOn = cc.UserDefault:getInstance():getBoolForKey("local_EffectOn", true)


function QYPlaySound.getInstance()
    return cc.SimpleAudioEngine:getInstance()
end

---------------------------------------------------------
-- 音乐
-- 预加载音乐文件
function QYPlaySound.preloadMusic(filename)
	cc.SimpleAudioEngine:getInstance():preloadMusic(filename)
end

-- 播放音乐
function QYPlaySound.playMusic(filename, isLoop)
	if not QYPlaySound.musiceOn then
		return true
	end

    cc.SimpleAudioEngine:getInstance():playMusic(filename, isLoop or true)
end

-- 停止音乐
function QYPlaySound.stopMusic(isReleaseData)
	local releaseDataValue = false
	if nil ~= isReleaseData then
		releaseDataValue = isReleaseData
	end

	cc.SimpleAudioEngine:getInstance():stopMusic(releaseDataValue)
end

-- 重播音乐
function QYPlaySound.rewindMusic()
    cc.SimpleAudioEngine:getInstance():rewindMusic()
end

-- 设置音量
function QYPlaySound.setMusicVolume(volume)
	cc.SimpleAudioEngine:getInstance():setMusicVolume(volume)
end

-- 获得音量
function QYPlaySound.getMusicVolume()
    return cc.SimpleAudioEngine:getInstance():getMusicVolume()
end

-- 暂停音乐
function QYPlaySound.pauseMusic()
    cc.SimpleAudioEngine:getInstance():pauseMusic()
end

-- 恢复音乐
function QYPlaySound.resumeMusic()
    cc.SimpleAudioEngine:getInstance():resumeMusic()
end

function QYPlaySound:setMusiceOn(on)
	QYPlaySound.musiceOn = on
	if not on then
		QYPlaySound.stopMusic()
	end
end

---------------------------------------------------------
-- 音效
-- 预加载音效
function QYPlaySound.preloadEffect(filename)
    cc.SimpleAudioEngine:getInstance():preloadEffect(filename)
end

-- 播放音效
function QYPlaySound.playEffect(filename, isLoop)

	if not QYPlaySound.effectOn then
		return true
	end
	return cc.SimpleAudioEngine:getInstance():playEffect(filename, isLoop or false)    
end

-- 停止音效
function QYPlaySound.stopEffect(handle)
	cc.SimpleAudioEngine:getInstance():stopEffect(handle)
end

-- 停止所有音效
function QYPlaySound.stopAllEffects()
	cc.SimpleAudioEngine:getInstance():stopAllEffects()
end

-- 暂停音效
function QYPlaySound.pauseEffect(handle)
    cc.SimpleAudioEngine:getInstance():pauseEffect(handle)
end

-- 暂停所有音效
function QYPlaySound.pauseAllEffects()
    cc.SimpleAudioEngine:getInstance():pauseAllEffects()
end

-- 恢复音效
function QYPlaySound.resumeEffect(handle)
    cc.SimpleAudioEngine:getInstance():resumeEffect(handle)
end

-- 恢复所有音效
function QYPlaySound.resumeAllEffects(handle)
    cc.SimpleAudioEngine:getInstance():resumeAllEffects()
end

-- 设置音效音量
function QYPlaySound.setEffectsVolume(volume)
    cc.SimpleAudioEngine:getInstance():setEffectsVolume(volume)
end

-- 获得音效音量
function QYPlaySound.getEffectsVolume()
    cc.SimpleAudioEngine:getInstance():getEffectsVolume()
end

function QYPlaySound:setEffectsOn(on)
	QYPlaySound.effectOn = on
	if not on then
		QYPlaySound.stopAllEffects()
	end
end

return QYPlaySound