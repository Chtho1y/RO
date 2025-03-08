local UISimpleNoticeView = require("UICommonTips/UISimpleNoticeView_Generate")

function UISimpleNoticeView:OnAwake(data)
	self.controller = require("UICommonTips/UISimpleNoticeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISimpleNoticeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UISimpleNoticeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISimpleNoticeView:Init()
	local titleLangKey = self.controller:GetTitle()
	local contentLangKey = self.controller:GetContent()
	self.titleLab.text.text = titleLangKey and string.formatbykey(titleLangKey) or ''
	self.contentLab.text.text = contentLangKey and string.formatbykey(contentLangKey) or ''
end

function UISimpleNoticeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISimpleNoticeView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
end

function UISimpleNoticeView:OnHide()

end

function UISimpleNoticeView:OnShow(data)
	self.controller:SetData(data)

end

function UISimpleNoticeView:OnClose()
end

function UISimpleNoticeView:OnDispose()
	self.controller:OnDispose()
end

function UISimpleNoticeView:OnClickCloseBtn()
	self:UIClose()
end

return UISimpleNoticeView

