local UISignDailyView = require("UISign/UISignDailyView_Generate")

function UISignDailyView:OnAwake(data)
	self.controller = require("UISign/UISignDailyCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISignDailyView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SIGN_UP_SUCCESS, self, self.Refresh)
end

function UISignDailyView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISignDailyView:Init()
	self:InitGrid()
	self:Refresh()

	if ManagerContainer.DataMgr.SignData:CanTodaySign() then
		self.delayTimer = FrameTimer.New(function()
			self:AutoSignUp()
		end, 1)
		self.delayTimer:Start()
	end
end

function UISignDailyView:InitGrid()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UISignDailyView:Refresh(resetPos)
	self.controller:RefreshShowDatas()
	local loopGridView = self.scrollView.loopGridView
	local length = self.controller:GetShowDataLength()
	if resetPos then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end
end

function UISignDailyView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetShowDataLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	local showData = self.controller:GetShowData(itemIndex)
	local canSignToday = self.controller:GetCanSignToday()
	local item = gridView:NewListViewItem("SignRewardItem")
	item.gameObject.name = itemIndex
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "SignRewardItem", item.gameObject)

	local data = {idx = itemIndex + 1, cfgData = showData, canSignToday = canSignToday}
	CommonUtil.UpdateItemPrefab(self, itemlua, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
	return item
end

function UISignDailyView:OnItemClick(button, params)
	local cfgData = params[0]

	local canSignDay = ManagerContainer.DataMgr.SignData:GetCanSignDay()
	local canSignToday = self.controller:GetCanSignToday()

	if not canSignToday then
		--今日已经签到过
		--ManagerContainer.LuaUIMgr:ShowMinRewardTips(cfgData.SignInReward)
		local data = {cfgId = cfgData.SignInReward[1][1], num = cfgData.SignInReward[1][2]}
		ManagerContainer.LuaUIMgr:OpenTips(data)
	else
		if cfgData.ID == canSignDay then
			self.controller:SendSignUp()
		else
			--ManagerContainer.LuaUIMgr:ShowMinRewardTips(cfgData.SignInReward)
			local data = {cfgId = cfgData.SignInReward[1][1], num = cfgData.SignInReward[1][2]}
			ManagerContainer.LuaUIMgr:OpenTips(data)
		end
	end
end

function UISignDailyView:AutoSignUp()
	self.controller:SendSignUp()
end

function UISignDailyView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISignDailyView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "SignInQA"})
end

function UISignDailyView:OnCloseClick()
	self:UIClose()
end

function UISignDailyView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	--self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
end

function UISignDailyView:OnHide()

end

function UISignDailyView:OnShow(data)
	self.controller:SetData(data)

end

function UISignDailyView:OnClose()
	if self.delayTimer then
		self.delayTimer:Stop()
		self.delayTimer = nil
	end

	self.scrollView.loopGridView:Dispose()
end

function UISignDailyView:OnDispose()
	self.controller:OnDispose()
end

return UISignDailyView

