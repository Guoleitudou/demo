local cfg = {}

local cfgdata = {}

cfg._apiver = 30
--cfg._smacct = "yk"
cfg._smacct = ""
cfg._sminfo = 3
cfg._smold = nil
cfg._smtime = 0
cfg._sm15time = 0
cfg._smpay = 0

function cfg.isupload()
    if(cfg.issm()) then
        if(cfg.issmoff()) then
            if(cfg._sminfo == 0 and cfg.sm_isold()) then--succ
                return true
            end
        else
            return true
        end
    end
    return false
end

function cfg.issm()
	if(g_data._info._userid == "******") then 
		local st = Cfg.get("notice2").showgfsm
		--if(g_data._partner ~=  and g_data._partner ~=  and g_data._partner ~=  and g_data._partner ~=  and g_data._partner ~=  and g_data._partner ~= ) then
		for k,v in pairs(st) do
			if(g_data._partner == v) then
				return Data.getNoticeZhi(73)
			end
		end
		return false
	end
	
    return Data.getNoticeZhi(73)
    --return false
	--return true
end

function cfg.issmoff() --black on
    local cf = Cfg.get("misc").smonline
    if(cf and cf == false) then return true end
    return false
end

function cfg.gettaskid(id)
	local js = Cfg.get("task")
	for k,v in pairs(js.activity_task) do
		if(v.task_id == id) then
			return v.tag_value
		end
	end
end

function cfg.gettask(tp,id)
	local js = Cfg.get("task")
	for k,v in pairs(js[tp]) do
		--print(k,v.id,v.bonus)
		if(v.id == id) then
			return v
		end
	end
end

function cfg.checkzc()
	local js = Cfg.get("activity2").callrich_consume
	local d = tonumber(string.sub(js,10,-1))
	myprint("checkzc",d,Cfg.getpropcount(1043001))
	if(Cfg.getpropcount(1043001) >= d) then
		return true
	else
		return false
	end
end

function cfg.weektime()
	local js = os.date("*t")
	local y = js.year
	local m = js.month
	local d = js.day
	local w = js.wday
	w = w - 1
	if(w <= 0) then w = 7 end
	w = w - 1
	
	myprint(y,m,d,w,os.date("%Y-%m-%d",os.time() - w*24*60*60),os.date("%Y-%m-%d",os.time() + (7-w-1)*24*60*60))
	return (os.date("%Y/%m/%d",os.time() - w*24*60*60)).."-"..os.date("%Y/%m/%d",os.time() + (7-w-1)*24*60*60)
end

function cfg.gettzinfo(data)
	local lv = data[1]
	if(lv > data[2]) then
		lv = data[2]
	end
	if(lv > data[3]) then
		lv = data[3]
	end
	
	return lv
end

