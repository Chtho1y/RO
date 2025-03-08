local UIRoleChangeJobTipsView = require("UIRoleMain/UIRoleChangeJobTipsView_Generate")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")

local roleViewSystem = nil
local previewSystem = nil

local oldJobId
local jobDatas
local pageToggleData = {}

local isLeader = true
local curIdx
local curModel

local canTransfer = false

local needCost = false
local enoughCost = true
local costKey
local costNum = 0

function UIRoleChangeJobTipsView:OnAwake(data)
	self.controller = require("UIRoleMain/UIRoleChangeJobTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRoleChangeJobTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_JOB_CHANGE_SUCCESS, function(id, isReplace)
		if isReplace then
			self:RefreshSuccess()
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.JOB_CHANGE_SUCCESS_OVER, function(isReplace)
        if isReplace then
            --self:CloseSelf()
			self:ClearToggles()
			self:Init(true)

			pageToggleData = {}
			CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.content, curIdx, self.SelectSameStageJob)
        end
	end)
end

function UIRoleChangeJobTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRoleChangeJobTipsView:Init(ignoreRandom)
	isLeader = self.controller:IsLeader()

	oldJobId = self.controller:GetHeroCurJobId()
	jobDatas = self.controller:GetSameStageJobDatas(oldJobId)

	if not ignoreRandom then
		curIdx = math.floor(math.random(1, #jobDatas))
		if isLeader then
			if jobDatas[curIdx].Id == oldJobId then
				curIdx = curIdx ~= 1 and 1 or curIdx + 1
			end
		else
			if jobDatas[curIdx].ParterId == oldJobId then
				curIdx = curIdx ~= 1 and 1 or 2
			end
		end
	end
	self:RefreshSameStageJobsToggle()

	if not previewSystem then
		previewSystem = PreviewSystem:new("Transfer", 512, 512)
		previewSystem:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
	end
	if not roleViewSystem then
		roleViewSystem = RoleViewSystem:new()
	end
	self:RefreshCost()
end

function UIRoleChangeJobTipsView:RefreshCost()
	local cost = self.controller:GetCurChangeCost()
	if cost == true then
		needCost = false
		enoughCost = true
		self.btnChangeJob.image:SetActive(false)
		self.btnChangeJob.numcost.text.text = I18N.T("Free")
	else
		self.btnChangeJob.image:SetActive(true)
		costKey = tonumber(cost[1])
		costNum = tonumber(cost[2])
		local cfgData = ManagerContainer.CfgMgr:GetItemById(costKey)
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				self.btnChangeJob.image.image.sprite = sprite
			end)
		end
		local ownRes = CommonUtil.GetOwnResCountByItemId(costKey)
		self.btnChangeJob.numcost.text.text = costNum
		if ownRes < costNum then
			CommonUtil.SetTextColor(self.btnChangeJob.numcost.text, Constant.RedColorText);
		end

		needCost = true
		enoughCost = ownRes >= costNum
	end
end

function UIRoleChangeJobTipsView:RefreshSameStageJobsToggle()
	self.toggles = {}
	for i = 1, #jobDatas do
		local go = UnityEngine.GameObject.Instantiate(self.roleJobToggleItem.gameObject)
		go.transform:SetParent(self.content.transform)
		go.transform.localPosition = Vector3.zero
		go.transform.localRotation = Quaternion.identity
		go.transform.localScale = Vector3.one
		go:SetActive(true)
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, self.roleJobToggleItem.prefabName, go)
		CommonUtil.LoadIcon(self, jobDatas[i].JobIcon, function (sprite)
			itemlua.jobIcon.image.sprite = sprite
		end, itemlua, "jobicon")
		itemlua.jobName.text.text = I18N.T(jobDatas[i].JobName)
		itemlua.toggle.group = self.content.toggleGroup
		itemlua.toggle.isOn = i == 1

		self.toggles[#self.toggles + 1] = itemlua
	end

	if #jobDatas > 6 then
		self.content.horizontalLayoutGroup.childAlignment = UnityEngine.TextAnchor.MiddleLeft
		self.content.rectTransform.anchorMin = Vector2 (0, 0.5);
		self.content.rectTransform.anchorMax = Vector2 (0, 0.5);
		self.content.rectTransform.pivot = Vector2 (0, 0.5);
	else
		self.content.horizontalLayoutGroup.childAlignment = UnityEngine.TextAnchor.MiddleCenter
		self.content.rectTransform.anchorMin = Vector2 (0.5, 0.5);
		self.content.rectTransform.anchorMax = Vector2 (0.5, 0.5);
		self.content.rectTransform.pivot = Vector2 (0.5, 0.5);
	end
	local pos = Vector3.zero
	pos.x = -curIdx * 128
	self.content.rectTransform.anchoredPosition = pos
end

function UIRoleChangeJobTipsView:SelectSameStageJob(index)
	curIdx = index
	self.controller:SetIdx(index)
	self:RefreshPreview()

	if isLeader then
		self.btnChangeJob:SetActive(jobDatas[curIdx].Id ~= oldJobId)
		self.desTxt:SetActive(jobDatas[curIdx].Id == oldJobId)
	else
		self.btnChangeJob:SetActive(jobDatas[curIdx].ParterId ~= oldJobId)
		self.desTxt:SetActive(jobDatas[curIdx].ParterId == oldJobId)
	end
end

function UIRoleChangeJobTipsView:Recycle(parterId)
	if curModel ~= nil then
		curModel:SetActive(false)
		previewSystem:RemoveGo(curModel)
		roleViewSystem:Recycle()
		curModel = nil
	end
end

function UIRoleChangeJobTipsView:RefreshPreview()
	local jobData = jobDatas[curIdx]
	self.desc.uILocalizeScript:SetContent(jobData.Desc)
	self:Recycle(jobData.ParterId)

	if isLeader then
		self:RefreshDefaultRoleView(Enum.RoleInEnvType.RoleMainView)
	else
		self:RefreshPartnerView(Enum.RoleInEnvType.RoleMainView, jobData.ParterId)
	end

	self.model.rawImage.texture = previewSystem:GetRenderTexture()
end

function UIRoleChangeJobTipsView:RefreshSuccess()
	local curCfgData = jobDatas[curIdx]
	self:Recycle(curCfgData.ParterId)

	local data = {3, previewSystem, isLeader, roleViewSystem, oldJobId, isLeader and curCfgData.Id or curCfgData.ParterId}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITransPerform, data, self.uiData.id)
