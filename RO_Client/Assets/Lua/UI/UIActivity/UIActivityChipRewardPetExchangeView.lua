local UIActivityChipRewardPetExchangeView = require("UIActivity/UIActivityChipRewardPetExchangeView_Generate")
local IconPetItemCtr = require("Common/IconPetItemCtr")
local IconItemCtr = require("Common/IconItemCtr")
function UIActivityChipRewardPetExchangeView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityChipRewardPetExchangeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityChipRewardPetExchangeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.ActivityRefresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTIVITY_GLOBAL_REFRESH,self,self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EXCHANGEPET_NTF,self,self.OnPetRewardBack)
end

function UIActivityChipRewardPetExchangeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityChipRewardPetExchangeView:Init()
	self.isCanExchange = true
	self.controller:RefreshChipDatas()
	local activeItem = self.controller.activityData
	CommonUtil.LoadIcon(self, activeItem.pageBg, function (sprite)
		self.banner.image.sprite = sprite
	end)
	self.selectList = {}
	self.cacheNumList = {}
	self:InitGrid()
	self:Refresh()
	if not self.timer then
		self.timer = FrameTimer.New(slot(self.DelayInitTop, self), 1)
	end
	if not self.timer.running then
		self.timer:Start()
	end
end

function UIActivityChipRewardPetExchangeView:DelayInitTop()
	self:InitTop()
end
function UIActivityChipRewardPetExchangeView:OnPetRewardBack(data)
	if data.error == 0 then
		local itemIndex = self.controller:GetIndexByCfgId(data.reward_idx) - 1
		local itemlua = self:GetShowItemByIdx(itemIndex)
		if itemlua then
			for i = 1, 4 do
				if  self.cacheNumList[itemIndex][i] and self.selectList[itemIndex][i]then
					self.cacheNumList[itemIndex][i].selectCount  = 0
					self.selectList[itemIndex][i] = {}
				end
			end
		self:Refresh()
		end
	end
	self.isCanExchange = true
end

function UIActivityChipRewardPetExchangeView:InitTop()
	if not self.updateTimer then
		self.updateTimer = Timer.New(slot(self.UpdateMinute, self), 60, -1)
	end
	if not self.updateTimer.running then
		self.updateTimer:Start()
	end

	local canOpen = self:RefreshRemainTime()
	if canOpen then
		local activeItem = self.controller.activityData
		ManagerContainer.DataMgr.ActsDataMgr:SendGetGlobalCollectionServerData(activeItem.actId)
	end
end
function UIActivityChipRewardPetExchangeView:RefreshRemainTime()
	local leftTime = self.controller:GetRemainTime()
	if leftTime <= 0 then
		self.time.text.text = "0"
		ManagerContainer.DataMgr.ActsDataMgr:RefreshRedPointState(Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD)
		self:OnClickCloseBtn()
		return false
	end
	local day,hour,minute,second = ConvertTimeForm(leftTime)
	local timeStr = ""
	if day > 0 then
		timeStr = day .. "天"..hour .. "时" .. minute .. "分"
	else
		if hour > 0 then
			timeStr = hour .. "时" .. minute .. "分"
		else
			if minute == 0 then
				minute = 1
			end
			timeStr = minute .. "分"
		end
	end
	self.time.text.text = timeStr
	return true
end

function UIActivityChipRewardPetExchangeView:UpdateMinute()
	self:RefreshRemainTime()
end

function UIActivityChipRewardPetExchangeView:InitGrid()
	self.boxExchange.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIActivityChipRewardPetExchangeView:ActivityRefresh(actid)
	if self.controller:GetActId() == actid then
		self:Refresh()
	end
end
function UIActivityChipRewardPetExchangeView:Refresh()
	local loopListView = self.boxExchange.loopListView
	local length = self.controller:GetChipDataLength()
	loopListView:SetListItemCount(length)
	loopListView:RefreshAllShownItem()
end

function UIActivityChipRewardPetExchangeView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetChipDataLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	if not self.cacheNumList[itemIndex] then
		self.cacheNumList[itemIndex] = {}
	end
	local showData = self.controller:GetChipShowDataByIdx(itemIndex)
	local cfgData = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(showData.cfgId)
	local enterType = cfgData.Type
	local item = gridView:NewListViewItem("PetExchangeItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "PetExchangeItem", item.gameObject)

	for i = 1, 4 do
		itemlua["coastItem"..(i-1)]:SetActive(false)
	end
	local globalCount = self.controller:GetGlobalCount(showData.cfgId)
	local globalLack = (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0)
	if cfgData.ExchangeCondition1 then
		for i = 1, #cfgData.ExchangeCondition1 do
			local condition = cfgData.ExchangeCondition1[i]
			--两种类型  两种条件结构 
			local maxCount = enterType == 0 and condition[5] or condition[4]
			local index = condition[1]
			if not self.cacheNumList[itemIndex][index] then
				self.cacheNumList[itemIndex][index] = {}
				self.cacheNumList[itemIndex][index].selectCount = 0
				self.cacheNumList[itemIndex][index].maxCount = maxCount
			end
			local costItemLua = itemlua["coastItem"..(index-1)]
			self:RefeChipItem(enterType == 0 and costItemLua.iconPetItem or costItemLua.iconItem,condition,{itemIndex,index},globalLack,enterType,costItemLua.addMask)
			costItemLua.iconPetItem:SetActive(enterType == 0)
			costItemLua.iconItem:SetActive(enterType ~= 0)
			costItemLua:SetActive(true)
			itemlua["text"..(index)].text.text = I18N.SetLanguageValue(self:GetColorText(self.cacheNumList[itemIndex][index].selectCount,maxCount))
		end
	end
	if cfgData.ExchangeCondition2 then
		for i = 1, #cfgData.ExchangeCondition2 do
			local condition = cfgData.ExchangeCondition2[i]
			--两种类型  两种条件结构 
			local maxCount = enterType == 0 and condition[5] or condition[4]
			local index = condition[1]
			if not self.cacheNumList[itemIndex][index] then
				self.cacheNumList[itemIndex][index] = {}
				self.cacheNumList[itemIndex][index].selectCount = 0
				self.cacheNumList[itemIndex][index].maxCount = maxCount
			end
			if enterType ~= 0 and not (cfgData and  cfgData.Scope and cfgData.Scope[i]) then
				LogError("策划需检查配置，筛选表与条件数量不一致")
				return
			end
			local data = enterType == 0 and condition or {cfgData.Scope[i],condition[2],condition[3],condition[4],condition[5]}
			local costItemLua = itemlua["coastItem"..(index-1)]
			self:RefeChipItem(enterType == 0 and costItemLua.iconPetItem or costItemLua.iconItem,data,{itemIndex,index},globalLack,enterType,costItemLua.addMask,true)
			costItemLua.iconPetItem:SetActive(enterType == 0)
			costItemLua.iconItem:SetActive(enterType ~= 0)
			costItemLua:SetActive(true)
			itemlua["text"..(index)].text.text = I18N.SetLanguageValue(self:GetColorText(self.cacheNumList[itemIndex][index].selectCount,maxCount))
		end
	end

	itemlua.serverLimit:SetActive(cfgData.ServersReward > 0)
	local count1 =  cfgData.ExchangeCondition1 and #cfgData.ExchangeCondition1 or 0 
	local count2 = cfgData.ExchangeCondition2 and #cfgData.ExchangeCondition2 or 0
	itemlua.coast.scrollRect.enabled =  count1 + count2 > 4
	if cfgData.ServersReward > 0 then
		local remain = cfgData.ServersReward - globalCount
		itemlua.green:SetActive(remain > 0)
		itemlua.red:SetActive(remain == 0)
		itemlua.number.text.text = remain.."/"..cfgData.ServersReward
	end
	local remainTimes = cfgData.Number - showData.rewardNum
	
	itemlua.numberReward.text.text = remainTimes
	itemlua.mask:SetActive(showData.rewardNum >= cfgData.Number)
	self:RefeRewardItem(itemlua.reward.iconItem ,cfgData.Reward,enterType)
	local isCanExchange = self:GetItemIsCanExchange(itemIndex)	
	itemlua.button.button.interactable = isCanExchange 
	CommonUtil.SetTotalChildrenGray(itemlua.button.gameObject, not isCanExchange)
	itemlua.uIRedPointRP:SetActive(isCanExchange and cfgData.Number > showData.rewardNum and ((globalCount < cfgData.ServersReward and cfgData.ServersReward > 0) or cfgData.ServersReward == 0))
	self.uiBase:AddButtonUniqueEventListener(itemlua.button.button, self, self.OnChipClick, itemIndex, isCanExchange, globalLack)
	return item
end

function UIActivityChipRewardPetExchangeView:GetItemIsCanExchange(itemIndex)
	if self.cacheNumList[itemIndex] then
		for k, v in pairs(self.cacheNumList[itemIndex]) do
			if v.selectCount < v.maxCount then
				return false
			end
		end
	end
	return true
end
function UIActivityChipRewardPetExchangeView:GetColorText(num,maxNum)
	if num < maxNum then
		return "<color=red>"..num.."</color>/"..maxNum
	else
		return "<color=green>"..num.."</color>/"..maxNum
	end
end
function UIActivityChipRewardPetExchangeView:RefeRewardItem(itemlua,data,enterType)
	local cfgId = data[1][1]
	local num = data[1][2]
	local cfgData = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
	local rewarddata = { cfgId = cfgId, num = num}
	local logicData = {cfgId = cfgId,num = num,data = rewarddata,enterType = enterType}
	IconItemCtr:SetData(self,itemlua, logicData, nil, self, self.OnRewardItemClick)
end

function UIActivityChipRewardPetExchangeView:RefeChipItem(itemlua,data,indexInfo,globalLack,enterType,addMask,isByQulity)
	local itemIndex =  indexInfo[1]
	local index =  indexInfo[2]
	if enterType == 0 then --宠物兑换
		local target = data[2]
		local level = data[3]
		local skilllv = data[4]
		local num = data[5]
		local hasNum 
		local petDataList = {}
		if isByQulity then
			local Icon
			local frameIcon = Constant.Quality_HeadFrame_Icons[target + 1]
			local natureIcon = "Jobs/Jobicon_Unknown" 
			if target == 2 then
				Icon = "Pets/item_petuniversal_mini"
			elseif target == 3 then
				Icon = "Pets/item_petuniversal_mvp"
			end
			CommonUtil.LoadIcon(self, Icon, function (sprite)
				itemlua.icon.image.sprite = sprite
			end)
			CommonUtil.LoadIcon(self,frameIcon , function (sprite)
				itemlua.frame.image.sprite = sprite
			end)
			CommonUtil.LoadIcon(self,natureIcon , function (sprite)
				itemlua.nature.image.sprite = sprite
			end)
			itemlua.nature:SetActive(true)
			local starFrame 
			if skilllv > 0 then
				starFrame = Constant.PetSkillLvStar_Icons[1]
			elseif skilllv > 10 then
				starFrame = Constant.PetSkillLvStar_Icons[2]
			elseif skilllv > 20 then
				starFrame = Constant.PetSkillLvStar_Icons[3]
			end
			hasNum = ManagerContainer.DataMgr.PetDataMgr:GetPetCountByQulityAndLv(target,level,skilllv)
			CommonUtil.LoadIcon(self, starFrame, function (sprite)
				itemlua.star.image.sprite = sprite
			end)
			itemlua.star:SetActive(true)
			itemlua.star.advenceLv.text.text = skilllv
			itemlua.num.text.text = I18N.SetLanguageValue("Lv."..level)	
			itemlua.support:SetActive(false)
			itemlua.relation:SetActive(false)
			itemlua.battle:SetActive(false)
	
			local parms = {data = data,isByQulity = isByQulity,indexInfo = indexInfo,globalLack = globalLack,enterType = enterType}
			self.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, self, self.OnItemClick,parms)
		else
			hasNum = ManagerContainer.DataMgr.PetDataMgr:GetPetCountByIdAndLv(target,level,skilllv)
			local logicData = {cfgId = target,level = level, skilllv = skilllv,data = data,isByQulity = isByQulity,indexInfo = indexInfo,globalLack = globalLack,enterType = enterType}
			IconPetItemCtr:SetData(self,itemlua, logicData, Enum.ItemIEnterType.PetMats, self, self.OnItemClick)
		end
		CommonUtil.SetTotalChildrenGray(itemlua.gameObject, hasNum == 0 or globalLack)
		local isSelect =  self.cacheNumList[itemIndex][index].selectCount == self.cacheNumList[itemIndex][index].maxCount
		addMask:SetActive(not isSelect and hasNum > 0 and not globalLack)
	elseif enterType == 1 then
		local itemType = data[2]
		local num  = data[4]
		local hasNum = 0
		if isByQulity then
			local needLv   = data[3]
			local filtrList = data[1]
			local target = data[5]
			for i = 1, #filtrList do
				hasNum = hasNum + CommonUtil.GetOwnResCountByItemId(filtrList[i])
			end
			local Icon
			local levelIcon = Constant.Quality_Equip_LV_Icons[needLv]
			local frameIcon = Constant.Quality_HeadFrame_Icons[target + 1]
			local cardLableIcon = Constant.Quality_CardType_Icons[target]
			if target == 2 then
				Icon = "Card_ic/card_carduniversal_mini"
			elseif target == 3 then
				Icon = "Card_ic/card_carduniversal_mvp"
			end
			itemlua.level:SetActive(true)
			CommonUtil.LoadIcon(self, levelIcon, function (sprite)
				itemlua.level.image.sprite = sprite
			end)
			CommonUtil.LoadIcon(self, Icon, function (sprite)
				itemlua.icon.image.sprite = sprite
			end)
			CommonUtil.LoadIcon(self,frameIcon , function (sprite)
				itemlua.frame.image.sprite = sprite
			end)
			CommonUtil.LoadIcon(self, cardLableIcon, function (sprite)
				itemlua.cardLabel.image.sprite = sprite
			end)
			itemlua.cardLabel:SetActive(true)
			itemlua.job:SetActive(false)
			itemlua.num:SetActive(false)
			itemlua.conertips:SetActive(false)
			local parms = {data = data,isByQulity = isByQulity,indexInfo = indexInfo,globalLack = globalLack,enterType = enterType}
			self.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, self, self.OnItemClick,parms)
		else
			local itemId   = data[3]
			hasNum = CommonUtil.GetOwnResCountByItemId(itemId)
			local logicData = {cfgId = itemId,data = data,isByQulity = isByQulity,indexInfo = indexInfo,globalLack = globalLack,enterType = enterType}
			IconItemCtr:SetData(self,itemlua, logicData, nil, self, self.OnItemClick)
		end
		CommonUtil.SetTotalChildrenGray(itemlua.gameObject, hasNum == 0 or globalLack)
		local isSelect =  self.cacheNumList[itemIndex][index].selectCount == self.cacheNumList[itemIndex][index].maxCount
		addMask:SetActive(not isSelect and hasNum > 0 and not globalLack)
	end
