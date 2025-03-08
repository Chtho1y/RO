local UISkillSettingsView = require("UISkill/UISkillSettingsView_Generate")
local ColorExtension = require("ColorExtension")


function UISkillSettingsView:OnAwake(data)
	self.controller = require("UISkill/UISkillSettingsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISkillSettingsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_PARTER_ADD, self, self.OnParterAdd)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_SLOT_CHANGED, self, self.OnRefreshSlotSkillEvent)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_CHANGED, self, self.OnSkillChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_SKILL_RESET_LV_COUNT_CHANGED, self, self.OnSkillRestLvCountChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.RED_POINT_NOTICE, self, self.OnRedPointNotice)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_CRUISE_CHANGED, self, self.OnCruiseChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_ADVANCESKILLEXP_CHANGED, self, self.OnAdvanceSkillExpChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.OnCoinChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_LV_UP_REFRESH, self, self.RefreshTreeView)
end

function UISkillSettingsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISkillSettingsView:Init()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_VIEW_UP_SKILL_BTN)

	self.skillList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetSkillTreeItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.isEquiping = false
	-- 用于避免频繁向服务器发送升级，加一个限制
	-- 只在升级消息完成再去发送，避免由于中间过程出问题，导致其它技能也不能升级
	-- 则换算成，只要当前选择的技能刷新了就能继续发送消息
	self.isSendUpgradeLv = false
	self:InitResourceBox()
	self:RefreshHero()
	self:RefreshSwitchHero()
	self:HideUpLevelFx()
end

function UISkillSettingsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.btnUpgrade.repeatButton:AddRepeatClickEventListener(nil, nil)
	self.dragContainer.reorderableList.OnElementSiblingChanged:RemoveAllListeners()
	self.dragContainer.reorderableList.OnElementEndDrag:RemoveAllListeners()
	self.skillList.loopGridView.ScrollRect.onValueChanged:RemoveAllListeners()
end

function UISkillSettingsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.btnLeft.button, self, self.OnClickLeftBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnRight.button, self, self.OnClickRightBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnReset.button, self, self.OnClickResetBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnInfo.button, self, self.OnClickInfoBtn)

	self.uiBase:AddButtonUniqueEventListener(self.btnLearn.button, self, self.OnClickLearnBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnSkillAdvance.button, self, self.OnClickAvanceBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnEquip.button, self, self.OnClickEquipBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnSkillAdvanceInfo.button, self, self.OnClickAdvanceAttrBtn)
	self.uiBase:AddButtonUniqueEventListener(self.image.button, self, self.OnClickShowChangeSkillExp)
	self.uiBase:AddButtonUniqueEventListener(self.cancelReplace.button, self, self.OnClickCancelReplaceBtn)
	self.btnUpgrade.repeatButton:AddRepeatClickEventListener(self, self.OnClickUpgradeBtn)

	self.uiBase:AddButtonUniqueEventListener(self.skillItem1.icon.button, self, self.OnClickSlotSkillBtn, 1)
	self.uiBase:AddButtonUniqueEventListener(self.skillItem2.icon.button, self, self.OnClickSlotSkillBtn, 2)
	self.uiBase:AddButtonUniqueEventListener(self.skillItem3.icon.button, self, self.OnClickSlotSkillBtn, 3)
	self.uiBase:AddButtonUniqueEventListener(self.skillItem4.icon.button, self, self.OnClickSlotSkillBtn, 4)

	self.uiBase:AddButtonUniqueEventListener(self.slotLabel.slot1.btnReplace.button, self, self.OnClickReplaceBtn, 1)
	self.uiBase:AddButtonUniqueEventListener(self.slotLabel.slot2.btnReplace.button, self, self.OnClickReplaceBtn, 2)
	self.uiBase:AddButtonUniqueEventListener(self.slotLabel.slot3.btnReplace.button, self, self.OnClickReplaceBtn, 3)
	self.uiBase:AddButtonUniqueEventListener(self.slotLabel.slot4.btnReplace.button, self, self.OnClickReplaceBtn, 4)

	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBackBtn)

	self.dragContainer.reorderableList.OnElementSiblingChanged:AddListener(function(reorderableListEventStruct)
		self:OnDragSlotSkillList(reorderableListEventStruct)
	end)
	self.dragContainer.reorderableList.OnElementEndDrag:AddListener(function()
		self:OnEngDragSkillList()
	end)
	self.skillList.loopGridView.ScrollRect.onValueChanged:AddListener(function(offset)
		self:RefreshArrowHead(offset)
	end)
end

function UISkillSettingsView:OnHide()
end

function UISkillSettingsView:OnShow(data)
	if not data then return end
	self.controller:SetData(data)
	if self.upLevelFxTimer then
		self.upLevelFxTimer:Stop()
		self.upLevelFxTimer = nil
	end
	self.isEquiping = false
	self:RefreshHero()
	self:RefreshSwitchHero()
	self:HideUpLevelFx()
end

function UISkillSettingsView:OnClose()
end

function UISkillSettingsView:OnDispose()
	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil

	self:HideUpLevelFx()
	if self.upLevelFxTimer then
		self.upLevelFxTimer:Stop()
		self.upLevelFxTimer = nil
	end
	self.curSelectSkillItem = nil
	self.isSendUpgradeLv = nil
	self.isEquiping = nil
	self.skillList.loopGridView:Dispose()

	self.markShowDatas = nil
end

function UISkillSettingsView:OnParterAdd()
	local changeHero = self.controller:RefreshOwnedHeros()
	self:RefreshSwitchHero()
	if changeHero then
		self:RefreshHero()
	end
end

function UISkillSettingsView:OnRefreshSlotSkillEvent(heroId)
	if self.controller:GetHeroId() ~= heroId then return end
	self.controller:UpdateSlotSkills()
	self:RefreshTreeView(false)
	self:RefreshSelectSkillInfo()
	self:RefreshSlotSkill(false)
	if self.isEquiping then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("SkillChange")
		self:OnClickCancelReplaceBtn()
	end
end

function UISkillSettingsView:OnSkillChanged(heroId, newSkills, upLevelSkills,downLvSkills,isRefeSelectId)
	if self.controller:GetHeroId() ~= heroId then return end
	self.controller:RefreshSkillList()
	if isRefeSelectId then
		local curSkillId = self.controller:GetSelectSkillId()
		while not self.controller:GetSkilldataByIndex(curSkillId) do
			local skillTreeData = self.controller:GetSkillTreeCfgData(curSkillId)
			local skillList = skillTreeData and skillTreeData.SuperSkill
			if not skillList then
				break
			end
			local heroid = self.controller:GetHeroId()
			local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(heroid)
			local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
			if #skillList > 1 and jobdata and jobdata.JobBranch then
				curSkillId = skillList[jobdata.JobBranch][2]
			else
				curSkillId = skillList[1][2]
			end
		end
		if curSkillId ~= self.controller:GetSelectSkillId() then
			self.controller:SetSelectSkillId(curSkillId)
		end
	end
	self.controller:UpdateSlotSkills()
	self:RefreshTreeView(false)
	self:RefreshSelectSkillInfo()
	self:RefreshSlotSkill(false)
	if upLevelSkills and #upLevelSkills > 0 then
		self:ShowUpLevelFx()
	end
end

function UISkillSettingsView:OnSkillRestLvCountChanged()
	self:RefreshResetSkillLvBtn()
end

function UISkillSettingsView:OnRedPointNotice(rpType)
	if rpType ~= Enum.RedPointEnum.SkillUnlockRP then
		return
	end
	self:RefreshTreeView(false)
end

function UISkillSettingsView:OnCoinChanged()
	local itemCfgId = Enum.ItemType.Coin
	local count = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	self.currency1.number.text.text = CommonUtil.FormatNumber(count)
end

function UISkillSettingsView:OnCruiseChanged()
	local itemCfgId = Enum.ItemType.SkillExp
	local count = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	self.currency2.number.text.text = CommonUtil.FormatNumber(count)
end

function UISkillSettingsView:OnAdvanceSkillExpChanged()
	local itemCfgId = Enum.ItemType.AdvanceSkillExp
	local count = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	self.currency3.number.text.text = CommonUtil.FormatNumber(count)
end

function UISkillSettingsView:OnClickSkillItem(btn, params)
	if self.isEquiping then return end
	local skillId = params[0]
	if not self.controller:SetSelectSkillId(skillId) then
		return
	end
	if self.curSelectSkillItem then
		self.curSelectSkillItem.selectSign:SetActive(false)
	end
	local itemlua = params[1]
	itemlua.selectSign:SetActive(true)
	self.curSelectSkillItem = itemlua
	self:RefreshSelectSkillInfo()
	local selectHeroId = self.controller:GetHeroId()
	ManagerContainer.RedPointMgr.HeroRPCtr:CancelSkillUnlockNotify(selectHeroId, skillId)
end

function UISkillSettingsView:OnClickLeftBtn()
	if self.isEquiping then return end
	if not self.controller:ChangeHero(false) then return end
	self:RefreshHero()
end

function UISkillSettingsView:OnClickRightBtn()
	if self.isEquiping then return end
	if not self.controller:ChangeHero(true) then return end
	self:RefreshHero()
end

function UISkillSettingsView:OnClickResetBtn()
	if self.isEquiping then return end
	local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(self.controller:GetHeroId())
	local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillResetTips, {{self.SendResetSkillLv, self},nil,jobdata and jobdata.JobStage >= 3})
end

function UISkillSettingsView:OnClickInfoBtn()
	if self.isEquiping then return end
	-- 计算显示的数据
	if not self.markShowDatas then
		self.markShowDatas = {}
		self.markShowDatas[1] = 'TitleSkillDsc'
		-- 'TitleNatureDsc'
		local markCfgDatas = ManagerContainer.CfgMgr:GetMarkCfg()
		if markCfgDatas then
			local datas = {}
			self.markShowDatas[2] = datas
			for id, markCfgData in pairs(markCfgDatas) do
				if markCfgData.ShowTypes == 0 or markCfgData.ShowTypes == 2 then
					datas[#datas + 1] = {id, markCfgData.Name, markCfgData.Desc, markCfgData.Icon}
				end
			end
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleInfoPop, self.markShowDatas)
end

function UISkillSettingsView:OnClickLearnBtn()
	if self.isEquiping then return end
	local curSkillId = self.controller:GetSelectSkillId()
	local errorCode, itemCfgId = self.controller:GetActiveSkillErrorCode(curSkillId)
	if errorCode == 0 then
		self.controller:SendActiveSkill(curSkillId)
	else
		if errorCode == 139 then
			CommonUtil.ItemNotEnoughHandle(itemCfgId, self.uiData.id)
		elseif errorCode == 141 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('LearnSkillCondition04')
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UISkillSettingsView:OnClickShowChangeSkillExp()
	local count = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.SkillExp)
	local maxExchangeCount 
	local isSetColor
	local radio = GlobalConfig.Instance:GetConfigIntValue(320)
	if count < radio  then
		isSetColor = true
		maxExchangeCount = 1
	else
		isSetColor = false
		maxExchangeCount = math.floor(count / radio)
	end
	--cfgid == Enum.ItemType.GaojiSkillExp
	local data = {cfgId = Enum.ItemType.AdvanceSkillExp,targetCfgId = Enum.ItemType.SkillExp, radio = radio , count = count,isSetColor = isSetColor, maxExchangeCount = maxExchangeCount, owner = self, ownerCB = self.OnCliclExchangeSkillExpBtn, isExchangeItem = true}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITipsExchange, data)
end

function UISkillSettingsView:OnCliclExchangeSkillExpBtn(idx,num)
		--发送兑换技能经验消息
		local count = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.SkillExp)
		local radio = GlobalConfig.Instance:GetConfigIntValue(320)
		local isCanExchange = count < radio
		if not isCanExchange then
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CONVER_SKILL_EXP_REQ,{cnt = num})
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('SuperSkillExpNotEnough')
		end
end

function UISkillSettingsView:OnClickAdvanceAttrBtn()
	local skilldata = {}
	local attrs = {}
	ManagerContainer.DataMgr.UserData:GetSkillData(self.controller:GetHeroId()):GetAvanceSkillAttrs(attrs,skilldata)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillAdvanceTotal,{skilldata,attrs})
end

