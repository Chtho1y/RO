local UIRoleChangeJobView = require("UIRoleMain/UIRoleChangeJobView_Generate")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")

local roleViewSystem = nil
local previewSystem = nil

local oldJobId
local nextJobDatas
local pageToggleData = {}

local isLeader = true
local curIdx
local curModel

local WeightVals = {
	150,250,250,250,150
}
local totalWeight

local isMax = false
function UIRoleChangeJobView:OnAwake(data)
	self.controller = require("UIRoleMain/UIRoleChangeJobCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRoleChangeJobView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_JOB_CHANGE_SUCCESS, function(id, isReplace)
		if not isReplace then
			self:RefreshSuccess()
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.JOB_CHANGE_SUCCESS_OVER, function(isReplace)
		if not isReplace then
			self:CloseSelf()
		end
	end)
end

function UIRoleChangeJobView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRoleChangeJobView:Init()
	self:Refresh()
end

function UIRoleChangeJobView:Refresh()
	if not roleViewSystem then
		roleViewSystem = RoleViewSystem:new()
	end

	curIdx = 1
	isLeader = self.controller:IsLeader()

	self.boardImage:SetActive(true)
	self.btnChangeJob:SetActive(true)

	oldJobId = self.controller:GetHeroCurJobId()
	local jobData
	if isLeader then
		jobData = ManagerContainer.CfgMgr:GetJobDataById(oldJobId)
		self.boardImage:SetActive(jobData.JobType > 0)
		self.btnChangeJob:SetActive(jobData.JobType > 0)
	else
		jobData = ManagerContainer.CfgMgr:GetPartnerDataById(oldJobId)
	end
	if jobData.JobStage >= GlobalConfig.Instance:GetConfigIntValue(103) then
		self.jobMax:SetActive(true)
		self.changeJob:SetActive(false)
		self.dscBox:SetActive(false)
		self.btnChange:SetActive(false)
		self.btnChange2:SetActive(false)
		isMax = true
		return
	else
		self.changeJob:SetActive(true)
		self.jobMax:SetActive(false)
		self.dscBox:SetActive(true)
		self.btnChange:SetActive(true)
		self.btnChange2:SetActive(false)
	end

	nextJobDatas = self.controller:GetNextJobDatas(oldJobId)

	self:RefreshNextJobsToggle()

	if not previewSystem then
		previewSystem = PreviewSystem:new("Transfer", 512, 512)
		previewSystem:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
	end

	if isLeader then
		if nextJobDatas then
			local nextJob = nextJobDatas[1]
			if nextJob ~= nil then
				local jobStage = nextJob.JobStage
				if jobStage == 1 then
					totalWeight = 0
					local minNum = math.min(#nextJobDatas, #WeightVals)
					for i = 1, minNum do
						totalWeight = totalWeight + WeightVals[i]
					end

					math.randomseed(os.time())
					local rdm = math.random(0, totalWeight)
					local curWeight = 0
					for i = 1, minNum do
						curWeight = curWeight + WeightVals[i]
						if rdm <= curWeight then
							curIdx = i
							return
						end
					end
				end
			end
		end
	end
end

function UIRoleChangeJobView:RefreshNextJobsToggle()
	local idx = 0
	if nextJobDatas then
		idx = #nextJobDatas
		for i = 1, idx do
			local item = self["job"..i]
			item:SetActive(true)
			local jobData = nextJobDatas[i]
			CommonUtil.LoadIcon(self, jobData.JobIcon, function (sprite)
				item.jobIcon.image.sprite = sprite
			end)
			item.jobName.text.text = I18N.T(jobData.JobName)
		end
	end
	for i = idx + 1, 5 do
		self["job"..i]:SetActive(false)
	end
end

function UIRoleChangeJobView:SelectNextJob(index)
	if isMax then return end

	curIdx = index
	self.controller:SetIdx(index)
	self:RefreshPreview()
	self:RefreshNextJobConds()
end

function UIRoleChangeJobView:Recycle()
	if curModel ~= nil then
		curModel:SetActive(false)
		previewSystem:RemoveGo(curModel)
		roleViewSystem:Recycle()
		curModel = nil
	end
end

function UIRoleChangeJobView:RefreshPreview()
	local jobData = nextJobDatas[curIdx]
	self.desc.uILocalizeScript:SetContent(jobData.Desc)
	self:Recycle()

	if isLeader then
		self:RefreshDefaultRoleView(Enum.RoleInEnvType.RoleMainView)
	else
		self:RefreshPartnerView(Enum.RoleInEnvType.RoleMainView, jobData.ParterId)
	end

	self.model.rawImage.texture = previewSystem:GetRenderTexture()
end

function UIRoleChangeJobView:RefreshSuccess()
	local curCfgData = nextJobDatas[curIdx]
	self:Recycle(curCfgData.ParterId)

	local data = {2, previewSystem, isLeader, roleViewSystem, oldJobId, isLeader and curCfgData.Id or curCfgData.ParterId}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITransPerform, data, self.uiData.id)
