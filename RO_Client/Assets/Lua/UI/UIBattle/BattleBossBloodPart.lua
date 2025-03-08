local BattleBossBloodPart = class("BattleBossBloodPart")

function BattleBossBloodPart:ctor()
    self.lastLife = nil
end

function BattleBossBloodPart:InitGo(host,uiGo)
    self.minDeltaBlood = GlobalConfig.Instance:GetConfigFloatValue(137)
    self.host = host
    self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BattleBossBlood", uiGo)

    self:InitPanel()
end

function BattleBossBloodPart:InitPanel()
end

function BattleBossBloodPart:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Boss_Life,self,self.OnRefreshBossLife);
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Boss_Buff,self,self.OnRefreshBossBuff);
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Boss_Remove_Buff,self,self.OnRefreshRemoveBossBuff);
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_CLONE_NEW_BOSS,self,self.OnCloneNewBoss);
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_FIGHTING_START,self,self.OnFightingStart);
end

function BattleBossBloodPart:RemoveEventListener()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Boss_Life,self,self.OnRefreshBossLife);
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Boss_Buff,self,self.OnRefreshBossBuff);
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Boss_Remove_Buff,self,self.OnRefreshRemoveBossBuff);
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_CLONE_NEW_BOSS,self,self.OnCloneNewBoss);
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_FIGHTING_START,self,self.OnFightingStart);
end

function BattleBossBloodPart:AddUIEventListener()
    self.host.uiBase:AddButtonUniqueEventListener(self.viewLua.bossIcon.button, self, self.OnClickBoss)
end

function BattleBossBloodPart:OnClickBoss()
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleBossTips,self.bossActor)
end

function BattleBossBloodPart:Show(bossActor,bossName,life,maxLife,skillParam)
    self.bossActor = bossActor
    self.lastLife = life
    self.totalTime = GlobalConfig.Instance:GetConfigIntValue(3)
    self.leftTime = self.totalTime

	self.viewLua.bossBlood2.image.fillAmount = 1
	self.viewLua.bossBlood.image.fillAmount = 1
    self.viewLua.bossBloodNode.animator:Play("BossBloddShow")
    
    self:SetBossBattleInfo(bossName,bossActor.HeadIcon)
    self.viewLua:SetActive(true)
    self:ShowLeftTime(self.totalTime)
    self:AddEventListener()
end

function BattleBossBloodPart:Hide()
    self:RemoveTimer()
    self:HideBossBattleInfo()
    self.viewLua:SetActive(false)
    self:RemoveEventListener()
end

function BattleBossBloodPart:OnCloneNewBoss(bossName,life,maxLife,skillParam)
	self.lastLife = life
    
    self.viewLua.bossBlood2.image.fillAmount = 1
	self.viewLua.bossBlood.image.fillAmount = 1
	self.viewLua.bossName.text.text = bossName
end

function BattleBossBloodPart:ShowLeftTime(time)
    if self.viewLua == nil then
        return
    end

    if time > 0  then
        self.viewLua.leftTime.text.text = FormatTimeMS(time)
    else
        self.viewLua.leftTime.text.text = "00:00"
    end
end

function BattleBossBloodPart:OnFightingStart()
    self.totalTime = GlobalConfig.Instance:GetConfigIntValue(3)
    self:OnRefreshLeftTime()
    self.timeHandler = ManagerContainer.LuaTimerMgr:AddTimer(300, -1,self,self.OnRefreshLeftTime,nil);
end

function BattleBossBloodPart:OnRefreshLeftTime()
    self.leftTime = self.totalTime - LuaBattleBridge.GetFightingTime()
    self:ShowLeftTime(self.leftTime)
    if self.leftTime <= 0 then
        self.leftTime = 0
        self:RemoveTimer()
    end
end

function BattleBossBloodPart:RemoveTimer()
    if self.timeHandler and self.timeHandler ~= 0 then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.timeHandler);
        self.timeHandler = nil;
    end
end

function BattleBossBloodPart:SetBossBattleInfo(bossName,bossIcon)
	self.bossBuffs = {}
	self.skillCDTimers = {}
	self.bossBuffLoadHandlers = {}
    self.viewLua.bossName.text.text = bossName

    if bossIcon ~= nil and bossIcon ~= "" then
        CommonUtil.LoadIcon(self.host, bossIcon, function (sprite)
            self.viewLua.bossIcon.image.sprite = sprite
        end)
    end
    local natureCfg = ManagerContainer.CfgMgr:GetNatureDataById(self.bossActor.NatureId)
    if natureCfg ~= nil then
        CommonUtil.LoadIcon(self.host, natureCfg.Icon, function (sprite)
            self.viewLua.bossNature.image.sprite = sprite
        end)
    end
    
end

function BattleBossBloodPart:HideBossBattleInfo()
    LuaBattleBridge.SetTweenFillAmount(self.viewLua.bossBlood2,false)
    self:Clear()
