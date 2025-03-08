local UIActivityFortnightLoginView = require("UIActivity/UIActivityFortnightLoginView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local makeUpCost = 10
function UIActivityFortnightLoginView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityFortnightLoginCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityFortnightLoginView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.OnRefreshActivity);
end

function UIActivityFortnightLoginView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityFortnightLoginView:Init()
	makeUpCost = GlobalConfig.Instance:GetConfigIntValue(260)
	self.controller:InitActivityData(self.uiData.id)
	self.subActItemList = {}
	self.subActItemLuaList = {}
	self.templateItem:SetActive(false)
	self:InitUIComs()
	self:RefreshActData()
end

function UIActivityFortnightLoginView:InitUIComs()
	local activityItem = self.controller:GetActivityData()
	if activityItem ~= nil then
		local data = activityItem:GetActivityData()
		if data ~= nil then
			for i = 1, #data do
				self:CreateSubActItem(i,data[i])
			end
		end
	else
		self.templateItem:SetActive(false)
	end

	local pageBg = self.controller:GetBg()
	if pageBg ~= "" then
		CommonUtil.LoadIcon(self, pageBg, function (sprite)
			self.image.image.sprite = sprite
		end)
	end
end


function UIActivityFortnightLoginView:OnRefreshActivity(activityId)
	local actItem = self.controller:GetActivityData()
	if actItem == nil or actItem.actId ~= activityId then
		return
	end

	self:RefreshActData()
end


function UIActivityFortnightLoginView:RefreshActData()
	local activityItem = self.controller:GetActivityData()
	if activityItem ~= nil then
		self.curDayTxt.text.text = activityItem.curDay .. I18N.T("Day")
		local data = activityItem:GetActivityData()
		if data ~= nil then
			for i = 1, #data do
				self:RefreshItemData(self.subActItemLuaList[i],data[i],activityItem.curDay)
			end
		end
	end
end

function UIActivityFortnightLoginView:CreateSubActItem(day,data)
	local itemGo = UnityEngine.GameObject.Instantiate(self.templateItem.gameObject)
	self.subActItemList[#self.subActItemList+1] = itemGo
	local rewardItemLua = CommonUtil.BindGridViewItem2Lua(self, "RewardItem", itemGo)
	rewardItemLua.prefabName = "RewardItem"
	
	itemGo.name = "d"..day
	rewardItemLua.name = "RewardItem"
	rewardItemLua.transform:SetParent(self.rewardsNode.transform)
	rewardItemLua.transform.localScale = Vector3(1,1,1)
	rewardItemLua.rectTransform.anchoredPosition3D = Vector3(0,0,0)
	rewardItemLua.dayTxt.text.text = "<color=" .. data.txtClr .. ">".. string.formatbykey("TitleFirstRechargeRewards",day) .. "</color>"
	rewardItemLua:SetActive(true)
	rewardItemLua.gotRewardNode:SetActive(false)
	rewardItemLua.missNode:SetActive(false)

	CommonUtil.LoadIcon(self, data.qualityIcon, function (sprite)
		rewardItemLua.image.sprite = sprite
		end)
	self.subActItemLuaList[#self.subActItemLuaList+1] = rewardItemLua
end

function UIActivityFortnightLoginView:RefreshItemData(rewardItemLua,itemData,curDay)
	local rewardData = {cfgId = itemData.rewards[1][1], num = itemData.rewards[1][2] }
	if itemData.isGotReward then
		rewardItemLua.gotRewardNode:SetActive(true)
		rewardItemLua.MakeUpNode:SetActive(false)
		rewardItemLua.shad:SetActive(true)
		rewardItemLua.iconItem.bg.button.interactable = false
		local itemCfg = IconItemCtr:SetData(self, rewardItemLua.iconItem, rewardData)
		if itemData.day == curDay then
			self.curRewardName.text.text = itemCfg.Name
		end
	elseif itemData.isOutdate then
		rewardItemLua.gotRewardNode:SetActive(false)
		--rewardItemLua.missNode:SetActive(true)
		rewardItemLua.MakeUpNode:SetActive(true)
		rewardItemLua.shad:SetActive(false)
		--rewardItemLua.iconItem.bg.button.interactable = false
		IconItemCtr:SetData(self, rewardItemLua.iconItem, rewardData, nil, self, self.OnClickMakeUp,itemData.day)
	else
		rewardItemLua.gotRewardNode:SetActive(false)
		rewardItemLua.MakeUpNode:SetActive(false)

		if itemData.day <= curDay then
			rewardItemLua.shad:SetActive(false)
			local itemCfg = IconItemCtr:SetData(self, rewardItemLua.iconItem, rewardData, nil, self, self.OnClickGetReward,itemData.day)
			if itemData.day == curDay then
				self.curRewardName.text.text = itemCfg.Name
			end
		else
			IconItemCtr:SetData(self, rewardItemLua.iconItem, rewardData, nil, self, self.OnClickItem)
			rewardItemLua.shad:SetActive(true)
		end
	end

	rewardItemLua.iconItem.redPoint:SetActive(itemData.isFinished and (not itemData.isOutdate) and (not itemData.isGotReward))
end

function UIActivityFortnightLoginView:OnClickGetReward(btn,params)
	local day = params and params[2] or self.makeUpDay
	local activityItem = self.controller:GetActivityData()
	if activityItem ~= nil then
		activityItem:SendRewardReq(day)
	end

	self.makeUpDay = nil
end

function UIActivityFortnightLoginView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIActivityFortnightLoginView:OnClickMakeUp(btn, params)
	self.makeUpDay = params[2]
	local data = {"LoginActivityTip", {makeUpCost}, nil, self, self.OnClickGetReward}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIActivityFortnightLoginView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityFortnightLoginView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.backBtn.button,self, self.OnClickCloseBtn)
end

function UIActivityFortnightLoginView:OnHide()

end

function UIActivityFortnightLoginView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityFortnightLoginView:OnClose()
	if self.subActItemList ~= nil then
		for i= 1, #self.subActItemList do
			CommonUtil.DestroyGO(self.subActItemList[i])
		end
		self.subActItemList = nil
	end

	CommonUtil.ClearGridViewItem(self,"RewardItem")
	self.subActItemLuaList = nil

	self.makeUpDay = nil
end

function UIActivityFortnightLoginView:OnDispose()
	self.controller:OnDispose()
end

function UIActivityFortnightLoginView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
        ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
    end
end

return UIActivityFortnightLoginView