end

function UIRoleChangeJobView:CloseSucceed()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self, self.controller:GetData())
end

function UIRoleChangeJobView:RefreshOldRoleView(roleInEnvType)
	local userData = ManagerContainer.DataMgr.UserData
	local jobId = oldJobId
	local roleId = CommonUtil.JobIdToRoleId(jobId, userData:GetSex())
	self:RefreshRoleView(roleInEnvType, roleId, nil, nil)
end

function UIRoleChangeJobView:RefreshDefaultRoleView(roleInEnvType)
	local userData = ManagerContainer.DataMgr.UserData
	local jobData = nextJobDatas[curIdx]
	local jobId = jobData.Id
	local roleId = CommonUtil.JobIdToRoleId(jobId, userData:GetSex())
	self:RefreshRoleView(roleInEnvType, roleId, nil, nil)
end

function UIRoleChangeJobView:RefreshPartnerView(roleInEnvType, partnerCfgId)
	if partnerCfgId == nil then return nil end

	return roleViewSystem:RefreshView(roleInEnvType, partnerCfgId, nil, nil, self, self.LoadModelCB)
end

function UIRoleChangeJobView:RefreshNextJobConds()
	self.scrollView.loopVerticalScrollRect:ClearCells()
	if not nextJobDatas or not nextJobDatas[curIdx] then
		self.btnChange:SetActive(false)
		self.btnChange2:SetActive(false)
		return
	end
	local beforeId = nextJobDatas[curIdx].BeforeJobId
	if beforeId == 0 then
		self.btnChange:SetActive(false)
		self.btnChange2:SetActive(false)
		return
	end

	local uid = self.controller:GetData()
	local jobData
	if isLeader then
		jobData = ManagerContainer.CfgMgr:GetJobDataById(beforeId)
	else
		jobData = ManagerContainer.CfgMgr:GetPartnerDataById(beforeId)
	end

	CommonUtil.LoopGridViewEleCreate(self, self.scrollView.loopVerticalScrollRect, self.content.gridLayoutGroup, jobData.ChangeCond, 0, function (itemLua, idx)
		local condId = jobData.ChangeCond[idx + 1]
		local task = ManagerContainer.DataMgr.TaskDataNew:GetChangeJobTaskData(uid, condId)
		if task ~= nil then
			local data = {condId = condId, tasks = task}
			CommonUtil.UpdateItemPrefab(self, itemLua, data)
		end

		itemLua:SetActive(task ~= nil)
	end)

	local itemCosts = jobData.ItemCost
	local show = false
	if itemCosts then
		for i = 1, #itemCosts do
			local itemCost = itemCosts[i]
			if itemCost then
				local itemCfgId = itemCost[1]
				local costNum = itemCost[2]
				local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
				if itemCfgData then
					self.btnChange2.ic.image.enabled = false
					self.btnChange2.ic.image.sprite = nil
					CommonUtil.LoadIcon(self, itemCfgData.MiniIcon, function(sprite)
						if sprite then
							self.btnChange2.ic.image.sprite = sprite
							self.btnChange2.ic.image.enabled = true
						end
					end)
					local ownNum = CommonUtil.GetOwnResCountByItemId(itemCfgId)
					local content = (tostring(ownNum) .. '/' .. tostring(costNum))
					if ownNum < costNum then
						content = string.format(Constant.PinkColorText, content)
					end
					self.btnChange2.cost.text.text = content
					show = true
				end
			end
		end
	end
	self.btnChange:SetActive(not show)
	self.btnChange2:SetActive(show)
end

function UIRoleChangeJobView:RefreshRoleView(roleInEnvType, roleId, viewData, extGoesShowData)
	roleViewSystem:RefreshView(roleInEnvType, roleId, viewData, extGoesShowData, self, self.LoadModelCB)
end

function UIRoleChangeJobView:LoadModelCB(model)
	curModel = model
	if previewSystem then
		previewSystem:UpdateGo(model)
	end

	curModel:SetActive(true)
end

function UIRoleChangeJobView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRoleChangeJobView:CloseSelf()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self, self.controller:GetData())
end

