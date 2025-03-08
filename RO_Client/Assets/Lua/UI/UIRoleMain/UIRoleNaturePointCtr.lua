local UIRoleNaturePointCtr = class("UIRoleNaturePointCtr", require("UICtrBase"))

local isLeader = false
local remainPoints = 0

local num1, num2

local curOwnIndex = 1
local sortedPartnerDatas
function UIRoleNaturePointCtr:Init(view)
	local val = GlobalConfig.Instance:GetConfigStrValue(153)
	local list = CommonUtil.DeserializeGlobalStrToTable(val)
	num1 = tonumber(list[1])
	num2 = tonumber(list[2])

	self.view = view
end

function UIRoleNaturePointCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	isLeader = data == 1
	self:SetCurOwnerIndexById(data)
end

function UIRoleNaturePointCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleNaturePointCtr:GetData()
	return self.data
end

function UIRoleNaturePointCtr:SetCurOwnerIndexById(id)
	if sortedPartnerDatas == nil then
		self:GetSlotSortPartnerDatas()
	end

	if id == 1 then
		curOwnIndex = 1
	else
		for k,v in pairs(sortedPartnerDatas) do
			if v.id == id then
				curOwnIndex = k + 1
			end
		end
	end
end

function UIRoleNaturePointCtr:GetSlotSortPartnerDatas()
	local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	sortedPartnerDatas = {}
	for _,v in pairs(partnerDatas) do
		if v.owned then
			sortedPartnerDatas[#sortedPartnerDatas + 1] = v
		end
	end
	table.sort(sortedPartnerDatas, function (a, b)
		if a.owned and b.owned then
			return a.post < b.post
		else
			if a.owned and not b.owned then
				return true
			elseif not a.owned and b.owned then
				return false
			else
				return a.post < b.post
			end
		end
	end)
end

local function IndexOffset(curIndex, offset)
	local max = #sortedPartnerDatas + 1
	local num = curIndex + offset
	local index = num
	if num <= 0 then
		index = max
	elseif num > max then
		index = 1
	end
	return index
end

function UIRoleNaturePointCtr:GetCurOwnerIndex()
	return curOwnIndex
end

function UIRoleNaturePointCtr:SwichParterHero(offset)
	local curIndex = curOwnIndex

	curOwnIndex = IndexOffset(curIndex, offset)
	if curOwnIndex == 1 then
		self:SetData(1)
	else
		self:SetData(sortedPartnerDatas[curOwnIndex - 1].id)
	end
	return
end

function UIRoleNaturePointCtr:ResetRemainPoints()
	remainPoints = self:GetRoleDataAttrPoints(self.data)
end

function UIRoleNaturePointCtr:ChangeRemainPoint(num)
	-- remainPoints = remainPoints + num
	remainPoints = SDataUtil.Add(remainPoints,num)
	return remainPoints
end

function UIRoleNaturePointCtr:GetRemainPoint()
	return remainPoints
end

function UIRoleNaturePointCtr:GetAttrPlanePercent(val)
	return (val - 1) * num1 - num2 * math.pow(val - 1, 2)
end

function UIRoleNaturePointCtr:SendAttrChange(attrs)
	local table = {}
	for k,v in pairs(attrs) do
		if v > 0 then
			table[#table + 1] = {key = k, value = v}
		end
	end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ADD_ATTR_POINT_REQ, {attr_list = table, hero_id = self.data})
end

function UIRoleNaturePointCtr:SendResetPoint()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_RESET_ATTR_POINT_REQ, {hero_id = self.data})
end

local function Attr2Points(totalCount, attr, pointData)
	if attr > 1 then
		attr = attr - 1
		totalCount = SDataUtil.Add(totalCount,pointData[attr].cost)
		-- totalCount = totalCount + pointData[attr].cost
	else
		return totalCount
	end

	return Attr2Points(totalCount, attr, pointData)
end

local function Attr2Points1(addPoint, totalCount, attr, pointData)
	local newAttr = attr + addPoint
	if SDataUtil.IsGreaterEqual(totalCount, pointData[newAttr].cost) then
		totalCount = SDataUtil.Sub(totalCount,pointData[newAttr].cost)
		addPoint = addPoint + 1
	else
		return addPoint, totalCount
	end

	return Attr2Points1(addPoint, totalCount, attr, pointData)
end

