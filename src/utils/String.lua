--[[
	字符串工具
	Author: Wei Long
	Date: 2014-12-19 21:14:27
]]

local String = {}

-- UTF8字符解析
function String.getByteSizeUTF8(byte)
	local size = nil
	if byte < 128 then
		size = 1
    elseif byte < 194 then
    	size = 2
    elseif byte < 224 then
        size = 2
    elseif byte < 240 then
        size = 3
    elseif byte < 248 then
        size = 4
    elseif byte < 252 then
        size = 5
    elseif byte < 254 then
        size = 6
    end
	return size
end

-- 获取原字符串总共多少个字，将字节数转化为字数
function String.getLengthUTF8(str)
	local byte_len = string.len(str)
	local char_len = 0
	local i = 1
	-- print("byte_len ="..byte_len)
    while i <= byte_len do
   		local byte = string.byte(str,i)
   		i = i + String.getByteSizeUTF8(byte)
   		char_len = char_len + 1
    end
    return char_len
end

function String.charAtUTF8(str,idx)
	local byte_len = string.len(str)
	local char_len = 0
	local i = 1
   	local startIndex,endIndex = 1,1
    while i <= byte_len do
   		local byte = string.byte(str,i)
   		char_len = char_len + 1
   		if char_len == idx then
    		startIndex = i
   			endIndex = i + String.getByteSize(byte) - 1
   			return string.sub(str,startIndex,endIndex)
   		end
   		i = i + String.getByteSize(byte)
    end
	return nil
end

function String.substringUTF8(str,_startIndex,_endIndex)
	local byte_len = string.len(str)
	local char_len = 0
	local i = 1
	local startIndex,endIndex = 1,1
    while i <= byte_len do
   		local byte = string.byte(str,i)
   		char_len = char_len + 1
   		if char_len == _startIndex then
   			startIndex = i
   		end

   		i = i + String.getByteSizeUTF8(byte)
   		if char_len == _endIndex then
   			endIndex = i - 1
   			return string.sub(str,startIndex,endIndex)
   		end
    end
	return nil
end

function String.substrUTF8(str,_startIndex,_len)
	local byte_len = string.len(str)
	local char_len = 0
	local i = 1
	local startIndex,endIndex,len = nil,nil,1
    while i <= byte_len do
   		local byte = string.byte(str,i)
   		char_len = char_len + 1
   		if char_len == _startIndex then
   			startIndex = i
   			len = char_len
   		end

   		i = i + String.getByteSize(byte)
   		if char_len - len == _len - 1 then
   			endIndex = i - 1
   			return string.sub(str,startIndex,endIndex)
   		end
    end
	return "fuck"
end

function String.indexOfUTF8(str,vol,_startIndex)
end

-------------------------------------------------------

return String
