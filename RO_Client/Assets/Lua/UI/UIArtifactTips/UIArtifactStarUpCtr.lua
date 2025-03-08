local UIArtifactStarUpCtr = class("UIArtifactStarUpCtr", require("UICtrBase"))

function UIArtifactStarUpCtr:Init(view)
	self.view = view
end

function UIArtifactStarUpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	self.skillEquipData = data[1]
	self.heroId = data[2]

	self.selectedIds = {}
end

function UIArtifactStarUpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIArtifactStarUpCtr:GetData()
	return self.data
end

function UIArtifactStarUpCtr:GetSkillEquipData()
	return self.data[1]
end

function UIArtifactStarUpCtr:GetHeroId()
	return self.data[2]
end

function UIArtifactStarUpCtr:GetHeroCfgId()
	return self.data[3]
end

function UIArtifactStarUpCtr:GetHeroNickname()
	return self.data[4]
end

function UIArtifactStarUpCtr:RefreshShowDatas()
	self.showDatas = self:RefreshStarUpCostSkillEquipDatas()
    local showDataLength = 0
    if self.showDatas then
        showDataLength = #self.showDatas
        if self.row and self.minColumn then
            local curColumn = Mathf.Ceil(showDataLength / self.row) + 2
            if curColumn < self.minColumn then
                curColumn = self.minColumn
            end
            showDataLength = curColumn * self.row
        end
    end
    self.showDataLength = showDataLength
end

local conditionCound = 0
function UIArtifactStarUpCtr:RefreshStarUpCostSkillEquipDatas()
	conditionCound = 0
	local skillEquipData = self.skillEquipData
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
	if not cfgData then
		return
	end
	local starLv = skillEquipData.starLv
	if starLv >= skillEquipData.maxStarLv then
		return
	end
	local cost = cfgData.Condition[starLv + 1][1]
	conditionCound = cost[2]

	local skillEquipDatas = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquips()
	
	if not skillEquipDatas or not next(skillEquipDatas) then return end

	local list = {}
	for _,v in pairs(skillEquipDatas) do
		if cost[1] == v.cfgId and v.starLv == 0 then
			list[#list + 1] = v
		end
	end
	
	CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "quality", "maxStarLv", "cfgId")

	return list
end

function UIArtifactStarUpCtr:SetGridRowColumn(row, minColumn)
    self.row = row
    self.minColumn = minColumn
end

function UIArtifactStarUpCtr:GetShowDataLength()
    return self.showDataLength or 0
end

function UIArtifactStarUpCtr:IsCostSkillEuipEnough()
	local count = #self.selectedIds
    return count >= conditionCound
end

function UIArtifactStarUpCtr:GetShowData(itemIndex)
    return self.showDatas and self.showDatas[itemIndex + 1] or nil
end

function UIArtifactStarUpCtr:ClearSelected()
	self.selectedIds = {}
end

function UIArtifactStarUpCtr:SelectSkillEquip(data)
	local oldId
	local result, idx = CommonUtil.EleInTable(data.id, self.selectedIds)
	if idx then
		data.selected = 0
		table.remove(self.selectedIds, idx)
	else
		if #self.selectedIds >= conditionCound then
			if conditionCound >= 2 then
				return
			elseif conditionCound == 1 then
				local oldData = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquipDataByUid(self.selectedIds[1])
				if oldData then
					oldId = oldData.id
					oldData.selected = 0
				end
				table.remove(self.selectedIds, 1)
			end
		end
		data.selected = 1
		table.insert(self.selectedIds, data.id)
	end

	if oldId then
		for i = 1, #self.showDatas do
			if self.showDatas[i].id == oldId then
				return i
			end
		end
	end
end

function UIArtifactStarUpCtr:GetSelectedCostCount()
	return #self.selectedIds
end

function UIArtifactStarUpCtr:SendStarUpReq()
	ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipStarUpReq(self.heroId, self.skillEquipData.id, self.selectedIds)
end

function UIArtifactStarUpCtr:OnDispose()
	if self.selectedIds then
		for i = 1, #self.selectedIds do
			local data = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquipDataByUid(self.selectedIds[i])
			if data then
				data.selected = 0
			end
		end
		self.selectedIds = nil
	end

	self.data = nil
	self.view = nil
end

return UIArtifactStarUpCtr

