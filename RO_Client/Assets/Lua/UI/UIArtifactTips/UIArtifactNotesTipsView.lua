local UIArtifactNotesTipsView = require("UIArtifactTips/UIArtifactNotesTipsView_Generate")

local curSkill
function UIArtifactNotesTipsView:OnAwake(data)
	self.controller = require("UIArtifactTips/UIArtifactNotesTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIArtifactNotesTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIArtifactNotesTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIArtifactNotesTipsView:Init()
	self:Refresh()
end

function UIArtifactNotesTipsView:Refresh()
	local skillEquipData = self.controller:GetSkillEquipData()

	local idx = self.controller:GetIdx()
	local cfgId = skillEquipData.cfgId
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
	if not cfgData or not skillEquipData then return end

	local heroId = self.controller:GetHeroId()

	local heroData = CommonUtil.GetHeroLogicDataByUid(heroId)
	if not heroData then return end

	local skillData = heroData.skillData
	local slotSkills = skillData.slotSkills
	local unLockSkillMap = skillData.unlockSkillMap

	local data = cfgData.ArtifacFuncId[idx]

	if not data then return end

	local oldSkillId = heroId == 1 and data[2] or data[3]

	local skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(oldSkillId)
	if not skillTreeCfgData then
		skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(oldSkillId)
	end

	if not skillTreeCfgData then return end

	local lastSkillId = skillTreeCfgData.beforeSkill
	if unLockSkillMap[oldSkillId] then
		curSkill = oldSkillId
	else
		curSkill = lastSkillId
	end
	
	local oldSkillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(lastSkillId)
	local newSkillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(oldSkillId)
	if not oldSkillCfgData or not newSkillCfgData then return end

	local condition1 = self.controller:GetCondition1State()
	if not condition1 then
		condition1 = unLockSkillMap[oldSkillId] ~= nil
	end

	local condition2 = self.controller:GetCondition2State()
	if not condition2 then
		condition2 = false
		for i = 1, #slotSkills do
			if slotSkills[i].isUnlock and slotSkills[i].skillId == oldSkillId then
				condition2 = true
				break
			end
		end
	end

	local condition3 = self.controller:GetCondition3State()
	if not condition3 then
		condition3 = data ~= nil and idx <= skillEquipData.starLv 
	end

	self.condition1.actived:SetActive(condition1)
	self.condition1.dsc.text.text = condition1 and I18N.SetLanguageValue("ArtifactTips1", I18N.T(newSkillCfgData.Name))
									or I18N.SetLanguageValue("ArtifactTips2", I18N.T(newSkillCfgData.Name), I18N.T(oldSkillCfgData.Name))

	self.condition2.actived:SetActive(condition2)
	self.condition2.dsc.text.text = condition2 and I18N.SetLanguageValue("ArtifactTips3", I18N.T(newSkillCfgData.Name))
									or  I18N.SetLanguageValue("ArtifactTips4", I18N.T(newSkillCfgData.Name))


	self.condition3.actived:SetActive(condition3)
	self.condition3.dsc.text.text = condition3 and I18N.T("ArtifactTips5")
									or I18N.T("ArtifactTips6")

	local tipsUI = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIArtifactTips)
	if tipsUI then
		self.condition1.btnGoto:SetActive(not condition1)
		self.condition2.btnGoto:SetActive(not condition2)
		self.condition3.btnGoto:SetActive(false)
	else
		local isSkillSettingUI = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UISkillSettings)
		self.condition1.btnGoto:SetActive(not condition1 and not isSkillSettingUI)
		self.condition2.btnGoto:SetActive(not condition2 and not isSkillSettingUI)
		self.condition3.btnGoto:SetActive(not condition3 and isSkillSettingUI ~= nil)
	end
end

function UIArtifactNotesTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIArtifactNotesTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnUICloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnUICloseClick)

	self.uiBase:AddButtonEventListener(self.condition1.btnGoto.button, self, self.OnGotoSkillSetting)
	self.uiBase:AddButtonEventListener(self.condition2.btnGoto.button, self, self.OnGotoSkillSetting)
	self.uiBase:AddButtonEventListener(self.condition3.btnGoto.button, self, self.OnGotoArtifactTips)
end

function UIArtifactNotesTipsView:OnUICloseClick()
	self:UIClose()
end

function UIArtifactNotesTipsView:OnGotoSkillSetting()
	if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UISkillSettings) then
		local heroId = self.controller:GetHeroId()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillSettings, {heroId, curSkill})
		ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIArtifactTips)
	end
	self:OnUICloseClick()
end

function UIArtifactNotesTipsView:OnGotoArtifactTips()
	if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIArtifactTips) then
		local heroId = self.controller:GetHeroId()
		local heroData = CommonUtil.GetHeroLogicDataByUid(heroId)
		local skillEquipData = self.controller:GetSkillEquipData()
		local jobType
		if heroId == 1 then
			local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroData.configId)
			jobType = jobData.JobType
		else
			local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
			jobType = cfgData.JobType
		end

		local data = {{cfgId = skillEquipData.cfgId, jobType = jobType, logicData = skillEquipData, heroId = heroId, heroCfgId = heroData.configId, nickname = heroData.nickname}, Enum.ItemIEnterType.SkillEquip, self.uiData.id}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactTips, data)
	end
	self:OnUICloseClick()
end

function UIArtifactNotesTipsView:OnHide()

end

function UIArtifactNotesTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIArtifactNotesTipsView:OnClose()
	curSkill = nil
end

function UIArtifactNotesTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIArtifactNotesTipsView

