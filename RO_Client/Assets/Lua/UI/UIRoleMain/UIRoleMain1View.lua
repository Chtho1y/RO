local UIRoleMain1View = require("UIRoleMain/UIRoleMain1View_Generate")
local IconItemCtr = require ("Common.IconItemCtr")
local RoleListItemCtr = require("Common/RoleListItemCtr")
local HeroHeadIcon = require("Common/HeroHeadIcon")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")
local RedPointItemCtr = require("Common/RedPointItemCtr")
local EquipSlotItemNewCtr = require("Common/EquipSlotItemNewCtr")
local ColorExtension = require("ColorExtension")

local attrField = {}
local oldAttrs = {}
local newAttrs = {}

local activationList
local curModel
local allEquiped = false

local isLeader = false
local partnerId
local battleData

local recruitCostId
local recruitCostNum
local animatorNames = {"Lead", "Sword", "Mage", "Priest", "Archer", "Thief"}

local lastClickLogTime
local lastClickNum

local UIRedPointRP = "UIRedPointRP"
function UIRoleMain1View:OnAwake(data)
	self.controller = require("UIRoleMain/UIRoleMain1Ctr")
	self.controller:Init(self)
	self.controller:SetData(data)

	attrField[1] = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_base_attr_id)
	attrField[2] = #ManagerContainer.CfgMgr.QualityPointCfg
end

function UIRoleMain1View:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.NICK_NAME_CREATED, self, self.RefreshUserNickName)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.USER_HEADPROTRAIT_CHANGED, self, self.RefreshUserHeadProtrait)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_ATTR_ADD_SUCCESS, function()
		--self.leadBox.btnNature.redPoint1:SetActive(ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroAttrRPStatus())
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, function()
		self:RefershOneKeyState()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_CHANGED, function()
		self:RefreshSkillSuitBtn()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ONE_KEY_EQUIP_REDPOINT_NOTICE, function()
		self:RefershOneKeyState()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_HERO_UI, function()
		self:RefreshFellowBtns()
		self:RefreshFightPower()
		self:RefreshAttrs() 
		self:RefershOneKeyState()
		self:RefreshSkillSuitBtn()
		self:RefreshCardSuitBtn()
	end)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_CARD_SUIT, function()
		self:RefreshCardSuitBtn()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_EQUIP_REFRESH, function()
		self:RefreshFellowBtns()
		self:RefreshFightPower()
		self:RefreshEquips()
		self:RefreshCardSlotRP()
		self:RefreshAttrs(true)
		self:RefreshCardSuitBtn()

		local slotIndex = self.controller:GetCurSLotIndex()
		ManagerContainer.LuaUIMgr:AttrNoticeDisplay(slotIndex)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_UI_ROLE_REDPOINT_NOTICE)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SLOT_REFINE_LV_UP_SUCCESS, function(result)
		if result == Enum.NetErrorCode.ERROR_OK then
			self:RefreshEquips()
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FIGHTPOWER_REFRESH, function()
		self:RefreshFightPower()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SIDEFIGHTPOWER_REFRESH, function()
		self:RefreshFightPower()
	end)
	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SWICH_PARTNER_VIEW, function(data)
		self.controller:SetData(data)
		self:Refresh()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_MAIN_TOP_RES_TYPE, isLeader and Enum.ItemType.Diamond or Enum.ItemType.ParterExp)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PARTNER_BATTLE_REQ_SUCCESS, function()
		--CommonUtil.SetGOLayer(curModel, Constant.DefaultLayer)
		local battleStatus = self.controller:GetBattleStatus()
		if battleStatus then
			local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.controller:GetData())
			local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PARTNER_BATTLE_CHANGE_INDEX, cfgData.ParterId)
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("Change", I18N.T(cfgData.Name))
		end

		--self.controller:SetData(battleData)
		self:Refresh()
		--self.popReplace:SetActive(false)
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PARTNER_STRENGTH_SUCCESS, function()
		self:RefreshFellowBtns()

		local logicData = self.controller:GetHeroLogicData()
		self:RefreshPartnerView(logicData.id, logicData.configId, logicData)
	end)

    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FIGHTPOWER_PARTNER_ACK, function()
        self:RefreshFightPower()
    end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_JOB_CHANGE_SUCCESS, function()

	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_POINT_NOTICE, self, self.RefreshRedPoint)

	
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PARTNER_ACTIVE_SUCCESS, function(configId)
        local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(configId)
		self.controller:SetCurOwnerIndex(logicData.post)
		self.controller:SetData(logicData.id)
		--self:Refresh()
		self:RecruitSucceed()
    end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTOR_SERVER_CHANGE_ATTRS, function(tbArrtDeffrent)
		local slotIndex = self.controller:GetCurSLotIndex()
		ManagerContainer.DataMgr.CardData:RefreshEquipedCardSuitData(slotIndex)
		if #tbArrtDeffrent < 1 then
			return
		end
		-- local slotIndex = self.controller:GetCurSLotIndex()
		if slotIndex == 1 then
			oldAttrs = ManagerContainer.DataMgr.UserData:GetLastTotalAtttrs()
			newAttrs = ManagerContainer.DataMgr.UserData:GetHeroData().attrs
		else
			oldAttrs = ManagerContainer.DataMgr.PartnerData:GetLastTotalAttrs(slotIndex)
			local list = ManagerContainer.DataMgr.PartnerData:GetPartnerDataBySlotIndex(slotIndex)
			newAttrs = list == nil and nil or list.attrs
		end		
		if nil ~= newAttrs then
			-- LogError(Inspect(newAttrs))
			-- LogError(Inspect(oldAttrs))		
			--刷新卡牌祝福等级信息
			--ManagerContainer.DataMgr.CardData:RefreshEquipedCardSuitData(slotIndex)
			--属性变化弹窗
			self:AttrChangeTipsDisplay()
		end		
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PARTNER_ACTIVE_SUCCESS_OVER, function()
		self:Refresh()
	end)

	--ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_SLOT_CHANGED,self,self.OnRefreshSkillSlot)
	--ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_PARTENR_SKILL_REFRESH,self,self.OnRefreshHeroSkill)

	-- 由服务器发起，角色刷新形象
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.FASHION_WEAR_CHANGE, self, self.RefreshDefaultRoleView)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.CARDSLOT_REDPOINT_ROLE_UI_NTF, self, self.RefreshCardSlotOpenRP)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ROLE_UI_REDPOINT_CHANGE, self, self.RefreshOtherRedPoint)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CRUISE_CHANGED, self, self.OnCruiseChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_SLOT_REFRESH, self, self.RefreshSkillEquip)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_LV_UP_REFRESH, self, self.SkillEquipSlotSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_RP_REFRESH, self, self.RefreshSkillEquipRP)
end

function UIRoleMain1View:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRoleMain1View:Init()
	self:InitRoleSystems()
	lastClickLogTime = nil
	lastClickNum = nil
	self.equipments:SetActive(false)
	self.transform:DOScale(1, 0.5):OnComplete(function ()
		self.equipments:SetActive(true)
	end)
	self:Refresh()
