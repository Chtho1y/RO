local UIWorldBossBattleView = require("UIWorldBoss/UIWorldBossBattleView_Generate")

local DOTween = DG.Tweening.DOTween
local LifeBarTweenSpeed = 0.5
local LifeBarTweenStopInterval = 0.1
local PlayerInOutAnimTime = 0.5

function UIWorldBossBattleView:OnAwake(data)
	self.controller = require("UIWorldBoss/UIWorldBossBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIWorldBossBattleView:AddEventListener()
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Skill,self,self.OnRefreshBossSkill)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Buff,self,self.OnRefreshBossBuff)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Boss_Remove_Buff,self,self.OnRefreshRemoveBossBuff)

	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Cast_Skill, self, self.OnPlayerSkillChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Fighter_Life, self, self.OnPlayerHpChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Fighter_Sp, self, self.OnPlayerSpChanged)

	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_HP_CHANGED, self, self.OnRefreshBossLife)
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_PLAYER_CHANGED, self, self.OnPlayerChanged)

	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.WORLD_BOSS_SERVER_KICKOUT_BATTLE, self, self.OnServerKickoutBattle)

	self.controller:SetWorldBossBattleUIReady()
end

function UIWorldBossBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIWorldBossBattleView:Init()
	self.serverKickoutBattle = false
	self:InitBossBlood()
	self:InitPlayerList()
end

function UIWorldBossBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_HP_CHANGED, self, self.OnRefreshBossLife)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_PLAYER_CHANGED, self, self.OnPlayerChanged)

	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.WORLD_BOSS_SERVER_KICKOUT_BATTLE, self, self.OnServerKickoutBattle)
end

function UIWorldBossBattleView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIWorldBossBattleView:OnHide()

end

function UIWorldBossBattleView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIWorldBossBattleView:OnClose()
end

function UIWorldBossBattleView:OnDispose()
	self.serverKickoutBattle = nil
	self:DisposeBossBlood()
	self:DisposePlayerList()

end

function UIWorldBossBattleView:OnServerKickoutBattle()
	self:OnRefreshBossLife()
	-- self:RefreshPlayerSuccess()
	self.serverKickoutBattle = true
end



--------------------------- WorldBoss ----------------------------

function UIWorldBossBattleView:InitBossBlood()
	self:DisposeBossBlood()
	self.bossBuffs = {}
	self.bossDebuffs = {}
	self.bossBuffLoadHandlers = {}
	self.bossBloodNode:SetActive(true)

	self.bossBloodNode.animator:Play("BossBloddShow")
	local segmentPrecent = self.controller:GetBossSegmentPrecent()
	self.bossBlood2.image.fillAmount = segmentPrecent
	self.bossBlood.image.fillAmount = segmentPrecent
	self.lastLifeBarNum = self.controller:GetBossLifeBarNum()
	self:RefreshBossLifeBarNum()

	self.bossName.text.text = self.controller:GetBossName()
	local bossIcon = self.controller:GetBossIcon()
	if bossIcon ~= nil and bossIcon ~= "" then
        CommonUtil.LoadIcon(self.host, bossIcon, function (sprite)
            self.bossIcon.image.sprite = sprite
        end)
    end
	-- self:OnRefreshBossSkill(self.controller:GetBossInitSkillParam())
end

function UIWorldBossBattleView:DisposeBossBlood()
	if self.bossBloodSequence then
		self.bossBloodSequence:Kill()
		self.bossBloodSequence = nil
	end
	-- self:ClearBossSkillTimer()
	if self.bossBuffs then
		for i = #self.bossBuffs, 1, -1 do
			self:RemoveBuffIconGo(self.bossBuffs[i].icon, false)
		end
	end
	self.bossBuffs = nil
	if self.bossDebuffs then
		for i = #self.bossDebuffs, 1, -1 do
			self:RemoveBuffIconGo(self.bossDebuffs[i].icon, true)
		end
	end
	self.bossDebuffs = nil
	if self.bossBuffLoadHandlers then
		for buffIcon, value in pairs(self.bossBuffLoadHandlers) do
			self:RemoveBuffLoadHandler(buffIcon, true)
		end
	end
	self.bossBuffLoadHandlers = nil
	self.lastLifeBarNum = nil
	if self.bossLifeAnimTimer and self.bossLifeAnimTimer.running then
		self.bossLifeAnimTimer:Stop()
	end
	self.bossLifeAnimTimer = nil
