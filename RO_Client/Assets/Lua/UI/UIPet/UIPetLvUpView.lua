local UIPetLvUpView = require("UIPet/UIPetLvUpView_Generate")
local PetViewSystem = require("PetViewSystem")
local PreviewSystem = require("PreviewSystem")
local ColorExtension = require("ColorExtension")
local IconItemCtr = require("Common/IconItemCtr")

local LvUpPage = {
	LvUp = 1,
	SkillUp = 2,
}

local pageToggleData = {}
local curModel = nil
local previewSystem = nil
local petViewSystem = nil

local isZenyLack = false
local isExpLack = false

local skillUpCost

local attrSortList

local SkillFxSpeedList = {0.25,0.125,0.0625,1}

local StampSlotCount = 6
local attrsShowState = false
function UIPetLvUpView:OnAwake(data)
	self.controller = require("UIPet/UIPetLvUpCtr"):new()
	self.controller:SetData(data)
	self.controller:Init(self)
end

function UIPetLvUpView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_LVUP_REFRESH_NTF, self, self.OnLvUpNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_ADVENCE_REFRESH_NTF, self, self.OnAdvenceCallBackNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_SKILLUP_REFRESH_NTF, self, self.OnSkillUpMatNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_SKILLUP_SUCCESS_NTF, self, self.OnSkillUpSuccessNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.RefreshTopOwnedRes)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_BATTLE_SUCCESS_NTF, self, self.BattleChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_STAMP_SLOT_REFRESH, self, self.OnSlotRefreshNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SIDEFIGHTPOWER_REFRESH, self, self.ShowFightPower)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FIGHTPOWER_REFRESH, self, self.ShowFightPower)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTOR_SERVER_CHANGE_ATTRS, self, self.OnAttrChange)	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_DETAIL_QUERY_SUCCESS, self, self.OnPetDetailQuerySuccess)
end

function UIPetLvUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

--同步当前面板宠物属性
function UIPetLvUpView:SyncSverPetData()
	local actorData = self.controller:GetPetActorData()
	if not actorData then
		return			
	end
	self.SyncCbId = ManagerContainer.LuaActorAttributeMgr:SyncServerActorData(actorData,function()
		self:RefreshPetTotalAttrs()
		self:RefreshAttrs()
	end
	)

end

function UIPetLvUpView:OnAttrChange(tbArrtDeffrent)
	--LogError(Inspect(tbArrtDeffrent))
	--LogError("Refresh pet Attr")
	self.controller:AttrsChanged(tbArrtDeffrent)

	self:RefreshPetTotalAttrs()
	self:RefreshAttrs()
end

function UIPetLvUpView:Init()
	self.model:SetActive(false)
	self:RefreshTopOwnedRes()
	skillUpCost = GlobalConfig.Instance:GetConfigIntValue(207)
	attrSortList = {}
	for k,v in pairs(Enum.HeroAttrType) do
		attrSortList[#attrSortList + 1] = v
	end
	table.sort(attrSortList, function (a,b)
		return a < b
	end)
end

function UIPetLvUpView:OnPetDetailQuerySuccess()
	self.model:SetActive(true)
	self:RefresPetRP()
	
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, LvUpPage.LvUp, self.OnValueChangedToggle)

    self:LoadPars()
	self:ResetPetView()
	self:CloseTotalAttr()
	self:Refresh()
	self.advenceOK:SetActive(false)
	self:SyncSverPetData()
	self:RefreshPetStamps()
end


function UIPetLvUpView:CloseTotalAttr()
	self.lvUpNode.animator:Play("MoveBoxHide")

	attrsShowState = false
	self.iconUp:SetActive(attrsShowState)
	self.iconDown:SetActive(not attrsShowState)
	self.UpDownText.uILocalizeScript:SetContent("BtnDetails")
end

function UIPetLvUpView:OnPageInEnd()
	self.controller:QueryPetDetailInfo()
	self.super.OnPageInEnd(self)
end

function UIPetLvUpView:LoadPars()
    if self.top.uIEffectCfg and not self.top.uIEffectCfg.Ready then
        self.top.uIEffectCfg:LoadEffect()
    end
    if self.skillView.uIEffectCfg and not self.skillView.uIEffectCfg.Ready then
        self.skillView.uIEffectCfg:LoadEffect()
    end
end

function UIPetLvUpView:ResetPetView()
	local petData = self.controller:GetCurPetData()
	if not petData then return end

	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	local camPos = petCfgData.CamPos or {-0.116, 2.28, 3.89}
	local camRot = petCfgData.CamRot or {12.174, 177.372, 0.085}
	if not previewSystem then
		previewSystem = PreviewSystem:new("Role", 1024, 1024)
	end
	previewSystem:SetView(Vector3(camPos[1], camPos[2], camPos[3]), Quaternion.Euler(camRot[1], camRot[2], camRot[3]))

	self:RemoveCurModel()
	self.model.rawImage.texture = previewSystem:GetRenderTexture()

	self:RefreshPetView(petData)
	local multiply = petCfgData.ConversionRate*0.0001
	self.lvUpNode.text.uILocalizeScript:SetContentAndValues("DscAttrToRole", {multiply*100})
end

function UIPetLvUpView:RemoveCurModel()
	if previewSystem and curModel ~= nil then
		curModel:SetActive(false)
		previewSystem:RemoveGo(curModel)
		petViewSystem:Recycle()

		curModel = nil
	end
end

function UIPetLvUpView:RefreshPetView(petData)
	if petData == nil then return nil end
	if not petViewSystem then
		petViewSystem = PetViewSystem:new()
	end
	return petViewSystem:RefreshView(Enum.RoleInEnvType.PetLvUp, petData.cfgId, petData.extGoesShowData, self, self.LoadModelCB)