end

function UIRoleMain1View:InitRoleSystems()
	if not self.roleViewSystems then
		self.roleViewSystems = {}
	end
	for i = 1, 6 do
		if not self.roleViewSystems[i] then
			local roleViewSystem = RoleViewSystem:new()
			self.roleViewSystems[i] = roleViewSystem
		end
	end
end

function UIRoleMain1View:OnPageInEnd()
	self.super.OnPageInEnd(self)
end

function UIRoleMain1View:LoadModelCB(model)
	curModel = model
	if self.previewSystem and model ~= nil then
		self.previewSystem:UpdateGo(model)
	end
	curModel.transform.position = Vector3.zero
	curModel:SetActive(true)

	local logicData = self.controller:GetHeroLogicData()
	if not isLeader then
		self.roleViewSystems[logicData.id]:RolePlayAni(curModel, logicData.owned and "f_show" or "f_Injured")
	end
end

function UIRoleMain1View:OnEffectLoaded(effect)
	if self.previewSystem and effect then
		self.previewSystem:UpdateGo(effect)
	end
end

function UIRoleMain1View:OwnedHeadSelction(button, params)
	local index = params[0]
	if self.controller:GetCurOwnerIndex() == index then return end

	self.controller:SetCurOwnerIndex(index)
	self.controller:SetData(params[1])

	self.equipments:SetActive(false)
	self.equipments:SetActive(true)
	self:Refresh()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_MAIN_TOP_RES_TYPE, isLeader and Enum.ItemType.Diamond or Enum.ItemType.ParterExp)
end

function UIRoleMain1View:RefreshFellowBtns()
    --local id = self.controller:GetData()
    --local battlePower = ManagerContainer.DataMgr.UserData:GetSlotFightPower(id)
    --if battlePower == 0 then
    --    self.controller:SendFightPowerReq(id)
    --end

	local selectedIdx = self.controller:GetCurOwnerIndex()
	self.roleListAnim.animator:Play(animatorNames[selectedIdx])

	local roleId = ManagerContainer.DataMgr.UserData:GetUserRoleId()
	local logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
	local cfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
	local data = {1, logicData, cfgData}
	RoleListItemCtr:SetData(self, self["role"..1], data, self, self.OwnedHeadSelction)

	local rpState = ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroRPStatus()
	self["roleRP"..1]:SetActive(rpState ~= Enum.RedPointEnum.None)
	if rpState ~= Enum.RedPointEnum.None then
		RedPointItemCtr:SetData(self, self["roleRP"..1], rpState, Enum.HeroRPSource.HeadIcon, 1)
	end
	local partnerDatas = self.controller:GetSortedPartnerDatas()

	for k, v in pairs(partnerDatas) do
		local idx = k + 1
		local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(v.configId)
		local data = {idx, v, cfgData}
		RoleListItemCtr:SetData(self, self["role"..idx], data, self, self.OwnedHeadSelction)
		rpState = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerRPStatus(v.id)
		self["roleRP"..idx]:SetActive(rpState ~= Enum.RedPointEnum.None)
		if rpState ~= Enum.RedPointEnum.None then
			RedPointItemCtr:SetData(self, self["roleRP"..idx], rpState, Enum.HeroRPSource.HeadIcon, v.id)
		end
	end

	--for i = 2,6 do
	--	local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(i)
	--	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	--	local data = {i, logicData, cfgData}
	--	RoleListItemCtr:SetData(self, self["role"..i], data, self, self.OwnedHeadSelction, logicData ~= nil and ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerRPStatus(logicData.id) or nil)
	--end
end

--移除当前的model
function UIRoleMain1View:RemoveCurModel()
	if curModel ~= nil then
		curModel:SetActive(false)
		self.previewSystem:RemoveGo(curModel)
		for i = 1, 6 do
			self.roleViewSystems[i]:Recycle()
		end
		curModel = nil
	end
end

function UIRoleMain1View:Refresh()
	local uid = self.controller:GetData()
	if not uid then
		self.controller:SetData(1)
		uid = 1
	end
	self.recommendSkillId = nil
	self.recommendSkillType = nil

	ManagerContainer.LuaUIMgr:SetOldSlot(nil)
	self.controller:RefreshPartnersLists()

	if not self.previewSystem then
		self.previewSystem = PreviewSystem:new("Role", 512, 512)
		self.previewSystem:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
	end

	for i = 1, 6 do 
		self.roleViewSystems[i]:CancelCreate()
	end

	self:RemoveCurModel();

	local cfgData
	isLeader = self.controller:GetIsLeader()
	local logicData = self.controller:GetHeroLogicData()

	self.btnPvpSuppress:SetActive(isLeader)
	local pressValue = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
	self.btnPvpSuppress.num.text.text = pressValue
	self.leadBox:SetActive(isLeader)
	self.ptBox:SetActive(not isLeader and logicData.owned)
	self.ptBox1:SetActive(not isLeader and not logicData.owned)
	--self.btnLeft:SetActive(isLeader)
	--self.btnRight:SetActive(isLeader)
	--self.btnReplace:SetActive(logicData.owned and self.controller:GetActivationPartnerCount() > 3)

	--self.main:SetActive(isLeader)
	--self.pt:SetActive(not isLeader)

	self.leadBox.btnFashion:SetActive(isLeader)
	self.leadBox.btnTitle:SetActive(isLeader)

	self:RefreshFellowBtns()

	partnerId = nil
	if isLeader then

		--self:RefreshFellowBtns()

		cfgData = ManagerContainer.CfgMgr:GetJobDataById(ManagerContainer.DataMgr.UserData:GetJobCfgId())

		self:RefreshDefaultRoleView()
		self:RefreshUserNickName()
	else
		local logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(uid)
		cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
		partnerId = cfgData.ParterId

		--if logicData.isBattle then
		--	UIRoleListCtr:RefreshPartnersLists()
			--self:RefreshFellowBtns()
		--end

		--self.controller:NilOldSlot()
		activationList = self.controller:RefreshPartnersLists()

		self:RefreshPartnerView(uid, partnerId, logicData)
		--self.name.uILocalizeScript:SetContent(cfgData.Name)
	end

	self.model.rawImage.texture = self.previewSystem:GetRenderTexture()

	self:RefreshFightPower()

	self:RefreshEquips()
	if isLeader or logicData.owned then
		self:RefreshAttrs()
	end
	self:RereshAttrPointRP()
	self:RefreshRedPoint()
	self:RefreshOtherRedPoint()
    self:RefreshRecruit()
	self:RefreshCardSlotRP()

	self.itemGroup:SetActive(isLeader or logicData.owned)
	self.btnGroup:SetActive(isLeader or logicData.owned)
	--self:InitSkillItemGos()
	--self:RefreshSkills();

	self.btnGoOut:SetActive(not isLeader and not logicData.isBattle and logicData.owned)
	self.btnDown:SetActive(not isLeader and logicData.isBattle and logicData.owned)

	if isLeader then
		--self.leadBox.btnNature.redPoint1:SetActive(ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroAttrRPStatus())
	end

	self:RefreshOneKeyLock()

	self:InitRoleNatureIcon()
	self.btnPveBless:SetActive(cfgData and cfgData.JobStage >= 3)
	self:RefreshSkillSuitBtn()
	self:RefreshCardSuitBtn()

	self:RefreshSkillEquip()
	self.artifact:SetActive(isLeader or logicData.owned)