end

function UIActivityChipRewardPetExchangeView:OnRewardItemClick(button,params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0].data)
end

function UIActivityChipRewardPetExchangeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIActivityChipRewardPetExchangeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnInfo.button, self, self.OnClickPlayRuleBtn)
end

function UIActivityChipRewardPetExchangeView:OnClickPlayRuleBtn()
	local rulekey = self.controller:GetRuleKey()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', rulekey})
end

function UIActivityChipRewardPetExchangeView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

function UIActivityChipRewardPetExchangeView:OnChipClick(button, params)
	local leftTime = self.controller:GetRemainTime()
	if leftTime <= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SetsWordActivity02")
		return
	end
	if not self.isCanExchange then
		return
	end
	if params[2] then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SetsWordActivity05")
		return
	end
	self.curridx = params[0]
	ManagerContainer.LuaUIMgr:ShowMessageBox("PetExchangetips",nil,nil,self,self.ItemClick1Sure,nil)
end

function UIActivityChipRewardPetExchangeView:OnHide()

end

function UIActivityChipRewardPetExchangeView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityChipRewardPetExchangeView:ItemClick1Sure()
	local data = {}
	for k, v in pairs(self.selectList[self.curridx]) do
		local cfgList={}
		for key, value in pairs(v) do
			cfgList[#cfgList + 1] = {key = key,value = value}
		end
		local info = {condition_id = k, cost_item = cfgList}
		data[#data + 1] = info
	end
	local showData = self.controller:GetChipShowDataByIdx(self.curridx)
	local cfgData = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(showData.cfgId)
	self.controller:SendGetActivityRewardReq(cfgData.Id,data)
	self.isCanExchange = false
end

function UIActivityChipRewardPetExchangeView:OnItemClick(button,params)
	if not self.isCanExchange then
		return
	end
	local data = params[0]
	local enterType = data.enterType
	if data.enterType == 0 then  --宠物兑换
		local petDataList
		local target = data.data[2]
		local level =  data.data[3]
		local skilllv =  data.data[4]
		local num =  data.data[5]
		if data.isByQulity then --是否是按品质任意选择
			petDataList = ManagerContainer.DataMgr.PetDataMgr:GetPetDataByQulityAndLv(target,level,skilllv)
		else
			petDataList = ManagerContainer.DataMgr.PetDataMgr:GetPetDataByIdAndLv(target,level,skilllv)
		end
		local itemIndex = data.indexInfo[1]
		local Index = data.indexInfo[2]
		if not self.selectList[itemIndex] then
			self.selectList[itemIndex] = {}
		end
		if not self.selectList[itemIndex][Index] then
			self.selectList[itemIndex][Index] = {}
		end
		local otherSelectList = {}
		for key, value in pairs(self.selectList) do
			for k, v in pairs(value) do
				for i, j in pairs(v) do
					if not(itemIndex == key and Index == k) then
						otherSelectList[i] = j
					end
				end
			end
		end
		local selectInfo = {selectList =self.selectList[itemIndex][Index],selectCount = self.cacheNumList[itemIndex][Index].selectCount,indexInfo = data.indexInfo,otherSelectList = otherSelectList,conditions = {target,level,skilllv,num,data.isByQulity},enterType = enterType}
		local params = {list = petDataList,callback = {self,self.OnSelectCom},selectInfo = selectInfo,enterType = enterType}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetExchangeMats,params)
	elseif data.enterType == 1 then --宠物以外兑换
		local showList
		local itemType = data.data[2]
		local itemId   = data.data[3]
		local filtrList = data.data[1]
		local num = data.data[4]
		local quality
		if data.isByQulity then
			quality = data.data[5]
			showList = self.controller:GetShowListByItemTypeAndFiltrList(itemType,filtrList)
		else
			showList = self.controller:GetShowListByItemTypeAndId(itemType,itemId)
		end
		local itemIndex = data.indexInfo[1]
		local Index = data.indexInfo[2]
		if not self.selectList[itemIndex] then
			self.selectList[itemIndex] = {}
		end
		if not self.selectList[itemIndex][Index] then
			self.selectList[itemIndex][Index] = {}
		end
		local otherSelectList = {}
		for key, value in pairs(self.selectList) do
			for k, v in pairs(value) do
				for i, j in pairs(v) do
					if not(itemIndex == key and Index == k) then
						otherSelectList[i] = j
					end
				end
			end
		end
		local selectInfo = {selectList =self.selectList[itemIndex][Index],selectCount = self.cacheNumList[itemIndex][Index].selectCount,indexInfo = data.indexInfo,otherSelectList = otherSelectList,conditions = {itemType,itemId,filtrList,num,data.isByQulity,quality},enterType = enterType}
		local params = {list = showList,callback = {self,self.OnSelectCom},selectInfo = selectInfo,enterType = enterType}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetExchangeMats,params)
	end