end

function UIWorldBossBattleView:RefreshBossLifeBarNum()
	local lifeBarNum = self.lastLifeBarNum
	if lifeBarNum > 1 then
		self.bossLifeBarNum.text.text = 'x' .. tostring(lifeBarNum)
		self.bossLifeBarNum:SetActive(true)
		self.bossBloodBack:SetActive(true)
	else
		self.bossLifeBarNum.text.text = ''
		self.bossLifeBarNum:SetActive(false)
		self.bossBloodBack:SetActive(false)
	end
end

function UIWorldBossBattleView:OnRefreshBossLife()
	if self.serverKickoutBattle then return end
	if not self.controller:SyncBossLife() then return end
	local lifeBarNum = self.controller:GetBossLifeBarNum()
	local segmentPrecent = self.controller:GetBossSegmentPrecent()

	-- 未来如果同步血量间隔很短，则需要另外启用定时器来做血量表现的更新
	-- 避免同帧，或者在时间很短内做频繁更新
	local seq = self.bossBloodSequence
	if seq then
		seq:Kill()
		seq = nil
	end
	seq = DOTween.Sequence()
	self.bossBloodSequence = seq

	local lastLifeBarNum = self.lastLifeBarNum
	self.lastLifeBarNum = lifeBarNum
	if lastLifeBarNum > lifeBarNum then
		-- boss减血了
		self.bossBlood.image.fillAmount = 0
		if lifeBarNum > 0 then
			local curPrecent = self.bossBlood2.image.fillAmount
			local lerpPercent = 1 - segmentPrecent
			local totalChangePrecent = curPrecent + lerpPercent
			local speedAverage = LifeBarTweenSpeed / totalChangePrecent
			seq:Append(self.bossBlood2.image:DOFillAmount(0, curPrecent * speedAverage))
			seq:AppendCallback(function()
				self.bossBlood.image.fillAmount = segmentPrecent
				self.bossBlood2.image.fillAmount = 1
				self:RefreshBossLifeBarNum()
			end)
			seq:Append(self.bossBlood2.image:DOFillAmount(segmentPrecent, lerpPercent * speedAverage))
			seq:AppendCallback(function()
				self.bossBlood.image.fillAmount = segmentPrecent
				self.bossBlood2.image.fillAmount = segmentPrecent
			end)
		else
			seq:Append(self.bossBlood2.image:DOFillAmount(0, LifeBarTweenSpeed))
			self.bossBloodBack:SetActive(false)
			seq:AppendCallback(function()
				self:RefreshBossLifeBarNum()
			end)
		end
	elseif lastLifeBarNum < lifeBarNum then
		-- boss加血了
		local curPrecent = self.bossBlood2.image.fillAmount
		local lerpPercent = 1 - curPrecent
		local totalChangePrecent = segmentPrecent + lerpPercent
		local speedAverage = (LifeBarTweenSpeed - LifeBarTweenStopInterval) / totalChangePrecent
		seq:Append(self.bossBlood2.image:DOFillAmount(1, lerpPercent * speedAverage))
		seq:AppendCallback(function()
			self.bossBlood.image.fillAmount = 1
			self.bossBlood2.image.fillAmount = 1
		end)
		seq:AppendInterval(LifeBarTweenStopInterval)
		seq:AppendCallback(function()
			self.bossBlood.image.fillAmount = 0
			self.bossBlood2.image.fillAmount = 0
			self:RefreshBossLifeBarNum()
		end)
		seq:Append(self.bossBlood2.image:DOFillAmount(segmentPrecent, segmentPrecent * speedAverage))
		seq:AppendCallback(function()
			self.bossBlood.image.fillAmount = segmentPrecent
			self.bossBlood2.image.fillAmount = segmentPrecent
		end)
	else
		local lastSegmentPrecent = self.bossBlood.image.fillAmount
		if lastSegmentPrecent > segmentPrecent then
			-- boss减血了
			self.bossBlood.image.fillAmount = segmentPrecent
			seq:Append(self.bossBlood2.image:DOFillAmount(segmentPrecent, LifeBarTweenSpeed))
			seq:AppendCallback(function()
				self.bossBlood.image.fillAmount = segmentPrecent
				self.bossBlood2.image.fillAmount = segmentPrecent
			end)
		elseif lastSegmentPrecent < segmentPrecent then
			-- boss加血了
			seq:Append(self.bossBlood2.image:DOFillAmount(segmentPrecent, LifeBarTweenSpeed))
			seq:AppendCallback(function()
				self.bossBlood.image.fillAmount = segmentPrecent
				self.bossBlood2.image.fillAmount = segmentPrecent
			end)
		-- else
			-- 上面已判定相同,理论上进不来这里
		end
	end

	-- if life == 0 then
	-- 	self.bossBloodNode.animator:Play("BossBloddClose");
	-- end
