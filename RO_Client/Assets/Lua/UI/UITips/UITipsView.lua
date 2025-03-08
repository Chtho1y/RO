local UITipsView = require("UITips/UITipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local ColorExtension = require("ColorExtension")
local TaskJumpCtr = require("Common/TaskJumpCtr")

local cfgId, state, itemCount, chosenCount, targetData, ItemOpenTime
local itemType
function UITipsView:OnAwake(data)
	self.controller = require("UITips/UITipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UITipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.RefreshMoney)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.RefreshMoney)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.RefreshItem)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LIST_CHANGE, self, self.RefreshFasionPaperOwnSign)
end

function UITipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UITipsView:Init()
	targetData = self.controller:GetData()
	if targetData.tipsType == Enum.UITipsType.Skill then
		self:InitSkill()
	else
		self:InitItem()
	end
end

function UITipsView:InitSkill()
	local skillId = targetData.cfgId
	local skillLevel = targetData.num or 0
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(Enum.SkillType.Active, skillId, skillLevel)
	local skillLevelCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLevel)
	local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillLevelCfgId)
	local skillShowData = ManagerContainer.CfgMgr:GetSkillShowCfgById(skillId)

	CommonUtil.SetTotalChildrenGray(self.iconItem.icon, false)
	self.iconItem.icon.image.sprite = nil
	CommonUtil.LoadIcon(self, skillCfgData and skillCfgData.Icon or nil, function (sprite)
        self.iconItem.icon.image.sprite = sprite
	end, self.iconItem, 'IconIcon')

	self.iconItem.frame.image.sprite = nil
	CommonUtil.LoadIcon(self, Constant.Quality_White_Frame_Icon, function (sprite)
        self.iconItem.frame.image.sprite = sprite
	end, self.iconItem, 'IconFrame')
	self.iconItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLevel))

	self.iconItem.frame.image.material = nil

	-- self.iconItem.frameLead:SetActive(false)
	self.iconItem.level:SetActive(false)
	self.iconItem.job:SetActive(false)
	self.iconItem.limited:SetActive(false)
	self.iconItem.sexLabel:SetActive(false)
	self.iconItem.cardLabel:SetActive(false)
	self.iconItem.num:SetActive(true)
	self.iconItem.refineLv:SetActive(false)
	self.iconItem.qualityFX:SetActive(false)
	self.iconItem.repeatSign:SetActive(false)
	self.iconItem.conertips:SetActive(false)
	self.iconItem.vip:SetActive(false)
	self.iconItem.redPoint:SetActive(false)

	if skillCfgData then
		self.textName.text.text = string.formatbykey(skillCfgData.Name)
	else
		self.textName.text.text = ''
	end

	if skillLevelCfgData then
		self.type1.text2.text.text = tostring(skillLevelCfgData.CD) .. string.formatbykey('S')
		self.type2.text2.text.text = tostring(skillLevelCfgData.Cost) .. string.formatbykey('sp')
		local descParam = skillLevelCfgData.DescParam
		if descParam then
			if type(descParam) == 'table' then
				self.desTxt.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(descParam))
			else
				self.desTxt.text.text = string.formatbykey(skillLevelCfgData.Desc, descParam)
			end
		else
			self.desTxt.text.text = string.formatbykey(skillLevelCfgData.Desc)
		end
	else
		self.type1.text2.text.text = '-'
		self.type2.text2.text.text = '-'
		self.desTxt.text.text = ''
	end

	local tags = nil
	local num = 0
	if skillShowData then
		tags = skillShowData.Label
		if tags then
			if type(tags[1]) == 'number' then
				tags = {tags}
			end
			num = #tags
		end
	end
	for i = 1, 4 do
		local skillTagItem = self['skillTagItem' .. i]
		if skillTagItem then
			if i <= num then
				local tagId = tags[i][1]
				local colorId = tags[i][2]
				skillTagItem:SetActive(true)
				skillTagItem.bgColorID.image.color = ColorExtension.HexStringToColor(I18N.SetLanguageValue('ColorID' .. tostring(colorId)))
				skillTagItem.textSkillID.uILocalizeScript:SetContent('SkillTagID' .. tostring(tagId))
			else
				skillTagItem:SetActive(false)
			end
		end
	end

	self.type1:SetActive(true)
	self.type2:SetActive(true)
	self.type1.text1.uILocalizeScript:SetContent('SkillCD1')
	self.type2.text1.uILocalizeScript:SetContent('SkillCost')
	self.type3:SetActive(false)
	self.type4:SetActive(false)
	self.type5:SetActive(false)
	self.type6:SetActive(false)


	self.skillTag:SetActive(true)
	self.baseAttr:SetActive(false)
	self.costMaterials:SetActive(false)
	self.btnBox:SetActive(false)
