--[[
    说明: 事件工具类
]]

local Event = class("Event")

-- 装备强化完成事件
Event.EQUIP_UPGRADE_DONE = "EQUIP_UPGRADE_DONE"
-- 材料合成完成事件
Event.FUSE_DONE = "FUSE_DONE"
-- 英雄战斗力发生变化
Event.HERO_COMBATL_CHANGED = "HERO_COMBATL_CHANGED"
Event.HERO_LEVEL_CHANGED = "HERO_LEVEL_CHANGED"
Event.HERO_FUSE_DONE = "HERO_FUSE_DONE"
Event.HERO_UP_GRADE_DONE = "HERO_UP_GRADE_DONE"
Event.HERO_UP_STAR_DONE = "HERO_UP_STAR_DONE"
Event.SKILL_POINT_BUY_DONE = "SKILL_POINT_BUY_DONE"
Event.HERO_INFO_CHANGED = "HERO_INFO_CHANGED"

Event.USER_SPIRIT_CHANGED = "USER_SPIRIT_CHANGED" -- 体力
Event.USER_MONEY_CHANGED = "USER_MONEY_CHANGED" -- 金币
Event.USER_GEM_CHANGED = "USER_GEM_CHANGED" -- 钻石
Event.USER_LEVEL_CHANGED = "USER_LEVEL_CHANGED" -- 等级
Event.USER_VIP_LEVEL_CHANGED = "USER_VIP_LEVEL_CHANGED" -- 等级
Event.USER_EMAIL_CHANGED = "USER_EMAIL_CHANGED" --邮箱状态

Event.GUIDE_CHANGE = "guideChange"
Event.GUIDE_STEP_CHANGE = "guideStepChange"
Event.GUIDE_END = "guideEnd"
Event.CONTINUE_TOUCH_END = "CONTINUE_TOUCH_END"

-- 背包出售完成
Event.BACKPACK_SELL_DONE = "BACKPACK_SELL_DONE"
Event.BACKPACK_USE_DONE = "BACKPACK_USE_DONE"

-- 副本扫荡完成
Event.PVE_CLEAN_LEVEL_DONE = "PVE_CLEAN_LEVEL_DONE"

-- 请求数据中
Event.SERVICE_LOADING = "SERVICE_LOADING"
-- 请求数据完成
Event.SERVICE_LOADING_DONE = "SERVICE_LOADING_DONE"

-- 显示英雄试炼
Event.CONTROLLER_SHOW_ACTIVITY = "CONTROLLER_SHOW_ACTIVITY"
Event.CONTROLLER_SHOW_PVE = "CONTROLLER_SHOW_PVE"
Event.CONTROLLER_SHOW_ARENA = "CONTROLLER_SHOW_ARENA"
Event.CONTROLLER_SHOW_KILLING = "CONTROLLER_SHOW_KILLING"
Event.CONTROLLER_SHOW_ALTAR = "CONTROLLER_SHOW_ALTAR"

-- 显示开启新功能 
Event.OPEN_NEW_CONTENT = "OPEN_NEW_CONTENT"
-- 显示商店
Event.CONTROLLER_SHOW_SHOP = "CONTROLLER_SHOW_SHOP"
-- 显示精英关卡
Event.CONTROLLER_SHOW_ELITE = "CONTROLLER_SHOW_ELITE"
-- 显示任务
Event.CONTROLLER_SHOW_TASK = "CONTROLLER_SHOW_TASK"

Event.TIPS_SHOW = "TIPS_SHOW"

Event.CHANGE_BACKGROUND = "CHANGE_BACKGROUND"

-- PVE星级奖励动画
Event.PVE_CHECK_CAN_GET_REWARD = "PVE_CHECK_CAN_GET_REWARD"

Event.Dispatcher = cc.Director:getInstance():getEventDispatcher()

-- 增加一个事件监听
-- name: 事件名称
-- func: 事件回调
-- fixedPriority: 优化级, 默认为1
function Event.add(name, func, fixedPriority)
    local listener = cc.EventListenerCustom:create(name, func)
    Event.Dispatcher:addEventListenerWithFixedPriority(listener, fixedPriority or 1)
    return listener
end

-- 删除一个事件监听
function Event.remove(listener)
    if listener then
        Event.Dispatcher:removeEventListener(listener)
    end
end

-- 触发一个事件监听
function Event.dispatch(name, usedata)
    local event = cc.EventCustom:new(name)
    event._usedata = usedata
    Event.Dispatcher:dispatchEvent(event)
end

return Event