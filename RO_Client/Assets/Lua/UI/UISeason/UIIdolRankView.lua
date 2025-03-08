local UIIdolRankView = require("UISeason/UIIdolRankView_Generate")
local RankList = {}
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')
local UIIdolRankItemCtr = require('Common/UIIdolRankItemCtr')

function UIIdolRankView:OnAwake(data)
	self.controller = require("UISeason/UIIdolRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIIdolRankView:InitGrid()
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

function UIIdolRankView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.rankScroll.scrollRect.enabled = true
end

function UIIdolRankView:OnBeginLoad(isLeft)
	ManagerContainer.DataMgr.IdolData:SendGetVoteRankInfoReq()
end

function UIIdolRankView:GetItemByIndex(gridView, idx, itemIndex)
	local item = nil
	local itemLua = nil
	local showData = RankList[idx + 1]
	item = gridView:NewListViewItem('UIIdolRankItem')
	itemLua = CommonUtil.BindGridViewItem2Lua(self, 'UIIdolRankItem', item.gameObject)
	CommonUtil.UpdateItemPrefab(self, itemLua, showData, nil,self, self.OnClickSupportBtn)
	return item
end

function UIIdolRankView:RefreshPlayerInfo()
	self:InitUI()
	RankList = ManagerContainer.DataMgr.IdolData:GetRankInfoData()
	local maxLength = ManagerContainer.DataMgr.IdolData:GetRankInfoLimit()
	local dataLength = ManagerContainer.DataMgr.IdolData:GetRankInfosLength()
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(maxLength)
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

function UIIdolRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_IDOL_RANK_PLAYER_RANK_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_IDOL_VOTE_RANK_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_VOTE_VIEW_INFO, self, self.RefreshPlayerInfo)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_SUPPORTTIPSVIEW, self, self.OnOpenSupportTips)
end

function UIIdolRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIIdolRankView:Init()
	self:InitGrid()
	self:InitUI()
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
	ManagerContainer.DataMgr.IdolData:ClearIdolRankInfos()
	ManagerContainer.DataMgr.IdolData:SendGetVoteRankInfoReq()
end

function UIIdolRankView:InitUI()
	local selfTicket = ManagerContainer.DataMgr.CompetitionData:GetScore()
	local selfRank   = ManagerContainer.DataMgr.CompetitionData:GetRank()
	local logicData = {rank = selfRank,score = selfTicket, uid = ManagerContainer.DataMgr.UserData:GetUserId(),enterType = 1}
	UIIdolRankItemCtr:SetData(self, self.selfRankItem, logicData,nil,self, self.OnClickSupportBtn)
end

function UIIdolRankView:OnOpenSupportTips(data)
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

function UIIdolRankView:OnClickSupportBtn(btn,param)
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

function UIIdolRankView:OnSureSupport(logicData)	--确认投票
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

function UIIdolRankView:OnClickOtherHeadBtn(button,params)
	local uid = params[0]
	local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
	if selfUid == uid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIIdolRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIIdolRankView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.closeBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
end

function UIIdolRankView:OnClickCloseBtn()
	self:UIClose()
end

function UIIdolRankView:OnHide()

end

function UIIdolRankView:OnShow(data)
	self.controller:SetData(data)
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
end

function UIIdolRankView:OnClose()
	ManagerContainer.DataMgr.IdolData:ClearVoteInfoUid()
end

function UIIdolRankView:OnDispose()
	self.controller:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	ManagerContainer.DataMgr.IdolData:ClearIdolRankInfos()
end

return UIIdolRankView

