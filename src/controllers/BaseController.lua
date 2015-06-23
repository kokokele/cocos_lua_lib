--[[
    说明: 基础控制器
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-11-11
]]

local BaseController = class("BaseController", qy.View.Base)

function BaseController:ctor()
    BaseController.super.ctor(self)
end

function BaseController:startController(controller)
    qy.App.runningScene:push(controller)
end

function BaseController:finish()
    qy.App.runningScene:pop()
end

-- 菜单层左上角返回按钮
function BaseController:onBackClicked()
    self:finish()
end

return BaseController