function UIRoleChangeJobView:RefreshNoticeUI()
	local jobData = nextJobDatas[curIdx]
	--self.dscBox.jobName.uILocalizeScript:SetContent(jobData.Name)
	--self.noticeUI:SetActive(true)
    local data
    if isLeader then
        data = {"ChangeJob", {I18N.T(jobData.JobName)}, jobData, self, self.ChangeSure}
    else
        data = {"ChangeJob1", {I18N.T(jobData.JobName)}, jobData, self, self.ChangeSure}
    end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIRoleChangeJobView:CloseSureUI()
	self.noticeUI:SetActive(false)
end

function UIRoleChangeJobView:SendChange()
	if not self:CheckChangeJobCont() then
		return
	end
	self:RefreshNoticeUI()
end

function UIRoleChangeJobView:SendChange2()
	if not self:CheckChangeJobCont() then
		return
	end
	self:RefreshNoticeUI()
end

function UIRoleChangeJobView:CheckChangeJobCont()
	local beforeId = nextJobDatas[curIdx].BeforeJobId
	if beforeId == 0 then return false end
	local uid = self.controller:GetData()
	local jobData
	if isLeader then
		jobData = ManagerContainer.CfgMgr:GetJobDataById(beforeId)
	else
		jobData = ManagerContainer.CfgMgr:GetPartnerDataById(beforeId)
	end
	local changeConds = jobData.ChangeCond
	if changeConds then
		for i = 1, #changeConds do
			local changeCond = changeConds[i]
			if changeCond then
				local task = ManagerContainer.DataMgr.TaskDataNew:GetChangeJobTaskData(uid, changeCond)
				if task then
					if task.state == Enum.TaskStateType.NoCompeleted then
						ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('ConditionOut')
						return false
					end
				end
			end
		end
	end
	local itemCosts = jobData.ItemCost
	if itemCosts then
		for i = 1, #itemCosts do
			local itemCost = itemCosts[i]
			if itemCost then
				local itemCfgId = itemCost[1]
				local costNum = itemCost[2]
				if CommonUtil.ResLackErrorNotice(itemCfgId, costNum) then
					return false
				end
			end
		end
	end
	return true
end

function UIRoleChangeJobView:ChangeSure()
	if not self:CheckChangeJobCont() then
		return
	end
	local jobData = nextJobDatas[curIdx]
	local jobId = isLeader and jobData.Id or jobData.ParterId
	self.controller:SendChangeJobReq(jobId)
end

function UIRoleChangeJobView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.group, curIdx, self.SelectNextJob)

	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.CloseSelf)

	--self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.CloseSureUI)
	self.uiBase:AddButtonEventListener(self.btnChange.button, self, self.SendChange)
	self.uiBase:AddButtonEventListener(self.btnChange2.button, self, self.SendChange2)

	--self.uiBase:AddButtonEventListener(self.btnSure.button, self, self.ChangeSure)
	--self.uiBase:AddButtonEventListener(self.btnCancle.button, self, self.CloseSureUI)

	self.uiBase:AddButtonEventListener(self.btnSkill.button, self, self.OnClickSkillBtn)
	self.uiBase:AddButtonEventListener(self.btnTest.button, self, self.RefreshSuccess)
	self.uiBase:AddButtonEventListener(self.btnChangeJob.button, self, self.OnChangeSameStageJob)

	self.model.uIEventTriggerListener.onDrag = function()
		local deltaX = self.model.uIEventTriggerListener.currentEventData.delta.x
		curModel.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
	end
end

function UIRoleChangeJobView:OnHide()

end

function UIRoleChangeJobView:OnShow(data)
	self.controller:SetData(data)
	self:Refresh()
	self:SelectNextJob(curIdx)
end

function UIRoleChangeJobView:OnClose()
	pageToggleData = nil

	if self.loadSystem then
		self.loadSystem:Dispose()
	end

	self.loadSystem = nil

	DG.Tweening.DOTween.Kill(self.transform)

	self.scrollView.loopVerticalScrollRect:ClearCells()
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

function UIRoleChangeJobView:OnDispose()
	self.controller:OnDispose()
end

function UIRoleChangeJobView:OnClickSkillBtn()
	local heroId = self.controller:GetData()
	local curJobData = nextJobDatas[curIdx]
	if curJobData then
		local id = isLeader and curJobData.Id or curJobData.ParterId
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISkillPreview, {heroId = heroId, id = id})
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FunctionLock')
	end
end

function UIRoleChangeJobView:OnChangeSameStageJob()
	local canChanged = false
	if isLeader then
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(oldJobId)
		canChanged = jobData.JobStage > 0
	else
		local jobData = ManagerContainer.CfgMgr:GetPartnerDataById(oldJobId)
		canChanged = jobData.JobStage > 1
	end
	if not canChanged then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChangeJobDscTxt_5")
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleChangeJobTips, self.controller:GetData(), self.uiData.id)
end

return UIRoleChangeJobView