end

function UIPetLvUpView:RefreshModleScale()
	local Scale = self.controller:GetScale()
	if nil ~= curModel then
		curModel.transform.localScale = Vector3.one * Scale
	end
end

function UIPetLvUpView:LoadModelCB(model)
	curModel = model
	if previewSystem and model ~= nil then
		previewSystem:UpdateGo(model)
	end
	curModel:SetActive(true)
	self:RefreshModleScale()
	--是否默认动作
	petViewSystem:RolePlayAni(curModel, "s_click")
end

function UIPetLvUpView:RefreshTopOwnedRes()
	local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)
	local expOwned = ManagerContainer.DataMgr.UserData:GetResById(Enum.ItemIds.PetExp) or 0
	local crystalOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.PetCrystal)

	self.currency.number.text.text = CommonUtil.FormatNumber(zenyOwned)
	self.currency1.number.text.text = CommonUtil.FormatNumber(expOwned)
	self.currency2.number.text.text = CommonUtil.FormatNumber(crystalOwned)
end

function UIPetLvUpView:Refresh()
	self:RefreshTop()
	self.baseSView.loopVerticalScrollRect:ClearCells()
	self.addSView.loopVerticalScrollRect:ClearCells()
end

function UIPetLvUpView:BattleChanged()
	self:Refresh()
	self:RefresPetRP()
	self:RefreshPetStamps()
end

function UIPetLvUpView:RefreshTop()
	local petData = self.controller:GetCurPetData()
	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	if not petCfgData then
		return
	end
	--LogError(Inspect(petData))
	self.btnGoOut:SetActive(not petData.isBattle)
	self.btnDown:SetActive(petData.isBattle)

	self.info.petName.text.text = petData.advanceLevel > 0 and I18N.T(petCfgData.Name).."+"..petData.advanceLevel or I18N.T(petCfgData.Name)

	self.stampSlots.battleInfo:SetActive(petData.heroId > 0)
	if petData.heroId > 0 then
		local content
		if petData.heroId == 1 then
			content = ManagerContainer.DataMgr.UserData:GetUserNickname()
		else
			local heroData = CommonUtil.GetHeroCfgDataByUid(petData.heroId)
			content = I18N.T(heroData.Name)
		end

		self.stampSlots.battleInfo.text.uILocalizeScript:SetContentAndValues("PetBattleFollow1", {content})
	end

	self:ShowFightPower()

	self:RefreshTopSkills()
	self:InitRoleNatureIcon()
end

function UIPetLvUpView:InitRoleNatureIcon()
	local petData = self.controller:GetCurPetData()
	local cfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	local natureId = cfgData.NatureType
	local natureCfgData = ManagerContainer.CfgMgr:GetNatureDataById(natureId)
	local icon = natureCfgData.Icon

	CommonUtil.LoadIcon(self, icon, function (sprite)
		self.btnNature.icon.image.sprite = sprite
	end)
end

function UIPetLvUpView:ShowFightPower()
	local id = self.controller:GetData()
	local Power = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(id,true)
	if nil ~= Power and -1 ~= Power then
		self.fightPower.num.text.text = Power
	else
		self.fightPower.num.text.text = ManagerContainer.DataMgr.PetDataMgr:GetTotalFightPower(id)
	end
end

function UIPetLvUpView:RefreshTopSkills()
	local petData = self.controller:GetCurPetData()
	for i = 1, 3 do
		local data = petData.skillList[i]
		local item = self.skillView["skillItem"..i]
		item:SetActive(data ~= nil)
		if data then
			local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'SkillItem', item.gameObject)
			CommonUtil.SetCommonSkillItem(self, itemlua, data.cfgId, data.level, self.OnSkillClick, data)

			self["skill"..i.."Fx"].transform:SetParent(item.transform)
			self["skill"..i.."Fx"].rectTransform.anchoredPosition3D = Vector3.zero
		end
	end
end

function UIPetLvUpView:RefreshLvUpPage()
	local petData = self.controller:GetCurPetData()
	local curMaxLv = self.controller:GetCurPetMaxLv()
	self.LvNum.text.text = petData.level.."/"..curMaxLv

	CommonUtil.LoadIcon(self, Constant.Quality_CardType_Icons[petData.quality], function (sprite)
		self.LabelIcon.image.sprite = sprite
	end, self, "labelIcon")

	self:RefreshAttrs()
	self:RefreshLvUpCost()
end

function UIPetLvUpView:RefreshAttrs()
	local attrs = self.controller:GetSimpleSecondAttrs()
	if not attrs then return end

    local petData = self.controller:GetCurPetData()
    local relationAttrs = {}
    if petData.heroId == 0 then
        relationAttrs = self.controller:GetRelationAddAttrs()
    end

	local petStarIcon, textContent = CommonUtil.GetPetSkillStarIconAndColor(petData.skillList)
	CommonUtil.LoadIcon(self, petStarIcon, function (sprite)
		self.advence.image.sprite = sprite
	end)
	self.advenceLv.text.text = textContent

	local idx = 0
	for k,v in pairs(attrs) do
		idx = idx + 1
		local item = self["attrItem"..idx]
		item.text.uILocalizeScript:SetContent("Attr_" .. k)
        if k >= Enum.HeroAttrType.Life and k <= Enum.HeroAttrType.CastAcceleration then
            --v = SDataUtil.Add(v, relationAttrs[k] or 0)
        else
            if k >= Enum.HeroAttrType.Nature_None_Damage_Percent then
                v = SDataUtil.Add(v, (relationAttrs[k] and relationAttrs[k]*0.0001 or 0))
            end
        end

		item.number.text.text = CommonUtil.HeroAttrFormatValue(k, v)
	end
