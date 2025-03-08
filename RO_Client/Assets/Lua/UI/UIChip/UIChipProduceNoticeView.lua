local UIChipProduceNoticeView = require("UIChip/UIChipProduceNoticeView_Generate")

function UIChipProduceNoticeView:OnAwake(data)
	self.controller = require("UIChip/UIChipProduceNoticeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChipProduceNoticeView:AddEventListener()

end

function UIChipProduceNoticeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChipProduceNoticeView:Init()
	self.dscBox.notice.uILocalizeScript:SetContent('ChipDecomposeTips01')
	self.desTxt.uILocalizeScript:SetContent("ChipDecomposeTips02")
	self.text.uILocalizeScript:SetContent("BtnDecompose")
end

function UIChipProduceNoticeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChipProduceNoticeView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.alpha.button, function (buttton, params)
		self.controller:CancelDecompose()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function (buttton, params)
		self.controller:CancelDecompose()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnCancle.button, function (buttton, params)
		self.controller:CancelDecompose()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnProduce.button, function (buttton, params)
		self.controller:SureDecompose()
		self:UIClose()
	end)
end

function UIChipProduceNoticeView:OnHide()


end

function UIChipProduceNoticeView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIChipProduceNoticeView:OnClose()
end

function UIChipProduceNoticeView:OnDispose()

end

return UIChipProduceNoticeView

