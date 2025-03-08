local UITransPerformView = require("UIRoleMain/UITransPerformView_Generate")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local displayPos = Vector3(0, 0, -1)
local transBgPos = Vector3(1, -3.2, -20)
local transPar1Name = "UI/Fx_HeroTrans_01"
local transPar2Name = "UI/Fx_HeroTrans_02"
local transPar3Name = "UI/Fx_Hero_ZhoaMu"

local time1, time2, time3
function UITransPerformView:OnAwake(data)
	self.controller = require("UIRoleMain/UITransPerformCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UITransPerformView:AddEventListener()

end

function UITransPerformView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UITransPerformView:Init()
	local data = self.controller:GetData()
	
	self.isPlayEnd = false

	self.type = data[1]
	self.previewSystem = data[2]
	self.isLeader = data[3]
	self.viewSystem = data[4]
	self.oldId = data[5]
	self.newId = data[6]

	self.model.rawImage.texture = self.previewSystem:GetRenderTexture()

    self.curedSucceedAnim:SetActive(false)
	self.succeedAnim:SetActive(false)
	self.skillBox:SetActive(false)

	local timesStr = GlobalConfig.Instance:GetConfigStrValue(151)
	local times = CommonUtil.DeserializeGlobalStrToTable(timesStr)
	time1,time2,time3 = tonumber(times[1]), tonumber(times[2]), tonumber(times[3])

	self.loadSystem = MultiTypeAssetLoadSystem:new()
	self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)

	self:PreLoadTransParticles()

	--self.model.rectTransform.sizeDelta = Vector2(UnityEngine.Screen.height, UnityEngine.Screen.height)
end

function UITransPerformView:PreLoadTransParticles()
	self.loadSystem:RemoveLoadAllAsset()

	self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, transPar2Name)
	if self.type >= 2 then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, transPar1Name)
	elseif self.type == 1 then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, transPar3Name)
	end

	self.loadSystem:Begin()
end

function UITransPerformView:PreloadedAssets()
	self.transPar1Go = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, transPar1Name)
	self.transPar2Go = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, transPar2Name)
	self.transPar3Go = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, transPar3Name)

	if self.transPar1Go then
		self.transPar1Go:SetActive(false)
	end
	self.transPar2Go:SetActive(false)
	if self.transPar3Go then
		self.transPar3Go:SetActive(false)
	end

	self.model:SetActive(true)

	self:StartPerform()
end

function UITransPerformView:StartPerform()
	if self.type == 1 then
		self:RecruitDisplayStart()
	elseif self.type >= 2 then
		self:TransferDisplayStart()
	end
end

function UITransPerformView:RecruitDisplayStart()
	local partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(self.newId)
	self.title.text.text = I18N.SetLanguageValue("ChangeJobSkillShow", I18N.T(partnerData.JobName))

	self.viewSystem:RefreshView(Enum.RoleInEnvType.RoleMainView, self.newId, nil, nil, self, self.LoadModelCB)
end

function UITransPerformView:TransferDisplayStart()
	self.transferState = 1

	local curCfgData
	if self.isLeader then
		curCfgData = ManagerContainer.CfgMgr:GetJobDataById(self.newId)
	else
		curCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(self.newId)
	end
	self.title.text.text = I18N.SetLanguageValue("ChangeJobSkillShow", I18N.T(curCfgData.JobName))

	self:DisplayParticle(self.transPar1Go)
	if self.isLeader then
		local userData = ManagerContainer.DataMgr.UserData
		local roleId = CommonUtil.JobIdToRoleId(self.oldId, userData:GetSex())
		local viewData = CommonUtil.TableClone(userData:GetViewData())
		viewData.fashionData = nil
		self.viewSystem:RefreshView(Enum.RoleInEnvType.Transfer, roleId, viewData, nil, self, self.LoadModelCB)
	else
		self.viewSystem:RefreshView(Enum.RoleInEnvType.Transfer, self.oldId, nil, nil, self, self.LoadModelCB)
	end

	self.model.rawImage.texture = self.previewSystem:GetRenderTexture()
end

function UITransPerformView:LoadModelCB(model)
	self.curModel = model
	if self.previewSystem then
		self.previewSystem:UpdateGo(model)
	end
	--self.curModel.transform.parent = nil
	self.curModel.transform.position = displayPos
	self.curModel:SetActive(true)

	if self.type == 1 then
		self.viewSystem:RolePlayAni(self.curModel, "f_Injured")

		self.transform:DOScaleZ(1, time1):OnComplete(function()
			self:DisplayParticle(self.transPar3Go)
			self.viewSystem:RolePlayAni(self.curModel, "f_Save")
		end)
		self.transform:DOScaleZ(1, time2):OnComplete(function()
			self.curedSucceedAnim:SetActive(true)
		end)
		self.transform:DOScale(1, time3):OnComplete(function()
			self:RefreshJobSuccessSkills()
		end)
	else
		if self.transferState == 1 then
			--播放浮现动画
			self.viewSystem:RolePlayAni(self.curModel, "f_Transfer")

			self.transform:DOScale(1, time1):OnComplete(function()
				self.transferState = 2
				self:DisplayParticle(self.transPar2Go)

				self:Recycle()

				if self.isLeader then
					local userData = ManagerContainer.DataMgr.UserData
					local roleId = CommonUtil.JobIdToRoleId(self.newId, userData:GetSex())
					local viewData = CommonUtil.TableClone(userData:GetViewData())
					viewData.fashionData = nil
					self.viewSystem:RefreshView(Enum.RoleInEnvType.Transfer, roleId, viewData, nil, self, self.LoadModelCB)
				else
					self.viewSystem:RefreshView(Enum.RoleInEnvType.Transfer, self.newId, nil, nil, self, self.LoadModelCB)
				end
			end)

			self.transform:DOScaleZ(1, time2):OnComplete(function()
				self.succeedAnim:SetActive(true)
			end)
			self.transform:DOScale(1, time3):OnComplete(function()
				self:RefreshJobSuccessSkills()
			end)

		elseif self.transferState == 2 then
			--播放转职后展示动画
			self.viewSystem:RolePlayAni(self.curModel, "f_Transfer_show")
		end
	end
