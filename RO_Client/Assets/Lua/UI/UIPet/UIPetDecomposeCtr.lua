local UIPetDecomposeCtr = class("UIPetDecomposeCtr", require("UICtrBase"))

local DecomposeType = {
	Pet = 1,
	SkillEquip = 2,
}

local autoQualityLimit = 1
local decomposeLimit = 15
local decomposeReturn
local decomposeReturn1
local decomposeReturnNormal, decomposeReturnMini, decomposeReturnMvp
local defaultCount = decomposeLimit
function UIPetDecomposeCtr:Init(view)
	self.view = view
end

function UIPetDecomposeCtr:SetData(data)
	if self.filterData == nil then
		self.filterData = {}
		self.filterData.raritySelections = {}
		self.filterData.attrSelections = {}
		self.filterData.typeSelections = {}
		self.isFilter = false
	end

	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self:InitGlobal()
end

function UIPetDecomposeCtr:InitGlobal()
	if self.data == DecomposeType.Pet then
		decomposeLimit = GlobalConfig.Instance:GetConfigIntValue(227)
		autoQualityLimit = GlobalConfig.Instance:GetConfigIntValue(271)
		local val = GlobalConfig.Instance:GetConfigStrValue(224)
		if val ~= "" and val ~= nil then
			decomposeReturn = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	
		local val = GlobalConfig.Instance:GetConfigStrValue(249)
		if val ~= "" and val ~= nil then
			decomposeReturn1 = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	
		local val = GlobalConfig.Instance:GetConfigStrValue(270)
		if val ~= "" and val ~= nil then
			decomposeReturnNormal = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	
		local val = GlobalConfig.Instance:GetConfigStrValue(279)
		if val ~= "" and val ~= nil then
			decomposeReturnMini = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	
		local val = GlobalConfig.Instance:GetConfigStrValue(280)
		if val ~= "" and val ~= nil then
			decomposeReturnMvp = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	elseif self.data == DecomposeType.SkillEquip then
		decomposeLimit = GlobalConfig.Instance:GetConfigIntValue(332)
		autoQualityLimit = 2--GlobalConfig.Instance:GetConfigIntValue(331)
	end
end

function UIPetDecomposeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetDecomposeCtr:GetData()
	return self.data
end

function UIPetDecomposeCtr:SetChildController(ctr)
	self.childCtr = ctr
end

function UIPetDecomposeCtr:AddSelectedId(id)
	if not self.selectedIds then
		self.selectedIds = {}
	end

	if #self.selectedIds >= decomposeLimit then
		return false
	end

	if not CommonUtil.EleInTable(id, self.selectedIds) then
		if self.data == DecomposeType.Pet then
			local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
			if petData.quality <= autoQualityLimit and petData.level == 1 then
				self.autoSelectedCount = self.autoSelectedCount - 1
			end
		else
			local skillEquipData = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquipDataByUid(id)
			if skillEquipData.quality <= autoQualityLimit and skillEquipData.starLv == 1 then
				self.autoSelectedCount = self.autoSelectedCount - 1
			end
		end
		self.selectedIds[#self.selectedIds + 1] = id
		local showData = self:GetShowDataById(id)
		if showData then
			showData.selected = 1
		end
		return true
	end
	return false
end

function UIPetDecomposeCtr:IsSelected(id)
	return CommonUtil.EleInTable(id, self.selectedIds)
end

function UIPetDecomposeCtr:RemoveSeletedId(id)
	if not self.selectedIds then return end

	local result, idx = CommonUtil.EleInTable(id, self.selectedIds)
	if result then
		if self.data == DecomposeType.Pet then
			local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
			if petData.quality <= autoQualityLimit and petData.level == 1 then
				self.autoSelectedCount = self.autoSelectedCount + 1
			end
		else
			local skillEquipData = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquipDataByUid(id)
			if skillEquipData.quality <= autoQualityLimit and skillEquipData.starLv == 1 then
				self.autoSelectedCount = self.autoSelectedCount + 1
			end
		end
		local showData = self:GetShowDataById(id)
		if showData then
			showData.selected = 0
		end
		table.remove(self.selectedIds, idx)
	end
end

function UIPetDecomposeCtr:GetSelectedPetDatas()
	if not self.selectedIds then return end

	self.selectedPetDatas = {}

	for i = 1, #self.selectedIds do
		local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(self.selectedIds[i])
		self.selectedPetDatas[#self.selectedPetDatas + 1] = petData
	end

	CommonUtil.ArraySortListSelections(self.selectedPetDatas, Enum.TableSortRule.Up, "quality", "cfgId")
	return self.selectedPetDatas
end

function UIPetDecomposeCtr:GetSelectedPetDataByIdx(idx)
	if not self.selectedPetDatas then return end

	return self.selectedPetDatas[idx + 1]
end

function UIPetDecomposeCtr:GetSelectedPetLength()
	if not self.selectedIds then return 0 end

	return #self.selectedIds
end

function UIPetDecomposeCtr:RefreshPetDatas()
	self.petDatasLength = 0
	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	local petDatas = petDatasSource
	if self.isFilter then
		petDatas = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"quality", "Attribute", "natureType"}, {self.filterData.raritySelections, self.filterData.attrSelections, self.filterData.typeSelections})
	end
	if petDatas ~= nil then
		petDatas = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"isBattle", "qiyueHeroId"}, {false, 0})

		for _,v in pairs(petDatas) do
			v.skillUp = self:WasSkillUp(v)
		end

		CommonUtil.ArraySortSelections(petDatas, Enum.TableSortRule.Up, "isBattle", "quality", "isSupport", "isRelevant", "skillUp", "advanceLevel", "level", "cfgId")

		if not self.autoSelectedCount then
			self.autoSelectedCount = 0
			for _,v in pairs(petDatas) do
				if not v.isBattle and v.quality <= autoQualityLimit and v.level == 1 and not v.isRelevant and not v.isSupport and not v.skillUp then
					self.autoSelectedCount = self.autoSelectedCount + 1
				end
			end

			self.autoSelectedCount = math.min(decomposeLimit, self.autoSelectedCount)
			defaultCount = self.autoSelectedCount
		end

		if self.selectedIds then
			for _,v in pairs(petDatas) do
				if CommonUtil.EleInTable(v.id, self.selectedIds) then
					v.selected = 1
				end
			end
		end
		self.petDatasLength = #petDatas
	end

	if petDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	-- LogHRWarning(Inspect(petDatas))
	return petDatas