function UISkillSettingsView:OnAdvanceConfirm()
	local data = {}
	local skillId = self.controller:GetSelectSkillId()
	local skillTreeCfg = self.controller:GetSkillTreeCfgData(skillId)
	if skillTreeCfg and skillTreeCfg.SuperSkill and #skillTreeCfg.SuperSkill > 0 then
		local selectHeroId = self.controller:GetHeroId()
		local nextskillTreeCfg
		local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(selectHeroId)
		local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
		for i = 1, #skillTreeCfg.SuperSkill do
			if skillTreeCfg.SuperSkill[i][1] == jobdata.JobBranch then
				nextskillTreeCfg = self.controller:GetSkillTreeCfgData(skillTreeCfg.SuperSkill[i][2])
				break
			end
		end
		data[1] = {id = skillId, lv = skillTreeCfg.MaxLv }
		data[2] = {id = nextskillTreeCfg.SkillId, lv = 1 }
		data[3] = self.controller:GetHeroId()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillAdvance,data)
	else
		LogError('[Wboy] SkillTreeCfg Data is Error.  skillId : ' .. tostring(skillId) )
	end
end


function UISkillSettingsView:OnClickAvanceBtn()
	if self.isEquiping then return end
	local curSkillId = self.controller:GetSelectSkillId()
	local errorCode, itemCfgId = CommonUtil.CheckSkillCanAvance(self.controller:GetHeroId(),curSkillId)
	if errorCode == 0 then
		self:OnAdvanceConfirm()
	else
		if errorCode == 139 then
			CommonUtil.ItemNotEnoughHandle(itemCfgId, self.uiData.id)
		elseif errorCode == 200 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('NeedAdvanceJobTips')
		elseif errorCode == 141 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('LearnSkillCondition04')
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UISkillSettingsView:OnClickUpgradeBtn()
	if self.isEquiping then return end
	if self.isSendUpgradeLv then return end
	local curSkillId = self.controller:GetSelectSkillId()
	local errorCode, itemCfgId = self.controller:GetUpgradeSkillErrorCode(curSkillId)
	if errorCode == 0 then
		self.isSendUpgradeLv = true
		self.controller:SendUpgradeSkill(curSkillId)
	else
		if errorCode == 139 then
			CommonUtil.ItemNotEnoughHandle(itemCfgId, self.uiData.id)
		elseif errorCode == 141 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('LearnSkillCondition06')
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
end

function UISkillSettingsView:OnClickEquipBtn()
	if self.isEquiping then return end
	if self.controller:GetUnlockSlotNum() <= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('DscSkillSet3')
		return
	end
	self.isEquiping = true
	self:RefreshReplaceBtn()
end

function UISkillSettingsView:OnClickCancelReplaceBtn()
	if not self.isEquiping then return end
	self.isEquiping = false
	self:RefreshReplaceBtn()
end

function UISkillSettingsView:OnClickSlotSkillBtn(btn, params)
	if self.isEquiping then return end
	local slotIdx = params[0]
	local skillId = self.controller:GetSkillIdBySlotIdx(slotIdx)
	local isChanged = self.controller:SetSelectSkillId(skillId)
	if isChanged then
		if self.curSelectSkillItem then
			self.curSelectSkillItem.selectSign:SetActive(false)
		end
		self:RefreshSelectSkillInfo()
	end
	self:RefreshTreeView(true, true)
end

function UISkillSettingsView:OnClickReplaceBtn(btn, params)
	if not self.isEquiping then return end
	local curSkillId = self.controller:GetSelectSkillId()
	local slotIdx = params[0]
	self.controller:SendChangeSkill(curSkillId, slotIdx)
end

function UISkillSettingsView:OnClickBackBtn()
	if self.isEquiping then return end
	self:UIClose()
	if self.uiBase.MSourceUIID > 0 then
        ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID, self.controller:GetHeroId())
    end
end

function UISkillSettingsView:ShowUpLevelFx()
	self:HideUpLevelFx()
	self.skillLvUP:SetActive(true)
	self.fx_ui_skillsettings_skillup.uIParticle:PlayCachedParticalSystem(true)
	if not self.upLevelFxTimer then
		self.upLevelFxTimer = Timer.New(function()
			self:HideUpLevelFx()
		end, 5)
		self.upLevelFxTimer:Start()
	else
		self.upLevelFxTimer.time = self.upLevelFxTimer.duration
	end
end

function UISkillSettingsView:HideUpLevelFx()
	self.skillLvUP:SetActive(false)
	self.fx_ui_skillsettings_skillup.uIParticle:PlayCachedParticalSystem(false)
end

function UISkillSettingsView:InitResourceBox()
	local itemCfgId = Enum.ItemType.Coin
	local count = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	self.currency1.number.text.text = CommonUtil.FormatNumber(count)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
		self.currency1.icon.image.sprite = sprite
	end)
	itemCfgId = Enum.ItemType.SkillExp
	count = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	self.currency2.number.text.text = CommonUtil.FormatNumber(count)
	itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
		self.currency2.icon.image.sprite = sprite
	end)

	local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(self.controller:GetHeroId())
	local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
	self.currency3:SetActive(jobdata and jobdata.JobStage >= 3)
	itemCfgId = Enum.ItemType.AdvanceSkillExp
	count = CommonUtil.GetOwnResCountByItemId(itemCfgId)
	self.currency3.number.text.text = CommonUtil.FormatNumber(count)
	itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
	CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
		self.currency3.icon.image.sprite = sprite
	end)

end

function UISkillSettingsView:RefreshHero()
	self:RefreshRoleTop()
	self.curSelectSkillItem = nil
	self:RefreshTreeView()
	self:RefreshSelectSkillInfo()
	self:RefreshSlotSkill(true)
	self:RefreshReplaceBtn()
	self:RefreshResetSkillLvBtn()
	--未进阶二转角色隐藏 高级技能经验
	local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(self.controller:GetHeroId())
	local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
	self.currency3:SetActive(jobdata and jobdata.JobStage >= 3)
end

function UISkillSettingsView:RefreshRoleTop()
	local id = self.controller:GetHeroId()
	local cfgData = CommonUtil.GetHeroCfgDataByUid(id)
	CommonUtil.LoadIcon(self, cfgData.BattleCartoonImg, function (sprite)
		self.roleImg.role.image.sprite = sprite
	end)

	local heroData = self.controller:GetHeroData()
	local jobName, roleName = CommonUtil.GetHeroSplitJobAndNameByUid(id, heroData.configId)
	self.roleImg.textBox.uILocalizeScript:SetContentAndValues("DscRoleTalk1", {jobName, roleName})
end

