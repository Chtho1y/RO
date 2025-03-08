local UIRoleChangeJobCtr = class("UIRoleChangeJobCtr", require("UICtrBase"))

local isLeader = true
function UIRoleChangeJobCtr:Init(view)
	self.view = view
end

function UIRoleChangeJobCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	isLeader = data == 1
end

function UIRoleChangeJobCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleChangeJobCtr:GetData()
	return self.data
end

function UIRoleChangeJobCtr:SetIdx(idx)
	self.curIdx = idx
end

function UIRoleChangeJobCtr:SendChangeJobReq(jobId)
	local heroId = self.data
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HERO_CHANGE_JOB_REQ, {hero_id = heroId, job_id = jobId})
end

function UIRoleChangeJobCtr:GetHeroCurJobId()
	local logicData
	if isLeader then
		logicData = ManagerContainer.DataMgr.UserData:GetHeroData()
	else
		logicData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(self.data)
	end

	return logicData.configId
end

function UIRoleChangeJobCtr:GetNextJobDatas(jobId)
	local nextJobDatas
	if isLeader then
		nextJobDatas = ManagerContainer.CfgMgr:GetNextJobs(jobId)
	else
		nextJobDatas = ManagerContainer.CfgMgr:GetPartnerNextJobs(jobId)
	end
	self.nextJobDatas = nextJobDatas
	return nextJobDatas
end

function UIRoleChangeJobCtr:IsLeader()
	return isLeader
end

function UIRoleChangeJobCtr:GetSkillList()
	local skillList = nil
	local job = self.nextJobDatas[self.curIdx]
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

function UIRoleChangeJobCtr:GetSkillItemInfoByIndex(itemIndex)
	return self.skillList and self.skillList[itemIndex + 1] or nil
end

function UIRoleChangeJobCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.skillList = nil
	self.nextJobDatas = nil
end

return UIRoleChangeJobCtr

