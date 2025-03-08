local UIPetLvUpCtr = class("UIPetLvUpCtr", require("UICtrBase"))

local advenceLvStage
local lastAttrs = {}
local newAttrs = {}
local commonSkillMatId = 819
function UIPetLvUpCtr:Init(view)
	self.view = view

	local val = GlobalConfig.Instance:GetConfigStrValue(208)
	if val ~= "" and val ~= nil then
		advenceLvStage = CommonUtil.DeserializeGlobalStrToTable(val)
	end

	commonSkillMatId = GlobalConfig.Instance:GetConfigIntValue(313)
end

function UIPetLvUpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetLvUpCtr:GetCurPetData()
	local id = self.data
	self.curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	return self.curPetData
end

function UIPetLvUpCtr:GetCurPetMaxLv()
	if next(advenceLvStage) == nil then
		return 0
	end
	return tonumber(advenceLvStage[self.curPetData.advanceLevel + 1] or 0), self.curPetData.advanceLevel + 1 == #advenceLvStage
end

function UIPetLvUpCtr:GetPetMaxLv()
	return ManagerContainer.CfgMgr:GetPetExpCfgMaxData()
end

function UIPetLvUpCtr:GetCurAdvenceMaxLv()
	if next(advenceLvStage) == nil then
		return 0
	end
	if not self.curPetData then
		self.curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(self.data)
	end
	return tonumber(advenceLvStage[self.curPetData.advanceLevel] or 0), tonumber(advenceLvStage[self.curPetData.advanceLevel + 1] or 0)
end

function UIPetLvUpCtr:GetSimpleSecondAttrs()
	local id = self.data
	local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(id)
	if not actorData then
		return
	end

	if self.simpleAttrs == nil then
		self.simpleAttrs = {}
	end

	self.simpleAttrs[Enum.HeroAttrType.Life] = actorData:GetFinalAttr(Enum.HeroAttrType.Life)
	self.simpleAttrs[Enum.HeroAttrType.Sp] = actorData:GetFinalAttr(Enum.HeroAttrType.Sp)
	self.simpleAttrs[Enum.HeroAttrType.Attack] = actorData:GetFinalAttr(Enum.HeroAttrType.Attack)
	self.simpleAttrs[Enum.HeroAttrType.MagicAttack] = actorData:GetFinalAttr(Enum.HeroAttrType.MagicAttack)
	self.simpleAttrs[Enum.HeroAttrType.Defense] = actorData:GetFinalAttr(Enum.HeroAttrType.Defense)
	self.simpleAttrs[Enum.HeroAttrType.MagicDefense] = actorData:GetFinalAttr(Enum.HeroAttrType.MagicDefense)
	return self.simpleAttrs
end

function UIPetLvUpCtr:GetCurPetAttr(key)
	local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(self.data)
	return actorData:GetFinalAttr(key)
end

function UIPetLvUpCtr:SendPetLvUp()
	ManagerContainer.DataMgr.PetDataMgr:SendPetLvUp(self.data)
end

function UIPetLvUpCtr:AttrsChanged(tbArrtDeffrent)
    if tbArrtDeffrent ~= nil then
        for i=1,#tbArrtDeffrent do
            local Data = tbArrtDeffrent[i]
            local IsHero  = Data.is_hero_pet 
            local ActorId  = Data.actor_id 
            if self.data == ActorId and not IsHero then
                local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(self.data)
                lastAttrs = {}
				newAttrs = {}
                for k,v in pairs(Enum.HeroAttrType) do
                    newAttrs[v] = math.floor(SDataUtil.InvConvert(actorData:GetFinalAttr(v)))
                    local Dif = Data:GetAttribute(v)                    
                    if Dif == nil then
                        Dif = 0
                    end
                    lastAttrs[v] = newAttrs[v] - Dif
                end
                ManagerContainer.LuaUIMgr:AttrNoticeDisplay1( {lastAttrs, newAttrs})
            end
        end
    end    
end

function UIPetLvUpCtr:RefreshLeftPet()
	self.data = ManagerContainer.DataMgr.PetDataMgr:GetNextSortId(self.data, false)
