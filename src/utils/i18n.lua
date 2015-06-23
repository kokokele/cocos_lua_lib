--[[
    说明: 国际化工具类
]]

local I18N = class("I18N")

-- 载入的语言资源库
I18N.translates = require("data/translate")

-- 获取对应的语言字符串
function I18N.getString(name)
    local str = I18N.translates[name]
    if str then
        return str.zh_CN
    else
        return name
    end
end

return I18N