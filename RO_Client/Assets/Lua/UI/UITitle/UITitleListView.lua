local UITitleListView = require("UITitle/UITitleListView_Generate")
local TitleListItemCtr = require("Common/TitleListItemCtr")
local TitleTypeList,TitleDataList
local SortRuleList = {4,2,1,3}
local currToggle = 0
local lastToggle = -1
function UITitleListView:OnAwake(data)
	self.controller = require("UITitle/UITitleListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UITitleListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_TITLE_CHANGE, self, self.OnTitleDataChange)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TITLE_ACTIVE_REDPOINT_NOTICE, self, self.ToggleRedPointNotice)
end

function UITitleListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end
function UITitleListView:GetShowItemByIdx(idx)
	local item = self.toggleList.loopGridView:GetShownItemByItemIndex(idx)
	if item then
		local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "ToggleItem", item.gameObject)
		return itemlua
	end
end
function UITitleListView:RefreshTitleEndTime()
	self.titleList.loopGridView:RefreshListByIndex(TitleDataList and #TitleDataList or 0)
end

function UITitleListView:OnTitleDataChange(changeData)
	for i = 1, #TitleDataList do
		local id = TitleDataList[i].titleId
		if changeData[id] then
			TitleDataList[i] = changeData[id]
		end
	end
	self.titleList.loopGridView:RefreshListByIndex(TitleDataList and #TitleDataList or 0)
	if self.timer and self.timer.running then
		self.timer:Stop()
	end
	if not self.timer then
		self.timer = Timer.New(slot(self.RefreshTitleEndTime, self), 3600,-1)
	end
	if not self.timer.running then
		self.timer:Start()
	end
end

function UITitleListView:ToggleRedPointNotice()
	local redPointList = ManagerContainer.DataMgr.TitleData:GetTitleRedPointList()
	for i = 0, self.toggleContent.transform.childCount - 1 do
		local item = self.toggleContent.transform:GetChild(i)
		local parent = item
		local redPoint = parent:Find("redPoint")
		if redPoint then
			redPoint.gameObject:SetActive(redPointList[i])
		else
			if redPointList[i] then
				self:CreateRP(parent, redPoint, "redPoint", "Common/UIRedPointRP")
			end
		end
	end
	if redPointList and #redPointList > 0 then
		for i = 1, #redPointList do
			local itemLua =  self:GetShowItemByIdx(i - 1)
			if not itemLua then
				return
			end
			local parent = itemLua.transform
			local redPoint = parent:Find("redPoint")
			if redPoint then
				redPoint.gameObject:SetActive(redPointList[i])
			else
				if redPointList[i] then
					self:CreateRP(parent, redPoint, "redPoint", "Common/UIRedPointRP")
				end
			end
		end
	end
end
function UITitleListView:CreateRP(parent, redPoint, name, path)
	local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, path)
    if go then
        redPoint = go.transform
        redPoint:SetParent(parent)
        redPoint.localRotation = Quaternion.identity
        redPoint.localScale = Vector3.one
        local rectTransform = redPoint:GetComponent(Enum.TypeInfo.RectTransform)
        rectTransform.anchoredPosition3D = Vector3(90, 35, 0)
        go.name = name
    end
end

function UITitleListView:Init()
	local time = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	TitleTypeList = ManagerContainer.DataMgr.TitleData:GetTitleTypeList()
	local idx = self.controller:GetData()
	currToggle =  idx and idx - 1 or 0
	lastToggle = -1
	local TitleDic = ManagerContainer.DataMgr.TitleData:GetTitleDataByType(currToggle + 1)
	TitleDataList = self:SortTitleData(TitleDic)
	self.titleList.scrollRect.enabled = false
	self.toggleList.scrollRect.enabled = false
	self.titleList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetTitleItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.toggleList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetToggleItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.titleList.loopGridView:RefreshListByIndex(TitleDataList and #TitleDataList or 0,0)
	self.toggleList.loopGridView:RefreshListByIndex(TitleTypeList and #TitleTypeList or 0,0)
	self:ToggleRedPointNotice()
	if self.timer and self.timer.running then
		self.timer:Stop()
	end
	if not self.timer then
		self.timer = Timer.New(slot(self.RefreshTitleEndTime, self), 3600,-1)
	end
	if not self.timer.running then
		self.timer:Start()
	end
end

function UITitleListView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.titleList.scrollRect.enabled = true
	self.toggleList.scrollRect.enabled = true
end

function UITitleListView:GetToggleItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
	item = gridView:NewListViewItem('ToggleItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'ToggleItem', item.gameObject)
	self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnChangeToggleBtnClick, itemIndex)
	itemLua.on:SetActive(currToggle == itemIndex)
	itemLua.label.text.text = I18N.SetLanguageValue('TitleType_'..TitleTypeList[itemIndex + 1])
	local redPointList = ManagerContainer.DataMgr.TitleData:GetTitleRedPointList()
	local parent = itemLua.transform
	local redPoint = parent:Find("redPoint")
	if redPoint then
		redPoint.gameObject:SetActive(redPointList[itemIndex + 1])
	else
		if redPointList[itemIndex + 1] then
			self:CreateRP(parent, redPoint, "redPoint", "Common/UIRedPointRP")
		end
	end
	return item
end
function UITitleListView:OnChangeToggleBtnClick(button, params)
	local idx = params[0]
	if button then
		lastToggle = currToggle
		currToggle = idx
		self:Refresh(idx)
	end
end

function UITitleListView:Refresh(idx)
	if idx == lastToggle then
		return
	end
	local itemLua =  self:GetShowItemByIdx(lastToggle)
	if itemLua then
		itemLua.on:SetActive(false)
	end
	local CurritemLua =  self:GetShowItemByIdx(idx)
	if CurritemLua then
		CurritemLua.on:SetActive(true)
	end
	local TitleDic = ManagerContainer.DataMgr.TitleData:GetTitleDataByType(idx + 1)
	TitleDataList = self:SortTitleData(TitleDic)
	self.titleList.loopGridView:RefreshListByIndex(TitleDataList and #TitleDataList or 0,0)
end


function UITitleListView:GetTitleItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
	item = gridView:NewListViewItem('TitleListItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'TitleListItem', item.gameObject)
	TitleListItemCtr:SetData(self,itemLua,TitleDataList[itemIndex + 1])
	return item
end
function UITitleListView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.titleList.scrollRect.enabled = true
	self.toggleList.scrollRect.enabled = true
end
function UITitleListView:OnBtnEquipClick(button,params)
	local param = params[0]
	self.controller:SendTitleOperateReq(2,param.titleId)
end
function UITitleListView:OnBtnActiveClick(button,params)
	local param = params[0]
	self.controller:SendTitleOperateReq(1,param.titleId)
end
function UITitleListView:OnBtnRemoveClick(button,params)
	local param = params[0]
	self.controller:SendTitleOperateReq(3,param.titleId)
end

function UITitleListView:SortTitleData(data)
	local titleList = {}
	for k, v in pairs(data) do
		table.insert(titleList,v)
	end
	table.sort(titleList,function(a,b)
		local titleDataA = ManagerContainer.CfgMgr:GetDesignationCfgById(a.titleId)
		local titleDataB = ManagerContainer.CfgMgr:GetDesignationCfgById(b.titleId)
		if SortRuleList[a.state] == SortRuleList[b.state] then
			if titleDataA.Sort == titleDataB.Sort then
				return a.titleId < b.titleId
			else
				return titleDataA.Sort > titleDataB.Sort
			end
		else
			return SortRuleList[a.state] < SortRuleList[b.state]
		end
	end)
	return titleList
end

function UITitleListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UITitleListView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.allAtrBtn.button, self, self.OnClickTotalAttrBtn)
end

function UITitleListView:OnClickTotalAttrBtn()
	local baseAttrs = {}
	local val = GlobalConfig.Instance:GetConfigStrValue(333)
	if val ~= "" and val ~= nil then
		local attrsTable = CommonUtil.DeserializeGlobalStrToNumberTable(val)
		for i = 1, #attrsTable do
			table.insert(baseAttrs,{attrsTable[i],0})
		end
	end
	local activeTitleList = ManagerContainer.DataMgr.TitleData:GetAllActiveTitleListAttrs()
	for i = 1, #baseAttrs do
		if activeTitleList[baseAttrs[i][1]] then
			baseAttrs[i][2] = activeTitleList[baseAttrs[i][1]]
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionTotal,{title="TitleTotalProperty", attrs=baseAttrs})
end

function UITitleListView:OnClickCloseBtn()
	self:UIClose()
end

function UITitleListView:OnHide()

end

function UITitleListView:OnShow(data)
	self.controller:SetData(data)

end

function UITitleListView:OnClose()
	if self.timer and self.timer.running then
		self.timer:Stop()
	end
end

function UITitleListView:OnDispose()
	self.toggleList.loopGridView:Dispose()
	self.titleList.loopGridView:Dispose()
	self.controller:OnDispose()
end

return UITitleListView

