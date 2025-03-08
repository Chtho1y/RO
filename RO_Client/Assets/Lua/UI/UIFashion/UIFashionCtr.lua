local UIFashionCtr = class("UIFashionCtr", require("UICtrBase"))

local SortRule = function(a, b)
	local fashionUpData = ManagerContainer.DataMgr.UserData:GetViewData().fashionData
	local fashionIdA = a.FashionId
	local fashionIdB = b.FashionId
	local isUpA = (fashionUpData[a.FashionLocation] == fashionIdA)
	local isUpB = (fashionUpData[b.FashionLocation] == fashionIdB)
	local qualityA = a.FashionQuality
	local qualityB = b.FashionQuality
	if isUpA == isUpB then
		local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
		local fashionUseJobA = a.FashionUseJob
		local fashionUseJobB = b.FashionUseJob
		local canUseA = (not fashionUseJobA or IsTableHasValue(fashionUseJobA, jobCfgId))
		local canUseB = (not fashionUseJobB or IsTableHasValue(fashionUseJobB, jobCfgId))
		if canUseA == canUseB then
			local isNewA = ManagerContainer.DataMgr.FashionData:IsNew(fashionIdA)
			local isNewB = ManagerContainer.DataMgr.FashionData:IsNew(fashionIdB)
			if isNewA == isNewB then
				if qualityA == qualityB then
					return fashionIdA < fashionIdB
				else
					return qualityA > qualityB
				end
			else
				return isNewA
			end
		else
			return canUseA
		end
	else
		return isUpA
	end
end

local AllSortRule = function(a, b)
	local fashionData = ManagerContainer.DataMgr.FashionData
	local fashionIdA = a.FashionId
	local fashionIdB = b.FashionId
	local qualityA = a.FashionQuality
	local qualityB = b.FashionQuality
	local isUpA = fashionData:Contains(fashionIdA)
	local isUpB = fashionData:Contains(fashionIdB)
	if isUpA == isUpB then
		if qualityA == qualityB then
			return fashionIdA < fashionIdB
		else
			return qualityA > qualityB
		end
	else
		return isUpA
	end
end

local ViewPageType = {
	Change = 1,
	Book = 2,
}

function UIFashionCtr:Init(view)
	self.view = view
end

function UIFashionCtr:SetData(data)
	self.asyncIdx = 0
	self:ClearData()
	self:CacheViewData()
	if data == nil then return end
	self.data = data
end

function UIFashionCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionCtr:GetData()
	return self.data
end

function UIFashionCtr:OnDispose()
	self.data = nil
	self.view = nil
	self:ClearData()
end

function UIFashionCtr:ClearData()
	self.viewDataCache = nil
	self.viewDataCacheSend = nil

	self.ownerDatas = nil
	self.ownerDataMap = nil
	self.ownerDataRP = nil
	self.ownerDataRPMap = nil
	self.allDatas = nil
	self.allDataMap = nil

	self.curViewPageType = nil
	self.showDatas = nil
	self.showDataLength = nil

	self.curSelectItemIndex = nil
	self.curSelectFashionSlotType = nil
end

function UIFashionCtr:GetHeroId()
	return ManagerContainer.DataMgr.UserData:GetId()
end

function UIFashionCtr:IsBeginner()
	return ManagerContainer.DataMgr.UserData:GetJobType() == 0
end

function UIFashionCtr:GetRoleCfgId()
	return ManagerContainer.DataMgr.UserData:GetUserRoleId()
end

function UIFashionCtr:GetRoleViewData()
	local heroData = ManagerContainer.DataMgr.UserData:GetMainRoleData()
	return heroData.extGoesShowData
end

--- 需要在启动换装界面时缓存当前时装的数据
function UIFashionCtr:CacheViewData()
	self.viewDataCache = clone(ManagerContainer.DataMgr.UserData:GetViewData())
end

function UIFashionCtr:GetViewData()
	return self.viewDataCache
end

function UIFashionCtr:CanWear(fashionCfgData)
	if not fashionCfgData then
		return false
	end
	if not fashionCfgData.FashionUseJob then
		return true
	end
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	if IsTableHasValue(fashionCfgData.FashionUseJob, jobCfgId) then
		return true
	end
	return false
end

