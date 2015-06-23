local Timer = class("Timer")

Timer.times = {}

function Timer.create(name, func, interval)
    if not Timer.times[name] then
        Timer.times[name] = cc.Director:getInstance():getScheduler():scheduleScriptFunc(func, interval, false)
    end
end

function Timer.remove(name)
    if Timer.times[name] then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(Timer.times[name])
        Timer.times[name] = nil
    end
end

function Timer.check(name)
    return Timer.times[name] ~= nil
end

return Timer