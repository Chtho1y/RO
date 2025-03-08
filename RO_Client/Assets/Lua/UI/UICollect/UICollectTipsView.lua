local UICollectTipsView = require("UICollect/UICollectTipsView_Generate")
local BitUtil = require("BitUtil")
local IconItemCtr = require("Common/IconItemCtr")

function UICollectTipsView:OnAwake(data)
	self.controller = require("UICollect/UICollectTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICollectTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_HANDBOOK_REWARD_REFRESH, function()
		self:RefreshCardReward()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_HANDBOOK_REWARD_REFRESH, function()
		self:RefreshPetReward()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARD_HANDBOOK_RANK_REFRESH, function(playerInfo, time)
		self:RefreshFirstRank(playerInfo, time)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.KEEPSAKE_LEVEL_UP_SUCCESS_NTF, function()
		local keepSakeId = self.controller:GetCfgId()
		local lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(keepSakeId)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("ObjectActivated", lv)
		self:Init()
	end)
end

function UICollectTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICollectTipsView:Init()
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, self.collectionAttrItem.prefabName)
	self.btnUse.toggle.isOn = false

	self.type = self.controller:GetType()
	self.cfgId = self.controller:GetCfgId()

	self.bottom.head:SetActive(false)
	self.bottom.label:SetActive(false)
	self.bottom.info:SetActive(false)

	self.type1:SetActive(self.type == Enum.CollectType.Pet)
	self.skillBox:SetActive(self.type == Enum.CollectType.Pet)
	self.type2:SetActive(self.type == Enum.CollectType.Card)
	self.type4:SetActive(self.type == Enum.CollectType.Card)

	self.type3:SetActive(self.type == Enum.CollectType.KeepSake)
	self.type51:SetActive(false)
	self.type52:SetActive(false)
	self.type53:SetActive(false)

	self.cardIconBigItem:SetActive(self.type == Enum.CollectType.Card)
	self.petIcon:SetActive(self.type == Enum.CollectType.Pet)
	self.collectionIconItem:SetActive(self.type == Enum.CollectType.KeepSake)

	self.baseAttr:SetActive(self.type ~= Enum.CollectType.KeepSake)
	self.dscSkill:SetActive(self.type == Enum.CollectType.Pet)

	self.rewards:SetActive(self.type ~= Enum.CollectType.KeepSake)
	self.collectionAttr:SetActive(self.type == Enum.CollectType.KeepSake)
	self.collectionUpdate:SetActive(self.type == Enum.CollectType.KeepSake)
	self.dscContent.transform.localPosition = Vector3.zero

	CommonUtil.DisposeBatchGridChildsItem(self, self.baseAttr.grid.transform, self.attrItem.prefabName)

	self.baseAttr.text.uILocalizeScript:SetContent("BasicNature")

	if self.type == Enum.CollectType.Card then
		self:RefreshCardInfo()
	elseif self.type == Enum.CollectType.Pet then
		self:RefreshPetInfo()
	elseif self.type == Enum.CollectType.KeepSake then
		self:RefreshKeepSakeInfo()
	end
end

