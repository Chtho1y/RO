local UIVipExpTipsView = require("UIVip/UIVipExpTipsView_Generate")

function UIVipExpTipsView:OnAwake(data)
	self.controller = require("UIVip/UIVipExpTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVipExpTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIVipExpTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVipExpTipsView:Init()
	self:RefreshView()
end

function UIVipExpTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVipExpTipsView:AddUIEventListener()

end

function UIVipExpTipsView:OnHide()

end

function UIVipExpTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIVipExpTipsView:OnClose()
end

function UIVipExpTipsView:OnDispose()
	if self.animTimer then
		self.animTimer:Stop()
		self.animTimer = nil
	end
	if self.closeTimer then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
	self.controller:OnDispose()
end

function UIVipExpTipsView:RefreshView()
	local curLv, lastExp, curExp = self.controller:GetInfo()
	local vipExp = 1
	local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(curLv)
	self.vipIcon.image.sprite = nil
	self.vipIcon.image.enabled = false
	if vipCfg then
		self.vipNameTxt.text.text = string.formatbykey(vipCfg.Name)
		CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
			if sprite then
				self.vipIcon.image.sprite = sprite
				self.vipIcon.image.enabled = true
			end
		end)
		vipExp = vipCfg.VipExp or 0
	else
		self.vipNameTxt.text.text = ''
	end
	vipExp = Mathf.Max(vipExp, lastExp, curExp)

	self.addNum.text.text = '+' .. tostring(curExp - lastExp)
	self.slider1.slider.value = (curExp / vipExp)
	self.slider2.slider.value = (lastExp / vipExp)
	self.number.text.text = tostring(curExp) .. '/' .. tostring(vipExp)

	if self.animTimer then
		self.animTimer:Stop()
		self.animTimer = nil
	end
	self.animTimer = Timer.New(function()
		self.slider2.slider:DOValue((curExp / vipExp), 1)
	end, 0.5)
	self.animTimer:Start()

	if self.closeTimer then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
	self.closeTimer = Timer.New(function()
		self:CheckNextChange()
	end, 2.3)
	self.closeTimer:Start()
	self.vipExpAnim.animator:Play('FightPowerShow', -1, 0)
	self.vipExpAnim.animator:Update(0)
end

function UIVipExpTipsView:CheckNextChange()
	local isNext = self.controller:RefreshNextChange()
	if not isNext then
		self:UIClose()
		return
	end
	self:RefreshView()
end

return UIVipExpTipsView

