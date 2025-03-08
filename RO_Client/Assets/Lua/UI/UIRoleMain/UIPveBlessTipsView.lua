local UIPveBlessTipsView = require("UIRoleMain/UIPveBlessTipsView_Generate")

function UIPveBlessTipsView:OnAwake(data)
	self.controller = require("UIRoleMain/UIPveBlessTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPveBlessTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_CHANGED, function()
		self:Refresh()
	end)
end

function UIPveBlessTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPveBlessTipsView:Init()
	self:Refresh()
end

function UIPveBlessTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPveBlessTipsView:Refresh()
	local id = self.controller:GetData()
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(id)
	local currNerveLv = skillData:GetCurrNerveLv()
	local allCfgDatas = ManagerContainer.CfgMgr:GetAllSkillSuitNewCfg()
	for i = 1, #allCfgDatas do
		if self.pveBlessLv["lv"..(i - 1)] then
			self.pveBlessLv["lv"..(i - 1)]:SetActive(currNerveLv == i)
		end
	end
	if currNerveLv == 1 then
		self.currentLv:SetActive(false)
		self.nextLv:SetActive(true)
		self:RefreshInfo(self.nextLv,currNerveLv + 1,skillData)
	elseif #allCfgDatas == currNerveLv then
		self.currentLv:SetActive(true)
		self.nextLv:SetActive(false)
		self:RefreshInfo(self.currentLv,currNerveLv,skillData,true)
	else
		if currNerveLv == 0 then
			return
		end
		self.currentLv:SetActive(true)
		self.nextLv:SetActive(true)
		self:RefreshInfo(self.currentLv,currNerveLv,skillData,true)
		self:RefreshInfo(self.nextLv,currNerveLv + 1,skillData)
	end
end

function UIPveBlessTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self,self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button,self,self.OnCloseClick)
end

function UIPveBlessTipsView:OnCloseClick()
	self:UIClose()
end

function UIPveBlessTipsView:RefreshInfo(item,currLv,skillData,state)
	local color = state and Constant.GreenColorText or Constant.GrayColorText
	local skillSuitData  = ManagerContainer.CfgMgr:GetSkillSuitNewCfgById(currLv)
	local Suit1 = skillSuitData.Suit1
	local condition = skillSuitData.TriggerConditions[1]
	if condition then
		item.dscAttr.text.text = I18N.SetLanguageValue("SkillSuit",condition[2])
	end
	local currData = skillData:GetNerveCurrDataById(currLv)
	if currData then
		local currcount = currData.currcount or 0
		local needNum   = currData.needNum or 0
		item.count.text.text = "("..currcount.."/"..needNum..")"
	end
	item.lv.text.text = I18N.SetLanguageValue("CardSuitTips1",currLv - 1)
	item.activedState:SetActive(state)
	if Suit1 and #Suit1 > 0 then
		for i = 1, #Suit1 do
			if 	item["cardBlessAttrItem"..i] then
				local key = Suit1[i][1]
				local val = Suit1[i][2] or 0
				local itemlua = item["cardBlessAttrItem"..i]
				itemlua.text.text.text = I18N.T("SkillSuitNew_" .. key)
				itemlua.number.text.text = (SDataUtil.IsGreater(val, 0) and '+' or (SDataUtil.IsLess(val, 0) and '-'or '')) .. val .. "%"
				CommonUtil.SetTextColor(itemlua.text.text, color)
				CommonUtil.SetTextColor(itemlua.number.text, color)
			end
		end
	end
end

function UIPveBlessTipsView:OnHide()

end

function UIPveBlessTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPveBlessTipsView:OnClose()
end

function UIPveBlessTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIPveBlessTipsView

