local UISeasonIdolView = require("UISeason/UISeasonIdolView_Generate")
local UIIdolRankItemCtr = require("Common/UIIdolRankItemCtr")
local IconItemCtr = require("Common/IconItemCtr")
local PreviewSystem = require "PreviewSystem"
local RoleViewSystem = require "RoleViewSystem"
local CreateActorSystem = require("CreateActorSystem")

function UISeasonIdolView:OnAwake(data)
	self.controller = require("UISeason/UISeasonIdolCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISeasonIdolView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_DAYS_REWARD_INFO, self, self.InitReward)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_RANK_MODEL_INFO, self, self.InitModel)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_VOTE_VIEW_INFO, self, self.InitUI)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.RefreshItem)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_SUPPORTTIPSVIEW, self, self.OnOpenSupportTips)
end

function UISeasonIdolView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISeasonIdolView:Init()
	ManagerContainer.DataMgr.CompetitionData:SetUIJumpState(1)	--设置UI平级界面状态
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
	self:InitUI()
	self:InitRewardUI()
	self:InitReward()
	self:InitModel()
end

function UISeasonIdolView:InitRewardUI()
	local data = GlobalConfig.Instance:GetConfigStrValue(344)
	local list = CommonUtil.DeserializeGlobalStrToTable(data)
	if not self.rewardCfgData then
		self.rewardCfgData = {}
	end
	if list and #list > 0 then
		for i = 1, #list do
			if list[i] and #list[i] >= 9 then
				table.insert(self.rewardCfgData,{tonumber(list[i][8]),tonumber(list[i][9])})
				local data = {cfgId = self.rewardCfgData[i][1],num = self.rewardCfgData[i][2]}
				IconItemCtr:SetData(self, self["rewards"..i].iconSmallItem, data)
				local timerTxt = list[i][2]..":"..list[i][3].."-"..list[i][5]..":"..list[i][6]
				self["rewards"..i].timetext.text.text = timerTxt
			end
		end
	end
end

function UISeasonIdolView:OnOpenSupportTips(data)
	local voteInfoUid = ManagerContainer.DataMgr.IdolData:GetVoteInfoUid()
	if not voteInfoUid then
		return
	end
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
	local cfgId = 238
	local maxNum = CommonUtil.GetOwnResCountByItemId(cfgId)
	local logicData = {rank = data.rank,score = data.score, uid = data.uid,enterType = 2}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIIdolSupportTips,{cfgId,self,self.OnSureSupport,logicData,maxNum})
end

function UISeasonIdolView:RefreshItem()
	local num = CommonUtil.GetOwnResCountByItemId(238)	--荧光棒
	self.glowstick.number.text.text = CommonUtil.FormatNumber(num)
end

function UISeasonIdolView:InitUI()
	local num = CommonUtil.GetOwnResCountByItemId(238)	--荧光棒
	self.glowstick.number.text.text = CommonUtil.FormatNumber(num)
	local selfTicket = ManagerContainer.DataMgr.CompetitionData:GetScore()
	local selfRank   = ManagerContainer.DataMgr.CompetitionData:GetRank()
	local logicData = {rank = selfRank,score = selfTicket, uid = ManagerContainer.DataMgr.UserData:GetUserId(),enterType = 1}
	UIIdolRankItemCtr:SetData(self, self.selfRankItem, logicData,nil,self, self.OnClickSupportBtn)
	local redState = ManagerContainer.DataMgr.IdolData:GetRedState()
	self.btnIdolGift.giftShow:SetActive(redState)
end

function UISeasonIdolView:InitModel()
	if not self.roleSystemMap then
		self.roleSystemMap = {}
	end
	if not self.previewSystemMap then
		self.previewSystemMap = {}
	end
	local data = ManagerContainer.DataMgr.IdolData:GetShowDataList()
	for i = 1, 3 do
		local instanceId = self["playerNode"..i].gameObject:GetInstanceID()
		if data[i] then
			self["playerNode"..i].roleModel:SetActive(true)
			self["playerNode"..i].pos:SetActive(false)
			self["playerNode"..i].btnSupport.button.interactable = true
			CommonUtil.SetTotalChildrenGray(self["playerNode"..i].btnSupport,false)
			if not self.roleSystemMap[instanceId] then
				self.roleSystemMap[instanceId] = RoleViewSystem:new()
			end
			if not self.previewSystemMap[instanceId] then
				self.previewSystemMap[instanceId] = PreviewSystem:new("Preview", 256, 256)
				self.previewSystemMap[instanceId]:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
			end
			self.roleSystemMap[instanceId]:CancelCreate()
			self.previewSystemMap[instanceId]:RemoveAllGo()
			self.roleSystemMap[instanceId]:SetHeroId(instanceId)
			self:RefreshRoleView(self.roleSystemMap[instanceId],data[i].roleCfgId, data[i].viewData, data[i].extGoesShowData)
			self["playerNode"..i].roleModel.rawImage.texture = self.previewSystemMap[instanceId]:GetRenderTexture()
			self["playerNode"..i].nametext.text.text = data[i].nickName
			self["playerNode"..i].hotVal.text.text = data[i].vote_list.score
			local logicData = {rank = i,score = data[i].vote_list.score, uid = data[i].vote_list.uid,enterType = 0}
			self.uiBase:AddButtonUniqueEventListener(self["playerNode"..i].btnSupport.button, self, self.OnClickSupportBtn,logicData)
		else
			self["playerNode"..i].roleModel:SetActive(false)
			self["playerNode"..i].pos:SetActive(true)
			self["playerNode"..i].nametext.text.text = I18N.SetLanguageValue('NoneRank')
			self["playerNode"..i].hotVal.text.text = I18N.SetLanguageValue('Nohot')
			self["playerNode"..i].btnSupport.button.interactable = false
			CommonUtil.SetTotalChildrenGray(self["playerNode"..i].btnSupport,true)
		end
	end
end
function UISeasonIdolView:RefreshRoleView(roleViewSystem,roleId,viewData,extGoesShowData)
	roleViewSystem:RefreshView(Enum.RoleInEnvType.RoleMainView, roleId, viewData, extGoesShowData, self, self.LoadModelCB)
end

function UISeasonIdolView:LoadModelCB(go, result, instanceId)
if not go then return end
if self.previewSystemMap[instanceId] and go ~= nil then
	go.name = instanceId
	self.previewSystemMap[instanceId]:UpdateGo(go)
end
go:SetActive(true)
end

function UISeasonIdolView:InitReward()
	local timeList = ManagerContainer.DataMgr.IdolData:GetRewardsTimeList()
	if not timeList then
		return
	end
	local curTimer = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	for i = 1, #timeList do
		local startTime = timeList[i][1]
		local endTime = timeList[i][2]
		local state = timeList[i][3]
		if state then
			self["rewards"..i].idolRewardsAnim.animator:Play("IdolRewardsReceived")
		else
			if curTimer >= startTime and curTimer <= endTime then
				self["rewards"..i].idolRewardsAnim.animator:Play("IdolRewardsAvailable")
			elseif curTimer > endTime then
				self["rewards"..i].idolRewardsAnim.animator:Play("IdolRewardsOverdue")
			end
		end
	end
	local endTime = timeList[2][2]
	if curTimer >= endTime then
		if self.updateTimer then
			self.updateTimer:Stop()
			self.updateTimer = nil
		end
	else
		self:SetUpdateTimer()
	end
end
function UISeasonIdolView:SetUpdateTimer()
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
	if not self.updateTimer then
		self.updateTimer = Timer.New(slot(self.InitReward, self), 60, -1)
	end
	if not self.updateTimer.running then
		self.updateTimer:Start()
	end
end

function UISeasonIdolView:OnClickOtherHeadBtn(button,params)
	local uid = params[0]
	local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
	if selfUid == uid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end


function UISeasonIdolView:OnSeasonViewOpen()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.DataMgr.CompetitionData:SetUIJumpState(0)
		ManagerContainer.DataMgr.CompetitionData:QueryCurCompetitionReq()
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
	self:OnClickCloseBtn()
end

function UISeasonIdolView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

function UISeasonIdolView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISeasonIdolView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "AidouluSeasonPlayExplain"})
end