end

-- function UIWorldBossBattleView:OnRefreshBossSkill(skillParam)
-- 	if self.serverKickoutBattle then return end
-- 	if self.bossSkillNode == nil then
-- 		return
-- 	end
-- 	if skillParam == nil then
-- 		self:ClearBossSkillTimer()
-- 		self.bossSkillNode:SetActive(false)
-- 		return
-- 	end
-- 	self.bossSkillNode:SetActive(true)

-- 	CommonUtil.LoadIcon(self, skillParam.skillIcon, function (sprite)
-- 		self.bossSkillIcon.image.sprite = sprite
-- 		end, self, "Boss_SkillIconAsyncIdx")

-- 	self.bossSkillNode.forbidNode:SetActive(skillParam.IsForbidden)
-- 	self.bossSkillNode.extraNode:SetActive(skillParam.IsEnhance)

-- 	if skillParam.IsCasting then
-- 		self.bossSkillProgress:SetActive(false)
-- 		self.bossSkillCD:SetActive(false)

-- 		self.bossSkillNode.releaseNode:SetActive(true)
-- 		self.bossSkillNode.keepNode:SetActive(true)
-- 		self.bossSkillNode.waitNode:SetActive(false)

-- 		self:ClearBossSkillTimer()
-- 		self.bossSkillNode.animator:Play("BossSkillRelease")
-- 	else
-- 		if skillParam.IsForbidden then
-- 			self.bossSkillNode.animator:Play("SkillForbidden");
-- 		else
-- 			self.bossSkillNode.animator:Play("BossWait");
-- 		end

-- 		self:UpdateBossSkillCD(skillParam.cdTime,skillParam.cdTime)
-- 		self.bossSkillProgress:SetActive(true)
-- 		self.bossSkillCD:SetActive(true)
-- 		self.bossSkillNode.releaseNode:SetActive(false)
-- 		self.bossSkillNode.keepNode:SetActive(false)

-- 		local cnt = skillParam.cdTime * 1000 / 100
-- 		self:ClearBossSkillTimer()
-- 		self.bossSkillTimer = ManagerContainer.LuaTimerMgr:AddTimer(100, cnt, self, self.UpdateBossSkillCDTimer, {skillParam = skillParam,totalTime = skillParam.cdTime})
-- 	end
-- end