function UISkillSettingsView:RefreshSwitchHero()
	local num = self.controller:GetHeroVaildNum()
	if num > 1 then
		self.btnLeft:SetActive(true)
		self.btnRight:SetActive(true)
	else
		self.btnLeft:SetActive(false)
		self.btnRight:SetActive(false)
	end
end

--------------------------------- 技能列表 Start ----------------------------------
function UISkillSettingsView:GetSkillTreeItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('SkillSmallItem')
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'SkillSmallItem', item.gameObject)
	if itemlua then
		local skillData = self.controller:GetSkillItemInfoByIndex(itemIndex)
		if skillData then
			local curSkillId = self.controller:GetSelectSkillId()

			if self.forceGuideSkillId ~= nil and self.forceGuideSkillId == skillData.SkillId then
				self.forceGuideTarget = item.gameObject
			end

			itemlua.selectSign:SetActive(skillData.SkillId == curSkillId)
			if skillData.SkillId == curSkillId then
				self.curSelectSkillItem = itemlua
			end
			local skillId = skillData.SkillId
			local skillType = skillData.SkillType
			local isUnlock = self.controller:GetIsUnlock(skillId)
			local skillLv
			if isUnlock then
				skillLv = self.controller:GetSkilllv(skillId)
			else
				skillLv = 1
			end
			itemlua.lock:SetActive(not isUnlock and not self.controller:GetIsCanUnlock(skillId))
			local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(skillType, skillId, skillLv)
			itemlua.skillItem.icon.image.sprite = nil
			if skillCfgData then
				if skillCfgData.Icon then
					CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
						itemlua.skillItem.icon.image.sprite = sprite
					end, itemlua, "SkillIconAsyncIdx")
				end
				itemlua.skillItem.num.text.text = isUnlock and (I18N.SetLanguageValue('Lv') .. tostring(skillLv)) or ''
				itemlua.skillName.text.text = I18N.SetLanguageValue(skillCfgData.Name)

				local skillShowData = ManagerContainer.CfgMgr:GetSkillShowCfgById(skillId)
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
					local skillTagItem = itemlua['skillTagItem' .. i]
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
			else
				itemlua.skillItem.icon.image.sprite = nil
				itemlua.skillItem.num.text.text = ''
				itemlua.skillName.text.text = ''
				itemlua.skillTagItem1:SetActive(false)
				itemlua.skillTagItem2:SetActive(false)
				itemlua.skillTagItem3:SetActive(false)
				itemlua.skillTagItem4:SetActive(false)
				LogError('[Wboy] Skill Cfg Data is Error. skillType :' .. tostring(skillType) .. '  skillId : ' .. tostring(skillId) .. '  skillLv : ' .. tostring(skillLv))
			end
			itemlua.skillItem.icon.button.enabled = false
			local isEquip = self.controller:GetSkillIsAtSlot(skillId)
			itemlua.equipSign:SetActive(isEquip)
			local selectHeroId = self.controller:GetHeroId()
			local rpStatus = ManagerContainer.RedPointMgr.HeroRPCtr:GetSkillUnlockRPStatus(selectHeroId, skillId)
			local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(selectHeroId)
			local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
			local curskillLv = self.controller:GetSkilllv(skillData.SkillId)
			local isCanAvance = false
			local nextSkilldata
			if  skillData.SuperSkill then
				nextSkilldata = self.controller:GetSkillTreeCfgData(skillData.SuperSkill[1][2])
			end

			--神器标记
			local artifactSkillState, idx = self.controller:GetSkillInSkillEquipDataState(skillId)
			itemlua.redPoint:SetActive(rpStatus ~= Enum.RedPointEnum.None and artifactSkillState == 0)
			itemlua.artifactStatus:SetActive(artifactSkillState > 0)

			itemlua.artifactStatus.activated:SetActive(artifactSkillState == 2)
			itemlua.artifactStatus.button.interactable = artifactSkillState > 0
			if artifactSkillState > 0 then
				CommonUtil.LoadIcon(self, self.controller:GetSkillEquipIcon(), function (sprite)
					itemlua.artifactStatus.icon.image.sprite = sprite
				end, itemlua, "ArtifactIcon")
				CommonUtil.NeedUIGray(itemlua.artifactStatus.icon.image, artifactSkillState == 1)

				self.uiBase:AddButtonUniqueEventListener(itemlua.artifactStatus.button, self, self.OnSkillEquipSignClick, artifactSkillState, idx)
			end

			if nextSkilldata and  nextSkilldata.OpenNeedCost  then
				local openNeedCost = nextSkilldata.OpenNeedCost
				isCanAvance = self:IsCanLearnOrAvance(openNeedCost,self.btnSkillAdvance.costBox,true)
				if  herodata.baseLevel > nextSkilldata.OpenLevel and  skillData.SuperSkill and jobdata 
				and jobdata.JobStage >= nextSkilldata.JobStage and curskillLv >= skillData.MaxLv  
				and isCanAvance then
					itemlua.newRedPoint:SetActive(artifactSkillState == 0)
					local redPointParent = itemlua.newRedPoint.transform
					if redPointParent then
						if redPointParent.childCount == 0 then
							self:CreateNormalRedPoint(redPointParent)
						end
					end
				else
					itemlua.newRedPoint:SetActive(false)
				end
			else
				itemlua.newRedPoint:SetActive(false)
			end
			
			self.uiBase:AddButtonUniqueEventListener(itemlua.button, self, self.OnClickSkillItem, skillId, itemlua)
			local quality = skillData and skillData.SkillQuality or 0
			if quality ~= 0 then
				CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[quality], function (sprite)
					itemlua.skillItem.frame.image.sprite = sprite
				end)
			else
				CommonUtil.LoadIcon(self, "FrameNew/frame_item_gray", function (sprite)
					itemlua.skillItem.frame.image.sprite = sprite
				end)
			end
		else
			LogError('[Wboy] Skill Data is Error. index :' .. tostring(itemIndex))
		end
	end
	return item
end


