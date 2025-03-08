local UIRoleStrengthView = require("UIRoleMain/UIRoleStrengthView_Generate")
local CostItemCtr = require("Common/CostItemCtr")

local breakImgs = {"FrameNew/bg_label_corner_green", "FrameNew/bg_label_corner_blue", "FrameNew/bg_label_corner_purple", "FrameNew/bg_label_corner_gold", "FrameNew/bg_label_corner_red", "FrameNew/bg_label_corner_red2"}

local canStrength = false
local lackCoin = false
local lackFate = false
function UIRoleStrengthView:OnAwake(data)
	self.controller = require("UIRoleMain/UIRoleStrengthCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRoleStrengthView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PARTNER_STRENGTH_SUCCESS, function()
		self:RefreshStrengthSuccess()

	end)
end

function UIRoleStrengthView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRoleStrengthView:Init()
	self:Refresh()
end

function UIRoleStrengthView:Refresh(newUp)
	local partnerId = self.controller:GetData()
	local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(partnerId)
	local cfgData = ManagerContainer.CfgMgr:GetParterProgressById(partnerData.ParterJob)
	local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(partnerId)
	local strengthLv = logicData.strengthLevel

	local nextLv = strengthLv + 1
	local isMax = strengthLv >= cfgData.BreachTimes

	self.btnStrength:SetActive(strengthLv < cfgData.BreachTimes)
	self.max:SetActive(strengthLv >= cfgData.BreachTimes)

	self.labelBox:SetActive(strengthLv > 0)
	self.labelBox.text.text.text = I18N.T("BtnBreak").."+"..strengthLv

	if strengthLv > 0 then
		local breakImg = breakImgs[strengthLv]
		if not breakImg then
			breakImg = breakImgs[#breakImgs]
		end
		CommonUtil.LoadIcon(self, breakImg, function (sprite)
			self.labelBox.label.image.sprite = sprite
			self.labelBox.labelLt.image.sprite = sprite
		end)
		if newUp then
			self.labelBox.animator:Play("LabelChange")
		end
	end

	for i = 1, 6 do
		local item = self["strengthAttr"..i]
		item:SetActive(false)
		item.number2:SetActive(false)
		item.arrow:SetActive(false)

		if item.uIEffectCfg and not item.uIEffectCfg.Ready then
			item.uIEffectCfg:LoadEffect()
		end
	end

	--当前属性
	local nextAttributes = cfgData["BreachAttribute"..nextLv]
	if nextAttributes == nil then
		nextAttributes = cfgData["BreachAttribute"..cfgData.BreachTimes]
	end
	if nextAttributes == nil then
		return
	end

	nextAttributes = CommonUtil.DeserializeCfgItemList(nextAttributes)
	for i = 1, #nextAttributes do
		local attrId = nextAttributes[i][1]
		local num = logicData.attrs[attrId]

		local item = self["strengthAttr"..i]
		item:SetActive(true)
		item.text.text.text = I18N.T("Attr_" .. attrId)
		item.number.text.text = CommonUtil.HeroAttrFormatValueNoSign(attrId, num, true)

		if newUp then
			if item.uIEffectCfg then
				item.uIEffectCfg:ShowEffect("FX_UI_TuPo_New",item.fx.transform)
			end
		end
	end

	--下一突破
	if not isMax then
		for i = 1, #nextAttributes do
			local attrId = nextAttributes[i][1]
			local num = SDataUtil.Add(logicData.attrs[attrId], attrId > 21 and nextAttributes[i][2]*0.0001 or nextAttributes[i][2])
			local attrValue = attrId > 21 and CommonUtil.GetPreciseDecimal(num, 2) or SDataUtil.Div(num, 1)
			if attrValue == 0 then
				attrValue = 0.01
			end

			local item = self["strengthAttr"..i]
			item.number2.text.text = CommonUtil.HeroAttrFormatValueNoSign(attrId, attrValue, true)
			item.number2:SetActive(true)
			item.arrow:SetActive(true)
		end
	end

	self:RefreshCurRefineCost(cfgData, nextLv, isMax)
end

function UIRoleStrengthView:RefreshCurRefineCost(cfgData, nextLv, isMax)
	local nextMoneyCost, nextItemCost = 0,0
	if not isMax then
		nextMoneyCost = cfgData.BreachMoney[nextLv]
		nextItemCost = cfgData.BreachCost[nextLv]
	else
		nextMoneyCost = cfgData.BreachMoney[cfgData.BreachTimes]
		nextItemCost = cfgData.BreachCost[cfgData.BreachTimes]
	end

	local data = {cfgId = Enum.ItemType.Coin, cost = nextMoneyCost, isMax = isMax}
	local result = CostItemCtr:SetData(self, self.cost2, data, self, self.ShowItemTips)

	lackCoin = CommonUtil.ResLackErrorNotice(Enum.ItemType.Coin, nextMoneyCost, true)

	local data1 = {cfgId = nextItemCost[1], num = 0, cost = nextItemCost[2], isMax = isMax}
	local result1 = CostItemCtr:SetData(self, self.cost1, data1, self, self.ShowItemTips)

	lackFate = CommonUtil.ResLackErrorNotice(nextItemCost[1], nextItemCost[2], true)

	canStrength = result and result1 and not isMax
end

function UIRoleStrengthView:RefreshStrengthSuccess()
	local partnerId = self.controller:GetData()
	local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(partnerId)
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(partnerId)
	local oldLogicData = CommonUtil.TableClone(logicData)
	oldLogicData.strengthLevel = oldLogicData.strengthLevel - 1

	local replaceParams = {StrengthLevel = logicData.strengthLevel - 1}
	local actorData = ManagerContainer.LuaActorDataMgr:GetActorsById(logicData.id);
	CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, actorData,false, actorData.HeadFrameId, nil, nil, nil, replaceParams)

	self.strengthSuccess:SetActive(true)

	self.transform:DOScale(1, 1):OnComplete(function ()
		--HeroHeadIcon:SetInactivationHeroIcon(self, cfgData, self.headItem, logicData)
		local actorData = ManagerContainer.LuaActorDataMgr:GetActorsById(logicData.id);
		CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, actorData,false,actorData.HeadFrameId)
	end)

	self.transform:DOScale(1, 4):OnComplete(function ()
		self.strengthSuccess:SetActive(false)
		self:Refresh(true)
	end)
end

function UIRoleStrengthView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRoleStrengthView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	--self.uiBase:AddButtonEventListener(self.strengthSuccess.button, function ()
	--	self.strengthSuccess:SetActive(false)
	--	--self:UIClose()
	--	self:Refresh()
	--end)

	self.uiBase:AddButtonEventListener(self.btnStrength.button, function ()
		--if not canStrength then return end
		if lackCoin then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("4")
			return
		end

		if lackFate then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LackKnotOfFate")
			return
		end
		local partnerId = self.controller:GetData()
		local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(partnerId)
		self.controller:SendStrengthReq(logicData.id)
	end)
end

function UIRoleStrengthView:ShowItemTips(button, params)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, params[0])
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIRoleStrengthView:OnHide()
end

function UIRoleStrengthView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIRoleStrengthView:OnClose()

end

function UIRoleStrengthView:OnDispose()
	DG.Tweening.DOTween.Kill(self.transform)

	for i = 1, 6 do
		local item = self["strengthAttr"..i]
		item.uIEffectCfg:Clean()
	end
end

return UIRoleStrengthView