end

function UIPetDecomposeCtr:RefreshSkillEquipDatas()
	self.petDatasLength = 0
	local petDatasSource = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquips()
	local petDatas = petDatasSource
	if self.isFilter then
		petDatas = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"quality", "Attribute", "natureType"}, {self.filterData.raritySelections, self.filterData.attrSelections, self.filterData.typeSelections})
	end
	if petDatas ~= nil then
		CommonUtil.ArraySortSelections(petDatas, Enum.TableSortRule.Up, "quality", "maxStarLv", "cfgId")

		if not self.autoSelectedCount then
			self.autoSelectedCount = 0
			for _,v in pairs(petDatas) do
				if v.quality <= autoQualityLimit and v.starLv == 0 then
					self.autoSelectedCount = self.autoSelectedCount + 1
				end
			end

			self.autoSelectedCount = math.min(decomposeLimit, self.autoSelectedCount)
			defaultCount = self.autoSelectedCount
		end

		if self.selectedIds then
			for _,v in pairs(petDatas) do
				if CommonUtil.EleInTable(v.id, self.selectedIds) then
					v.selected = 1
				end
			end
		end
		self.petDatasLength = #petDatas
	end

	if petDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	-- LogHRWarning(Inspect(petDatas))
	return petDatas
end


function UIPetDecomposeCtr:GetPetDataById(id)
	if self.childCtr and self.childCtr.GetPetDataById then
		return self.childCtr:GetPetDataById(id)
	end

	return nil, nil
end

function UIPetDecomposeCtr:GetShowDataLength()
	return self.petDatasLength
end

