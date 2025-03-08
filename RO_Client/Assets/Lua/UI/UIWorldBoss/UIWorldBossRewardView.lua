local UIWorldBossRewardView = require("UIWorldBoss/UIWorldBossRewardView_Generate")

local ExecuteSequenceData = require('ExecuteSequenceData')

local SSR_EFFECT_NAME = 'FX_UI_ChallengeReward_01'
local SSR_EFFECT_SCALE = Vector3(80, 80, 80)

local TicketInAnimTime = nil
local TicketOpenAnimTime = nil
local IsOpenReward1 = nil
local IsOpenReward2 = nil
local IsOpenReward3 = nil

local RewardType = {
	SSR = 1,
	SR = 2,
	R = 3,
}

function UIWorldBossRewardView:OnAwake(data)
	self.controller = require("UIWorldBoss/UIWorldBossRewardCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIWorldBossRewardView:AddEventListener()

end

function UIWorldBossRewardView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIWorldBossRewardView:Init()
	self.controller:InitData()
	self:InitAnimTime()
	self.clickMask:SetActive(true)
	self.btnBack:SetActive(false)
	self.ticket1.animator.keepAnimatorControllerStateOnDisable = true
	self.ticket2.animator.keepAnimatorControllerStateOnDisable = true
	self.ticket3.animator.keepAnimatorControllerStateOnDisable = true

	self.ticket1.animator:Play('TicketKeep')
	self.ticket2.animator:Play('TicketKeep')
	self.ticket3.animator:Play('TicketKeep')

	self:RefreshRewardList(self.rewardSSR, self.controller:GetWorldBossRewardsByType(RewardType.SSR))
	self:RefreshRewardList(self.rewardSR, self.controller:GetWorldBossRewardsByType(RewardType.SR))
	self:RefreshRewardList(self.rewardR, self.controller:GetWorldBossRewardsByType(RewardType.R))
	self:RefreshVip()

	local hasSSR = false
	local rewardList = self.controller:GetWorldBossRewardList()
	for _, rewardType in pairs(rewardList) do
		if rewardType == RewardType.SSR then
			hasSSR = true
			break
		end
	end
	if hasSSR then
		if not self.ssrEffects then
			if not self.ssrEffectSeqId then
				self.ssrEffectSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.UIEffectPath, {SSR_EFFECT_NAME}, self, self.SSREffectCompleted)
				if ManagerContainer.ResMgr:SeqIdEquals(self.ssrEffectSeqId, 0) then
					self.ssrEffectSeqId = nil
					self:SSREffectCompleted()
				end
			end
		end
	else
		self:DisposeSSREffect()
	end
end

function UIWorldBossRewardView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIWorldBossRewardView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBtnBack)
	self.uiBase:AddButtonUniqueEventListener(self.ticket1.button, self, self.OnClickBtnTicket, 1)
	self.uiBase:AddButtonUniqueEventListener(self.ticket2.button, self, self.OnClickBtnTicket, 2)
	self.uiBase:AddButtonUniqueEventListener(self.ticket3.button, self, self.OnClickBtnTicket, 3)
end

function UIWorldBossRewardView:OnHide()

end

function UIWorldBossRewardView:OnShow(data)
	self.controller:SetData(data)

end

function UIWorldBossRewardView:OnClose()
end

function UIWorldBossRewardView:OnDispose()
	if self.popGotCloseTimer then
		self.popGotCloseTimer:Stop()
		self.popGotCloseTimer = nil
	end
	if self.executeSequenceData then
		ManagerContainer.ExecuteSequenceMgr:Exit(self.executeSequenceData)
		self.executeSequenceData = nil
	end
	self:DisposeSSREffect()
	self.controller:OnDispose()
end

function UIWorldBossRewardView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.ticket1.animator:Play('TicketIn')
	self.ticket2.animator:Play('TicketIn')
	self.ticket3.animator:Play('TicketIn')
	self:ResetExecuteSequenceData()
	self:SetClickMaskState(true)
	self.executeSequenceData:AppendInterval(TicketInAnimTime)
	self.executeSequenceData:AppendFunc(false, self, self.SetClickMaskState, false)
	ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
end

function UIWorldBossRewardView:OnPageOutEnd()
	self.super.OnPageOutEnd(self)
end