end

function UIRoleChangeJobTipsView:RefreshOldRoleView(roleInEnvType)
	local userData = ManagerContainer.DataMgr.UserData
	local jobId = oldJobId
	local roleId = CommonUtil.JobIdToRoleId(jobId, userData:GetSex())
	local viewData = CommonUtil.TableClone(userData:GetViewData())
	self:RefreshRoleView(roleInEnvType, roleId, nil, nil)
end

function UIRoleChangeJobTipsView:RefreshDefaultRoleView(roleInEnvType)
	local userData = ManagerContainer.DataMgr.UserData
	local jobData = jobDatas[curIdx]
	local jobId = jobData.Id
	local roleId = CommonUtil.JobIdToRoleId(jobId, userData:GetSex())
	local viewData = CommonUtil.TableClone(userData:GetViewData())
	self:RefreshRoleView(roleInEnvType, roleId, nil, nil)
end

function UIRoleChangeJobTipsView:RefreshPartnerView(roleInEnvType, partnerCfgId)
	if partnerCfgId == nil then return nil end
	return roleViewSystem:RefreshView(roleInEnvType, partnerCfgId, nil, nil, self, self.LoadModelCB)
end

function UIRoleChangeJobTipsView:RefreshRoleView(roleInEnvType, roleId, viewData, extGoesShowData)
	roleViewSystem:RefreshView(roleInEnvType, roleId, viewData, extGoesShowData, self, self.LoadModelCB)
end

function UIRoleChangeJobTipsView:LoadModelCB(model)
	curModel = model
	if previewSystem then
		previewSystem:UpdateGo(model)
	end
	curModel.transform.position = Vector3.zero
	curModel:SetActive(true)
end

function UIRoleChangeJobTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRoleChangeJobTipsView:AddUIEventListener()
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.content, curIdx, self.SelectSameStageJob)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.btnSkill.button, self, self.OnClickSkillBtn)
	self.uiBase:AddButtonEventListener(self.btnChangeJob.button, self, self.OnChangeClick)
end

function UIRoleChangeJobTipsView:OnCloseClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleMain1, self.controller:GetData())
	self:UIClose()
end

function UIRoleChangeJobTipsView:OnClickSkillBtn()
	local heroId = self.controller:GetData()
	local curJobData = jobDatas[curIdx]
	if curJobData then
		local id = isLeader and curJobData.Id or curJobData.ParterId
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillPreview, {heroId = heroId, id = id})
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FunctionLock')
	end
end

function UIRoleChangeJobTipsView:OnChangeClick()
	if needCost then
		if not enoughCost then
			--ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(812)
			--return
		else
			local cfgData = ManagerContainer.CfgMgr:GetItemById(costKey)
			if cfgData then
				local jobData = jobDatas[curIdx]
				local data
				if isLeader then
					data = {"ChangeJob2", {I18N.T(cfgData.Name).."x"..costNum, I18N.T(jobData.JobName)}, jobData, self, self.ChangeSure}
				else
					data = {"ChangeJob2", {I18N.T(cfgData.Name).."x"..costNum, I18N.T(jobData.JobName)}, jobData, self, self.ChangeSure}
				end
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				return
			end
		end
	else
		local jobData = jobDatas[curIdx]
		local data
		if isLeader then
			data = {"ChangeJob3", {I18N.T(jobData.JobName)}, jobData, self, self.ChangeSure}
		else
			data = {"ChangeJob3", {I18N.T(jobData.JobName)}, jobData, self, self.ChangeSure}
		end
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
		return
	end
	self:ChangeSure()
end

function UIRoleChangeJobTipsView:ChangeSure()
	local jobData = jobDatas[curIdx]
	local jobId = isLeader and jobData.Id or jobData.ParterId

	self.controller:SendChangeJobReq(jobId)
end

function UIRoleChangeJobTipsView:CloseSelf()
	self:UIClose()
end

function UIRoleChangeJobTipsView:OnHide()

end

function UIRoleChangeJobTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIRoleChangeJobTipsView:ClearToggles()
	for _, v in pairs(self.toggles) do
		v.transform.parent = nil
		UnityEngine.GameObject.Destroy(v.gameObject)
		v:GenerateDestroy()
		v.uiParticle = nil
		v.gameObject = nil
		v.transform = nil
	end
	self.toggles = nil
end

function UIRoleChangeJobTipsView:OnClose()
	pageToggleData = nil

	self:ClearToggles()

	if self.loadSystem then
		self.loadSystem:Dispose()
	end

	self.loadSystem = nil

	DG.Tweening.DOTween.Kill(self.transform)

	self.model.uIEventTriggerListener.onDrag = nil
	pageToggleData = nil
	curModel = nil

	if previewSystem then
		previewSystem:Dispose(true)
	end
	previewSystem = nil
	if roleViewSystem then
		roleViewSystem:Dispose()
	end
	roleViewSystem = nil
end

function UIRoleChangeJobTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIRoleChangeJobTipsView

