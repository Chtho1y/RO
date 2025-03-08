local UIPetRootCtr = class("UIPetRootCtr", require("UICtrBase"))

local qiyueSlotUnlockCost
local lockIds = {42,43,44,45,46,47}
function UIPetRootCtr:Init(view)
	self.view = view
end

function UIPetRootCtr:SetData(data)
	if self.filterData == nil then
		self.filterData = {}
		self.filterData.raritySelections = {}
		self.filterData.attrSelections = {}
		self.filterData.typeSelections = {}
		self.isFilter = false
	end

	local val = GlobalConfig.Instance:GetConfigStrValue(350)
	if val ~= "" and val ~= nil then
		qiyueSlotUnlockCost = CommonUtil.DeserializeGlobalStrToTable(val)
	end
	self:RefreshCurPetBattleLock()
	
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetRootCtr:GetShowDataRealLength()
	return self.showDatas and #self.showDatas or 0
end

function UIPetRootCtr:GetShowData(itemIndex)
	return self.showDatas and self.showDatas[itemIndex + 1] or nil
end

function UIPetRootCtr:RefreshCurPetBattleLock()
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

function UIPetRootCtr:GetPetBattleUnlockCount()
	return self.unlockCount
end

function UIPetRootCtr:CalcUnlockSlot(slotList)
	local state = false
	local idx = #slotList + 1
	local cost = qiyueSlotUnlockCost[idx]
	if not cost then
		return false
	end
	local costId = tonumber(cost[1])
	local costNum = tonumber(cost[2])
	local count = CommonUtil.GetOwnResCountByItemId(costId)
	return count >= costNum, idx, costId, count, costNum
end

function UIPetRootCtr:RefreshQiyueDatas()
	self:HasEnoughPet()

	if self.showDatas then return end
	self.showDatas = {}
	for i = 1, 6 do
		local data = CommonUtil.GetHeroLogicDataByUid(i)
		self.showDatas[#self.showDatas + 1] = data
	end
	CommonUtil.ArraySortSelections(self.showDatas, {Enum.TableSortRule.Up, Enum.TableSortRule.Down, Enum.TableSortRule.Down}, "id", "isBattle", "owned")
end

function UIPetRootCtr:RefreshPetDatas()
	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	--策划要求战力加入排序
	for _,v in pairs(petDatasSource) do
		v.totalFightPower = ManagerContainer.DataMgr.PetDataMgr:GetTotalFightPower(v.id)
	end

	local petDatas
	petDatas = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"quality", "Attribute", "natureType"}, {self.filterData.raritySelections, self.filterData.attrSelections, self.filterData.typeSelections})

	if petDatas ~= nil then
		CommonUtil.ArraySortSelections(petDatas, Enum.TableSortRule.Down, "isBattle", "isRelevant", "isSupport", "quality", "level", "totalFightPower", "cfgId", "id")
	end

	if petDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end
	
	return petDatas
end

function UIPetRootCtr:SetFilterData(data, isFilter)
	self.filterData = data
	self.isFilter = isFilter
end

function UIPetRootCtr:GetFilterData()
	return self.filterData
end

function UIPetRootCtr:GetIsFilter()
	return self.isFilter
end

function UIPetRootCtr:HasEnoughPet()
	self.hasFreePet = false
	local petDatas = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	for i = 1, #petDatas do
		if not petDatas[i].isBattle and petDatas[i].qiyueHeroId == 0 then
			self.hasFreePet = true
			return
		end
	end
end

function UIPetRootCtr:HeroRemoveAllQiyueSlot(heroId)
	ManagerContainer.DataMgr.PetDataMgr:SendQiyueSlotOutReq(heroId, 0)
end

function UIPetRootCtr:SendQiyueUnlockReq(heroId)
	ManagerContainer.DataMgr.PetDataMgr:SendQiyueUnlockReq(heroId)
end

function UIPetRootCtr:CanFreeQiyuePet()
	return self.hasFreePet
end

function UIPetRootCtr:SetQueryPetId(id)
	self.queryPetId = id
end

function UIPetRootCtr:GetQueryPetId()
	return self.queryPetId
end

function UIPetRootCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetRootCtr:GetData()
	return self.data
end

function UIPetRootCtr:OnDispose()
	self.filterData = nil
	self.isFilter = nil
	self.showDatas = nil

	self.data = nil
	self.view = nil
end

return UIPetRootCtr