end

function UITransPerformView:Recycle()
	if self.previewSystem and self.curModel ~= nil then
		self.curModel:SetActive(false)
		self.previewSystem:RemoveGo(self.curModel)
		self.viewSystem:Recycle()
		self.curModel = nil
	end
end

function UITransPerformView:RefreshJobSuccessSkills()
	local skillList
	if self.type == 1 then
		local ctr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIRoleMain1)
		if ctr then
			skillList = ctr:GetSkillList()
		end
	elseif self.type == 2 then
		local ctr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIRoleChangeJob)
		if ctr then
			skillList = ctr:GetSkillList()
		end
	elseif self.type == 3 then
		local ctr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIRoleChangeJobTips)
		if ctr then
			skillList = ctr:GetSkillList()
		end
	end
	if skillList == nil then return end

	CommonUtil.LoopGridViewEleCreateNoItem(self, self.skillBox.scrollView.loopVerticalScrollRect, skillList, 0, self, self.RefreshSuccessSkill)

	self.skillBox:SetActive(true)
	self.isPlayEnd = true
end

function UITransPerformView:RefreshSuccessSkill(go, idx)
	local skillItemGo = go.transform:Find("SkillItem")
	local skillNameText = go.transform:Find("ItemTxt"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'SkillItem', skillItemGo)

	local skillData
	if self.type == 1 then
		local ctr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIRoleMain1)
		if ctr then
			skillData = ctr:GetSkillItemInfoByIndex(idx)
		end
	elseif self.type == 2 then
		local ctr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIRoleChangeJob)
		if ctr then
			skillData = ctr:GetSkillItemInfoByIndex(idx)
		end
	elseif self.type == 3 then
		local ctr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIRoleChangeJobTips)
		if ctr then
			skillData = ctr:GetSkillItemInfoByIndex(idx)
		end
	end
	if skillData then
		local skillId = skillData.SkillId
		local skillType = skillData.SkillType
		local skillLv = 1
		local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(skillType, skillId, skillLv)
		if skillCfgData then
			if skillCfgData.Icon then
				CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
					itemlua.icon.image.sprite = sprite
				end, itemlua, "SkillIconAsyncIdx")
			end
			itemlua.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLv))
			skillNameText.text = I18N.SetLanguageValue(skillCfgData.Name)
		end
	end
end

function UITransPerformView:DisplayParticle(go)
	self.previewSystem:UpdateGo(go)
	go:SetActive(true)
	go.transform.parent = nil
	go.transform.position = displayPos
end

function UITransPerformView:RecyclePars()
	if self.transPar1Go then
		ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, transPar1Name, self.transPar1Go)
	end
	ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, transPar2Name, self.transPar2Go)
	if self.transPar3Go then
		ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, transPar1Name, self.transPar3Go)
	end
	self.transPar1Go = nil
	self.transPar2Go = nil
	self.transPar3Go = nil
end

function UITransPerformView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UITransPerformView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.CloseSucceed)
end

function UITransPerformView:CloseSucceed()
	if not self.isPlayEnd then return end
	self:UIClose()
end

function UITransPerformView:OnHide()

end

function UITransPerformView:OnShow(data)
	self.controller:SetData(data)

end

function UITransPerformView:OnClose()
	--self:Recycle(self.newId)
	self.model:SetActive(false)

	if self.transPar1Go then
		self.transPar1Go:SetActive(false)
	end
	self.transPar2Go:SetActive(false)
	if self.transPar3Go then
		self.transPar3Go:SetActive(false)
	end

	DG.Tweening.DOTween.Kill(self.transform)
	self.skillBox.scrollView.loopVerticalScrollRect:ClearCells()
	if self.type == 1 then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UISTORY_CONDITION_TRIGGER, Enum.UIStoryCondType.PartnerGot, self.newId)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PARTNER_ACTIVE_SUCCESS_OVER)
	elseif self.type >= 2 then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.JOB_CHANGE_SUCCESS_OVER, self.type == 3)
	end
end

function UITransPerformView:OnDispose()
	self.controller:OnDispose()

	self.model.rawImage.texture = nil

	self:RecyclePars()
	if self.loadSystem then
		self.loadSystem:Dispose()
	end
	self.loadSystem = nil
	DG.Tweening.DOTween.Kill(self.transform)

	self.previewSystem = nil

	self.curModel = nil
	self.viewSystem = nil
	self.isPlayEnd = nil
end

return UITransPerformView

