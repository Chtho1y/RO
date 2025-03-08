local UICardListCtr = class("UICardListCtr", require("UICtrBase"))

local curEleIndex = 0
local cardDatas
local costCardLogicDatas = {nil,nil,nil}

function UICardListCtr:Init(view)
	self.view = view
end

function UICardListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICardListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICardListCtr:GetData()
	return self.data
end


function UICardListCtr:GetEleIndex()
	return curEleIndex
end

function UICardListCtr:SetEleIndex(index)
	curEleIndex = index
end

function UICardListCtr:NilCostCards()
	costCardLogicDatas = {nil,nil,nil}
end

function UICardListCtr:GetCostCard(idx)
	return costCardLogicDatas[idx]
end

function UICardListCtr:AddCostCard(idx, logicData)
	costCardLogicDatas[idx] = logicData
end

function UICardListCtr:RemoveCostCard(idx)
	costCardLogicDatas[idx] = nil
end

function UICardListCtr:RefreshMvpCradList()
	local cardDatasSource = ManagerContainer.DataMgr.CardData:GetAllCardDataMap()
	local ls = {}
	for _,v in pairs(cardDatasSource) do
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(v.cfgId)
		if itemCfgData.Quality == 4 then
			local composition = itemCfgData.Composition
			local num = v.num
			while (num > composition) do
				local data = {cfgId = v.cfgId, num = composition, isSelect = false,level = v.CardLevel}
				table.insert(ls, data)
				num = num - composition
			end
			-- 最后还需要把剩余的单独占格
			if num > 0 then
				local data = {cfgId = v.cfgId, num = num, isSelect = false,level = v.CardLevel}
				table.insert(ls, data)
			end
		end
	end

	if ls ~= nil then
		CommonUtil.ArraySortSelections(ls, Enum.TableSortRule.Down, "CardLevel","cfgId")
	end
	-- if ls == nil then
	-- 	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NoCardTips3")
	-- end
	self.MvpCardList = ls
	return self.MvpCardList
end

function UICardListCtr:GetMvpCardList()
	return self.MvpCardList
end

function UICardListCtr:GetTransferSlotIdx()
	return self.leftSlotIdx,self.rightSlotIdx
end

function UICardListCtr:ClearLeftSlotIdx()
	if self.leftSlotIdx then
		local oldData = self:GetShowData(self.leftSlotIdx - 1)
		if oldData then
			oldData.isSelect = false
		end
	end
	self.leftSlotIdx = nil
end

function UICardListCtr:ClearRightSlotIdx()
	if self.rightSlotIdx then
		local oldData = self:GetShowData(self.rightSlotIdx - 1)
		if oldData then
			oldData.isSelect = false
		end
	end
	self.rightSlotIdx = nil
end

function UICardListCtr:GetShowData(idx)
	return self.MvpCardList and self.MvpCardList[idx + 1] or nil 
end

function UICardListCtr:SendTransReq()
	local leftData = self:GetShowData(self.leftSlotIdx - 1)
	local rightData = self:GetShowData(self.rightSlotIdx - 1)
	ManagerContainer.DataMgr.CardData:SendMvpCardTransReq(leftData.cfgId, rightData.cfgId)
end

function UICardListCtr:CheckTransError(leftIdx,rightIdx)
	if not leftIdx or not rightIdx then return 0 end
	local leftData = self:GetShowData(leftIdx - 1)
	local rightData = self:GetShowData(rightIdx - 1)
	if leftData.level == rightData.level then
		return 1
	elseif self:CheckCardEqual(leftData.cfgId,rightData.cfgId) then
		return 2
	else
		return 0
	end
end

function UICardListCtr:CheckCardEqual(leftId,rightId)
	if leftId and rightId then
		local w = math.floor(leftId / 10000)
		local q = math.floor(leftId / 1000 % 10)
		local s = math.floor(leftId / 10 % 10)
		local g = math.floor(leftId % 10)
		for i = 1, 5 do
			local v = w * 10000 + q * 1000 + i * 100 + s * 10 + g
			if v == rightId then
				return true
			end
		end
	end
	return false
end

function UICardListCtr:SetTransSlotIdx(idx)
	local oldIdx, newIdx

	if self.leftSlotIdx == idx then
		oldIdx = self.leftSlotIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.isSelect = false
			end
		end
		self.leftSlotIdx = nil
		return 0, oldIdx, newIdx
	elseif self.rightSlotIdx == idx then
		oldIdx = self.rightSlotIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.isSelect = false
			end
		end
		self.rightSlotIdx = nil
		return 0, oldIdx, newIdx
	end

	if (self.leftSlotIdx and self.leftSlotIdx == idx) or not self.leftSlotIdx then
		local checkCode = self:CheckTransError(idx, self.rightSlotIdx)
		if checkCode > 0 then
			return checkCode
		end
		oldIdx = self.leftSlotIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.isSelect = false
			end
		end
		if idx == oldIdx then idx = nil end
		if idx then
			local oldData = self:GetShowData(idx - 1)
			if oldData then
				oldData.isSelect = true
			end
		end
		self.leftSlotIdx = idx
		return 0, oldIdx, newIdx
	end
	if (self.rightSlotIdx and self.rightSlotIdx == idx) or not self.rightSlotIdx then
		local checkCode = self:CheckTransError(self.leftSlotIdx, idx)
		if checkCode > 0 then
			return checkCode
		end
		oldIdx = self.rightSlotIdx
		if oldIdx then
			local oldData = self:GetShowData(oldIdx - 1)
			if oldData then
				oldData.isSelect = false
			end
		end
		if idx == oldIdx then idx = nil end
		if idx then
			local oldData = self:GetShowData(idx - 1)
			if oldData then
				oldData.isSelect = true
			end
		end
		self.rightSlotIdx = idx
		return 0, oldIdx, newIdx
	end

	if self.leftSlotIdx ~= idx and self.rightSlotIdx ~= idx then return 4 end
end


function UICardListCtr:CanCostMore()
	for i = 1, 3 do
		if costCardLogicDatas[i] == nil then
			return true
		end
	end
	return false
end

function UICardListCtr:CanComposeMore()
	for i = 1, 3 do
		if costCardLogicDatas[i] ~= nil then
			return false
		end
	end
	return true
end

function UICardListCtr:AutoAddCostCard(logicData)
	for i = 1, 3 do
		if costCardLogicDatas[i] == nil then
			costCardLogicDatas[i] = logicData
			return i
		end
	end
	return 0
end

function UICardListCtr:AutoRemoveCostCard(logicData)
	for i = 1, 3 do
		if costCardLogicDatas[i] ~= nil and costCardLogicDatas[i].cfgId == logicData.cfgId then
			costCardLogicDatas[i] = nil
			return i
		end
	end
	return 0
end

function UICardListCtr:GetCardDatas(ele)
	cardDatas = {}
	local datas = ManagerContainer.DataMgr.CardData:GetAllCardDataMap()
	for _,v in pairs(datas) do
		if v.num > 0 then
			if ele == 0 then
				table.insert(cardDatas, CommonUtil.TableClone(v))
			else
				local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(v.cfgId)
				if cardCfgData.CardType == ele then
					table.insert(cardDatas, CommonUtil.TableClone(v))
				end
			end
		end
	end
	CommonUtil.ArraySortSelections(cardDatas, Enum.TableSortRule.Down, "CardType", "CardLevel", "cfgId")

	return cardDatas
end

function UICardListCtr:GetComposeCardDatas(ele, canCompose)
    cardDatas = {}
    local datas = ManagerContainer.DataMgr.CardData:GetAllCardDataMap()
    for _,v in pairs(datas) do
        if v.num > 0 then
            local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(v.cfgId)
			local nextCardCfgData = ManagerContainer.CfgMgr:GetCardDataById(v.cfgId + 100)
            if ele == 0 then
                if nextCardCfgData and ((canCompose and v.num >= 3) or (not canCompose and v.num > 0)) then
                    table.insert(cardDatas, CommonUtil.TableClone(v))
                end
            else
                if cardCfgData.CardType == ele and nextCardCfgData and ((canCompose and v.num >= 3) or (not canCompose and v.num > 0)) then
                    table.insert(cardDatas, CommonUtil.TableClone(v))
                end
            end
        end
    end
	CommonUtil.ArraySortListSelections(cardDatas, {Enum.TableSortRule.Down, Enum.TableSortRule.Up, Enum.TableSortRule.Down}, {"CardType", "CardLevel", "cfgId"})
    return cardDatas
end

function UICardListCtr:RecreateNeedNotice()
	for _, v in pairs(costCardLogicDatas) do
		if v ~= nil then
			local cardData = ManagerContainer.CfgMgr:GetCardDataById(v.cfgId)
			if cardData.CardType > Enum.CardType.NORMAL then
				return true
			end
		end
	end
	return false
end

function UICardListCtr:SendCardReceate()
	local data = {}
	for _,v in pairs(costCardLogicDatas) do
		if v ~= nil then
			data[#data + 1] = v.cfgId
		end
	end
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_COMPOSE_REQ, {card_list = data})
end

function UICardListCtr:SendCardCompose(nextCardIds, counts)
	local cfgIds = {}
	for k,v in pairs(nextCardIds) do
		if v ~= nil then
			cfgIds[#cfgIds + 1] = {key = v - 100, value = counts[v] * 3}
		end
	end
	if #cfgIds == 0 then return end

	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CARD_UP_GRADE_REQ, {config_ids = cfgIds})
end

function UICardListCtr:OnDispose()
	self.data = nil
	self.view = nil
	self:ClearLeftSlotIdx()
	self:ClearRightSlotIdx()
	self.MvpCardList = nil
end

function UICardListCtr:IsProduceFree()
	local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
	return vipCfg and vipCfg.CardReset >= 1
end

return UICardListCtr

