local UIPetBattleCtr = class("UIPetBattleCtr", require("UICtrBase"))

local lockIds = {42,43,44,45,46,47}
function UIPetBattleCtr:Init(view)
	self.view = view
end

function UIPetBattleCtr:SetData(data)
	if self.filterData == nil then
		self.filterData = {}
		self.filterData.raritySelections = {}
		self.filterData.attrSelections = {}
		self.filterData.typeSelections = {}
		self.isFilter = false
	end

	self:InitHeroBattleDatas()

	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetBattleCtr:GetData()
	return self.data
end

function UIPetBattleCtr:GetList()
	if not self.data then
		return nil
	end
	return self.data.list
end

function UIPetBattleCtr:GetCurSelectedId()
	if not self.data then
		return nil
	end
	return self.data.curId
end

function UIPetBattleCtr:InitCurSelectedData()
	local curId = self:GetCurSelectedId()
	if not curId then return false end

	return self:GetPetDataById(curId)
end

function UIPetBattleCtr:SetChildController(ctr)
	self.childCtr = ctr
end

function UIPetBattleCtr:InitHeroBattleDatas()
	self.heroBattleDatas = {}
	self.heroBattlePetIds = {}

	for i = 1, 6 do
		local heroData = CommonUtil.GetHeroLogicDataByUid(i)
		self.heroBattleDatas[i] = heroData
		self.heroBattlePetIds[i] = heroData.battlePetId
	end
end

function UIPetBattleCtr:GetBattlePetCount()
	local length = 0
	for _,v in pairs(self.heroBattlePetIds) do
		if v > 0 then
			length = length + 1
		end
	end
	return length
end

function UIPetBattleCtr:GetHeroDataByUid(id)
	if not self.heroBattleDatas then return end

	return self.heroBattleDatas[id]
end

function UIPetBattleCtr:GetSlotUnLockState(idx)
	return ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(lockIds[idx])
end

function UIPetBattleCtr:RefreshCurPetBattleLock()
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
	self.lockCount = #lockIds - self.unlockCount
end

function UIPetBattleCtr:GetUnlockCount()
	return self.unlockCount
end

function UIPetBattleCtr:GetLockCount()
	return self.lockCount
end

function UIPetBattleCtr:GetLockContent()
	return self.curLockContent
end

function UIPetBattleCtr:RefreshPetDatas()
	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	local petDatas = petDatasSource
	if self.isFilter then
		petDatas = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"quality", "Attribute", "natureType"}, {self.filterData.raritySelections, self.filterData.attrSelections, self.filterData.typeSelections})
	end
	if petDatas ~= nil then
		petDatas = CommonUtil.ArrayFilterSelections(petDatas, Enum.FilterType.AND, {"qiyueHeroId"}, {0})
		CommonUtil.ArraySortSelections(petDatas, Enum.TableSortRule.Down, "isBattle", "quality", "advanceLevel", "level", "isRelevant", "isSupport", "totalFightPower", "cfgId")

		--for _, v in pairs(petDatas) do
		--	if v.heroId > 0 then
		--		v.selected = 1
		--	end
		--end
	end

	if petDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	return petDatas
end

function UIPetBattleCtr:SetCurSelectedPetData(data)
	if self.lastSelectedData then
		self.lastSelectedData.selected = 0
	end
	if data then
		data.selected = 1
	end
	self.curSelectedData = data
	self.lastSelectedData = self.curSelectedData
	return data and self:GetPetDataIdxById(data.id) or nil
end

function UIPetBattleCtr:GetPetDataIdxById(id)
	if self.childCtr then
		local data,idx = self.childCtr:GetPetDataById(id)
		return idx
	end
	return nil
end

function UIPetBattleCtr:GetCurSelectedPetData()
	return self.curSelectedData
end

function UIPetBattleCtr:GetLastSelectedPetData()
	return self.lastSelectedData
end

function UIPetBattleCtr:GetPetDataById(id)
	if self.childCtr then
		return self.childCtr:GetPetDataById(id)
	end
	return nil
end

function UIPetBattleCtr:SetPetBattlePetId(idx, id)
	self.heroBattlePetIds[idx] = id or 0
end

function UIPetBattleCtr:GetPetBattlePetId(idx)
	return self.heroBattlePetIds[idx]
end

function UIPetBattleCtr:HasSamePetInBattle(id, idx)
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	for k,v in pairs(self.heroBattlePetIds) do
		if v ~= 0 then
			local petData1 = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(v)
			if petData.cfgId == petData1.cfgId then
				if idx ~= k then
					return id ~= v
				end
			end
		end
	end

	return false
end

function UIPetBattleCtr:SendPetBattle(oneKeyDown)
	self:ClearSelectedInfo()
	local map = {}
	if not oneKeyDown then
		for k,v in pairs(self.heroBattlePetIds) do
			local heroData = self:GetHeroDataByUid(k)
			if k == 1 or heroData.owned then
				map[#map + 1] = {key = heroData.id, value = v}
			end
		end
	else
		for i = 1, 6 do
			local heroData = self:GetHeroDataByUid(i)
			if heroData and (heroData.id == 1 or heroData.owned) and heroData.battlePetId > 0 then
				map[#map + 1] = {key = heroData.id, value = 0}
			end
		end
	end

	if #map > 0 then
		ManagerContainer.DataMgr.PetDataMgr:SendPetBattle(map)
	end
end

function UIPetBattleCtr:ClearSelectedInfo()
	if self.curSelectedData then
		self.curSelectedData.selected = 0
	end
	if self.lastSelectedData then
		self.lastSelectedData.selected = 0
	end
	
	self.curSelectedData = nil
	self.lastSelectedData = nil
end

function UIPetBattleCtr:SetFilterData(data, isFilter)
	self.filterData = data
	self.isFilter = isFilter
end

function UIPetBattleCtr:GetFilterData()
	return self.filterData
end

function UIPetBattleCtr:GetIsFilter()
	return self.isFilter
end

function UIPetBattleCtr:GetShowDataLength()
	if self.childCtr then
		return self.childCtr:GetShowDataLength()
	end
	return 0
end

function UIPetBattleCtr:OnDispose()
	self.childCtr = nil
	self.heroBattlePetIds = nil
	self.heroBattleDatas = nil
	self.curSelectedData = nil
	self.lastSelectedData = nil

	self.filterData = nil
	self.isFilter = nil

	self.data = nil
	self.view = nil
end

return UIPetBattleCtr