function UICollectTipsView:RefreshCardInfo()
	local cardId = self.controller:GetCfgId()
	ManagerContainer.DataMgr.CollectionBookData:QueryCardRank(cardId)

	local cfgData = ManagerContainer.CfgMgr:GetCardIdentificationDatasById(cardId)
	if not cfgData then
		return
	end

	self.textName.text.text = I18N.T(cfgData.CardName)

	CommonUtil.LoadIcon(self, cfgData.CardImg, function (sprite)
		self.iconCard.image.sprite = sprite
	end)

	local frameIcon = Constant.Quality_Frame_Icons[cfgData.FrameQuality]
	CommonUtil.LoadIcon(self, frameIcon, function (sprite)
		self.frame.image.sprite = sprite
	end)

	CommonUtil.LoadIcon(self, Constant.Quality_CardType_Icons[cfgData.CardQuality], function (sprite)
		self.cardLabel.image.sprite = sprite
	end)

	self.type2.text2.text.text = I18N.T(Enum.EquipTypeName[cfgData.CardLocation])

	for i = 1, self.type4.jobBox.transform.childCount do
		self.type4.jobBox.transform:GetChild(i - 1).gameObject:SetActive(false)
	end

	if cfgData.Profession then
		for i = 1,#cfgData.Profession do
			local icon
			if self.type4.jobBox.transform.childCount >= i then
				icon = self.type4.jobBox.transform:GetChild(i - 1)
			else
				icon = UnityEngine.GameObject.Instantiate(self.type4.icon).transform
				if icon then
					icon:SetParent(self.type4.jobBox.transform)
					icon.localPosition = Vector3.zero
					icon.localRotation = Quaternion.identity
					icon.localScale = Vector3.one
				end
			end
			if icon then
				icon.gameObject:SetActive(true)
				CommonUtil.LoadIcon(self, Constant.Hero_Job_Icons[cfgData.Profession[i]], function (sprite)
					local image = icon:GetComponent(Enum.TypeInfo.Image)
					image.sprite = sprite
				end, self, 'IconJob'..i)
			end
		end
	end

	local index = 0
	for _,v in pairs(CommonUtil.DeserializeCfgItemList(cfgData.Attribute1)) do
		index = index + 1
		CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
	end

	self.desTxt.text.text = I18N.T(cfgData.CardDescribe)

	self:RefreshCardReward()
end

function UICollectTipsView:RefreshPetInfo()
	local petId = self.controller:GetCfgId()
	ManagerContainer.DataMgr.PetDataMgr:QueryFirstRank(petId)

	local cfgData = ManagerContainer.CfgMgr:GetPetDataById(petId)
	if not cfgData then
		return
	end

	self.textName.text.text = I18N.T(cfgData.Name)

	CommonUtil.LoadIcon(self, Constant.Natural_Icons..cfgData.NatureType, function (sprite)
		self.type1.icon.image.sprite = sprite
	end)

	CommonUtil.LoadIcon(self, cfgData.Petimg, function (sprite)
		self.petIcon.npc1.image.sprite = sprite
	end)
	if cfgData.IconOffset then
		self.petIcon.npc1.rectTransform.anchoredPosition = Vector2(cfgData.IconOffset[1], cfgData.IconOffset[2])
	end

	for i = 1, 3 do
		local skillId = cfgData["Skill"..i]
		local item = self.skillView["skillItem"..i]
		item:SetActive(skillId > 0)
		if skillId > 0 then
			local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'SkillItem', item.gameObject)
			CommonUtil.SetCommonSkillItem(self, itemlua, skillId, 1, self.OnSkillClick, skillId, i)
		end
	end
	self:OnSkillClick1(cfgData.Skill1, 1)
	local attrs = {}
	attrs[1] = {Enum.HeroAttrType.Life, cfgData.Hp}
	attrs[2] = {Enum.HeroAttrType.Sp, cfgData.Sp}
	attrs[3] = {Enum.HeroAttrType.Attack, cfgData.Atk}
	attrs[4] = {Enum.HeroAttrType.MagicAttack, cfgData.Matk}

	local index = 0
	for _,v in pairs(attrs) do
		index = index + 1
		CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
	end

	self.desTxt.text.text = I18N.T(cfgData.Desc)

	self:RefreshPetReward()
end

