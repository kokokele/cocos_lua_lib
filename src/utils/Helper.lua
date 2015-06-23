local Helper = class("Helper")
local plists = {}
local animations = {}

-- 添加Plist文件
function Helper.addPlist(name)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("res/" .. name ..".plist", "res/" .. name .. ".pvr.ccz")
end

-- 删除Plist文件
function Helper.removePlist(name)
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile("res/" .. name .. ".plist")
    display.removeImage("res/" .. name .. ".pvr.ccz")
end 

function Helper.addArmatureFileInfo(name)
    -- body
    local pvr = "res/" .. name .. ".pvr.ccz"
    local plist = "res/" .. name .. ".plist"
    local xml = "res/" .. name .. ".xml"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(pvr, plist, xml)
end

function Helper.removeArmatureFileInfo(name)
    -- body
    local pvr = "res/" .. name .. ".pvr.ccz"
    local plist = "res/" .. name .. ".plist"
    local xml = "res/" .. name .. ".xml"
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(xml)
    cc.SpriteFrameCache:getInstance():removeSpriteFramesFromFile(plist)
    display.removeImage(pvr)
end

function Helper.removeTextureForKey(name)
    -- body
    local pvr = "res/" .. name
    display.removeImage(pvr)
end


function Helper.loadImage(name)
    -- body
    return name
end



Helper.SKILL_GRAY = cc.c3b(80, 80, 80)
Helper.heroListPzwh = 30
Helper.HERO_MAX_AP = 1500

function Helper.width()
    -- body
    local s = cc.Director:getInstance():getWinSize()
    return s.width
end

function Helper.height()
    -- body
    local s = cc.Director:getInstance():getWinSize()
    return s.height
end

function Helper.htLength(p, p1)
    -- body
    local a, b = 0;
    a = math.abs(p.x - p1.x);
    b = math.abs(p.y - p1.y);
    local c = math.sqrt(math.pow(a, 2)+ math.pow(b, 2))
    return c
end

function Helper.htLengthX(p,p1)
    return math.abs(p.x - p1.x);
end

function Helper.rectContainsPoint(p, w, p1)
    -- local rect_ = cc.rect( p.x - size_.width*0.5, p.y - size_.height*0.5, size_.width, size_.height)
    -- return cc.rectContainsPoint( rect_, p1)

    if p1.x>=p.x-w and
        p1.x<=p.x+w then
        return true
    end
    return false
end

function Helper.roundContainsPoint(p, p1, radius)
    local contains = false
    if Helper.htLength(p, p1) <= radius then
        contains = true
    end
    return contains
end

function Helper.TOPOS_TIME(p, p1, s)
    -- body
    local time =  Helper.htLength(p, p1)/s
    return time
end

--dt 当前秒数 返回 XX:XX:XX 时间串
function Helper.getTimeStr(dt)
    -- body
    local hours = math.floor(dt/3600)--多少小时
    local minutes = math.floor((dt - hours*3600)/60)
    local seconds = dt - hours*3600 - minutes*60

    local str = ""
    if seconds > 9 then
        str = tostring(seconds)
    else
        str = "0" .. tostring(seconds)
    end

    if minutes > 9 then
        str = tostring(minutes) .. ":" .. str
    else
        str = "0" .. tostring(minutes) .. ":" .. str
    end

    if hours > 9 then
        str = tostring(hours) .. ":" .. str
    elseif hours > 0 then
        str = "0" .. tostring(hours) .. ":" .. str
    end

    return str
    -- print("timestr==================================", str)

end

function Helper.Angle(p, p1)
    -- body
    local b =  math.abs(p.y-p1.y)
    local c =  math.abs(p.x-p1.x)
    local sina = math.atan(b/c)
    return math.abs(180*sina/3.1415)
end

function Helper.removeValue(_table, value)
    -- body

    cclog("Helper.removeValue")
    print_r(value)
    for k, v in pairs(_table) do
        if value == v then
            table.remove(_table, k)
            cclog("删除成功")
            break
        end
    end
end

Helper.screenwidth = Helper.width()
Helper.screenheight = Helper.height()

Helper.Hero_Interval = 100

Helper.heroListPzwh = 30

Helper.LineMoment = 50

Helper.STANDARD_LINE_UP = Helper.LineMoment*2+202 --三行中心线

Helper.STANDARD_LINE_MAX_DOWN = 202