-- function UIWorldBossBattleView:UpdateBossSkillCDTimer(sequence,params)
-- 	local skillParam = params.skillParam
-- 	local totalTime = params.totalTime
-- 	skillParam.cdTime  = skillParam.cdTime - 0.1
-- 	local leftTime = skillParam.cdTime;
-- 	if leftTime < 0 then
-- 		leftTime = 0
-- 	end
-- 	self:UpdateBossSkillCD(leftTime,totalTime)
-- end

-- function UIWorldBossBattleView:ClearBossSkillTimer()
-- 	if self.bossSkillTimer ~= nil then
-- 		ManagerContainer.LuaTimerMgr:RemoveTimer(self.bossSkillTimer)
-- 		self.bossSkillTimer = nil
-- 	end
-- end

-- function UIWorldBossBattleView:UpdateBossSkillCD(leftTime,totalTime)
-- 	local time = CommonUtil.GetPreciseDecimal(leftTime,1)
-- 	if totalTime > 0 and time > 0 then
-- 		self.bossSkillProgress.image.fillAmount = time/totalTime
-- 		self.bossSkillCD.text.text = tostring(time)
-- 	else
-- 		self.bossSkillProgress.image.fillAmount = 0
-- 		self.bossSkillCD.text.text = ""
-- 	end
-- 	self.bossSkillNode.waitNode:SetActive(time == 0)
-- end