function UICollectTipsView:RefreshKeepSakeInfo()
	local keepSakeId = self.controller:GetCfgId()
	ManagerContainer.DataMgr.KeepSakeBookData:QueryKeepSakeRank(keepSakeId)
	self.controller:ResetKeepSakeMaterialCount()

	local lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(keepSakeId)
	local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(keepSakeId)
	if not cfgData then
		return
	end

	CommonUtil.SetTotalChildrenGray(self.collectionIconItem, lv == nil and not ManagerContainer.DataMgr.KeepSakeBookData:CanKeepSakeLvUp(keepSakeId))

	self.textName.text.text = I18N.T(cfgData.Name)

	local jobs = cfgData.Job
	for i = 1, #jobs do
		local type = self["type5"..i]
		if type then
			type:SetActive(true)
			local jobId = jobs[i]
			local name = ""
			local jobIcon = ""
			if jobId == 0 then
				jobId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
				local jobData = ManagerContainer.CfgMgr:GetJobDataById(jobId)
				jobIcon = jobData.JobIcon
				name = ManagerContainer.DataMgr.UserData:GetUserNickname()
			else
				local partnerData = ManagerContainer.CfgMgr:GetPartnerDataByJobId(jobId)
				if partnerData then
					name = I18N.T(partnerData.Name)
					jobIcon = partnerData.JobIcon
				end
			end
			CommonUtil.LoadIcon(self, jobIcon, function (sprite)
				type.icon.image.sprite = sprite
			end, tolua.getpeer(type), "jobIcon")
			type.text2.text.text = name
		end
	end

	CommonUtil.LoadIcon(self, cfgData.CollectionImg, function (sprite)
		self.iconCollection.image.sprite = sprite
	end)

	local frameIcon = Constant.Quality_CardBg_Icons[cfgData.CollectionLevel]
	CommonUtil.LoadIcon(self, frameIcon, function (sprite)
		self.frameCollection.image.sprite = sprite
	end)

	CommonUtil.LoadIcon(self, Constant.Quality_CardType_Icons[cfgData.CollectionLevel - 1], function (sprite)
		self.labelCollection.image.sprite = sprite
	end)

	CommonUtil.LoadIcon(self, Constant.Quality_Equip_LV_Icons[lv or 1], function (sprite)
		self.levelCollection.image.sprite = sprite
	end)

	local curLv = lv or 0
	local nextLv = curLv + 1

	self.collectionAttr:SetActive(curLv < cfgData.MaterialMaxLevel)
	self.collectionUpdate:SetActive(curLv < cfgData.MaterialMaxLevel)
	if curLv < cfgData.MaterialMaxLevel then
		self.collectionAttr.currentBox.text.uILocalizeScript:SetContentAndValues("CollectionAttribute", {curLv.."/"..cfgData.MaterialMaxLevel})
		self.collectionAttr.nextBox.text.uILocalizeScript:SetContentAndValues("CollectionAttributeNext", {nextLv > cfgData.MaterialMaxLevel and "" or (nextLv.."/"..cfgData.MaterialMaxLevel)})

		if curLv == 0 then
			ManagerContainer.GoPoolMgr:SpawnGoNewLuaTotalPath("Assets/Content/Prefabs/UI/UICollect", self.collectionAttrItem, function (itemlua)
				itemlua.transform:SetParent(self.collectionAttr.currentBox.grid.transform, false)
				itemlua.transform.localScale = Vector3.one
				itemlua.nameText.text.text = I18N.T("ObjectNotActivate")
				itemlua.numberText.text.text = ""
				CommonUtil.AddBatchItemsByItemlua(self, itemlua)
			end)
		else
			local attrs = cfgData["AddAttrLevel"..curLv]
			for i = 1,#attrs do
				ManagerContainer.GoPoolMgr:SpawnGoNewLuaTotalPath("Assets/Content/Prefabs/UI/UICollect", self.collectionAttrItem, function (itemlua)
					itemlua.transform:SetParent(self.collectionAttr.currentBox.grid.transform, false)
					itemlua.transform.localScale = Vector3.one

					local attrId = attrs[i][1]
					local val1 = attrs[i][2]
					itemlua.nameText.text.text = I18N.T("Attr_" .. attrId)
					local attrValue = attrId > 21 and CommonUtil.GetPreciseDecimal(val1*0.0001, 3) or math.floor(val1)
					itemlua.numberText.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrValue, true)

					CommonUtil.AddBatchItemsByItemlua(self, itemlua)
				end)
			end
		end

		if curLv < cfgData.MaterialMaxLevel then
			local attrs = cfgData["AddAttrLevel"..nextLv]
			for i = 1,#attrs do
				ManagerContainer.GoPoolMgr:SpawnGoNewLuaTotalPath("Assets/Content/Prefabs/UI/UICollect", self.collectionAttrItem, function (itemlua)
					itemlua.transform:SetParent(self.collectionAttr.nextBox.grid.transform, false)
					itemlua.transform.localScale = Vector3.one

					local attrId = attrs[i][1]
					local val1 = attrs[i][2]
					itemlua.nameText.text.text = I18N.T("Attr_" .. attrId)
					CommonUtil.SetTextColor(itemlua.nameText.text, Constant.GreenColorText)
					local attrValue = attrId > 21 and CommonUtil.GetPreciseDecimal(val1*0.0001, 3) or math.floor(val1)
					itemlua.numberText.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrValue, true)
					CommonUtil.SetTextColor(itemlua.numberText.text, Constant.GreenColorText)

					CommonUtil.AddBatchItemsByItemlua(self, itemlua)
				end)
			end
		end

		self:RefreshKeepSakeMaterials()
		self.baseAttr:SetActive(false)
	else
		self.baseAttr:SetActive(true)
		self.baseAttr.text.text.text = self.baseAttr.text.text.text .. I18N.T("ObjectFullLevel")
		local attrs = cfgData["AddAttrLevel"..curLv]
		local index = 0
		for _,v in pairs(attrs) do
			index = index + 1
			CommonUtil.BatchCreateItemsLoopWithMould(self, self.attrItem, self.baseAttr.grid.transform, v, index, Enum.ItemIEnterType.Attr)
		end
	end
	self.desTxt.text.text = I18N.T(cfgData.Describe)
