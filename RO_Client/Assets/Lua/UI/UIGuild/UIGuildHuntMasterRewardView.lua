local UIGuildHuntMasterRewardView = require("UIGuild/UIGuildHuntMasterRewardView_Generate")

function UIGuildHuntMasterRewardView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildHuntMasterRewardCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildHuntMasterRewardView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_HUNT_MASTER_REWARD_CHANGED, self, self.OnGuildHuntMasterRewardChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_DISBAND_SUCCESS, self, self.OnGuildDisBandSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_QUIT_SUCCESS, self, self.OnGuildQuitSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_KICKOUT_SUCCESS, self, self.OnGuildKickoutSuccess)
end

function UIGuildHuntMasterRewardView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildHuntMasterRewardView:Init()
	self:RefreshView()
	-- 从服务器获得当前奖励级别
	local errorCode = self.controller:SendGuildMasterRewardReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIGuildHuntMasterRewardView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildHuntMasterRewardView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIGuildHuntMasterRewardView:OnHide()

end

function UIGuildHuntMasterRewardView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildHuntMasterRewardView:OnClose()
end

function UIGuildHuntMasterRewardView:OnDispose()
	self.controller:OnDispose()
end

function UIGuildHuntMasterRewardView:OnGuildDisBandSuccess()
	self:UIClose()
end

function UIGuildHuntMasterRewardView:OnGuildQuitSuccess()
	self:UIClose()
end

function UIGuildHuntMasterRewardView:OnGuildKickoutSuccess()
	self:UIClose()
end

function UIGuildHuntMasterRewardView:OnGuildHuntMasterRewardChanged(bossId)
	if self.controller:GetBossId() ~= bossId then return end
	self:RefreshView()
end

function UIGuildHuntMasterRewardView:OnClickCancelBtn()
	self:UIClose()
end

function UIGuildHuntMasterRewardView:OnClickHeadItem(_, params)
	local uid = params[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIGuildHuntMasterRewardView:OnClickIconItem(_, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIGuildHuntMasterRewardView:RefreshView()
	local data = self.controller:GetAwardData()
	if nil == data then
		self.emptyTips:SetActive(false)
		self.notEmpty:SetActive(false)
		return
	end
	if table_is_empty(data) or table_is_empty(data.playerBrief)  or data.damage <= 0 then
		self.emptyTips:SetActive(true)
		self.notEmpty:SetActive(false)
		self.desTxt.text.text = string.formatbykey('GuildHuntTip1')
		return
	end
	self.emptyTips:SetActive(false)
	self.notEmpty:SetActive(true)

	local playerBrief = data.playerBrief
	local heroData = nil
	local headFrame = nil
	local uid = nil
	if playerBrief then
		uid = playerBrief.uid
		headFrame = playerBrief.headFrame
		if int64.equals(uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
			headFrame = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
		end
		local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerBrief.configId)
		local jobIcon = ''
		if jobCfg then
			jobIcon = jobCfg.JobIcon
		end
		heroData = {Level = playerBrief.level, ProfessionIcon = jobIcon, HeadIcon = playerBrief.headPortraitName, IsHero = true}
		self.topDamageMember.nameTxt.text.text = tostring(playerBrief.nickName)
	else
		self.topDamageMember.nameTxt.text.text = ''
	end
	CommonUtil.SetPlayerHeadAndFrame(self, self.topDamageMember.headItem, heroData, false, headFrame, self, self.OnClickHeadItem, uid)
	self.topDamageMember.damageTxt.text.text = tostring(data.damage)

	local awards = self:GetMasterRewards(data.damage)
	if not awards then
		self.awardScrollView:SetActive(false)
		return
	end
	CommonUtil.LoopGridViewEleCreateNew(self, self.awardScrollView.loopHorizontalScrollRect, nil, awards, 0, self, self.UpdateAwardItem)
end

function UIGuildHuntMasterRewardView:UpdateAwardItem(itemLua, idx, itemData)
	if not itemLua or not itemData then return end
	CommonUtil.UpdateItemPrefab(self, itemLua, {cfgId = itemData[1], num = itemData[2]}, Enum.ItemIEnterType.Bag, self, self.OnClickIconItem)
end


function UIGuildHuntMasterRewardView:GetMasterRewards(damage)
	local bossId = self.controller:GetBossId()
	local bossCfgData = ManagerContainer.CfgMgr:GetGuildHuntBossCfgById(bossId)
	if not bossCfgData then return nil end
	if bossCfgData.BossType ~= Enum.GuildHuntBossType.Normal then
		return nil
	end
	local damageSegment = bossCfgData.DamageSegment
	if not damageSegment or damageSegment <= 0 then
		return nil
	end
	local rewardRanges = bossCfgData.RewardRange
	if not rewardRanges then
		return nil
	end
	local rewardRangeLength = #rewardRanges
	if rewardRangeLength < damageSegment then
		return nil
	end
	local masterRewards = bossCfgData.MasterReward
	if not masterRewards then
		return nil
	end
	local masterRewardLength = #masterRewards
	if masterRewardLength < damageSegment then
		return nil
	end
	local validIdx = nil
	for i = 1, rewardRangeLength do
		local rewardRange = rewardRanges[i]
		if damage < rewardRange[1] then
			break
		end
		validIdx = i
		if damage <= rewardRange[2] then
			break
		end
	end
	if not validIdx then return nil end
	local awardCfgId = masterRewards[validIdx]
	if not awardCfgId then return nil end
	local awardCfgData = ManagerContainer.CfgMgr:GetGuildHuntBossAwardCfgById(awardCfgId)
	if not awardCfgData then return nil end
	return awardCfgData.Reward
end

return UIGuildHuntMasterRewardView