end

function UIRoleMain1View:InitRoleNatureIcon()
	local id = self.controller:GetData()
	local cfgData = CommonUtil.GetHeroJobCfgDataByUid(id)
	local natureId = cfgData.NatureId
	local natureCfgData = ManagerContainer.CfgMgr:GetNatureDataById(natureId)
	local icon = natureCfgData.Icon

	CommonUtil.LoadIcon(self, icon, function (sprite)
		self.btnNature.icon.image.sprite = sprite
	end)
end

function UIRoleMain1View:RefreshOneKeyLock()
	--self.btnOneKeyEquip_lock:SetActive(false)
	--self.btnOneKeyForge_lock:SetActive(not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(13))
	--self.btnOneKeyCardUp_lock:SetActive(not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(20))
	--self.btnOneKeyCardForge_lock:SetActive(not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(3))
end

function UIRoleMain1View:RefreshUserNickName()
	if not isLeader then return end
	--self.name.text.text = ManagerContainer.DataMgr.UserData:GetUserNickname()
end

function UIRoleMain1View:RefreshUserHeadProtrait()
	self:RefreshFellowBtns()
end

function UIRoleMain1View:RefreshAttrs(isNew)
	-- local logicData = self.controller:GetHeroLogicData()
    -- for _,v in pairs(Enum.HeroAttrType) do
    --     if not isNew then
    --         oldAttrs[v] = math.floor(SDataUtil.InvConvert(logicData.attrs[v] or 0))
    --     else
    --         newAttrs[v] = math.floor(SDataUtil.InvConvert(logicData.attrs[v] or 0))
    --     end
    -- end
end

function UIRoleMain1View:RefreshRecruit()
	local recruitCost = GlobalConfig.Instance:GetConfigStrValue(123)
	local cost = recruitCost:split(':')
	recruitCostId = tonumber(cost[1])
	recruitCostNum = tonumber(cost[2])

	local recruitCostOwned = CommonUtil.GetOwnResCountByItemId(recruitCostId)
	CommonUtil.SetTotalChildrenGray(self.ptBox1.btnRecruit, recruitCostOwned < recruitCostNum)

	self.ptBox1.recruitDsc:SetActive(recruitCostOwned == 0)

    local curRecruitTask = self.controller:GetCurRecruitCondDsc()
    self.ptBox1.dsc.text.text = ""
    if curRecruitTask ~= nil then
		self.ptBox1.dsc.text.text = I18N.SetLanguageValue("Healthtips_1", I18N.T(curRecruitTask))
    end

	local logicData = self.controller:GetHeroLogicData()
	local recruitRP = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerRecruitRPStatusById(logicData.id)
	self.ptBox1.btnRecruit.uIHartRP:SetActive(recruitRP == Enum.RedPointEnum.RecruitRP)
end

function UIRoleMain1View:RereshAttrPointRP()
	local id = self.controller:GetData()
	if id == 1 then
		ManagerContainer.RedPointMgr.HeroRPCtr:HeroAttrRPNotify()
	else
		ManagerContainer.RedPointMgr.HeroRPCtr:PartnerAttrRPNotify(id)
	end
end

function UIRoleMain1View:OnCruiseChanged()
	local btnSkill
	if isLeader then
		btnSkill = self.leadBox.btnSkill
	else
		btnSkill = self.ptBox.btnSkill
	end
	local heroId = self.controller:GetHeroLogicId()
	local status = ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroSkillUnlockRPStatus(heroId)
	local redPointParent = nil
	if status ~= Enum.RedPointEnum.None then
		btnSkill.redPoint1:SetActive(true)
		btnSkill.redPointRoot:SetActive(false)
	else
		btnSkill.redPoint1:SetActive(false)
		if CommonUtil.HasSkillCanUp(heroId) then
			btnSkill.redPointRoot:SetActive(true)
			redPointParent = btnSkill.redPointRoot.transform
		else
			btnSkill.redPointRoot:SetActive(false)
		end
	end
	if redPointParent then
		if redPointParent.childCount == 0 then
			self:CreateNormalRedPoint(redPointParent)
		end
	end
end

function UIRoleMain1View:RefreshRedPoint(rpType)
	if rpType == nil then
		self:OnCruiseChanged()
		return
	end
	if rpType == Enum.RedPointEnum.FashionNewRP then
		return
	elseif rpType == Enum.RedPointEnum.SkillUnlockRP then
		self:OnCruiseChanged()
	end
end

function UIRoleMain1View:CreateNormalRedPoint(parent)
	local redPoint = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, UIRedPointRP)
	if redPoint then
		redPoint.transform:SetParent(parent)
		redPoint.transform.localPosition = Vector3.zero
		redPoint.transform.localRotation = Quaternion.identity
		redPoint.transform.localScale = Vector3.one
		redPoint:SetActive(true)
	end
end

function UIRoleMain1View:RefreshOtherRedPoint()
	local natureState, tranferState, breakState, lvUpState = false,false, false, false
	local natureParent, tranferParent, breakParent, lvUpParent = nil, nil, nil, nil
	if isLeader then
		ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroAttrRPStatus()

		natureState = ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroAttrRPStatus()
		natureParent = self.leadBox.btnNature.redPointRoot.transform

		tranferState = ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroTransferRPStatus()
		tranferParent = self.leadBox.btnTransfer.redPointRoot.transform
	else
		local heroId = self.controller:GetHeroLogicId()
		natureState = ManagerContainer.RedPointMgr.HeroRPCtr:GetAttrPointRPStatus(heroId)
		natureParent = self.ptBox.btnNature.redPointRoot.transform

		tranferState = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerTransferRPStatusById(heroId)
		tranferParent = self.ptBox.btnTransfer.redPointRoot.transform

		breakState = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerStrengthRPStatusById(heroId)
		breakParent = self.ptBox.btnBreak.redPointRoot.transform

		lvUpState = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerLvUpRPStatusById(heroId)
		lvUpParent = self.ptBox.btnLvUp.redPointRoot.transform
	end

	if natureParent then
		natureParent.gameObject:SetActive(natureState)
		if natureState then
			if natureParent.childCount == 0 then
				self:CreateNormalRedPoint(natureParent)
			end
		end
	end

	if tranferParent then
		tranferParent.gameObject:SetActive(tranferState)
		if tranferState then
			if tranferParent.childCount == 0 then
				self:CreateNormalRedPoint(tranferParent)
			end
		end
	end

	if breakParent then
		breakParent.gameObject:SetActive(breakState)
		if breakState then
			if breakParent.childCount == 0 then
				self:CreateNormalRedPoint(breakParent)
			end
		end
	end

	if lvUpParent then
		lvUpParent.gameObject:SetActive(lvUpState)
		if lvUpState then
			if lvUpParent.childCount == 0 then
				self:CreateNormalRedPoint(lvUpParent)
			end
		end
	end
