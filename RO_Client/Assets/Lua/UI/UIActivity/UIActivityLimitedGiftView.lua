local UIActivityLimitedGiftView = require("UIActivity/UIActivityLimitedGiftView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local updateHandle
local curTime
local interTime = 1
function UIActivityLimitedGiftView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityLimitedGiftCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityLimitedGiftView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.LIMIT_RECHARGE_PAY_SUCCESS_NTF, self, self.OnPaySuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.LIMIT_RECHARGE_OPEN_NTF, self, self.RefreshNew)
end

function UIActivityLimitedGiftView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityLimitedGiftView:Init()
	self.inited = false
	self.dot:SetActive(false)

	self.controller:InitLimitedGiftIdx()
	self:InitGird()
end

function UIActivityLimitedGiftView:InitUpdate()
	if not updateHandle then
		updateHandle = UpdateBeat:CreateListener(self.Update, self)
	end

	UpdateBeat:AddListener(updateHandle)

	curTime = 0
end

function UIActivityLimitedGiftView:InitGird()
	local initParam = SuperScrollView.LoopListViewInitParam()
	initParam.mSmoothDumpRate = 0.05
	initParam.mSnapVecThreshold = 9999
	self.scrollView.loopListView.OffsetSnapCenterPercent = 0.4
	self.scrollView.loopListView.ItemSnapEnable = true
	self.scrollView.loopListView:InitListView(-1, function(loopListView, idx)
		return self:GetItemByRowColumn(loopListView, idx)
	end, nil, initParam)
	self.scrollView.scrollRect.horizontal = false
end

function UIActivityLimitedGiftView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	self:InitUpdate()
	self:Refresh()
end

function UIActivityLimitedGiftView:RefreshNew()
	if not self.controller:IsExist() then
		self:OnCloseClick()
		return
	end

	self.controller:InitLimitedGiftIdx()
	self:Refresh()
end

function UIActivityLimitedGiftView:Refresh()
	local idx = self.controller:GetLimitRechargeIdx()
	local length = self.controller:GetLimitRechargeCount()

	self.inited = true

	self:DisposeDot()
	self:RefreshDots()

	self.btnArrowR:SetActive(length > 1)
	self.btnArrowL:SetActive(length > 1)

	self.scrollView.scrollRect.horizontal = length > 1
	self.dotToggleGroup:SetActive(length > 1)

	if length == 0 then
		return
	end

	--self.scrollView.loopListView:SetListItemCount(length, false)
	self.scrollView.loopListView:MovePanelToItemIndex(idx - 1, 0)
	self.scrollView.loopListView:RefreshAllShownItem()
end

function UIActivityLimitedGiftView:RefreshDots()
	if not self.dots then self.dots = {} end

	local length = self.controller:GetLimitRechargeCount()
	local selectedIdx = self.controller:GetLimitRechargeIdx()
	local num = #self.dots
	local dot = nil
	local parent = self.dotToggleGroup.transform
	for i = 1, length do
		if i <= num then
			dot = self.dots[i]
		else
			dot = CommonUtil.Instantiate(self.dot.gameObject, parent)
			if tolua.getpeer(dot) == nil then
				tolua.setpeer(dot, {})
			end
			dot.toggle = dot:GetComponent(Enum.TypeInfo.Toggle)
			self.dots[i] = dot
		end
		dot:SetActive(true)
		dot.toggle.isOn = (i == selectedIdx)
	end
	for i = length + 1, num do
		dot = self.dots[i]
		dot:SetActive(false)
	end
end

function UIActivityLimitedGiftView:DisposeDot()
	if not self.dots then return end
	for _, dot in pairs(self.dots) do
		CommonUtil.DestroyGO(dot)
		dot.toggle = nil
		if tolua.getpeer(dot) ~= nil then
			tolua.setpeer(dot, nil)
		end
	end
	self.dots = nil
end

