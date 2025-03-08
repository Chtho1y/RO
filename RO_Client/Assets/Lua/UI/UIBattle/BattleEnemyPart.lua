local BattleEnemyPart = class("BattleEnemyPart")

function BattleEnemyPart:ctor()
end

function BattleEnemyPart:InitGo(host,uiGo)
    self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BattleEnemy", uiGo)
end

function BattleEnemyPart:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Enemy_Fighter_Life,self,self.RefreshFighterLife);
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Enemy_Fighter_Sp,self,self.RefreshFighterSp);
end

function BattleEnemyPart:RemoveEventListener()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Enemy_Fighter_Life,self,self.RefreshFighterLife);
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Enemy_Fighter_Sp,self,self.RefreshFighterSp);
end

function BattleEnemyPart:AddUIEventListener()
end

function BattleEnemyPart:Show(enemyName,members, isLeftTime, totalTime)
	self.enemyName = enemyName
    self.enemyMembers = members
    self:HidePlayerNodes()
	self:AddEventListener()
	self.actorHeadMapping = {}

	for i =1, #self.enemyMembers do
		local actor = self.enemyMembers[i]
		local go = self:GetHeadGo(i)
		self.actorHeadMapping[tostring(actor.ID)] = go
		self:SetPlayerData(actor.ID,go.headBoxItemNew,self.enemyMembers[i])
	end
	if isLeftTime then
		self.viewLua.leftTime:SetActive(true)
		self.viewLua.infinite:SetActive(false)
		self:InitLeftTimer()
		if totalTime then
			self.remainLeftTime = totalTime
			self.totalTime = totalTime
		else
			self.remainLeftTime = 0
			self.totalTime = 0
		end
	else
		self.viewLua.leftTime:SetActive(false)
		self.viewLua.infinite:SetActive(true)
		self:DisposeLeftTimer()
	end
	self.viewLua.enemyNameTxt.text.text = self.enemyName
	self.viewLua:SetActive(true)
end

function BattleEnemyPart:HidePlayerNodes()
	for i =1, 4 do
		local go = self:GetHeadGo(i)
		go.headBoxItemNew:SetActive(false)
		go.headBoxItemNew.headItem.head.button.interactable = false
	end
end

function BattleEnemyPart:Hide()
    self:RemoveEventListener()
	self.viewLua:SetActive(false)
	self:HidePlayerNodes()
	self:Clear()
end

function BattleEnemyPart:SetPlayerData(uid,playerNode,actorData)
    CommonUtil.SetPlayerHeadAndFrame(self.host,playerNode.headItem,actorData,true,actorData.HeadFrameId)
	self:RefreshFighterLife(uid,actorData.Life,actorData.Life)
	self:RefreshFighterSp(uid,actorData.Sp,actorData.Sp)
	playerNode.deadNode:SetActive(false)
	playerNode:SetActive(true)
end

function BattleEnemyPart:RefreshFighterLife(actorId,life,maxLife)
	local headGo = self:GetActorHeadGo(actorId)
	CommonUtil.SetFighterLife(headGo,life,maxLife)
end

function BattleEnemyPart:RefreshFighterSp(actorId,sp,maxSp)
	local headGo = self:GetActorHeadGo(actorId)
	CommonUtil.SetFighterSp(headGo,sp,maxSp)
end

function BattleEnemyPart:GetHeadGo(idx)
	if idx == 1 then
		return self.viewLua.playerNode1
	end

	if idx == 2 then
		return self.viewLua.playerNode2
	end

	if idx == 3 then
		return self.viewLua.playerNode3
	end

	if idx == 4 then
		return self.viewLua.playerNode4
	end

	return nil
end

function BattleEnemyPart:GetActorHeadGo(actorId)
	if self.actorHeadMapping == nil then
		return nil
	end

	if actorId == nil then
		return nil
	end
	
	return self.actorHeadMapping[tostring(actorId)].headBoxItemNew
end

function BattleEnemyPart:InitLeftTimer()
	if not self.leftTimer then
		self.leftTimer = Timer.New(slot(self.RefreshLeftTimer, self), 0.3, -1)
	end
	if not self.leftTimer.running then
		self.leftTimer:Start()
	end
end

function BattleEnemyPart:DisposeLeftTimer()
	if self.leftTimer then
		self.leftTimer:Stop()
		self.leftTimer = nil
	end
end

function BattleEnemyPart:RefreshLeftTimer()
	self.remainLeftTime = self.totalTime - LuaBattleBridge.GetFightingTime()
    self:ShowLeftTime(self.remainLeftTime)
    if self.remainLeftTime <= 0 then
        self.remainLeftTime = 0
        self:DisposeLeftTimer()
    end
end

function BattleEnemyPart:ShowLeftTime(time)
    if self.viewLua == nil then
        return
    end

    if time > 0  then
        self.viewLua.leftTime.text.text = FormatTimeMS(time)
    else
        self.viewLua.leftTime.text.text = "00:00"
    end
end

function BattleEnemyPart:Clear()
    self.enemyMembers = nil
	self.actorHeadMapping = nil
	self:DisposeLeftTimer()
end

function BattleEnemyPart:Dispose()
	self:Clear()
    self.host = nil
    self.viewLua = nil
end

return BattleEnemyPart
