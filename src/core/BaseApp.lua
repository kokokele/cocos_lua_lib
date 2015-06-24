--
-- Author: zp
-- Date: 2015-06-24 15:34:47
--

-- 注册一个全局的qy表, 存储所有的对象
app = nil


local BaseApp = class("BaseApp")

function BaseApp:ctor()
    self.runningScene = nil

    app = self
    app.p = {}
    
    self:registerClass(app.p)
    

    app.V = require("core.BaseView")
    -- app.C = require("core.BaseController")
    -- app.M = require("core.BaseModel")

    app.Timer = require("utils.timer")
    app.Event = require("utils.event")
    app.Http = require("utils.http")
   	app.Date = require("utils.date")
    app.json = require("utils.dkjson")
    app.String = require("utils.String")

end


-- 动态注册类,类java语法调用,包路径首字母小写,类名首字母大写
-- local login = sg.scene.LoginScene.new()
function BaseApp:registerClass(o) 
    
    function recursion(_o) 
        setmetatable(_o, {
            __index = function(t, k)
                local path = rawget(t,"__path")
                local t1 = nil
                if string.byte(k,1) == string.byte(string.upper(k),1) then
                    local className
                     if path then
                        className = path.."."..k
                    else
                        className = k
                    end
                    -- print(">>>>>>>>>>>>>>className:",className)
                    t1 = require(className)
                    rawset(t, k, t1)
                else
                    t1 = {}
                    if path then
                        t1.__path = path ..".".. k
                    else
                        t1.__path = k
                    end
                    -- print(">>>>>>>>>>>>>>path:",t1.__path)
                    rawset(t, k, t1)
                    recursion(_o[k])
                end
                return t1
            end,

            __newindex = function(_, k, v)
                -- only read
            end,
        })
    end

    recursion(o)
end

function BaseApp:popScene()
    cc.Director:getInstance():popScene()
end

function BaseApp:pushScene(scene)
    cc.Director:getInstance():pushScene(scene)
end

function BaseApp:replaceScene(scene)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

BaseApp.new()
------------------
