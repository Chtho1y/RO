local UIFashionLvUpView = require("UIFashion/UIFashionLvUpView_Generate")
local CostItemCtr = require("Common/CostItemCtr")

function UIFashionLvUpView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionLvUpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionLvUpView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LV_UP_CHANGE, self, self.OnPageInEnd)
end

function UIFashionLvUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionLvUpView:Init()
	if self.bg.uIEffectCfg and not self.bg.uIEffectCfg.Ready then
		self.bg.uIEffectCfg:LoadEffect()
	end
end

function UIFashionLvUpView:OnPageInEnd(needUp)
	self.super.OnPageInEnd(self)

	self:RefreshTop()
	self:RefreshAttrs(needUp)
	self:RefreshCosts()
	self:RefreshBottom()
	if needUp then
		if self.bg.uIEffectCfg then
			self.bg.uIEffectCfg:HideEffect("FX_UI_LV_UP",self.bg.fx.transform)
			self.bg.uIEffectCfg:ShowEffect("FX_UI_LV_UP",self.bg.fx.transform)
		end
	end
end

function UIFashionLvUpView:RefreshTop()
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end

	local itemlua = self.fashionWearItem
	itemlua.icon.image.sprite = nil
	itemlua.icon.image.enabled = false
	itemlua.frame.image.sprite = nil
	itemlua.frame.image.enabled = false
	CommonUtil.LoadIcon(self, fashionCfgData.FashionIcon, function (sprite)
		itemlua.icon.image.sprite = sprite
		itemlua.icon.image.enabled = true
	end, itemlua, "FashionWearItemIconAsyncIdx")
	CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[fashionCfgData.FashionQuality], function (sprite)
		itemlua.frame.image.sprite = sprite
		itemlua.frame.image.enabled = true
	end, itemlua, "FashionWearItemFrameAsyncIdx")
	itemlua.icon:SetActive(true)
	itemlua.bg:SetActive(true)
	itemlua.frame:SetActive(true)
	itemlua.selected:SetActive(false)
	itemlua.disable:SetActive(false)
	itemlua.redPoint:SetActive(false)
	itemlua.bg.button.onClick:RemoveAllListeners()

	local fashionLogicData = self.controller:GetFashionLogicData(fashionCfgData.FashionId)
	itemlua.num.text.text = "Lv "..(fashionLogicData and fashionLogicData.lv or 1)

	self.scrollView.text.text.text = I18N.T(fashionCfgData.FashionName)
	self.scrollView.numlv.text.text = (fashionLogicData and fashionLogicData.lv or 1) .. "/"..ManagerContainer.CfgMgr:GetFashionMaxLv()
end

function UIFashionLvUpView:RefreshAttrs(needUp)
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end

	local curLv = fashionLogicData and fashionLogicData.lv or 1
	local maxLv = ManagerContainer.CfgMgr:GetFashionMaxLv()
	self.lV:SetActive(true)
	self.lV.image:SetActive(curLv < maxLv)
	self.lV.number2:SetActive(curLv < maxLv)

	self.lV.number1.text.text = curLv
	self.lV.number2.text.text = curLv + 1
	if needUp then
		if self.lV.uIEffectCfg and not self.lV.uIEffectCfg.Ready then
			self.lV.uIEffectCfg:LoadEffect()
		end

		if self.lV.uIEffectCfg then
			self.lV.uIEffectCfg:HideEffect("FX_UI_TuPo_New",self.lV.fx.transform)
			self.lV.uIEffectCfg:ShowEffect("FX_UI_TuPo_New",self.lV.fx.transform)
		end
	end

	local lvCfgData = ManagerContainer.CfgMgr:GetFashionLvDataByLv(curLv)
	local nextLvCfgData = ManagerContainer.CfgMgr:GetFashionLvDataByLv(curLv + 1)
	local attrs = fashionLogicData.attrs
	for i = 1, 5 do
		local attrItem = self["attr"..i]
		if attrItem then
			local attr = attrs and attrs[i] or nil
			attrItem.image:SetActive(attr and curLv < maxLv)
			attrItem.number2:SetActive(attr and curLv < maxLv)
			attrItem.number1:SetActive(attr ~= nil)
			if attr then
				local jobType = attr.jobType
				local attrId = attr.attrId
				local attrValue = attr.value
				local jobName = self.controller:GetJobTypeName(jobType)
				attrItem.text.text.text = jobName..I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))
				attrItem.number1.text.text = "+"..attrValue

				attrItem.number2.text.text = "+"..(nextLvCfgData and nextLvCfgData.UpAttribute or 0)

				if needUp then
					if attrItem.uIEffectCfg and not attrItem.uIEffectCfg.Ready then
						attrItem.uIEffectCfg:LoadEffect()
					end

					if attrItem.uIEffectCfg then
						attrItem.uIEffectCfg:HideEffect("FX_UI_TuPo_New",attrItem.fx.transform)
						attrItem.uIEffectCfg:ShowEffect("FX_UI_TuPo_New",attrItem.fx.transform)
					end
				end
			end

			attrItem:SetActive(attr ~= nil)
		end
	end
end

local resLack = {}
function UIFashionLvUpView:RefreshCosts()
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end

	local lvCfgData = ManagerContainer.CfgMgr:GetFashionLvDataByLv(fashionLogicData.lv + 1)
	local isMax = lvCfgData == nil
	if isMax then
		lvCfgData = ManagerContainer.CfgMgr:GetFashionLvDataByLv(fashionLogicData.lv)
	end
	if not lvCfgData then
		return
	end

	local quality = fashionCfgData.FashionQuality
	local costs = lvCfgData['UpMaterial'..quality]

	for i = 1, 3 do
		local cost = costs and costs[i] or nil
		local costItem = self["cost"..i]
		if costItem then
			costItem:SetActive(cost ~= nil)
			if cost then
				local data = {cfgId = cost[1], cost = cost[2], isMax = isMax}
				CostItemCtr:SetData(self, costItem, data, self, self.ShowItemTips)
				resLack[i] = {isLack = false, cfgId = cost[1]}
				resLack[i].isLack = CommonUtil.ResLackErrorNotice(cost[1], cost[2], true)
			end
		end
	end
end

function UIFashionLvUpView:RefreshBottom()
	local fashionId = self.controller:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(fashionId)
	if not fashionCfgData or not fashionLogicData then
		return
	end

	local curLv = fashionLogicData and fashionLogicData.lv or 1
	local maxLv = ManagerContainer.CfgMgr:GetFashionMaxLv()

	self.max:SetActive(curLv >= maxLv)
	self.btnLvUp:SetActive(curLv < maxLv)
end

function UIFashionLvUpView:ShowItemTips(button, params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIFashionLvUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionLvUpView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.btnLvUp.button, self, self.OnClickUpgradeBtn)
end

function UIFashionLvUpView:OnClickClose()
	self:UIClose()
end

function UIFashionLvUpView:OnClickUpgradeBtn()
	for i = 1,#resLack do
		if resLack[i].isLack then
			CommonUtil.ItemNotEnoughHandle(resLack[i].cfgId)
			return
		end
	end
	self.controller:SendFashionLvUp()
end

function UIFashionLvUpView:OnHide()

end

function UIFashionLvUpView:OnShow(data)
	self.controller:SetData(data)

end

function UIFashionLvUpView:OnClose()
	for i = 1, 5 do
		local attrItem = self["attr"..i]
		if attrItem then
			attrItem.uIEffectCfg:Clean()
		end
	end

	self.bg.uIEffectCfg:Clean()
end

function UIFashionLvUpView:OnDispose()
	self.controller:OnDispose()
end

return UIFashionLvUpView

