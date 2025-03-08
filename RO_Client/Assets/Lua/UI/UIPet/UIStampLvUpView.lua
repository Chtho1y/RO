local UIStampLvUpView = require("UIPet/UIStampLvUpView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local lastCfgId = 0
local isMaxLv = false
local canAdvance = false
local lackCostId
function UIStampLvUpView:OnAwake(data)
	self.controller = require("UIPet/UIStampLvUpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIStampLvUpView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_STAMP_LEVEL_UP_REFRESH, self, self.OnLvUpNtf)
end

function UIStampLvUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIStampLvUpView:Init()
	self:Refresh()
end

function UIStampLvUpView:Refresh()
	local stampData = self.controller:GetStampData()
	if not stampData then
		return
	end

	local cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(stampData.cfgId)
	if not cfgData then
		return
	end

	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(stampData.cfgId)
	if not itemCfgData then
		return
	end

	local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(stampData.lv, stampData.cfgId)
	if not lvCfgData then
		return
	end

	local nextLvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(stampData.lv + 1, stampData.cfgId)
	local nextStampLvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(1, cfgData.Advance)

	lastCfgId = stampData.cfgId

	IconItemCtr:SetData(self, self.popLvUp.iconItem, stampData)

	self.popLvUp.nameText.uILocalizeScript:SetContent(cfgData.Name)
	self.popLvUp.lV.number.text.text = stampData.lv .."/"..cfgData.MaxLevel

	isMaxLv = stampData.lv >= cfgData.MaxLevel
	canAdvance = cfgData.Advance > 0
	local nextCfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(cfgData.Advance)
	local nextCfgName = nextCfgData and nextCfgData.Name or ""

	self.popLvUp.lVLimit.text.text.text = I18N.T("LV")
	self.popLvUp.lVLimit.number1.text.text = I18N.T(cfgData.Name)

	for i = 1, 5 do
		local attr = lvCfgData.Nature[i]
		local attrItem = self.popLvUp["attr"..i]
		attrItem:SetActive(attr ~= nil)
		if attr ~= nil then
			local val = attr[2]
			attrItem.text.text.text = I18N.T("Attr_" .. attr[1])
			attrItem.number1.text.text = val
			attrItem.number2:SetActive(canAdvance or (not canAdvance and not isMaxLv))
			attrItem.image:SetActive(canAdvance or (not canAdvance and not isMaxLv))
			if isMaxLv then
				if canAdvance then
					local val1 = nextStampLvCfgData.Nature[i] and nextStampLvCfgData.Nature[i][2] or 0
					attrItem.number2.text.text = val1
				end
			else
				local val1 = nextLvCfgData.Nature[i] and nextLvCfgData.Nature[i][2] or 0
				attrItem.number2.text.text = val1
			end
		end
	end

	self.popLvUp.lVLimit:SetActive(isMaxLv)
	self.popLvUp.lVLimit.text:SetActive(not isMaxLv)
	self.popLvUp.lVLimit.image:SetActive(canAdvance or (not canAdvance and not isMaxLv))
	self.popLvUp.lVLimit.number2:SetActive(canAdvance or (not canAdvance and not isMaxLv))
	if canAdvance then
		self.popLvUp.lVLimit.number2.text.text = isMaxLv and I18N.T(nextCfgName) or I18N.T(cfgData.Name)
	end

	if not isMaxLv then
		local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(stampData.lv, stampData.cfgId)
		local costs = lvCfgData.Cost
		self:RefresCost(costs, false)
	elseif isMaxLv and canAdvance then
		local costs = cfgData.AdvanceCost
		self:RefresCost(costs, true)
	end
	self.cost:SetActive(canAdvance or (not canAdvance and not isMaxLv))

	self.popLvUp.btnLvUp:SetActive(not isMaxLv)
	self.popLvUp.btnAdvance:SetActive(isMaxLv and canAdvance)
	self.popLvUp.max:SetActive(isMaxLv and not canAdvance)
end

function UIStampLvUpView:RefresCost(costs, isAdvence)
	if not costs then
		self.cost1:SetActive(false)
		self.cost1:SetActive(false)
		return
	end

	for i = 1, 2 do
		local cost = costs[i]
		local costItem = self["cost"..i]
		costItem:SetActive(cost ~= nil)
		if cost then
			local cfgData = ManagerContainer.CfgMgr:GetItemById(cost[1])
			local costTb = tolua.getpeer(costItem)
			CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				costItem.icon.image.sprite = sprite
			end, costTb, "costIcon")

			local ownCount = CommonUtil.GetOwnResCountByItemId(cost[1])
			if not isAdvence then
				costItem.number.text.text = CommonUtil.FormatNumber(cost[2])
				CommonUtil.IsConditionOutColor(costItem.number.text, cost[2] > ownCount, cost[2])
			else
				local str = cost[1] ~= Enum.ItemType.Coin and ownCount.."/"..cost[2] or CommonUtil.FormatNumber(cost[2])
				costItem.number.text.text = str
				CommonUtil.IsConditionOutColor(costItem.number.text, cost[2] > ownCount, str)
			end
			if not lackCostId and cost[2] > ownCount then
				lackCostId = cost[1]
			end
		end
	end
end

function UIStampLvUpView:RefreshAdvanceSusccess()
	local stampData = self.controller:GetStampData()
	if not stampData then
		return
	end

	local cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(stampData.cfgId)
	if not cfgData then
		return
	end

	local lastCfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(lastCfgId)
	if not lastCfgData then
		return
	end

	local lastStampLvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(lastCfgData.MaxLevel, lastCfgId)
	local stampLvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(1, stampData.cfgId)

	IconItemCtr:SetData(self, self.popEvolutionOK.iconItem, stampData)

	self.popEvolutionOK.lVLimit.number1.text.text = I18N.T(lastCfgData.Name)

	for i = 1, 5 do
		local attr = lastStampLvCfgData.Nature[i]
		local nextAttr = stampLvCfgData.Nature[i]
		local attrItem = self.popEvolutionOK["attr"..i]
		attrItem:SetActive(attr ~= nil)
		if attr ~= nil then
			local val = attr[2]
			attrItem.text.text.text = I18N.T("Attr_" .. attr[1])
			attrItem.number1.text.text = val
			local val1 = nextAttr[2]
			attrItem.number2.text.text = val1
		end
	end

	self.popEvolutionOK.lVLimit.number2.text.text = I18N.T(cfgData.Name)
	self.popEvolutionOK:SetActive(true)
	self.popLvUp:SetActive(false)
end

function UIStampLvUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIStampLvUpView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.popLvUp.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.popEvolutionOK.AnyBtn.button, self, self.OnOkCloseClick)
	self.uiBase:AddButtonEventListener(self.popLvUp.btnLvUp.button, self, self.OnLvUpClick)
	self.uiBase:AddButtonEventListener(self.popLvUp.btnAdvance.button, self, self.OnAdvanceClick)