end

function UIPetLvUpView:RefreshLvUpCost()
	local petData = self.controller:GetCurPetData()
	local petExpData = ManagerContainer.CfgMgr:GetPetExpCfgDataById(petData.level)
	local expCost = petExpData["experience"..petData.quality] or 0
	local zenyCost = petExpData["CostMoney"..petData.quality] or 0
	if not petExpData or expCost == 0 or zenyCost == 0 then
		self.cost1:SetActive(false)
		self.cost2:SetActive(false)
		self.btnLvUp:SetActive(false)
		self.btnAdvence:SetActive(false)
		return
	end

	local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)

	local expOwned = ManagerContainer.DataMgr.UserData:GetResById(Enum.ItemIds.PetExp) or 0
	CommonUtil.IsConditionOutColor(self.cost2.num.text, expCost > expOwned, expCost)

	isZenyLack = zenyCost > zenyOwned
	isExpLack = expCost > expOwned

	local curMaxLv, isMax = self.controller:GetCurPetMaxLv()
	local maxLv = self.controller:GetPetMaxLv()

	local lvUpState = petData.level < curMaxLv
	self.btnLvUp:SetActive(lvUpState)

	local advenceState = petData.level == curMaxLv and not isMax
	if advenceState then
		local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)
		local nextAdvenceLv = petData.advanceLevel + 1
		zenyCost = petProgressCfgData.CostMoney[nextAdvenceLv]
	end
	CommonUtil.IsConditionOutColor(self.cost1.num.text, zenyCost > zenyOwned, CommonUtil.FormatNumber(zenyCost))
	self.btnAdvence:SetActive(advenceState)

	self.cost1:SetActive(zenyCost >= 0 and not advenceState)
	self.cost2:SetActive(expCost >= 0 and not advenceState)
	self.cost.advanceDsc:SetActive(advenceState)
end

function UIPetLvUpView:RefreshSkillUpPage()
	local isMax = self.controller:IsSkillMax()
	local skillMatId = self.controller:GetSkillUpMat()
	self.item.owned:SetActive(skillMatId ~= nil and not isMax)
	self.item.unowned:SetActive(skillMatId == nil and not isMax)
	if skillMatId then
		local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(skillMatId)
		if petData then
			petData.selected = 0
		end

		CommonUtil.UpdateItemPrefab(self, self.skillNode.iconPetItem, petData, Enum.ItemIEnterType.Pet, self, self.OnOpenMatUI)
	end

	self.item.max:SetActive(isMax)

	self:RefreshSkillUpCost()

	self.skillNode.number.text.text = skillMatId and "1/1" or "0/1"
	self.skillNode.btnOneKey.on:SetActive(skillMatId ~= nil)
	self.skillNode.btnOneKey.off:SetActive(skillMatId == nil)
	self.skillNode.btnOneKey.text.uILocalizeScript:SetContent(skillMatId == nil and "TextAutoChoose" or "TextAutoChoose_001")
end

local lackSkillUpCoin
function UIPetLvUpView:RefreshSkillUpCost()
	self.cost1:SetActive(true)
	self.cost2:SetActive(false)
	self.cost.advanceDsc:SetActive(false)
	local zenyCost = skillUpCost
	local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)
	lackSkillUpCoin = zenyOwned < zenyCost
	CommonUtil.IsConditionOutColor(self.cost1.num.text, zenyCost > zenyOwned, CommonUtil.FormatNumber(zenyCost))
end

function UIPetLvUpView:OnLvUpNtf()
    if self.top.uIEffectCfg then
        self.top.uIEffectCfg:HideEffect("FX_UI_ChongWuShengJi_01",self.lvFx.transform)
        self.top.uIEffectCfg:ShowEffect("FX_UI_ChongWuShengJi_01",self.lvFx.transform)
    end
	self:OnLvUpCallBackNtf()
	petViewSystem:RolePlayAni(curModel, "s_upgrade")

	if self.moreBoxAnim.activeSelf then
		self:RefreshPetTotalAttrs()
	end
end

function UIPetLvUpView:OnLvUpCallBackNtf()
	self:RefresPetRP()
	self:OnValueChangedToggle()

	if self.moreBoxAnim.activeSelf then
		self:RefreshPetTotalAttrs()
	end
end

