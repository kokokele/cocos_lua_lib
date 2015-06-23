--[[
    说明: 日期类

    %a  abbreviated weekday name (e.g., Wed)
    %A  full weekday name (e.g., Wednesday)
    %b  abbreviated month name (e.g., Sep)
    %B  full month name (e.g., September)
    %c  date and time (e.g., 09/16/98 23:48:10)
    %d  day of the month (16) [01-31]
    %H  hour, using a 24-hour clock (23) [00-23]
    %I  hour, using a 12-hour clock (11) [01-12]
    %M  minute (48) [00-59]
    %m  month (09) [01-12]
    %p  either "am" or "pm" (pm)
    %S  second (10) [00-61]
    %w  weekday (3) [0-6 = Sunday-Saturday]
    %x  date (e.g., 09/16/98)
    %X  time (e.g., 23:48:10)
    %Y  full year (1998)
    %y  two-digit year (98) [00-99]
    %%  the character `%´

    usage:
        local str, isZero = qy.Date.format("%X", 12345678910)
        if isZero then
            print("倒计时结束")
        else
            print(str .. " 后免费")
        end
]]

local Date = class("Date")

function Date.format(format, time)
    local sec = time - os.time() -- - fix_time
    local datetime = os.time(os.date("!*t", math.max(sec, 0)))
    return os.date(format, datetime), sec < 0
end

return Date