--- 是否穿戴时装
function UIFashionCtr:IsWear(cfgId)
	if self.curViewPageType ~= ViewPageType.Change then
		return false
	end
	if not self.viewDataCache.fashionData then
		return false
	end
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgId)
	return (self.viewDataCache.fashionData[fashionCfgData.FashionLocation] == cfgId)
end

function UIFashionCtr:ChangeWear(fashionCfgData)
	if not fashionCfgData then
		return 1, nil
	end
	if self.curViewPageType ~= ViewPageType.Change then
		return 1, nil
	end
	if not self.viewDataCache.fashionData then
		return 1, nil
	end
	if not self:CanWear(fashionCfgData) then
		return 2, nil
	end
	local cfgId = fashionCfgData.FashionId
	local lastCfgId = self.viewDataCache.fashionData[fashionCfgData.FashionLocation]
	if (lastCfgId == cfgId) then
		-- 脱下
		self.viewDataCache.fashionData[fashionCfgData.FashionLocation] = nil
	else
		-- 更换
		self.viewDataCache.fashionData[fashionCfgData.FashionLocation] = cfgId
	end
	return 0, lastCfgId
end

function UIFashionCtr:IsChangeFashion()
	local viewData = ManagerContainer.DataMgr.UserData:GetViewData()
	for _, value in pairs(Enum.FashionSlotType) do
		if self.viewDataCache.fashionData[value] ~= viewData.fashionData[value] then
			if viewData.fashionData[value] then
				return true
			end
			if self.viewDataCache.fashionData[value] then
				return true
			end
		end
	end
	return false
end

--- 在关闭界面时比较变化，并通知服务器
function UIFashionCtr:SendFashionChange()
	if not self.viewDataCache then return false end
	local downs = {}
	local ups = {}
	local viewData = ManagerContainer.DataMgr.UserData:GetViewData()
	for _, value in pairs(Enum.FashionSlotType) do
		if self.viewDataCache.fashionData[value] ~= viewData.fashionData[value] then
			if viewData.fashionData[value] then
				table.insert(downs, viewData.fashionData[value])
			end
			if self.viewDataCache.fashionData[value] then
				table.insert(ups, self.viewDataCache.fashionData[value])
			end
		end
	end
	local isChanged = false
	if #downs > 0 then
		isChanged = true
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_DOWN_REQ, { fashion_cfg_id = downs })
	end
	if #ups > 0 then
		isChanged = true
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_FASHION_UP_REQ, { fashion_cfg_id = ups })
	end
	if isChanged then
		self.viewDataCacheSend = clone(self.viewDataCache)
	end
	return isChanged
end

function UIFashionCtr:IsSaveFashionSuccess()
	if not self.viewDataCacheSend then return true end
	local viewData = ManagerContainer.DataMgr.UserData:GetViewData()
	for _, value in pairs(Enum.FashionSlotType) do
		if self.viewDataCacheSend.fashionData[value] ~= viewData.fashionData[value] then
			if viewData.fashionData[value] then
				return false
			end
			if self.viewDataCacheSend.fashionData[value] then
				return false
			end
		end
	end
	self.viewDataCacheSend = nil
	return true
end

function UIFashionCtr:GetViewPageType()
	return ViewPageType
end

function UIFashionCtr:GetCurViewPageType()
	return self.curViewPageType
end

function UIFashionCtr:ChangeViewPage(viewPageType)
	if self.curViewPageType == viewPageType then
		return false
	end
	self.curViewPageType = viewPageType
	self:RefreshShowDataType()
	return true
end

function UIFashionCtr:GetCurSelectItemIndex()
	return self.curSelectItemIndex
end

function UIFashionCtr:SetCurSelectItemIndex(itemIndex)
	if self.curSelectItemIndex == itemIndex then
		return false
	end
	self.curSelectItemIndex = itemIndex
	return true
end

