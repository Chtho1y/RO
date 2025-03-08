local UIEquipListCtr = class("UIEquipListCtr", require("UICtrBase"))

function UIEquipListCtr:Init(view)
	self.view = view
end

function UIEquipListCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIEquipListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIEquipListCtr:GetData()
	return self.data
end
-- 获得道具配置id
function UIEquipListCtr:GetCfgId()
	return self.data[1].cfgId
end

function UIEquipListCtr:GetLogicData()
	return self.data[1].logicData
end

function UIEquipListCtr:GetSlotIndex()
	return self.data[1].slotIndex
end

function UIEquipListCtr:GetSlotType()
	return self.data[1].slotType
end

function UIEquipListCtr:GetCallBackOwner()
	return self.data[1].cbOwner
end

function UIEquipListCtr:GetJobType()
	return self.data[1].jobType
end

function UIEquipListCtr:GetCallBack()
	return self.data[1].cb
end

function UIEquipListCtr:GetCallBack1()
	return self.data[1].cb1
end

function UIEquipListCtr:GetEnterType()
	return self.data[2]
end

function UIEquipListCtr:GetFilterSkillEquips()
	local jobType = self:GetJobType()
	local skillEquipDatas = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquips()
	if skillEquipDatas then
		CommonUtil.ArraySortSelections(skillEquipDatas, Enum.TableSortRule.Down, "starLv", "quality", "maxStarLv", "cfgId")
	end
	return skillEquipDatas
end

function UIEquipListCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIEquipListCtr

