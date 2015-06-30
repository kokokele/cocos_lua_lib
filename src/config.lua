
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

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

-- 注册一个全局的qy表, 存储所有的对象
app = {}

app.config = {
    -- 是否是debug模式
    DEBUG = true,
    -- 手动新手开关
    IS_NEW = true,
    IS_NEW_EXTEND = true,

    Theme = "theme_default",

    -- 服务器信息配置
    SERVER_SCHEME = "http",
    SERVER_PORT = "80",


    SERVER_PATH = "vms/index.php?mod=api",
}