end

function UITipsView:RefreshTimer()
	if not ItemOpenTime then
		self:StopRefreshTimer()
		return
	end
	local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(ItemOpenTime)
	if remainTime > 0 then
		self.box.cD.number.text.text = I18N.SetLanguageValue("CDitemTime",DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
	else
		self.box.cD.number.text.text =  I18N.SetLanguageValue("CDitemDesc")
	end
	if not remainTime or remainTime <= 0 then
		self:StopRefreshTimer()
	else
		if self.refreshTimer then
			local validTime = nil
			if remainTime >= 86400 then
				validTime = remainTime % 3600
				if validTime == 0 then validTime = 3600 end
			elseif remainTime >= 3600 then
				validTime = remainTime % 60
				if validTime == 0 then validTime = 60 end
			else
				validTime = 1
			end
			if validTime then
				self.refreshTimer.duration = validTime
			else
				self:StopRefreshTimer()
			end
		end
	end
end

function UITipsView:StopRefreshTimer()
	if self.refreshTimer then
		self.refreshTimer:Stop()
	end
end

function UITipsView:DisposeRefreshTimer()
	self:StopRefreshTimer()
	self.refreshTimer = nil
end

function UITipsView:StartRefreshTimer()
	local timer = self.refreshTimer
	if not timer then
		timer = Timer.New(slot(self.RefreshTimer,self), 1, -1)
		self.refreshTimer = timer
	end
	if not timer.running then
		timer:Start()
	end
end

function UITipsView:InitItem()
	--targetData = {cfgId = 100001, num = 100, state = CommonUtil.Get2Powers(Enum.TipsEnterType.BaseAttr, Enum.TipsEnterType.Cost)}

	cfgId = targetData.cfgId
	state = targetData.state or 0
	itemCount = targetData.num or 0

	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if itemCfgData == nil then
		LogError("cant find "..cfgId.."  in itemcfg");
		return
	end

	local cfgData = self:GetCfgDataAndType(cfgId,itemCfgData.ResType,itemCfgData.ComposeItem)
	itemType = itemCfgData.ResType
	if cfgData == nil then
		cfgData = itemCfgData
	end

	local data1 = {cfgId = cfgId, num = itemCount, starLv = targetData.starLv}
	IconItemCtr:SetData(self, self.iconItem, data1, Enum.ItemIEnterType.Bag)

	if itemCfgData.ItemTime and itemCfgData.ItemTime == 7 then	--延时开启道具类型
		self.box.cD:SetActive(true)
		ItemOpenTime = (targetData.timeStamp + itemCfgData.ItemTimeCd) * 1000
		local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(ItemOpenTime)
		if remainTime > 0 then
			self.box.cD.number.text.text = I18N.SetLanguageValue("CDitemTime",DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, true, false))
		else
			self.box.cD.number.text.text =  I18N.SetLanguageValue("CDitemDesc")
		end
		self:StartRefreshTimer()
	else
		self.box.cD:SetActive(false)
		ItemOpenTime = nil
	end

	self.textName.text.text = I18N.T(itemCfgData.Name)
	self.type1.text1.uILocalizeScript:SetContent('Type')
	self.type1.text2.text.text = I18N.T("ItemTypeDes_"..itemType)

	local dcs = cfgData.Desc or itemCfgData.Describe
	self.desTxt.text.text = I18N.T(dcs)

	local _type2State = itemType == Enum.ItemType.Equip or itemType == Enum.ItemType.Card or itemType == Enum.ItemType.FashionPaper;
	self.type2:SetActive(_type2State)
	self.type2.text1.uILocalizeScript:SetContent('Position')
	local _type3State = (itemType == Enum.ItemType.Gift or itemType == Enum.ItemType.Income or itemType == Enum.ItemType.OptionalGift)
	self.type3:SetActive(_type3State)
	local _type4State = itemType == Enum.ItemType.FashionPaper
	self.type4:SetActive(_type4State)
	local _type5State = (itemType == Enum.ItemType.HeadFrame or (itemCfgData.ItemTime > 0 and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.ForeverItem and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.SeasonForeverItem and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.DelayOpenItem))
	self.type5:SetActive(_type5State);
	local _type6State = itemType == Enum.ItemType.PetStamp
	self.type6:SetActive(_type6State);

	if _type5State or itemType == Enum.ItemType.Income then
		self.box.btn_Open.text.text = I18N.T("BtnUse");
	else
		self.box.btn_Open.text.text = I18N.T("BtnOpen");
	end

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
	elseif itemType == Enum.ItemType.PetStamp then
		CommonUtil.LoadIcon(self, Constant.Pet_Stamp_Slot_Icons[cfgData.Type], function (sprite)
			self.type6.image.image.sprite = sprite
		end)
		self.type1:SetActive(false)
	end

	if targetData.isPreview then
		self.type5.text2.text.text = I18N.T("TimeShowTips")
	else
		if itemCfgData.ItemTime > 0 and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.ForeverItem and itemCfgData.ItemTime ~= Enum.ActivitiesItemType.SeasonForeverItem then
			if targetData.timeStamp then
				if targetData.timeStamp > 0 then
					local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
					local delta = targetData.timeStamp - curTime
					if delta <= 0 then
						self.type5.text2.text.text = I18N.T("DscSeasonResult6")
					elseif delta <= 60 then
						self.type5.text2.text.text = I18N.T("LessOneMinu")
					else
						local time = DateTimeUtil.convertSeconds2TimeStr1(delta, true, false)
						self.type5.text2.text.text = time
					end
				else
					self.type5.text2.text.text = I18N.T("Forever")
				end
			else
				self.type5.text2.text.text = "---"
			end
		end
	end

	self.skillTag:SetActive(false)

	local needBase = self:BitAnd(state, Enum.TipsEnterType.BaseAttr)
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
		elseif itemType == Enum.ItemType.PetStamp then
			local petStampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(targetData.id)
			local lv = 1
			if petStampData then
				lv = petStampData.lv
			end
			local lvCfgData = ManagerContainer.CfgMgr:GetPetEquipExpCfgDataByLvAndCfgId(lv, cfgId)
			local index = 0
			for _,v in pairs(lvCfgData.Nature) do
				index = index + 1
				CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
			end

			self.iconItem.num.text.text = I18N.SetLanguageValue("Lv")..lv
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

	self:RefreshMakeMaterials()

	local boxState = self:BitAnd(state, Enum.TipsEnterType.BtnDecompose)
			or self:BitAnd(state, Enum.TipsEnterType.BtnEquip) or self:BitAnd(state, Enum.TipsEnterType.BtnInfo)
			or self:BitAnd(state, Enum.TipsEnterType.BtnOK) or self:BitAnd(state, Enum.TipsEnterType.BtnOpen)
			or self:BitAnd(state, Enum.TipsEnterType.BtnCompose) or self:BitAnd(state, Enum.TipsEnterType.SliderBox)
			or self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition) or self:BitAnd(state, Enum.TipsEnterType.BtnInsertCard)
			or self:BitAnd(state, Enum.TipsEnterType.BtnUse) or self:BitAnd(state, Enum.TipsEnterType.BtnGoto)
			or self:BitAnd(state, Enum.TipsEnterType.ItemNumber)
	self.btnBox:SetActive(targetData.displayBtn and boxState)

	self.btn_Decompose:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnDecompose))

	local equipState = self:BitAnd(state, Enum.TipsEnterType.BtnEquip)
	local equipComposeState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(1)
	self.btn_EquipCompose:SetActive(equipState and equipComposeState)
	self.btn_Info:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnInfo))
	self.btn_OK:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnOK))
	self.btn_Open:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnOpen))
	self.btn_InsertCard:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnInsertCard))
	self.btn_Use:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnUse))
	self.btn_Goto:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnGoto))
	self:SetBoxState();
	self:SetBoxItemNumber()
	if self:BitAnd(state, Enum.TipsEnterType.SliderBox) or self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition) then
		self:SetBoxSlider();
		if self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition) then
			self:SetUseItemIcon();
		end
	end