function UIFashionCtr:RefreshOwnerDatas()
	local fashionMap = ManagerContainer.DataMgr.FashionData:GetFashionMap()
	local heroSex = ManagerContainer.DataMgr.UserData:GetSex()
	local ownerDatas = {}
	local ownerDataMap = {}
	local ownerDataRPMap = {}
	if fashionMap then
		local typeFashions
		for cfgId,fashionData in pairs(fashionMap) do
			local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgId)
			if fashionCfgData.FashionOpen then
				typeFashions = ownerDataMap[fashionCfgData.FashionLocation]
				if not typeFashions then
					typeFashions = {}
					ownerDataMap[fashionCfgData.FashionLocation] = typeFashions
				end
				typeFashions[#typeFashions + 1] = fashionCfgData
				ownerDatas[#ownerDatas + 1] = fashionCfgData
			end
		end
	end

	table.sort(ownerDatas, SortRule)

	-- 更新排序
	for _, value in pairs(ownerDataMap) do
		table.sort(value, SortRule)
	end
	self.ownerDatas = ownerDatas
	self.ownerDataMap = ownerDataMap
	self.ownerDataRPMap = ownerDataRPMap

	self:RefreshRPInfo()
end

function UIFashionCtr:RefreshAllDatas()
	local userData = ManagerContainer.DataMgr.UserData
	local heroSex = userData:GetSex()
	local cfgMgr = ManagerContainer.CfgMgr
	local FashionCfgDatas = cfgMgr:GetFashionCfg()
	local allDatas = {}
	local allDataMap = {}
	for _, value in pairs(FashionCfgDatas) do
		if value.FashionOpen and (not value.FashionSex or value.FashionSex == 0 or heroSex == value.FashionSex) then
			local typeFashions = allDataMap[value.FashionLocation]
			if not typeFashions then
				typeFashions = {}
				allDataMap[value.FashionLocation] = typeFashions
			end
			-- 有效数据
			typeFashions[#typeFashions + 1] = value
			allDatas[#allDatas + 1] = value
		end
	end
	self.allDatas = allDatas
	self.allDataMap = allDataMap
	self:RefreshAllDatasSort()
end

function UIFashionCtr:RefreshAllDatasSort()
	if self.allDatas then
		table.sort(self.allDatas, AllSortRule)
	end

	-- 更新排序
	if self.allDataMap then
		for _, value in pairs(self.allDataMap) do
			table.sort(value, AllSortRule)
		end
	end
end

-- function UIFashionCtr:GetMinRow()
-- 	if self.curViewPageType == ViewPageType.Change then
-- 		return 2
-- 	elseif self.curViewPageType == ViewPageType.Book then
-- 		return 4
-- 	end
-- 	return 1
-- end

-- function UIFashionCtr:GetColumn()
-- 	if self.curViewPageType == ViewPageType.Change then
-- 		return 5
-- 	elseif self.curViewPageType == ViewPageType.Book then
-- 		return 5
-- 	end
-- 	return 1
-- end

function UIFashionCtr:RefreshShowData()
	self.ownerDatas = nil
	self.ownerDataMap = nil
	self.allDatas = nil
	self.allDataMap = nil
	self.showDatas = nil
	self.showDataLength = nil
	self:RefreshShowDataType(self.curSelectFashionSlotType)
end

function UIFashionCtr:GetCurSelectFashionSlotType()
	return self.curSelectFashionSlotType
end

function UIFashionCtr:RefreshShowDataType(fashionSlotType)
	if fashionSlotType then
		if self.curViewPageType == ViewPageType.Change then
			if not self.ownerDataMap then self:RefreshOwnerDatas() end
			self.showDatas = self.ownerDataMap[fashionSlotType]
		elseif self.curViewPageType == ViewPageType.Book then
			if not self.allDataMap then self:RefreshAllDatas() end
			self.showDatas = self.allDataMap[fashionSlotType]
		end
	else
		if self.curViewPageType == ViewPageType.Change then
			if not self.ownerDatas then self:RefreshOwnerDatas() end
			self.showDatas = self.ownerDatas
		elseif self.curViewPageType == ViewPageType.Book then
			if not self.allDatas then self:RefreshAllDatas() end
			self.showDatas = self.allDatas
		end
	end
	self.curSelectFashionSlotType = fashionSlotType
	local showDataLength = (self.showDatas and #self.showDatas or 0)
	-- if showDataLength > 0 then
	-- 	local column = self:GetColumn()
	-- 	local row = Mathf.Ceil(showDataLength / column)
	-- 	row = Mathf.Max(row, self:GetMinRow())
	-- 	showDataLength = row * column
	-- else
	-- 	showDataLength = self:GetColumn() * self:GetMinRow()
	-- end
	self.showDataLength = showDataLength
end

function UIFashionCtr:GetShowDataLength()
	return self.showDataLength
end

function UIFashionCtr:GetShowData(itemIndex)
	return self.showDatas and self.showDatas[itemIndex + 1] or nil
end

function UIFashionCtr:GetItemIndexByCfgId(cfgId)
	if cfgId and self.showDatas then
		for index, fashionCfgData in pairs(self.showDatas) do
			if fashionCfgData.FashionId == cfgId then
				return index - 1
			end
		end
	end
	return nil
end

function UIFashionCtr:IsOwner(cfgId)
	return ManagerContainer.DataMgr.FashionData:Contains(cfgId)
end

function UIFashionCtr:RefreshFashionSlotTypeRPInfo(fashionSlotType)
	local changed = false
	local datas = self.ownerDataMap[fashionSlotType]
	local lastRPStatus = self.ownerDataRPMap[fashionSlotType]
	if datas then
		local hasNew = false
		for _,cfgId in pairs(datas) do
			local isNew = ManagerContainer.DataMgr.FashionData:IsNew(cfgId)
			if isNew then
				hasNew = true
				break
			end
		end
		if (lastRPStatus ~= hasNew) then
			if lastRPStatus ~= nil or hasNew then
				self.ownerDataRPMap[fashionSlotType] = hasNew
				changed = true
			end
		end
	else
		if lastRPStatus then
			self.ownerDataRPMap[fashionSlotType] = false
			changed = true
		end
	end
	return changed
end

function UIFashionCtr:RefreshRPInfo(fashionSlotType)
	local changed = false
	if fashionSlotType then
		changed = self:RefreshFashionSlotTypeRPInfo(fashionSlotType)
	else
		for _, value in pairs(Enum.FashionSlotType) do
			changed = self:RefreshFashionSlotTypeRPInfo(value) or changed
		end
	end
	-- 分析总红点
	if changed then
		local lastRPStatus = self.ownerDataRP
		local hasNew = false
		for _, isNew in pairs(self.ownerDataRPMap) do
			if isNew then
				hasNew = true
				break
			end
		end
		if (lastRPStatus ~= hasNew) then
			if lastRPStatus ~= nil or hasNew then
				self.ownerDataRP = hasNew
				changed = true
			end
		end
	end
	return changed
end

function UIFashionCtr:GetRPStatus(fashionSlotType)
	local status
	if fashionSlotType then
		status = self.ownerDataRPMap[fashionSlotType]
	else
		status = self.ownerDataRP
	end
	return (status ~= nil and status or false)
end

function UIFashionCtr:GetAllFashionAttr()
	local suitAttrs = ManagerContainer.DataMgr.FashionData:GetFashionSuitAttrs()
	local attrs = {}
	for k,v in pairs(suitAttrs) do
		attrs[#attrs + 1] = {k,v}
	end

	local fashionAttrs = ManagerContainer.DataMgr.FashionData:GetFashionAllAttrs()
	local attrs1 = {}
	for k,v in pairs(fashionAttrs) do
		for k1,v1 in pairs(v) do
			if v1 > 0 then
				attrs1[#attrs1 + 1] = {k1,v1,k - 1}
			end
		end
	end

	table.sort(attrs, function(a, b)
		return a[1] < b[1]
	end)
	table.sort(attrs1, function(a, b)
		if a[3] == 0 and b[3] == 0 then
			return a[1] < b[1]
		elseif a[3] == 0 and b[3] > 0 then
			return true
		elseif a[3] > 0 and b[3] > 0 then
			local posA = ManagerContainer.CfgMgr:GetPartnerPostIdByJobType(a[3])
			local posB = ManagerContainer.CfgMgr:GetPartnerPostIdByJobType(b[3])
			return posA < posB
		end
	end)

	return attrs,attrs1
end

function UIFashionCtr:GetFashionLogicData(cfgId)
	return ManagerContainer.DataMgr.FashionData:GetFashionById(cfgId)
end

function UIFashionCtr:GetJobTypeName(jobType)
	if not jobType then return "" end
	local colorStr = "<color=%s>%s</color>"
	local leaderColor = GlobalConfig.Instance:GetConfigStrValue(306)
	local name = string.format(colorStr, leaderColor, I18N.T("protagonist"))
	if jobType > 0 then
		--伙伴
		local name1, color = ManagerContainer.CfgMgr:GetPartnerCfgDataByJobType(jobType)
		name = string.format(colorStr, color, I18N.T(name1))
	end
	return name
end

function UIFashionCtr:GetFashionSuitLv(suitId)
	return ManagerContainer.DataMgr.FashionData:GetFashionSuitLvById(suitId)
end

return UIFashionCtr