local function Points2Attr(totalCount, addAttr, attr, pointData)
	-- if pointData[attr].cost > remainPoints then
	-- 	return addAttr, totalCount
	-- end

	if SDataUtil.IsGreater(pointData[attr].cost, remainPoints) then
		return addAttr, totalCount
	end

	-- if pointData[attr].cost <= totalCount then
	if SDataUtil.IsLessEqual(pointData[attr].cost, totalCount) then
		-- totalCount = totalCount - pointData[attr].cost
		totalCount = SDataUtil.Sub(totalCount,pointData[attr].cost)
		attr = attr + 1
		addAttr = addAttr + 1
	else
		return addAttr, totalCount
	end

	return Points2Attr(totalCount, addAttr, attr, pointData)
end

local function AddNewAttr(addPoint, val, newVal, totalCount, pointData, percent, isEnd)
	addPoint, newVal = Attr2Points1(addPoint, newVal, val, pointData)
	if SDataUtil.IsGreater(newVal,0) and SDataUtil.IsGreater(totalCount,newVal) and not isEnd and percent < 100 then
		newVal = SDataUtil.Add(newVal,1)
		totalCount = SDataUtil.Sub(totalCount,1)
		return AddNewAttr(addPoint, val, newVal, totalCount, pointData, percent, isEnd)
	else
		return addPoint, newVal, totalCount
	end
end

local function AddOneNewAttr(val, totalCount, pointData)
	-- if pointData[val].cost <= totalCount then
	if SDataUtil.IsLessEqual(pointData[val].cost,totalCount) then
		-- totalCount = totalCount - pointData[val].cost
		totalCount = SDataUtil.Sub(totalCount,pointData[val].cost)
		return 1, totalCount
	end
	return 0, totalCount
end