end

-------------------宝箱相关start----------------------
--设置打开宝箱需要条件的按钮
function UITipsView:SetBoxState()
	self.box:SetActive(self:BitAnd(state, Enum.TipsEnterType.SliderBox) or self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition) or self:BitAnd(state, Enum.TipsEnterType.ItemNumber))

	local needSliderComs = self:BitAnd(state, Enum.TipsEnterType.SliderComs)
	self.btnMinus:SetActive(needSliderComs)
	self.btnPlus:SetActive(needSliderComs)
	self.boxSliderHande:SetActive(needSliderComs)
	self.slider.slider.interactable = needSliderComs

	self.box:SetActive(self:BitAnd(state, Enum.TipsEnterType.SliderBox) or self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition))
	self.box.btn_Open:SetActive(self:BitAnd(state, Enum.TipsEnterType.SliderBox) and not self:BitAnd(state, Enum.TipsEnterType.BtnBoxCompose))
	self.box.btn_Open1:SetActive(self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition))
	self.box.btn_Compose:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnBoxCompose))
end

function UITipsView:SetBoxItemNumber()
	if not self:BitAnd(state, Enum.TipsEnterType.ItemNumber) then
		self.box.itemNumber:SetActive(false)
		return
	end
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData or #itemCfgData.ComposeItem <= 0 then
		self.box.itemNumber:SetActive(false)
		return
	end
	local composeData = itemCfgData.ComposeItem[1]
	if not composeData then
		self.box.itemNumber:SetActive(false)
		return
	end
	local itemCfgData1 = ManagerContainer.CfgMgr:GetItemById(composeData[1])
	if not itemCfgData1 then
		self.box.itemNumber:SetActive(false)
		return
	end
	self.box.itemNumber:SetActive(true)
	CommonUtil.LoadIcon(self, itemCfgData1.MiniIcon, function(sprite)
		if sprite then
			self.box.itemNumber.icon.image.sprite = sprite
			self.box.itemNumber.icon.image.enabled = true
		end
	end)
	self.box.itemNumber.number.text.text = ''