end

function UIStampLvUpView:OnCloseClick()
	self:UIClose()
end

function UIStampLvUpView:OnOkCloseClick()
	self.popLvUp:SetActive(true)
	self.popEvolutionOK:SetActive(false)
end

function UIStampLvUpView:OnLvUpClick()
	if isMaxLv then
		return
	end
	if lackCostId then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(lackCostId))
	end
	self.controller:SendLvUp()
end

function UIStampLvUpView:OnAdvanceClick()
	if not canAdvance then
		return
	end
	if lackCostId then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(lackCostId))
	end
	self.controller:SendAdvance()
end

function UIStampLvUpView:LvUpSuccessDisplay()
	--self.fx_ui_lv_up.uIParticle:PlayCachedParticalSystem(false)
	self.fx_ui_lv_up.uIParticle:PlayCachedParticalSystem(true)
end

function UIStampLvUpView:OnLvUpNtf()
	lackCostId = nil
	local state = self.controller:GetState()
	if state == 1 then
		self:LvUpSuccessDisplay()
	elseif state == 2 then
		self:RefreshAdvanceSusccess()
	end
	self:Refresh()
	self.controller:ClearState()
end

function UIStampLvUpView:OnHide()

end

function UIStampLvUpView:OnShow(data)
	self.controller:SetData(data)

end

function UIStampLvUpView:OnClose()
end

function UIStampLvUpView:OnDispose()
	self.controller:OnDispose()
end

return UIStampLvUpView