function UIWorldBossRewardView:InitAnimTime()
	if TicketInAnimTime and TicketOpenAnimTime then
		return
	end
	TicketInAnimTime = 1
	TicketOpenAnimTime = 0.3
	local clips = self.ticket1.animator.runtimeAnimatorController.animationClips
	for i = 0, clips.Length - 1 do
		local clip = clips[i]
		if clip then
			local clipName = clip.name
			if clipName == 'TicketIn' then
				TicketInAnimTime = clip.length
			elseif clipName == 'TicketOpen' then
				TicketOpenAnimTime = clip.length
			end
		end
	end
end

function UIWorldBossRewardView:SetClickMaskState(state)
	self.clickMask:SetActive(state)
end

function UIWorldBossRewardView:ResetExecuteSequenceData()
	if self.executeSequenceData then
		ManagerContainer.ExecuteSequenceMgr:Exit(self.executeSequenceData)
		self.executeSequenceData:Reset()
	else
		self.executeSequenceData = ExecuteSequenceData:new()
	end
end

function UIWorldBossRewardView:RefreshRewardList(listLua, datas)
	if not listLua then return end
	if datas and type(datas[1]) == 'number' then
		datas = {datas}
	end
	local data
	for i = 1, 4 do
		local itemlua = listLua['iconSmallItem' .. i]
		data = datas and datas[i] or nil
		if data then
			itemlua:SetActive(true)
			CommonUtil.UpdateItemPrefab(self, itemlua, data, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
		else
			itemlua:SetActive(false)
		end
	end
end

function UIWorldBossRewardView:ShowItemTips(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end


function UIWorldBossRewardView:OnClickBtnBack()
	self:UIClose(self)
end

function UIWorldBossRewardView:OnClickBtnTicket(_, params)
	local rewardType = self.controller:GetCurVaildRewardType()
	if not rewardType then return end
	local id = params[0]
	if id == 1 then
		if IsOpenReward1 then return end
		IsOpenReward1 = true
		self:RefreshOpenNum(self.controller:GetWorldBossRemainNum())
		self.ticket1.animator:Play('TicketOpen')
		self:RefreshTicketView(self.ticket1, rewardType)
		self:ResetExecuteSequenceData()
		self:SetClickMaskState(true)
		self.executeSequenceData:AppendInterval(TicketOpenAnimTime)
		self.executeSequenceData:AppendFunc(false, self, self.OpenPopGotView, rewardType)
		self.executeSequenceData:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_PAGE_OUT_END_NTF)
		self.executeSequenceData:AppendFunc(false, self, self.RewardShowComplete)
		ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
	elseif id == 2 then
		if IsOpenReward2 then return end
		IsOpenReward2 = true
		self:RefreshOpenNum(self.controller:GetWorldBossRemainNum())
		self.ticket2.animator:Play('TicketOpen')
		self:RefreshTicketView(self.ticket2, rewardType)
		self:ResetExecuteSequenceData()
		self:SetClickMaskState(true)
		self.executeSequenceData:AppendInterval(TicketOpenAnimTime)
		self.executeSequenceData:AppendFunc(false, self, self.OpenPopGotView, rewardType)
		self.executeSequenceData:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_PAGE_OUT_END_NTF)
		self.executeSequenceData:AppendFunc(false, self, self.RewardShowComplete)
		ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
	elseif id == 3 then
		if IsOpenReward3 then return end
		IsOpenReward3 = true
		self:RefreshOpenNum(self.controller:GetWorldBossRemainNum())
		self.ticket3.animator:Play('TicketOpen')
		self:RefreshTicketView(self.ticket3, rewardType)
		self:ResetExecuteSequenceData()
		self:SetClickMaskState(true)
		self.executeSequenceData:AppendInterval(TicketOpenAnimTime)
		self.executeSequenceData:AppendFunc(false, self, self.OpenPopGotView, rewardType)
		self.executeSequenceData:AppendUIListener(Enum.UIPageName.UIPOPGot, UIEventNames.UI_PAGE_OUT_END_NTF)
		self.executeSequenceData:AppendFunc(false, self, self.RewardShowComplete)
		ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
	end
end

function UIWorldBossRewardView:OpenPopGotView(rewardType)
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {rewards = self.controller:GetWorldBossRewardsByType(rewardType)})
	if self.popGotCloseTimer then
		self.popGotCloseTimer.time = 3
		self.popGotCloseTimer.loop = 1
	else
		self.popGotCloseTimer = Timer.New(function()
			if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UITips) then
				ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UITips)
			end
			ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIPOPGot)
		end, 3)
	end
	if not self.popGotCloseTimer.running then
		self.popGotCloseTimer:Start()
	end
