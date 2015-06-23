--[[
    说明: 弹窗基类, 自带半透明背景, 所有继承的弹窗不需要再增加透明背景
]]

local BaseDialog = class("BaseDialog", qy.View.Base)

-- 继承
function BaseDialog.extend(name, csbFile)
    local InheritView = class(name, BaseDialog)
    if csbFile then
        InheritView.__create = function()
            return InheritView.super.__create(csbFile)
        end
    end
    return InheritView
end

function BaseDialog:ctor(_, params)
    BaseDialog.super.ctor(self)

    self:setContentSize(display.size)
    
    self:OnClick("Btn_close", function()
        qy.M.playEffect("UI1.mp3")
        self:dismiss()
    end)

    self:setAnchorPoint(display.CENTER)
    self:setOpacity(0)
    self:setScale(0.05)

    self._isCanceledOnTouchOutside = false
    self._isGlobal = false -- 是否是全局dialog
end

function BaseDialog:setColorOpacity(opacity)
    self._opacity = opacity
end

function BaseDialog:_proxyDialog()
    local layout = ccui.Layout:create()
    layout:setContentSize(display.size)
    layout:setBackGroundColor(cc.c3b(0, 0, 0))    -- 填充颜色
    layout:setBackGroundColorType(1)              -- 填充方式
    layout:setBackGroundColorOpacity(self._opacity or 160)         -- 颜色透明度
    layout:setTouchEnabled(true)

    -- 点击透明区域可关闭
    layout:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended then
            if self._isCanceledOnTouchOutside then
                self:dismiss()
            end
        end
    end)

    self:addTo(layout)

    return layout
end

-- 非全局弹窗
function BaseDialog:showTo(parent, startPos)
    self:_show(startPos, parent)
end

-- 全局弹窗
function BaseDialog:show(startPos)
    self:_show(startPos)
end

function BaseDialog:_show(startPos, parent)
    self._isGlobal = not parent
    self._startpos = startPos or display.center
    self:setPosition(self._startpos)
    if parent then
        parent:addChild(self:_proxyDialog(), 1000)
    else
        qy.App.runningScene:showDialog(self:_proxyDialog())
    end
    -- 弹窗动画是根据60帧做的，转换一下
    local delay = cc.Director:getInstance():getAnimationInterval() - (1.0 / 60)
    self:runAction(cc.Sequence:create(
        cc.Spawn:create(
            cc.ScaleTo:create(0.15 + delay, 1.07),
            cc.FadeIn:create(0.08 + delay),
            cc.MoveTo:create(0.1 + delay, display.center)
        ),
        cc.ScaleTo:create(0.1 + delay, 0.99),
        cc.ScaleTo:create(0.03 + delay, 1),
        cc.CallFunc:create(function()
            self:onShowFinish()
        end)
    ))
end

function BaseDialog:dismiss(onDismissFinishListener)
    qy.M.playEffect("UI1.mp3")
    if self._dismissListener then
        self._dismissListener(self)
    end

    if not tolua.isnull(self) then
        self:_dismiss(onDismissFinishListener)
    end
end

function BaseDialog:_dismiss(onDismissFinishListener)
    self:runAction(cc.Sequence:create(
        cc.ScaleTo:create(0.15, 1.2),
        cc.ScaleTo:create(0.03, 1),
        cc.Spawn:create(
            cc.CallFunc:create(function()
                self:getParent():runAction(cc.FadeOut:create(0.11))
            end),
            cc.ScaleTo:create(0.1, 0.05),
            cc.FadeOut:create(0.11),
            cc.MoveTo:create(0.1, self._startpos)
        ),
        cc.CallFunc:create(function()
            if self._isGlobal then
                qy.App.runningScene:dismissDialog()
            else
                self:getParent():removeFromParent()
            end
            if type(onDismissFinishListener) == "function" then
                onDismissFinishListener()
            end
        end)
    ))
end

function BaseDialog:onShowFinish()
    -- 弹窗动画完成后会执行该函数，需要在弹窗显示完成后执行逻辑的可以重写该函数
end

function BaseDialog:setCanceledOnTouchOutside(cancel)
    self._isCanceledOnTouchOutside = cancel
    return self
end

function BaseDialog:setOnDismissListener(listener)
    self._dismissListener = listener
    return self
end

return BaseDialog