end

function UIRoleMain1View:RefreshCardSlotRP()
	local id = self.controller:GetData()
	local cardState = self.controller:InsertedCards()
	local emptyRP = ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotEmptyRP(id)
	self.redPointItem3:SetActive(emptyRP)
	local upRP = ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotUpRP(id)
	self.redPointItem4:SetActive(upRP)

	self.btnOneKeyCardUp:SetActive(not cardState or emptyRP)
	self.btnOnekeyCardDown:SetActive(cardState and not emptyRP)
end

function UIRoleMain1View:RefreshFightPower()	
	local logicData = self.controller:GetHeroLogicData()	
	--LogError("刷新伙伴战力"..tostring(logicData.id))
	local Power = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(logicData.id,false)
	if nil ~= Power and -1 ~= Power then		
		local TotalPower = Power
		local PetPower = ManagerContainer.DataMgr.UserData:GetAsideFighterSvrPower(logicData.battlePetId,true)
		if nil ~= PetPower and -1 ~= PetPower then
			TotalPower = TotalPower + PetPower
		end
		self.fightPower.text.text = tostring(TotalPower)
	else
		self.fightPower.text.text = ManagerContainer.DataMgr.UserData:GetSlotFightPower(logicData.id)
	end
end

function UIRoleMain1View:RefreshPress()
	local pressValue = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
	self.btnPvpSuppress.num.text.text = pressValue
end

function UIRoleMain1View:RefreshDefaultRoleView()
	if self.uiBase.IsHide then return end
	local userData = ManagerContainer.DataMgr.UserData
	local heroData = userData:GetMainRoleData()
	self:RefreshRoleView(userData:GetUserRoleId(), userData:GetViewData(), heroData.extGoesShowData)
end

function UIRoleMain1View:RefreshRoleView(roleId, viewData, extGoesShowData)
	self.roleViewSystems[1]:RefreshView(Enum.RoleInEnvType.RoleMainView, roleId, viewData, extGoesShowData, self, self.LoadModelCB)
end

function UIRoleMain1View:RefreshPartnerView(uid, partnerCfgId, heroData)
	local extGoesShowData = heroData.extGoesShowData
	return self.roleViewSystems[uid]:RefreshView(Enum.RoleInEnvType.RoleMainView, partnerCfgId, nil, extGoesShowData, self, self.LoadModelCB)
end

function UIRoleMain1View:RefreshEquipList(button, params)
	local data = {params[0], Enum.ItemIEnterType.HeroEquip}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipList, data)
end

function UIRoleMain1View:RefreshEquipTips(button, params)
	local data = {params[0], Enum.ItemIEnterType.HeroEquip, true}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, data)
end

function UIRoleMain1View:ChangeCurEquip(button, params)
	self.controller:SendCurEquipDress(params[0], params[1])
	local slotLua = self["slot"..params[0]]

	--slotLua.equipFx:SetActive(true)
	slotLua.equipFx.uIParticle:PlayCachedParticalSystem(true)
end

function UIRoleMain1View:PutOffCurEquip(button, params)
	self.controller:SendCurEquipPutOff(params[0], params[1])
end

function UIRoleMain1View:RefreshEquips()
	local id = self.controller:GetData()
	local oldSlot = ManagerContainer.LuaUIMgr:GetOldSlot()

	local logicData = self.controller:GetHeroLogicData()

	local jobData
	if isLeader then
		ManagerContainer.RedPointMgr.HeroRPCtr:HeroEquipRefineRPNotify()
		jobData = ManagerContainer.CfgMgr:GetJobDataById(ManagerContainer.DataMgr.UserData:GetJobCfgId())
	else
		ManagerContainer.RedPointMgr.HeroRPCtr:PartnerEquipRefineRPNotify(id)
		jobData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	end

	local slotIndex = self.controller:GetCurSLotIndex()
	local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
	
	--self.equipments:SetActive(logicData.isBattle)
	--self.btnOneKeyEquip:SetActive(logicData.isBattle)
	self.btnOneKeyForge:SetActive(isLeader or logicData.owned)
	--self.btnOnekeyDown:SetActive(logicData.isBattle)

    local needPars = {false,false,false,false,false,false}

	--if logicData.isBattle then
		if slots == nil then
			self.btnOneKeyEquip:SetActive((isLeader or logicData.owned))
			self.btnOnekeyDown:SetActive(false)
		else
			local canChange = false
			local hasEquiped = false
			allEquiped = true

			for i = 1, 6 do
				local slotDressRPStatus = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatusByIdx(i)
						or ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusByIdAndIdx(logicData.id, i)

				if slotDressRPStatus == Enum.RedPointEnum.EquipDressRP then
					canChange = true
				end

				if oldSlot ~= nil and i <= #slots and slots[i].equip_id ~= 0 then
					if oldSlot[i] == nil or slots[i].equip_id ~= oldSlot[i].equip_id then
                        needPars[i] = true
					end
				end

				if i <= #slots and slots[i].equip_id > 0 then
					hasEquiped = true
				else
					if slotDressRPStatus == Enum.RedPointEnum.EquipDressRP then
						allEquiped = false
					end
				end
			end
			self.btnOneKeyEquip:SetActive((isLeader or logicData.owned) and (not hasEquiped or canChange))
			self.btnOnekeyDown:SetActive((isLeader or logicData.owned) and (allEquiped and hasEquiped and not canChange))
		end

	self:RefershOneKeyState()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIEquipList)
	--end

	--self.btnOneKeyEquip_lock:SetActive(isLeader and oneKeyEquipLockState)
	--self.btnOneKeyForge_lock:SetActive(isLeader and oneKeyForgeLockState)
    for i = 1, 6 do
		self["slot"..i].equipFx:SetActive(false)
        local data = {isLeader, logicData, jobData, slots, slotIndex, i, self.RefreshEquipTips}
		EquipSlotItemNewCtr:SetData(self, self["slot"..i], data, self, self.RefreshEquipList, needPars[i])
    end
end

function UIRoleMain1View:RefershOneKeyState()
	local logicData = self.controller:GetHeroLogicData()
	local oneKeyRP = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatus()
			or ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusById(logicData.id)
	self.redPointItem1:SetActive(oneKeyRP == Enum.RedPointEnum.EquipDressRP)

	local oneKeyUpRP = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipForgeRPStatus()
			or ManagerContainer.RedPointMgr.HeroRPCtr:GetpartnerEquipForgeRPStatusById(logicData.id)

	self.redPointItem2:SetActive(oneKeyUpRP == Enum.RedPointEnum.EquipForgeRP)
