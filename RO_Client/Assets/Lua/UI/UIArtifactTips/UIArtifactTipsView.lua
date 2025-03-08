local UIArtifactTipsView = require("UIArtifactTips/UIArtifactTipsView_Generate")
local IconItemCtr = require ("Common.IconItemCtr")

function UIArtifactTipsView:OnAwake(data)
	self.controller = require("UIArtifactTips/UIArtifactTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIArtifactTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_SLOT_LVUP_REFRESH, self, self.LvupSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_LV_UP_REFRESH, self, self.Refresh)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTOR_SERVER_CHANGE_ATTRS, self, self.RefreshAttr)
end

function UIArtifactTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIArtifactTipsView:Init()
	self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(false)
	self:Refresh()
end

function UIArtifactTipsView:Refresh()
	self:RefreshTop()
	self:RefreshCenter()

	local enterFrom = self.controller:GetEnterFrom()
	local fromRole = enterFrom == Enum.UIPageName.UIRoleMain1
	self.cost:SetActive(fromRole)
	self.btnBox:SetActive(fromRole)
	self.slotLvRoot:SetActive(fromRole)
	self.btnChange:SetActive(fromRole)
	self.labelBox:SetActive(fromRole)
	if fromRole then
		self:RefreshJobInfo()
		self:RefreshBottom()
	else

	end
end

function UIArtifactTipsView:LvupSuccess()
	self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(true)
	self:Refresh()
end

function UIArtifactTipsView:RefreshTop()
	local skillEquipData = self.controller:GetSkillEquipData()
	local cfgId = skillEquipData.cfgId
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

	IconItemCtr:SetData(self, self.skillEquipSlot.iconItem, skillEquipData, Enum.ItemIEnterType.Bag) 
	self.skillEquipSlot.iconItem:SetActive(true)
	self.textName.text.text = I18N.T(cfgData.Name)
	self.desTxt.text.text = I18N.T(itemCfgData.Describe)
end

function UIArtifactTipsView:RefreshJobInfo()
	local heroId = self.controller:GetHeroId()
	local heroCfgId = self.controller:GetHeroCfgId()
	local nickname = self.controller:GetHeroNickname()
	local jobIcon
	if heroId == 1 then
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroCfgId)
		jobIcon = jobData.JobIcon
	else
		local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroCfgId)
		jobIcon = heroCfgData.JobIcon
	end
	
	CommonUtil.LoadIcon(self, jobIcon, function (sprite)
		self.jobIcon.image.sprite = sprite
	end)

	local name
	if heroId == 1 then
		local cfgData = ManagerContainer.CfgMgr:GetJobDataById(heroCfgId)
		if nickname == nil then
			name = CommonUtil.GetHeroJobAndNameByUid(heroId, heroCfgId) 
		else
			if cfgData == nil then
				name = nickname
			else
				name = I18N.T(cfgData.JobName) .. nickname
			end
		end
	else
		name = CommonUtil.GetHeroJobAndNameByUid(heroId, heroCfgId) 
	end
	self.heroName.text.text = name
end

local function IsTheJob(jobData, skillEquipCfgData)
	if not jobData then
		return false
	end
	return jobData.JobType == skillEquipCfgData.JobType and jobData.JobBranch == skillEquipCfgData.JobBranch and jobData.JobStage == skillEquipCfgData.JobStage
end

function UIArtifactTipsView:RefreshCenter()
	local enterFrom = self.controller:GetEnterFrom()
	local canActive = enterFrom == Enum.UIPageName.UIRoleMain1 or enterFrom == Enum.UIPageName.UIArtifactNotesTips

	local heroId = self.controller:GetHeroId()
	local heroCfgId = self.controller:GetHeroCfgId()
	local jobData, skillData, slotSkills, unLockSkillMap

	local heroData = CommonUtil.GetHeroLogicDataByUid(heroId)
	if heroData then
		skillData = heroData.skillData
		slotSkills = skillData.slotSkills
		unLockSkillMap = skillData.unlockSkillMap

		if heroId == 1 then
			jobData = ManagerContainer.CfgMgr:GetJobDataById(heroCfgId)
		else
			jobData = ManagerContainer.CfgMgr:GetPartnerDataById(heroCfgId)
		end
	end

	local skillEquipData = self.controller:GetSkillEquipData()
	local cfgId = skillEquipData.cfgId
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
	for i = 1, 5 do
		local item = self["artifactPropertyItem"..i]
		local rp = item.rp
		local data = cfgData.ArtifacFuncId[i]
		item:SetActive(i <= skillEquipData.maxStarLv)
		if i <= skillEquipData.maxStarLv then
			local condition1, condition2, condition3 = false, false, false
			if heroId then
				local oldSkillId = heroId == 1 and data[2] or data[3]
				condition1 = unLockSkillMap[oldSkillId] ~= nil

				condition2 = false
				for i = 1, #slotSkills do
					if slotSkills[i].isUnlock and slotSkills[i].skillId == oldSkillId then
						condition2 = true
						break
					end
				end
			end
			condition3 = data ~= nil and i <= skillEquipData.starLv 
			item.star:SetActive(condition3)

			local content = I18N.T(cfgData.FuncDesc[i])
			if condition3 then
				content = string.format(Constant.GreenColorText,content)
			else
				content = string.format(Constant.GrayColorText, content)
			end
			
			local isCorrect = IsTheJob(jobData, cfgData)
			if not isCorrect then
				content = content..I18N.SetLanguageValue("ArtifactEmployTips", I18N.T(cfgData.JobName))
			end
			item.dsc.text.text = content
			item.btnActivation:SetActive((i == (skillEquipData.starLv + 1)) and canActive)
			self.uiBase:AddButtonUniqueEventListener(item.btnActivation.button, self, self.OnActivationClick, i)

			local canNotice = not condition1 or not condition2 or not condition3
			item.button.enabled = canNotice and canActive and isCorrect
			rp:SetActive(canNotice and canActive and isCorrect)
			self.uiBase:AddButtonUniqueEventListener(item.button, self, self.OnShowNotice, i, condition1, condition2, condition3)
		end
	end
