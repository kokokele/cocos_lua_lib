--[[
    说明: 窗体布局
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-11-22
]]

local FormLayout = qy.View.Base.extend("FormLayout", "widget/FormLayout")

--[[
    size: 大小
    
    qy.Widget.FormLayout.new({
        size = {400, 400},
    })
]]

function FormLayout:ctor(params)
    FormLayout.super.ctor(self)

    -- 内容区
    self:InjectView("Content")
    self:InjectView("Shadow_top")
    self:InjectView("Shadow_down")
    self:InjectView("Frame")
    self:InjectView("Close")

    self._params = params
    
    -- 默认大小
    self._size = cc.size(params.size[1] or 400, params.size[2] or 400)

    self:_onSizeChanged()
end

-- 大小改变
function FormLayout:_onSizeChanged()
    -- 内容区
    self.Content:setContentSize(self._size)
    
    self.Frame:setContentSize(self._size.width + 24, self._size.height + 24)

    self.Shadow_top:setPositionY(self._size.height + 18)
    self.Shadow_top:setContentSize(self._size.width + 4, 33)

    self.Shadow_down:setContentSize(self._size.width + 4, 33)

    self.Close:setPosition(cc.p(self._size.width + 24, self._size.height + 16))
    self.Close:setVisible(false)
end

-- 显示关闭按钮
function FormLayout:showCloseButton(callback)
    self.Close:setVisible(true)
    self:OnClick(self.Close, callback)
end

function FormLayout:getSize()
    return self._size
end

function FormLayout:setShadowVisible(visible)
    self.Shadow_top:setVisible(visible)
    self.Shadow_down:setVisible(visible)
end

return FormLayout