end

function UIActivityChipRewardPetExchangeView:OnSelectCom(data)
	local selectInfo = data
	local enterType = data.enterType
	local itemIndex = data.indexInfo[1]
	local index = data.indexInfo[2]
	local itemlua = self:GetShowItemByIdx(itemIndex)
	if itemlua then
		self.cacheNumList[itemIndex][index].selectCount = data.selectCount
		local hasNum = 0
		if enterType == 0 then
			if data.conditions[5] then
				hasNum = ManagerContainer.DataMgr.PetDataMgr:GetPetCountByQulityAndLv(data.conditions[1],data.conditions[2],data.conditions[3])
			else
				hasNum = ManagerContainer.DataMgr.PetDataMgr:GetPetCountByIdAndLv(data.conditions[1],data.conditions[2],data.conditions[3])
			end
		elseif enterType == 1 then
			if data.conditions[5] then
				local filtrList = data.conditions[3]
				for i = 1, #filtrList do
					hasNum = hasNum + CommonUtil.GetOwnResCountByItemId(filtrList[i])
				end
			else
				hasNum =  CommonUtil.GetOwnResCountByItemId(data.conditions[2])
			end
		end	
		itemlua["coastItem"..(index - 1)].addMask:SetActive(data.selectCount < data.maxNum and hasNum and hasNum >0)
		itemlua["text"..(index)].text.text = I18N.SetLanguageValue(self:GetColorText(self.cacheNumList[itemIndex][index].selectCount,data.maxNum))
		self:CheckSelectIdIsExist(data.selectList,itemIndex,index)
		local isCanExchange = self:GetItemIsCanExchange(itemIndex)
		local showData = self.controller:GetChipShowDataByIdx(itemIndex)
		local cfgData = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(showData.cfgId)
		local globalCount = self.controller:GetGlobalCount(showData.cfgId)
		local globalLack = (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0)
		itemlua.button.button.interactable = isCanExchange 
		CommonUtil.SetTotalChildrenGray(itemlua.button.gameObject, not isCanExchange)
		itemlua.uIRedPointRP:SetActive(isCanExchange and cfgData.Number > showData.rewardNum and ((globalCount < cfgData.ServersReward and cfgData.ServersReward > 0) or cfgData.ServersReward == 0))
	end
