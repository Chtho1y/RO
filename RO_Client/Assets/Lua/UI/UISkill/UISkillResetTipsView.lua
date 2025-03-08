local UISkillResetTipsView = require("UISkill/UISkillResetTipsView_Generate")

function UISkillResetTipsView:OnAwake(data)
	self.controller = require("UISkill/UISkillResetTipsCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISkillResetTipsView:AddEventListener()

end

function UISkillResetTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISkillResetTipsView:Init()
	local cfgId, num = self.controller:GetResetCost()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if itemCfgData then
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
			self.btnResetAll.resIcon.image.sprite = sprite
		end, self, "CostItemIconAsyncIdx")
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
			self.btnResetAdvance.resIcon.image.sprite = sprite
		end, self, "CostItemIconAsyncIdx")
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
			self.btnReset.resIcon.image.sprite = sprite
		end, self, "CostItemIconAsyncIdx")
	end
	if num <= 0 then
		self.btnReset.resText.text.text = string.formatbykey('Free')
		self.btnResetAdvance.resText.text.text = string.formatbykey('Free')
		self.btnResetAll.resText.text.text = string.formatbykey('Free')
	else
		local ownNum = self.controller:GetOwnResCountByItemId(cfgId)
		if ownNum < num then
			self.btnReset.resText.text.text = string.format(Constant.PinkColorText, tostring(num))
			self.btnResetAdvance.resText.text.text = string.format(Constant.PinkColorText, tostring(num))
			self.btnResetAll.resText.text.text = string.format(Constant.PinkColorText, tostring(num))
		else
			self.btnReset.resText.text.text = tostring(num)
			self.btnResetAdvance.resText.text.text = tostring(num)
			self.btnResetAll.resText.text.text = tostring(num)
		end
	end
	local isAdvance = self.controller:GetIsAdvance()
	self.btnResetAdvance:SetActive(isAdvance)
	self.btnResetAll:SetActive(isAdvance)
	self.btnReset:SetActive(not isAdvance)
end

function UISkillResetTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISkillResetTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.btnReset.button, self, self.OnClickResetBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnResetAll.button, self, self.OnClickResetBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnResetAdvance.button, self, self.OnClickResetAdvanceBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UISkillResetTipsView:OnHide()

end

function UISkillResetTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UISkillResetTipsView:OnClose()
end

function UISkillResetTipsView:OnDispose()
	self.controller:OnDispose()
end

function UISkillResetTipsView:OnClickResetBtn()
	self.controller:ResetCallback()
	self:UIClose()
end

function UISkillResetTipsView:OnClickResetAdvanceBtn()
	self.controller:ResetCallback(1)
	self:UIClose()
end

function UISkillResetTipsView:OnClickCloseBtn()
	self.controller:CancelCallback()
	self:UIClose()
end

return UISkillResetTipsView

