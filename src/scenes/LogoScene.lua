--[[
    说明：LOGO场景
    作者：林国锋
    日期：2015-04-14
]]

local LogoScene = class("LogoScene", cc.Scene)

local videoFullPath = cc.FileUtils:getInstance():fullPathForFilename("res/video/logo.mp4")

function LogoScene:ctor(onCompletedListener)
    local function onVideoEventCallback(sender, eventType)
        if eventType == ccexp.VideoPlayerEvent.COMPLETED then
            onCompletedListener()
        end
    end

    local scale = display.size.width / 720.00
    local cgVideoPlayer = ccexp.VideoPlayer:create()
    cgVideoPlayer:setPosition(cc.p(display.size.width / 2, display.size.height / 2))
    cgVideoPlayer:setAnchorPoint(cc.p(0.5, 0.5))
    cgVideoPlayer:setContentSize(cc.size(display.size.width, display.size.height))
    cgVideoPlayer:setContentSize(cc.size(720 * scale, 344 * scale))
    cgVideoPlayer:setFileName(videoFullPath)
    cgVideoPlayer:addEventListener(onVideoEventCallback)

    self:addChild(cgVideoPlayer)

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(function(touch, event)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    listener:registerScriptHandler(function(touch, event)
        if not cgVideoPlayer:isPlaying() then
            cgVideoPlayer:resume()
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)

    cgVideoPlayer:play()
end

return LogoScene