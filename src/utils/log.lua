--[[--
打印UserData & table
]]
app.print_r = function(o, ret, indent)
    local r = ""
    local t = type(o)

    if t == "table" then
        if not indent then indent = 0 end
        r = "{"
        local first = true

        for k, v in pairs(o) do
            r = r .. (first and "" or ", ") .. print_r(k, true, indent + 1).. "=" .. print_r(v, true, indent + 1)
            if first then first = false end
        end
        r = r .. "}\n"
    elseif t == "function" then r = "funciton"
    elseif t == "string" then   r = o
    elseif t == "boolean" then  r = o and "true" or "false"
    elseif t == "nil" then      r = t
    elseif t == "userdata" then
        t = tolua.type(o)
        if t == "CCPoint" then r = "{x="..o.x..",y="..o.y.."}"
        elseif t == "CCSize" then r = "{width="..o.width..",height="..o.height.."}"
        elseif t == "CCRect" then r = "{origin="..print_r(o.origin, true)..",size="..print_r(o.size, true).."}"
        else r = t
        end
    else r = r .. o
    end

    if ret then return r else
        print("------------------ [print_r] Start---------------------")
        print(r)
        print("------------------ [print_r] End  ---------------------")
    end
end

--[[--
Lua 格式化打印 table 函数
use: http://www.laoxieit.com/coding/59.html
]]
function app.print_lua_table (lua_table)
    indent = indent or 0
    for k, v in pairs(lua_table) do
        if type(k) == "string" then
            k = string.format("%q", k)
        end
        local szSuffix = ""
        if type(v) == "table" then
            szSuffix = "{"
        end
        local szPrefix = string.rep("    ", indent)
        formatting = szPrefix.."["..k.."]".." = "..szSuffix
        if type(v) == "table" then
            print(formatting)
            print_lua_table(v, indent + 1)
            print(szPrefix.."},")
        else
            local szValue = ""
            if type(v) == "string" then
                szValue = string.format("%q", v)
            else
                szValue = tostring(v)
            end
            print(formatting..szValue..",")
        end
    end
end