function UIActivityLimitedGiftView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local data = self.controller:GetCurLimitRechargeData(itemIndex)
	if not data then return nil end
	local cfgData = ManagerContainer.CfgMgr:GetActivitiesDiscountsCfgById(data.activitiesId)
	if not data then return nil end
	local item = gridView:NewListViewItem('LimitedGiftItem')
	if not item then return nil end
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'LimitedGiftItem', item.gameObject)

	local type = cfgData.TriggeringCondition and cfgData.TriggeringCondition[1][1] or 0
	local param1 = cfgData.TriggeringCondition and cfgData.TriggeringCondition[1][2] or 0
	local param2 = cfgData.TriggeringCondition and cfgData.TriggeringCondition[1][3] or 0

	if type == Enum.UnlockChargeType.DrawCardMVP or type == Enum.UnlockChargeType.DrawPetMVP then
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(param1)
		param1 = I18N.T(itemCfgData.Name)
	elseif type == Enum.UnlockChargeType.BattleLevel then
		local levelCfgData = ManagerContainer.CfgMgr:GetLevelDataById(param1)
		param1 = I18N.T(levelCfgData.Name)
	end

	if cfgData.PlaceholderCount == 0 then
		itemlua.levelText.uILocalizeScript:SetContentAndValues("DscGoddessTalk_"..type, {I18N.T(cfgData.Name)})
	elseif cfgData.PlaceholderCount == 1 then
		itemlua.levelText.uILocalizeScript:SetContentAndValues("DscGoddessTalk_"..type, {param1, I18N.T(cfgData.Name)})
	elseif cfgData.PlaceholderCount == 2 then
		itemlua.levelText.uILocalizeScript:SetContentAndValues("DscGoddessTalk_"..type, {param1, param2, I18N.T(cfgData.Name)})
	end

	itemlua.value.text.text = cfgData.Value
	itemlua.presentPrice.number.text.text = cfgData.Money

	self:RefreshReward(itemlua, cfgData)
	self:InitRemainTime(itemlua, data)

	self.uiBase:AddButtonUniqueEventListener(itemlua.presentPrice.button, self, self.OnPayClick)

	item.CachedRectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Horizontal, self.scrollView.loopListView.ViewPortWidth)
	return item
end

function UIActivityLimitedGiftView:RefreshReward(itemlua, cfgData)
	local reward = cfgData.Reward
	if not reward then return end

	if self.rewards == nil then
		self.rewards = {}
	end

	for i = 1, 4 do
		local item = itemlua["item"..i]
		item:SetActive(reward[i] ~= nil)
		if reward[i] then
			local trans = item.transform
			local data = {cfgId = reward[i][1], num = reward[i][2]}
			if trans.childCount > 1 then
				local iconItem = item.transform:GetChild(1)
				local itemlua1 = CommonUtil.GetBatchItemByGo(self, Enum.PrefabNames.ItemItem, iconItem.gameObject)
				IconItemCtr:SetData(self, itemlua1, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
			else
				ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.ItemItem, function(itemlua1)
					CommonUtil.BatchCreateItems(self, itemlua1, item.transform, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
				end)
			end
		end
	end
end

function UIActivityLimitedGiftView:InitRemainTime(itemlua, data)
	local time = self.controller:GetRemainTime(data.activitiesId)
	itemlua.endTimeText.uILocalizeScript:SetContentAndValues("DscLimitedGiftTime", {time})
end

function UIActivityLimitedGiftView:RefreshRemainTime()
	local id = self.controller:GetLimitRechargeId()
	local time = self.controller:GetRemainTime(id)
	self.itemlua.endTimeText.uILocalizeScript:SetContentAndValues("DscLimitedGiftTime", {time})

	if not self.controller:IsExist() then
		self:OnCloseClick()
	end
end

function UIActivityLimitedGiftView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIActivityLimitedGiftView:Update()
	if not curTime then return end
	curTime = curTime + Time.deltaTime
	if curTime >= interTime then
		curTime = 0
		self:RefreshRemainTime()
	end
end

function UIActivityLimitedGiftView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIActivityLimitedGiftView:AddUIEventListener()
	--self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.BtnClose.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.btnArrowL.button, self, self.OnLeftClick)
	self.uiBase:AddButtonEventListener(self.btnArrowR.button, self, self.OnRightClick)

	self.scrollView.loopListView.mOnBeginDragAction = function()
		self:OnBeginDragAction()
	end
	self.scrollView.loopListView.mOnDragingAction = function()
		self:OnDragingAction()
	end
	self.scrollView.loopListView.mOnSnapItemFinished = function(loopListView, loopListViewItem)
		return self:OnSnapItemFinished(loopListView, loopListViewItem)
	end