end

function UITipsView:RefreshBoxItemNumber()
	if not self:BitAnd(state, Enum.TipsEnterType.ItemNumber) then
		return
	end
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData or #itemCfgData.ComposeItem <= 0 then
		return
	end
	local composeData = itemCfgData.ComposeItem[1]
	if not composeData then
		return
	end
	local itemCfgData1 = ManagerContainer.CfgMgr:GetItemById(composeData[1])
	if not itemCfgData1 then
		return
	end
	local num = tonumber(composeData[2]) * chosenCount
	if itemCfgData.ResType == Enum.ItemType.Income then
		local levelData = ManagerContainer.LuaBattleMgr:GetCurrentLevelData()
		if levelData then
			if itemCfgData1.ResType == Enum.ItemType.RoleBaseExp then
				local _rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
				num = tonumber(levelData.BaseExpOl) * num / _rewardIntervalTime
			elseif itemCfgData1.ResType == Enum.ItemType.ParterExp then
				local _rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
				num = tonumber(levelData.ParterOl) * num / _rewardIntervalTime
			elseif itemCfgData1.ResType == Enum.ItemType.Coin then
				local _rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
				num = tonumber(levelData.ZenyOl) * num / _rewardIntervalTime
			elseif itemCfgData1.ResType == Enum.ItemType.SkillExp then
				local _rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
				num = tonumber(levelData.CruiseOl) * num / _rewardIntervalTime
			end
		end
	end
	self.box.itemNumber.number.text.text = CommonUtil.FormatNumber(num)
end

--判断玩家能选中的宝箱开启的最大个数
function UITipsView:JudgeMaxCount()	--判断玩家能选中的最大数量
	local _maxCount = itemCount;
	if self:BitAnd(state, Enum.TipsEnterType.SliderBoxCondition) then
		local _itemData = ManagerContainer.CfgMgr:GetItemById(targetData.cfgId);
		local _costItem = _itemData.Costitem;
		local _costItemCount = CommonUtil.GetOwnResCountByItemId(_costItem[1][1]);
		local _canUseCount = math.floor(_costItemCount / _costItem[1][2]);
		if _canUseCount < _maxCount then
			_maxCount = _canUseCount;
		end
	end
	return _maxCount;
