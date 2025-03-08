local UISkillPreviewCtr = class("UISkillPreviewCtr", require("UICtrBase"))

function UISkillPreviewCtr:Init(view)
	self.view = view
end

---@param data table 数据结构为 {heroId = 1, id = 1}  id:主角为JobId, 伙伴为ParterId
function UISkillPreviewCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self:InitSkillList()
end

function UISkillPreviewCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISkillPreviewCtr:GetData()
	return self.data
end

function UISkillPreviewCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.skillList = nil
end

function UISkillPreviewCtr:GetHeroId()
	return self.data.heroId
end

function UISkillPreviewCtr:GetJobId()
	return self.data.id
end

function UISkillPreviewCtr:IsLeaderHero()
	return ManagerContainer.DataMgr.UserData:IsLeaderHero(self:GetHeroId())
end

function UISkillPreviewCtr:InitSkillList()
	local skillList = nil
	if self:IsLeaderHero() then
		local job = ManagerContainer.CfgMgr:GetJobDataById(self:GetJobId())
		skillList = ManagerContainer.CfgMgr:GetSkillTreeByFeature(job.JobType, job.JobBranch, job.JobStage)
	else
		local job = ManagerContainer.CfgMgr:GetPartnerDataById(self:GetJobId())
		skillList = ManagerContainer.CfgMgr:GetParterSkillTreeByFeature(job.JobType, job.ParterId)
	end
	if skillList then
		table.sort(skillList, function(a, b)
			return a.Pos < b.Pos
		end)
	end
	self.skillList = skillList
end

function UISkillPreviewCtr:GetSkillList()
	return self.skillList
end

function UISkillPreviewCtr:GetSkillListCount()
	return self.skillList and #self.skillList or 0
end

function UISkillPreviewCtr:GetSkillItemInfoByIndex(itemIndex)
	return self.skillList and self.skillList[itemIndex + 1] or nil
end

return UISkillPreviewCtr