function UIWorldBossBattleView:OnRefreshBossBuff(buffIcon, num)
	if self.serverKickoutBattle then return end
	if self:HasBuffIconGo(buffIcon) then
        local info = self:GetBuffIconInfo(buffIcon)
        if info and info.text  then
			if num > 0 then
				info.text.text  = tostring(num)
			else
				info.text.text  = ""
			end
        end
		return
	end

	local buffGo =  UnityEngine.GameObject.Instantiate(self.buffTemp)
    buffGo:SetActive(true)
    buffGo.transform:SetParent(self.buffTemp.transform.parent)
    buffGo.transform.localScale = Vector3.one
    buffGo.transform.localPosition = Vector3.zero
	buffGo.name = buffIcon

	local image = nil
	local imageGo = buffGo.transform:Find("Image")
	if imageGo then
		image = imageGo:GetComponent(Enum.TypeInfo.Image)
	end
	local numText = nil
	local numTextGo = buffGo.transform:Find("num")
	if numTextGo then
		numText = numTextGo:GetComponent(Enum.TypeInfo.TextMeshProUGUI)
	end

	local temps =  string.split(buffIcon, '/')
    local buffDesc = ""
    if temps ~= nil and #temps > 0 then
        buffDesc = temps[#temps].."_Desc"
    end
	local info = {icon = buffIcon, go = buffGo, image = image, text = numText,desc = buffDesc }
    self.bossBuffs[#self.bossBuffs+1] = info
    self:LoadBuffIcon(info, num,buffDesc)
end

function UIWorldBossBattleView:OnRefreshRemoveBossBuff(buffIcon)
	if self:HasBuffIconGo(buffIcon) then
		self:RemoveBuffIconGo(buffIcon)
	end
end

function UIWorldBossBattleView:HasBuffIconGo(buffIcon)
    if self.bossBuffs == nil then
        return false
    end

    for i = 1, #self.bossBuffs do
        if self.bossBuffs[i].icon == buffIcon then
            return true
        end
    end
	return false
end

function UIWorldBossBattleView:GetBuffIconInfo(buffIcon)
    if self.bossBuffs == nil then
        return nil
    end

    for i = 1, #self.bossBuffs do
        if self.bossBuffs[i].icon == buffIcon then
            return self.bossBuffs[i]
        end
    end
	return nil
end

function UIWorldBossBattleView:LoadBuffIcon(info, num,desc)
    if not info or not info.go then
		return
	end

	if info.text then
		if num > 0 then
			info.text.text = tostring(num)
		else
			info.text.text = ''
		end
	end

	if not info.image then
		return
	end

	local btn = info.go.transform:GetComponent(Enum.TypeInfo.Button)
	if btn ~= nil then
		self.uiBase:AddButtonUniqueEventListener(btn, self, self.OnClickBuff,desc)
	end

	local handler =  CommonUtil.LoadIcon(self.host, info.icon, function (sprite)
			self.bossBuffLoadHandlers[info.icon] = nil
			info.image.sprite = sprite
		end)

	self.bossBuffLoadHandlers[info.icon] = handler
end

function UIWorldBossBattleView:OnClickBuff(btn,params)
	ManagerContainer.LuaUIMgr:ShowMinTips(params[0])
end

function UIWorldBossBattleView:RemoveBuffIconGo(buffIcon)
    if self.bossBuffs ~= nil then
        for i = 1, #self.bossBuffs do
            if self.bossBuffs[i].icon == buffIcon then
                self:RemoveBuffLoadHandler(buffIcon)
                CommonUtil.DestroyGO(self.bossBuffs[i].go)
                self.bossBuffs[i].go = nil
                table.remove(self.bossBuffs, i)
                return
            end
        end
    end
end

function UIWorldBossBattleView:RemoveBuffLoadHandler(buffIcon)
	if self.bossBuffLoadHandlers[buffIcon] ~= nil then
		ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(self.bossBuffLoadHandlers[buffIcon])
		self.bossBuffLoadHandlers[buffIcon] =  nil
	end
end

---------------------------- Player ------------------------------
function UIWorldBossBattleView:InitPlayerList()
	local playerCaches = {}
	local index = 1
	while (index ~= nil) do
		local player = self['player' .. index]
		if player then
			table.insert(playerCaches, player)
			index = index + 1
			player:SetActive(false)
		else
			index = nil
		end
	end
	self.playerCaches = playerCaches  -- 可以用于显示的玩家Go池
	self.playerMap = {}
	self.prePlayerIns = {}			-- 正在进入的玩家 （进入动画表现中的玩家）
	self.prePlayerOuts = {}			-- 正在退出的玩家 （退出动画表现中的玩家）
	self.playerInOutAnimTimer = Timer.New(function()
		self:EndPlayerInOutAnim()
	end, PlayerInOutAnimTime, -1)
	-- self.playerSkillCDTimer = {}	-- 玩家技能CD更新的定时器

	self.headsBox.slideHorizontalLayoutGroup.snapEnable = false

	local uids = self.controller:GetDefaultInBattleUIds()
	local hasError = false
	local num = #self.playerCaches
	if uids then
		for i = 1, #uids do
			if num <= 0 then
				LogError('[Wboy] player is not enough in prefab !!!')
				break
			end
			local uid = uids[i]
			local actorSystem = self.controller:GetActorSystemByUID(uid)
			if actorSystem then
				local player = self.playerCaches[num]
				table.remove(self.playerCaches, num)
				num = num - 1
				self.playerMap[uid] = player
				player:SetActive(true)
				self:SetPlayerInfoInOut(player, true, actorSystem)
			else
				hasError = true
			end
		end
	else
		hasError = true
	end
	-- 默认在场景中的玩家不动画进入
	self.headsBox.slideHorizontalLayoutGroup:CalculateLayoutInputHorizontal()
	self.headsBox.slideHorizontalLayoutGroup:SetLayoutHorizontal()
	self.headsBox.slideHorizontalLayoutGroup:CalculateLayoutInputVertical()
	self.headsBox.slideHorizontalLayoutGroup:SetLayoutVertical()
	self.headsBox.slideHorizontalLayoutGroup.snapEnable = true
	if hasError then
		LogError('[Wboy] Script execute order is error !!!')
	end
end

function UIWorldBossBattleView:DisposePlayerList()
	self.playerCaches = nil
	self.playerMap = nil
	self.prePlayerIns = nil
	self.prePlayerOuts = nil
	self.prePlayerInOut = nil
	if self.playerInOutAnimTimer and self.playerInOutAnimTimer.running then
		self.playerInOutAnimTimer:Stop()
	end
	self.playerInOutAnimTimer = nil
	-- for _, timer in pairs(self.playerSkillCDTimer) do
	-- 	if timer and timer.running then
	-- 		timer:Stop()
	-- 	end
	-- end
	-- self.playerSkillCDTimer = nil
end

-- function UIWorldBossBattleView:RefreshPlayerSuccess()
-- 	for _, player in pairs(self.playerMap) do
-- 		self:SetPlayerSkill(player)
-- 	end
-- end

function UIWorldBossBattleView:OnPlayerChanged(enters, exits)
	if self.serverKickoutBattle then return end
	self:EndPlayerInOutAnim(true)
	local uid
	for i = 1, #exits do
		uid = exits[i]
		local player = self.playerMap[uid]
		if player then
			table.insert(self.prePlayerOuts, player)
			player.position.animator:Play("PlayerClose")
			self:SetPlayerInfoInOut(player)
		end
		-- local timer = self.playerSkillCDTimer[uid]
		-- if timer and timer.running then
		-- 	timer:Stop()
		-- end
		-- self.playerSkillCDTimer[uid] = nil
	end

	local num = #self.playerCaches
	for i = 1, #enters do
		local enter = enters[i]
        uid = enter.uid
        local actorSystem = enter.data
		if actorSystem then
			if num <= 0 then
				break
			end
			--是否有变身ID
			if nil ~= actorSystem.userData.change_play_id and actorSystem.userData.change_play_id>0 then
				actorSystem:CreatePetBossActor(actorSystem.userData.change_play_id)   
			end
			local player = self.playerCaches[num]
			table.remove(self.playerCaches, num)
			num = num - 1
			self.playerMap[uid] = player
			table.insert(self.prePlayerIns, player)
			player:SetActive(true)
			player.position.animator:Play("PlayerShow")
			self:SetPlayerInfoInOut(player, true, actorSystem)
		end
	end
	if self.playerInOutAnimTimer.running then
		self.playerInOutAnimTimer.time = PlayerInOutAnimTime
	else
		self.playerInOutAnimTimer:Start()
	end

	self.headsBox.slideHorizontalLayoutGroup.snapEnable = false
	self.headsBox.slideHorizontalLayoutGroup:CalculateLayoutInputHorizontal()
	self.headsBox.slideHorizontalLayoutGroup:SetLayoutHorizontal()
	self.headsBox.slideHorizontalLayoutGroup:CalculateLayoutInputVertical()
	self.headsBox.slideHorizontalLayoutGroup:SetLayoutVertical()
	self.headsBox.slideHorizontalLayoutGroup.snapEnable = true
end

-- function UIWorldBossBattleView:OnPlayerSkillChanged(skillParam)
-- 	if self.serverKickoutBattle then return end
-- 	if skillParam == nil then return end
-- 	local uid = skillParam.actorId
-- 	local player = self.playerMap[uid]
-- 	if not player then return end
-- 	self:SetPlayerSkill(player, skillParam)
-- end

function UIWorldBossBattleView:OnPlayerHpChanged(uid, curHp, maxHp)
	if self.serverKickoutBattle then return end
	if uid == nil then return end
	local player = self.playerMap[uid]
	if not player then return end
	if maxHp <= 0 then
		local actorSystem = self.controller:GetActorSystemByUID(uid)
		if actorSystem then
			uid = actorSystem:GetUserId()
		end
		LogError('[Wboy] maxHp is error ' .. tostring(maxHp) .. '  ' .. tostring(uid))
		return
	end
	if curHp <= 0 then
		self:SetPlayerHp(player, 0)
	else
		self:SetPlayerHp(player, SDataUtil.InvConvert(curHp) / SDataUtil.InvConvert(maxHp))
	end
end

function UIWorldBossBattleView:OnPlayerSpChanged(uid, curSp, maxSp)
	if self.serverKickoutBattle then return end
	if uid == nil then return end
	local player = self.playerMap[uid]
	if not player then return end
	if maxSp <= 0 then
		local actorSystem = self.controller:GetActorSystemByUID(uid)
		if actorSystem then
			uid = actorSystem:GetUserId()
		end
		LogError('[Wboy] maxSp is error ' .. tostring(maxSp) .. '  ' .. tostring(uid))
		return
	end
	if curSp <= 0 then
		self:SetPlayerSp(player, 0)
	else
		self:SetPlayerSp(player, SDataUtil.InvConvert(curSp) / SDataUtil.InvConvert(maxSp))
	end
end

--- 结束所有正在表现进出动画
function UIWorldBossBattleView:EndPlayerInOutAnim(forceEnd)
	if forceEnd then
		if self.playerInOutAnimTimer.running then
			self.playerInOutAnimTimer.time = PlayerInOutAnimTime
		end
	else
		self.playerInOutAnimTimer:Stop()
	end
	for i = #self.prePlayerOuts, 1, -1 do
		local player = self.prePlayerOuts[i]
		self.prePlayerOuts[i] = nil
		player:SetActive(false)
		table.insert(self.playerCaches, player)
	end

	for i = #self.prePlayerIns, 1, -1 do
		self.prePlayerIns[i] = nil
	end
end

function UIWorldBossBattleView:SetPlayerInfoInOut(player, isIn, actorSystem)
	if isIn then
		local actorData = actorSystem:GetPlayerActorParam()
		local headFrameId = actorSystem:GetHeadFrameId()
		CommonUtil.SetPlayerHeadAndFrame(self, player.headBoxItem.headItem, actorData, false, headFrameId, self, self.OnClickPlayerHead, actorSystem:GetUserId())
		player.playerName.text.text = actorSystem:GetUserNickname()
		local userId = actorSystem:GetUserId()
		LuaBattleBridge.BeginTweenRecTransformPos(player.position, 0, Vector3(0,0,0))
		if int64.equals(userId, self.controller:GetCurUserId()) then
			LuaBattleBridge.BeginTweenRecTransformPos(player.position,0.1,Vector3(0,15,0))
		end
		player.transform:SetSiblingIndex(0)
		-- self:SetPlayerSkill(player)
		self:SetPlayerHp(player, 1)
		self:SetPlayerSp(player, 1)
	else
		-- self:SetPlayerSkill(player)
		self:SetPlayerHp(player, 0)
		self:SetPlayerSp(player, 0)
	end
end

function UIWorldBossBattleView:OnClickPlayerHead(btn,param)
	if self.serverKickoutBattle then return end
	local uid = param[0]
	if not uid then return end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

-- function UIWorldBossBattleView:SetPlayerSkill(player, skillInfo)
-- 	if not player then return end
-- 	local skill = player.skill
-- 	if not skill then return end
-- 	if not skillInfo then
-- 		skill:SetActive(false)
-- 		return
-- 	end
-- 	skill:SetActive(true)
-- 	local uid = skillInfo.actorId
-- 	local isForbidden = skillInfo.IsForbidden
-- 	local isCasting = skillInfo.IsCasting
-- 	local isEnhance = skillInfo.IsEnhance
-- 	local icon = skillInfo.skillIcon
-- 	local animName

-- 	skill.icon.image.sprite = nil

-- 	CommonUtil.LoadIcon(self, icon, function (sprite)
-- 		skill.icon.image.sprite = sprite
-- 	end, self, player.name .. "_SkillIconAsyncIdx")
-- 	skill.forbidden:SetActive(isForbidden)
-- 	skill.extra:SetActive(isEnhance)
-- 	if isCasting then
-- 		skill.release:SetActive(true)
-- 		skill.keep:SetActive(true)
-- 		skill.mask:SetActive(false)
-- 		skill.wait:SetActive(false)
-- 		skill.cD:SetActive(false)

-- 		local timer = self.playerSkillCDTimer[uid]
-- 		if timer and timer.running then
-- 			timer:Stop()
-- 			timer.cdCurTime = nil
-- 			timer.cdMaxTime = nil
-- 		end
-- 		animName = 'SkillRelease'
-- 	else
-- 		local cdTime = skillInfo.cdTime
-- 		if cdTime > 0 then
-- 			self:SetPlayerSkillCD(skill, cdTime, cdTime)
-- 			local timer = self.playerSkillCDTimer[uid]
-- 			if not timer then
-- 				timer = Timer.New(function()
-- 					self:UpdatePlayerSkillCD(uid)
-- 				end, 0.1, -1)
-- 				self.playerSkillCDTimer[uid] = timer
-- 			end
-- 			timer.cdCurTime = cdTime
-- 			timer.cdMaxTime = cdTime
-- 			if timer.running then
-- 				timer.time = timer.duration
-- 			else
-- 				timer:Start()
-- 			end
-- 		else
-- 			skill.mask.image.fillAmount = 0
-- 			skill.cD.text.text = ""
-- 			skill.wait:SetActive(true)
-- 		end
-- 		skill.release:SetActive(false)
-- 		skill.keep:SetActive(false)
-- 		skill.mask:SetActive(true)
-- 		skill.cD:SetActive(true)
-- 		animName = isForbidden and 'SkillForbidden' or 'SkillWait'
-- 	end

-- 	if player.headBoxItem and player.headBoxItem.animator then player.headBoxItem.animator:Play(animName) end
-- end

-- function UIWorldBossBattleView:UpdatePlayerSkillCD(uid)
-- 	local timer = self.playerSkillCDTimer[uid]
-- 	if not timer then return end
-- 	local cdMaxTime = timer.cdMaxTime or 0
-- 	if cdMaxTime <= 0 then
-- 		LogError("[Wboy] total skill cd is Error " .. tostring(cdMaxTime))
-- 		return
-- 	end
-- 	local cdCurTime
-- 	if timer.cdCurTime then
-- 		timer.cdCurTime = timer.cdCurTime - 0.1
-- 		cdCurTime = timer.cdCurTime
-- 	else
-- 		cdCurTime = 0
-- 	end
-- 	local player = self.playerMap[uid]
-- 	if not player or not player.skill then
-- 		-- 玩家已经不在了，删除这个定时器
-- 		timer:Stop()
-- 		self.playerSkillCDTimer[uid] = nil
-- 		return
-- 	end
-- 	self:SetPlayerSkillCD(player.skill, cdCurTime, cdMaxTime)
-- end

-- function UIWorldBossBattleView:SetPlayerSkillCD(skill, leftTime, totalTime)
-- 	local time = CommonUtil.GetPreciseDecimal(leftTime, 1)
-- 	if time > 0 then
-- 		skill.mask.image.fillAmount = time / totalTime
-- 		skill.cD.text.text = tostring(time)
-- 	else
-- 		skill.mask.image.fillAmount = 0
-- 		skill.cD.text.text = ""
-- 	end
-- 	skill.wait:SetActive(time == 0)
-- end

function UIWorldBossBattleView:SetPlayerHp(player, precent)
	if precent <= 0 then
		player.headBoxItem.deadNode:SetActive(true)
		-- player.skill:SetActive(false)
	else
		player.headBoxItem.deadNode:SetActive(false)
	end
	local hp = player.headBoxItem.hp
	local lastPrecent = hp.image.fillAmount
	if lastPrecent == precent then return end
	hp.image.fillAmount = precent
	if lastPrecent > 0.2 then
		if precent <= 0.2 then
			hp.image.sprite = hp.switchSprite:GetSprite("Bar_HP_red")
		end
	else
		if precent > 0.2 then
			hp.image.sprite = hp.switchSprite:GetSprite("Bar_HP")
		end
	end
end

function UIWorldBossBattleView:SetPlayerSp(player, precent)
	player.headBoxItem.sp.image.fillAmount = precent
end

return UIWorldBossBattleView