function UIPetLvUpView:OnAdvenceCallBackNtf()
	local petData = self.controller:GetCurPetData()
	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)

	self.info.petName.text.text = petData.advanceLevel > 0 and I18N.T(petCfgData.Name).."+"..petData.advanceLevel or I18N.T(petCfgData.Name)

	if petData then
		petData.selected = 0
	end
	CommonUtil.UpdateItemPrefab(self, self.advenceOK.iconPetItem, petData, Enum.ItemIEnterType.Pet)

	self.advenceOK.iconPetItem.petName.text.text = I18N.T(petCfgData.Name)
	self.advenceOK.iconPetItem.nameBg:SetActive(true)

	local data = petProgressCfgData["Attribute"..(petData.advanceLevel)]
	if data == nil then
		LogError(logicData.configId.." 宠物进阶 "..petData.advanceLevel.."  进阶属性错误")
		return
	end

	local curMaxLv, nextMaxLv = self.controller:GetCurAdvenceMaxLv()
	--self.attrs.lVLimit.text.text.text = I18N.T("LVLimit")
	self.advenceOK.lVLimit.number1.text.text = curMaxLv
	self.advenceOK.lVLimit.number2.text.text = nextMaxLv
	self.advenceOK.lVLimit:SetActive(true)

	local petData = self.controller:GetCurPetData()
	local relationAttrs = {}
	if petData.heroId == 0 then
		relationAttrs = self.controller:GetRelationAddAttrs()
	end

	local idx = 0
	for i = 1, 5 do
		local v = data[i]
		idx = idx + 1

		local attr = self.advenceOK["attr"..idx]
		attr:SetActive(v ~= nil)

		if attr and v then
			local key = v[1]
			local val = self.controller:GetCurPetAttr(key)
			if val then
				--if key >= Enum.HeroAttrType.Life and key <= Enum.HeroAttrType.CastAcceleration then
				--	val = SDataUtil.Add(val, relationAttrs[key] or 0)
				--else
				--	if key >= Enum.HeroAttrType.STR_Percent then
				--		val = SDataUtil.Add(val, (relationAttrs[key] and relationAttrs[key]*0.0001 or 0))
				--	end
				--end
				--val = SDataUtil.InvConvert(val)
				--attr.text.text.text = I18N.T("Attr_" .. v[1])
				--attr.number1.text.text = math.floor(val - v[2])
				--attr.number2.text.text = math.floor(val)

				val = SDataUtil.InvConvert(val)
				attr.text.text.text = I18N.T("Attr_" .. v[1])
				val = key > 21 and CommonUtil.GetPreciseDecimalFloor(val, 3) or math.floor(val)
				local val1 = key > 21 and CommonUtil.GetPreciseDecimalFloor(v[2]*0.0001, 3) or math.floor(v[2])

				attr.number1.text.text = CommonUtil.HeroAttrFormatValueNoSign(key, val - val1, true)
				attr.number2.text.text = CommonUtil.HeroAttrFormatValueNoSign(key, val, true)
			end
		end
	end

	self.advenceOK:SetActive(true)
	self:OnLvUpCallBackNtf()
	self:ShowFightPower()
	petViewSystem:RolePlayAni(curModel, "s_advance")
end

function UIPetLvUpView:OnValueChangedToggle()
	self.lvUpNode:SetActive(pageToggleData.toggleDefaultIndex == LvUpPage.LvUp)
	self.skillNode:SetActive(pageToggleData.toggleDefaultIndex == LvUpPage.SkillUp)

	self.btnLvUp:SetActive(pageToggleData.toggleDefaultIndex == LvUpPage.LvUp)
	self.btnAdvence:SetActive(pageToggleData.toggleDefaultIndex == LvUpPage.LvUp)
	self.btnSkillUp:SetActive(pageToggleData.toggleDefaultIndex == LvUpPage.SkillUp)

	if pageToggleData.toggleDefaultIndex == LvUpPage.LvUp then
		self.controller:SetSkillUpMatId()
		self:RefreshLvUpPage()
	elseif pageToggleData.toggleDefaultIndex == LvUpPage.SkillUp then
		self:RefreshSkillUpPage()
	end
end

function UIPetLvUpView:OnSkillClick(button, params)
	local data = params[0]
	local petData = self.controller:GetCurPetData()
	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	local maxLimit = #petCfgData.Skill1Rate
	data = {cfgId = data.cfgId, num = data.level, isMax = data.level >= maxLimit}
	ManagerContainer.LuaUIMgr:OpenTipsSkill(data)
end

function UIPetLvUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetLvUpView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnUpDown.button, self, self.RefreshAttrsShowState)
	self.uiBase:AddButtonEventListener(self.lvUpNode.btnAttrs.button, self, self.OnPetAttrsClick, 2)
	--self.uiBase:AddButtonEventListener(self.btnLvUp.button, self, self.OnLvUpClick)
	self.uiBase:AddButtonEventListener(self.btnAdvence.button, self, self.OnAdvenceClick)
	self.uiBase:AddButtonEventListener(self.btnSkillUp.button, self, self.OnSkillUpClick)
	self.uiBase:AddButtonEventListener(self.btnLeft.button, self, self.OnLeftClick)
	self.uiBase:AddButtonEventListener(self.btnRight.button, self, self.OnRightClick)
	self.uiBase:AddButtonEventListener(self.top.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.item.unowned.icon.button, self, self.OnOpenMatUI)
	self.uiBase:AddButtonEventListener(self.btnNature.button, self, self.OnNatureDscClick)
	self.uiBase:AddButtonEventListener(self.btnGoOut.button, self, self.OnBattleClick)
	self.uiBase:AddButtonEventListener(self.btnDown.button, self, self.OnBattleDown)
	self.uiBase:AddButtonEventListener(self.btnOnekeyDown.button, self, self.OnOnekeyDown)
	self.uiBase:AddButtonEventListener(self.btnOneKeyEquip.button, self, self.OnOnekeyUp)
	self.uiBase:AddButtonEventListener(self.petBlessLv.button, self, self.OnPetBlessClick)

	self.uiBase:AddButtonEventListener(self.slot1.button, self, self.OnSlotClick, 1)
	self.uiBase:AddButtonEventListener(self.slot2.button, self, self.OnSlotClick, 2)
	self.uiBase:AddButtonEventListener(self.slot3.button, self, self.OnSlotClick, 3)
	self.uiBase:AddButtonEventListener(self.slot4.button, self, self.OnSlotClick, 4)
	self.uiBase:AddButtonEventListener(self.slot5.button, self, self.OnSlotClick, 5)
	self.uiBase:AddButtonEventListener(self.slot6.button, self, self.OnSlotClick, 6)

	self.model.uIEventTriggerListener.onDrag = function()
		local deltaX = self.model.uIEventTriggerListener.currentEventData.delta.x
		curModel.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
	end

	self.model.uIEventTriggerListener.onClick = function()
		petViewSystem:RolePlayAni(curModel, "s_click")
	end

	self.btnLvUp.repeatButton:AddRepeatClickEventListener(function (index, isOver)
		self:OnLvUpClick()
	end)

	self.uiBase:AddButtonEventListener(self.skillNode.btnOneKey.button, self, self.OnSkillAutoMatClick)
	self.uiBase:AddButtonEventListener(self.btnContract.button, self, self.OnContractClick)