end

function UIWorldBossRewardView:RewardShowComplete()
	self:SetClickMaskState(false)
	if self.popGotCloseTimer then
		self.popGotCloseTimer:Stop()
	end
	local hasNext = self.controller:OffsetNextVaildRewardType()
	if not hasNext then
		self:RefreshOpenNum(nil)
	end
	self.btnBack:SetActive(not hasNext)
end

function UIWorldBossRewardView:RefreshTicketView(ticket, rewardType)
	ticket.sSR:SetActive(rewardType == RewardType.SSR)
	ticket.sR:SetActive(rewardType == RewardType.SR)
	ticket.r:SetActive(rewardType == RewardType.R)
end

function UIWorldBossRewardView:RefreshVip()
	-- local vipCfg = self.controller:GetVipCfg()
	-- if vipCfg and vipCfg.Lv > 0 then
	-- 	self.noVip:SetActive(false)
	-- 	self.vip:SetActive(true)
	-- 	self.vip.icon.image.enabled = false
	-- 	self.vip.icon.image.sprite = nil
	-- 	CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
	-- 		if sprite then
	-- 			self.vip.icon.image.enabled = true
	-- 			self.vip.icon.image.sprite = sprite
	-- 		end
	-- 	end)
	-- else
	-- 	self.noVip:SetActive(true)
	-- 	self.vip:SetActive(false)
	-- end
	-- self:RefreshOpenNum(self.controller:GetWorldBossRemainNum())
	self.noVip:SetActive(false)
	self.vip:SetActive(false)
end

function UIWorldBossRewardView:RefreshOpenNum(openNum)
	-- if not openNum then
	-- 	self.noVip:SetActive(false)
	-- 	self.vip:SetActive(false)
	-- 	return
	-- end
	-- self.noVip.timeTxt.text.text = string.formatbykey('WorldBossDraw', tostring(openNum))
	-- self.vip.timeTxt.text.text = string.formatbykey('WorldBossDraw', tostring(openNum))
end

function UIWorldBossRewardView:SSREffectCompleted()
	self.ssrEffectSeqId = nil
	local ssrEffect = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIEffectPath, SSR_EFFECT_NAME)
	if not ssrEffect then
		return
	end
	if not self.ssrEffects then
		self.ssrEffects = {}
	end
	ssrEffect.transform:SetParent(self.ticket1.effect.transform)
	ssrEffect.transform.localPosition = Vector3.zero
	ssrEffect.transform.localRotation = Quaternion.identity
	ssrEffect.transform.localScale = SSR_EFFECT_SCALE
	ssrEffect:SetActive(true)
	self.ssrEffects[#self.ssrEffects + 1] = ssrEffect
	ssrEffect = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIEffectPath, SSR_EFFECT_NAME)
	if not ssrEffect then
		return
	end
	ssrEffect.transform:SetParent(self.ticket2.effect.transform)
	ssrEffect.transform.localPosition = Vector3.zero
	ssrEffect.transform.localRotation = Quaternion.identity
	ssrEffect.transform.localScale = SSR_EFFECT_SCALE
	ssrEffect:SetActive(true)
	self.ssrEffects[#self.ssrEffects + 1] = ssrEffect
	ssrEffect = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIEffectPath, SSR_EFFECT_NAME)
	if not ssrEffect then
		return
	end
	ssrEffect.transform:SetParent(self.ticket3.effect.transform)
	ssrEffect.transform.localPosition = Vector3.zero
	ssrEffect.transform.localRotation = Quaternion.identity
	ssrEffect.transform.localScale = SSR_EFFECT_SCALE
	ssrEffect:SetActive(true)
	self.ssrEffects[#self.ssrEffects + 1] = ssrEffect
end

function UIWorldBossRewardView:DisposeSSREffect()
	if self.ssrEffectSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.ssrEffectSeqId)
		self.ssrEffectSeqId = nil
	end
	if self.ssrEffects then
		for _, ssrEffect in pairs(self.ssrEffects) do
			if ssrEffect then
				ssrEffect.transform.localScale = Vector3.one
				ManagerContainer.ResMgr:RecycleGO(Constants.UIEffectPath, SSR_EFFECT_NAME, ssrEffect.gameObject)
			end
		end
		self.ssrEffects = nil
	end
end

return UIWorldBossRewardView