function UISkillSettingsView:RefreshTreeView(resetPos, isCenter)
	if resetPos == nil then resetPos = true end
	local loopGridView = self.skillList.loopGridView
	local skillList = self.controller:SetSkillList()
	local len = skillList and #skillList or 0
	if resetPos then
		local curSkillId = self.controller:GetSelectSkillId()
		local moveTo = 0
		for i = 1, len do
			local skillTreeData = skillList[i]
			local skillId = skillTreeData.SkillId
			if skillId == curSkillId then
				moveTo = i - 1
				break
			end
		end
		if isCenter then
			local scrollRect = loopGridView.ScrollRect
			local viewport = scrollRect.viewport
			local viewportH = viewport.rect.height
			loopGridView:RefreshListByIndex(len, moveTo, 0, -viewportH * 0.5)
		else
			loopGridView:RefreshListByIndex(len, moveTo)
		end
	else
		if loopGridView.ItemTotalCount == len then
			loopGridView:RefreshListByIndex(len)
		else
			loopGridView:RefreshListByIndex(len)
		end
	end
	self:RefreshArrowHead()
end

function UISkillSettingsView:FindSkillItemById(id, owner, ownerCB)
	self.forceGuideSkillId = id
	local skillList = self.controller:SetSkillList()
	local idx
	for k,v in pairs(skillList) do
		local skillId = v.SkillId
		if skillId == id then
			idx = k
			break
		end
	end
	if idx == nil then
		if owner and ownerCB then
			ownerCB(owner)
			return
		end
	end

	local loopGridView = self.skillList.loopGridView
	loopGridView:RefreshAllShownItem()
	loopGridView:MovePanelToItemByIndex(idx - 1)

	self.delayTimer = FrameTimer.New(function()
		if owner and ownerCB then
			ownerCB(owner, self.forceGuideTarget)
		end
	end, 5)
	self.delayTimer:Start()
end

function UISkillSettingsView:RefreshArrowHead(offset)
	local loopGridView = self.skillList.loopGridView
	local scrollRect = loopGridView.ScrollRect
	local viewport = scrollRect.viewport
	local content = scrollRect.content
	local viewportH = viewport.rect.height
	local contentH = content.rect.height
	local vaildH = contentH - viewportH
	if vaildH <= 0 then
		self.upArrow:SetActive(false)
		self.bottomArrow:SetActive(false)
		return
	end
	vaildH = 1 / vaildH
	local padding = loopGridView.Padding
	local minH = (padding.top + 20) * vaildH
	local maxH = 1 - (padding.bottom + 20) * vaildH
	local offsetY
	if offset then
		offsetY = offset.y
	else
		offsetY = scrollRect.verticalNormalizedPosition
	end
	self.upArrow:SetActive((offsetY <= maxH))
	self.bottomArrow:SetActive((offsetY >= minH))
end

function UISkillSettingsView:RefreshSelectSkillInfo()
	self.isSendUpgradeLv = false
	local curSkillId = self.controller:GetSelectSkillId()
	local curSkillLv = self.controller:GetSkilllv(curSkillId)
	local curSkillMaxLv = self.controller:GetSkillMaxLv(curSkillId)
	local skillTreeCfgData = self.controller:GetSkillTreeCfgData(curSkillId)
	self.btnSkillAdvanceInfo:SetActive(skillTreeCfgData and skillTreeCfgData.SkillQuality > 0)
	if skillTreeCfgData and skillTreeCfgData.SkillQuality > 0 then
		self.btnSkillAdvanceInfo.text.text.text = string.formatbykey("Advance",skillTreeCfgData.SkillQuality - 2)
	end
	-- 当前
	local isUnlock = self.controller:GetIsUnlock(curSkillId)
	self.currentBox.title:SetActive(isUnlock)
	self.currentBox.desText:SetActive(isUnlock)
	self.currentBox.none:SetActive(not isUnlock)
	if isUnlock then
		self.currentBox.title.text.text.text = tostring(curSkillLv)
		self:RefreshSkillDes(self.currentBox, curSkillId, curSkillLv)
	else
		self.currentBox.title.text.text.text = '--'
	end
	-- 下一级
	local nextSkillLv = curSkillLv + 1
	local hasNextLv = (nextSkillLv <= curSkillMaxLv)
	self.nextBox.title:SetActive(hasNextLv)
	self.nextBox.desText:SetActive(hasNextLv)
	self.nextBox.max:SetActive(not hasNextLv)
	if hasNextLv then
		self.nextBox.title.text.text.text = tostring(nextSkillLv)
		self:RefreshSkillDes(self.nextBox, curSkillId, nextSkillLv, true)
	else
		self.nextBox.title.text.text.text = I18N.SetLanguageValue('Max')
	end

	self:RefreshSkillLvAttrs(curSkillMaxLv, curSkillId, curSkillLv)
	self:RefreshSkillBtnContainer()
end

function UISkillSettingsView:RefreshSkillDes(detailBox, skillId, skillLv, isNext)
	local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLv)
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillCfgId)
	if skillCfgData then
		local descParam = skillCfgData.DescParam
		if descParam then
			if type(descParam) == 'table' then
				if isNext then
					local ls = {}
					local colorStr = '<color=' .. string.formatbykey('ColorID8') .. '>'
					for i = 1, #descParam do
						ls[i] = colorStr .. tostring(descParam[i]) .. '</color>'
					end
					descParam = ls
				end
				detailBox.desText.text.text = string.formatbykey(skillCfgData.Desc, unpack(descParam))
			else
				if isNext then
					detailBox.desText.text.text = string.formatbykey(skillCfgData.Desc, '<color=' .. I18N.formatbykey('ColorID8') .. '>' .. tostring(descParam) .. '</color>')
				else
					detailBox.desText.text.text = string.formatbykey(skillCfgData.Desc, descParam)
				end
			end
		else
			detailBox.desText.text.text = string.formatbykey(skillCfgData.Desc)
		end
	else
		detailBox.desText.text.text = ''
	end
end

