local UIPetContractAttributeCtr = class("UIPetContractAttributeCtr", require("UICtrBase"))
local sameNatureTypeAdd = 0

local sortAttrKey
local lockIds = {42,43,44,45,46,47}
function UIPetContractAttributeCtr:Init(view)
	self.view = view
end

function UIPetContractAttributeCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data

	sameNatureTypeAdd = GlobalConfig.Instance:GetConfigIntValue(351)* 0.01
	
	sortAttrKey = {}
	for k,v in pairs(Enum.HeroAttrType) do
		sortAttrKey[#sortAttrKey + 1] = v
	end
	table.sort(sortAttrKey, function (a,b)
		return a < b
	end)

	--self:RefreshAllQiyueAttrs()
	self:RefreshCurPetBattleLock()
end

function UIPetContractAttributeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetContractAttributeCtr:GetData()
	return self.data
end

function UIPetContractAttributeCtr:RefreshCurPetBattleLock()
	self.unlockCount = 0
	for i = 1,#lockIds do
		local unLockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(lockIds[i])
		if unLockState then
			self.unlockCount = self.unlockCount + 1
		else
			self.curLockContent = content
			break
		end
	end
end

function UIPetContractAttributeCtr:GetUnlockCount()
	return self.unlockCount
end

local function CalcPetQiyueAddAttrs(masterPetId, slotList)
	local baseAttrs = {}
	local addAttrs = {}
	local hasQiyue = false

	local masterData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(masterPetId)
	if not masterData then return baseAttrs, addAttrs, hasQiyue end
	for i = 1, #slotList do
		local data = slotList[i]
		if data.petId > 0 then
			local percent = 0
			local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(data.petId)
			local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
			local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(data.petId)
			if petData and petCfgData then
				if masterData.natureType == petData.natureType then
					percent = percent + sameNatureTypeAdd
				end
				percent = percent + petCfgData.contract * 0.01 + petData.totalSkillUpCount * petCfgData.understand * 0.01
			end
			for j = 1, #sortAttrKey do
				local key = sortAttrKey[j]
				if key >= Enum.HeroAttrType.Life and key <= Enum.HeroAttrType.CastAcceleration then
					local num = SDataUtil.InvConvert(actorData:GetFinalAttr(key))
					num = num*percent * 0.01
					if num > 0 then
						if not baseAttrs[key] then baseAttrs[key] = {key, 0, 0} end
						baseAttrs[key][2] = baseAttrs[key][2] + num
					end
				elseif key >= Enum.HeroAttrType.Nature_None_Damage_Percent  then
					local num = SDataUtil.InvConvert(actorData:GetFinalAttr(key))
					num = num*percent * 0.01

					if num > 0 then
						if not addAttrs[key] then addAttrs[key] = {key, 0, 0} end
						addAttrs[key][2] = addAttrs[key][2] + num
					end
				end
			end

			hasQiyue = true
		end
	end
	return baseAttrs, addAttrs, hasQiyue
end

function UIPetContractAttributeCtr:RefreshAllQiyueAttrs()
	sortAttrKey = {}
	for k,v in pairs(Enum.HeroAttrType) do
		sortAttrKey[#sortAttrKey + 1] = v
	end
	table.sort(sortAttrKey, function (a,b)
		return a < b
	end)

	local heroDatas = {}
	for i = 1, 6 do
		local data = CommonUtil.GetHeroLogicDataByUid(i)
		if data.isBattle then
			heroDatas[#heroDatas + 1] = data
		end
	end
	CommonUtil.ArraySortSelections(heroDatas, {Enum.TableSortRule.Up, Enum.TableSortRule.Down, Enum.TableSortRule.Down}, "id", "isBattle", "owned")

	self.battlePetDatas = {}
	self.totalQiyueBaseAttrs = {}
	self.totalQiyueAddAttrs = {}
	local totalQiyueBaseAttrs = {}
	local totalQiyueAddAttrs = {}
	self.hasQiyueList = {}
	self.petQiyueBaseAttrs = {}
	self.petQiyueAddAttrs = {}
	for i = 1, 4 do
		local data = heroDatas[i]
		if data then
			local qiyueData = data.petQiyueData
			local baseAttrs, addAttrs, hasQiyue = CalcPetQiyueAddAttrs(data.battlePetId, qiyueData.slotList)
			self.petQiyueBaseAttrs[i] = {}
			self.petQiyueAddAttrs[i] = {}
			self.hasQiyueList[i] = hasQiyue
			self.battlePetDatas[i] = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(data.battlePetId) 

			if baseAttrs then
				-- LogHRWarning(Inspect(baseAttrs))
				for k, v in pairs(baseAttrs) do
					self.petQiyueBaseAttrs[i][#self.petQiyueBaseAttrs[i] + 1] = v  
					if not totalQiyueBaseAttrs[v[1]] then totalQiyueBaseAttrs[v[1]] = {v[1], 0, 0} end
					totalQiyueBaseAttrs[v[1]][2] = totalQiyueBaseAttrs[v[1]][2] + v[2]
				end
			end
			if addAttrs then
				-- LogHRWarning(Inspect(addAttrs))
				for k, v in pairs(addAttrs) do
					self.petQiyueAddAttrs[i][#self.petQiyueAddAttrs[i] + 1] = v  
					if not totalQiyueAddAttrs[v[1]] then totalQiyueAddAttrs[v[1]] = {v[1], 0, 0} end
					totalQiyueAddAttrs[v[1]][2] = totalQiyueAddAttrs[v[1]][2] + v[2]
				end
			end
		end
	end
	-- LogHRWarning(Inspect(totalQiyueAddAttrs))
	for k, v in pairs(totalQiyueBaseAttrs) do
		self.totalQiyueBaseAttrs[#self.totalQiyueBaseAttrs + 1] = v  
	end
	for k, v in pairs(totalQiyueAddAttrs) do
		self.totalQiyueAddAttrs[#self.totalQiyueAddAttrs + 1] = v  
	end
end

local function PetHasQiyue(masterPetId, slotList)
	local hasQiyue = false

	local masterData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(masterPetId)
	if not masterData then return hasQiyue end
	for i = 1, #slotList do
		local data = slotList[i]
		if data.petId > 0 then
			hasQiyue = true
			break
		end
	end
	return hasQiyue
end

function UIPetContractAttributeCtr:RefreshQiyueAttrs()
	self.battlePetDatas = {}
	self.totalQiyueBaseAttrs = {}
	self.totalQiyueAddAttrs = {}
	self.hasQiyueList = {}
	self.petQiyueBaseAttrs = {}
	self.petQiyueAddAttrs = {}

	local heroDatas = {}
	for i = 1, 6 do
		local data = CommonUtil.GetHeroLogicDataByUid(i)
		if data.isBattle then
			heroDatas[#heroDatas + 1] = data
		end
	end
	CommonUtil.ArraySortSelections(heroDatas, {Enum.TableSortRule.Up, Enum.TableSortRule.Down, Enum.TableSortRule.Down}, "id", "isBattle", "owned")

	local totalQiyueBaseAttrs = {}
	local totalQiyueAddAttrs = {}

	for i = 1, 4 do
		local heroData = heroDatas[i]
		if heroData then
			local qiyueData = heroData.petQiyueData
			self.petQiyueBaseAttrs[i] = {}
			self.petQiyueAddAttrs[i] = {}
			self.hasQiyueList[i] = PetHasQiyue(heroData.battlePetId, qiyueData.slotList)
			self.battlePetDatas[i] = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(heroData.battlePetId) 

			if heroData.battlePetId > 0 then
				local curQiyueAttrs = ManagerContainer.DataMgr.PetDataMgr:GetQiyueAttrsById(heroData.battlePetId)
				if curQiyueAttrs then
					for j = 1, #sortAttrKey do
						local key = sortAttrKey[j]
						if key >= Enum.HeroAttrType.Life and key <= Enum.HeroAttrType.CastAcceleration then
							local num = curQiyueAttrs[key]
							if num and num > 0 then
								self.petQiyueBaseAttrs[i][#self.petQiyueBaseAttrs[i] + 1] = {key, num, 0}
								if not totalQiyueBaseAttrs[key] then totalQiyueBaseAttrs[key] = {key, 0, 0} end
								totalQiyueBaseAttrs[key][2] = totalQiyueBaseAttrs[key][2] + num
							end
						elseif key >= Enum.HeroAttrType.Nature_None_Damage_Percent  then
							local num = curQiyueAttrs[key]
							if num and num > 0 then
								num = num * 0.0001
								self.petQiyueAddAttrs[i][#self.petQiyueAddAttrs[i] + 1] = {key, num, 0}
								if not totalQiyueAddAttrs[key] then totalQiyueAddAttrs[key] = {key, 0, 0} end
								totalQiyueAddAttrs[key][2] = totalQiyueAddAttrs[key][2] + num
							end
						end
					end
				end
			end
		end
	end

	for i = 1, #sortAttrKey do
		local key = sortAttrKey[i]
		local num = totalQiyueBaseAttrs[key]
		if num then
			self.totalQiyueBaseAttrs[#self.totalQiyueBaseAttrs + 1] = num  
		end
		local num = totalQiyueAddAttrs[key]
		if num then
			self.totalQiyueAddAttrs[#self.totalQiyueAddAttrs + 1] = num  
		end
	end
end

function UIPetContractAttributeCtr:GetTotalQiyueAttrs()
	return self.totalQiyueBaseAttrs, self.totalQiyueAddAttrs
end

function UIPetContractAttributeCtr:GetPetQiyueAttrsByIdx(idx)
	return self.petQiyueBaseAttrs[idx], self.petQiyueAddAttrs[idx]
end

function UIPetContractAttributeCtr:IsPetHaveQiyueByIdx(idx)
	return self.hasQiyueList[idx]
end

function UIPetContractAttributeCtr:GetBattlePetDataByIdx(idx)
	return self.battlePetDatas[idx]
end

function UIPetContractAttributeCtr:QueryPetDetailInfo()
	ManagerContainer.DataMgr.PetDataMgr:QueryQiyueBattlePetAttrReq()
end

function UIPetContractAttributeCtr:OnDispose()
	sortAttrKey = {}
	self.totalQiyueAttrs = nil
	self.petQiyueAttrList = nil
	self.hasQiyueList = nil
	self.battlePetDatas = nil

	self.data = nil
	self.view = nil
end

return UIPetContractAttributeCtr