end

function UIRoleMain1View:GetNoBattlePartnerList()
	local actList = {}
	for _,v in pairs(activationList) do
		actList[#actList + 1] = v.id
	end

	CommonUtil.LoopGridViewEleCreate(self, self.popReplace.scrollView.loopVerticalScrollRect, self.content.gridLayoutGroup, actList, 0, function (itemLua, idx)
		local id = actList[idx + 1]
		local heroData = ManagerContainer.CfgMgr:GetPartnerDataById(id)
		HeroHeadIcon:SetActivationHeroIcon(self, false, heroData, ManagerContainer.DataMgr.PartnerData:GetPartnerDataById(id), itemLua, false, Enum.RedPointEnum.None)

		self.uiBase:AddButtonUniqueEventListener(itemLua.head.button, self, self.PartnerBattleReq, heroData)
	end)
end

function UIRoleMain1View:RefreshPopReplace()
	self:GetNoBattlePartnerList()
	self.popReplace:SetActive(true)
end

function UIRoleMain1View:AttrChangeTipsDisplay()
	local delta = {}
	local increase = false
	for k,_ in pairs(oldAttrs) do
		delta[k] = SDataUtil.InvConvert(newAttrs[k]) - SDataUtil.InvConvert(oldAttrs[k])
		if delta[k] > 0 then
			increase = true
		end
	end

	local specialAttr = nil
	local slotIndex = self.controller:GetCurSLotIndex()
    local temp = CommonUtil.GetCurCardLv(slotIndex)
    if temp then
        specialAttr = {{temp[1],temp[2]}}
    end

	if increase then 
		ManagerContainer.LuaUIMgr:AttrNoticeDisplay1({oldAttrs, newAttrs,specialAttr})
		oldAttrs = CommonUtil.TableClone(newAttrs)
	end
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIAttrAddTips, delta)
end

---------------------------------------------Skill Module -----------------------------
function UIRoleMain1View:OnClickSkillBtn()
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillSettings, {self.controller:GetData()}, self.uiData.id)
end

function UIRoleMain1View:OnRefreshSkillSlot()
	self:RefreshSkills()
end

function UIRoleMain1View:OnRefreshHeroSkill(heroCfgId)
	local hero = self.controller:GetHeroLogicData()
	if hero~= nil and hero.configId == heroCfgId then
		self:RefreshSkills()
	end
end

function UIRoleMain1View:ShowUnlockSkill()
	local logicData = self.controller:GetHeroLogicData()
	local nextAdvanceLevel = logicData.advanceLevel + 1
	if nextAdvanceLevel+1 > #logicData.skills then
		self.UnlockSkillItem.transform.parent.gameObject:SetActive(false)
		return
	end

	self.UnlockSkillItem.transform.parent.gameObject:SetActive(true)
	if self.UnlockSkillLua == nil then
		self.UnlockSkillLua = self.UnlockSkillItem
	end

	self:SetSkillData(self.UnlockSkillLua,logicData.skills[nextAdvanceLevel+1])
	self.UnlockSkillLua.lock:SetActive(false)
	self.UnlockSkillLua.mask:SetActive(false)
end

function UIRoleMain1View:InitSkillItemGos()
	self.SkillItemCls = {}
	for i=1, 4 do
		local skillItemGo = self:GetSkillItemGo(i);
		local skillLua = skillItemGo
		self.SkillItemCls[#self.SkillItemCls+1] = skillLua
		if isLeader then
			self.uiBase:AddButtonEventListener(skillLua.add.button,self, self.OnClickSkillSlotAddBtn)
		end
	end
end

function UIRoleMain1View:OnClickSkillIconBtn(btn,params)
	local slotIdx = params[0];
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillTips,slotIdx, nil, self.uiData.id)
end

function UIRoleMain1View:OnClickSkillLockBtn(btn,params)
	local slotIdx = params[0];
	local skillSlot = ManagerContainer.DataMgr.SkillsData:GetSkillSlotData(slotIdx);
	if  skillSlot ~= nil then
		skillSlot:ShowLockTips()
	end
end

function UIRoleMain1View:OnClickSkillSlotAddBtn()
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillTree, nil, self.uiData.id)
end

function UIRoleMain1View:RefreshSkills()
	if isLeader then
		for i=1, 4 do
			self:RefreshSkillSlot(i)
		end
	else
		local skills = self.controller:GetHeroLogicData().skills
		for i=1, 4 do
			self:RefreshSkillSlot(i,skills[i])
		end
	end
end

function UIRoleMain1View:OnShowSkillTips(btn,params)
	local skillId = params[0]
	if skillId == nil then
		return
	end

	local skill = self.controller:GetSkillById(skillId)
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillPTTips,skill, self.uiData.id)
end


function UIRoleMain1View:RefreshSkillSlot(slotIdx, skill)
	local skillSlot = ManagerContainer.DataMgr.SkillsData:GetSkillSlotData(slotIdx);
	if skillSlot == nil  then
		return
	end

	local vis = skillSlot:IsUnlocked()

	local skillLua = self.SkillItemCls[slotIdx]

	local skillIcon = skillLua.transform:Find("Icon"):GetComponent(Enum.TypeInfo.Image);
	local iconBtn = skillLua.transform:Find("Icon"):GetComponent(Enum.TypeInfo.Button);
	local uiDragItem = skillLua.transform:Find("Icon"):GetComponent(Enum.TypeInfo.UIDragItem);

	if isLeader then
		skillLua.gameObject:SetActive(true)
		skillIcon.gameObject:SetActive(vis)
		skillLua.frame:SetActive(vis)
		-- skillLua.label:SetActive(vis)
		skillLua.lvbg:SetActive(vis)
		skillLua.add:SetActive(vis)
		skillLua.lock:SetActive(not vis)
		skillLua.mask:SetActive(not vis)

		self.uiBase:AddButtonUniqueEventListener(iconBtn,self, self.OnClickSkillIconBtn,slotIdx)
		self.uiBase:AddButtonUniqueEventListener(skillLua.lock.button,self, self.OnClickSkillLockBtn,slotIdx)
		if vis then
			skillLua.text.text.text = "lv." .. skillSlot.level
			if skillSlot:HasArrangeSkill() then
				skillLua.add:SetActive(false)
				CommonUtil.LoadIcon(self, skillSlot.skill.skillCfg.Icon, function (sprite)
					if skillIcon~= nil then
						skillIcon.sprite = sprite
					end
				end)

				if isLeader then
					uiDragItem:Reset(slotIdx)

					uiDragItem.onBeginDrag = function()
						iconBtn.interactable = false;
						self.MoveSkillItem.image.sprite = skillIcon.sprite;
						uiDragItem:SetMoveItem(self.MoveSkillItem.rectTransform)
					end

					uiDragItem.onEndDrag = function()
						if uiDragItem.LastSlotIdx ~= uiDragItem.slotIdx then
							ManagerContainer.DataMgr.SkillsData:SendSwapSkill(uiDragItem.LastSlotIdx,uiDragItem.slotIdx)
						end
						self.MoveSkillItem:SetActive(false)
						iconBtn.interactable = true;
					end
				end
			else
				skillLua.add:SetActive(true)
				skillLua.lvbg:SetActive(false)
				skillIcon.gameObject:SetActive(false)
			end
		end
	else
		skillLua.gameObject:SetActive(skill ~= nil)
		skillLua.icon:SetActive(skill ~= nil)
		skillLua.transform.parent:Find("Lable"..slotIdx).gameObject:SetActive(skill ~= nil)
		skillLua.frame:SetActive(true)
		skillLua.label:SetActive(skill ~= nil and not skill:IsPassiveSkill())
		skillLua.lvbg:SetActive(skill ~= nil)
		skillLua.add:SetActive(false)
		skillLua.lock:SetActive(skill ~= nil and not skill.isUnlocked)
		skillLua.mask:SetActive(skill ~= nil and not skill.isUnlocked)

		if skill ~= nil then
			skillLua.text.text.text = "lv" .. skill.level
			self.uiBase:AddButtonUniqueEventListener(skillLua.icon.button,self, self.OnShowSkillTips,skill.skillId)
			self.uiBase:AddButtonUniqueEventListener(skillLua.lock.button,self, self.OnShowSkillTips,skill.skillId)
			if skill.skillCfg~= nil then
				CommonUtil.LoadIcon(self, skill.skillCfg.Icon, function (sprite)
					if skillLua.icon~= nil then
						skillLua.icon.image.sprite = sprite
					end
				end)
			end
		end
	end

end


function UIRoleMain1View:RefreshSkillSlotPartner(slotIdx,skill)
	local skillLua = self.SkillItemCls[slotIdx]
	if skillLua == nil then
		LogError("UIRolePtView:RefreshSkillSlot：" .. slotIdx);
		return
	end

	--self:RefreshSkillSlot(slotIdx,skill)
	self:SetSkillData(skillLua,skill)
end

function UIRoleMain1View:GetSkillItemGo(slotIdx)
	if slotIdx == 1 then
		return self.Skill1;
	end

	if slotIdx == 2 then
		return self.Skill2;
	end

	if slotIdx == 3 then
		return self.Skill3;
	end

	if slotIdx == 4 then
		return self.Skill4;
	end
end

function UIRoleMain1View:SetSkillData(skillLua,skill)
	skillLua.gameObject:SetActive(true)
	skillLua.frame:SetActive(true)
	skillLua.label:SetActive(not skill:IsPassiveSkill())
	skillLua.lvbg:SetActive(true)
	skillLua.add:SetActive(false)
	skillLua.lock:SetActive(not skill.isUnlocked)
	skillLua.mask:SetActive(not skill.isUnlocked)
	skillLua.text.text.text = "lv" .. skill.level

	self.uiBase:AddButtonUniqueEventListener(skillLua.icon.button,self, self.OnShowSkillTips,skill.skillId)
	self.uiBase:AddButtonUniqueEventListener(skillLua.lock.button,self, self.OnShowSkillTips,skill.skillId)
	if skill.skillCfg~= nil then
		CommonUtil.LoadIcon(skill.skillCfg.Icon, function (sprite)
			if skillLua.icon~= nil then
				skillLua.icon.image.sprite = sprite
			end
		end, self.uiData.id, self.controller:GetAsyncIdx())
	end
end

function UIRoleMain1View:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.FASHION_WEAR_CHANGE, self, self.RefreshDefaultRoleView)
end

function UIRoleMain1View:OpenFashionChangeView()
	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashion, nil, self.uiData.id)
end

function UIRoleMain1View:OpenTitleListView()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITitleList, nil, self.uiData.id)
end

function UIRoleMain1View:OnPvpSuppressClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPvpSuppressTips)
end

function UIRoleMain1View:OnPveBlessClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPveBlessTips,self.controller:GetData())
end

function UIRoleMain1View:OnTransferClick()
	local logicData = self.controller:GetHeroLogicData()

	--self:UIHide(false)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleChangeJob, logicData.id, self.uiData.id)
end

function UIRoleMain1View:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.leadBox.btnSkill.button,self,self.OnClickSkillBtn)
	self.uiBase:AddButtonEventListener(self.ptBox.btnSkill.button,self,self.OnClickSkillBtn)

	self.uiBase:AddButtonEventListener(self.leadBox.btnNature.button, function ()
		--self:UIHide(false)
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleNaturePoint, self.controller:GetData(), self.uiData.id)
	end)

	self.uiBase:AddButtonEventListener(self.ptBox.btnNature.button, function ()
		--self:UIHide(false)
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleNaturePoint, self.controller:GetData(), self.uiData.id)
	end)

	self.uiBase:AddButtonEventListener(self.leadBox.btnTransfer.button, self, self.OnTransferClick)
	self.uiBase:AddButtonEventListener(self.ptBox.btnTransfer.button, self, self.OnTransferClick)
	self.uiBase:AddButtonEventListener(self.btnPvpSuppress.button, self, self.OnPvpSuppressClick)
	self.uiBase:AddButtonEventListener(self.btnPveBless.button, self, self.OnPveBlessClick)


	self.uiBase:AddButtonEventListener(self.btnOneKeyEquip.button, function ()
		local hasRp = true
		if isLeader then
			hasRp = ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatus() == Enum.RedPointEnum.EquipDressRP
		else
			local logicData = self.controller:GetHeroLogicData()
			if logicData.isBattle then
				hasRp = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusById(logicData.id) == Enum.RedPointEnum.EquipDressRP
			end
		end
		local hasEquip = self.controller:HasEquipOn()
		if not hasEquip and not hasRp then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.NoSuitableEquip)
			return
		end
		if hasRp then
			self.controller:SendOneKeyEquipDress()
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnOnekeyDown.button, function ()
		local hasRp = false
		if isLeader then
			hasRp = ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatus() == Enum.RedPointEnum.EquipDressRP
		else
			local logicData = self.controller:GetHeroLogicData()
			--if logicData.isBattle then
				hasRp = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusById(logicData.id) == Enum.RedPointEnum.EquipDressRP
			--end
		end
		local hasEquip = self.controller:HasEquipOn()
		if not hasEquip and not hasRp then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.NoSuitableEquip)
			return
		end
		if not hasRp then
			self.controller:SendOneKeyEquipPutOff()
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnOneKeyForge.button, function ()
		self.controller:SendOneKeyUp()
	end)

	self.uiBase:AddButtonEventListener(self.btnLeft.button, function ()
		self.controller:SwichParterHero(-1)
	end)

	self.uiBase:AddButtonEventListener(self.btnRight.button, function ()
		self.controller:SwichParterHero(1)
	end)

	self.uiBase:AddButtonEventListener(self.btnRefineExtra.button, function ()
		local slotIndex = self.controller:GetCurSLotIndex()
		local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
		if slots == nil then return end

		local lv = ManagerContainer.DataMgr.UserData:GetMinRefineLevel(slots)

		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRefineExtraPop, lv)
	end)

	self.uiBase:AddButtonEventListener(self.ptBox.btnLvUp.button, function ()
		local logicData = self.controller:GetHeroLogicData()
		local curMaxLv, advenceMaxLv = self.controller:GetPartnerCurMaxLv()
		local maxLv = advenceMaxLv or curMaxLv
		local stepData = self.controller:GetHeroStepData()
		if logicData.baseLevel >= maxLv and logicData.advanceLevel >= #stepData.AddLv then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ParterLvUpMax")
			return
		end

		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPartnerLvUp, self.controller:GetData())
	end)

	self.uiBase:AddButtonEventListener(self.ptBox.btnBreak.button, function ()
		local logicData = self.controller:GetHeroLogicData()
		local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleStrength, cfgData.ParterId)
	end)

	self.uiBase:AddButtonEventListener(self.btnDown.button, function ()
		local logicData = self.controller:GetHeroLogicData()
		self.controller:PartnerBattleReq(logicData.id, false)
	end)

	self.uiBase:AddButtonEventListener(self.btnGoOut.button, function ()
		local partnerBattleCount = self.controller:GetBattlePartnerCount()
		if partnerBattleCount >= 3 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChangePartnerTips")
			return
		end
		local logicData = self.controller:GetHeroLogicData()
		self.controller:PartnerBattleReq(logicData.id, true)
	end)

	self.model.uIEventTriggerListener.onDrag = function()
		local deltaX = self.model.uIEventTriggerListener.currentEventData.delta.x
		curModel.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
	end

	self.uiBase:AddButtonEventListener(self.ptBox1.btnRecruit.button, self, self.OnBtnRecruitClick)

	self.uiBase:AddButtonEventListener(self.leadBox.btnFashion.button, self, self.OpenFashionChangeView)
	self.uiBase:AddButtonEventListener(self.leadBox.btnTitle.button, self, self.OpenTitleListView)

	self.uiBase:AddButtonEventListener(self.btnOneKeyCardUp.button, self, self.OnOneKeyCardUp)
	self.uiBase:AddButtonEventListener(self.btnOnekeyCardDown.button, self, self.OnOneKeyCardDown)
	self.uiBase:AddButtonEventListener(self.btnOneKeyCardForge.button, self, self.OnOneKeyCardForge)
	self.uiBase:AddButtonEventListener(self.btnNature.button, self, self.OnNatureDscClick)
	self.uiBase:AddButtonEventListener(self.btnCardBless.button, self, self.OnCardBlessClick)
	self.uiBase:AddButtonEventListener(self.btnLog.button, self, self.OnClickBtnLog)
	self.uiBase:AddButtonEventListener(self.skillEquipSlot.button, self, self.OnSkillEquipClick)
end

function UIRoleMain1View:OnClickBtnLog(button, params)
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	if not lastClickLogTime or (curTime - lastClickLogTime) > 15000 then
		lastClickLogTime = curTime
		lastClickNum = 0
	end
	if not lastClickNum then
		lastClickNum = 0
	end
	lastClickNum = lastClickNum + 1
	if lastClickNum >= 30 then
		lastClickNum = 0
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('Egg2')
	end
end

function UIRoleMain1View:OnNatureDscClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINatureInfo)
end

function UIRoleMain1View:OnCardBlessClick()
	local id = self.controller:GetData()
	local curLv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(id)
	local count,totalCount = ManagerContainer.DataMgr.CardData:GetCardSuitCountById(id)
	local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(id)
	local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
	local data = {curLv = curLv, count = count, totalCount = totalCount, state = state, slot = slot}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICardBlessTips, data)
end

function UIRoleMain1View:OnBtnRecruitClick(button, params)

	local recruitCostOwned = CommonUtil.GetOwnResCountByItemId(recruitCostId)
	if recruitCostOwned < recruitCostNum then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("RecruitItemUnFull")
		return
	end

	local logicData = self.controller:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	--判断队伍里是否已经有坦有奶
	local partnerCount = ManagerContainer.DataMgr.PartnerData:GetOwnedPartnerCount()
	local hasTank, hasPure = false, false
	local needSecondNtf = true
	if partnerCount == 0 or partnerCount >= 3 then
		needSecondNtf = false
	else
		local roleJobId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
		local roleJobData = ManagerContainer.CfgMgr:GetJobDataById(roleJobId)
		if not hasTank or not hasPure then
			if roleJobData and (roleJobData.JobType == 1 or roleJobData.JobType == 5) then
				if not hasTank then
					hasTank = roleJobData.JobType == 1
				end
				if not hasPure then
					hasPure = roleJobData.JobType == 5
				end
			end
		end

		if not hasTank or not hasPure then
			local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
			for k,v in pairs(partnerDatas) do
				if v.owned then
					local cfgData1 = ManagerContainer.CfgMgr:GetPartnerDataById(v.configId)
					if cfgData1 and (cfgData1.JobType == 1 or cfgData1.JobType == 5) then
						if not hasTank then
							hasTank = cfgData1.JobType == 1
						end
						if not hasPure then
							hasPure = cfgData1.JobType == 5
						end
					end
				end
			end
		end

		if cfgData and (cfgData.JobType == 1 or cfgData.JobType == 5) then
			if not hasTank then
				hasTank = cfgData.JobType == 1
			end
			if not hasPure then
				hasPure = cfgData.JobType == 5
			end
		end

		if partnerCount < 2 then
			needSecondNtf = not hasTank and not hasPure
		else
			needSecondNtf = not hasTank or not hasPure
		end
	end

	local data = {}
	local data1
	if not needSecondNtf then
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(recruitCostId)
		data[1] = I18N.T(itemCfgData.Name)
		data[2] = recruitCostNum
		data[3] = I18N.T(cfgData.Name)
		data[4] = I18N.T(cfgData.JobName)
		data1 = {"PartnerActive", data, nil, self, self.OnRecruitSure}
	else
		data[1] = I18N.T(cfgData.JobName)
		data[2] = I18N.T(cfgData.Name)
		data1 = {"PartnerActive1", nil, nil, self, nil, self.OnRecruitSure, data}
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data1)
end

function UIRoleMain1View:OnRecruitSure()
	local count = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Recruit)
	if count < recruitCostNum then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("RecruitItemUnFull")
		return
	end

	local logicData = self.controller:GetHeroLogicData()
	self.controller:SendRecruit(logicData.configId)
end

function UIRoleMain1View:RecruitSucceed()
	self:RemoveCurModel()
	local logicData = self.controller:GetHeroLogicData()
	local data = {1, self.previewSystem, false, self.roleViewSystems[logicData.id], nil, logicData.configId}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITransPerform, data)
end

function UIRoleMain1View:GetModelRawImageTex()
	return self.model.rawImage.texture
end

function UIRoleMain1View:OnHide()
	if self.previewSystem then
		self.previewSystem:Dispose(true)
	end
	self.previewSystem = nil

	for i = 1, 6 do
		self.roleViewSystems[i]:Dispose()
	end
	self.roleViewSystems = nil
end

function UIRoleMain1View:OnShow(data)
	self.controller:SetData(data)
	if not data then
		self.controller:SetData(data)
	end
	self:Init()
	self.delayTimer = FrameTimer.New(function()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_MAIN_TOP_RES_TYPE, isLeader and Enum.ItemType.Diamond or Enum.ItemType.ParterExp)
	end, 1)
	self.delayTimer:Start()
end

function UIRoleMain1View:OnBackIn()

end

function UIRoleMain1View:OnClose()
	-- CommonUtil.SetGOLayer(curModel, Constant.DefaultLayer)

	if self.inited then
		DG.Tweening.DOTween.Kill(self.transform)
		self.recommendSkillId = nil
		self.model.uIEventTriggerListener.onDrag = nil
		self.controller:SetCurOwnerIndex(1)
	end

	curModel = nil
	lastClickLogTime = nil
	lastClickNum = nil

	if self.previewSystem then
		self.previewSystem:Dispose()
	end
	self.previewSystem = nil

	if self.roleViewSystems then
		for i = 1, 6 do
			self.roleViewSystems[i]:Dispose()
		end
		self.roleViewSystems = nil
	end

	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
end

function UIRoleMain1View:RefreshCardSlotOpenRP()
	self:RefreshFellowBtns()
	self:RefreshEquips()
end

function UIRoleMain1View:OnOneKeyCardUp()
	self.controller:OnOneKeyCardUp()
end

function UIRoleMain1View:OnOneKeyCardDown()
	self.controller:OnOneKeyCardDown()
end

function UIRoleMain1View:OnOneKeyCardForge()
	self.controller:OnOneKeyCardForge()
end

function UIRoleMain1View:RefreshCardSuitBtn()
	local id = self.controller:GetData()
	local curLv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(id)
	local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(id)
	local allCfgDatas = ManagerContainer.CfgMgr:GetAllCardSuitNewCfg()
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
function UIRoleMain1View:RefreshSkillSuitBtn()
	local id = self.controller:GetData()
	local pressValue = ManagerContainer.DataMgr.UserData:GetCurrRoleSkillPress()
	self.btnPvpSuppress.num.text.text = pressValue
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(id)
	if skillData == nil then
		self.pveBlessLv:SetActive(false)
		return
	end
	self.pveBlessLv:SetActive(true)
	local currNerveLv = skillData:GetCurrNerveLv()
	local allCfgDatas = ManagerContainer.CfgMgr:GetAllSkillSuitNewCfg()
	for i = 1, #allCfgDatas do
		if self.pveBlessLv["lv"..(i - 1)] then
			self.pveBlessLv["lv"..(i - 1)]:SetActive(currNerveLv == i)
		end
	end
end

-------------------------------------------------------神器-----------------------------------------------------
function UIRoleMain1View:RefreshSkillEquip()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIArtifactTips)
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIEquipList)

	if isLeader then
		self:RefreshDefaultRoleView()
	else
		local logicData = self.controller:GetHeroLogicData()
		self:RefreshPartnerView(logicData.id, logicData.configId, logicData)
	end
	self:SkillEquipSlotSuccess()
	self:RefreshSkillEquipRP()
end

function UIRoleMain1View:RefreshSkillEquipRP()
	self:RefreshFellowBtns()

	local heroId = self.controller:GetData()
	local skillEquipRP = ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleSkillEuipSlotRP(heroId)
	self.skillEquipSlot.redPointItem.redPoint:SetActive(skillEquipRP)
end

function UIRoleMain1View:SkillEquipSlotSuccess()
	local curSkillEquipData = self.controller:GetCurHeroSkillEquipSlotData()
	self.skillEquipSlot.iconItem:SetActive(curSkillEquipData ~= nil and curSkillEquipData.id > 0)
	self.artifact.lightBlue:SetActive(curSkillEquipData ~= nil and curSkillEquipData.id > 0)
	if curSkillEquipData and curSkillEquipData.cfgId > 0 then
		IconItemCtr:SetData(self, self.skillEquipSlot.iconItem, curSkillEquipData, Enum.ItemIEnterType.HeroEquip, self, self.OnSkillEquipClick) 
	end
end

function UIRoleMain1View:ChangeSkillEquip(button, params)
	local skillEquipId = params[0]
	self.controller:SendSkillEquipUpReq(skillEquipId)
end

function UIRoleMain1View:DownSkillEquip()
	self.controller:SendSkillEquipDownReq()
end

function UIRoleMain1View:OnSkillEquipClick(button, params)
	local heroData = self.controller:GetHeroLogicData()
	local jobType = self.controller:GetHeroJobType()
	local curSkillEquipData = self.controller:GetCurHeroSkillEquipSlotData()
	if not curSkillEquipData or curSkillEquipData.id == 0 then
		local data = {{cfgId = 0, cbOwner = self, cb = self.ChangeSkillEquip, cb1 = self.DownSkillEquip, jobType = jobType, logicData = curSkillEquipData}, Enum.ItemIEnterType.SkillEquip}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipList, data)
	else
		local data = {{cfgId = curSkillEquipData.cfgId, cbOwner = self, cb = self.ChangeSkillEquip, cb1 = self.DownSkillEquip, jobType = jobType, logicData = curSkillEquipData, heroId = heroData.id, heroCfgId = heroData.configId, nickname = heroData.nickname}, Enum.ItemIEnterType.SkillEquip, self.uiData.id}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactTips, data)
	end
end
------------------------------------------------------------------------------------------------------------------

function UIRoleMain1View:RecommendRoleById(id, owner, ownerCB)
	local logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
	local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
	if jobData.JobStage ~= 1 then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	local recommendType = Enum.JobRecommend[jobData.JobType]
	local partners = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	for _,v in pairs(partners) do
		local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(v.configId)
		if cfgData.JobType == recommendType[1] then
			self.controller:SetData(v.id)
			self:Refresh()
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_MAIN_TOP_RES_TYPE, isLeader and Enum.ItemType.Diamond or Enum.ItemType.ParterExp)
			break
		end
	end

	if owner and ownerCB then
		ownerCB(owner)
	end
end

function UIRoleMain1View:PartnerLvUpById(id, owner, ownerCB)
	local partnerData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(id)
	if not partnerData.owned then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	local target = self["role"..id]
	if target == nil then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	target = target.head
	if target == nil then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	if owner and ownerCB then
		ownerCB(owner, target)
	end
end

function UIRoleMain1View:OnDispose()
	self.controller:OnDispose()
end

return UIRoleMain1View

