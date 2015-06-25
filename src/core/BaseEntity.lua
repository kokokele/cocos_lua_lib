--[[
  
    usage:

        local Hero = class("Hero", app.D)

        function Hero:ctor()
            self:setproperty({"level", 10, didSet = function(level)
                print(self.name .. " 等级变成" .. level)
            end})

            -- didSet 方法会在level的值发生变化的时候自动调用, 实现值的观察
        end
]]

local BaseEntity = class("BaseEntity", require("core.Singal"))

--[[
    增加一个属性, 每个属性都是一个表, 具有名字与值, 还有get/set/willSet/didSet函数
    属性会绑定到self[name .. "_"], 注意不要覆盖了
    值的更新会触发willSet/didSet两个函数, 方便做值的监听

    比如:
        self:setproperty("id", 10, willSet = function(id, oldValue, newValue)
            print("值将更新为: " .. newValue)
        end, didSet = function(id)
            print("值更新完了")
        end)

        print(self.id_.value)
        self.id_:set(100)
        print(self.id_:get())
        self.id_ = 123
        print(self.id_)
]]
function BaseEntity:setproperty(property)
    assert(property, "property不能为空")

    assert(type(property) == "table", "参数必须是一个table表类型")

    -- 值准备更新
    if property[6] then property.willSet = property[6] end

    -- 值更新了
    if property[5] then property.didSet = property[5] end

    -- 设置值
    if not property.set then
        property.set = property[4] or function(self, value)
            self.value = value
        end
    end

    -- 获取值
    if not property.get then
        property.get = property[3] or function(self)
            return self.value
        end
    end
    
    property.eq = function(self, value)
        return self.value == value
    end

    property.tostring = function(self)
        return tostring(self:get())
    end

    -- 元表
    property.mt = {
        name = property.name or property[1],
        value = property.value or property[2],

        __index = function(t, k)
            return t.mt[k]
        end,

        __newindex = function(t, k, v)
            if k == "value" then
                local oldvalue = t.mt.value
                -- 值改变关调用willSet
                if t.willSet then
                    t.willSet(t, oldvalue, v)
                end
                -- 正式改变值
                t.mt.value = v
                -- 值改变了调用didSet
                if t.didSet then
                    t.didSet(t, oldvalue)
                end

                -- 触发观察者
               self:fire(t.mt.name, v)

            elseif k == "didSet" or k == "willSet" then
                rawset(t, k, v)
            else
                assert(false, t.name .. " 属性不可增加其它特性")
            end
        end,

        __add = function(t, v)
            return type(t.mt.value) == "number" and (t.mt.value + v) or (t.mt.value .. v)
        end,

        __eq = function(t, v)
            return type(t) == "table" and (t.mt.value == v) or (t == v.mt.value)
        end,

        __concat = function(t1, t2)
            return type(t1) == "table" and (t1.mt.value .. t2) or (t1 .. t2.mt.value)
        end,

        __tostring = property.tostring
    }

    assert(property.mt.name, "参数name不能为空")
    assert(type(property.mt.name) == "string", "参数name类型必须是string")

    -- 值为表，增加insert方法
    if type(property[2]) == "table" or type(property.value) == "table" then
        -- 数组插入
        property.insert = function(self, value)
            table.insert(self.mt.value, value)
            if property.didSet then
                property.didSet(property)
            end
        end
        -- 数组删除
        property.remove = function(self, index)
            table.remove(self.mt.value, index)
            if property.didSet then
                property.didSet(property)
            end
        end
        -- 数组查找，反正下标
        property.find = function(self, value)
            for i, v in ipairs(self.value) do
                if v == value then
                    return i
                end
            end
            return 0
        end

        property.at = function(self, key)
            return self.mt.value[key]
        end

        -- 大小
        property.size = function(self)
            return table.nums(self.mt.value)
        end

        -- 遍历
        property.foreach = function(self, callback)
            for k, v in pairs(self.mt.value) do
                callback(k, v)
            end
        end

        -- 排序
        property.sort = function(self, callback)
            table.sort(self.mt.value, callback)
        end
    end

    -- clear
    property[1] = nil
    property[2] = nil
    property.name = nil
    property.value = nil

    -- 绑定
    self[property.mt.name .. "_"] = setmetatable(property, property.mt)
end


--[[
    判断name属性在不在, 存在并返回

    local f, v = self:isproperty("id")
    if f then print(v) end
]]
function BaseEntity:isproperty(name)
    return type(self[name .. "_"]) == "table", self[name .. "_"]
end

function BaseEntity:updateAll(data)
    for name, value in pairs(data) do
        self:set(name, value)
    end
end

function BaseEntity:set(property_name, property_value)
    local f, p = self:isproperty(property_name)
    if f then
        p:set(property_value)
    end
end

return BaseEntity