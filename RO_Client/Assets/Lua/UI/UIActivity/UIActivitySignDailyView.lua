local UIActivitySignDailyView = require("UIActivity/UIActivitySignDailyView_Generate")

function UIActivitySignDailyView:OnAwake(data)
	self.controller = require("UIActivity/UIActivitySignDailyCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivitySignDailyView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTIVITY_SIGN_SUCCESS, self, self.Refresh)
end

function UIActivitySignDailyView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivitySignDailyView:Init()
	self:InitGrid()
	self:Refresh()
end

function UIActivitySignDailyView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	local actId = self.controller:GetActId()
	local cfgData = ManagerContainer.CfgMgr:GetActivityCfg(actId)
	if cfgData and cfgData.Name then
		self.titleTxt.text.text = cfgData.Name
	end
	self.dscTxt.text.text = I18N.SetLanguageValue(self.controller:GetRuleKey())
end


function UIActivitySignDailyView:InitGrid()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIActivitySignDailyView:Refresh(resetPos)
	self.controller:RefreshShowDatas()
	local loopGridView = self.scrollView.loopGridView
	local length = self.controller:GetShowDataLength()
	if resetPos then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end
end

function UIActivitySignDailyView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetShowDataLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	local showData = self.controller:GetShowData(itemIndex)
	local canSignToday = self.controller:GetCanSignToday()
	local item = gridView:NewListViewItem("SignRewardItem")
	item.gameObject.name = itemIndex
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "SignRewardItem", item.gameObject)

	local data = {idx = itemIndex + 1, cfgData = showData, canSignToday = canSignToday,enterType = 1,signDays = self.controller:GetSignDays()}
	CommonUtil.UpdateItemPrefab(self, itemlua, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
	return item
end

function UIActivitySignDailyView:OnItemClick(button, params)
	local cfgData = params[0]

	local canSignDay =self.controller:GetSignDays()
	local canSignToday = self.controller:GetCanSignToday()

	if not canSignToday then
		--今日已经签到过
		--ManagerContainer.LuaUIMgr:ShowMinRewardTips(cfgData.SignInReward)
		local data = {cfgId = cfgData.SignInReward[1][1], num = cfgData.SignInReward[1][2]}
		ManagerContainer.LuaUIMgr:OpenTips(data)
	else
		if cfgData.ID == canSignDay + 1 then
			self.controller:SendSignUp()
		else
			--ManagerContainer.LuaUIMgr:ShowMinRewardTips(cfgData.SignInReward)
			local data = {cfgId = cfgData.SignInReward[1][1], num = cfgData.SignInReward[1][2]}
			ManagerContainer.LuaUIMgr:OpenTips(data)
		end
	end
end

function UIActivitySignDailyView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivitySignDailyView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "SignInQA"})
end

function UIActivitySignDailyView:OnCloseClick()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

function UIActivitySignDailyView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	--self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
end

function UIActivitySignDailyView:OnHide()

end

function UIActivitySignDailyView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivitySignDailyView:OnClose()
	self.scrollView.loopGridView:Dispose()
end

function UIActivitySignDailyView:OnDispose()
	self.controller:OnDispose()
end

return UIActivitySignDailyView