function cfg.getsqjl(id,pid)
	if(not cfg._sq) then
		cfg._sq = {10,10,10}
	end
	
	
	local n = 0
	local idx = 0
	if(id == "zz") then
		local tzlv = cfg.gettzinfo(cfg._sq) - 1
		if(tzlv > 0) then
			local js = Cfg.get("activity2").artifact_set
			local id = 0
			for i=1,#(js[1][4]) do
				if(tzlv >= js[1][4][i]) then
					id = i
				end
			end
			if(id > 0) then
				n = js[1][5][id]
			end
		end
	else
		if(id == "jjj") then
			idx = 1
		elseif(id == "zxjl") then
			idx = 2
		elseif(id == "yl") then
			idx = 3
		elseif(id == "qd") then
			idx = 4
		elseif(id == "xyzh") then
			idx = 5
		elseif(id == "jssl") then
			idx = 6
		elseif(id == "sb") then
			idx = 7
		elseif(id == "sld") then
			idx = 8
		elseif(id == "lgsw") then
			idx = 9
		else
			myprint("error sq id")
		end
		if(idx == 3) then
			myprint(id,pid)
			local js = Cfg.get("activity2").artifacts
			local function getN(data,pid)
				for i = 1,#data do
					if(data[i][1] == pid) then
						return data[i][2]
					end
				end
				return 0
			end
			n = getN(js[1].attr[cfg._sq[1]][idx],pid)
			n = n + getN(js[2].attr[cfg._sq[2]][idx],pid)
			n = n + getN(js[3].attr[cfg._sq[3]][idx],pid)
		elseif(idx > 0) then
			myprint(id,pid,idx,cfg._sq[1],cfg._sq[2],cfg._sq[3])
			local js = Cfg.get("activity2").artifacts
			if(cfg._sq[1] > #(js[1].attr)) then
				myprint("error idx1",#(js[1].attr),cfg._sq[1])
			else
				n = js[1].attr[cfg._sq[1]][idx]
			end
			if(cfg._sq[2] > #(js[2].attr)) then
				myprint("error idx1",#(js[2].attr),cfg._sq[2])
			else
				n = n + js[2].attr[cfg._sq[2]][idx]
			end
			if(cfg._sq[3] > #(js[3].attr)) then
				myprint("error idx1",#(js[3].attr),cfg._sq[3])
			else
				n = n + js[3].attr[cfg._sq[3]][idx]
			end
		end
	end
	
	return n
end

function cfg.isChCanrun()
	local hour = tonumber(os.date("%H", Data.getGameTime()))
	--local hour = tonumber(os.date("%H", os.time()))
	myprint("hour",hour)
    if(hour >= 20 and hour < 21) then
		if(cfg.isJR2()) then
			return true
		end
	end
    return false
end

function cfg.getdeviceid()
    if(L_getdevicetype() == "WIN") then
        return g_data._info._uid..""
    else
        return L_getdeviceID()
    end
end

function cfg.getsmacct()
    --local acct,pass = Cfg.getAutouser()
    --if(acct) then
    --	if(string.sub(acct,1,2) == "m-")then
    --        cfg._smacct = "yk"
    --    else
    --        cfg._smacct = ""
    --    end
    --else
        cfg._smacct = ""
    --end
end

function cfg.isykacct()
    if(cfg._smacct == "yk") then
        local acct,pass = Cfg.getAutouser()
        if(acct) then
            if(string.sub(acct,1,2) == "m-")then
                cfg._smacct = "yk"
                return true
            else
                cfg._smacct = ""
            end
        end
    end
    return false
end

function cfg.istoday(day)
	local nowTime = Data.getGameTime()
	
    local d = os.date("%d",nowTime)
    local m = os.date("%m",nowTime)
    local y = os.date("%Y",nowTime)
    
	local td = tonumber(string.sub(y,3,4)..m..d)
    myprint("today is", td)
    if(day == td) then
        myprint("is today", day)
        return true
    end
    return false
end

function cfg.isJR()
    --local ti = os.time({year=string.sub(cfg._smbirt,1,4),month=string.sub(cfg._smbirt,5,6),day=string.sub(cfg._smbirt,7,8)})
    --local ti = os.time({year=2020,month=05,day=17})
    --local ti2 = Data.getGameTime() - ti
    local days = Cfg.get("misc").holiday_cfg
    if(days) then
        local nowTime = Data.getGameTime()
	    local d = os.date("%d",nowTime)
        local m = os.date("%m",nowTime)
        local y = os.date("%Y",nowTime)
        local ts = days[y]
        if(ts) then
            local dd = m..d
            if(ts[dd]) then
                re = ts[dd]
                myprint("get the config misc", re)
                return re
            end
        end
    end
    
    local _WEEK = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }
    local w = tonumber(os.date("%w", Data.getGameTime()))
    local re = false
    if(w == 0 or w == 6) then
        re = true
    end
    --myprint("xingqi ji",w,_WEEK[w+1],re)
    return re
end

function cfg.isJR2()
    --local ti = os.time({year=string.sub(cfg._smbirt,1,4),month=string.sub(cfg._smbirt,5,6),day=string.sub(cfg._smbirt,7,8)})
    --local ti = os.time({year=2020,month=05,day=17})
    --local ti2 = Data.getGameTime() - ti
    local days = Cfg.get("misc").holiday_cfg
    if(days) then
        local nowTime = Data.getGameTime()
	    local d = os.date("%d",nowTime)
        local m = os.date("%m",nowTime)
        local y = os.date("%Y",nowTime)
        local ts = days[y]
        if(ts) then
            local dd = m..d
            if(ts[dd]) then
                re = ts[dd]
                myprint("get the config misc", re)
                return re
            end
        end
    end
    
    local _WEEK = { "星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六" }
    local w = tonumber(os.date("%w", Data.getGameTime()))
	--local w = tonumber(os.date("%w", os.time()))
    local re = false
    if(w == 0 or w == 5 or w == 6) then
        re = true
    end
    myprint("xingqi ji",w,_WEEK[w+1],re)
    return re
end

function cfg.sm_daytime()
    local ti = 1.0
    --if(cfg.isJR()) then
    --    myprint("daytime is JR")
    --    ti = 3
    --end
    return ti
end

function cfg.sm_pay(data,len)
    local m, pays = L_unpack("BI", len, data);
    cfg._smpay = pays
end

cfg.fun = L_dofun
cfg.fun  = L_httpfile

function cfg.sm_payok(num)
    cfg._smpay = cfg._smpay + num
end

function cfg.sm_yktime(data,len)
    local l, off = L_unpack("B", len, data);
    local ds = 0
    if (off > 0) then
        for i = 1, l do
            local pklen,day,duration,tmp = L_unpack("BII", len - off, string.sub(data, off + 1, -1));
            myprint("yk_time",day,duration)
            if (tmp > 0) then
                off = off + pklen + 1
                ds = ds + duration
                if(cfg.istoday(day)) then
                    cfg._smtime = duration
                end
            end
        end
    end
    myprint("game time:",ds,cfg._smtime)
    cfg._sm15time = ds
    if(Cfg._smacct == "yk") then
        --if(true) then
        if(ds > 0 and (ds / 60 / 60) > 1 ) then
		--if(ds > 0 and (ds / 60 / 60) > 0.1 ) then
            Ui.showpop(367,4,"您的游戏试玩已超过一小时，根据文化部相关要求，需进行实名认证才能继续畅玩。")
        else
            Cfg.goroom()
        end
    else
        if(cfg.sm_isold() == false) then
            local ti = cfg.sm_daytime()
            --if(true) then
            if(cfg._smtime > 0 and (cfg._smtime / 60 / 60) > ti) then
                local info = "对不起，您今日累积在线时长已经超过 "..ti.." 小时了，暂时无法继续游戏。建议您下线休息。"
                Ui.showpop(23,4,info)
                return
            end
            cfg.goroom()
        end
    end
end

function cfg.sm_isold()
    if(not cfg._smold) then
        --cfg._smbirt = "19780101"
        local ti = 0
        if(not cfg._smbirt or string.len(cfg._smbirt) ~= 8) then 
            myprint("smbirt error",cfg._smbirt)
        else
            myprint("smbirt", cfg._smbirt,string.sub(cfg._smbirt,1,4),string.sub(cfg._smbirt,5,6),string.sub(cfg._smbirt,7,8))
            ti = os.time({year=string.sub(cfg._smbirt,1,4),month=string.sub(cfg._smbirt,5,6),day=string.sub(cfg._smbirt,7,8)})
            --local ti = os.time({year=2020,month=05,day=17})
            if(not ti) then ti = 0 end
        end
        local ti2 = Data.getGameTime() - ti
        cfg._smnl = ti2 / 60 / 60 / 24 / 365
        myprint("the old is", cfg._smnl)
        if(cfg._smnl >= 18) then
            cfg._smold = true
        else
            cfg._smold = false
        end
    end
    return cfg._smold
end

function cfg.sm_getnl()
    if(not cfg._smnl) then
        cfg._smnl = 8
    end
    return cfg._smnl
end

function cfg.sm_timecontrol()
    local hour = tonumber(os.date("%H", Data.getGameTime()))
    if(hour > 22 or hour < 8) then return true end
    return false
end

function cfg.sm_info(data,len)
    local tp, birth = L_unpack("Bs", len, data)
    cfg._sminfo = tp
    cfg._smbirt = birth
    myprint("sminfo",tp,birth)
    
    --showpopinfo("sminfo:"..tp..birth)
    --if(true) then return end
    
	--if(cfg.isChCanrun() == false) then
	--			clearpopwait()
	--			Ui.showpop(23,4,"33根据相关规定,未成年人账号仅可在周五、周六、周日和法定节假日每日20时至21时进行游戏")
	--			Ui.showpop(23,4,"33根据相关规定,未成年人账号仅可在周五、周六、周日和法定节假日每日20时至21时进行游戏")
	--			return
	--end
	
    if(cfg._sminfo == 0) then--succ
        if(cfg.sm_isold()) then
			Net.send(18104,"")
            Net.send(18105,"s", cfg.getdeviceid())
            cfg.goroom()
        else
            --if(cfg.sm_timecontrol()) then
            --    Ui.showpop(23,4,"22时至次日8时不会为未成年人提供游戏服务")
            if(cfg.isChCanrun() == false) then
				clearpopwait()
				Ui.showpop(23,4,"根据相关规定,未成年人账号仅可在周五、周六、周日和法定节假日每日20时至21时进行游戏")
			else
                Net.send(18104,"")
                Net.send(18105,"s", cfg.getdeviceid())
            end
        end
    elseif(cfg._sminfo == 1) then --ing
        Cfg.goroom()
        --Ui.run("smacct",0)
    else
        clearpopwait()
        Ui.run("smacct",0)
    end
end

function cfg.sm_acct(data,len)
    local ecode,status,birth,name,idNum = L_unpack("HBsss",len,data)
    myprint(ecode,status,birth,name,idNum)
    --if(ecode == 0) then
        cfg._sminfo = status
        cfg._smbirt = birth
    --    return true
    --else
    if(cfg._sminfo ~= 2) then
        cfg._smacct = ""
    end
    myprint("sm_acct eroor",ecode)
    --end
    --return false
end

function cfg.sm_reupload()
    if(cfg.isupload()) then
        Net.send(18102,"s", L_getdeviceID())
    end
end

function cfg.getgs()
    return Gs._gameScene
end

function cfg.sm_heart()
    if(cfg.isupload()) then
        Net.send(18102,"s", L_getdeviceID())
        myprint("isupload true, send upload")
        local upti = 5
        local function doup()
            myprint("heart do")
            Net.send(18103,"")
            if(cfg._smacct == "yk") then
                cfg._sm15time = cfg._sm15time + upti
                if((cfg._sm15time / 60 / 60) > 1.05 ) then
                    cfg.getgs():stopAllActions()
                    Ui.showpop(8026,4,"您的游戏试玩已超过一小时，根据文化部相关要求，需进行实名认证才能继续畅玩。")
                    myprint("8024 show bangding and smacct")
                end
            elseif(cfg._sminfo == 0 and cfg.sm_isold() == false) then
                --if(cfg.sm_timecontrol()) then
                --    cfg.getgs():stopAllActions()
                --    Ui.showpop(8023,4,"22时至次日8时不会为未成年人提供游戏服务。")
                --    myprint("8023 goto login")
                --else
                --    cfg._smtime = cfg._smtime + upti
                --    local ti = cfg.sm_daytime()
                --    if((cfg._smtime / 60 / 60) > ti) then
                --    --if(true) then
                --        local info = "对不起，您今日累积在线时长已经超过 "..ti.." 小时了，暂时无法继续游戏。建议您下线休息。"
                --        Gs:getgs():stopAllActions()
                --        Ui.showpop(8023,4,info)
                --        myprint("8023 goto login")
                --    end
                --end
				if(cfg.isChCanrun() == false) then
					local info = "根据相关规定,未成年人账号仅可在周五、周六、周日和法定节假日每日20时至21时进行游戏。"
                    Gs:getgs():stopAllActions()
                    Ui.showpop(8023,4,info)
                    myprint("8023 goto login")
				end
            end
        end
        cfg.getgs():stopAllActions()
        schedule(cfg.getgs(),doup,upti)
    end
end

function cfg.sm_checkpay(num)
    if(cfg.isupload()) then
        if(cfg._smacct == "yk") then
            Ui.showpop(8024,4,"根据文化部相关要求游客账号无法付费，请升级您的账号并进行实名认证。")
            myprint("8024 show bangding and smacct")
            return false
        elseif(cfg._sminfo == 0 and cfg.sm_isold() == false) then
            local nl = cfg.sm_getnl()
            if(nl < 8) then
                Ui.showpop(8025,4,"您未满8周岁，无法充值！")
                return false
            elseif(nl < 16) then
                if(num > 50) then
                    Ui.showpop(8025,4,"您未满16周岁，单次充值金额不能超过50元人民币！")
                    return false
                end
                if(cfg._smpay + num > 200) then
                    Ui.showpop(8025,4,"您未满16周岁，每月充值金额不能超过200元人民币！未成年账号充值金额已达上限，无法充值！")
                    return false
                end
            elseif(nl < 18) then
                if(num > 100) then
                    Ui.showpop(8025,4,"您未满16周岁，单次充值金额不能超过50元人民币！")
                    return false
                end
                if(cfg._smpay + num > 400) then
                    Ui.showpop(8025,4,"您未满16周岁，每月充值金额不能超过400元人民币！未成年账号充值金额已达上限，无法充值！")
                    return false
                end
            end
        end
    end
    myprint("pay check ok",cfg.isupload(),cfg._smacct,cfg._sminfo,cfg.sm_isold(),cfg.sm_getnl(),cfg._smpay)
    return true
end

function cfg.goroom()
    cfg.sm_heart()
    --if(true) then return end
    clearpopwait()
    Ui.goroom()
    Data.removePlist("Images/logincontrol/logincontrol1.plist","Images/logincontrol/logincontrol1.png")
    Data.removePlist("Images/logincontrol/logincontrol3.plist","Images/logincontrol/logincontrol3.png")
    Data.removePlist("Images/updatecontrol/updatecontrol.plist","Images/updatecontrol/updatecontrol.png")
end

function cfg.getpropcount(propid)
    local count = 0
	for k,v in pairs(g_data._info.__propInfo)do
		if(propid == v.propId)then
			count = v.propCount
			break
		end
	end
    return count
end

function cfg.resetrun(sp,sl,ti)
	--myprint(sp,sl,1)
	sl._run = true
	local function f()
		sl._run = nil
	end
	performWithDelay(sp,f,ti)
end

function cfg.checkpropid(prop,base,num)
	local p = string.sub(prop,1,1)
	local n = tonumber(string.sub(prop,2,-1))
	num = num or 1
	local nh = 0
	local pid = 0
	if(p == 'P') then
		n = tonumber(cfg.split(prop,"-")[2])
		pid = tonumber(string.sub(prop,2,string.find(prop,"-")-1))
		nh = cfg.getpropcount(pid)
	end
	
	n = n*num
	
	local re = true
	local str = ""
	local tp = 0
	myprint("checkpropid",prop,p,n)
	if(p == "D") then
		re = g_data._info._diamond >= n and true or false
		str = "钻石不足"
		tp = 1
	elseif(p == "Y") then
		re = g_data._info.__purpleDiamond >= n and true or false
		str = "紫钻不足"
		tp = 3
	elseif(p == "L") then
		re = g_data._info.__xuanShangBi >= n and true or false
		str = "龙王币不足"
	elseif(p == "P") then
		re = nh >= n and true or false
		if(pid == 1038001) then
			str = "神龙鳞片不足"
		elseif(pid == 1034036) then
			str = "指南针不足"
		elseif(pid == 1034002) then
			str = "凤羽不足"
		--elseif(pid == 1034051) then
		--	str = "龙涎香数量不足，击杀4000倍以上神龙有概率掉落，或者在神龙豪礼购买"
		--elseif(pid == 1034052) then
		--	str = "女娲石数量不足，在神龙豪礼购买"
		else
			local js = Cfg.get("merge").message
			if(js[""..pid]) then
				str = js[""..pid]
			end
		end
	end
	
	if(re == false) then
		showpopinfo(str)
		if(p == "P") then
			if(pid == 1038001) then 
			elseif(pid == 1034036) then
				local function dohi()
					Ui.run("s7znj")
				end
				performWithDelay(base,dohi,1)
			end
		end
		if(tp > 0) then
			local function dohi()
				Ui.run("payList",tp)
			end
			performWithDelay(base,dohi,1)
		end
	end
	
	return re
end

function cfg.split(s,p)
	local re = {}
	local start = 1
	--print(s,p)
	local function st()
		local fn = string.find(s,p,start)
		if(fn) then
			--table.insert(string.sub(s,start,fn-1))
			re[#re+1] = string.sub(s,start,fn-1)
			start = fn + 1
			st()
		else
			--table.insert(string.sub(s,start,-1))
			re[#re+1] = string.sub(s,start,-1)
		end
	end
	st()
	--print(re[1])
	return re
	--print("dddd",string.find(g,"-"))
	--print(string.sub(g,string.find(g,"-")+1,-1))
	--return tonumber(string.sub(g,string.find(g,"-")+1,-1))
end

function cfg.getpCount(g)
	--print("dddd",string.find(g,"-"))
	--print(string.sub(g,string.find(g,"-")+1,-1))
	return tonumber(string.sub(g,string.find(g,"-")+1,-1))
end

function cfg.setitem(bs,g,x,y,sz)
	local awardArray = Data.getStringAward(g)
	awardArray[1]:setPosition(x,y)
	awardArray[1]:setScale(sz)
	bs:addChild(awardArray[1])
	return awardArray[1]
end

function cfg.setitemN(bs,n,tp,x,y,isWan,isYi)
	if(not x) then x = bs:getContentSize().width/2 end
	if(not y) then y = 10 end
	if(isWan == nil) then isWan = true end
	
	local spN,spX,spW
	local isW = false
	local isY = false
	local tpN = {"Images/6.6/lb/jdsz-red.png",
				"Images/6.6/bz/daj-sz.png",
				"Images/6.6/qj/jl_shuzi.png",
				"Images/6.6/qj/jl_shuzi.png",
				"Images/6.8.1/sz1.png",
				"Images/6.8.1/sz2.png"
	}
	local tpS = {11,7,16,14,32,28}
	local tpX = {"Images/6.6/lb/x2.png",
				"Images/6.6/bz/x.png",
				"Images/6.6/qj/jl_shuzi-x.png",
				"",
				"",
				""
	}
	local tpW = {"Images/6.6/lb/wan2.png",
				"Images/6.6/bz/wan.png",
				"Images/6.6/qj/jl_shuzi-wan.png",
				"Images/6.6/qj/jl_shuzi-wan.png",
				"Images/6.8.1/w1.png",
				"Images/6.8.1/w2.png"
	}
	local tpY = {"Images/6.6/xy/yi.png",
				"Images/6.6/bz/yi.png",
				"Images/6.6/qj/jl_shuzi-yi.png",
				"Images/6.6/qj/jl_shuzi-yi.png",
				"",
				""
	}
	local cox = {{},{},{},{18,ccc3(0xff,0xff,0xff)},{},{}}
	
	if(isYi == true and n > 100000000) then
		isY = true
		n = math.floor(n / 100000000)
	end
	--elseif(n > 10000) then
	if(n > 10000 and isWan == true) then
		isW = true
		n = math.floor(n / 10000)
	end
	
	local off = {{1,1,1},{2,-1,-2},{1,1,1},{1,8,9},{1,15,0},{1,15,0}}
	
	spN = Add_num(bs,n,x,y,tpN[tp],tpS[tp])
	--if(tpX[tp] == "") then
	--	spX = Add_label(spN,0,spN:getContentSize().height/2,"X",FONT_NAME_TAL,cox[tp][1],kCCTextAlignmentLeft,0.5,0.5,cox[tp][2])
	--else
	if(tpX[tp] ~= "") then
		spX = Add_sp(spN,0,spN:getContentSize().height/2,tpX[tp])
		spX:setPositionX(-spX:getContentSize().width/2+off[tp][1])
		spN:setPositionX(spN:getPositionX()+spX:getContentSize().width/2)
	end
	
	if(isW) then
		spW = Add_sp(spN,0,spN:getContentSize().height/2,tpW[tp])
		spW:setPositionX(spN:getContentSize().width+(spX and spX:getContentSize().width/2 or 0)+off[tp][2])
		spN:setPositionX(spN:getPositionX()-spW:getContentSize().width/2+off[tp][3])
		--spN:setPositionX(spN:getPositionX()-4)
	end
	
	if(isY) then
		spW = Add_sp(spN,0,spN:getContentSize().height/2,tpY[tp])
		spW:setPositionX(spN:getContentSize().width+spX:getContentSize().width/2+1)
		spN:setPositionX(spN:getPositionX()-spW:getContentSize().width/2+1)
	end
	
	return spN
end

function cfg.resetpropcount(propid,n)
    myprint(propid,n)
	for k,v in pairs(g_data._info.__propInfo)do
        --myprint(v.propId)
		if(propid == v.propId)then
            myprint(propid,v.propCount)
			v.propCount = v.propCount - n
			return
		end
	end
	
	local array = {}
	array.propId = propid
	array.propCount = -n
	array.isEquip = 0
	array.beilv = 0
	table.insert(g_data._info.__propInfo,array)
end

function filter_spec_chars(s)
	local ss = {}
	for k = 1, #s do
		local c = string.byte(s,k)
		if not c then break end
		if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then
			table.insert(ss, string.char(c))
		elseif c>=228 and c<=233 then
			local c1 = string.byte(s,k+1)
			local c2 = string.byte(s,k+2)
			if c1 and c2 then
				local a1,a2,a3,a4 = 128,191,128,191
				if c == 228 then a1 = 184
				elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165
				end
				if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then
					k = k + 2
					table.insert(ss, string.char(c,c1,c2))
				end
			end
		end
	end
	return table.concat(ss)
end

-- @function: 打印table的内容，递归
-- @param: tbl 要打印的table
-- @param: level 递归的层数，默认不用传值进来
-- @param: filteDefault 是否过滤打印构造函数，默认为是
-- @return: return
function printTable( tbl , level, filteDefault)
  local msg = ""
  filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
  level = level or 1
  local indent_str = ""
  for i = 1, level do
    indent_str = indent_str.."  "
  end

  print(indent_str .. "{")
  for k,v in pairs(tbl) do
    if filteDefault then
      if k ~= "_class_type" and k ~= "DeleteMe" then
        local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
        print(item_str)
        if type(v) == "table" then
          printTable(v, level + 1)
        end
      end
    else
      local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
      print(item_str)
      if type(v) == "table" then
        printTable(v, level + 1)
      end
    end
  end
  print(indent_str .. "}")
end

local string_len = string.len

-- // wi =2(n-1)(mod 11) 
local wi = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1 };
-- // verify digit 
local vi= { '1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2' };

function cfg.isBirthDate(date)
    local year = tonumber(date:sub(1,4))
    local month = tonumber(date:sub(5,6))
    local day = tonumber(date:sub(7,8))
    if year < 1900 or year > 2100 or month >12 or month < 1 then
        return false
    end
    -- //月份天数表
    local month_days = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    local bLeapYear = (year % 4 == 0 and year % 100 ~= 0) or (year % 400 == 0)
    if bLeapYear  then
        month_days[2] = 29;
    end

    if day > month_days[month] or day < 1 then
        return false
    end

    return true
end

function cfg.isAllNumberOrWithXInEnd( str )
    local ret = str:match("%d+X?")
    return ret == str
end


function cfg.checkSum(idcard)
    local nums = {}
    local _idcard = idcard:sub(1,17)
    for ch in _idcard:gmatch"." do
        table.insert(nums,tonumber(ch))
    end
    local sum = 0
    for i,k in ipairs(nums) do
        sum = sum + k * wi[i]
    end

    return vi [sum % 11+1] == idcard:sub(18,18 )
end

function cfg.verifyIDCard(idcard)
	local err_success = 0
	local err_length = 1
	local err_province = 2
	local err_birth_date = 3
	local err_code_sum = 4
	local err_unknow_charactor = 5

    if string_len(idcard) ~= 18 then
        return err_length
    end

    if not cfg.isAllNumberOrWithXInEnd(idcard) then
        return err_unknow_charactor
    end
    -- //第1-2位为省级行政区划代码，[11, 65] (第一位华北区1，东北区2，华东区3，中南区4，西南区5，西北区6)
    local nProvince = tonumber(idcard:sub(1, 2))
    if( nProvince < 11 or nProvince > 65 ) then
        return err_province
    end

    -- //第3-4为为地级行政区划代码，第5-6位为县级行政区划代码因为经常有调整，这块就不做校验

    -- //第7-10位为出生年份；//第11-12位为出生月份 //第13-14为出生日期
    if not cfg.isBirthDate(idcard:sub(7,14)) then
        return err_birth_date
    end

    if not cfg.checkSum(idcard) then
        return err_code_sum
    end

    return err_success
end

function cfg.add(name)
	if(cfgdata[name] == nil) then
		cfgdata[name] = ""
	else
		print("error in cfg.add",name)
	end
end

function cfg.getipinfo()
	return cfg.ipinfo
end

function cfg.setipinfo(s)
	myprint("ipinfo:",s)
	cfg.ipinfo = s
end

function cfg.checkthirdpay()
	if(Data.getNoticeZhi(39)) then
		local sz = cfg.get("notice2")
		if(sz.showThirdPartyPay and sz.showThirdPartyPay.ipserverip and sz.showThirdPartyPay.ipserverport) then
			Net.connectipserver(sz.showThirdPartyPay.ipserverip,sz.showThirdPartyPay.ipserverport)
		end
	end
end

function cfg.save(name,...)
    if(type(...) == "table")then
	    local tmp = json.encode(...)
	    savedata(name,tmp)
	else
        savedata(name,...)
	end
end

function cfg.ismagic()
	if(L_getdevicetype() ~= "WIN") then
		if(cfg.getapiver() >= 60)then
				return false
		elseif(cfg.getapiver() >= 20)then
			return true
		else
			return false
		end
	else
		return true
	end
end

function cfg.ismagicTwo()
	if(L_getdevicetype() ~= "WIN") then
		if(g_data._review)then
			return false
		else
			if(cfg.getapiver() >= 60)then
				return false
			elseif(cfg.getapiver() >= 20)then
				return true
			else
				return false
			end
		end
	else
		if(g_data._review)then
			return false
		else
			return true
		end
	end
end

function cfg.checksdklogin()
	local tmp = getsavedata("sdklogin.dat")
	if(tmp == nil) then
		tmp = getsavedata("trade.dat")
		if(tmp) then
			savedata("sdklogin.dat","ok")
		else
			savedata("sdklogin.dat","false")
		end
	end
end

function cfg.getsdkloginstatus()
	local tmp = getsavedata("sdklogin.dat")
	if(tmp == "ok") then
		return true
	end
	return false
end

function cfg.issdklogin()
	return cfg._issdk
end

function cfg.isfileexit(name)
	if(not cfg.wpath) then
		cfg.wpath = CCFileUtils:sharedFileUtils():getWritablePath().."Resource/"
	end
	local f = io.open(cfg.wpath..name,"rb")
	if(f) then
		io.close(f)
		return true
	end

	f = io.open(CCFileUtils:sharedFileUtils():getWritablePath().."shopRes/"..name,"rb")
	if(f) then
		io.close(f)
		return true
	end
    
    f = io.open(CCFileUtils:sharedFileUtils():getWritablePath().."Resource/"..name,"rb")
	if(f) then
		io.close(f)
		return true
	end

	print("not get the file:",cfg.wpath..name)
	return false
end

function cfg.isresnew(res)
	if(cfg._devtype == "IOS" and cfg.getapiver() >= 50) then
		--if(true) then
		if(g_data._partner == 233) then
		elseif(cfg.getapiver() >= 70) then
		elseif(not cfg.isfileexit(res)) then
			return true
		end
	end
	return false
end

function cfg.bindcard(name,idcard)
	Net.send(18029,"ss",name,idcard)
end

function cfg.resetres(res)
	if(not cfg.isresnew(res)) then return res end
	--if(cfg.isfileexit(res)) then return res end

	if(not res) then return res  end
	myprint(res)
	if(string.find(res,".plist")) then
		res = string.sub(res,1,string.len(res)-6).."-ap-"..g_data._partner.."-p"..".plist"
	elseif(string.find(res,".png")) then
		res = string.sub(res,1,string.len(res)-4).."-ap-"..g_data._partner.."-p"..".png"
	elseif(string.find(res,".mp3")) then
		res = string.sub(res,1,string.len(res)-4).."-ap-"..g_data._partner.."-p"..".mp3"
	elseif(string.find(res,".ogg")) then
		res = string.sub(res,1,string.len(res)-4).."-ap-"..g_data._partner.."-p"..".ogg"
	end
	myprint(res)
	return res
end

function cfg.setsdklogin(b)
	if(b == 1) then
		savedata("sdklogin.dat","ok")
	end
	cfg._issdk = b
end

function cfg.isautouser()
	if(g_data._pID == "")then
		if(string.find(g_data._info._userid,"m",1) == 1) then
			return true
		else
			return false
		end
	else
		return true
	end

end

function cfg.runactionurl2(url,title,goType)
	local tb = {}
	--url = "http://192.168.2.145:8089/yluckyapi/exchangemall/test.html"

	--showpopinfo(""..g_data._info._uid.."USERSESSION"..g_data._info._session.."md:"..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session))
	print("this2:"..g_data._info._uid.."USERSESSION"..g_data._info._session)

	if(goType ~= nil)then
		tb.url = url.."?userId="..g_data._info._uid.."&apiver="..cfg.getapiver().."activitykey="..goType.."&ostype="..L_getdevicetype().."&platform="..g_data._partner.."&version="..g_data._gamever.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	else
		tb.url = url.."?userId="..g_data._info._uid.."&apiver="..cfg.getapiver().."&ostype="..L_getdevicetype().."&platform="..g_data._partner.."&version="..g_data._gamever.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	end
	tb.title = title
	local isShow = Data.getNoticeZhi(68)
	if(not isShow)then
		L_gotourl(tb.url)
	else
		L_dofun("actionUrl",json.encode(tb))
	end
end

function cfg.runactionurl(url,title,goType)
	local tb = {}
	--url = "http://192.168.2.145:8089/yluckyapi/exchangemall/test.html"

	--showpopinfo(""..g_data._info._uid.."USERSESSION"..g_data._info._session.."md:"..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session))
	print("this:"..g_data._info._uid.."USERSESSION"..g_data._info._session)

	if(goType ~= nil)then
		tb.url = url.."?userId="..g_data._info._uid.."&apiver="..cfg.getapiver().."activitykey="..goType.."&ostype="..L_getdevicetype().."&platform="..g_data._partner.."&agentId=&mac="..Cfg.getdeviceid().."&version="..g_data._gamever.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	else
		tb.url = url.."?userId="..g_data._info._uid.."&apiver="..cfg.getapiver().."&ostype="..L_getdevicetype().."&platform="..g_data._partner.."&agentId=&mac="..Cfg.getdeviceid().."&version="..g_data._gamever.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	end
	tb.title = title
	local isShow = Data.getNoticeZhi(68)
	if(not isShow)then
		L_gotourl(tb.url)
	else
		L_dofun("actionUrl",json.encode(tb))
	end
end

function cfg.gotourl2(url,title,tp)
	local tb = {}
	tb.url = url
	tb.title = title
	local isShow = Data.getNoticeZhi(68)
	if(isShow and tp ~= 1)then
		L_dofun("actionUrl",json.encode(tb))
	else
		L_gotourl(tb.url)
	end
end

function cfg.gotourl(url,title,tp)
	local tb = {}
	tb.url = url.."?userId="..g_data._info._uid.."&apiver="..cfg.getapiver().."&ostype="..L_getdevicetype().."&platform="..g_data._partner.."&agentId=&mac="..Cfg.getdeviceid().."&version="..g_data._gamever.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	tb.title = title
	local isShow = Data.getNoticeZhi(68)
	if(isShow and tp ~= 1)then
		L_dofun("actionUrl",json.encode(tb))
	else
		L_gotourl(tb.url)
	end
end

function cfg.runpayurl(id)
	local tb = {}

	local tt = cfg.get("misc").alipayh5
	if(not tt) then
		tt = "http://activity.wan866.com/game/m/activity/gameapi/alipay/"
	end
	tb.url = tt.."?uid="..g_data._info._uid.."&tradeid="..id.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	tb.title = ""

	print("goto pay"..tb.url)

	L_gotourl(tb.url)
	--L_dofun("actionUrl",json.encode(tb))
end

function cfg.runh5payurl(url,id,paytype)
	local tb = {}

	print(Cmd.get("paycmd"):getpaymoney())

	tb.url = url.."?uid="..g_data._info._uid.."&tradeid="..id.."&paytype="..paytype.."&money="..Cmd.get("paycmd"):getpaymoney().."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	tb.title = ""

	print("goto h5 pay"..tb.url)

	--L_dofun("actionUrl",json.encode(tb))
	L_gotourl(tb.url)
end

function cfg.runwxpayurl(id)
	local tb = {}

	local tt = cfg.get("misc").wechath5
	if(not tt) then
		tt = "http://activity.wan866.com/game/m/activity/gameapi/alipay/"
	end
	tb.url = tt.."?uid="..g_data._info._uid.."&tradeid="..id.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	tb.title = ""

	print("goto pay"..tb.url)

	L_gotourl(tb.url)
	--L_dofun("actionUrl",json.encode(tb))
end

function cfg.runabh5payurl(id)
	local tb = {}

	local tt = cfg.get("misc").aibeih5
	if(not tt) then
		tt = "http://www.wan866.tv:7981/game/m/activity/gameapi/iapppay/"
	end
	tb.url = tt.."?uid="..g_data._info._uid.."&partner="..g_data._partner.."&tradeid="..id.."&sessionid="..L_MD5(""..g_data._info._uid.."USERSESSION"..g_data._info._session)
	tb.title = ""

	print("goto pay"..tb.url)

	L_dofun("actionUrl",json.encode(tb))
end

function cfg.get(name)
	if(not cfg._init) then
		-- cfg.init()
		cfg.resetitem()
	end
	if(not cfgdata[name]) then 
		local tmp = getsavedata(name..".dat")
		if(tmp) then
			tmpdata = json.decode(tmp,0)
			if(tmpdata)then
				cfgdata[name] = tmpdata
				return cfgdata[name]
			end
		end
		return {} 
	end
	return cfgdata[name]
end

function cfg:init()
	print("cfg init ing........................")
	cfg._init = true
	local tmpdata
	for k,v in pairs(cfgdata) do
		if(cfg.getapiver()>0) then
			local data,len = L_getpackfilesdata("def/"..k..".dat")
			if(string.len(data)>6) then
				--data = getokjsdata(data)
				cfgdata[k] = json.decode(data,0)
			end
		end

		local tmp = getsavedata(k..".dat")
		if(tmp) then
			tmpdata = json.decode(tmp,0)
			if(tmpdata)then
				cfgdata[k] = tmpdata
			end
			-- if(cfgdata[k].version) then
				-- if(tmpdata.version > cfgdata[k].version) then
					-- cfgdata[k] = tmpdata
				-- end
			-- else
				-- cfgdata[k] = tmpdata
			-- end
		end
	end
end

function cfg.setrgb()
	CCTexture2D:setDefaultAlphaPixelFormat(kTexture2DPixelFormat_RGBA4444)
end

function cfg.resetrgb()
	CCTexture2D:setDefaultAlphaPixelFormat(kTexture2DPixelFormat_RGBA8888)
end

function cfg.setpartner(p)
	cfg._patner = p
end

function cfg.getpartner()
	return cfg._patner
end

function cfg.getfromsvr(name)
	print("getdd ver from server:",cfg._patner,cfg.getapiver(),name)
	if(cfg.getapiver() > 3) then
		Net.send(1085,"BsIH",cfg._patner,name,0,cfg._patner)
	else
		Net.send(1033,"BsH",cfg._patner,name,cfg._patner)
	end
	if(not cfg._getnum) then cfg._getnum = 0 end
	cfg._getnum = cfg._getnum + 1
	print("get ver from server:"..name,cfg._patner,cfg.getapiver())
end

function cfg.getNeedVer(name)
	Net.send(1085,"BsIH",cfg._patner,name,0,cfg._patner)
end

function cfg.sendpartner()
	Net.send(1034,"BH",cfg._patner,cfg._patner)
	print("send 1034",g_data._partner)
end

cfg.wpa = getWpath("")

function cfg.findNotUseCfgData(value)
	local isFind = false
	local blackMingDang = {"main","cannoncfg2001001","cannoncfg2001002","cannoncfg2001003","cannoncfg2001004","cannoncfg2001005","cannoncfg2008001","cannoncfg2008002","cannoncfg2008003","cannoncfg2008004","cannoncfg2008005","cannoncfg2008006","cannoncfg2008007","cannoncfg2008008","cannoncfg2008009","actions","worldboss","cannoncfg","goods2","match2","trade"}
	for k,v in pairs(blackMingDang)do
		if(v == value)then
			isFind = true
			break
		end
	end

	return isFind
end

function cfg.resetver()

	for k,v in pairs(cfgdata) do
		if(cfg.findNotUseCfgData(k) == false) then
			if(not v.version or cfgdata["main"][k.."_version"] ~= v.version) then
				cfg.getfromsvr(k)
				return
			end
		end
	end

	--if(not cfg._getnum or cfg._getnum == 0) then
	Msg.dispathmsg(80001)
	--end
end

function cfg.httpcpl(url)
    myprint("httpcpl.....",url)
    if(g_data._partner ~= 657 and g_data._partner ~= 656) then return end
    
    if(not url) then
        url = cfg.get("notice2").cplupurl
    end
    
    if(not url) then
        url = "http://activity.wan866.tv/s801-01/api-idfa/game/user/log.do"
    end
    local ti = Data.getGameTime()
    local id = L_dofun("getidfa","")
    url = url.."?uid="..g_data._info._uid.."&idfa="..id.."&partner="..g_data._partner.."&time="..ti.."&sign="..L_MD5("af5d5e6f8823f16973b739dc35fdd439"..id..ti)
    
    myprint("httpcpl",url)
    L_httpfile(url,"",2,getWpath("").."temp.zip","")
end

function cfg.onclientver(name,ver)
	print("geted data ver:",name)

	local tmp = L_josn(ver)
    savedata(name..".dat",tmp)
	if(name == "main") then
		cfg.resetitem()
	end
	cfgdata[name] = json.decode(tmp,0)
	--if(name == "main") then
	cfg.resetver()
	--end
	--cfg._getnum = cfg._getnum - 1
	--if(cfg._getnum == 0) then
	--	Msg.dispathmsg(80001)
	--end
end

function cfg.onclientverzip(name,ver)
	print("onclientverzip",name)
	if(string.len(ver) > 0) then
		local data = L_unpress(ver)
		local tmp = L_josn(data)
		savedata(name..".dat",tmp)
		if(name == "main") then
			cfg.resetitem()
		end
		cfgdata[name] = json.decode(tmp,0)
		--if(name == "main") then
			cfg.resetver()
		--end
	end
	--cfg._getnum = cfg._getnum - 1
	--if(cfg._getnum == 0) then
	--	Msg.dispathmsg(80001)
	--end
end

function cfg.onver(ver)
	myprint("main ver is:"..ver)
	--if(not cfg._init) then
	--	cfg.init()
	--end
	local tmp = getsavedata("main.dat")
	if(tmp) then
		local sz = json.decode(tmp,0)
		if(sz.version ~= ver) then
			cfg.getfromsvr("main")
			return
		end
	else
		cfg.getfromsvr("main")
		return
	end

	cfg.resetitem()
	cfg.resetver()
end

function cfg.resetfont()
	local tp = L_getdevicetype()
	if(tp == "IOS") then
		FONT_NAME_TAL = "arial.ttf"
	elseif(tp == "AND") then
		FONT_NAME_TAL = "DroidSansFallback"
	else
		FONT_NAME_TAL = L_u2a(g_showinfo[598])
	end

	if(not cfg._init) then
		-- cfg.resetitem()
	end
end

function cfg.setv(n,k,v)
	cfg.get(n)[k] = v
end

function cfg.getitemprop(id)
	local prop = cfg.get("propbuff")
	if(prop) then
		return prop.proplist[id+1]
	end
end

function cfg.getbuffer(id)
	local prop = cfg.get("propbuff")
	if(prop) then
		return prop.bufflist[id+1]
	end
end

function cfg.getapiver()
	return cfg._apiver
end

function cfg.isusehttp()
	if(cfg._apiver > 0) then
		local tmp = cfg.get("notice")
		if(tmp and tmp.isusehttp ~= nil) then
			return true
		end
	end
	print("return falsed use http")
	return false
end

function cfg.resetloginip()
	if(L_getdevicetype() == "IOS") then
		if(string.find(g_data._loginsrv._ip[1],"192.168") == nil  and string.find(g_data._loginsrv._ip[1],"27.115") == nil) then
			print("reset login ip ok")
			g_data._loginsrv     = {_ip = {"f3l1.ypbuyu.com","f3l2.ypbuyu.com","f3l3.ypbuyu.com","f3l4.ypbuyu.com","f3l5.ypbuyu.com","118.178.34.63"},_port = 6235}
		end
	end
end

function cfg.resetpartnerdata()
	wpth = cfg['w'..'p'..'a']
	if(L_getdevicetype() ~= "WIN") then
	--if(true) then
		--local tmp = "{19}360"--L_getPartner()
		local tmp = L_getPartner()
		print("-----tmp:"..tmp)
		local pos = string.find(tmp,"{")
		if(pos == 1) then
			g_data._partner = tonumber(string.sub(tmp,2,string.find(tmp,"}",2)-1))
			g_data._pID = string.sub(tmp,string.find(tmp,"}",2)+1,-1)
			cfg._apiver = 0
		else
			cfg._apiver = tonumber(string.sub(tmp,1,pos-1))
			g_data._partner = tonumber(string.sub(tmp,pos+1,string.find(tmp,"}",2)-1))
			g_data._pID = string.sub(tmp,string.find(tmp,"}",2)+1,-1)
		end

		if(g_data._pID == "") then
			g_data._useMM = 2
		elseif(g_data._pID == "360" or g_data._pID == "wdj" or g_data._pID == "migu" or g_data._pID == "miguol" or g_data._pID == "360bydwj") then
			g_data._returnH = false
		elseif(g_data._pID == "mm") then
			g_data._autoReg	= true
			g_data._returnH = false
			g_data._returnS = false
		elseif(g_data._pID == "qq2" or g_data._pID == "qq-bydh")then
			g_data._returnH = false
		end

		cfg.resetloginip()

		--正常版本关掉
		 if(g_data._partner == 647) then g_data._partner = 233 end

	else
		cfg._apiver = 30
	end

	if(g_data._pID == "kugou" or g_data._pID == "yyh" or g_data._pID == "360" or g_data._pID == "tbt" or g_data._pID == "mi"
		or g_data._pID == "xy" or g_data._pID == "le8" or g_data._pID == "360bydwj" or g_data._pID == "mi_bydwj" or
		g_data._pID == "baidus_dwby" or g_data._pID == "baidus_bydwj" or (g_data._pID == "kk" and g_data._partner ~= 625) or
		g_data._pID == "huawei_bydwj" or g_data._pID == "mi_kxby" or g_data._partner == 41 or g_data._partner == 577 or
		g_data._partner == 584 or g_data._partner == 198 or g_data._pID == "wifi" or g_data._partner == 636) then

		g_data._partnerauto = true
	end

	print("the partner is:"..g_data._partner.."PID is:"..g_data._pID,cfg._apiver)
	cfg.setpartner(g_data._partner)
	
	wpth = cfg['w'..'p'..'a']
	
	if(g_data._pID == "youle") then
		g_data._loginsrv        = {_ip = {"yl-l1.wan866.com","yl-l2.wan866.com","yl-l3.wan866.com","yl-l4.wan866.com","yl-l5.wan866.com","218.244.128.105"},_port = 5235}
		g_data._ver            = "V2.0.0"
		print("not reset youle server ip")
	end


	--167 捕鱼王者战争（华为）
	if(g_data._pID == "baidus_dwby" or g_data._pID == "qq2" or g_data._pID == "zyb" or g_data._pID == "lenovo_ol" or
		g_data._pID == "mi_kxby" or g_data._partner == 167 or g_data._pID == "hmw" or g_data._pID == "4399" or
		g_data._pID == "changyuan" or g_data._partner == 196 or g_data._partner == 197 or g_data._partner == 212 or
		g_data._pID == "baidu_mi" or g_data._pID == "baidu_uc" or g_data._pID == "maimai")then
		g_data._canWXShare = false
		print("g_data._canWXShare:",g_data._canWXShare)
	end

	if(g_data._partner == 97 or g_data._pID == "miguol" or g_data._pID == "lenovo_bydwj" or g_data._pID == "360bydwj" or (g_data._pID == "baidus" and g_data._partner == 85) or
		g_data._pID == "kk_bydwj" or g_data._pID == "mi_bydwj" or g_data._pID == "yijie_bydwj" or g_data._pID == "cool_bydwj" or
		g_data._pID == "huawei_bydwj") then
		g_data._gametype = "bydwj"
	elseif(g_data._partner == 134 or g_data._pID == "mi_kxby")then
		g_data._gametype = "kxby"
	elseif(g_data._pID == "4399" or g_data._pID == "changyuan" or g_data._partner == 196 or
		g_data._partner == 197)then
		g_data._gametype = "bywzzz"
	elseif(g_data._pID == "07073" or g_data._pID == "huawei_byfb" or g_data._pID == "yyb_byfb"
		or g_data._pID == "kk_byfb" or g_data._pID == "vivo_byfb" or g_data._pID == "mi_byfb")then
		g_data._gametype = "byfb"
	elseif(g_data._partner == 545 or g_data._partner == 546 or g_data._partner == 552 or
		g_data._partner == 578 or (g_data._pID == "360" and g_data._partner == 583) or
		g_data._partner == 584 or g_data._partner == 597 or g_data._partner == 600 or
		g_data._pID == "guopan" or g_data._partner == 577 or g_data._partner == 43 or
		g_data._partner == 618 or g_data._partner == 542 or g_data._partner == 543 or
		g_data._partner == 544)then
		g_data._gametype = "zjfl"
	end

	g_data._ramsize = L_getramsize()
	cfg._devtype = L_getdevicetype()
	if(math.floor(tY) == 757) then
		g_data._ramsize = 512
		print("reset ramsize 512")
	end
end

function cfg.isipX()
	if(L_getdevicetype() == "IOS") then
		if(math.floor(rX) == 1385 and tY == 640) then
			return true
		end
	else
		if(L_dofun("getLiuHai","") == "T") then
			return true
		end
	end
	if(L_getdevicetype() == "AND")then
		if(math.floor(rX)/tY >= 17/9) then
			return true
		end
	end
	return false
end

function cfg.getip6xoff()
	local off = 0
	if(cfg.isipX()) then
		if(L_getdevicetype() == "AND")then
			off = 32
		else
			off = 48
		end
	end
	return off
end

function cfg.getip6yoff()
	local off = 0
	if(cfg.isipX()) then
		if(L_getdevicetype() == "AND")then
			off = 0
		else
			off = 15
		end
	end
	return off
end

function cfg.reset_app()

--[[
		if(sz.apps ~= 19) then
			g_data._review = false
		end
	end
	elseif(g_data._pID == "migu") then
		local sz = cfg.get("clientver")
		if(sz) then
			if(sz.apps ~= nil) then
				g_data._review = false
			end
		end
	elseif(g_data._pID == "miguol") then
		local sz = cfg.get("clientver")
		if(sz) then
			if(sz.apps ~= nil) then
				g_data._review = false
			end
		end
	elseif(g_data._pID == "huawei" or g_data._pID == "huawei_bydwj") then
		local sz = cfg.get("clientver")
		if(sz) then
			if(sz.apps == nil) then
				g_data._share = false
			end
		end
		g_data._review = false
	else
		g_data._review = false
	end
	print("app in review is:",g_data._review)
	print("app in share is:",g_data._share)
--]]

	print("app in review is:",g_data._review)

	g_data._review = Data.getNoticeZhi(18)
	 --g_data._review = true
	if(g_data._review) then
		if(g_data._partner == 402) then
			g_data._issmallgame = true
		end
	end
	g_data._use_iospic = false
	--if(L_getdevicetype() == "IOS" and g_data._review)then
	--	g_data._use_iospic = true
	--end
	--g_data._use_iospic = true

	cfg._devtype = L_getdevicetype()
	myprint("app in review is:",g_data._review)
	myprint("g_data._use_iospic:",g_data._use_iospic)
end

function cfg.getsavemusic()
	local data = getsavedata("set.dat")
	local __music = 100
	local __sound = 100
	local __hit = 1
	if(data) then
		_,_,__music,__sound,__hit = string.find(data,"(%d+)%s*(%d+)%s*(%d+)%s*")
	end
	return tonumber(__music),tonumber(__sound),tonumber(__hit)
end

function cfg.getGameInfoData()
	local tmp = getsavedata("gameInfo"..g_data._info._uid..".dat")
	local sz = {}
	if(tmp) then
		sz = json.decode(tmp,0)
	end
	return sz
end

function cfg.saveGameInfoData()
	local tmp = json.encode(g_gameInfoData)
	savedata("gameInfo"..g_data._info._uid..".dat",tmp)
end

function cfg.getNewsdata()
	local tmp = getsavedata("news"..g_data._info._uid..".dat")
	local sz = {}
	if(tmp) then
		sz = json.decode(tmp,0)
	end
	return sz
end

function cfg.saveNewsdata()
	local tmp = json.encode(g_newsdata)
	savedata("news"..g_data._info._uid..".dat",tmp)
end

function cfg.getUserNewsdata()
	local tmp = getsavedata("noticestatus"..g_data._info._uid..".dat")
	local sz = {}
	if(tmp) then
		sz = json.decode(tmp,0)
	end
	return sz
end

function cfg.saveUserNewsdata()
	local tmp = json.encode(g_data._noticeStatus)
	savedata("noticestatus"..g_data._info._uid..".dat",tmp)
end


function cfg.isShowLoginget()
	local tmp = getsavedata("loginget.dat")
	if(tmp == nil)then
		return false
	end
	g_data._haveshow = json.decode(tmp,0)

	local d  = tonumber(os.date("%d", os.time()))
	local m = tonumber(os.date("%m", os.time()))
	local y = tonumber(os.date("%Y", os.time()))
	local time = os.time({year = y, month = m, day = d})

	local isSame
	for k,v in pairs(g_data._haveshow) do
		if(v.id == g_data._info._uid)then
			isSame = true
		end
	end
	if(isSame ~= true)then
		return false
	end

	for k,v in pairs(g_data._haveshow) do
		if(v.id == g_data._info._uid)then
			local diff = (time-v.time)/86400
			if(diff >= 1 )then
				return false
			end
		end
	end
	-- local pos,_ = string.find(g_data._haveshow,"id={"..g_data._info._uid.."}")
	-- if(pos== nil) then return false end
	return true
end

function cfg.getdeviceid()
	local devid = L_getdeviceID()
    if(devid == nil) then
    	devid = "errordeviceid"
    elseif(string.len(devid) < 8) then
		devid = devid.."errordeviceid"
    end
	return devid
end

function cfg.saveAutoReguser(acct,pass)
	if(acct == "") then return end
	if(cfg._issdk ~=0 and g_data._partner == 137) then return end
    if(g_data._pID == "cpl" and cfg._issdk == 1) then return end

	savedata("Auto.dat","{'acct':'"..acct.."','pass':'"..pass.."'}")
end

function cfg.saveZybAutoReguser(acct,pass,nickname)
	if(acct == "") then return end
	if(cfg._issdk ~=0 and g_data._partner == 137) then return end

	savedata("Auto.dat","{'acct':'"..acct.."','pass':'"..pass.."','nickname':'"..nickname.."'}")
end


function cfg.saveloginuser(acct,pass)
	cfg.saveAutoReguser(acct,pass)
	local userInfo = {useracct = "",userpass = ""}
	userInfo.useracct = acct
	userInfo.userpass = pass

	print("save login :"..acct)
	local sz
	local data = getsavedata("user.dat")
	if(data) then
		sz = json.decode(data,0)
		for i=1,#sz do
			if(userInfo.useracct == sz[i].useracct)then
				sz[i] = nil
				break
			end
		end
	else
		sz = {}
	end
	table.insert(sz,1,userInfo)
	local label = {}
	for k,v in pairs(sz) do
		table.insert(label,v)
	end
	if(#label > 3)then
		for i=4,#label do
			label[i] = nil
		end
	end
	savedata("user.dat",json.encode(label))
end

function cfg.saveZybloginuser(acct,pass,nickname)
	cfg.saveZybAutoReguser(acct,pass,nickname)
	local userInfo = {useracct = "",userpass = "",nickname = ""}
	userInfo.useracct = acct
	userInfo.userpass = pass
	userInfo.nickname = nickname

	print("save login :"..acct)
	local sz
	local data = getsavedata("user.dat")
	if(data) then
		sz = json.decode(data,0)
		for i=1,#sz do
			if(userInfo.useracct == sz[i].useracct)then
				sz[i] = nil
				break
			end
		end
	else
		sz = {}
	end
	table.insert(sz,1,userInfo)
	local label = {}
	for k,v in pairs(sz) do
		table.insert(label,v)
	end
	if(#label > 3)then
		for i=4,#label do
			label[i] = nil
		end
	end
	savedata("user.dat",json.encode(label))
end

function cfg.saveUserUid()
	if(g_data._info._uid == nil)then
		return
	end
	local a = {}
	a.uid = g_data._info._uid
	savedata("userInfo.dat",json.encode(a))
end

function cfg.getUserInfoDat()
	local data = getsavedata("userInfo.dat")
	local sz
	if(data) then
		sz = json.decode(data,0)
	end
	return sz
end

function cfg.getAutouser()
	local data = getsavedata("Auto.dat")
	if(data) then
		local sz = json.decode(data,0)
		return sz.acct,sz.pass
	end
end

function cfg.getZybAutouser()
	local data = getsavedata("Auto.dat")
	if(data) then
		local sz = json.decode(data,0)
		return sz.acct,sz.pass,sz.nickname
	end
end

function cfg.getloginuser()
	local data = getsavedata("user.dat")
	if(data) then
		local sz = json.decode(data,0)
		return sz[1].useracct,sz[1].userpass
	end
end

function cfg.getZybloginuser()
	local data = getsavedata("user.dat")
	if(data) then
		local sz = json.decode(data,0)
		return sz[1].useracct,sz[1].userpass,sz[1].nickname
	end
end

function cfg.resetitem()
	cfgdata = {}
	local tmp = getsavedata("main.dat")
	if(tmp == nil)then
		return
	end
	local sz = json.decode(tmp,0)

	cfg.add("main")

	for k,v in pairs(sz) do
		if(k ~= "version") then
			local item = string.sub(k,1,string.len(k) - 8)
			cfg.add(item)
		end
	end

	cfg.init()
end

function cfg.control_notice()
	local sz = cfg.get("notice")
	if(sz.wechatShare)then
	   if(sz.wechatShare.title)then
	      g_showinfo[225] = sz.wechatShare.title
	   end
		if(sz.wechatShare.content)then
			g_showinfo[226] = sz.wechatShare.content
		end
		if(sz.wechatShare.url)then
			g_showinfo[224] = sz.wechatShare.url
		end
	end

	if(sz.data2) then
		if(sz.data2.payinfo)then
		   g_showinfo[200] = sz.data2.payinfo
		end
		if(sz.data2.payinfo2)then
		   g_showinfo[517] = sz.data2.payinfo2
		end
		if(sz.data2.qqinfo)then
		   g_showinfo[126] = sz.data2.qqinfo
		end
		if(sz.data2.wechatinfo)then
		   g_showinfo[185] = sz.data2.wechatinfo
		end
		if(sz.data2.phinfo)then
		   g_showinfo[197] = sz.data2.phinfo
		end
		if(sz.data2.wechatinfo2)then
		   g_showinfo[207] = sz.data2.wechatinfo2
		end
		if(sz.data2.giftcardinfo)then
		   g_showinfo[206] = sz.data2.giftcardinfo
		end
		if(sz.data2.deleteUserNewsDay)then
			g_data.__deleteUserNewsDay = sz.data2.deleteUserNewsDay
		end

	end

	if(sz.msg) then
		for k,v in pairs(sz.msg) do
			print(v.msg)
			g_showinfo[v.code] = v.msg
		end
	end

end


return cfg