end

function UIPetLvUpView:OnSkillAutoMatClick()
	if self.controller:IsSkillMax() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("539")
		return
	end

	local skillMatId = self.controller:GetSkillUpMat()
	if not skillMatId then
		self.controller:RefreshSkillMatsData()
	else
		self.controller:SetSkillUpMatId()
	end
	self:RefreshSkillUpPage()
end

function UIPetLvUpView:OnNatureDscClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINatureInfo)
end

function UIPetLvUpView:OnBattleClick()
	local petData = self.controller:GetCurPetData()
	if petData.qiyueHeroId > 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("PetContractState6")
		return
	end
	ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	local data = {curId = self.controller:GetData()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetBattle,data,self.uiData.id)
end

function UIPetLvUpView:OnBattleDown()
	self.controller:SendPetBattleDown()
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petfight_005")
end

function UIPetLvUpView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "PetText001"})
end

function UIPetLvUpView:OnOpenMatUI()
	if self.controller:IsSkillMax() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("539")
		return
	end
	local petId = self.controller:GetData()
	local skillMatId = self.controller:GetSkillUpMat()
	local data = {selfId = petId, selectedId = skillMatId, fromUIId = self.uiData.id, enterType = Enum.ItemIEnterType.PetMats}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetMats, data)
end

function UIPetLvUpView:OnSkillUpClick()
	if self.controller:IsSkillMax() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("539")
		return
	else
		local hasSkillMats = self.controller:GetSkillUpMat()
		if not hasSkillMats then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("DscChooseSillUpMet")
			return
		end
	end

	if lackSkillUpCoin then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("4")
		return
	end

	local costPetData = self.controller:GetSkillMatPetData()
	if costPetData and costPetData.isRelevant then
		local data = {"PetCostNotify8", nil, nil, self, self.PetClickSure}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
		return
	end

	if costPetData and (costPetData.level > 1 or self.controller:WasSkillUp(costPetData)) then
		local data = {"PetCostNotify4", nil, nil, self, self.PetClickSure}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
		return
	end

	self.controller:SendPetSkillUp()
end

function UIPetLvUpView:PetClickSure()
	self.controller:SendPetSkillUp()
end

function UIPetLvUpView:OnLeftClick()	
	self.controller:RefreshLeftPet()
	self.controller:SetSkillUpMatId()
	self.controller:QueryPetDetailInfo()
end

function UIPetLvUpView:OnRightClick()
	self.controller:RefreshRightPet()
	self.controller:SetSkillUpMatId()
	self.controller:QueryPetDetailInfo()
end

function UIPetLvUpView:RefreshAttrsShowState(button, params)
	attrsShowState = not attrsShowState

	self.iconUp:SetActive(attrsShowState)
	self.iconDown:SetActive(not attrsShowState)

	if attrsShowState then
		self.UpDownText.uILocalizeScript:SetContent("BtnClose")
		self.lvUpNode.animator:Play("MoreBoxUp")
		--self:RefreshPetTotalAttrs()
	else
		self.UpDownText.uILocalizeScript:SetContent("BtnDetails")
		self.lvUpNode.animator:Play("MoreBoxDown")
	end
end

function UIPetLvUpView:OnSubClose(path)
	local target = CommonUtil.ParseUITargetPath(self, path)
	if target == self.lvUpNode then
		self:RefreshPetTotalAttrs()
	else
		self.super.OnSubClose(self, path)
	end
end

