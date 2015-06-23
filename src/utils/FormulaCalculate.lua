--[[
	各种公式计算
]]

local FormulaCalculate = class("FormulaCalculate")

--计算英雄升级后各属性数据
--[[
	a 星级  b 属性增量 c 基础属性成长 d 等级  e 基础属性
]]
function FormulaCalculate.heroAttribute(a,b,c,d,e)
    local num = ((a - 1)*b+c)*d +e
    return num
end

--[[正常伤害 己方角色物攻/角色魔攻 — （敌方角色物防/魔防  * （1-己方物防忽视率/魔防忽视率））） * （1- 敌方物防免疫/魔防免疫）
    a己方角色物攻/角色魔攻
    b敌方角色物防/魔防
    c己方物防忽视率/魔防忽视率
    d敌方物防免疫/魔防免疫
]]
function FormulaCalculate.ordinaryAttack(a,b,c,d)
    local num = (a - (b*(1-c)))*(1-d)
    return num
end

--[[
    爆击计算
    (1.5+爆击伤害倍率）*正常伤害
    a爆击伤害倍率
    b正常伤害
]]
function FormulaCalculate.criticalAttack(a,b)
    return (1.5+a)*b
end

--[[
    格挡免疫的伤害 ＝ 造成的最终伤害 * （ 1 - （0.2 +  hAttribute22））
    hAttribute22表里面填的直接是百分比，无需计算
    a 正常伤害
    b 敌方格挡免伤效果 hAttribute22
]]
function FormulaCalculate.blockNum(a,b)
    return a*(1-(0.2+b))
end


--[[
    最终伤害 ＝（算爆击后 +  己方神圣伤害） * 己方伤害倍率
    a算爆击后
    b己方神圣伤害
    c己方伤害倍率

    公式共用 己方神圣伤害可能为0
]]
function FormulaCalculate.attackNum(a,b,c)
    return (a+b)*c
end

function FormulaCalculate.attackType(a,b)
    --[[
        闪避率=SQRT(50*(不能为负数（挨打方闪避值-攻击方命中值)）/20) * 0.01
        格挡率=SQRT(50*(不能为负数（挨打方格挡值-攻击方破击值)）/20) * 0.01
        爆击率＝SQRT(50*(不能为负数（攻击方暴击值-挨打方抗爆值)）/20) * 0.01
        吸血百分比 = SQRT(50*(不能为负数（攻击方普攻吸血 -挨打方抗爆值)）/20) * 0.01 --hAttribute17
    ]]
    local value_ = (a-b) > 0 and (a-b) or 0
    local jl = math.sqrt(50*value_/20)
    -- if randn < sbl then
    --     return true
    -- end
    -- return false 
    return jl
end


--技能攻击
-- a 攻击力 b 防御力 c倍率
function FormulaCalculate.skillsAttack(a,b,c)
    local num = (a - b)*c
    return num
end
--额外加的属性
--[[
统统＝级*   关系

        hAttribute1 = heroInitData.heroHp,--生命
        hAttribute2 = heroInitData.heroAd,--物理攻击力
        hAttribute3 = heroInitData.heroAc,--物理防御力
        hAttribute4 = heroInitData.heroAp,--魔法攻击力
        hAttribute5 = heroInitData.heroAdf,--魔法防御力
        hAttribute6 = 0,--暴击值
        hAttribute7 = heroInitData.attackJL,--普通攻击距离
        hAttribute8 = 0,--物防忽视值
        hAttribute9 = 0,--魔防忽视值
        hAttribute10 = 0,--闪避值
        hAttribute11 = 0,--命中值
        hAttribute12 = 0,--治疗效果
        hAttribute15 = 0,--技能命中等级
        hAttribute13 = heroInitData.addHpNum,--过关加血 血量回复
        hAttribute14 = heroInitData.addMpNum,--过关加能量 能量回复
        hAttribute16 = 0, --技能＝级
        hAttribute17 = 0, --普攻吸血
        hAttribute18 = 0,--爆击伤害倍率
        hAttribute19 = 0,-- 抗爆值
        hAttribute20 = 0,--格挡
        hAttribute21 = 0,--破击
        hAttribute22 = 0,--格挡免伤效果率 
        hAttribute23 = 0,--物防免疫
        hAttribute24 = 0,--魔防免疫
        hAttribute25 = 0,--被治疗效果
        hAttribute26 = 0,-- 技能效果抗性等级
        hAttribute27 = 0,--神圣伤害
        hAttribute28 = heroInitData.ptAttackCd,--普通CD

]]
function FormulaCalculate:equipmentAddAttribute(a, b)
	local num = a *b
	return num
end 

--技能升级
function FormulaCalculate:skillUpAddValue(d, type_)
    local val = 0
    if d.upValueList then
        local lv = d.level
        for k,v in pairs(d.upValueList) do
            -- print(k,v)
            if v.type == type_ then
                val = v.value+lv*v.value1
                break
            end
        end
    end
    return val
end

--[[
    buff 命中
    技能BUFF闪避率 ＝   SQRT(50*(不能为负数（敌方技能抗性等级-(自己英雄技能等级+自己技能命中等级)）/20) 
    hAttribute26 = 0,-- 技能效果抗性

    a hAttribute26 = 0,-- 敌方技能抗性等级
    b 自己英雄技能等级
    c 自己技能命中等级
]]
function FormulaCalculate.checkBuffHit(a,b,c)
    local num = math.random(100)
    local aa = (a-(b+c))
    local value_ = aa > 0 and aa or 0
    local jl = math.sqrt(50*value_/20)
    if num < jl then
        return true
    end
    return false
end
--待删
function FormulaCalculate:getSkillProbability(a, b)
    local probability = (1-(a-b)*0.08)
    if probability >= 1 then
        return true
    elseif probability < 1 and probability > 0 then
        probability = probability*100
        if probability > math.random(100) then
            return true
        end
    end
    return false
end
--[[
    最终治疗 ＝ （（自己的魔法攻击力【hAttribute4】 * 自己的技能系数 + （自己的技能附加基础 + 自己的技能等级 * 自己的技能附加增量））
    * （1 + 自己的治疗效果【hAttribute12】+ 被治疗方的被治疗效果【hAttribute25】）） * 技能伤害倍率

    a 自己的魔法攻击力
    b 自己的治疗效果
    c 被治疗方的被治疗效果
    d 技能数据

    ==自己的技能附加基础 + 自己的技能等级 * 自己的技能附加增量）==类型101
    ==d.skillRatio  技能伤害倍率
]]
function FormulaCalculate.treatment(a,b,c,d)
    return ((a*d.damagePt+qy.FormulaCalculate:skillUpAddValue(d, 101))*(1+b+c))*d.skillRatio
end


--活动副本金钱计算   d伤害lv玩家＝级
function FormulaCalculate:shilanMoney(d,lv)
    return math.ceil(math.pow(d,1.5)/(2000*math.sqrt(lv)))
end



return FormulaCalculate