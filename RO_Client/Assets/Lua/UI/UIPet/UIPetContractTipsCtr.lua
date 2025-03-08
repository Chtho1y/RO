local UIPetContractTipsCtr = class("UIPetContractTipsCtr", require("UICtrBase"))
local PetMatsGridView = require("UIPet/PetMatsGridView")
local RectOffset = UnityEngine.RectOffset

function UIPetContractTipsCtr:Init(view)
	self.view = view
end

function UIPetContractTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(self:GetSelectedPetId())
	self:SetSelectedData(petData)
end

function UIPetContractTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetContractTipsCtr:GetData()
	return self.data
end

function UIPetContractTipsCtr:GetHeroId()
	return self.data[1]
end

function UIPetContractTipsCtr:GetSlotIdx()
	return self.data[2]
end

function UIPetContractTipsCtr:GetSelectedPetId()
	return self.data[3]
end

function UIPetContractTipsCtr:GetQiyuePetId()
	return self.data[4]
end

function UIPetContractTipsCtr:SetChildController(ctr)
	self.childCtr = ctr
end

function UIPetContractTipsCtr:SetSelectedData(data)
	local lastData = self.selectedData
	if self.selectedData == data then
		if data then
			data.selected = 0
		end
		self.selectedData = nil
	else
		self.selectedData = data
		if data then
			data.selected = 1
		end
	end
	if lastData then
		lastData.selected = 0
	end
	return lastData
end

function UIPetContractTipsCtr:GetSelectedData()
	return self.selectedData
end

function UIPetContractTipsCtr:RefreshPetDatas()
	local petDatasSource = ManagerContainer.DataMgr.PetDataMgr:GetPetDatas()
	--策划要求战力加入排序
	for _,v in pairs(petDatasSource) do
		v.totalFightPower = ManagerContainer.DataMgr.PetDataMgr:GetTotalFightPower(v.id)
	end

	local petDatas
	petDatas = CommonUtil.ArrayFilterSelections(petDatasSource, Enum.FilterType.AND, {"isBattle"}, {false})

	if petDatas ~= nil then
		if self.selectedData then
			self.selectedData.selected = 1
		end
		--CommonUtil.ArraySortSelections(petDatas, Enum.TableSortRule.Down, "isBattle", "isRelevant", "isSupport", "quality", "totalFightPower", "cfgId", "id")
		CommonUtil.ArraySortListSelections(petDatas, {Enum.TableSortRule.Up, Enum.TableSortRule.Down, Enum.TableSortRule.Down, Enum.TableSortRule.Down}, {"qiyueHeroId", "quality", "totalSkillUpCount", "level"})
	end

	if petDatas == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	end

	return petDatas
end

function UIPetContractTipsCtr:SendSlotChangeReq(petId)
	local heroId = self:GetHeroId()
	local idx = self:GetSlotIdx()
	if self.selectedData then
		if self.selectedData.id ~= self:GetSelectedPetId() then
			ManagerContainer.DataMgr.PetDataMgr:SendQiyueSlotInReq(heroId, idx, self.selectedData.id)
		end
	else
		ManagerContainer.DataMgr.PetDataMgr:SendQiyueSlotOutReq(heroId, idx)
	end
end

function UIPetContractTipsCtr:GetPetDataIdxInShowDatas(id)
	if self.childCtr then
		return self.childCtr:GetPetDataById(id)
	end
	return nil
end

function UIPetContractTipsCtr:OnDispose()
	self.selectedData = nil
	self.childCtr = nil

	self.data = nil
	self.view = nil
end

return UIPetContractTipsCtr