function UIRoleNaturePointCtr:CalcAutoPoints()
	local userData = self:GetHeroLogicData()
	local baseAttrs = self:GetLastBaseAttrs()
	local autoData
	if isLeader then
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(userData.configId)
		autoData = jobData.AutoAddPoint
	else
		local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(userData.configId)
		autoData = partnerData.AddPoint
	end
	local pointData = ManagerContainer.CfgMgr.QualityPointCfg

	local str = SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.STR])
	local agi = SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.AGI])
	local int = SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.INT])
	local vit = SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.VIT])
	local dex = SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.DEX])
	local luk = SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.LUK])

	local totalCount = self:GetRoleDataAttrPoints(self.data)
	remainPoints = totalCount

	local oldTotalCount = 0
	local curTotalCountMap = {}
	for _,v in pairs(autoData) do
		local type = v[1]
		local curTotalCount = 0
		if type == Enum.HeroAttrType.STR then
			curTotalCount = Attr2Points(curTotalCount, str, pointData)
		elseif type == Enum.HeroAttrType.AGI then
			curTotalCount = Attr2Points(curTotalCount, agi, pointData)
		elseif type == Enum.HeroAttrType.INT then
			curTotalCount = Attr2Points(curTotalCount, int, pointData)
		elseif type == Enum.HeroAttrType.VIT then
			curTotalCount = Attr2Points(curTotalCount, vit, pointData)
		elseif type == Enum.HeroAttrType.DEX then
			curTotalCount = Attr2Points(curTotalCount, dex, pointData)
		elseif type == Enum.HeroAttrType.LUK then
			curTotalCount = Attr2Points(curTotalCount, luk, pointData)
		end

		curTotalCountMap[type] = curTotalCount
		oldTotalCount = SDataUtil.Add(oldTotalCount, curTotalCount)
	end

	local oneAttrAddDic = {}
	local totalStatus = {}
	local function NeedOver()
		for k, v in pairs(totalStatus) do
			if v then
				return false
			end
		end
		return true
	end

	local newTotalCount = SDataUtil.Add(oldTotalCount,  totalCount)
	for i = 1, #autoData do
		totalStatus[i] = true
		local type = autoData[i][1]
		local percent = autoData[i][2]

		local attrNewCount = 0
		local isEnd = false
		if i < #autoData then
			-- attrNewCount = math.floor(totalCount * percent / 100)
			attrNewCount = SDataUtil.Div(SDataUtil.Multiply(newTotalCount,percent),100)
			if SDataUtil.IsGreaterEqual(attrNewCount, curTotalCountMap[type]) then
				local delta = SDataUtil.Sub(attrNewCount, curTotalCountMap[type])
				if SDataUtil.IsGreater(delta, 0) then
					if SDataUtil.IsGreater(totalCount, delta) then
						attrNewCount = delta
						totalCount = SDataUtil.Sub(totalCount, delta)
					else
						attrNewCount = totalCount
						totalCount = 0
					end
				else
					attrNewCount = 0
				end
			else
				attrNewCount = 0
			end
		else
			isEnd = true
			attrNewCount = totalCount
			totalCount = 0
		end

		oneAttrAddDic[type] = 0

		if SDataUtil.IsGreater(attrNewCount, 0) then
			local addPoint = 0
			local remain = 0
			if type == Enum.HeroAttrType.STR then
				oneAttrAddDic[type], remain, totalCount = AddNewAttr(addPoint, str, attrNewCount, totalCount, pointData, percent, isEnd)
				str = str + oneAttrAddDic[type]
			elseif type == Enum.HeroAttrType.AGI then
				oneAttrAddDic[type], remain, totalCount = AddNewAttr(addPoint, agi, attrNewCount, totalCount, pointData, percent, isEnd)
				agi = agi + oneAttrAddDic[type]
			elseif type == Enum.HeroAttrType.INT then
				oneAttrAddDic[type], remain, totalCount = AddNewAttr(addPoint, int, attrNewCount, totalCount, pointData, percent, isEnd)
				int = int + oneAttrAddDic[type]
			elseif type == Enum.HeroAttrType.VIT then
				oneAttrAddDic[type], remain, totalCount = AddNewAttr(addPoint, vit, attrNewCount, totalCount, pointData, percent, isEnd)
				vit = vit + oneAttrAddDic[type]
			elseif type == Enum.HeroAttrType.DEX then
				oneAttrAddDic[type], remain, totalCount = AddNewAttr(addPoint, dex, attrNewCount, totalCount, pointData, percent, isEnd)
				dex = dex + oneAttrAddDic[type]
			elseif type == Enum.HeroAttrType.LUK then
				oneAttrAddDic[type], remain, totalCount = AddNewAttr(addPoint, luk, attrNewCount, totalCount, pointData, percent, isEnd)
				luk = luk + oneAttrAddDic[type]
			end

			if SDataUtil.IsGreater(remain, 0) then
				totalCount = SDataUtil.Add(totalCount, remain)
			end
		end
	end

	while(true) do
		for k,v in pairs(autoData) do
			local type = v[1]
			local add = 0
			if type == Enum.HeroAttrType.STR then
				add, totalCount = AddOneNewAttr(str, totalCount, pointData)
				str = str + add
			elseif type == Enum.HeroAttrType.AGI then
				add, totalCount = AddOneNewAttr(agi, totalCount, pointData)
				agi = agi + add
			elseif type == Enum.HeroAttrType.INT then
				add, totalCount = AddOneNewAttr(int, totalCount, pointData)
				int = int + add
			elseif type == Enum.HeroAttrType.VIT then
				add, totalCount = AddOneNewAttr(vit, totalCount, pointData)
				vit = vit + add
			elseif type == Enum.HeroAttrType.DEX then
				add, totalCount = AddOneNewAttr(dex, totalCount, pointData)
				dex = dex + add
			elseif type == Enum.HeroAttrType.LUK then
				add, totalCount = AddOneNewAttr(luk, totalCount, pointData)
				luk = luk + add
			end

			oneAttrAddDic[type] = oneAttrAddDic[type] + add
			if add == 0 then
				totalStatus[k] = false
			end
		end
		if NeedOver() then
			break
		end
	end

	--if SDataUtil.IsGreater(totalCount,0) then
	--	local add = 0
	--	add, totalCount = AddOneNewAttr(luk, totalCount, pointData)
	--	if oneAttrAddDic[Enum.HeroAttrType.LUK] == nil then
	--		oneAttrAddDic[Enum.HeroAttrType.LUK] = 0
	--	end
	--	oneAttrAddDic[Enum.HeroAttrType.LUK] = oneAttrAddDic[Enum.HeroAttrType.LUK] + add
	--end

	remainPoints = totalCount

	return oneAttrAddDic
end

function UIRoleNaturePointCtr:IsLeader()
	return isLeader
end

function UIRoleNaturePointCtr:GetHeroLogicData()
	if isLeader then
		return ManagerContainer.DataMgr.UserData:GetHeroData()
	else
		return ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	end
end

function UIRoleNaturePointCtr:GetLastBaseAttrs()
	if isLeader then
		return ManagerContainer.DataMgr.UserData:GetLastBaseAttrs()
	else
		return ManagerContainer.DataMgr.PartnerData:GetLastBaseAttrs(self.data)
	end
end

function UIRoleNaturePointCtr:GetRoleDataAttrPoints(id)
	if id == 1 then
		return ManagerContainer.DataMgr.UserData:GetRoleDataAttrPoints()
	else
		return ManagerContainer.DataMgr.PartnerData:GetRoleDataAttrPoints(id)
	end
end

function UIRoleNaturePointCtr:OnDispose()
	sortedPartnerDatas = nil

	self.data = nil
	self.view = nil
end

return UIRoleNaturePointCtr

