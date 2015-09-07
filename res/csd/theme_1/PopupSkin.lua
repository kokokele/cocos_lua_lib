--------------------------------------------------------------
-- This file was automatically generated by Cocos Studio.
-- Do not make changes to this file.
-- All changes will be lost.
--------------------------------------------------------------

local luaExtend = require "LuaExtend"

-- using for layout to decrease count of local variables
local layout = nil
local localLuaFile = nil
local innerCSD = nil
local innerProject = nil
local localFrame = nil

local Result = {}
------------------------------------------------------------
-- function call description
-- create function caller should provide a function to 
-- get a callback function in creating scene process.
-- the returned callback function will be registered to 
-- the callback event of the control.
-- the function provider is as below :
-- Callback callBackProvider(luaFileName, node, callbackName)
-- parameter description:
-- luaFileName  : a string, lua file name
-- node         : a Node, event source
-- callbackName : a string, callback function name
-- the return value is a callback function
------------------------------------------------------------
function Result.create(callBackProvider)

local result={}
setmetatable(result, luaExtend)

--Create Node
local Node=cc.Node:create()
Node:setName("Node")
Node:setLocalZOrder(0)

--Create Bg
local Bg = ccui.Layout:create()
Bg:ignoreContentAdaptWithSize(false)
Bg:setBackGroundImage("assets_lib/bg/bg_4.png",0)

Bg:setClippingEnabled(false)
Bg:setBackGroundImageCapInsets(cc.rect(40,40,306,246))
Bg:setBackGroundColor(cc.c3b(150, 200, 255))
Bg:setBackGroundColor(cc.c3b(150, 200, 255),cc.c3b(255, 255, 255))
Bg:setBackGroundColorVector(cc.p(0,1))
Bg:setBackGroundColorType(0)
Bg:setBackGroundColorOpacity(102)
Bg:setBackGroundImageScale9Enabled(true)

Bg:setTouchEnabled(true)
Bg:setLayoutComponentEnabled(true)
Bg:setName("Bg")
Bg:setLocalZOrder(0)
Bg:setTag(39)
Bg:setCascadeColorEnabled(true)
Bg:setCascadeOpacityEnabled(true)
Bg:setVisible(true)
Bg:setAnchorPoint(0, 0)
Bg:setPosition(0, 0)
Bg:setScaleX(1)
Bg:setScaleY(1)
Bg:setRotation(0)
Bg:setRotationSkewX(0)
Bg:setRotationSkewY(0)
Bg:setOpacity(255)
Bg:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Bg)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(400, 400))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(0)
layout:setRightMargin(-400)
layout:setTopMargin(-400)
layout:setBottomMargin(0)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Bg)

--Create Button_Close
local Button_Close = ccui.Button:create()
Button_Close:ignoreContentAdaptWithSize(false)
Button_Close:loadTextureNormal("assets_lib/button/close_normal.png",0)
Button_Close:loadTexturePressed("assets_lib/button/close_normal.png",0)
Button_Close:loadTextureDisabled("Default/Button_Disable.png",0)
Button_Close:setTitleFontSize(20)
Button_Close:setTitleText("")
Button_Close:setTitleColor(cc.c3b(65, 65, 70))
Button_Close:setFlippedX(false)
Button_Close:setFlippedY(false)
Button_Close:setScale9Enabled(true)
Button_Close:setCapInsets(cc.rect(15,11,45,51))
Button_Close:setBright(true)
Button_Close:setTouchEnabled(true)
Button_Close:setLayoutComponentEnabled(true)
Button_Close:setName("Button_Close")
Button_Close:setLocalZOrder(0)
Button_Close:setTag(40)
Button_Close:setCascadeColorEnabled(true)
Button_Close:setCascadeOpacityEnabled(true)
Button_Close:setVisible(true)
Button_Close:setAnchorPoint(0, 0)
Button_Close:setPosition(368.5, 349.5)
Button_Close:setScaleX(1)
Button_Close:setScaleY(1)
Button_Close:setRotation(0)
Button_Close:setRotationSkewX(0)
Button_Close:setRotationSkewY(0)
Button_Close:setOpacity(255)
Button_Close:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Button_Close)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(75, 73))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(368.5)
layout:setRightMargin(-443.5)
layout:setTopMargin(-422.5)
layout:setBottomMargin(349.5)
layout:setStretchWidthEnabled(false)
layout:setStretchHeightEnabled(false)
Node:addChild(Button_Close)

--Create Container
local Container=cc.Node:create()
Container:setName("Container")
Container:setLocalZOrder(0)
Container:setTag(4)
Container:setCascadeColorEnabled(true)
Container:setCascadeOpacityEnabled(true)
Container:setVisible(true)
Container:setAnchorPoint(0, 0)
Container:setPosition(11, 13)
Container:setScaleX(1)
Container:setScaleY(1)
Container:setRotation(0)
Container:setRotationSkewX(0)
Container:setRotationSkewY(0)
Container:setOpacity(255)
Container:setColor(cc.c3b(255, 255, 255))
layout = ccui.LayoutComponent:bindLayoutComponent(Container)
layout:setPositionPercentXEnabled(false)
layout:setPositionPercentYEnabled(false)
layout:setPositionPercentX(0)
layout:setPositionPercentY(0)
layout:setPercentWidthEnabled(false)
layout:setPercentHeightEnabled(false)
layout:setPercentWidth(0)
layout:setPercentHeight(0)

layout:setSize(cc.size(0, 0))

layout:setHorizontalEdge(0)
layout:setVerticalEdge(0)
layout:setLeftMargin(11)
layout:setRightMargin(-11)
layout:setTopMargin(-13)
layout:setBottomMargin(13)
Node:addChild(Container)

--Create Animation
result['animation'] = ccs.ActionTimeline:create()
  
result['animation']:setDuration(0)
result['animation']:setTimeSpeed(1)
--Create Animation List

result['root'] = Node
return result;
end

return Result