end

function BattleBossBloodPart:OnRefreshBossLife(life,maxLife)
    local deltaLife = (self.lastLife - life)/maxLife
	if deltaLife > 0 and deltaLife < self.minDeltaBlood and life > 0 then  --掉血的时候，如果没有一定的数值不进行血条的变化
		return
	end

	self.lastLife = life

	self.viewLua.bossBlood.image.fillAmount = life / maxLife
	LuaBattleBridge.TweemFillAmount(self.viewLua.bossBlood2,life / maxLife,0.5)

    if life == 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Dead)
		-- self.viewLua.bossBloodNode.animator:Play("BossBloddClose");
	end
end

function BattleBossBloodPart:OnRefreshBossBuff(buffIcon,num)
    if self:HasBuffIconGo(buffIcon) then
        local go = self:GetBuffIconGo(buffIcon)
        if go ~= nil then
            local numTxt = go.transform:Find("num"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
            if numTxt ~= nil then
                if num > 0 then
                    numTxt.text = tostring(num)
                else
                    numTxt.text = ""
                end
            end
        end
		return
	end

	local buffGo =  UnityEngine.GameObject.Instantiate(self.viewLua.buffTemp)
    buffGo:SetActive(true)
    buffGo.transform:SetParent(self.viewLua.buffTemp.transform.parent)
    buffGo.transform.localScale = Vector3.one
    buffGo.transform.localPosition = Vector3.zero
    buffGo.name = buffIcon

    local temps =  string.split(buffIcon, '/')
    local buffDesc = ""
    if temps ~= nil and #temps > 0 then
        buffDesc = temps[#temps].."_Desc"
    end
    self.bossBuffs[#self.bossBuffs+1] = {icon = buffIcon, go = buffGo,desc = buffDesc}
    self:LoadBuffIcon(buffGo,buffIcon,num,buffDesc)
end

function BattleBossBloodPart:OnRefreshRemoveBossBuff(buffIcon)
	if self:HasBuffIconGo(buffIcon) then
		self:RemoveBuffIconGo(buffIcon)
	end
end

function BattleBossBloodPart:HasBuffIconGo(buffIcon)
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

function BattleBossBloodPart:GetBuffIconGo(buffIcon)
    if self.bossBuffs == nil then
        return nil
    end

    for i = 1, #self.bossBuffs do
        if self.bossBuffs[i].icon == buffIcon then
            return self.bossBuffs[i].go
        end
    end
	return nil
end

function BattleBossBloodPart:LoadBuffIcon(buffGo,buffIcon,num,desc)
    if buffGo == nil or buffIcon == nil then
		return
	end

	local img = buffGo.transform:Find("Image"):GetComponent(Enum.TypeInfo.Image)
	if img == nil then
		return
    end
    
    local numTxt = buffGo.transform:Find("num"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
    if numTxt ~= nil then
        if num > 0 then
            numTxt.text = tostring(num)
        else
            numTxt.text = ""
        end
    end

    local btn = buffGo.transform:GetComponent(Enum.TypeInfo.Button)
	if btn ~= nil then
		self.host.uiBase:AddButtonUniqueEventListener(btn, self, self.OnClickBuff,desc)
	end

	local handler =  CommonUtil.LoadIcon(self.host, buffIcon, function (sprite)
			self.bossBuffLoadHandlers[buffIcon] = nil
			if img ~= nil and sprite ~= nil then
				img.sprite = sprite
			end
		end)

	self.bossBuffLoadHandlers[buffIcon] = handler
end

function BattleBossBloodPart:OnClickBuff(btn,params)
    ManagerContainer.LuaUIMgr:ShowMinTips(params[0])
end

function BattleBossBloodPart:RemoveBuffIconGo(buffIcon)
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

function BattleBossBloodPart:RemoveBuffLoadHandler(buffIcon)
	if self.bossBuffLoadHandlers[buffIcon] ~= nil then
		ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(self.bossBuffLoadHandlers[buffIcon])
		self.bossBuffLoadHandlers[buffIcon] =  nil
	end
end

function BattleBossBloodPart:Clear()
    self:RemoveTimer()
    if self.bossBuffLoadHandlers ~= nil then
		for k,p in pairs(self.bossBuffLoadHandlers) do
			if p > 0 then
				ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(p)
			end
		end
		self.bossBuffLoadHandlers = nil
    end
    if self.bossBuffs ~= nil then
		for i = 1, #self.bossBuffs do
			CommonUtil.DestroyGO(self.bossBuffs[i].go)
        end
        self.bossBuffs = nil
	end
end

function BattleBossBloodPart:Dispose()
    self:Clear()
    -- 解决ID1001907
    self:RemoveEventListener()
    self.minDeltaBlood = 0
    self.host = nil
    self.viewLua = nil
end

return BattleBossBloodPart