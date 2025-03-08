local UIArtifactReforgeCtr = class("UIArtifactReforgeCtr", require("UICtrBase"))

local reforgeStarCount = 5
function UIArtifactReforgeCtr:Init(view)
	self.view = view
end

function UIArtifactReforgeCtr:SetData(data)
	reforgeStarCount = GlobalConfig.Instance:GetConfigIntValue(339)

	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIArtifactReforgeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIArtifactReforgeCtr:GetData()
	return self.data
end

function UIArtifactReforgeCtr:RefrshShowDatas(idx)
	self.curSelectedIdx = nil
	if idx == 1 then
		self.showDatas = self:RefreshReforgeDatas()
		self.curSelectedIdx = nil
	elseif idx == 2 then
		self.showDatas = self:RefreshReforgeDatas()
		self.leftSelectedIdx = nil
		self.rightSelectedIdx = nil
	end

	self.showDataLength = self.showDatas and #self.showDatas or 0
end

function UIArtifactReforgeCtr:RefreshReforgeDatas()
	local datas = ManagerContainer.DataMgr.SkillEquipData:GetSkillEquips()
	local list = {}
	for i = 1, #datas do
		if datas[i].maxStarLv >= reforgeStarCount then
			list[#list + 1] = datas[i]
			datas[i].reforgeSelected = false
			datas[i].transSelected = false
		end
	end
	CommonUtil.ArraySortSelections(list, Enum.TableSortRule.Down, "quality", "starLv", "cfgId", "id")
	return list
end

function UIArtifactReforgeCtr:GetShowDataLength()
	return self.showDataLength
end

function UIArtifactReforgeCtr:GetShowData(idx)
	return self.showDatas and self.showDatas[idx + 1] or nil 
end

function UIArtifactReforgeCtr:SetCurSelectedIdx(idx)
	local oldIdx
	if self.curSelectedIdx ~= idx then
		if self.curSelectedIdx then
			local oldData = self:GetShowData(self.curSelectedIdx - 1)
			if oldData then
				oldData.reforgeSelected = false
				oldIdx = self.curSelectedIdx
			end
		end

		self.curSelectedIdx = idx
		if idx then
			local data = self:GetShowData(idx - 1)
			if data then
				data.reforgeSelected = true
			end
		end
	else
		oldIdx = self.curSelectedIdx
		self.curSelectedIdx = nil
	end

	return oldIdx
end

function UIArtifactReforgeCtr:GetCurSelecteIdx()
	return self.curSelectedIdx
end

function UIArtifactReforgeCtr:SetTransSelected(idx)
	local function CheckTransError(leftIdx, rightIdx)
		if not leftIdx or not rightIdx then return 0 end
		local leftData = self:GetShowData(leftIdx - 1)
		local rightData = self:GetShowData(rightIdx - 1)
		if leftData.maxStarLv ~= rightData.maxStarLv then
			return 1
		elseif leftData.starLv == rightData.starLv then
			return 2
		elseif leftData.cfgId == rightData.cfgId then
			return 3
		else
			return 0
		end
	end
	local oldIdx, newIdx

	if self.leftSelectedIdx == idx then
		oldIdx = self.leftSelectedIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.transSelected = false
			end
		end
		self.leftSelectedIdx = nil
		return 0, oldIdx, newIdx
	elseif self.rightSelectedIdx == idx then
		oldIdx = self.rightSelectedIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.transSelected = false
			end
		end
		self.rightSelectedIdx = nil
		return 0, oldIdx, newIdx
	end

	if (self.leftSelectedIdx and self.leftSelectedIdx == idx) or not self.leftSelectedIdx then
		local checkCode = CheckTransError(idx, self.rightSelectedIdx)
		if checkCode > 0 then
			return checkCode
		end
		oldIdx = self.leftSelectedIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.transSelected = false
			end
		end
		if idx == oldIdx then idx = nil end
		if idx then
			local oldData = self:GetShowData(idx - 1)
			if oldData then
				oldData.transSelected = true
			end
		end
		self.leftSelectedIdx = idx
		return 0, oldIdx, newIdx
	end
	if (self.rightSelectedIdx and self.rightSelectedIdx == idx) or not self.rightSelectedIdx then
		local checkCode = CheckTransError(self.leftSelectedIdx, idx)
		if checkCode > 0 then
			return checkCode
		end
		oldIdx = self.rightSelectedIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.transSelected = false
			end
		end
		if idx == oldIdx then idx = nil end
		if idx then
			local oldData = self:GetShowData(idx - 1)
			if oldData then
				oldData.transSelected = true
			end
		end
		self.rightSelectedIdx = idx
		return 0, oldIdx, newIdx
	end
	
	if self.leftSelectedIdx ~= idx and self.rightSelectedIdx ~= idx then return 4 end
end

function UIArtifactReforgeCtr:GetTransSelectedIdx()
	return self.leftSelectedIdx, self.rightSelectedIdx
end

function UIArtifactReforgeCtr:ClearLeftTransSelectedIdx()
	if self.leftSelectedIdx then
		local oldData = self:GetShowData(self.leftSelectedIdx - 1)
		if oldData then
			oldData.transSelected = false
		end
	end
	self.leftSelectedIdx = nil
end

function UIArtifactReforgeCtr:ClearRightTransSelectedIdx()
	if self.rightSelectedIdx then
		local oldData = self:GetShowData(self.rightSelectedIdx - 1)
		if oldData then
			oldData.transSelected = false
		end
	end
	self.rightSelectedIdx = nil
end

function UIArtifactReforgeCtr:SendReforgeReq()
	local curIdx = self:GetCurSelecteIdx()
	if not curIdx then
		return
	end
	local skillEuipData = self:GetShowData(curIdx - 1)
	if skillEuipData then
		ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipReforgeReq(skillEuipData.id)
	end
end

function UIArtifactReforgeCtr:SendTransReq()
	local leftData = self:GetShowData(self.leftSelectedIdx - 1)
	local rightData = self:GetShowData(self.rightSelectedIdx - 1)
	ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipShiftReq(leftData.id, rightData.id)
end

function UIArtifactReforgeCtr:GetOldLeftAndRightData()
	local leftData = self:GetShowData(self.leftSelectedIdx - 1)
	local rightData = self:GetShowData(self.rightSelectedIdx - 1)
	return leftData, rightData
end

function UIArtifactReforgeCtr:OnDispose()
	if self.showDatas then
		for _,v in pairs(self.showDatas) do
			v.reforgeSelected = false
			v.transSelected = false
		end
		self.showDatas = nil
	end

	self.oldLeftData = nil
	self.oldRighttData = nil
	self.data = nil
	self.view = nil
end

return UIArtifactReforgeCtr

