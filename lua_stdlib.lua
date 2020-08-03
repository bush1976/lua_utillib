-- 2020/8/3
--单精度浮点数转16进制
function floatToHex(p1)
	print("floatToHex")
	print(p1)

	local d = tonumber(p1)
	local sign = 0
	local expo = 0
	local mant = 0

	if d > 0 then
		sign = 0
	else
		sign = 1
		d = d * -1
	end

	expo = d-d%1
	mant = d%1

	local expo_str = bit_d2b(expo)
	print("sign = ", sign)
	print("expo = ", expo)
	print("mant = ", mant)
	print("expo_str = ", expo_str)
	

	a = 0.5
	b = 0.0
	c = 0.0
	offset = 0.0
	val = mant
	local str = ""
	for i=1, 23, 1 do
		c = val / a
		if c > 1 then
			str = str .. "1"
			val = val - a
		else
			str = str .. "0"
		end
		b = a / 2
		a = b
	end

	print("str = ", str)

	mant_str = string.sub(str, 0, 23 - string.len(expo_str) + 1)
	newstr = string.sub(expo_str, 2, string.len(expo_str)) .. mant_str
	firststr = string.sub(newstr, 0, 1)
	bstr = 127 + string.len(expo_str) - 1
	bstr_b = bit_d2b(bstr)
	while string.len(bstr_b) < 8 do
		bstr_b = "0"..bstr_b
	end
	result = sign ..bstr_b .. newstr

	print("mant_str = ", mant_str)
	print("newstr = ", newstr)
	print("firststr = ", firststr)
	print("bstr = ", bstr, bstr_b)
	print("result = ", result)
	

	d1=bit_b2d(string.sub(result, 0, 32))
	r1=string.format("%08X",d1)	

	print("r1 = ", r1)
	r = string.sub(r1, 7, 8)..string.sub(r1, 5, 6)..string.sub(r1, 3, 4)..string.sub(r1, 1, 2)
	--print(r)

	return r
end


 --双精度浮点数转16进制
 function doubleToHex(p1)
	print("doubleToHex")
	print(p1)

local d = tonumber(p1)
local sign = 0
local expo = 0
local mant = 0

if d > 0 then
	sign = 0
else
	sign = 1
	d = d * -1
end

expo = d-d%1
mant = d%1

local expo_str = bit_d2b(expo)

a = 0.5
b = 0.0
c = 0.0
offset = 0.0
val = mant
local str = ""
for i=1, 52, 1 do
	c = val / a
	if c > 1 then
		str = str .. "1"
		val = val - a
	else
		str = str .. "0"
	end
	b = a / 2
	a = b
end

print(str)
print(expo_str)

mant_str = string.sub(str, 0, 52 - string.len(expo_str) + 1)
newstr = string.sub(expo_str, 2, string.len(expo_str)) .. mant_str
firststr = string.sub(newstr, 0, 1)
bstr = 1023 + string.len(expo_str) - 1
bstr_b = bit_d2b(bstr)
while string.len(bstr_b) < 11 do
	bstr_b = "0"..bstr_b
end
result = sign .. bstr_b .. newstr

d1=bit_b2d(string.sub(result, 0, 32))
d2=bit_b2d(string.sub(result, 32, 64))
--print(d1)
--print(d2)
r1=string.format("%08X",d1)	
r2=string.format("%08X",d2)

r = string.sub(r2, 7, 8)..string.sub(r2, 5, 6)..string.sub(r2, 3, 4)..string.sub(r2, 1, 2)..string.sub(r1, 7, 8)..string.sub(r1, 5, 6)..string.sub(r1, 3, 4)..string.sub(r1, 1, 2)
--print(r)

return r
end



--有符号整数补码计算2字节
--bsh 2018-09-19
function buma_2byte(p1)
	local symbol
	local MAX = 4294967295
	local m
	local bp
	local bp1, bp2, bp3, bp4
	local hp1, hp2, hp3, hp4
	local r

	if p1 >= 0 then
		symbol = 0
		bp = bit_d2b3(p1)
	else
		symbol = 1
		m = MAX + p1
		bp = bit_d2b3(m)
		print(m)
	end
	print(symbol, bp)

	while string.len(bp)%32 > 0 do
        bp="0"..bp
	end
	print(bp)
	bp1 = string.sub(bp, 1, 8)
	bp2 = string.sub(bp, 9, 16)
	bp3 = string.sub(bp, 17, 24)
	bp4 = string.sub(bp, 25, 32)
	hp1 = bit_b2h_1byte(bp1)
	hp2 = bit_b2h_1byte(bp2)
	hp3 = bit_b2h_1byte(bp3)
	hp4 = bit_b2h_1byte(bp4)
	print(bp1, hp1)
	print(bp2, hp2)
	print(bp3, hp3)
	print(bp4, hp4)

	r = andOper1Byte(hp1, "FF")..andOper1Byte(hp2, "FF")..andOper1Byte(hp3, "FF")..andOper1Byte(hp4, "FF")
	print(r)
 end

 --按位与操作(1byte)
 --bsh 2018-09-19
 function andOper1Byte(p1, p2)
	local t1 = "0x"..p1
	local t2 = "0x"..p2
	local c1 = tonumber(t1)
	local c2 = tonumber(t2)
	local bstr1 = bit_d2b3(c1)
	local bstr2 = bit_d2b3(c2)
	local b1
	local b2

	local r = ""
	for i=1, 8, 1 do
		b1 = tonumber(string.sub(bstr1, i, i))
		b2 = tonumber(string.sub(bstr2, i, i))
		if b1 == 1 and b2 == 1 then
			r = r.."1"
			temp = 1
		else
			r = r.."0"
			temp = 0
		end
		--print(i, b1, b2, temp)
	end

	rhex = bit_b2h_1byte(r)

	--print(r, rhex)
	return rhex
 end

