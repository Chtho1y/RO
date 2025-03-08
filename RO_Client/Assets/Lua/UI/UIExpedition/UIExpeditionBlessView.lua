local UIExpeditionBlessView = require("UIExpedition/UIExpeditionBlessView_Generate")

function UIExpeditionBlessView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionBlessCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionBlessView:AddEventListener()
end

function UIExpeditionBlessView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionBlessView:Init()

end

function UIExpeditionBlessView:OnPageInEnd()
	self:ShowBuffs()
	self.super.OnPageInEnd(self)
end

function UIExpeditionBlessView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpeditionBlessView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
end

function UIExpeditionBlessView:OnHide()

end

function UIExpeditionBlessView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpeditionBlessView:OnClose()
	self.buffScrollList.loopVerticalScrollRect:ClearCells()
end

function UIExpeditionBlessView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionBlessView:ShowBuffs()
	local buffs = ManagerContainer.DataMgr.ExpeditionDataMgr:GetBuffs()
	if buffs ~= nil and #buffs > 0 then
		self.emptyNode:SetActive(false)
		CommonUtil.LoopGridViewEleCreateNew(self,
			self.buffScrollList.loopVerticalScrollRect,
			self.buffScrollList.content.gridLayoutGroup,
			buffs,
			0,
			self, self.SetBuffData);
	else
		self.emptyNode:SetActive(true)
		self.buffScrollList.loopVerticalScrollRect:ClearCells()
	end
end

function UIExpeditionBlessView:SetBuffData(node,idx,buffData)
	node.buffName.text.text = buffData.Name
	CommonUtil.LoadIcon(self, buffData.Icon, function (sprite)
		node.buffIcon.image.sprite = sprite
	end, node, "ExpeditionBuffIdx")
	node.buffDesc.text.text = buffData.Desc
	node:SetActive(true)
end

function UIExpeditionBlessView:OnClickClose()
	self:UIClose()
end

return UIExpeditionBlessView

