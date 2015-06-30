
local MyApp = class("MyApp")

function MyApp:run()
    app.replaceScene(app.scenes.LoginScene.new())
end

return MyApp