end

--判断是否要根据当前的滑动条的值改变选中的数量
function UITipsView:JudgeNeedChangeValue()
	local _needChange = false;
	local _changedValue = chosenCount;
	if itemCount > 0 then
		local _changedCount = self.slider.slider.value;
		if _changedCount == 0 then
			_changedCount = 1;
			self.slider.slider.value = _changedCount
		end
		if _changedCount ~= chosenCount then
			_needChange = true;
			_changedValue = _changedCount;
		end
	end
	return _needChange, _changedValue;
end

--改变选中的数量
function UITipsView:ChangeChosenCount(_up)
	if _up then	--增加一个
		local _newCount = chosenCount + 1;
		if _newCount <= itemCount then chosenCount = _newCount; end
	else
		if chosenCount > 1 then chosenCount = chosenCount - 1; end
	end
end

--刷新滑动条和选中的宝箱的数量
function UITipsView:RefreshSliderBoxNum(_needChangeSlider)
	self.box.numBox.num.text.text = tostring(chosenCount);-- .. "/" .. tostring(itemCount);
	if _needChangeSlider then
		self.slider.slider.value = chosenCount;
	end
	self:RefreshBoxNum();
	self:RefreshBoxItemNumber()
end

--刷新宝箱开启按钮，这个是只设置btn_Open1按钮的
function UITipsView:RefreshBoxNum()
	--设置btn_Open1下的开启宝箱需要道具的数量的显示
	local _itemData = ManagerContainer.CfgMgr:GetItemById(cfgId);
	if _itemData and _itemData.Costitem ~= nil and #_itemData.Costitem[1] > 0 then
		self.box.btn_Open1.num.text.text = _itemData.Costitem[1][2] * chosenCount;
	end
	local _canOpenMaxCount = self:JudgeMaxCount();
	self.box.btn_Open1.button.interactable = _canOpenMaxCount >= chosenCount;
end

--点击减少按钮
function UITipsView:MinusFun()
	self:ChangeChosenCount(false);
	self:RefreshSliderBoxNum(true);
end
--点击增加按钮
function UITipsView:PlusFun()
	self:ChangeChosenCount(true);
	self:RefreshSliderBoxNum(true);
end

--滑动条的数值有改变的时候
function UITipsView:OnSliderValueChanged(slider, value)
	local _needChange, _changedValue = self:JudgeNeedChangeValue();
	if _needChange then
		chosenCount = _changedValue;
	end
	self:RefreshSliderBoxNum(false);
end

function UITipsView:TransComposeItemCount()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not itemCfgData or not itemCfgData.Costitem then return end

	local costNum = itemCfgData.Costitem[1][2]
	itemCount = math.floor(itemCount / costNum)
end

function UITipsView:SetBoxSlider()
	if itemType == Enum.ItemType.Gift
		or itemType == Enum.ItemType.HeadFrame
		or itemType == Enum.ItemType.Income
		or itemType == Enum.ItemType.Compose then
		if itemType == Enum.ItemType.Compose then
			self:TransComposeItemCount()
		end

		local _showSlider = itemCount > 1;
		self.box.numBox:SetActive(_showSlider);
		chosenCount = itemCount;	--默认选中最大数量
		if _showSlider then
			self.uiBase:AddButtonUniqueEventListener(self.btnMinus.button, self, self.MinusFun);
			self.uiBase:AddButtonUniqueEventListener(self.btnPlus.button, self, self.PlusFun);
			self.uiBase:AddSliderUniqueEventListener(self.slider.slider, self, self.OnSliderValueChanged, nil)

			self.slider.slider.maxValue = itemCount;
			self:RefreshSliderBoxNum(true);
		else
			self:RefreshBoxNum();
			self:RefreshBoxItemNumber()
		end
	--elseif itemType == Enum.ItemType.Compose then
	--	chosenCount = itemCount
	--	self.box.numBox:SetActive(true);
	--	local cfgData = ManagerContainer.CfgMgr:GetItemById(targetData.cfgId);
	--	self.slider.slider.maxValue = cfgData.Costitem[1][2];
	--	self.box.numBox.num.text.text = chosenCount.. "/" .. cfgData.Costitem[1][2];
	--	self.slider.slider.value = chosenCount;
	end
