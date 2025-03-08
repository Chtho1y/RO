local UICardDecomposeTipsCtr = class("UICardDecomposeTipsCtr", require("UICtrBase"))

local decomposeList
local selectionList
function UICardDecomposeTipsCtr:Init(view)
	self.view = view
end

function UICardDecomposeTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UICardDecomposeTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardDecomposeTipsCtr:GetData()
	return self.data
end

function UICardDecomposeTipsCtr:GetDecomposeCardCount(type)
	if decomposeList == nil then
		decomposeList = {}
	end
	decomposeList[type] = {}
	local num = 0
	for _,v in pairs(self.data[1]) do
		if v.CardType == type then
			decomposeList[type][#decomposeList[type] + 1] = v
			num = num + v.decompose
		end
	end
	return num
end

function UICardDecomposeTipsCtr:IsOneKeyDecompose()
	return self.data[2]
end

function UICardDecomposeTipsCtr:GetDecomposeAwards()
	local type = self:GetSelectionList()
	local list = {}
	if type ~= 0 then
		for k2,v2 in pairs(type) do
			if v2 then
				for _,v in pairs(decomposeList[k2]) do
					local itemCfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
					local award = CommonUtil.DeserializeCfgItemList(itemCfgData.Resolve)
					for _,v1 in pairs(award) do
						if list[v1[1]] == nil then
							list[v1[1]] = 0
						end
						list[v1[1]] = list[v1[1]] + (v1[2] * v.decompose)
					end
				end
			end
		end
	end
	local list1 = {}
	for k,v in pairs(list) do
		list1[#list1 + 1] = {k, v}
	end
	return list1
end

function UICardDecomposeTipsCtr:ResetSelectionList()
	selectionList = nil
end

function UICardDecomposeTipsCtr:SetSelectionList(type)
	if selectionList == nil then
		selectionList = {}
	end
	if selectionList[type] == nil then
		selectionList[type] = false
	end
	selectionList[type] = not selectionList[type]
	return selectionList[type]
end

function UICardDecomposeTipsCtr:GetSelectionList()
	if selectionList == nil then
		selectionList = {}
	end

	local noSelection = true
	for k, v in pairs(selectionList) do
		if v then
			noSelection = false
		end
	end
	return noSelection and 0 or selectionList
end

function UICardDecomposeTipsCtr:SendDecompose()
	local type = self:GetSelectionList()
	if type == 0 then
		return
	end
	local list = {}
	if type ~= 0 then
		for k2,v2 in pairs(type) do
			if v2 then
				for _,v in pairs(decomposeList[k2]) do
					local data = {key = v.cfgId, value = v.decompose}
					list[#list + 1] = data
				end
			end
		end
	end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_DECOMPOSE_REQ, {card_list = list})
end

function UICardDecomposeTipsCtr:OnDispose()
	self.data = nil
	self.view = nil

	decomposeList = nil
	selectionList = nil
end

return UICardDecomposeTipsCtr

