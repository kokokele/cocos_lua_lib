-- 注册一个全局的qy表, 存储所有的对象
app.config = {
    -- 是否是debug模式 
    DEBUG = true,
    -- 手动新手开关
    IS_NEW = true,
    IS_NEW_EXTEND = true,
    -- 服务器信息配置
    SERVER_SCHEME = "http",
    SERVER_PORT = "80",
    

    SERVER_PATH = "vms/index.php?mod=api",
}

local App = class("App")


function App:run()
    app.replaceScene(app.scenes.LoginScene.new())
end

return App
