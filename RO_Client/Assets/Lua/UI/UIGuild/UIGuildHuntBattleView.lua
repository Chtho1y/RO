local UIGuildHuntBattleView = require("UIGuild/UIGuildHuntBattleView_Generate")
local BattleHeadsBoxPart = require("UIBattle/BattleHeadsBoxPart")


-- local GUILD_HUNT_BATTLE_SPEED_KEY = 'GUILD_HUNT_BATTLE_SPEED'

local BOX_ANIM_TIME = 0.86
local MinChangePercent = 0.1

function UIGuildHuntBattleView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildHuntBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildHuntBattleView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_HUNT_BOSS_HURT_CHANGED, self, self.OnHurtChanged)
end

function UIGuildHuntBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildHuntBattleView:Init()
	local isDemon = self.controller:GetData()
	self.huntGroup:SetActive(not isDemon)
	self.demonGroup:SetActive(isDemon)
	if not isDemon then
		LuaBattleBridge.TweemFillAmount(self.bossBlood, 0, 0)
		self.bossBlood2.image.fillAmount = 0
		self:RefreshAwards()
	else
		self.lastharm = 0
		local sommonId = ManagerContainer.DataMgr.GuildDemonData:GetSommonId()
		local npcCfg = ManagerContainer.CfgMgr:GetNpcCfgById(sommonId)
		if npcCfg then
			CommonUtil.LoadIcon(self, Constant.Natural_Icons..npcCfg.NatureId, function(sprite)
				self.bossNature.image.sprite = sprite
			end)
			CommonUtil.LoadIcon(self, npcCfg.Head, function(sprite)
				self.bossIcon.image.sprite = sprite
			end)
		end
		--Constant.Natural_Icons
	end
	self.controller:InitData()
	self.hurtChanged = true
	self:RefreshBlood()

	if not self.bloodTimer then
		self.bloodTimer = FrameTimer.New(slot(self.RefreshBlood, self), 1, -1)
	end
	if not self.bloodTimer.running then
		self.bloodTimer:Start()
	end

	-- local curSpeed = ManagerContainer.LuaGameMgr:GetGameSpeed()
	-- local saveSpeed = ManagerContainer.PlayerPrefsMgr:GetInt(GUILD_HUNT_BATTLE_SPEED_KEY, curSpeed)
	-- if curSpeed ~= saveSpeed then
	-- 	ManagerContainer.LuaGameMgr:SetGameSpeed(saveSpeed)
	-- 	curSpeed = saveSpeed
	-- end
	-- self.btnSpeed.speed1:SetActive(curSpeed == 1)
	-- self.btnSpeed.speed2:SetActive(curSpeed == 2)

	self.leftFightingTime = self.controller:FightingTime()
	self.leftTime.text.text = FormatTimeMS(self.leftFightingTime)
	-- 不能用1000，因为如果速度加快了，就不是1秒变化了
	self.leftFightingTimeHandler = ManagerContainer.LuaTimerMgr:AddTimer(300, -1, self, self.OnShowLeftFightingTime, nil)

	if self.HeadsBoxPart == nil then
		self.HeadsBoxPart = BattleHeadsBoxPart:new()
	end
	self.HeadsBoxPart:InitGo(self,self.uiBase:FindChildGo("UIBattle/BattleHeadsBox"))
	self.HeadsBoxPart:Show()
end

function UIGuildHuntBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Boss_Buff,self,self.OnRefreshBossBuff);
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Boss_Remove_Buff,self,self.OnRefreshRemoveBossBuff);
end

function UIGuildHuntBattleView:AddUIEventListener()
	-- self.uiBase:AddButtonUniqueEventListener(self.btnSpeed.button, self, self.OnClickSpeedBtn)
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Boss_Buff,self,self.OnRefreshBossBuff);
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Boss_Remove_Buff,self,self.OnRefreshRemoveBossBuff);
	
	self.HeadsBoxPart:AddUIEventListener()
end

function UIGuildHuntBattleView:OnHide()

end
-----------------------------------Boss buff
function UIGuildHuntBattleView:OnRefreshRemoveBossBuff(buffIcon)
	if self:HasBuffIconGo(buffIcon) then
		self:RemoveBuffIconGo(buffIcon)
	end
end

function UIGuildHuntBattleView:HasBuffIconGo(buffIcon)
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

function UIGuildHuntBattleView:GetBuffIconGo(buffIcon)
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

function UIGuildHuntBattleView:LoadBuffIcon(buffGo,buffIcon,num,desc)
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
		self.uiBase:AddButtonUniqueEventListener(btn, self, self.OnClickBuff,desc)
	end

	local handler =  CommonUtil.LoadIcon(self, buffIcon, function (sprite)
			self.bossBuffLoadHandlers[buffIcon] = nil
			if img ~= nil and sprite ~= nil then
				img.sprite = sprite
			end
		end)

	if nil == self.bossBuffLoadHandlers then
		self.bossBuffLoadHandlers = {}
	end
	self.bossBuffLoadHandlers[buffIcon] = handler
end

