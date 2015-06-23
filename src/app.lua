-- 注册一个全局的qy表, 存储所有的对象
qy = {
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

qycl = nil


--[[
    name: Ranking.MainDialog
    Ranking代表的是模块的名称，首字母必须大写
    MainDialog代表的是csd/modules/ranking/MainDialog这个UI
]]
function qy.class(name, base)
    local haveDot = string.find(name, "%p") -- 查找是否包含标点符号，这里指的是"."
    local moduleName = haveDot and string.sub(name, 1, haveDot - 1) or (function()
        local b, e = string.find(name, ".*%u") -- 查找最后一个大写字母的位置
        return string.sub(name, b, e - 1)
    end)()
    local className = haveDot and string.sub(name, haveDot + 1) or nil
    local obj = class(className or name, base)
    -- 基类是服务时，只绑定模型
    if base == qy.Service.Base then
        obj.model = qy.Model[moduleName]
    elseif base == qy.View.Base or base == qy.Dialog.Base or base == qy.Controller.Base then
        -- UI构造函数
        if className then
            obj.__create = function()
                return obj.super.__create("modules." .. string.lower(moduleName) .. "." .. className)
            end
        end
        -- 绑定模型
        obj.model = qy.Model[moduleName]
        -- 绑定服务
        obj.service = qy.Service[moduleName]
    end
    return obj
end

local App = class("App")

function App:ctor()
    self.runningScene = nil
    
    self:registerClass()
    
    qy.App = self

    qy.View = require("core.BaseView")

    -- qy.resversion = resversion or 0
    -- qy.Timer = require("utils.timer")
    -- qy.I18N = require("utils.i18n")
    -- qy.Event = require("utils.event")
    -- qy.Utils = require("utils.utils")
    -- qy.Http = require("utils.http")
    -- qy.Helper = require("utils.Helper")
    -- qy.FormulaCalculate = require("utils.FormulaCalculate")
    -- qy.Date = require("utils.date")
    -- qy.json = require("utils.dkjson")
    -- qy.String = require("utils.String")
    -- qy.M = require("utils.QYPlaySound")
    -- qy.res = require("res")
    -- qy.ArmatureManager = require("managers.ArmatureManager")
    -- qy.Effects = require("utils.effects")
    -- qy.TalkingData = require("utils.TalkingData")
    -- qy.SDK = require("utils.sdk")
    -- qy.ws = require("utils.websocket")

    -- require("utils.functions")
    -- require("utils.log")
end


-- 动态注册类,类java语法调用,包路径首字母小写,类名首字母大写
-- local login = sg.scene.LoginScene.new()
function App:registerClass() 
    local o = {}
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
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>className:",className)
                    t1 = require(className)
                    rawset(t, k, t1)
                else
                    t1 = {}
                    if path then
                        t1.__path = path ..".".. k
                    else
                        t1.__path = k
                    end
                    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>path:",t1.__path)
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
    qycl =  o
end

function App:popScene()
    cc.Director:getInstance():popScene()
end

function App:pushScene(scene)
    cc.Director:getInstance():pushScene(scene)
end

function App:replaceScene(scene)
    if cc.Director:getInstance():getRunningScene() then
        cc.Director:getInstance():replaceScene(scene)
    else
        cc.Director:getInstance():runWithScene(scene)
    end
end

function App:run()
    self:replaceScene(qycl.scenes.LoginScene.new())
end

return App
