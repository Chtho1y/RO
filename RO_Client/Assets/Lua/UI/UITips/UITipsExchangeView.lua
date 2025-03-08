local UITipsExchangeView = require("UITips/UITipsExchangeView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local ColorExtension = require("ColorExtension")

function UITipsExchangeView:OnAwake(data)
	self.controller = require("UITips/UITipsExchangeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UITipsExchangeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTIVITY_PAGECLOSE,self,self.OnClickCloseBtn)
end

function UITipsExchangeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UITipsExchangeView:Init()
	local cfgId = self.controller:GetCfgId()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData then return end

	local cfgData = self:GetCfgDataAndType(cfgId,itemCfgData.ResType,itemCfgData.ComposeItem)
	if cfgData == nil then
		cfgData = itemCfgData
	end

	local itemType = itemCfgData.ResType

	local data1 = {cfgId = cfgId, num = 0}
	IconItemCtr:SetData(self, self.iconItem, data1, Enum.ItemIEnterType.Bag)

	self.textName.text.text = I18N.T(itemCfgData.Name)
	self.type1.text1.uILocalizeScript:SetContent('Type')
	self.type1.text2.text.text = I18N.T("ItemTypeDes_"..itemType)

	local dsc = cfgData.Desc or itemCfgData.Describe
	local count
	if self.controller:GetisExchangeItem() or self.controller:GetEnterType() == Enum.UIPageName.UIActivityChipRewardCom  then
		self.desTxt.text.text = self.controller:GetisExchangeDesc() and I18N.T(self.controller:GetisExchangeRadioDesc()) or I18N.T(dsc)
		count = CommonUtil.GetOwnResCountByItemId(cfgId) or 0
	else
		self.desTxt.text.text = I18N.T(dsc)
		count = self.controller:GetCfgCount()
	end
	if itemCfgData.ResType < 100 then
		count = CommonUtil.FormatNumber(count)
	else
		count = CommonUtil.GetPreciseDecimalFloor(count/10000, 1) .. "w"
	end
	self.owned.text2.text.text = count

	local _type2State = itemType == Enum.ItemType.Equip or itemType == Enum.ItemType.Card or itemType == Enum.ItemType.FashionPaper;
	self.type2:SetActive(_type2State)
	self.type2.text1.uILocalizeScript:SetContent('Position')
	local _type3State = (itemType == Enum.ItemType.Gift or itemType == Enum.ItemType.Income or itemType == Enum.ItemType.OptionalGift)
	self.type3:SetActive(_type3State)
	local _type4State = itemType == Enum.ItemType.FashionPaper
	self.type4:SetActive(_type4State)
	local _type5State = itemType == Enum.ItemType.HeadFrame;
	self.type5:SetActive(_type5State);

	if itemType == Enum.ItemType.Equip then
		self.type2.text2.text.text = I18N.T(Enum.EquipTypeName[cfgData.Type])
	elseif itemType == Enum.ItemType.Card then
		self.type2.text2.text.text = I18N.T(Enum.EquipTypeName[cfgData.CardLocation])
	elseif itemType == Enum.ItemType.FashionPaper then
		local fashionData = ManagerContainer.CfgMgr:GetFashionById(cfgData.FashionId)
		self:RefreshJobOnly(fashionData.FashionUseJob)
		self.type2.text2.text.text = I18N.T('FashionSlot_' .. fashionData.FashionLocation)
	elseif itemType == Enum.ItemType.Gift or itemType == Enum.ItemType.Compose or itemType == Enum.ItemType.Income or itemType == Enum.ItemType.OptionalGift then
		local _enough, _needLevel, _level = self:JudgeItemNeedLevel(itemCfgData)
		if _needLevel <= 0 then
			self.type3:SetActive(false)
		else
			self.type3.text2.text.text = tostring(_needLevel);
			if not _enough then
				CommonUtil.SetTextColor(self.type3.text2.text, Constant.RedColorText)
			end
		end
	elseif itemType == Enum.ItemType.HeadFrame then
		local _timeStamp = itemCfgData.ComposeItem
		if _timeStamp then
			if _timeStamp[1][2] == nil or _timeStamp[1][2] <= 0 then
				self.type5.text2.text.text = I18N.T("Forever");
			else
				local _timeStr = "";
				local _timeSecond = _timeStamp[1][2] * 3600;
				if _timeSecond >= 60 and _timeSecond < Constant.OneDaySeconds then
					_timeStr = DateTimeUtil.convertSeconds2TimeStr1(_timeSecond, true, false, false);
				else
					_timeStr = DateTimeUtil.convertSeconds2TimeStr1(_timeSecond, false, false, false);
				end
				self.type5.text2.text.text = _timeStr;
			end
		end
	end

	self.skillTag:SetActive(false)
	self.box.itemNumber:SetActive(self.controller:GetisExchangeItem())
	if self.controller:GetisExchangeItem() then
		local itemcfg = ManagerContainer.CfgMgr:GetItemById(self.controller:GetTargetCfgId())
		if itemcfg then
			CommonUtil.LoadIcon(self, itemcfg.Icon , function (sprite)
				self.box.itemNumber.icon.image.sprite = sprite
			end)
		end
	end
	self:RefreshBaseAttrs(itemType, cfgData)
	self:RefreshMakeMaterials()

	self.slider.slider.maxValue = self.controller:GetMaxExchangeCount();
	self.slider.slider.value = 1
	self:RefreshSliderBoxNum()
	self.txtdsc.uILocalizeScript:SetContentAndValues("DscExchangeNum", {self.controller:GetMaxExchangeCount()})
end

function UITipsExchangeView:JudgeItemNeedLevel(_itemCfg)
	local _needLevel = _itemCfg.NeedLevel or 0;
	local _level = ManagerContainer.DataMgr.UserData:GetRoleLv();
	return _needLevel <= _level, _needLevel, _level;
end

function UITipsExchangeView:GetCfgDataAndType(cfgId,resType,composeItem)
	local cfgData = nil
	if resType == Enum.ItemType.Equip then
		cfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
		if cfgData ~= nil then
			return cfgData
		end
	end

	if resType == Enum.ItemType.Card then
		cfgData = ManagerContainer.CfgMgr:GetCardDataById(cfgId)
		if cfgData ~= nil then
			return cfgData
		end
	end

	if resType == Enum.ItemType.Parter then
		cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(cfgId)
		if cfgData ~= nil then
			return cfgData
		end
	end

	if resType == Enum.ItemType.FashionPaper then
		cfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
		if cfgData ~= nil then
			return cfgData
		end
	end

	if resType == Enum.ItemType.Pet then
		cfgData = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
		if cfgData ~= nil then
			return cfgData
		end
	end

	if resType == Enum.ItemType.HeadFrame then
		if composeItem ~= nil and #composeItem > 0 and #composeItem[1] > 0 then
			cfgData = ManagerContainer.CfgMgr:GetHeadFrameById(composeItem[1][1])
			return cfgData
		end
	end

	return nil
end

function UITipsExchangeView:RefreshBaseAttrs(itemType, cfgData)
	local needBase = itemType == Enum.ItemType.Equip
			or itemType == Enum.ItemType.Card
			or itemType == Enum.ItemType.FashionPaper
			or itemType == Enum.ItemType.HeadFrame

	self.baseAttr:SetActive(needBase)
	if needBase then
		if itemType == Enum.ItemType.Equip then
			local baseAttrs = {}
			for k,v in pairs(Enum.HeroAttrType) do
				if cfgData[k] and cfgData[k] ~= 0 then
					table.insert(baseAttrs, {Enum.HeroAttrType[k], cfgData[k]})
				end
			end
			local index = 0
			for k, v in pairs(baseAttrs) do
				index = index + 1
				CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
			end
		elseif itemType == Enum.ItemType.Card then
			local index = 0
			for _,v in pairs(CommonUtil.DeserializeCfgItemList(cfgData.Attribute1)) do
				index = index + 1
				CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
			end
		elseif itemType == Enum.ItemType.FashionPaper then
			local fashionData = ManagerContainer.CfgMgr:GetFashionById(cfgData.FashionId)
			local fashionAttrs = fashionData.FashionAttr
			-- 一条属性的时候
			if type(fashionAttrs[1]) == 'number' then
				fashionAttrs = {fashionAttrs}
			end
			local index = 0
			for _,v in pairs(fashionAttrs) do
				index = index + 1
				CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
			end
		elseif itemType == Enum.ItemType.HeadFrame then
			local baseAttrs = {}
			local _Attrs = cfgData.HeadFrameQuality;
			if _Attrs then
				for _k, _v in pairs(_Attrs) do
					if _v[1] and _v[2] then
						table.insert(baseAttrs, {_v[1],_v[2]});
					end
				end
				local index = 0
				for k, v in pairs(baseAttrs) do
					index = index + 1
					CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
				end
			end
		end
	end
end

function UITipsExchangeView:RefreshMakeMaterials(itemType)
	local cfgId = self.controller:GetCfgId()
	local needCost = itemType == Enum.ItemType.FashionPaper
	self.costMaterials:SetActive(needCost)
	if needCost then
		if itemType == Enum.ItemType.FashionPaper then
			local cfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
			local makeMaterial = clone(cfgData.MakeMaterial)
			if type(makeMaterial[1]) == 'number' then
				makeMaterial = {makeMaterial}
			end
			local num = #makeMaterial
			local materialCfgId = nil
			local materialNum = nil
			local moneyCfgId = nil
			local moneyNum = nil
			for i = num, 1, -1 do
				materialCfgId = makeMaterial[i][1]
				materialNum = makeMaterial[i][2]
				local materialItemCfgData = ManagerContainer.CfgMgr:GetItemById(materialCfgId)
				if materialItemCfgData.ResType == Enum.ItemType.Coin
						or materialItemCfgData.ResType == Enum.ItemType.Diamond then
					moneyCfgId = materialCfgId
					moneyNum = materialNum
					-- 移除一个货币显示到列表，会单独显示
					table.remove(makeMaterial, i)
					break
				end
			end
			num = #makeMaterial
			if num > 4 then num = 4 end
			local index = 0
			for _,v in pairs(makeMaterial) do
				index = index + 1
				CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.costMaterials.grid.transform, v, index, Enum.ItemIEnterType.CostMat)
			end
			return
		end
	end
end

function UITipsExchangeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UITipsExchangeView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnClose.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnExchange.button,self, self.OnExchangeClick)

	self.uiBase:AddButtonEventListener(self.btnMinus.button, self, self.MinusFun);
	self.uiBase:AddButtonEventListener(self.btnPlus.button, self, self.PlusFun);
	self.uiBase:AddSliderUniqueEventListener(self.slider.slider, self, self.OnSliderValueChanged, nil)