function UISkillSettingsView:RefreshSkillLvAttrs(curSkillMaxLv, curSkillId, curSkillLv)
	-- 获得这个技能所有能获得的属性列表
	local attrs = {}
	for i = 1, curSkillMaxLv do
		local cfgId = CommonUtil.GetSkillUpEffectCfgIdByIdAndLv(curSkillId, i)
		local cfgData = ManagerContainer.CfgMgr:GetSkillUpEffectCfgById(cfgId)
		if cfgData then
			local addAttributes = CommonUtil.DeserializeCfgItemList(cfgData.AddAttributes)
			if #addAttributes > 0 then
				table.insert(attrs, {lv = i, attr = addAttributes[1]})
			end
		end
	end
	for i = 1, 5 do
		local itemlua = self.lvAttrBox['skillLvAttrItem' .. i]
		if itemlua then
			local attr = attrs[i]
			if attr then
				itemlua:SetActive(true)
				local lvContent = (I18N.SetLanguageValue('LV') .. tostring(attr.lv))
				local attrId = attr.attr[1]
				local attrValue = attr.attr[2]
				local attrContent = (I18N.SetLanguageValue('KeySkillUpEffectCfg', CommonUtil.HeroAttrFormatValueNoSign(attrId, attrValue), I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))))
				if curSkillLv >= attr.lv then
					lvContent = string.format(Constant.GreenColorText, lvContent)
					attrContent = string.format(Constant.GreenColorText, attrContent)
				end
				itemlua.lvText.text.text = lvContent
				itemlua.attrText.text.text = attrContent
			else
				itemlua:SetActive(false)
			end
		end
	end
end

function UISkillSettingsView:RefreshSkillBtnContainer()
	local curSkillId = self.controller:GetSelectSkillId()
	local curSkillLv = self.controller:GetSkilllv(curSkillId)
	local isUnlock = self.controller:GetIsUnlock(curSkillId)
	local curSkillMaxLv = self.controller:GetSkillMaxLv(curSkillId)

	if isUnlock then
		local isEquip = self.controller:GetSkillIsAtSlot(curSkillId)
		self.btnEquip:SetActive(not isEquip)
		self.labelEquipped:SetActive(isEquip)
	else
		self.btnEquip:SetActive(false)
		self.labelEquipped:SetActive(false)
	end

	if not isUnlock then
		self.btnLearn:SetActive(true)
		self.btnUpgrade:SetActive(false)
		self.btnSkillAdvance:SetActive(false)
		local skillTreeCfgData = self.controller:GetSkillTreeCfgData(curSkillId)
		if skillTreeCfgData then
			-- 检查条件是否能学习
			local openLevel = skillTreeCfgData.OpenLevel
			if openLevel and openLevel > 0 then
				if not self:RefreshLockInfo(self.btnLearn.lockBox, openLevel) then
					self.btnLearn.lockBox:SetActive(true)
					self.btnLearn.costBox:SetActive(false)
					-- self.btnLearn.button.interactable = false
					return
				end
			end
			self.btnLearn.lockBox:SetActive(false)
			local openNeedCost = skillTreeCfgData.OpenNeedCost
			if openNeedCost then
				self:IsCanLearnOrAvance(openNeedCost,self.btnLearn.costBox)
			else
				self.btnLearn.costBox:SetActive(false)
			end
			-- self.btnLearn.button.interactable = canLearn
		-- else
			-- self.btnLearn.button.interactable = false
		end
	elseif curSkillLv < curSkillMaxLv then
		self.btnLearn:SetActive(false)
		self.btnSkillAdvance:SetActive(false)
		self.btnUpgrade:SetActive(true)
		local skillTreeCfgData = self.controller:GetSkillTreeCfgData(curSkillId)
		if skillTreeCfgData then
			-- 检查条件是否能升级
			local upgradeLevel = ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeLevelById(skillTreeCfgData.OpenLevel) --skillTreeCfgData.UpGradeLevel
			if upgradeLevel and upgradeLevel[curSkillLv] then
				if not self:RefreshLockInfo(self.btnUpgrade.lockBox, upgradeLevel[curSkillLv]) then
					self.btnUpgrade.redPointRoot:SetActive(false)
					self.btnUpgrade.lockBox:SetActive(true)
					self.btnUpgrade.costBox:SetActive(false)
					-- self.btnUpgrade.button.interactable = false
					return
				end
			else
				self.btnUpgrade.redPointRoot:SetActive(false)
				self.btnUpgrade.lockBox:SetActive(false)
				self.btnUpgrade.costBox:SetActive(false)
				-- self.btnUpgrade.button.interactable = false
				LogError('[Wboy] UpGradeLevel Cfg is Error. skillId : ' .. tostring(curSkillId) .. ' skillLv : ' .. tostring(curSkillLv))
				return
			end
			self.btnUpgrade.lockBox:SetActive(false)
			local canUpgrade = true
			local upgradeCost = ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeCostById(skillTreeCfgData.OpenLevel) --skillTreeCfgData.UpGradeCost
			if upgradeCost and upgradeCost[curSkillLv] or #(upgradeCost[curSkillLv]) < 2 then
				self.btnUpgrade.costBox:SetActive(true)
				local itemCfgId = upgradeCost[curSkillLv][1]
				local itemNum = upgradeCost[curSkillLv][2]
				if not self:RefreshCostInfo(self.btnUpgrade.costBox, itemCfgId, itemNum) then
					canUpgrade = false
				end
			else
				self.btnUpgrade.costBox:SetActive(false)
				canUpgrade = false
				LogError('[Wboy] UpGradeCost Cfg is Error. skillId : ' .. tostring(curSkillId) .. ' skillLv : ' .. tostring(curSkillLv))
			end
			-- self.btnUpgrade.button.interactable = canUpgrade
			if canUpgrade then
				self.btnUpgrade.redPointRoot:SetActive(true)
				local redPointParent = self.btnUpgrade.redPointRoot.transform
				if redPointParent then
					if redPointParent.childCount == 0 then
						self:CreateNormalRedPoint(redPointParent)
					end
				end
			else
				self.btnUpgrade.redPointRoot:SetActive(false)
			end
		-- else
		-- 	self.btnUpgrade.button.interactable = false
		end
	elseif curSkillLv == curSkillMaxLv then
		local curSkilldata  = self.controller:GetSkillTreeCfgData(curSkillId)
		if not curSkilldata then
			return
		end
		if  curSkilldata.SuperSkill then  
			self.btnLearn:SetActive(false)
			self.btnUpgrade:SetActive(false)
			self.btnSkillAdvance:SetActive(true)
		else
			self.btnSkillAdvance:SetActive(false)
			self.btnLearn:SetActive(false)
			self.btnUpgrade:SetActive(false)
			return
		end
		--self.btnJinjie:SetActive(true)
		local heroid = self.controller:GetHeroId()
		local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(heroid)
		local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
		local nextSkilldata
		if  curSkilldata.SuperSkill then
			nextSkilldata = self.controller:GetSkillTreeCfgData(curSkilldata.SuperSkill[1][2])
		end
		if jobdata and nextSkilldata and jobdata.JobStage < nextSkilldata.JobStage then
			self.btnSkillAdvance.redPointRoot:SetActive(false)
			self.btnSkillAdvance.lockBox:SetActive(true)
			self.btnSkillAdvance.costBox:SetActive(false)
			self.btnSkillAdvance.lockBox.text.text.text = I18N.SetLanguageValue('NeedAdvanceJob')
			return
			--需要进阶二转
		end
		local nextSkilldata
		if  curSkilldata.SuperSkill then
			nextSkilldata = self.controller:GetSkillTreeCfgData(curSkilldata.SuperSkill[1][2])
		end
		if nextSkilldata and nextSkilldata.OpenLevel  and  ManagerContainer.DataMgr.UserData:GetHeroLv(heroid) < nextSkilldata.OpenLevel then
			self.btnSkillAdvance.redPointRoot:SetActive(false)
			self.btnSkillAdvance.lockBox:SetActive(true)
			self.btnSkillAdvance.costBox:SetActive(false)
			self:RefreshLockInfo(self.btnSkillAdvance.lockBox, nextSkilldata.OpenLevel)
			return
			--角色等级不足
		end

		if  nextSkilldata.OpenNeedCost  then
			local openNeedCost = nextSkilldata.OpenNeedCost
			local canLearn = self:IsCanLearnOrAvance(openNeedCost,self.btnSkillAdvance.costBox)
				if canLearn then
					--可进阶
					self.btnSkillAdvance.redPointRoot:SetActive(true)
					local redPointParent = self.btnSkillAdvance.redPointRoot.transform
					if redPointParent then
						if redPointParent.childCount == 0 then
							self:CreateNormalRedPoint(redPointParent)
						end
					end
				else
					self.btnSkillAdvance.redPointRoot:SetActive(false)
				end
		else
			self.btnSkillAdvance.costBox:SetActive(false)
		end
		self.btnSkillAdvance.lockBox:SetActive(false)
	else
		self.btnSkillAdvance:SetActive(false)
		self.btnLearn:SetActive(false)
		self.btnUpgrade:SetActive(false)
	end