end

function UIPetLvUpCtr:RefreshRightPet()
	self.data = ManagerContainer.DataMgr.PetDataMgr:GetNextSortId(self.data, true)
end

function UIPetLvUpCtr:SetSkillUpMatId(id)
	self.skillUpMat = id
end

function UIPetLvUpCtr:GetSkillUpMat()
	return self.skillUpMat
end

function UIPetLvUpCtr:SendPetSkillUp()
	ManagerContainer.DataMgr.PetDataMgr:SendPetSkillUp(self.data, self.skillUpMat)
end

-- function UIPetLvUpCtr:GetScale()
-- 	LogError(tostring(self.data))
-- 	local PetActor = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(self.data)
-- 	local Scale = PetActor:GetScale()
-- 	return Scale
-- end

function UIPetLvUpCtr:GetScale()
	if not self.curPetData then 
		return  1 
	end
	-- LogError(Inspect(self.curPetData.skillList))
	local Nveragelevles = 0
	local nCount = 0
	for _,v in pairs(self.curPetData.skillList) do
		Nveragelevles = Nveragelevles + v.level 
		nCount = nCount + 1
	end
	-- if nCount > 0 then
	-- 	Nveragelevles = math.ceil(Nveragelevles / nCount)
	-- end
	-- if Nveragelevles < 1 then
	-- 	Nveragelevles = 1
	-- end
	Nveragelevles = Nveragelevles - nCount
	if Nveragelevles <= 0 then
		Nveragelevles = 0
	end

	local Scale = 1
	local cfg = GlobalConfig.Instance:GetConfigStrValue(318)
	if cfg and cfg ~= '' then
        local itemCfgs = string.split(cfg, ';')
        if itemCfgs then      
            for _,v in pairs(itemCfgs) do
                if v and v ~= '' then
                    local itemCfg = string.split(v, ':')
                    if itemCfg and #itemCfg >= 2 then
						local nLevel = tonumber(itemCfg[1])
						local fScale = tonumber(itemCfg[2])
						if nLevel <= Nveragelevles then
							Scale = fScale
						end
                    end
                end
            end
        end
    end
	return Scale
end

function UIPetLvUpCtr:GetCurPetSkillData(id)
	if not self.curPetData then return end

	for _,v in pairs(self.curPetData.skillList) do
		if v.cfgId == id then
			return v
		end
	end
	return
end

function UIPetLvUpCtr:GetPetActorData()
	local id = self.data
	local actorData = ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(id)
	if not actorData then
		return
	end

	return actorData
end

function UIPetLvUpCtr:IsSkillMax()
	if not self.curPetData then return false end

	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(self.curPetData.cfgId)
	local maxLimit = #petCfgData.Skill1Rate
	for _,v in pairs(self.curPetData.skillList) do
		if v.level < maxLimit then
			return false
		end
	end
	return true
end

function UIPetLvUpCtr:GetRelationAddAttrs()
	local function GetMaxActiveRelationIdx(relationPets, cfgData)
		local count = 3
		local maxIdx = 0
		for j = 3, 1, -1 do
			local condition = cfgData['Condition'..j]
			local state
			if condition then
				local curCount = 0
				if relationPets then
					for k,v1 in pairs(relationPets) do
						local cfgId = condition[k][1]
						local num = condition[k][2]
						if v1.cfgId == cfgId and v1.advanceLevel >= num and v1.petId > 0 then
							curCount = curCount + 1
						end
					end
				end

				state = curCount >= count
				if state then
					if maxIdx == 0 then
						maxIdx = j
					end
				end
			end
		end
		return maxIdx
	end

	local list = {}
	local petData = self:GetCurPetData()
	local relationDatas = ManagerContainer.DataMgr.PetDataMgr:GetAllPetRelationDatas()
	for _,v in pairs(relationDatas) do
		local cfgData = ManagerContainer.CfgMgr:GetPetPartnerDataById(v.cfgId)
		local maxIdx = GetMaxActiveRelationIdx(v.relationPets, cfgData)
		if maxIdx > 0 then
			for i = maxIdx, 1, -1 do
				for k, v1 in pairs(cfgData["attribute"..i]) do
					if not list[v1[1]] then
						list[v1[1]] = 0
					end
					list[v1[1]] = list[v1[1]] + v1[2]
				end
			end
		end
	end
	return list
end

function UIPetLvUpCtr:SendPetBattleDown()
	local petData = self:GetCurPetData()
	if petData.heroId > 0 then
		local data = {{key = petData.heroId, value = 0}}
		ManagerContainer.DataMgr.PetDataMgr:SendPetBattle(data)
	end
end

function UIPetLvUpCtr:SetSlotCount(count)
	self.slotCount = count
end

function UIPetLvUpCtr:RefreshSlotRPState()

end

function UIPetLvUpCtr:SendOneKeyUp()
	local petData = self:GetCurPetData()
	if not petData then return end

	local slots = petData.slots
	local kvList = {}
	for i = 1, self.slotCount do
		local slot = slots and slots[i] or nil
		local state = slot and (slot.stampId > 0) or false
		if not state then
			local list, qualityStamp = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetAllPetStampDatasByTypeExcludeId(i)
			if qualityStamp and qualityStamp.petId == 0 then
				kvList[#kvList + 1] = {key = i, value = qualityStamp.id}
			end
		end
	end

	if #kvList > 0 then
		ManagerContainer.DataMgr.PetDataMgr:SendStampUpReq(self.data, kvList)
	end
end

function UIPetLvUpCtr:SendOneKeyDown()
	local petData = self:GetCurPetData()
	if not petData then return end

	local slots = petData.slots
	local canDown = false
	for i = 1, self.slotCount do
		local slot = slots and slots[i] or nil
		local state = slot and (slot.stampId > 0) or false
		if state then
			canDown = true
			break
		end
	end

	if canDown then
		ManagerContainer.DataMgr.PetDataMgr:SendStampDownReq(self.data, 0)
	end
end

function UIPetLvUpCtr:RefreshSkillMatsData()
	if not self.curPetData then return end
	if self.skillUpMat then return end

	self.skillUpMat = nil

	local selfId = self.curPetData.id
	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	local petDatas = petDatasSource
	local petData = self.curPetData

	local selfDatas = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"cfgId", "qiyueHeroId"}, {petData.cfgId, 0})
	for j = #selfDatas, 1, -1 do
		if selfDatas[j].id == selfId then
			table.remove(selfDatas, j)
			break
		end
	end

	if #selfDatas > 0 then
		CommonUtil.ArraySortSelections(selfDatas, Enum.TableSortRule.Up, "isBattle", "quality", "isSupport", "isRelevant", "advanceLevel", "level", "cfgId")
		if #selfDatas > 0 then
			self.skillUpMat = selfDatas[1].id
			return
		end
	end

	local commonDatas = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"cfgId", "qiyueHeroId"}, {commonSkillMatId, 0})

	for j = #commonDatas, 1, -1 do
		if commonDatas[j].id == selfId then
			table.remove(commonDatas, j)
			break
		end
	end

	if #commonDatas > 0 then
		CommonUtil.ArraySortSelections(commonDatas, Enum.TableSortRule.Up, "isBattle", "quality", "isSupport", "isRelevant", "advanceLevel", "level", "cfgId")
		if #commonDatas > 0 then
			self.skillUpMat = commonDatas[1].id
			return
		end
	end
	
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petstudy_003")
end

function UIPetLvUpCtr:GetSkillMatPetData()
	if not self.skillUpMat then return end

	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(self.skillUpMat)
	return petData
end

function UIPetLvUpCtr:WasSkillUp(petData)
	if not petData.skillList then return false end

	for _,v in pairs(petData.skillList) do
		if v.level > 1 then
			return true
		end
	end
	return false
end

function UIPetLvUpCtr:QueryPetDetailInfo()
	ManagerContainer.DataMgr.PetDataMgr:QueryPetDetailInfos({self.data})
end

function UIPetLvUpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetLvUpCtr:GetData()
	return self.data
end

function UIPetLvUpCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.curSkillMat = nil
end

return UIPetLvUpCtr