end

--设置Btn_Open1按钮的用到的item的icon
function UITipsView:SetUseItemIcon()
	local _itemData = ManagerContainer.CfgMgr:GetItemById(targetData.cfgId);
	local _costItem = ManagerContainer.CfgMgr:GetItemById(_itemData.Costitem[1][1]);
	CommonUtil.LoadIcon(self, _costItem.Icon, function (sprite)
		self.box.btn_Open1.icon.image.sprite = sprite
	end)
end
-------------------宝箱相关end------------------------

function UITipsView:RefreshMoney()
	if itemType ~= Enum.ItemType.FashionPaper then
		return
	end
	self:RefreshMakeMaterials()
end

function UITipsView:RefreshItem()
	if itemType ~= Enum.ItemType.FashionPaper then
		return
	end
	self:RefreshMakeMaterials()
end

function UITipsView:RefreshMakeMaterials()
	local needCost = self:BitAnd(state, Enum.TipsEnterType.Cost)
	local enoughCost = true
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
				local ownCost = CommonUtil.GetOwnResCountByItemId(materialCfgId)
				if ownCost < materialNum then
					enoughCost = false
				end
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
			self:RefreshFasionPaperOwnSign()
			return
		end
	end

	self.btn_Compose:SetActive(self:BitAnd(state, Enum.TipsEnterType.BtnCompose))
	CommonUtil.SetTotalChildrenGray(self.btn_Compose, not enoughCost)
end

function UITipsView:JudgeItemNeedLevel(_itemCfg)
	local _needLevel = _itemCfg.NeedLevel or 0;
	local _level = ManagerContainer.DataMgr.UserData:GetRoleLv();
	return _needLevel <= _level, _needLevel, _level;
end

function UITipsView:BitAnd(num, lshift)
	local shiftNum = Bit.lshift (1, lshift)
	return Bit.band(num, shiftNum) == shiftNum
end

function UITipsView:GetCfgDataAndType(cfgId,resType,composeItem)
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

	if resType == Enum.ItemType.PetStamp then
		cfgData = ManagerContainer.CfgMgr:GetPetEquipCfgDataById(cfgId)
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

function UITipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UITipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickClose)

	self.uiBase:AddButtonUniqueEventListener(self.btn_Decompose.button, self, self.OnClickDecomposeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_Compose.button, self, self.OnClickComposeBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_EquipCompose.button, self, self.OnClickEquipBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_Info.button, self, self.OnClickInfoBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_OK.button, self, self.OnClickOkBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_Open.button, self, self.OnClickOpenBtn)
	self.uiBase:AddButtonUniqueEventListener(self.box.btn_Open.button, self, self.OnClickBoxOpenBtn)
	self.uiBase:AddButtonUniqueEventListener(self.box.btn_Open1.button, self, self.OnClickBoxOpenBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_InsertCard.button, self, self.OnInsertCardBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btn_Goto.button, self, self.OnGotoClick)
	self.uiBase:AddButtonUniqueEventListener(self.box.btn_Compose.button, self, self.OnComposeClick)
end

function UITipsView:OnClickClose(button, params)
	self:UIClose()
end

function UITipsView:OnInsertCardBtn(button, params)
	if self.controller:CanEquipCard() then
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardEquipList, self.controller:GetCfgId())
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CardWearTips")
		return
	end
end

function UITipsView:OnClickDecomposeBtn(button, params)
	if itemType ~= Enum.ItemType.FashionPaper then
		return
	end
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	local itemName1 = I18N.SetLanguageValue(itemCfgData.Name)
	local itemNum1 = CommonUtil.GetOwnResCountByItemId(cfgId)
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local resolveItem = fashionPaperCfgData.ResolveItem
	local content = ""
	for i = 1, #resolveItem do
		local cfgId = resolveItem[i][1]
		local num = resolveItem[i][2]
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		local quality = itemCfgData.Quality
		local name = I18N.SetLanguageValue(itemCfgData.Name)
		content = content ..string.format(Constant.ColorTextArray[quality],name.."X"..(itemNum1 * num))
		if i < #resolveItem then
			content = content .. string.format("<color=#000000>%s</color>", ",")
		end
	end

	local data = {"DecomposeFashionSure", {itemName1, itemNum1, content}, nil, self, self.SureDecomposeFashion}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UITipsView:RefreshFasionPaperOwnSign()
	if itemType ~= Enum.ItemType.FashionPaper then
		return
	end
	local fashionPaperData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local owned = ManagerContainer.DataMgr.FashionData:Contains(fashionPaperData.FashionId)
	self.btn_Compose:SetActive(not owned)
	self.btn_Decompose:SetActive(owned)
