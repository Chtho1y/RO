local UIArtifactPoolCtr = class("UIArtifactPoolCtr", require("UICtrBase"))

function UIArtifactPoolCtr:Init(view)
	self.view = view
end

function UIArtifactPoolCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIArtifactPoolCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIArtifactPoolCtr:GetData()
	return self.data
end

function UIArtifactPoolCtr:SendSkillEquipPoolReq()
	ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipPoolReq()
end

function UIArtifactPoolCtr:RefreshRandomPool()
	self.curRandomPool = ManagerContainer.DataMgr.SkillEquipData:GetCurRandomPool()
	if not self.curRandomPool then
		return false
	else
		self.curId = self.curRandomPool.curId
		local seconds = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(self.curRandomPool.nextBegin)
		self.nextRemainDay = math.ceil(seconds/86400)
		-- LogHRWarning("seconds   "..seconds.."    self.nextRemainDay  "..self.nextRemainDay)
		self.curRandomPoolDatas = {}
		local pool = self.curRandomPool.poolIdList
		for i = 1, #pool do
			local data = {}
			data.id = 0
			data.cfgId = pool[i]
			data.starLv =0
			local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(data.cfgId)
			data.maxStarLv = cfgData.ArtifactMaxLevel
			data.quality = cfgData.Quality
			data.jobType = cfgData.JobType
			data.jobBranch = cfgData.JobBranch
			data.jobStage = cfgData.JobStage

			self.curRandomPoolDatas[#self.curRandomPoolDatas + 1] = data
		end
		
		self.nextRandomPoolDatas = {}
		pool = self.curRandomPool.nextPool
		for i = 1, #pool do
			local data = {}
			data.id = 0
			data.cfgId = pool[i]
			data.starLv =0
			local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(data.cfgId)
			data.maxStarLv = cfgData.ArtifactMaxLevel
			data.quality = cfgData.Quality
			data.jobType = cfgData.JobType
			data.jobBranch = cfgData.JobBranch
			data.jobStage = cfgData.JobStage

			self.nextRandomPoolDatas[#self.nextRandomPoolDatas + 1] = data
		end

		return true
	end
end

function UIArtifactPoolCtr:GetOpenedRandomPoolLength()
	return self.curRandomPoolDatas and #self.curRandomPoolDatas or 0
end

function UIArtifactPoolCtr:GetNextRandomPoolLength()
	return self.nextRandomPoolDatas and #self.nextRandomPoolDatas or 0
end

function UIArtifactPoolCtr:GetOpendRandomPoolDataByIdx(idx)
	return self.curRandomPoolDatas and self.curRandomPoolDatas[idx + 1] or nil
end

function UIArtifactPoolCtr:GetNextRandomPoolDataByIdx(idx)
	return self.nextRandomPoolDatas and self.nextRandomPoolDatas[idx + 1] or nil
end

function UIArtifactPoolCtr:GetCurId()
	return self.curId
end

function UIArtifactPoolCtr:GetNextRemainDay()
	return self.nextRemainDay
end

function UIArtifactPoolCtr:OnDispose()
	self.curRandomPool = nil
	self.curRandomPoolDatas = nil
	self.nextRandomPoolDatas = nil

	self.data = nil
	self.view = nil
end

return UIArtifactPoolCtr