function UIGuildHuntBattleView:OnRefreshBossBuff(buffIcon,num)
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

	local buffGo =  UnityEngine.GameObject.Instantiate(self.buffTemp)
    buffGo:SetActive(true)
    buffGo.transform:SetParent(self.buffTemp.transform.parent)
    buffGo.transform.localScale = Vector3.one
    buffGo.transform.localPosition = Vector3.zero
    buffGo.name = buffIcon

    local temps =  string.split(buffIcon, '/')
    local buffDesc = ""
    if temps ~= nil and #temps > 0 then
        buffDesc = temps[#temps].."_Desc"
	end
	if nil == self.bossBuffs then
		self.bossBuffs = {}
	end
    self.bossBuffs[#self.bossBuffs+1] = {icon = buffIcon, go = buffGo,desc = buffDesc}
    self:LoadBuffIcon(buffGo,buffIcon,num,buffDesc)
end


function UIGuildHuntBattleView:OnClickBuff(btn,params)
    ManagerContainer.LuaUIMgr:ShowMinTips(params[0])
end

function UIGuildHuntBattleView:RemoveBuffIconGo(buffIcon)
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

function UIGuildHuntBattleView:RemoveBuffLoadHandler(buffIcon)
	if self.bossBuffLoadHandlers[buffIcon] ~= nil then
		ManagerContainer.ResMgr:ClearUIAsyncLoadReqsBySeqId(self.bossBuffLoadHandlers[buffIcon])
		self.bossBuffLoadHandlers[buffIcon] =  nil
	end
end

function UIGuildHuntBattleView:Clear()    
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
---------------
function UIGuildHuntBattleView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildHuntBattleView:OnClose()
	self:ClearLeftFightingTimer()
	if self.HeadsBoxPart ~= nil then
		self.HeadsBoxPart:Dispose()
		self.HeadsBoxPart = nil
	end
	if self.bloodTimer then
		self.bloodTimer:Stop()
		self.bloodTimer = nil
	end
end

function UIGuildHuntBattleView:OnDispose()
	self.controller:OnDispose()
end

function UIGuildHuntBattleView:OnHurtChanged()
	self.hurtChanged = true
end

-- function UIGuildHuntBattleView:OnClickSpeedBtn()
--     if ManagerContainer.LuaGameMgr:GetGameSpeed() == 2 then
-- 		ManagerContainer.LuaGameMgr:SetGameSpeed(1)
-- 		ManagerContainer.PlayerPrefsMgr:SetInt(GUILD_HUNT_BATTLE_SPEED_KEY, 1)
--         self.btnSpeed.speed2:SetActive(false)
--         self.btnSpeed.speed1:SetActive(true)
-- 	else
-- 		ManagerContainer.LuaGameMgr:SetGameSpeed(2)
-- 		ManagerContainer.PlayerPrefsMgr:SetInt(GUILD_HUNT_BATTLE_SPEED_KEY, 2)
--         self.btnSpeed.speed2:SetActive(true)
--         self.btnSpeed.speed1:SetActive(false)
-- 	end
-- end


function UIGuildHuntBattleView:OnShowLeftFightingTime()
	self.leftFightingTime = self.controller:FightingTime()
	if self.leftFightingTime <= 0 then
		self:ClearLeftFightingTimer()
	end
	self.leftTime.text.text = FormatTimeMS(self.leftFightingTime)
end

function UIGuildHuntBattleView:ClearLeftFightingTimer()
	if self.leftFightingTimeHandler ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self.leftFightingTimeHandler)
        self.leftFightingTimeHandler = nil
	end
end

function UIGuildHuntBattleView:RefreshAwards()
	local iconPath = self.controller:GetRewardIcon()
	CommonUtil.LoadIcon(self, iconPath, function(sprite)
		self.iconBox.image.sprite = sprite
	end)
	local num = self.controller:GetRewardNum()
	self.lvNumber.text.text = tostring(num)
end

function UIGuildHuntBattleView:RefreshBlood()
	if not self.hurtChanged then return end
	self.hurtChanged = false

	local isDemon = self.controller:GetData()
	if not isDemon then	
		local curDamage = self.controller:GetCurDamage()
		local min, max = self.controller:GetCurRewardRange()
		self.hPNumber.text.text = tostring(curDamage) .. '/' .. tostring(max)
		local percentVal = curDamage - min
		local percentValMax = max - min
		local percent = 0
		if percentValMax <= 0 then
			percent = 1
		else
			percent = (percentVal / percentValMax)
		end

		if percent >= 1 then
			self.boxBg.animator:Play('BoxIn', -1, 0)
			self.boxBg.animator:Update(0)
			percent = 1
		end
		if percent < MinChangePercent then
			LuaBattleBridge.TweemFillAmount(self.bossBlood, 0, 0)
			self.bossBlood2.image.fillAmount = 0
		else
			if self.bossBlood.image.fillAmount > percent then
				self.bossBlood.image.fillAmount = 0
			end
			LuaBattleBridge.TweemFillAmount(self.bossBlood, percent, BOX_ANIM_TIME)
			self.bossBlood2.image.fillAmount = percent
		end
		if self.controller:RefreshDamage() then
			self:RefreshAwards()
		end
	else
		local harm = ManagerContainer.DataMgr.GuildDemonData:GetRecordDemonValue()
		if harm > self.lastharm  then
			self.number.animator:Play('DmgNumber', -1, 0)
			self.number.animator:Update(0)
			self.lastharm = harm
		end
		local harmStr = CommonUtil.FormatNumber(harm,true)
		local lenth = #harmStr
		for i = 1, 10 do
			local tpStr = string.sub(harmStr,i,i)
			if tpStr == '.' then
				tpStr = 'del'
			end
			if i <= lenth then
				self["lable"..i]:SetActive(true)
				CommonUtil.LoadIcon(self, "IconScore/demon_number_"..tpStr, function(sprite)
					self["lable"..i].image.sprite = sprite
				end)
			else
				self["lable"..i]:SetActive(false)
			end
		end
	end
end


return UIGuildHuntBattleView

