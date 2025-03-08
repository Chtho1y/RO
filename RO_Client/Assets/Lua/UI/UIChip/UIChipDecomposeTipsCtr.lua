local UIChipDecomposeTipsCtr = class("UIChipDecomposeTipsCtr", require("UICtrBase"))

local Decompose_Quality_Tips = 4

function UIChipDecomposeTipsCtr:Init(view)
	self.view = view
end

function UIChipDecomposeTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self:InitDecomposeDatas()
end

function UIChipDecomposeTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChipDecomposeTipsCtr:GetData()
	return self.data
end

function UIChipDecomposeTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.selected = nil
	self.selectedQuality = nil
	self.decomposeQualityNum = nil
	self.decomposeList = nil
	self.decomposeAwardList = nil
end

function UIChipDecomposeTipsCtr:InitDecomposeDatas()
	local ls = self.data[1]
	local selected = self.data[2] or false
	local decomposeQualityNum = {}
	local decomposeList = {}
	local decomposeAwardMap = {}
	local decomposeAwardList = {}
	local selectedQuality = {}
	for i = 1, #ls do
		local chipData = ls[i]
		local num = (selected and chipData.cost or chipData.num)
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(chipData.cfgId)
		local quality = itemCfgData.Quality

		decomposeQualityNum[quality] = (decomposeQualityNum[quality] or 0) + num
		table.insert(decomposeList, {key = chipData.cfgId, value = num})
		selectedQuality[quality] = true
		local resolve = itemCfgData.Resolve
		if resolve then
			if type(resolve[1]) == 'number' then
				-- 单个
				local itemCfgId = resolve[1]
				local itemNum = resolve[2]
				decomposeAwardMap[itemCfgId] = (decomposeAwardMap[itemCfgId] or 0) + itemNum * num
			else
				for itemCfgId, itemNum in pairs(resolve) do
					decomposeAwardMap[itemCfgId] = (decomposeAwardMap[itemCfgId] or 0) + itemNum * num
				end
			end
		end
	end

	for itemCfgId, itemNum in pairs(decomposeAwardMap) do
		if itemNum > 0 then
			table.insert(decomposeAwardList, {itemCfgId, itemNum})
		end
	end

	table.sort(decomposeAwardList, function(a, b)
		local itemCfgDataA = ManagerContainer.CfgMgr:GetItemById(a[1])
		local itemCfgDataB = ManagerContainer.CfgMgr:GetItemById(b[1])
		if itemCfgDataA.Quality == itemCfgDataB.Quality then
			return a[1] < b[1]
		else
			return itemCfgDataA.Quality > itemCfgDataB.Quality
		end
	end)

	self.selected = selected
	self.decomposeQualityNum = decomposeQualityNum
	self.decomposeList = decomposeList
	self.decomposeAwardList = decomposeAwardList
	self.selectedQuality = selectedQuality
end

function UIChipDecomposeTipsCtr:IsSelected()
	return self.selected
end

function UIChipDecomposeTipsCtr:GetDecomposeQualityNum(quality)
	return (self.decomposeQualityNum[quality] or 0)
end

function UIChipDecomposeTipsCtr:GetDecomposeAwards()
	return self.decomposeAwardList
end

function UIChipDecomposeTipsCtr:GetSelectedQuality(quality)
	return self.selectedQuality[quality] or false
end

function UIChipDecomposeTipsCtr:SetSelectedQuality(quality, isSelected)
	self.selectedQuality[quality] = isSelected
end

--- 在发送分解前的，提示
---@return integer(0,不需要提示；1,高品质内容分解提示;2,未选择分解的类型；3;未选择分解碎片)
function UIChipDecomposeTipsCtr:GetErrorCode()
	local hight = false
	if self:IsSelected() then
		if #self.decomposeList <= 0 then
			return 3
		end
		for quality, num in pairs(self.decomposeQualityNum) do
			if num > 0 and quality >= Decompose_Quality_Tips then
				hight = true
				break
			end
		end
	else
		local num = 0
		for quality, isSelected in pairs(self.selectedQuality) do
			if isSelected then
				num = num + 1
				if quality >= Decompose_Quality_Tips then
					hight = true
				end
			end
		end
		if num <= 0 then
			return 2
		end
	end
	if hight then
		return 1
	end
	return 0
end

function UIChipDecomposeTipsCtr:SendDecompose()
	if self:IsSelected() then
		if #self.decomposeList > 0 then
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_CHIP_DECOMPOSE_REQ, {chip_list = self.decomposeList})
		end
	else
		local qualitys = {}
		for quality, isSelected in pairs(self.selectedQuality) do
			if isSelected then
				table.insert(qualitys, quality)
			end
		end
		if #qualitys > 0 then
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_CHIP_DECOMPOSE_REQ, {chip_type_list = qualitys})
		end
	end
end

return UIChipDecomposeTipsCtr

