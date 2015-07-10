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

-- 下一帧执行 方法
function Timer.onFrameNext(func)
    local director = cc.Director:getInstance()
    local delay = director:getAnimationInterval()

    Timer.createOnce(func, delay)

end


function Timer.createOnce (func, delay)

    local director = cc.Director:getInstance()
    local interval = director:getAnimationInterval()

    local timeHandler = nil
    timeHandler = director:getScheduler():scheduleScriptFunc(function()
            func()
            director:getScheduler():unscheduleScriptEntry(timeHandler)

        end, delay, false)
end

return Timer