function UIPetLvUpView:RefreshPetTotalAttrs()
	local actorData = self.controller:GetPetActorData()
	if not actorData then
		return
	end
	local petData = self.controller:GetCurPetData()
	local relationAttrs = {}
	if petData.heroId == 0 then
		relationAttrs = self.controller:GetRelationAddAttrs()
	end

	self.baseList = {}
	self.addList = {}
	for k,v in pairs(attrSortList) do
		if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.CastAcceleration then
			local num = actorData:GetFinalAttr(v)--SDataUtil.Add(actorData:GetFinalAttr(v), (relationAttrs[v] or 0))
			if SDataUtil.IsGreater(num, 0) then                                
				self.baseList[#self.baseList + 1] = {v, num, 0}
			end
		else
			if v >= Enum.HeroAttrType.Nature_None_Damage_Percent then
				local num = actorData:GetFinalAttr(v)
				if SDataUtil.IsGreater(num, 0) then
					self.addList[#self.addList + 1] = {v, num, 0}
				end
			end
		end
	end

	if self.baseSView.loopVerticalScrollRect.totalCount ~= #self.baseList then
		--self.baseSView.loopVerticalScrollRect:ClearCells()
		CommonUtil.LoopGridViewEleCreateNew(self, self.baseSView.loopVerticalScrollRect, self.baseSView.content.gridLayoutGroup, self.baseList, 0, nil, function (itemLua, idx)
			CommonUtil.UpdateItemPrefab(self, itemLua, self.baseList[idx + 1])
		end)
	else
		self.baseSView.loopVerticalScrollRect:RefreshCellsData()
	end

	if self.addSView.loopVerticalScrollRect.totalCount ~= #self.addList then
		--self.addSView.loopVerticalScrollRect:ClearCells()
		CommonUtil.LoopGridViewEleCreateNew(self, self.addSView.loopVerticalScrollRect, self.addSView.content.gridLayoutGroup, self.addList, 0, nil, function (itemLua, idx)
			CommonUtil.UpdateItemPrefab(self, itemLua, self.addList[idx + 1])
		end)
	else
		self.addSView.loopVerticalScrollRect:RefreshCellsData()
	end

	--if not self.attrsInited then
	--	self.baseSView.loopVerticalScrollRect:ClearCells()
	--	CommonUtil.LoopGridViewEleCreateNew(self, self.baseSView.loopVerticalScrollRect, self.baseSView.content.gridLayoutGroup, self.baseList, 0, nil, function (itemLua, idx)
	--		CommonUtil.UpdateItemPrefab(self, itemLua, self.baseList[idx + 1])
	--	end)
	--	self.addSView.loopVerticalScrollRect:ClearCells()
	--	CommonUtil.LoopGridViewEleCreateNew(self, self.addSView.loopVerticalScrollRect, self.addSView.content.gridLayoutGroup, self.addList, 0, nil, function (itemLua, idx)
	--		CommonUtil.UpdateItemPrefab(self, itemLua, self.addList[idx + 1])
	--	end)
	--else
	--	self.baseSView.loopVerticalScrollRect:RefreshCellsData()
	--	self.addSView.loopVerticalScrollRect:RefreshCellsData()
	--end

	self.addSView:SetActive(#self.addList > 0)
	self.none:SetActive(#self.addList == 0)

	self.attrsInited = true
end

function UIPetLvUpView:OnPetAttrsClick(button, params)
	local id = self.controller:GetData()
	local data = {id = id, type = params[0]}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetAttribute, data)
end

function UIPetLvUpView:OnLvUpClick()
	if isZenyLack then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petlvup_001")
		return
	end
	if isExpLack then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petlvup_002")
		return
	end
	local petData = self.controller:GetCurPetData()
	local maxLv = self.controller:GetPetMaxLv()
	if petData.level == maxLv then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petlvup_003")
		return
	end
	self.controller:SendPetLvUp()
end

function UIPetLvUpView:OnAdvenceClick()
	--local petData = self.controller:GetCurPetData()
	--local maxLv = self.controller:GetPetMaxLv()
	--if petData.level == maxLv then
	--	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petadvance_002")
	--	return
	--end

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetAdvence, self.controller:GetData())
end

function UIPetLvUpView:OnCloseClick()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIPetLvUpView:OnSkillUpMatNtf(id)
	self.controller:SetSkillUpMatId(id)	
	self:OnValueChangedToggle()
	self:RefresPetRP()
	self:RefreshModleScale()
end

function UIPetLvUpView:OnSkillUpSuccessNtf(id)
    local petData = self.controller:GetCurPetData()
    local skillCount = #petData.skillList
    if skillCount > 1 then
		ManagerContainer.LuaUIMgr:OpenInputMask(10000)
        self:SkillUpPerform(id, skillCount)
    else
        self:SkillUpResult(id)
    end
end

function UIPetLvUpView:ShowSkillUpEffect(idx)
    if self.skillView.uIEffectCfg then
        self.skillView.uIEffectCfg:HideEffect("FX_UI_LingWu_01",self["skill"..idx.."Fx"].transform)
        self.skillView.uIEffectCfg:ShowEffect("FX_UI_LingWu_01",self["skill"..idx.."Fx"].transform)
        if self.lastIdx then
            self.skillView.uIEffectCfg:HideEffect("FX_UI_LingWu_01",self["skill"..self.lastIdx.."Fx"].transform)
        end
    end
    self.lastIdx = idx
end

function UIPetLvUpView:SkillUpPerform(id, skillCount)
    local petData = self.controller:GetCurPetData()

    self.sequence = DG.Tweening.DOTween.Sequence()
    self.curIdx = 0
    self.lastIdx = nil

    self.curIdx = self.curIdx + 1
    local item = self.skillView["skillItem"..self.curIdx]
    if item then
        self:ShowSkillUpEffect(self.curIdx)
    end

    local t1 = self.transform:DOScale(1, SkillFxSpeedList[1]):SetLoops(skillCount * 3 - 1):OnStepComplete(function ()
        self.curIdx = self.curIdx + 1
        if self.curIdx > skillCount then
            self.curIdx = 1
        end
        local item = self.skillView["skillItem"..self.curIdx]
        if item then
            self:ShowSkillUpEffect(self.curIdx)
        end
    end)
    self.sequence:Append(t1)

    local t2 = self.transform:DOScale(1, SkillFxSpeedList[2]):SetDelay(SkillFxSpeedList[1] - SkillFxSpeedList[2]):SetLoops(skillCount):OnStepComplete(function ()
        self.curIdx = self.curIdx + 1
        if self.curIdx > skillCount then
            self.curIdx = 1
        end

        local item = self.skillView["skillItem"..self.curIdx]
        if item then
            self:ShowSkillUpEffect(self.curIdx)
        end
    end)
    self.sequence:Append(t2)

    local count = 1
    for i = 1, #petData.skillList do
        if petData.skillList[i].cfgId == id then
            count = i
            break
        end
    end

    local t3 = self.transform:DOScale(1, SkillFxSpeedList[3]):SetDelay(SkillFxSpeedList[2] - SkillFxSpeedList[3]):SetLoops(count):OnStepComplete(function ()
        self.curIdx = self.curIdx + 1
        if self.curIdx > skillCount then
            self.curIdx = 1
        end
        local item = self.skillView["skillItem"..self.curIdx]
        if item then
            self:ShowSkillUpEffect(self.curIdx)
        end
    end)
    self.sequence:Append(t3)

    local t4 = self.transform:DOScale(1, SkillFxSpeedList[4]):OnComplete(function ()
        for i = 1, skillCount do
            if self.skillView.uIEffectCfg then
                self.skillView.uIEffectCfg:HideEffect("FX_UI_LingWu_01",self["skill"..i.."Fx"].transform)
            end
        end
        self:SkillUpResult(id)
        self.sequence = nil
		ManagerContainer.LuaUIMgr:CloseInputMask()
    end)
    self.sequence:Append(t4)
    self.sequence:SetAutoKill(true)
end

function UIPetLvUpView:SkillUpResult(id)
	local skillId = id
	local skillData = self.controller:GetCurPetSkillData(id)
	local skillLevel = skillData.level
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(skillData.cfgId)
	local skillLevelCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLevel)
	local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillLevelCfgId)
	local skillShowData = ManagerContainer.CfgMgr:GetSkillShowCfgById(skillId)

	local itemlua = self.skillUpOK.skillItem
	CommonUtil.SetCommonSkillItem(self, itemlua, skillCfgData, skillLevel)
	self.skillUpOK.lVLimit.number1.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLevel - 1))
	self.skillUpOK.lVLimit.number2.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLevel))
	if skillCfgData then
		self.skillUpOK.textName.text.text = string.formatbykey(skillCfgData.Name)
	else
		self.skillUpOK.textName.text.text = ''
	end

	self.skillDescContent.rectTransform.anchoredPosition3D = Vector3.zero
	if skillLevelCfgData then
		self.skillUpOK.type1.text2.text.text = tostring(skillLevelCfgData.CD) .. string.formatbykey('S')
		self.skillUpOK.type2.text2.text.text = tostring(skillLevelCfgData.Cost) .. string.formatbykey('sp')
		local descParam = skillLevelCfgData.DescParam
		if descParam then
			if type(descParam) == 'table' then
				self.skillUpOK.text.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(descParam))
			else
				self.skillUpOK.text.text.text = string.formatbykey(skillLevelCfgData.Desc, descParam)
			end
		else
			self.skillUpOK.text.text.text = string.formatbykey(skillLevelCfgData.Desc)
		end
	else
		self.skillUpOK.type1.text2.text.text = '-'
		self.skillUpOK.type2.text2.text.text = '-'
		self.skillUpOK.text.text.text = ''
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
		local skillTagItem = self.skillUpOK['skillTagItem' .. i]
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

	self.skillUpOK.type1:SetActive(true)
	self.skillUpOK.type2:SetActive(true)
	self.skillUpOK.type1.text1.uILocalizeScript:SetContent('SkillCD1')
	self.skillUpOK.type2.text1.uILocalizeScript:SetContent('SkillCost')
	self.skillUpOK.type3:SetActive(false)
	self.skillUpOK.type4:SetActive(false)
	self.skillUpOK.type5:SetActive(false)

	self.skillUpOK.skillTag:SetActive(true)

	self.skillUpOK:SetActive(true)
	self:RefreshTopSkills()
	self:ShowFightPower()
	self:OnSkillUpMatNtf(nil)

	petViewSystem:RolePlayAni(curModel, "s_study")

	local petData = self.controller:GetCurPetData()
	local petStarIcon, textContent, count = CommonUtil.GetPetSkillStarIconAndColor(petData.skillList)
	CommonUtil.LoadIcon(self, petStarIcon, function (sprite)
		self.advence2.image.sprite = sprite
	end)
	self.advence2.advenceLv.text.text = textContent

	count = count - 1
	local idx = math.floor((math.max(count - 1, 0)) / 10) + 1
	local num = count % 10
	local num1 = num == 0 and 10 or num
	CommonUtil.LoadIcon(self, Constant.Pet_Star_Icons[idx], function (sprite)
		self.advence1.image.sprite = sprite
	end)
	self.advence1.advenceLv.text.text = string.format(Constant.Pet_Star_Text_Color[idx], num1)