end

function UITipsView:SureDecomposeFashion()
	self.controller:SendDecomposeMsg()
	self:UIClose()
end

function UITipsView:RefreshJobOnly(jobIds)
	if not jobIds then
		self.type4:SetActive(false)
		return
	end
	local len1 = #jobIds
	if len1 <= 0 then
		self.type4:SetActive(false)
		return
	end
	local len2
	if not self.jobBoxIcons then
		self.jobBoxIcons = {}
		len2 = 0
	else
		len2 = #self.jobBoxIcons
	end
	self.type4.jobBox.icon:SetActive(false)
	local parent = self.type4.jobBox.icon.transform.parent
	for i = 1, len1 do
		local jobBoxIcon
		if i <= len2 then
			jobBoxIcon = self.jobBoxIcons[i]
		else
			jobBoxIcon = {}
			local go = CommonUtil.Instantiate(self.type4.jobBox.icon, parent)
			jobBoxIcon.go = go
			jobBoxIcon.image = go:GetComponent(Enum.TypeInfo.Image)
			self.jobBoxIcons[i] = jobBoxIcon
		end
		local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobIds[i])
		jobBoxIcon.go:SetActive(true)
		jobBoxIcon.image.enabled = false
		jobBoxIcon.image.sprite = nil
		CommonUtil.CloseUIClearAsyncSeqIds(jobBoxIcon)
		if jobCfgData then
			CommonUtil.LoadIcon(self, jobCfgData.JobIcon, function(sprite)
				jobBoxIcon.image.enabled = true
				jobBoxIcon.image.sprite = sprite
			end, jobBoxIcon, 'JobIcon')
		end
	end

	for i = len1 + 1, len2 do
		local jobBoxIcon = self.jobBoxIcons[i]
		jobBoxIcon.go:SetActive(false)
		jobBoxIcon.image.sprite = nil
	end
end

function UITipsView:DisposeJobOnly()
	if self.jobBoxIcons then
		for _, jobBoxIcon in pairs(self.jobBoxIcons) do
			CommonUtil.CloseUIClearAsyncSeqIds(jobBoxIcon)
			CommonUtil.DestroyGO(jobBoxIcon.go)
			jobBoxIcon.go = nil
			jobBoxIcon.image = nil
		end
		self.jobBoxIcons = nil
	end
end

function UITipsView:SureComposeFashion()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionCompose, {cfgId = cfgId})
	self:UIClose()
end

function UITipsView:OnClickComposeBtn(button, params)
	if itemType ~= Enum.ItemType.FashionPaper then
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionCompose, {cfgId = cfgId})
	self:UIClose()
end

function UITipsView:OnClickEquipBtn(button, params)
	--装备合成
	if itemType ~= Enum.ItemType.Equip then
		return
	end

	local forgeType = CommonUtil.GetEquipForgeTypeByCfgId(cfgId)
	local data1
	if forgeType ~= nil then
		data1 = Enum.EquipForgeType[forgeType]
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIForge1, data1)
	self:UIClose()
end

function UITipsView:OnClickInfoBtn(button, params)

end

function UITipsView:OnClickOkBtn(button, params)

end