end

function UIActivityLimitedGiftView:OnSnapItemFinished(loopListView, loopListViewItem)
	local data = self.controller:GetCurLimitRechargeData(loopListViewItem.ItemIndex)
	self.itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "LimitedGiftItem", loopListViewItem.gameObject)
	if self.inited then
		local idx = self.controller:GetLimitRechargeIdx()
		local isAuto = self.controller:GetData()
		if isAuto then

		else
			self.controller:HasOpened(data.activitiesId)
		end
		self.controller:SetCurId(data.activitiesId)
		self.controller:SetSelectedIdx(loopListViewItem.ItemIndex)
	end
	self:RefreshDots()
end

function UIActivityLimitedGiftView:OnCloseClick()
	self:UIClose()
end

function UIActivityLimitedGiftView:OnBeginDragAction()

end

function UIActivityLimitedGiftView:OnDragingAction()
	local idx = self.scrollView.loopListView.CurSnapNearestItemIndex
	self.curDragIdx = math.abs(idx)
	if self.lastDragIdx ~= self.curDragIdx then
		local length = self.controller:GetLimitRechargeCount()
		local realIdx = math.fmod(idx, length)
		self.controller:SetSelectedIdx(realIdx)
		self.controller:SetIdBySelectedIdx()
		self:RefreshDots()
		self.lastDragIdx = self.curDragIdx
	end
end

function UIActivityLimitedGiftView:OnLeftClick()
	--self.controller:SetData(false)
	local idx = self.controller:GetSelectedIdx()
	idx = idx - 1
	self.scrollView.loopListView:SetSnapTargetItemIndex(idx)
end

function UIActivityLimitedGiftView:OnRightClick()
	--self.controller:SetData(false)
	local idx = self.controller:GetSelectedIdx()
	idx = idx + 1
	self.scrollView.loopListView:SetSnapTargetItemIndex(idx)
end

function UIActivityLimitedGiftView:OnPayClick()
	local id = self.controller:GetLimitRechargeId()
	local errorCode = ManagerContainer.PayMgr:LimitedGiftPay(id)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	if not errorCodeKey then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCodeKey)
	end
end

function UIActivityLimitedGiftView:OnPaySuccess()
	--if not self.controller:IsExist() then
	--	self:OnCloseClick()
	--end
end

function UIActivityLimitedGiftView:OnHide()

end

function UIActivityLimitedGiftView:OnShow(data)
	self.controller:SetData(data)
	self:Refresh()
	curTime = 0
end

function UIActivityLimitedGiftView:OnClose()
	if updateHandle ~= nil then
		UpdateBeat:RemoveListener(updateHandle)
		updateHandle = nil
	end

	self:DisposeDot()

	self.itemlua = nil
	self.scrollView.loopListView:Dispose()
	self.scrollView.loopListView.mOnSnapItemFinished = nil
	self.scrollView.loopListView.mOnBeginDragAction = nil
	self.scrollView.loopListView.mOnDragingAction = nil
end

function UIActivityLimitedGiftView:OnDispose()
	self.controller:OnDispose()
end

return UIActivityLimitedGiftView