end

function UIPetLvUpView:RefreshPetStamps()
	local petData = self.controller:GetCurPetData()
	if not petData then return end

	local slots = petData.slots
	local count = StampSlotCount
	self.controller:SetSlotCount(count)

	local canInsert = false

	local states = {}
	for i = 1, count do
		local slotItem = self["slot"..i]
		local slot = slots and slots[i] or nil
		local state = slot and (slot.stampId > 0) or false
		slotItem.inserted:SetActive(state)
		slotItem.empty:SetActive(not state)
		states[i] = slot and slot.stampId or 0
		if state then
			local stampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(slot.stampId)
			if stampData then
				IconItemCtr:SetData(self, self["stamp"..i], stampData, Enum.ItemIEnterType.Bag)
			else
				slotItem.empty:SetActive(true)
				slotItem.inserted:SetActive(false)

				local list, qualityStamp = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetAllPetStampDatasByTypeExcludeId(i)
				if qualityStamp and qualityStamp.petId == 0 then
					canInsert = true
				end
			end
		else
			local list, qualityStamp = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetAllPetStampDatasByTypeExcludeId(i)
			if qualityStamp and qualityStamp.petId == 0 then
				canInsert = true
			end
		end
		--红点
		local insertRP = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotInsertRPState(petData.id, i)
		local redpoint = self:RefreshRPShow(slotItem.rpRoot.transform, insertRP, "redpoint", "UIRedPointRP")
		if slot then
			if not insertRP then
				local lvUpRP = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotLvUpRPState(petData.id, i)
				if lvUpRP then
					redpoint.gameObject:SetActive(true)
				else
					local advanceRP = ManagerContainer.RedPointMgr.PetRPCtr:GetPetSlotAdvanceRPState(petData.id, i)
					if advanceRP then
						redpoint.gameObject:SetActive(true)
					end
				end
			end
		else
			redpoint.gameObject:SetActive(insertRP)
		end
		--处理 stone
	end

	self.btnOneKeyEquip:SetActive(canInsert)
	self.redPointItem1:SetActive(petData.isBattle and canInsert)
	self.btnOnekeyDown:SetActive(not canInsert)

	self:RefreshPetStampBless()
end

function UIPetLvUpView:RefreshPetStampBless()
	local petData = self.controller:GetCurPetData()
	local stampSuit = petData.stampSuit
	self.petBlessLv.lightGreen:SetActive(stampSuit[1] == 1)
	self.petBlessLv.lightBlue:SetActive(stampSuit[1] == 2)
	self.petBlessLv.lightPurple:SetActive(stampSuit[1] == 3)
	self.petBlessLv.lightGold:SetActive(stampSuit[1] == 4)
	self.petBlessLv.lightRed:SetActive(stampSuit[1] == 5)
	for i = 1, 6 do
		local quality = stampSuit[4][i]
		local slot = self.petBlessLv["slot"..i]
		slot:SetActive(quality ~= nil)
		if quality then
			local image = slot.image
			local slotTb = tolua.getpeer(slot)
			CommonUtil.LoadIcon(self, Constant.Pet_Stamp_Bless_Icons[quality], function (sprite)
				image.sprite = sprite
			end, slotTb, 'BlessIcon')
		end
	end
end

function UIPetLvUpView:OnOnekeyUp()
	self.controller:SendOneKeyUp()
end

function UIPetLvUpView:OnOnekeyDown()
	self.controller:SendOneKeyDown()
end

function UIPetLvUpView:OnSlotClick(button, params)
	self:CloseTotalAttr()

	local slotIdx = params[0]
	local petData = self.controller:GetCurPetData()
	local slots = petData.slots
	local slot = slots[slotIdx]
	local stampId = 0
	if slot then
		stampId = slot.stampId
	end

	local petId = self.controller:GetData()
	if stampId > 0 then
		local stampData = ManagerContainer.DataMgr.PetDataMgr.petStampData:GetPetStampDataMapById(stampId)
		if stampData then
			local data = {stampData = stampData, slotIdx = slotIdx, petId = petId}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetStampTips, data)
		end
	else
		local data = {curStamp = nil, slotIdx = slotIdx, petId = petId}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetStampList, data)
	end
end

function UIPetLvUpView:OnPetBlessClick()
	local petId = self.controller:GetData()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetStampBlessTips, petId)
end

function UIPetLvUpView:OnSlotRefreshNtf()
	self:RefreshPetStamps()
	self:Refresh()
	self:OnValueChangedToggle()
	self:RefreshTopOwnedRes()
	self:RefreshAttrs()
end

function UIPetLvUpView:RefresPetRP()
	local id = self.controller:GetData()
	ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetLvUpState(id)
	ManagerContainer.RedPointMgr.PetRPCtr:RefreshPetAdvenceState(id)
	ManagerContainer.RedPointMgr.PetRPCtr:RefreshSkillUpState(id)

	local petData = self.controller:GetCurPetData()
	self.btnContract.uIRedPointRP:SetActive(ManagerContainer.RedPointMgr.PetRPCtr:RefreshBattlePetQiyueRPState(petData))
end

function UIPetLvUpView:RefreshRPShow(parent, state, redName, redPath)
	local redP = parent:Find(redName)
	if not redP then
		redP = self:CreateNormalRedPoint(parent, redName, redPath)
	end
	redP.gameObject:SetActive(state)
	return redP
end

function UIPetLvUpView:CreateNormalRedPoint(parent, redName, redPath)
	local redPoint = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, redPath)
	if redPoint then
		redPoint.transform:SetParent(parent)
		redPoint.transform.localPosition = Vector3.zero
		redPoint.transform.localRotation = Quaternion.identity
		redPoint.transform.localScale = Vector3.one
		redPoint.name = redName
		redPoint:SetActive(true)
	end
	return redPoint.transform
end

function UIPetLvUpView:OnContractClick()
	local qiyueFunc, _, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(77)
    if not qiyueFunc then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content)
        return
    end

	local petData = self.controller:GetCurPetData()
	if petData.heroId == 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("PetContractTips1")
		return
	end
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.QIYUE_TOGGLE_JUMP_TRIGGER)
	self:UIClose()
end

function UIPetLvUpView:OnHide()
	curModel = nil

	if previewSystem then
		previewSystem:Dispose(true)
	end
	previewSystem = nil
	if petViewSystem then
		petViewSystem:Dispose()
	end
	petViewSystem = nil
end

function UIPetLvUpView:OnShow(data)
	self.controller:SetData(data)
	self:OnPetDetailQuerySuccess()
end

function UIPetLvUpView:OnClose()
	pageToggleData = nil
	ManagerContainer.LuaActorAttributeMgr:ClearCb(self.SyncCbId)
	if self.showAttrsTimer then
		self.showAttrsTimer:Stop()
		self.showAttrsTimer = nil
	end
end

function UIPetLvUpView:OnDispose()
	curModel = nil

	if previewSystem then
		previewSystem:Dispose(true)
	end
	previewSystem = nil
	if petViewSystem then
		petViewSystem:Recycle()
	end
	petViewSystem = nil

	self.model.uIEventTriggerListener.onDrag = nil
	self.model.uIEventTriggerListener.onClick = nil

	self.baseList = nil
	self.addList = nil
	self.baseSView.loopVerticalScrollRect:ClearCells()
	self.addSView.loopVerticalScrollRect:ClearCells()

    self.top.uIEffectCfg:Clean()
    self.skillView.uIEffectCfg:Clean()

	for i = 1, 3 do
		self["skill"..i.."Fx"].transform:SetParent(self.skillView.transform)
	end
    DG.Tweening.DOTween.KillAll()
    --DG.Tweening.DOTween.Kill(self.transform)
    self.sequence = nil

	self.controller:OnDispose()
end

return UIPetLvUpView

