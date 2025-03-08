local UIWorldBossBattleCtr = class("UIWorldBossBattleCtr", require("UICtrBase"))

function UIWorldBossBattleCtr:Init(view)
	self.view = view
end

function UIWorldBossBattleCtr:SetData(data)
	self.asyncIdx = 0
	self:InitBossData()
	if data == nil then return end
	self.data = data
end

function UIWorldBossBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIWorldBossBattleCtr:GetData()
	return self.data
end

function UIWorldBossBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.bossName = nil
	self.bossIcon = nil
	self.hpSegment = nil
	self.bossLife = nil
	self.bossMaxLife = nil
	self.bossLifeBarNum = nil
	self.bossSegmentPrecent = nil
end

function UIWorldBossBattleCtr:InitBossData()	
	local worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(self:GetCfgId(),0)
	if nil == worldBossCfgData then
		worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(self:GetCfgId(),1)
	end
	if worldBossCfgData then
		self.hpSegment = worldBossCfgData.HpSegment
		local summonId = worldBossCfgData.SummonId
        local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(summonId)
        if npcCfgData then
			self.bossName = npcCfgData.Name
			self.bossIcon = npcCfgData.Head
        end
	end
	self:SyncBossLife()
end

function UIWorldBossBattleCtr:GetCfgId()
	return ManagerContainer.DataMgr.WorldBossData:GetBattleBossId()
end

function UIWorldBossBattleCtr:GetHpSegment()
	return self.hpSegment or 1
end

function UIWorldBossBattleCtr:SyncBossLife()
	local life = ManagerContainer.DataMgr.WorldBossData:GetCurHp()
	local maxLife = ManagerContainer.DataMgr.WorldBossData:GetMaxHp()
	life = Mathf.Min(Mathf.Max(life, 0), maxLife)
	if self.bossLife == life and self.bossMaxLife == maxLife then
		return false
	end
	self.bossLife = life
	self.bossMaxLife = maxLife

	local hpSegment = self:GetHpSegment()
	local segmentMaxLife = maxLife / hpSegment
	local segmentRemainderLifeNum = Mathf.Ceil(life / segmentMaxLife)
	local segmentRemainderLife = life % segmentMaxLife
	if segmentRemainderLifeNum > 0 then
		if segmentRemainderLife <= 0 then
			segmentRemainderLife = segmentMaxLife
		end
	end
	local segmentPrecent = segmentRemainderLife / segmentMaxLife

	self.bossLifeBarNum = segmentRemainderLifeNum
	self.bossSegmentPrecent = segmentPrecent
	return true
end

function UIWorldBossBattleCtr:GetBossName()
	return self.bossName
end

function UIWorldBossBattleCtr:GetBossIcon()
	return self.bossIcon
end

function UIWorldBossBattleCtr:GetBossInitSkillParam()
	return ManagerContainer.LuaBossBattleMgr.bossSkillParam
end

function UIWorldBossBattleCtr:GetBossLifeBarNum()
	return self.bossLifeBarNum
end

function UIWorldBossBattleCtr:GetBossSegmentPrecent()
	return self.bossSegmentPrecent
end


function UIWorldBossBattleCtr:GetDefaultInBattleUIds()
	return ManagerContainer.DataMgr.WorldBossData:GetDefaultInBattleUIds()
end

function UIWorldBossBattleCtr:GetActorSystemByUID(uuid)
	return ManagerContainer.DataMgr.WorldBossData:GetActorSystemByUID(uuid)
end

function UIWorldBossBattleCtr:GetCurUserId()
	return ManagerContainer.DataMgr.UserData:GetUserId()
end

function UIWorldBossBattleCtr:SetWorldBossBattleUIReady()
	return ManagerContainer.DataMgr.WorldBossData:WorldBossBattleUIReady()
end

return UIWorldBossBattleCtr