end

function UICollectTipsView:RefreshKeepSakeMaterials()
	local keepSakeId = self.controller:GetCfgId()

	local lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(keepSakeId)
	local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(keepSakeId)
	if not cfgData then
		return
	end

	local curLv = lv or 0
	local nextLv = curLv + 1
	local materials = cfgData["MaterialLevel"..nextLv]
	if materials then
		for i = 1, 3 do
			local material = materials[i]
			self["item"..i]:SetActive(material ~= nil)
			if material then
				local data = {cfgId = material[1], num = 0}
				IconItemCtr:SetData(self, self["item"..i].iconSmallItem, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)

				local ownCount = self.controller:GetDisplayMats(material[1])
				ownCount = ownCount < material[2] and string.format(Constant.RedColorText, ownCount) or ownCount
				self["item"..i].numcost.text.text = ownCount.."/"..material[2]
			end
		end
	end

	self.exchangeCard.text.text.text = self.controller:GetOwnedKeepSakeExchange()
end

function UICollectTipsView:OnSkillClick(button, params)
	local skillId = params[0]
	local idx = params[1]

	self:OnSkillClick1(skillId, idx)
end

function UICollectTipsView:OnSkillClick1(skillId, idx)
	for i = 1, 3 do
		self["arrow"..i]:SetActive(false)
	end

	self["arrow"..idx]:SetActive(true)

	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(skillId)
	if skillCfgData then
		local skillLevelCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, 1)
		local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillLevelCfgId)

		self.dscSkill.skillName.text.text = I18N.T(skillCfgData.Name)
		self.dscSkill.lv.text.text = "Lv.1"
		if skillLevelCfgData.DescParam then
			if type(skillLevelCfgData.DescParam) == 'table' then
				self.dscSkill.desTxt.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(skillLevelCfgData.DescParam))
			else
				self.dscSkill.desTxt.text.text = string.formatbykey(skillLevelCfgData.Desc, skillLevelCfgData.DescParam)
			end
		else
			self.dscSkill.desTxt.text.text = string.formatbykey(skillLevelCfgData.Desc)
		end
	end
end

function UICollectTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICollectTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnArrowL.button, self, self.OnLeftClick)
	self.uiBase:AddButtonEventListener(self.btnArrowR.button, self, self.OnRightClick)

	self.uiBase:AddToggleEventListener(self.btnUse.toggle, self, self.OnAutoClick, 1)
	self.uiBase:AddButtonEventListener(self.btnActivity.button, self, self.OnActivityClick)
end

function UICollectTipsView:OnCloseClick()
	self:UIClose()
end

function UICollectTipsView:OnLeftClick()
	self.controller:GetOffsetCfgId(-1)
end

