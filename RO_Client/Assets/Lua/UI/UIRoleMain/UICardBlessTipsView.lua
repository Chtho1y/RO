local UICardBlessTipsView = require("UIRoleMain/UICardBlessTipsView_Generate")

function UICardBlessTipsView:OnAwake(data)
	self.controller = require("UIRoleMain/UICardBlessTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardBlessTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UICardBlessTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardBlessTipsView:Init()
	self:Refresh()
end

function UICardBlessTipsView:Refresh()
	local curLv, isMax = self.controller:GetCurCardSuitLv()
	local cfgData = ManagerContainer.CfgMgr:GetCardSuitNewCfgById(curLv)

	self:RefreshTop(curLv, isMax, cfgData)
	self:RefreshAttrs(curLv, isMax, cfgData)
end

function UICardBlessTipsView:RefreshTop(curLv, isMax, cfgData)
	local allCfgDatas = ManagerContainer.CfgMgr:GetAllCardSuitNewCfg()
	local state = self.controller:GetState()
	if not state then
		curLv = curLv - 1
	end
	self.cardBlessLv.lv0:SetActive(curLv == 0)
	for i = 1, #allCfgDatas do
		if self.cardBlessLv["lv"..i] then
			self.cardBlessLv["lv"..i]:SetActive(curLv == i)
		end
	end
end

function UICardBlessTipsView:RefreshAttrs(curLv, isMax, cfgData)
	local curCount, totalCount = self.controller:GetSuitCount()
    local state = self.controller:GetState()
	self:RefreshLvAttrs(self.currentLv, state, curCount, totalCount, cfgData)

	local nextLv = curLv + 1
	local nextCfgData = ManagerContainer.CfgMgr:GetCardSuitNewCfgById(nextLv)
	self.nextLv:SetActive(state and not isMax and nextCfgData ~= nil)
	if state and not isMax and nextCfgData ~= nil then
        local totalCount, nextCount  = self.controller:GetSatisfyCardCountByLv(nextLv)
		self:RefreshLvAttrs(self.nextLv, false, nextCount, totalCount, nextCfgData)
	end
end

function UICardBlessTipsView:RefreshLvAttrs(parent, state, curCount, totalCount, cfgData)
	parent.lv.text.text = I18N.SetLanguageValue("CardSuitTips1", cfgData.Id)

    parent.activedState:SetActive(state)
	parent.condition1:SetActive(#curCount >= 1)
	parent.condition2:SetActive(#curCount >= 2)

	for i = 1,#curCount do
		parent["condition"..i].count.text.text = curCount[i].."/"..totalCount[i]
		parent["condition"..i].activedState:SetActive(curCount[i]>=totalCount[i])

		local condition = cfgData.TriggerConditions[i]
		local type = condition[1]
		local lv = condition[2]
		local typeDsc = "Normal"
		if type == 2 then
			typeDsc = "Mini"
		elseif type == 3 then
			typeDsc = "Mvp"
		end
		parent["condition"..i].dscAttr.text.text = I18N.SetLanguageValue("CardSuitTips", lv, typeDsc)
	end
    local color = state and Constant.GreenColorText or Constant.GrayColorText
	for i = 1, 5 do
		local attr = cfgData.Suit1[i]
		local itemLua = parent["cardBlessAttrItem"..i]
		itemLua:SetActive(attr ~= nil)
		if attr then
			local attrId = attr[1]
			local attrNum = attr[2]*0.0001
			attrNum = attrId > 21 and CommonUtil.GetPreciseDecimal(attrNum, 3) or math.floor(attrNum)

			itemLua.text.text.text = I18N.T("Attr_" .. attrId)
			itemLua.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrNum, true)
		    CommonUtil.SetTextColor(itemLua.text.text, color)
            CommonUtil.SetTextColor(itemLua.number.text, color)
        end
	end
end

function UICardBlessTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardBlessTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self,self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button,self,self.OnCloseClick)
end

function UICardBlessTipsView:OnCloseClick()
	self:UIClose()
end

function UICardBlessTipsView:OnHide()

end

function UICardBlessTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UICardBlessTipsView:OnClose()
end

function UICardBlessTipsView:OnDispose()
	self.controller:OnDispose()
end

return UICardBlessTipsView