function UISeasonIdolView:OnClickSupportBtn(btn,param)
	if not ManagerContainer.DataMgr.CompetitionData:CanOpenSeasonUI() then
		return
	end
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
		return
	end
	local logicData = param[0]
	local uid = logicData.uid
	local cfgId = 238 --荧光棒
	local selfId = ManagerContainer.DataMgr.UserData:GetUserId()
	local maxNum = CommonUtil.GetOwnResCountByItemId(238)
	if uid == selfId then
		local selfTicket = ManagerContainer.DataMgr.CompetitionData:GetScore()
		local selfRank   = ManagerContainer.DataMgr.CompetitionData:GetRank()
		local data = {rank = selfRank,score = selfTicket, uid = ManagerContainer.DataMgr.UserData:GetUserId(),enterType = 1}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIIdolSupportTips,{cfgId,self,self.OnSureSupport,data,maxNum})
	else
		ManagerContainer.DataMgr.IdolData:SendGetPlayerVoteRankReq(uid)
	end
end

function UISeasonIdolView:OnClickBuyBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIShop, 1, self.uiData.id)
end

function UISeasonIdolView:OnSureSupport(logicData)	--确认投票
	if not ManagerContainer.DataMgr.CompetitionData:CanOpenSeasonUI() then
		return
	end
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
		return
	end
	local num = logicData[1]
	local uid = logicData[2]
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_ON_VOTE_REQ, { ticket_count = num,uid = uid})
end

function UISeasonIdolView:OnClickIdolFansBtn()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIIdolMyFansTips)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
end

function UISeasonIdolView:OnClickIdolGiftBtn()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIIdolGiftTips)
		ManagerContainer.DataMgr.IdolData:SetRedState(false)
		self.btnIdolGift.giftShow:SetActive(false)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
end
function UISeasonIdolView:OnClickIdolRankBtn()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIIdolRank)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
end

function UISeasonIdolView:OnClickIdolShopBtn()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if not IsOver then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIIdolActivityShop)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
	end
end

function UISeasonIdolView:OnClickIOnlineRewardsBtn(btn,param)
	if not ManagerContainer.DataMgr.CompetitionData:CanOpenSeasonUI() then
		return
	end
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
		return
	end
	local enterType = param[0]
	local timeList = ManagerContainer.DataMgr.IdolData:GetRewardsTimeList()
	if not timeList then
		return
	end
	local curTimer = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	local startTime = timeList[enterType][1]
	local endTime = timeList[enterType][2]
	local state = timeList[enterType][3]
	if not state then
		if curTimer >= startTime and curTimer <= endTime then
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_FANS_DAY_REWARD_REQ,{id = enterType})
		elseif curTimer > endTime then
			self["rewards"..enterType].idolRewardsAnim.animator:Play("IdolRewardsOverdue")
		else
			ManagerContainer.LuaUIMgr:OpenTips({cfgId =  self.rewardCfgData[enterType][1]})
		end
	end
end

function UISeasonIdolView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnSeason.button, self, self.OnSeasonViewOpen)
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.btnBuy.button, self, self.OnClickBuyBtn)
	self.uiBase:AddButtonEventListener(self.btnIdolFans.button, self, self.OnClickIdolFansBtn)
	self.uiBase:AddButtonEventListener(self.btnIdolGift.button, self, self.OnClickIdolGiftBtn)
	self.uiBase:AddButtonEventListener(self.btnIdolRank.button, self, self.OnClickIdolRankBtn)
	self.uiBase:AddButtonEventListener(self.btnIdolShop.button, self, self.OnClickIdolShopBtn)
	self.uiBase:AddButtonEventListener(self.rewards1.btnOnlineRewards.button, self, self.OnClickIOnlineRewardsBtn,1)
	self.uiBase:AddButtonEventListener(self.rewards2.btnOnlineRewards.button, self, self.OnClickIOnlineRewardsBtn,2)
end

function UISeasonIdolView:OnHide()

end

function UISeasonIdolView:OnShow(data)
	self.controller:SetData(data)
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
end

function UISeasonIdolView:OnClose()
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
end

function UISeasonIdolView:OnDispose()
	if self.previewSystemMap then
		for _, v in pairs(self.previewSystemMap) do
			v:Dispose()
		end
		self.previewSystemMap = nil
	end

	if self.roleSystemMap then
		for _, v in pairs(self.roleSystemMap) do
			v:Dispose()
		end
		self.roleSystemMap = nil
	end
	if self.updateTimer then
		self.updateTimer:Stop()
		self.updateTimer = nil
	end
	self.controller:OnDispose()
	ManagerContainer.DataMgr.IdolData:ClearTempPlayerBirefInfos()
end

return UISeasonIdolView

