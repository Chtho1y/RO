local UICardDecomposeTipsView = require("UICardTips/UICardDecomposeTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UICardDecomposeTipsView:OnAwake(data)
	self.controller = require("UICardTips/UICardDecomposeTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardDecomposeTipsView:AddEventListener()

end

function UICardDecomposeTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardDecomposeTipsView:Init()
	self.controller:ResetSelectionList()
	self.normal.checkBox.check:SetActive(false)
	self.mini.checkBox.check:SetActive(false)
	self.mVP.checkBox.check:SetActive(false)

	local normalCount = self.controller:GetDecomposeCardCount(Enum.CardType.NORMAL)
	local miniCount = self.controller:GetDecomposeCardCount(Enum.CardType.MINIBOSS)
	local mvpCount = self.controller:GetDecomposeCardCount(Enum.CardType.MVP)
	self.normal.count.text.text = normalCount
	self.mini.count.text.text = miniCount
	self.mVP.count.text.text = mvpCount

	local isOneKey = self.controller:IsOneKeyDecompose()

	self.normal:SetActive(isOneKey or normalCount > 0)
	self.mini:SetActive(isOneKey or miniCount > 0)
	self.mVP:SetActive(isOneKey or mvpCount > 0)

	self.normal.checkBox:SetActive(isOneKey)
	self.mini.checkBox:SetActive(isOneKey)
	self.mVP.checkBox:SetActive(isOneKey)

	if isOneKey then
		self.normal.checkBox.check:SetActive(self.controller:SetSelectionList(Enum.CardType.NORMAL))
	else
		self.controller:SetSelectionList(Enum.CardType.NORMAL)
		self.controller:SetSelectionList(Enum.CardType.MINIBOSS)
		self.controller:SetSelectionList(Enum.CardType.MVP)
	end

	self:RefreshAward()
end

function UICardDecomposeTipsView:RefreshAward()
	local awards = self.controller:GetDecomposeAwards()
	for i = 1,3 do
		self["award"..i]:SetActive(i <= #awards)
		if i <= #awards then
			local data = {cfgId = awards[i][1], num = awards[i][2]}
			local itemLua = self["awardItem"..i]
			IconItemCtr:SetData(self, itemLua, data, Enum.ItemIEnterType.CardCompose, self, self.ShowItemTips)
			self["award"..i].text.text.text = data.num
		end
	end
end

function UICardDecomposeTipsView:ShowItemTips(button, params)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, params[0])
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UICardDecomposeTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardDecomposeTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.normal.checkBox.button, function (buttton, params)
		self.normal.checkBox.check:SetActive(self.controller:SetSelectionList(Enum.CardType.NORMAL))
		self:RefreshAward()
	end)

	self.uiBase:AddButtonEventListener(self.mini.checkBox.button, function (buttton, params)
		self.mini.checkBox.check:SetActive(self.controller:SetSelectionList(Enum.CardType.MINIBOSS))
		self:RefreshAward()
	end)

	self.uiBase:AddButtonEventListener(self.mVP.checkBox.button, function (buttton, params)
		self.mVP.checkBox.check:SetActive(self.controller:SetSelectionList(Enum.CardType.MVP))
		self:RefreshAward()
	end)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function (buttton, params)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CARD_DECOMPOSE_CACHE_COUNTS)
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.alpha.button, function (buttton, params)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CARD_DECOMPOSE_CACHE_COUNTS)
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnCancle.button, function (buttton, params)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RESET_CARD_DECOMPOSE_CACHE_COUNTS)
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnDecompose.button, function (buttton, params)
		if self.controller:GetDecomposeCardCount(Enum.CardType.MINIBOSS) > 0 or self.controller:GetDecomposeCardCount(Enum.CardType.MVP) > 0 then
			self:UIHide(false)
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardProduceNotice, Enum.UIPageName.UICardDecomposeTips)
			return
		end

		self.controller:SendDecompose()
		self:UIClose()
	end)
end

function UICardDecomposeTipsView:OnHide()

end

function UICardDecomposeTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardDecomposeTipsView:OnClose()
end

function UICardDecomposeTipsView:OnDispose()

end

return UICardDecomposeTipsView