end

function UIActivityChipRewardPetExchangeView:CheckSelectIdIsExist(list,itemIndex,index)
    for _, p in pairs(list) do
		for key, value in pairs(self.selectList) do
			for k, v in pairs(value) do
				for i, j in pairs(v) do
					if itemIndex == key and index == k then
						break
					end
					if i == _ then
						self:RefeItemLuaData(key,k,i,j)
					end
				end
			end
		end
	end
end
function UIActivityChipRewardPetExchangeView:RefeItemLuaData(itemIndex,index,id,num)
	local itemlua = self:GetShowItemByIdx(itemIndex)
	if itemlua then
		local count = self.cacheNumList[itemIndex][index].selectCount 
		count = count - num 
		itemlua["coastItem"..(index - 1)].addMask:SetActive(count < self.cacheNumList[itemIndex][index].maxCount)
		itemlua["text"..(index)].text.text = I18N.SetLanguageValue(self:GetColorText(count,self.cacheNumList[itemIndex][index].maxCount))
		self.cacheNumList[itemIndex][index].selectCount  = count
		self.selectList[itemIndex][index][id] = nil
		local isCanExchange = self:GetItemIsCanExchange(itemIndex)
		local showData = self.controller:GetChipShowDataByIdx(itemIndex)
		local cfgData = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(showData.cfgId)
		local globalCount = self.controller:GetGlobalCount(showData.cfgId)
		local globalLack = (globalCount >= cfgData.ServersReward and cfgData.ServersReward > 0)
		itemlua.button.button.interactable = isCanExchange 
		CommonUtil.SetTotalChildrenGray(itemlua.button.gameObject, not isCanExchange)
		itemlua.uIRedPointRP:SetActive(isCanExchange and cfgData.Number > showData.rewardNum and ((globalCount < cfgData.ServersReward and cfgData.ServersReward > 0) or cfgData.ServersReward == 0))
	end
end

function UIActivityChipRewardPetExchangeView:GetShowItemByIdx(idx)
    local item = self.boxExchange.loopListView:GetShownItemByItemIndex(idx)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "PetExchangeItem", item.gameObject)
        return itemlua
    end
end

function UIActivityChipRewardPetExchangeView:OnClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UINoticeTips)
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
	self.selectList = {}
	self.cacheNumList = {}
	self.selectList = nil
	self.cacheNumList = nil
end

function UIActivityChipRewardPetExchangeView:OnDispose()
	self.boxExchange.loopListView:Dispose()
	self.controller:OnDispose()
end

return UIActivityChipRewardPetExchangeView