--异或操作(2byte)
function xorOper2Byte(p1, p2)
	local r = ""

	preH = string.sub(p1, 1, 2)
	preL = string.sub(p1, 3, 4)
	comH = string.sub(p2, 1, 2)
	comL = string.sub(p2, 3, 4)

	r = xorOper1Byte(preH, comH)..xorOper1Byte(preL, comL)
	--print(r)
	return r
end

--异或操作(1byte)
function xorOper1Byte(p1, p2)
	local t1 = "0x"..p1
	local t2 = "0x"..p2
	local c1 = tonumber(t1)
	local c2 = tonumber(t2)
	local bstr1 = bit_d2b3(c1)
	local bstr2 = bit_d2b3(c2)
	local b1
	local b2

	local r = ""
	for i=1, 8, 1 do
		b1 = tonumber(string.sub(bstr1, i, i))
		b2 = tonumber(string.sub(bstr2, i, i))
		if b1 == b2 then
			r = r.."0"
			temp = 0
		else
			r = r.."1"
			temp = 1
		end
		--print(i, b1, b2, temp)
	end

	rhex = bit_b2h_1byte(r)

	--print(r, rhex)
	return rhex
end



function bit_b2d(arg)--2进制转整数
    local nr=0
    for i=1,string.len(arg),1 do
        b=string.sub(arg,i,i)
        if b=="1" then
            nr=nr+2^(string.len(arg)-i)
        end
    end
    return nr
end

function bit_d2b(arg)--整数转2进制
    local br=""
    local offset=0
    local v=tonumber(arg)
    v=v-v%1
    
    if v==0 then
        return "0"
    end

    while v>0 do
        v=v/2
        offset=v%1
        if offset>0 then
            br="1"..br
        else
            br="0"..br
        end
        v=v-offset
    end

    return br
end

function bit_d2b2(arg)--整数转2进制，将长度补齐为4的整数倍
    local br=""
    local offset=0
    local v=tonumber(arg)
    v=v-v%1
    
    if v==0 then
        return "0000"
    end

    while v>0 do
        v=v/2
        offset=v%1
        if offset>0 then
            br="1"..br
        else
            br="0"..br
        end
        v=v-offset
    end

    while string.len(br)%4 > 0 do
        br="0"..br
    end
    
    local arglen = string.len(arg)-2
    while string.len(br) < arglen*4 do
        br="0"..br
    end

    return br
end

function bit_d2b3(arg)--整数转2进制，将长度补齐为8的整数倍，最大处理长度为4个字节，相当于长度为8的16进制字符串
    local br=""
    local offset=0
    local v=tonumber(arg)
	v=v-v%1
    
    if v==0 then
        return "00000000"
    end

    while v>0 do
        v=v/2
        offset=v%1
        if offset>0 then
            br="1"..br
        else
            br="0"..br
        end
        v=v-offset
    end

    while string.len(br)%8 > 0 do
        br="0"..br
	end
    
	local arglen = string.len(arg)-2
    while string.len(br) < arglen*4 do
        br="0"..br
    end

    return br
end

--整数转2进制，将长度补齐为8的整数倍，最大处理长度为4个字节，相当于长度为8的16进制字符串
--@arg	整数
--@len	结果几个字节有效，如果为1，输出结果8bit，如果为2，输出结果16bit
--bsh 2018-11-06
function bit_d2b4(arg, len)
    local br=""
    local offset=0
    local v=tonumber(arg)
    v=v-v%1
    
    if v==0 then
        return "00000000"
    end

    while v>0 do
        v=v/2
        offset=v%1
        if offset>0 then
            br="1"..br
        else
            br="0"..br
        end
        v=v-offset
    end

    while string.len(br)%8 > 0 do
        br="0"..br
    end
    
    local arglen = string.len(arg)-2
    while string.len(br) < len*8 do
        br="0"..br
    end

    return br
end

function bit_h2b(arg)--16进制转2进制字符串
    local br=""
    br=bit_d2b("0x"..arg)
    return br
end

function bit_h2b2(arg)--16进制转2进制字符串，将长度补齐为4的整数倍
    local br=""
    br=bit_d2b2("0x"..arg)
    return br
end