function UITipsView:OnClickOpenBtn(button, params)
	if self:DelayItemOpenCheck() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CDitemDesc01")
		self:UIClose()
		return
	end
	local _itemData = ManagerContainer.CfgMgr:GetItemById(targetData.cfgId)
	local _enough, _needLevel, _level = self:JudgeItemNeedLevel(_itemData)
	if not _enough then
		local _text = I18N.SetLanguageValue("UseLvTips", tostring(_needLevel), _itemData.Name)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(_text)
		return
	end
	if _itemData.ResType == Enum.ItemType.OptionalGift then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIOptionalGift, {targetData.extData._id, targetData.cfgId, 1})
	end
	if _itemData.ResType == Enum.ItemType.VipProof or  _itemData.ResType == Enum.ItemType.RuneShopExploreUnlock then
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_ITEM_REQ, {
		item_id = targetData.id,
		item_num = 1,
		})
	end
	if _itemData.ResType == Enum.ItemType.WishBox  then
		ManagerContainer.DataMgr.BagData:SendWishBoxReq({id = targetData.extData._id})
	end
	if _itemData.ResType == Enum.ItemType.OptionalWishBox then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIOptionalWishBox,{targetData.extData._id,targetData.cfgId})
	end
	self:UIClose()
end

function UITipsView:OnGotoClick(button, params)
	local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not cfgData then
		return
	end
	local num = CommonUtil.GetOwnResCountByItemId(cfgId)
	local params
	if itemType == Enum.ItemType.TitleMaterial and cfgData.Resolve and #cfgData.Resolve > 0 then
		local titleCfg = ManagerContainer.CfgMgr:GetDesignationCfgById(cfgData.Resolve[1])
		if titleCfg then
			params = titleCfg.Type
			local titleData = ManagerContainer.DataMgr.TitleData:GetTitleDataByTypeAndId(titleCfg.Type,titleCfg.ID)
			if titleCfg.Time == 0 and titleData.state > 2 then --称号已激活并且不是时限道具 可以进行多余材料分解确认操作
				local data = {"TitleDecomposeTips", {cfgData.Name ,num,titleCfg.DecomposeReward * num}, {cfgId,num,titleCfg.DecomposeReward * num}, self, self.DecomposeItemClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
		end
	end

	self:UIClose()
	TaskJumpCtr:JumpBuyCfgId(cfgData.SkipInterface,params)
end

function UITipsView:DecomposeItemClickSure(data)
	local num = data[2]
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_ITEM_REQ, {item_id = targetData.id,item_num = num})
	self:UIClose()
end

function UITipsView:OnComposeClick(button, params)
	local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if not cfgData then
		return
	end

	local count = CommonUtil.GetOwnResCountByItemId(cfgId)
	if cfgData.Costitem and count < cfgData.Costitem[1][2] then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("PetCardcompound")
		return
	end

	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_ITEM_REQ, {
		item_id = targetData.id,
		item_num = chosenCount,
	})
	self:UIClose()
end

function UITipsView:DelayItemOpenCheck()
	if ItemOpenTime then
		local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(ItemOpenTime)
		if remainTime > 0 then
			return true
		else
			return false
		end
	else
		return false
	end
end

function UITipsView:OnClickBoxOpenBtn(button, params)
	if chosenCount == nil or chosenCount == 0 then
		return
	end
	if self:DelayItemOpenCheck() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CDitemDesc01")
		self:UIClose()
		return
	end
	local _itemData = ManagerContainer.CfgMgr:GetItemById(targetData.cfgId)
	if _itemData.ResType == Enum.ItemType.HeadFrame then
		local headFrameId = 0
		if  _itemData.ComposeItem ~= nil and #_itemData.ComposeItem > 0 and #_itemData.ComposeItem[1] > 0 then
			headFrameId = _itemData.ComposeItem[1][1]
		end 
		ManagerContainer.DataMgr.HeadFrameDataMgr:UseHeadFrameItem(targetData.extData._id,headFrameId,chosenCount)
	else
		local _enough, _needLevel, _level = self:JudgeItemNeedLevel(_itemData)
		if not _enough then
			local _text = I18N.SetLanguageValue("UseLvTips", tostring(_needLevel), _itemData.Name);
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(_text);
		else
			--开启宝箱
			if _itemData.ItemTime  and _itemData.ItemTime == 7 then
				ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_ITEM_REQ, {
					item_id = targetData.extData._id,
					item_num = chosenCount,
					force_item_id = true
				})
			else
				ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_ITEM_REQ, {
					item_id = targetData.extData._id,
					item_num = chosenCount,
				})
			end
		end
	end

	self:UIClose();
end

function UITipsView:OnHide()

end

function UITipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UITipsView:OnClose()

end

function UITipsView:OnDispose()
	ItemOpenTime = nil
	self:DisposeRefreshTimer()
	self:DisposeJobOnly()
end

return UITipsView

