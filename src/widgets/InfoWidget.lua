--[[
    vip显示页头部信息，充值页头部信息（公用）
]]

local InfoWidget = class("InfoWidget", qy.View.Base)

InfoWidget.__create = function(delegate, csbFile)
    return InfoWidget.super.__create(csbFile or "widget/InfoWidget")
end

-- local InfoWidget = class("InfoWidget", function()
--     return qy.View.Base.new(csbFile or "widget/InfoWidget")
-- end)

local model = qy.Model.Vip
local userModel = qy.Model.User
function InfoWidget:ctor(delegate)
    InfoWidget.super.ctor(self)

    self:InjectView("Level_1")
    self:InjectView("Level_2")
    self:InjectView("rmb")
    self:InjectView("Text_1")
    self:InjectView("diamond")
    self:InjectView("Text_2")
    self:InjectView("vip_2")
    self:InjectView("LoadingBar")
    self:InjectView("Button_3")
    self:InjectView("pro")
    if delegate.isReCharge == true then
        self.Button_3:setTitleText("充值")
    else
        self.Button_3:setTitleText("特权")
    end

    self:OnClick(self.Button_3, function(sender, touchPos)
        if delegate then
            if delegate.isReCharge == true then
                if delegate.onRecharge then
                    delegate.onRecharge(touchPos)
                else
                    print("没有此方法")
                end
            else
                if delegate.onVip then
                    delegate.onVip(touchPos)
                else
                    print("没有此方法")
                end
            end
        end
    end)

    self:setInfo()
    
end

function InfoWidget:setInfo()
    local level = userModel.Vip and userModel.Vip.level_:get() or 0
    local already_rmb = userModel.info.payment_gem_added_:get()

    local level1_ = level + 1
    local level2_ = level + 2
    if level2_ > 16 then
        level2_ = 16
    end
    if level1_ > 16 then
        level1_ = 16
    end

    local data = model:getLevel(level1_)
    local data2 = model:getLevel(level2_)
    local rmb = data2.rmb_:get() - already_rmb
    local rmb_add = data2.rmb_:get() - (data and data.rmb_:get() or 0)
    local rmb_add2 = already_rmb - (data and data.rmb_:get() or 0)

    if rmb_add2 < 0 then
        rmb_add2 = 0
    end
    
    if rmb < 0 then
        rmb = "XXXX"
    end
    self.Level_1:setString(level)
    local level2 = level + 1
    self.Level_2:setString(level2)
    self.rmb:setString(rmb)

    if rmb_add2 > rmb_add then
        rmb_add2 = rmb_add
    end
    self.LoadingBar:setPercent(math.floor(rmb_add2 * 100 / rmb_add))
    self.pro:setString(rmb_add2 .. "/" .. rmb_add)
    if level2 > model:getNum() - 1 then      
        self.rmb:setVisible(false)
        self.Text_1:setVisible(false)
        self.diamond:setVisible(false)
        self.Text_2:setVisible(false)
        self.vip_2:setVisible(false)
        self.Level_2:setVisible(false)
    end
end

return InfoWidget