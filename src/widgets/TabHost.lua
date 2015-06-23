--[[
    说明: 标签视图
    作者: 林国锋 <guofeng@9173.com>
    日期: 2014-11-13
]]

local TabHost = class("TabHost", qy.Widget.FormLayout)

--[[
    qy.Widget.TabHost.new({
        default = 1,
        size = {400, 400},
        tabs = {"英雄", "物品"},
        
        ["onCreate"] = function(tabHost, idx)
            return nil
        end,
        
        ["onTabClick"] = function(tabHost, idx)
        end
    })
]]

function TabHost:ctor(params)
    TabHost.super.ctor(self, params)

    -- 默认标签页
    self._currentIdx = 0
   
    self._views = {}

    self:_createTabWidget()
    
    self:registerScriptHandler(function(event)
        if event == "cleanup" then
            self:foreach(function(view)
                view:release()
            end)
        end
    end)

    self:switchTo(params.default or 1)
end

function TabHost:switchTo(idx)
    if self._currentIdx ~= idx then
        self:_onClick(idx, self:findViewByName("TabWidget_" .. idx))
    end
end

function TabHost:currentView()
    return self._currentView
end

function TabHost:foreach(callfunc)
    for idx, view in pairs(self._views) do
        callfunc(view)
    end
end

function TabHost:_onClick(idx, tabWidget)
    qy.M.playEffect("UI7.mp3")
    if self._params.onTabClick then
        self._params.onTabClick(self, idx)
    end
    
    tabWidget:setSelected(true)
    
    if self._lastTabWidget then
        self._lastTabWidget:setSelected(false)
    end
    
    self._lastTabWidget = tabWidget
    
    -- 显示相应的内容
    self:_switchToTabContent(idx)
end

function TabHost:_switchToTabContent(idx)
    -- 消除当前视图
    if self._currentView then
        self.Content:removeChild(self._currentView)
    end

    -- 显示新的视图
    local view = self._views[tostring(idx)]
    
    if view == nil then
        view = assert(self._params.onCreate(self, idx), "创建view失败")
        view:retain()
        self._views[tostring(idx)] = view
    end

    self.Content:addChild(view)

    -- 改变当前的状态值
    self._currentIdx = idx
    self._currentView = view
end

-- 创建标签按钮
function TabHost:_createTabWidget()
    for i,v in ipairs(self._params.tabs) do
        TabHost.Widget.new(i, v, function(tabWidget)
            self:_onClick(i, tabWidget)
        end, self._size):addTo(self)
    end
end

---------------
-- TabWidget --
---------------
TabHost.Widget = qy.View.Base.extend("TabWidget", "widget/TabWidget")

function TabHost.Widget:ctor(i, title, callback, size)
    TabHost.Widget.super.ctor(self)

    self:InjectView("Button")
    self:InjectView("UI_tips")

    self:OnClick(self.Button, function(sender)
        if self._isOpen then
            callback(self)
        else
            qy.Widget.Toast.make(self._noOpenText):show()
        end
    end)

    self:setName("TabWidget_" .. i)
    self:setLocalZOrder(-10)
    self:setPosition(cc.p(size.width, size.height - i * 90.0 + 35))

    self._isOpen = true
    self._normalcolor = cc.c3b(51, 188, 190)
    self._selectedcolor = cc.c3b(255, 210, 0)

    self.Button:setTitleText(" " .. title)
    self.Button:setTitleFontName(qy.res.FONT_NAME)
    self.Button:setTitleColor(self._normalcolor)
    self.Button:getTitleRenderer():enableOutline(cc.c4b(46, 40, 40, 255), 1)
end

function TabHost.Widget:setSelected(selected)
    self.Button:setEnabled(not selected)
    self.Button:setBright(not selected)
    self.Button:setTitleColor(selected and self._selectedcolor or self._normalcolor)
    self:setLocalZOrder(selected and 0 or -10)
end

function TabHost.Widget:setTips(visible)
    self.UI_tips:setVisible(visible)
end

function TabHost.Widget:setNoOpen(text)
    self._isOpen = false
    self._noOpenText = text
    self:setColor(cc.c3b(200, 200, 200))
end

return TabHost