function UIPetDecomposeCtr:DecomposeReturnCalc()
	if not self.selectedIds then return end

	self.cost = nil
	if self.data == DecomposeType.Pet then
		local maxLevel = ManagerContainer.CfgMgr:GetPetExpCfgMaxData()

		local zeny, exp, stone = 0, 0, 0

		local function GetSkillLvUpCount(petData)
			local count = 0
			for _,v in pairs(petData.skillList) do
				if v.level > 1 then
					count = count + v.level - 1
				end
			end
			return count
		end

		local function SumLvCost(type, lv, maxLv)
			if lv > maxLv then
				return
			end

			if lv > maxLevel then
				return
			end

			local petExt = ManagerContainer.CfgMgr:GetPetExpCfgDataById(lv - 1)

			local zenyCost, expCost = petExt['CostMoney'..type], petExt['experience'..type]
			zeny = zeny + (zenyCost or 0)
			exp = exp + (expCost or 0)
			SumLvCost(type, lv + 1, maxLv)
		end

		local function GetAdveneReturn2(quality, advenceLv)
			local resReturn
			if quality == 1 then
				resReturn = decomposeReturnNormal
			elseif quality == 2 then
				resReturn = decomposeReturnMini
			elseif quality == 3 then
				resReturn = decomposeReturnMvp
			end

			for _,v in pairs(resReturn) do
				if tonumber(v[1]) == advenceLv then
					return tonumber(v[3])
				end
			end
			return 0
		end

		for _,v in pairs(self.selectedIds) do
			local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(v)
			if petData then
				local cfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
				local resReturn = decomposeReturn1[cfgData.Quality]
				if resReturn then
					zeny = zeny + (resReturn[2] or 0)
					exp = exp + (resReturn[1] or 0)
				end
				SumLvCost(petData.quality, 2, petData.level)

				local skillUpCount = GetSkillLvUpCount(petData)
				stone = stone + ((skillUpCount * tonumber(decomposeReturn[petData.quality][3])) or 0)

				stone = stone + GetAdveneReturn2(petData.quality, petData.advanceLevel)
			end
		end

		local vipPer = self:GetVipPercent()
		return {{cfgId = Enum.ItemType.Coin, num = zeny*vipPer}, {cfgId = Enum.ItemType.PetExp, num = exp*vipPer}, {cfgId = Enum.ItemType.PetStone, num = stone*vipPer}}, vipPer
	elseif self.data == DecomposeType.SkillEquip then
		local resReturn = {}
		for _,v in pairs(self.selectedIds) do
			local petData = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquipDataByUid(v)
			if petData then
				local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(petData.cfgId)
				local smeltReturn = cfgData.SmeltReturn
				local starLv = petData.starLv
				local returnC = smeltReturn[starLv + 1]
				for _,v in pairs(returnC) do
					if not resReturn[v[1]] then
						resReturn[v[1]] = 0
					end
					resReturn[v[1]] = resReturn[v[1]] + v[2]
				end
			end
		end

		self.cost = {}
		for k,v in pairs(resReturn) do
			self.cost[#self.cost + 1] = {cfgId = k, num = v}
		end
		return self.cost
	end
end

function UIPetDecomposeCtr:GetCurCostReturnLength()
	return self.cost and #self.cost or 0
end

function UIPetDecomposeCtr:GetCostReturnByIdx(idx)
	return self.cost[idx + 1]
end 

function UIPetDecomposeCtr:GetVipPercent()
	local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	local val = 0
	if vipCfg and vipCfg.PetBreak >= 1 then
		val = GlobalConfig.Instance:GetConfigIntValue(222)
	else
		val = GlobalConfig.Instance:GetConfigIntValue(221)
	end
	return val * 0.01
end

function UIPetDecomposeCtr:GetDefaultCount()
	return defaultCount
end

function UIPetDecomposeCtr:GetAutoSelectedPetCount()
	return self.autoSelectedCount or 0
end

function UIPetDecomposeCtr:WasSkillUp(petData)
	for _,v in pairs(petData.skillList) do
		if v.level > 1 then
			return true
		end
	end
	return false
end

function UIPetDecomposeCtr:OneKeySelectPet()
	if not self.childCtr then return end

	if not self.selectedIds then
		self.selectedIds = {}
	end
	self.autoSelectedCount = 0

	local petDatas = self.childCtr:GetShowDatas()
	if petDatas then
		for i = 1, #petDatas do
			local data = petDatas[i]
			if #self.selectedIds < decomposeLimit then
				if self.data == DecomposeType.Pet then
					if data.quality <= autoQualityLimit and not data.isBattle and data.level == 1 and not data.isRelevant and not data.isSupport and not data.skillUp then
						if not CommonUtil.EleInTable(data.id, self.selectedIds) then
							self.selectedIds[#self.selectedIds + 1] = data.id
							data.selected = 1
						end
					end
				elseif self.data == DecomposeType.SkillEquip then
					if data.quality <= autoQualityLimit and data.starLv == 0 then
						if not CommonUtil.EleInTable(data.id, self.selectedIds) then
							self.selectedIds[#self.selectedIds + 1] = data.id
							data.selected = 1
						end
					end
				end
			else
				break
			end
		end
	end
end

function UIPetDecomposeCtr:OneKeyCancelSelectedPet()
	for _,v in pairs(self.selectedIds) do
		local showData = self:GetShowDataById(v)
		if showData then
			showData.selected = 0
		end
	end
	self.autoSelectedCount = defaultCount
	self.selectedIds = {}
end

function UIPetDecomposeCtr:ClearSelected()
	self.autoSelectedCount = nil
	self.selectedIds = {}
end

function UIPetDecomposeCtr:SendPetDecompose()
	if self.data == DecomposeType.Pet then
		ManagerContainer.DataMgr.PetDataMgr:SendPetDecompose(self.selectedIds)
	elseif self.data == DecomposeType.SkillEquip then
		ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipDecomposeReq(self.selectedIds)
	end
end

function UIPetDecomposeCtr:GetShowDataById(id)
	if self.childCtr and self.childCtr.GetPetDataById then
		return self.childCtr:GetPetDataById(id)
	end
	return nil
end

function UIPetDecomposeCtr:SetFilterData(data, isFilter)
	self.filterData = data
	self.isFilter = isFilter
end

function UIPetDecomposeCtr:GetFilterData()
	return self.filterData
end

function UIPetDecomposeCtr:GetIsFilter()
	return self.isFilter
end

function UIPetDecomposeCtr:OnDispose()
	self.filterData = nil
	self.isFilter = nil

	self.selectedIds = nil
	self.selectedPetDatas = nil
	self.childCtr = nil

	self.data = nil
	self.view = nil
end

return UIPetDecomposeCtr

