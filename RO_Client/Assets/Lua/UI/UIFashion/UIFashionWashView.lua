local UIFashionWashView = require("UIFashion/UIFashionWashView_Generate")
local CostItemCtr = require("Common/CostItemCtr")

local washCost
function UIFashionWashView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionWashCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionWashView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_WASH_CHANGE, self, self.RefreshNewAttrs)
end

function UIFashionWashView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionWashView:Init()
	local val = GlobalConfig.Instance:GetConfigStrValue(299)
	if val ~= "" and val ~= nil then
		washCost = CommonUtil.DeserializeGlobalStrToTable(val)
	end
end

function UIFashionWashView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:RefreshNewAttrs()
end

function UIFashionWashView:RefreshNewAttrs()
	self:RefreshAttrs()
	self:RefreshCosts()
	self:RefreshBottom()
end

function UIFashionWashView:RefreshAttrs()
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end

	local attrs = fashionLogicData.attrs
	local resetAttrs = fashionLogicData.resetAttrs
	for i = 1, 5 do
		local attrItem = self["washAttrItem"..i]
		if attrItem then
			local attr = attrs and attrs[i] or nil
			if attr then
				local jobType = attr.jobType
				local attrId = attr.attrId
				local attrValue = attr.value
				local jobName = self.controller:GetJobTypeName(jobType)
				attrItem.propertyItem1.prName.text.text = jobName..I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))
				attrItem.propertyItem1.number.text.text = "+"..attrValue
			end
			local resetAttr = resetAttrs and resetAttrs[i] or nil
			attrItem.propertyItem2.prName:SetActive(resetAttr ~= nil)
			attrItem.propertyItem2.number:SetActive(resetAttr ~= nil)
			attrItem.propertyItem2.random:SetActive(resetAttr == nil)
			if resetAttr then
				local jobType = resetAttr.jobType
				local attrId = resetAttr.attrId
				local attrValue = resetAttr.value
				local jobName = self.controller:GetJobTypeName(jobType)
				attrItem.propertyItem2.prName.text.text = jobName..I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))
				attrItem.propertyItem2.number.text.text = "+"..attrValue

				if attrItem.uIEffectCfg and not attrItem.uIEffectCfg.Ready then
					attrItem.uIEffectCfg:LoadEffect()
				end

				if attrItem.uIEffectCfg then
					attrItem.uIEffectCfg:HideEffect("FX_UI_TuPo_New",attrItem.fx.transform)
					attrItem.uIEffectCfg:ShowEffect("FX_UI_TuPo_New",attrItem.fx.transform)
				end
			end
			attrItem:SetActive(attr ~= nil)
		end
	end
end

local resLack = {}
function UIFashionWashView:RefreshCosts()
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end
	for i = 1, 3 do
		local costItem = self["cost"..i]
		if costItem then
			costItem:SetActive(false)
		end
	end

	local cost = washCost[fashionCfgData.FashionQuality]
	local costItem = self.cost1
	if costItem then
		costItem:SetActive(cost ~= nil)
		if cost then
			local cfgId = tonumber(cost[1])
			local num = tonumber(cost[2])
			local data = {cfgId = cfgId, cost = num}
			CostItemCtr:SetData(self, costItem, data, self, self.ShowItemTips)
			resLack[1] = {isLack = false, cfgId = cfgId}
			resLack[1].isLack = CommonUtil.ResLackErrorNotice(cfgId, num, true)
		end
	end
end

function UIFashionWashView:RefreshBottom()
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end

	local resetAttrs = fashionLogicData.resetAttrs
	local resetState = #resetAttrs > 0

	self.btnWash:SetActive(not resetState)
	self.btnWashAgain:SetActive(resetState)
	self.btnKeep:SetActive(resetState)
end

function UIFashionWashView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIFashionWashView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionWashView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.btnWash.button, self, self.OnClickWashBtn, false)
	self.uiBase:AddButtonEventListener(self.btnWashAgain.button, self, self.OnClickWashBtn, false)
	self.uiBase:AddButtonEventListener(self.btnKeep.button, self, self.OnClickWashBtn, true)
end

function UIFashionWashView:OnClickClose()
	self:UIClose()
end

function UIFashionWashView:OnClickWashBtn(button, params)
	local state = params[0]
	if not state then
		for i = 1,#resLack do
			if resLack[i].isLack then
				CommonUtil.ItemNotEnoughHandle(resLack[i].cfgId)
				return
			end
		end
	end
	self.controller:SendFashionWash(state)
end

function UIFashionWashView:OnHide()

end

function UIFashionWashView:OnShow(data)
	self.controller:SetData(data)

end

function UIFashionWashView:OnClose()
	for i = 1, 5 do
		local attrItem = self["washAttrItem"..i]
		if attrItem then
			attrItem.uIEffectCfg:Clean()
		end
	end
end

function UIFashionWashView:OnDispose()
	self.controller:OnDispose()
end

return UIFashionWashView

