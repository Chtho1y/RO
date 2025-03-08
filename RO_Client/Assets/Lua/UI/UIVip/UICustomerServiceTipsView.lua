local UICustomerServiceTipsView = require("UIVip/UICustomerServiceTipsView_Generate")

function UICustomerServiceTipsView:OnAwake(data)
	self.controller = require("UIVip/UICustomerServiceTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICustomerServiceTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
end

function UICustomerServiceTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICustomerServiceTipsView:Init()
	local parent = self.texts.transform
	self.sourceGo = parent:Find('Contact').gameObject
	local itemLuas = self.itemLuas
	if not itemLuas then
		itemLuas = {self:GetItemLua(self.sourceGo)}
		self.itemLuas = itemLuas
	end

	local datas = self.controller:GetData()
	local len1 = datas and #datas or 0
	local len2 = #itemLuas
	local itemLua = nil
	local data = nil
	for i = 1, len1 do
		data = datas[i]
		itemLua = itemLuas[i]
		if not itemLua then
			local newGo = CommonUtil.Instantiate(self.sourceGo, parent)
			itemLua = self:GetItemLua(newGo)
			itemLuas[i] = itemLua
		end
		if itemLua then
			if data then
				itemLua.go:SetActive(true)
				itemLua.nameTxt.text = data.name or ''
				itemLua.contentTxt.text = data.account or ''
				self.uiBase:AddButtonUniqueEventListener(itemLua.copyBtn, self, self.OnClickCopyBtn, i)
			else
				itemLua.go:SetActive(false)
			end
		end
	end

	for i = len1 + 1, len2 do
		itemLua = itemLuas[i]
		if itemLua then
			itemLua.go:SetActive(false)
		end
	end
end

function UICustomerServiceTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UICustomerServiceTipsView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UICustomerServiceTipsView:OnHide()

end

function UICustomerServiceTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UICustomerServiceTipsView:OnClose()
end

function UICustomerServiceTipsView:OnDispose()
	self:DisposeItemLuas()
	self.sourceGo = nil
	self.controller:OnDispose()
end

function UICustomerServiceTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UICustomerServiceTipsView:OnClickCopyBtn(_, params)
	local idx = params[0]
	if not idx then
		return
	end
	local datas = self.controller:GetData()
	if not datas then
		return
	end
	local data = datas[idx]
	if not data or not data.account or data.account == '' then
		return
	end
	UnityEngine.GUIUtility.systemCopyBuffer = data.account
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('CopySucceed')
end

function UICustomerServiceTipsView:GetItemLua(itemGo)
	if not itemGo then return nil end
	local itemLua = {}
	itemLua.go = itemGo
	local trans = itemGo.transform
	itemLua.nameTxt = trans:Find('Text1'):GetComponent(Enum.TypeInfo.Text)
	itemLua.contentTxt = trans:Find('Text2'):GetComponent(Enum.TypeInfo.Text)
	itemLua.copyBtn = trans:Find('BtnCopy'):GetComponent(Enum.TypeInfo.Button)
	return itemLua
end

function UICustomerServiceTipsView:DisposeItemLuas()
	if not self.itemLuas then
		return
	end
	for _, itemLua in pairs(self.itemLuas) do
		if itemLua then
			local go = itemLua.go
			itemLua.go = nil
			itemLua.nameTxt = nil
			itemLua.contentTxt = nil
			itemLua.copyBtn = nil
			if go and go ~= self.sourceGo then
				CommonUtil.DestroyGO(go)
			end
		end
	end
	self.itemLuas = nil
end


return UICustomerServiceTipsView