end

function UITipsExchangeView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

--点击减少按钮
function UITipsExchangeView:MinusFun()
	self.controller:RefreshSelectedCount(-1)
	self:RefreshSliderBoxNum(true);
end
--点击增加按钮
function UITipsExchangeView:PlusFun()
	self.controller:RefreshSelectedCount(1)
	self:RefreshSliderBoxNum(true);
end

--滑动条的数值有改变的时候
function UITipsExchangeView:OnSliderValueChanged(slider, value)
	if value == 0 then
		value = 1
		self.slider.slider.value = value;
	end
	local selectedCount = value
	self.controller:SetSelectedCount(selectedCount)
	self:RefreshSliderBoxNum(false);
end

function UITipsExchangeView:RefreshSliderBoxNum(needChangeSlider)
	local selectedCount = self.controller:GetSelectedCount()
	if needChangeSlider then
		self.slider.slider.value = selectedCount;
	end
	local maxCount = self.controller:GetMaxExchangeCount()
	if self.controller:GetisExchangeItem() then
		if self.controller:GetisSetColor() then 
			self.box.itemNumber.number.text.text = string.format(Constant.RedColorText, selectedCount *  self.controller:GetRadio())
		else
			self.box.itemNumber.number.text.text = selectedCount * self.controller:GetRadio()
		end
		self.box.numBox.num.text.text = selectedCount
	else
		self.box.numBox.num.text.text = selectedCount .."/"..maxCount
	end
end

function UITipsExchangeView:OnExchangeClick()
	self.controller:OnExchangeClick()
	self:OnClickCloseBtn()
end

function UITipsExchangeView:OnHide()

end

function UITipsExchangeView:OnShow(data)
	self.controller:SetData(data)

end

function UITipsExchangeView:OnClose()
end

function UITipsExchangeView:OnDispose()
	self.controller:OnDispose()
end

return UITipsExchangeView