end

function UIArtifactTipsView:RefreshBottom()
	local skillEquipData = self.controller:GetSkillEquipData()
	self.slotLv.text.text = skillEquipData.slotLv
	self:RefreshAttr()

	self:RefreshCost()
end

--刷新神威
function UIArtifactTipsView:RefreshAttr()
	local skillEquipData = self.controller:GetSkillEquipData()
	local num = skillEquipData.slotAttrs[Enum.HeroAttrType.RealHurt] or 0
	self.slotNum.text.text = "+"..num
end

local lackRes
function UIArtifactTipsView:RefreshCost()
	local skillEquipData = self.controller:GetSkillEquipData()
	local cost = ManagerContainer.CfgMgr:GetArtifactExpCfgCostByLv(skillEquipData.slotLv)
	self.cost:SetActive(cost ~= nil)
	self.btnBox:SetActive(cost ~= nil)
	lackRes = {}
	if cost then
		for i = 1, 2 do
			local item = self["cost"..i]
			local cst = cost[i]
			item:SetActive(cst ~= nil)
			if cst then
				local cfgData = ManagerContainer.CfgMgr:GetItemById(cst[1])
				if cfgData then
					item.icon.image.enabled = false
					local ownNum = CommonUtil.GetOwnResCountByItemId(cst[1])
					if cfgData.Icon and cfgData.Icon ~= '' then
						CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
							item.icon.image.sprite = sprite
							item.icon.image.enabled = true
						end, 'ItemIcon'..i)
					end
					if ownNum < cst[2] then
						lackRes[i] = {cst[1], true}
						item.text.text.text = string.format(Constant.PinkColorText, cst[2])
					else
						lackRes[i] = {cst[1], false}
						item.text.text.text = cst[2]
					end
				else
					item.text.text.text = ''
				end
			end
		end
	end
end

function UIArtifactTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIArtifactTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnUICloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnUICloseClick)

	self.uiBase:AddButtonEventListener(self.btnRefine.button, self, self.OnSlotUpClick)
	self.uiBase:AddButtonEventListener(self.btnChange.button, self, self.OnChangeClick)

	self.uiBase:AddButtonEventListener(self.rule.button, self, self.OnClickPlayRuleBtn)
end

function UIArtifactTipsView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "ArtifactNatureTips"})
end

function UIArtifactTipsView:OnUICloseClick()
	self:UIClose()
end

function UIArtifactTipsView:OnActivationClick(button, params)
	local skillEquipData = self.controller:GetSkillEquipData()
	local heroId = self.controller:GetHeroId()
	local heroCfgId = self.controller:GetHeroCfgId()
	local nickname = self.controller:GetHeroNickname()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactStarUp, {skillEquipData, heroId, heroCfgId, nickname})
end

function UIArtifactTipsView:OnShowNotice(button, params)
	local idx = params[0]
	local condition1 = params[1]
	local condition2 = params[2]
	local condition3 = params[3]

	local skillEquipData = self.controller:GetSkillEquipData()
	local heroId = self.controller:GetHeroId()
	local cfgId = skillEquipData.cfgId
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
	if not cfgData or not skillEquipData then return end

	local data = {heroId = heroId, skillEquipData = skillEquipData, idx = idx, condition1 = condition1, condition2 = condition2, condition3 = condition3}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactNotesTips, data)
end

function UIArtifactTipsView:OnChangeClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipList, self.controller:GetData())
end

function UIArtifactTipsView:OnSlotUpClick()
	for i = 1, #lackRes do
		if lackRes[i][2] then
			CommonUtil.ItemNotEnoughHandle(lackRes[i][1])
			return
		end
	end
	self.controller:SendSlotUpReq()
end

function UIArtifactTipsView:OnHide()

end

function UIArtifactTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIArtifactTipsView:OnClose()
end

function UIArtifactTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIArtifactTipsView

