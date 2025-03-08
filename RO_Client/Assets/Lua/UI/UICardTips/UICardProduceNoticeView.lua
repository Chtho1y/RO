local UICardProduceNoticeView = require("UICardTips/UICardProduceNoticeView_Generate")

function UICardProduceNoticeView:OnAwake(data)
	self.controller = require("UICardTips/UICardProduceNoticeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardProduceNoticeView:AddEventListener()

end

function UICardProduceNoticeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardProduceNoticeView:Init()
	if self.controller:GetData() == Enum.UIPageName.UICardList then
		self.dscBox.notice.uILocalizeScript:SetContent("CardResettingTips")
		self.desTxt.uILocalizeScript:SetContent("CardResettingTips01")
		self.text.uILocalizeScript:SetContent("BtnProduceCard")
	elseif self.controller:GetData() == Enum.UIPageName.UICardDecomposeTips then
		self.dscBox.notice.uILocalizeScript:SetContent("CardDecomposeTips01")
		self.desTxt.uILocalizeScript:SetContent("CardDecomposeTips02")
		self.text.uILocalizeScript:SetContent("BtnDecompose")
	end
end

function UICardProduceNoticeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardProduceNoticeView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function (buttton, params)
		self:UIClose()
		if self.controller:GetData() == Enum.UIPageName.UICardDecomposeTips then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardDecomposeTips)
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnCancle.button, function (buttton, params)
		self:UIClose()
		if self.controller:GetData() == Enum.UIPageName.UICardDecomposeTips then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardDecomposeTips)
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnProduce.button, function (buttton, params)
		if self.controller:GetData() == Enum.UIPageName.UICardList then
			local UICardListCtr = require("UICardList/UICardListCtr")
			UICardListCtr:SendCardReceate()
		elseif self.controller:GetData() == Enum.UIPageName.UICardDecomposeTips then
			local UICardDecomposeTipsCtr = require("UICardTips/UICardDecomposeTipsCtr")
			UICardDecomposeTipsCtr:SendDecompose()
		end
		self:UIClose()
	end)
end

function UICardProduceNoticeView:OnHide()

end

function UICardProduceNoticeView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardProduceNoticeView:OnClose()

end

function UICardProduceNoticeView:OnDispose()

end

return UICardProduceNoticeView