end

--判断是否能进阶技能或学习技能
function UISkillSettingsView:IsCanLearnOrAvance(openNeedCost,CostBox,isReset)
		--CostBox:SetActive(true)
		local canLearn = true
		local openNeedCosts = nil
		if type(openNeedCost[1]) == 'number' then
			if #openNeedCost > 1 then
				openNeedCosts = {openNeedCost}
			end
		else
			openNeedCosts = openNeedCost
		end
		for i = 1, #openNeedCosts do
			local itemCfgId = openNeedCosts[i][1]
			local itemNum = openNeedCosts[i][2]
			if i == 1 then
				if not self:RefreshCostInfo(CostBox, itemCfgId, itemNum, isReset) then
					canLearn = false
					break
				end
			else
				local ownNum = self.controller:GetOwnResCountByItemId(itemCfgId)
				if ownNum < itemNum then
					canLearn = false
					break
				end
			end
		end
	return canLearn
end

function UISkillSettingsView:CreateNormalRedPoint(parent)
	local redPoint = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, 'UIRedPointRP')
	if redPoint then
		redPoint.transform:SetParent(parent)
		redPoint.transform.localPosition = Vector3.zero
		redPoint.transform.localRotation = Quaternion.identity
		redPoint.transform.localScale = Vector3.one
		redPoint:SetActive(true)
	end
end

function UISkillSettingsView:RefreshLockInfo(lockBox, upgradeLv)
	local canUpgrade
	if (self.controller:GetHeroLv() < upgradeLv) then
		lockBox:SetActive(true)
		lockBox.text.text.text = I18N.SetLanguageValue('LvLock', upgradeLv)
		canUpgrade = false
	else
		lockBox:SetActive(false)
		canUpgrade = true
	end
	return canUpgrade
end

function UISkillSettingsView:RefreshCostInfo(costBox, itemCfgId, costNum, isReset)
	local canCost = false
	if not isReset then
		costBox:SetActive(true)
		costBox.ic.image.sprite = nil
	end


	local ownNum = self.controller:GetOwnResCountByItemId(itemCfgId)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
	if itemCfgData and not isReset then
		CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function (sprite)
			costBox.ic.image.sprite = sprite
		end, self, "CostItemIconAsyncIdx")
	end
	local content
	if costNum then
		if not itemCfgData or itemCfgData.ResType == Enum.ItemType.Coin or itemCfgData.ResType == Enum.ItemType.SkillExp or itemCfgData.ResType == Enum.ItemType.AdvanceSkillExp then
			content = tostring(costNum)
		else
			content = (tostring(ownNum) .. '/' .. tostring(costNum))
		end
		if ownNum < costNum then
			content = string.format(Constant.PinkColorText, content)
		else
			canCost = true
		end
	else
		content = '--'
	end
	if not isReset then
		costBox.text.text.text = content
	end
	return canCost
end

--------------------------------- 技能列表 End   ----------------------------------







---------------------------------- 技能槽 Start -----------------------------------

function UISkillSettingsView:RefreshSlotSkill(isResetIdx)
	local slotNum = self.controller:GetSlotNum()
	for i = 1, slotNum do
		local slotIdx = self.controller:GeSlotIdxById(i)
		local skillItem = self['skillItem' .. slotIdx]
		if skillItem then
			if isResetIdx then
				skillItem.transform:SetSiblingIndex(slotIdx - 1)
			end
			self:RefreshSlotSkillItem(skillItem, self.controller:GetSkillIdBySlotIdx(slotIdx), i)
		end
	end

	local num = self.controller:GetSlotVaildSkillNum()
	self.dragContainer.reorderableList.IsDraggable = (num >= 1)
end

function UISkillSettingsView:OnDragSlotSkillList(reorderableListEventStruct)
	local droppedObject = reorderableListEventStruct.DroppedObject
	local index = reorderableListEventStruct.ToIndex + 1
	local slotIdxs = {}
	-- 槽位上技能发生变化，需要更改技能描述等
	local slotNum = self.controller:GetSlotNum()
	for i = 1, slotNum do
		local skillItem = self['skillItem' .. i]
		if skillItem then
			if skillItem.gameObject == droppedObject then
				slotIdxs[index] = i
			else
				local sibilingIndex = skillItem.transform:GetSiblingIndex() + 1
				slotIdxs[sibilingIndex] = i
			end
		end
	end
	self.controller:UpdateSlotIdxs(slotIdxs)
