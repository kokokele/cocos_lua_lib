--[[
    Lua 标准库拓展
]]
-- 计算表中字段数量
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

-- 检查并尝试转换为数值，如果无法转换则返回 0
function checknumber(value, base)
    return tonumber(value, base) or 0
end

-- 格式化数值
-- use: string.formatnumberthousands(1924235) 1,924,235
function string.formatnumberthousands(num)
    local formatted = tostring(checknumber(num))
    local k
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

-- 用指定字符或字符串切割，返回包含分割结果的数据
-- use: local input = "Hello,World"
--      local res = string.split(input, ",")
--      res = {"Hello", "World"}
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

-- 从表格中查找指定值，返回其索引，如果没找到返回 false
function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return false
end

-- 从表格中查找指定值，返回其 key，如果没找到返回 nil
function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

-- 使用cocos studio导出的lua中Text组件的自定义大小存在bug，暂时使用该方法解决
function ccui.Text:fixSize(size)
    self:ignoreContentAdaptWithSize(false)
    self:setTextAreaSize(size)
end

-- 设置行高
function ccui.Text:setLineHeight(lineHeight)
    self:getVirtualRenderer():setLineHeight(lineHeight)
end

local __setPosition = cc.Node.setPosition
function ccui.TextAtlas:setPosition(x, y)
    if type(x) == "table" then
        y = x.y
        x = x.x
    end
    __setPosition(self, x, y)
    self.__originX = x
end

function ccui.TextAtlas:setStringWithAnim(text, animated)
    local oldnum = self.__oldnum or 0
    local newnum = tonumber(text)
    self:setString(newnum)
    self:setPositionX(self.__originX + self:getContentSize().width / 2.0)
    if oldnum ~= 0 then
        local addnum = newnum - oldnum
        -- 减少时没有动画效果
        if addnum > 0 and (animated == nil or animated == true) then
            local i = 1
            local num = 31
            local increment = math.max(math.round(addnum / num), 1)
            self:setString(oldnum)
            self:runAction(cc.Sequence:create(cc.ScaleTo:create(0.25, 1.35),
                cc.ScaleTo:create(0.08, 1.2),
                cc.CallFunc:create(function()
                    self:stopAllActions()
                    schedule(self, function()
                        self:setString(math.min(oldnum + i, newnum))
                        i = i + increment
                        if i >= addnum then
                            self:setString(newnum)
                            self:stopAllActions()
                            self:runAction(cc.ScaleTo:create(0.15, 1))
                        end
                    end, 0.01)
                end)
            ))
        end
    end
    self.__oldnum = newnum
end