
-- 使用cocos studio导出的lua中Text组件的自定义大小存在bug，暂时使用该方法解决
function ccui.Text:fixSize(size)
    self:ignoreContentAdaptWithSize(false)
    self:setTextAreaSize(size)
end


function ccui.TextField:fixSize(size)
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
