local UIRoleChangeJobTipsCtr = class("UIRoleChangeJobTipsCtr", require("UICtrBase"))

local isLeader = true
local freeLv
local changeCost
function UIRoleChangeJobTipsCtr:Init(view)
	self.view = view
end

function UIRoleChangeJobTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	isLeader = data == 1

	local val = GlobalConfig.Instance:GetConfigStrValue(272)
	if val ~= "" and val ~= nil then
		freeLv = CommonUtil.DeserializeGlobalStrToTable(val)
	end

	local val = GlobalConfig.Instance:GetConfigStrValue(273)
	if val ~= "" and val ~= nil then
		changeCost = CommonUtil.DeserializeGlobalStrToTable(val)
	end
end

function UIRoleChangeJobTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleChangeJobTipsCtr:GetData()
	return self.data
end

function UIRoleChangeJobTipsCtr:SetIdx(idx)
	self.curIdx = idx
end

function UIRoleChangeJobTipsCtr:SendChangeJobReq(jobId)
	local heroId = self.data
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_REPLACE_JOB_REQ, {hero_id = heroId, job_id = jobId})
end

function UIRoleChangeJobTipsCtr:GetHeroCurJobId()
	local logicData
	if isLeader then
		logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
	else
		logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	end

	return logicData.configId
end

function UIRoleChangeJobTipsCtr:GetSameStageJobDatas(jobId)
	local jobDatas
	if isLeader then
		jobDatas = ManagerContainer.CfgMgr:GetSameStageJobs(jobId)
	else
		jobDatas = ManagerContainer.CfgMgr:GetPartnerSameStageJobs(jobId)
	end
	self.jobDatas = jobDatas
	return jobDatas
end

function UIRoleChangeJobTipsCtr:IsLeader()
	return isLeader
end

function UIRoleChangeJobTipsCtr:GetSkillList()
	local skillList = nil
	local job = self.jobDatas[self.curIdx]
	if isLeader then
		skillList = ManagerContainer.CfgMgr:GetSkillTreeByFeature(job.JobType, job.JobBranch, job.JobStage)
	else
		skillList = ManagerContainer.CfgMgr:GetParterSkillTreeByFeature(job.JobType, job.ParterId)
	end
	if skillList then
		table.sort(skillList, function(a, b)
			return a.Pos < b.Pos
		end)
	end
	self.skillList = skillList
	return skillList
end

function UIRoleChangeJobTipsCtr:GetSkillItemInfoByIndex(itemIndex)
	return self.skillList and self.skillList[itemIndex + 1] or nil
end

function UIRoleChangeJobTipsCtr:GetCurChangeCost()
	local logicData
	local curStage = 1
	if isLeader then
		logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(logicData.configId)
		curStage = jobData.JobStage
	else
		logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
		local jobData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
		curStage = jobData.JobStage
	end
	local curLv = logicData.baseLevel
	if not freeLv and not changeCost then
		return true
	end
	if curStage <= 1 and curLv <= tonumber(freeLv[curStage]) then
		return true
	end
	return changeCost[curStage]
end

function UIRoleChangeJobTipsCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.skillList = nil
	self.jobDatas = nil
end

return UIRoleChangeJobTipsCtr