end

function UISkillSettingsView:OnEngDragSkillList()
	self.controller:SendSlotSkillChange()
end

function UISkillSettingsView:RefreshSlotSkillItem(skillItem, skillId, slotId)
	local slotRoot = self.slotRoot['slot' .. slotId]
	local isUnlock = self.controller:GetSlotIsUnlock(slotId)
	if not isUnlock or not skillId or skillId <= 0 then
		skillItem:SetActive(false)
		local unlock, languageKey, content = self:CheckSlotUnlock(slotId, 1)
		if languageKey then
			if content then
				slotRoot.locked.textLocked.uILocalizeScript:SetContentAndValues(languageKey, content)
			else
				slotRoot.locked.textLocked.uILocalizeScript:SetContent(languageKey)
			end
		end
		slotRoot.locked:SetActive(not unlock)
		slotRoot.noSkill:SetActive(unlock)
		return
	end
	skillItem:SetActive(true)
	slotRoot.locked:SetActive(false)
	slotRoot.noSkill:SetActive(false)
	local skillLv = self.controller:GetSkilllv(skillId)
	if skillLv == 0 then
		skillLv = 1
	end
	local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLv)
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(skillId)
	local skillTreeCfgData = self.controller:GetSkillTreeCfgData(skillId)
	local quality = skillTreeCfgData and skillTreeCfgData.SkillQuality or 0
	if skillCfgData then
		CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
            skillItem.icon.image.sprite = sprite
		end, skillItem, "IconAsyncIdx")
		skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLv))
	else
		skillItem.icon.image.sprite = nil
		skillItem.num.text.text = ""
	end
	if quality ~= 0 then
		CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[quality], function (sprite)
			skillItem.frame.image.sprite = sprite
		end)
	else
		CommonUtil.LoadIcon(self, "FrameNew/frame_item_gray", function (sprite)
			skillItem.frame.image.sprite = sprite
		end)
	end
end

function UISkillSettingsView:CheckSlotUnlock(slotId, slotLv)
	local skillSlotCfgId = CommonUtil.GetSkillSlotCfgIdByIdxAndLv(slotId, slotLv)
	local skillSlotCfgData = ManagerContainer.CfgMgr:GetSkillSlotCfgById(skillSlotCfgId)
	if not skillSlotCfgData then
		return false
	end
	local condition
	if self.controller:IsLeaderHero() then
		condition = skillSlotCfgData.Condition
	else
		condition = skillSlotCfgData.ParterCondition
	end
	if not condition then
		return true
	end
	local levelData = self.controller:GetCurMapAndLevel()
	if levelData and condition >= levelData.Id then
		local condLevelData = ManagerContainer.CfgMgr:GetLevelDataById(condition)
        return false, 'SkillSlotUnlock_LevelId', {(condLevelData and I18N.SetLanguageValue(condLevelData.Name) or '')}
	end
	return true
end

function UISkillSettingsView:RefreshReplaceBtn()
	local show = self.isEquiping or false
	self.mask:SetActive(show)
	self.cancelReplace:SetActive(show)
	local slotNum = self.controller:GetSlotNum()
	for i = 1, slotNum do
		local btnReplace = self.slotLabel['slot' .. i].btnReplace
		if btnReplace then
			if show then
				local isUnlock = self.controller:GetSlotIsUnlock(i)
				btnReplace:SetActive(isUnlock)
				btnReplace.fx_ui_skillsettings_tihuan.uIParticle:PlayCachedParticalSystem(isUnlock)
			else
				btnReplace:SetActive(false)
			end
		end
	end
end

---------------------------------- 技能槽 End   -----------------------------------


function UISkillSettingsView:RefreshResetSkillLvBtn()
	local resetCount = ManagerContainer.DataMgr.UserData:GetSkillResetCount()
	self.btnReset:SetActive(resetCount >= 0)
end

function UISkillSettingsView:SendResetSkillLv(type)
	local itemCfgId, num = CommonUtil.GetResetSkillLvCost()
	local ownNum = self.controller:GetOwnResCountByItemId(itemCfgId)
	if ownNum < num then
		CommonUtil.ItemNotEnoughHandle(itemCfgId, self.uiData.id)
		return
	end
	local skillData = ManagerContainer.DataMgr.UserData:GetSkillData(self.controller:GetHeroId())
	--判断是否有技能可重置  type 为类型  1为重置进阶技能   0或nil 重置所有技能
	if  skillData:IsCanResetSkill(type) then
		self.controller:SendResetSkillLv(type)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(143)
	end
end

function UISkillSettingsView:SureJumpBuy()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, self.uiData.id)
end

function UISkillSettingsView:OnSkillEquipSignClick(button, params)
	local state = params[0]
	local idx = params[1]

	local heroId = self.controller:GetHeroId()
	local heroData = CommonUtil.GetHeroLogicDataByUid(heroId)
	local skillEquipData = self.controller:GetCurSkillEquipData()
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
	if not cfgData then return end
	if state == 1 then
		--灰态
		local data = cfgData.ArtifacFuncId[idx]
		local skillData = heroData.skillData
		local slotSkills = skillData.slotSkills
		local unLockSkillMap = skillData.unlockSkillMap

		local oldSkillId = heroId == 1 and data[2] or data[3]
		local condition1 = unLockSkillMap[oldSkillId] ~= nil

		local condition2 = false
		for i = 1, #slotSkills do
			if slotSkills[i].isUnlock and slotSkills[i].skillId == oldSkillId then
				condition2 = true
				break
			end
		end

		local condition3 = data ~= nil and idx <= skillEquipData.starLv 

		local data = {heroId = self.controller:GetHeroId(), skillEquipData = skillEquipData, idx = idx, condition1 = condition1, condition2 = condition2, condition3 = condition3}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactNotesTips, data)
	elseif state == 2 then
		--亮态

		local jobType
		if heroId == 1 then
			local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroData.configId)
			jobType = jobData.JobType
		else
			local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
			jobType = cfgData.JobType
		end

		local data = {{cfgId = skillEquipData.cfgId, jobType = jobType, logicData = skillEquipData, heroId = heroId, heroCfgId = heroData.configId, nickname = heroData.nickname}, Enum.ItemIEnterType.Bag, self.uiData.id}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactTips, data)
	end
end

return UISkillSettingsView

