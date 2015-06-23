
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = true

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 960,
    height = 640,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "SHOW_ALL"}
        end
    end
}

-- 是否启用内更新
local app = cc.Application:getInstance()
local target = app:getTargetPlatform()
if target == 2 then -- Mac平台模拟器不使用内更新
    QY_IS_USE_UPDATE = false
else
    QY_IS_USE_UPDATE = true

    QY_SDK = "default"
    -- QY_SDK = "haima"

    if QY_SDK == "haima" then
        QY_MANIFEST_FILE = "haima.manifest"
    else
        QY_MANIFEST_FILE = "heroes.manifest"
    end
end