Helper.STANDARD_LINE_MAX_UP = Helper.STANDARD_LINE_MAX_DOWN + Helper.LineMoment*4

Helper.STANDARD_LINE_CENTRE = Helper.STANDARD_LINE_UP - Helper.LineMoment/2--中心

Helper.STANDARD_LINE_DOWN = Helper.STANDARD_LINE_UP - Helper.LineMoment
Helper.MAPLEVELPOS_X = 200
Helper.MAPMOVE_WIDE = 300
Helper.SORT_TEAM_POS_X = 150 --整理队伍


function Helper.loadLanguageImg(name)
    -- body
    return name

end

function Helper.loadLanguageText(key)
    -- body

end

-- 获取屏幕大小
Helper.winSize = cc.Director:getInstance():getWinSize()

-- 判断元素是否在LayerTable表中 
function Helper.isInLayerTable(t, para)
    for k,v in pairs(t) do
        if v:getTag() == para:getTag() then
            return true, k
        end
    end
end

--table大小
function Helper.getTableSize(t)
    -- body
    local size = 0
    for i,v in ipairs(t) do
        size = size+1
    end
    return size
end

-- 游戏LayerTags
Helper.GameLayerTag = {nulTag = 100, LoginLayerTag = 101, MainLayerTag = 102}

-- 当前纹理内存
Helper.memory = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()

-- 读取静态数据表
function Helper.addDataFile(name)
    -- local path = "data/" .. name .. ".json"
    -- local data = cc.FileUtils:getInstance():getStringFromFile(path)
    -- return json.decode(data)
end

--[[ 
    初始化静态数据
use:
    Helper.static.hero[tostring(hero.id)]
]]

Helper.static = {
    -- hero = Helper.addDataFile("item"),--英雄
    -- skillsData = Helper.addDataFile("npczdskill"),--技能
    -- criticalData = Helper.addDataFile("critical"),--暴击
    -- chapterContent = Helper.addDataFile("chapterContent1"),--第1章节 多


    hero = require("data/item"),--英雄 道具＝＝
    skillsData = require("data/npczdskill"),           --技能
    buffData = require("data/buff"),                       --buff
    criticalData = require("data/critical"),           --暴击
    chapterContent = require("data/chapter/guanka"),           --关卡
    chapterData = require("data/chapter/zhangjie"),            --章节
    bossRankReward = require("data/bossaltar/boss_rankbetween_reward"),--boss 排名奖励（区间）
    shilian = require("data/shilian/shilian"),--英雄试练

    -- shaluzhanchang = require("data/shaluzanchang/shaluzanchang"),--杀戮之地
    shaluzhanchang = (function ()
        local d = {}
        for i=1,3 do
            local str = string.format("zone_%d",i)
            d[str] = require(string.format("data/killzone/%s",str))
        end
        return d
    end)(),
    killingRankReward = require("data/killzone/killzone_rankbetween_reward"),
    arenaRankReward = require("data/pvp/pvp_rankbetween_reward"),
    gameRules = require("data/gameRules"),--游戏规则说明
    bossRankNpc = require("data/bossaltar/rank_npc"),--boss 分数列表 (npc)
    heroUpLevelData = require("data/heroUpLevelData"),     --英雄升级
    luckyDraw = require("data/openbox/openbox"),                    -- 抽箱子
    shop = require("data/shop/shop"),                            -- 商店   
    setting = require("data/setting"),                      -- peizhi
    enemyAddAttribute = require("data/enemyAddAttribute"),--额外添加属性
    funcnumcost = require("data/funcnumcost"),
    funcopen = require("data/funcopen"),    --各模块开启条件
    hero_tags = require("data/hero_tags"), 
    task =require("data/task"),
    heroLevel = require("data/herolevel"),
    userLevel = require("data/userlevel"),
    guide = require("data/guide"),
    guideGuanka = require("data/guide_guanka"),
    signin = {},                                            -- 签到
    vip = require("data/vip"),
    recharge = {},
    totalLogin = require("data/activity/total_login"),
    initial = require("data/initial"),
}

setmetatable(Helper.static.hero, {
    __newindex = function(t, k, v)
        error("只读")
    end
})

-- 签到
setmetatable(Helper.static.signin, {
    __index = function (t, k)
        return require("data/qiandao/" .. k)
    end
})

-- 充值
setmetatable(Helper.static.recharge, {
    __index = function (t, k)
        return require("data/payment/" .. k)
    end
})

return Helper