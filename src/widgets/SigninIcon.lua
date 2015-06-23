
local SigninIcon = qy.View.Base.extend("SigninIcon", "modules.signin.Icon")

function SigninIcon:ctor(delegate)
    SigninIcon.super.ctor(self)

    self:InjectCustomView("UI_icon", qy.Widget.Icon, delegate)

    self:InjectView("reciver")
    self:InjectView("alreadyGet")
    self:InjectView("vip")
    self:InjectView("Img_vip")
    self:InjectView("Bg")
    self:InjectView("Bg3")
    self.Bg:setSwallowTouches(false)
    self.reciver:setSwallowTouches(false)
    self:setDone(false)  
end

-- 
function SigninIcon:setData(item)
    local rewardData = item.reward_:get()
    local reward = qy.Model.Backpack:getById(rewardData[1].tag)
    local icon = reward:iconEntity()

    self.UI_icon:setData(icon)
    self.UI_icon.Text_num:setString("X" .. rewardData[1].num)

    self:setEnableAward(item.enable_:get())
    self:setVip(item.vipData_:get() ~= 0)
    self.item = item
    self:setDone(item.done_:get())
    if item.vip_:get() > 0 then
        self.Img_vip:setTexture("Resources/signIn/pic_num_sign" .. item.vip_:get() .. ".png")
    end
end

-- 是否可签到
function SigninIcon:setEnableAward(flag)
    if flag == 2 then
        self.Bg3:setVisible(true)
        self.Bg3:setBackGroundImage("Resources/signIn/pic_sign_2.jpg")
    elseif flag == 1 then
        self.Bg3:setVisible(true)
        self.Bg3:setBackGroundImage("Resources/signIn/pic_sign_1.jpg")
    else
        self.Bg3:setVisible(false)
    end
end

-- 更新实体数据
function SigninIcon:setEntityEable(flag)
    self.item.enable_:set(flag)
    self:setEnableAward(flag)
end

-- 已经签到
function SigninIcon:setDone(flag)
    if self.item then
        self.item.done_:set(flag)
    end
    self.reciver:setVisible(flag)
    self.alreadyGet:setVisible(flag)
end

function SigninIcon:setVip(flag)
    self.vip:setVisible(flag)
end

return SigninIcon