--16进制转2进制字符串，将长度补齐为8的整数倍
--bsh 2018-09-19
function bit_h2b3(arg)
    local br=""
    br=bit_d2b3("0x"..arg)
    return br
end

function bit_b2h(arg)
    nr=bit_b2d(arg)
    r=string.format("%01X",nr)
    return r
end

function bit_b2h_1byte(arg)--2进制字符串转16进制字符，1个字节长度
	d=bit_b2d(arg)
	r=string.format("%02X",d)	
	return r
end

function bit_b2h_2byte(arg)--2进制字符串转16进制字符，2个字节长度
	local br = ""
	br = arg
	while string.len(br)%16 > 0 do
        br="0"..br
	end
	local d1 = bit_b2d(string.sub(br,1,8))
	local d2 = bit_b2d(string.sub(br,9,16))
	local r = string.format("%02X",d1)..string.format("%02X",d2)
	return r
end


function get_bits(content,len)--由2进制数据得到希望长度的2进制数据
	local r=content
	if string.len(content)<len then
		for i=1,len-string.len(content) do
			r="0"..r
		end
	else
		i=string.len(content)-len
		r=string.sub(r,i+1)
	end
	return r
end

function get_bytes(content)--由2进制转换为16进制，传入数据的长度需和字节数匹配好
	local r="";
	local len=string.len(content)
	len=len/8
	for i=1,len do
		--print(string.sub(content,(i-1)*8+1,i*8))
		r=r..bit_b2h_1byte(string.sub(content,(i-1)*8+1,i*8))
	end
	return r
end



function get_nor(p1,p2,num)--2进制异或计算
	local r=""
	for i=1,num do
		if string.sub(p1,i,i)==string.sub(p2,i,i) then
			r=r.."0"
		else
			r=r.."1"
		end
	end
	return r
end

function move_left(data,num)--左移
	data=string.sub(data,num+1)
	for i=1,num do
		data=data.."0"
	end
	return data
end

function move_right(data,num)--右移
	data=string.sub(data,1,string.len(data)-num)
	for i=1,num do
		data="0"..data
	end
	return data
end

--10进制数转换为4字节十六进制补码
--p1:10进制数
function ToBuMa(p1)
	local signal
	if(p1>=0) then 
		signal="plus"
	else
		signal="minus"
	end
	local x
	local y=""
	if(signal=="plus") then
		x=bit_d2b3(p1)
	else 
		x=bit_d2b3(p1*(-1))
	end
	
	--补齐至32位
	while (string.len(x)<32)
	do
		x="0"..x
	end
	--print(x)--正数就是x了
	
	--负数求反
	if(signal=="minus") then
		for i=2,32 do
			if string.sub(x,i,i)=="0" then
				y=y.."1"
			else 
				y=y.."0"
			end
		end
		x="1"..y
		y=""
		local s="add"
		for i=32,1,-1 do
			if s=="add" then
				if string.sub(x,i,i)=="1" then
					y="0"..y
				else
					y="1"..y
					s=""
				end
			else
				y=string.sub(x,i,i)..y
			end
		end
		--print(y)
	else
		y=x
	end
	y=get_bytes(y)
	--print(y)
	return y
end

--4字节十六进制补码转有符号整数
--p1:16进制字符串
--2018-12-26
--bsh
function HexToInt_BuMa_4byte(p1)
	local data = p1
	local len = string.len(data)
	if len > 8 then
		return nil
	end
	while (string.len(data)<8)
	do
		data="0"..data
	end
	local ch = string.sub(data,1,2)
	ch = bit_h2b3(ch)
	local signal = string.sub(ch,1,1)

	local r
	if signal == "1" then
		r = tonumber("FFFFFFFF", 16) - tonumber(p1, 16) + 1
		r = -1 * r
	else
		r = tonumber(p1, 16)
	end
	
	return r
end


function bitcrc(arg)--奇偶校验位计算
    print(arg)
    local b0=string.sub(arg,1,1)
    for i=2,string.len(arg) do
        b=string.sub(arg,i,i)
        if b==b0 then
            b0="0"
        else
            b0="1"
        end
    end
    return b0
end


function paramreverse(str)
	local r=0 
	for i=string.len(str)-1,0,-2 do
		s = string.sub(str,i,i+1)
		r = r .. s
	end
	return string.sub(r,2,-1)
end

function strtohex(p1,p2,p3,p4,p5,p6,p7,p8)
  
	b1=tonumber(p1)*128+tonumber(p2)*64+tonumber(p3)*32+tonumber(p4)*16+tonumber(p5)*8+tonumber(p6)*4+tonumber(p7)*2+tonumber(p8)
	b2=string.format("%02x",b1)
	return b2
end

function util_ftoi(p1)--小数进行四舍五入
	f = tonumber(p1)
	dec = f%1
	if dec >= 0.5 then
		return math.ceil(f)
	else 
		return math.floor(f)
	end
end

function currDir()  
    os.execute("cd > cd.tmp")  
    local f = io.open("cd.tmp", r)  
    local cwd = f:read("*a")  
    f:close()  
    os.remove("cd.tmp")  
    return cwd  
end 