function UICollectTipsView:OnRightClick()
	self.controller:GetOffsetCfgId(1)
end

function UICollectTipsView:OnAutoClick(toggle, val, result)
	if result then
		self.controller:AutoAddKeepSakeMaterialCount()
	else
		self.controller:ResetKeepSakeMaterialCount()
	end
	self:RefreshKeepSakeMaterials()
end

function UICollectTipsView:OnActivityClick()
	self.controller:SendKeepSakeActivity()
end

function UICollectTipsView:RefreshCardReward()
	local cardId = self.controller:GetCfgId()
	local cfgData = ManagerContainer.CfgMgr:GetCardIdentificationDatasById(cardId)
	local logicData = ManagerContainer.DataMgr.CollectionBookData:GetCollectionBookDataById(cardId)
	if not cfgData then
		return
	end

	for i = 1, self.rewards.bar.transform.childCount do
		self.rewards.bar.transform:GetChild(i - 1).gameObject:SetActive(false)
	end

	for i = 1, cfgData.MaxLv do
		local barItem
		if self.rewards.bar.transform.childCount >= i then
			barItem = self.rewards.bar.transform:GetChild(i - 1)
		else
			barItem = UnityEngine.GameObject.Instantiate(self.rewards.barItem).transform
			barItem.transform:SetParent(self.rewards.bar.transform)
			barItem.transform.localPosition = Vector3.zero
			barItem.transform.localScale = Vector3.one
		end

		barItem.gameObject:SetActive(true)

		local bar = barItem:Find("bar")
		local box = barItem:Find("Box")

		--local iconSmallItem = box:Find("Item/IconSmallItem")
		--local iconItemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", iconSmallItem.gameObject)

		--local data = {cfgId = reward[1], num = reward[2]}
		--IconItemCtr:SetData(self, iconItemlua, data, Enum.ItemIEnterType.Bag)
		--iconItemlua.bg.image.raycastTarget = false

		local reward = cfgData["CardReward"..i][1]
		local numText = box:Find("Item/Num"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
		numText.text = reward[2]

		local animator = box:GetComponent(Enum.TypeInfo.Animator)

		if logicData and i <= logicData.cardLevel then
			local rewarded = BitUtil.RshiftNumBandOne(logicData.rewardRec, i - 1) == 1
			animator:Play(rewarded and "BoxReceived" or "BoxAvailable")
			bar.gameObject:SetActive(true)
		else
			animator:Play("BoxNormal")
			bar.gameObject:SetActive(false)
		end
		local button = box:GetComponent(Enum.TypeInfo.Button)
		self.uiBase:AddButtonUniqueEventListener(button, self, self.OnCardBoxClick, i)

		barItem:Find("IconLv").gameObject:SetActive(true)
		barItem:Find("PetLv").gameObject:SetActive(false)
		local lvIcon = barItem:Find("IconLv"):GetComponent(Enum.TypeInfo.Image)
		CommonUtil.LoadIcon(self, Constant.Quality_Equip_LV_Icons[i], function (sprite)
			lvIcon.sprite = sprite
		end, self, 'LvIcon'..i)
	end
end

function UICollectTipsView:RefreshPetReward()
	local petId = self.controller:GetCfgId()
	local cfgData = ManagerContainer.CfgMgr:GetPetDataById(petId)
	local state, curAdvLv, owned = ManagerContainer.DataMgr.PetDataMgr:GetPetCollectRewardState(petId)

	for i = 1, self.rewards.bar.transform.childCount do
		self.rewards.bar.transform:GetChild(i - 1).gameObject:SetActive(false)
	end

	if cfgData.PetReward then
		for i = 1, #cfgData.PetReward do
			local adv = cfgData.PetReward[i][1]
			local barItem
			if self.rewards.bar.transform.childCount >= i then
				barItem = self.rewards.bar.transform:GetChild(i - 1)
			else
				barItem = UnityEngine.GameObject.Instantiate(self.rewards.barItem).transform
				barItem.transform:SetParent(self.rewards.bar.transform)
				barItem.transform.localPosition = Vector3.zero
				barItem.transform.localScale = Vector3.one
			end

			barItem.gameObject:SetActive(true)

			local bar = barItem:Find("bar")
			local box = barItem:Find("Box")

			--local iconSmallItem = box:Find("Item/IconSmallItem")
			--local iconItemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", iconSmallItem.gameObject)
			--local data = {cfgId = cfgData.PetReward[i][2], num = cfgData.PetReward[i][3]}
			--IconItemCtr:SetData(self, iconItemlua, data, Enum.ItemIEnterType.Bag)
			--iconItemlua.bg.image.raycastTarget = false

			local numText = box:Find("Item/Num"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
			numText.text = cfgData.PetReward[i][3]

			local animator = box:GetComponent(Enum.TypeInfo.Animator)

			if curAdvLv >= adv and owned then
				local rewarded = BitUtil.RshiftNumBandOne(state, adv) == 1
				animator:Play(rewarded and "BoxReceived" or "BoxAvailable")
				bar.gameObject:SetActive(true)
			else
				animator:Play("BoxNormal")
				bar.gameObject:SetActive(false)
			end
			local button = box:GetComponent(Enum.TypeInfo.Button)
			self.uiBase:AddButtonUniqueEventListener(button, self, self.OnPetBoxClick, adv)

			barItem:Find("IconLv").gameObject:SetActive(false)
			barItem:Find("PetLv").gameObject:SetActive(true)
			local text = barItem:Find("PetLv"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
			text.text = adv == 0 and I18N.T("GetPets") or "+"..adv
		end
	end
end

function UICollectTipsView:OnCardBoxClick(button, params)
	local id = self.controller:GetCfgId()
	local lv = params[0]

	local logicData = ManagerContainer.DataMgr.CollectionBookData:GetCollectionBookDataById(id)
	if logicData and lv <= logicData.cardLevel then
		local rewarded = BitUtil.RshiftNumBandOne(logicData.rewardRec, lv - 1) == 1
		if rewarded then
			return
		end
	else
		return
	end
	ManagerContainer.DataMgr.CollectionBookData:SendCardHandBookReward(id, lv)
end

function UICollectTipsView:OnPetBoxClick(button, params)
	local id = self.controller:GetCfgId()
	local state, curAdvLv, owned = ManagerContainer.DataMgr.PetDataMgr:GetPetCollectRewardState(id)
	local advMaxLv, petId = ManagerContainer.DataMgr.PetDataMgr:GetSomePetMaxAdvLvByCfgId(id)
	local adv = params[0]

	if curAdvLv >= adv and owned then
		local rewarded = BitUtil.RshiftNumBandOne(state, adv) == 1
		if rewarded then
			return
		end
	else
		return
	end

	ManagerContainer.DataMgr.PetDataMgr:SendPetReward(id, adv, petId)
end

function UICollectTipsView:RefreshFirstRank(playerInfo, time)
	self.bottom.head:SetActive(true)
	self.bottom.label:SetActive(true)
	self.bottom.info:SetActive(true)

	local playerHead = CommonUtil.GetPlayerHeadIcon(playerInfo);
	local jobData = ManagerContainer.CfgMgr:GetJobDataById(playerInfo.config_id)
	local fakerData = {ProfessionIcon = jobData.JobIcon, HeadIcon = playerHead, Level = playerInfo.level, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, self.bottom.headItem, fakerData,false, playerInfo.head_frame_id, self, self.OnPlayerClick, playerInfo.uid);

	self.bottom.nickname.text.text = CommonUtil.GetVaildNickName(playerInfo.nick_name)

	if time then
		local dateTime = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(time, '%Y/%m/%d')
		self.bottom.time.text.text = dateTime
	end
end

function UICollectTipsView:OnPlayerClick(button, params)
	local uid = params[0]

	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid);
end

function UICollectTipsView:OnItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UICollectTipsView:OnHide()

end

function UICollectTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UICollectTipsView:OnClose()
	CommonUtil.RecycleFromBatchItemsByPrefabName(self, self.collectionAttrItem.prefabName)
end

function UICollectTipsView:OnDispose()
	self.controller:OnDispose()
end

return UICollectTipsView

