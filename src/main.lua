cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src")
cc.FileUtils:getInstance():addSearchPath("res")

qy = {}

require "config"
require "cocos.init"

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    print(debug.traceback())
    return msg
end

local function start()

    require("core.BaseApp")
	require("app").new():run()
end


local function main()
    collectgarbage("collect")
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    
    print = release_print
    -- initialize director
    local director = cc.Director:getInstance()

    
    --turn on display FPS
    director:setDisplayStats(true)

    --set FPS. the default value is 1.0/60 if you don't call this
    director:setAnimationInterval(1.0 / 60)

    start()
end


local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    error(msg)
end
