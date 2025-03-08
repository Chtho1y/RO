local UIIdolGiftTipsView = require("UISeason/UIIdolGiftTipsView_Generate")
local RankList = {}
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIIdolGiftTipsView:OnAwake(data)
	self.controller = require("UISeason/UIIdolGiftTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIIdolGiftTipsView:InitGrid()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.rankScroll.loopListView, 0, 50,
															false, nil, nil,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex, nil, self.OnBeginLoad)
	self.rankScroll.scrollRect.enabled = false
end

function UIIdolGiftTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.rankScroll.scrollRect.enabled = true
end

function UIIdolGiftTipsView:OnBeginLoad(isLeft)
	ManagerContainer.DataMgr.IdolData:SendGetGiftRankInfoReq()
end

function UIIdolGiftTipsView:GetItemByIndex(gridView, idx, itemIndex)
	local item = nil
	local itemLua = nil
	local showData = RankList[itemIndex + 1]
	item = gridView:NewListViewItem('UIIdolGiftItem')
	itemLua = CommonUtil.BindGridViewItem2Lua(self, 'UIIdolGiftItem', item.gameObject)
	CommonUtil.UpdateItemPrefab(self, itemLua, showData,nil,self, self.OnClickSupportBtn)
	return item
end

function UIIdolGiftTipsView:RefreshPlayerInfo()
	RankList = ManagerContainer.DataMgr.IdolData:GetIdolGiftInfos()
	local maxLength = ManagerContainer.DataMgr.IdolData:GetGiftInfoLimit()
	local dataLength = ManagerContainer.DataMgr.IdolData:GetGiftInfosLength()
	-- self.noRankList:SetActive(RankList and #RankList == 0)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(maxLength)
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

function UIIdolGiftTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_IDOL_FANS_PLAYER_RANK_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_FASN_REWARD_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_VOTE_VIEW_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_SUPPORTTIPSVIEW, self, self.OnOpenSupportTips)
end

function UIIdolGiftTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIIdolGiftTipsView:Init()
	self:InitGrid()
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
	ManagerContainer.DataMgr.IdolData:SendGetGiftRankInfoReq()
end

function UIIdolGiftTipsView:OnOpenSupportTips(data)
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

function UIIdolGiftTipsView:OnClickSupportBtn(btn,param)
	if not ManagerContainer.DataMgr.CompetitionData:CanOpenSeasonUI() then
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

function UIIdolGiftTipsView:OnSureSupport(logicData)	--确认投票
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

function UIIdolGiftTipsView:OnClickOtherHeadBtn(button,params)
	local uid = params[0]
	local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
	if selfUid == uid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIIdolGiftTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIIdolGiftTipsView:OnClickBoxItem(btn,param)
	if not ManagerContainer.DataMgr.CompetitionData:CanOpenSeasonUI() then
		return
	end
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LabelOver")
		return
	end
	local logicData = param[0]
	local boxId = logicData.boxId
	local loveVal = logicData.loveVal
	-- local loveGiftItem = logicData.obj
	local uid = logicData.uid
	local rewardState = logicData.rewardState
	local rewards = {}
	local BoxData = ManagerContainer.CfgMgr:GetAidouluCfg()
	local tab = BoxData[boxId].Rewards
	for i = 1, #tab do
		table.insert(rewards,{tab[i][1],tab[i][2]})
	end
	if logicData.boxNum >= boxId  then
		if logicData.ticket < loveVal then
			local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
			if selfUid == uid then
				ManagerContainer.DataMgr.IdolData:SendFansGetRewardReq(uid)
			else
				ManagerContainer.LuaUIMgr:ShowMinRewardTips(rewards)
			end
		else
			if rewardState[boxId]  then
				return
			else
				ManagerContainer.DataMgr.IdolData:SendFansGetRewardReq(uid)
			end
		end
	else
		-- loveGiftItem.btnBox.box2:SetActive(true)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("IdolGiftUnlockTips")
		ManagerContainer.LuaUIMgr:ShowMinRewardTips(rewards)
	end
end

function UIIdolGiftTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIIdolGiftTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIIdolGiftTipsView:OnHide()

end

function UIIdolGiftTipsView:OnShow(data)
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
	self.controller:SetData(data)
end

function UIIdolGiftTipsView:OnClose()
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
end

function UIIdolGiftTipsView:OnDispose()
	self.controller:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	ManagerContainer.DataMgr.IdolData:ClearIdolFansRankInfos()
end

return UIIdolGiftTipsView

