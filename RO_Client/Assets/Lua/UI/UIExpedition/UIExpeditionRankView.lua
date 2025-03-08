local UIExpeditionRankView = require("UIExpedition/UIExpeditionRankView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIExpeditionRankView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionRankView:AddEventListener()	
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickCloseBtn)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Refresh_Expedition_RankData,self,self.OnRefreshRankList)	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
end

function UIExpeditionRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIExpeditionRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

--采用英灵殿排行榜模式
function UIExpeditionRankView:Init()	
	self.lastReqTime = 0
	ManagerContainer.DataMgr.ExpeditionDataMgr:ResetSvrIdx()
	self.scrollView.loopVerticalScrollRect:SetDragLuaCallback(self.OnDragScrollView)
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendScoreRankListReq(1)
	-- self.rankList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetListfRank()	
	-- if self.rankList~= nil and #self.rankList >= 1 then	
	-- 	self.noRankList:SetActive(false)
	-- 	self.scrollView:SetActive(true)
	-- 	CommonUtil.LoopGridViewEleCreateNew(self,
	-- 			self.scrollView.loopVerticalScrollRect,
	-- 			nil,
	-- 			self.rankList,
	-- 			0,
	-- 			self,
	-- 			self.OnRefreshRankData)			
	-- else
	-- 	self.noRankList:SetActive(true)
	-- 	self.scrollView:SetActive(false)
	-- end
	-- if self.loadStatusLoopListCtr then
	-- 	self.loadStatusLoopListCtr:Dispose()
	-- 	self.loadStatusLoopListCtr = nil
	-- end		
	-- self.loadStatusLoopListCtr =
	-- LoadStatusLoopListCtr:new(self, self.scrollView.loopListView, 0, 100,
	-- 													false, nil, nil,
	-- 													true, 'LoadingItem', nil,
	-- 													self.GetItemByIndex, nil, self.OnBeginLoad)
	-- ManagerContainer.DataMgr.ExpeditionDataMgr:ResetSvrIdx()
	-- ManagerContainer.DataMgr.ExpeditionDataMgr:SendScoreRankListReq(1)
end

function UIExpeditionRankView:OnDragScrollView()
	local curTime = Time.realtimeSinceStartup
	if (curTime - self.lastReqTime) >= 0.1 then
		local svrIdx,IsOver = ManagerContainer.DataMgr.ExpeditionDataMgr:GetNextRankListNum()	
		if not IsOver then
			--LogError(tostring(svrIdx))
			ManagerContainer.DataMgr.ExpeditionDataMgr:SendScoreRankListReq(svrIdx)
		end
		self.lastReqTime = curTime
	end
end

function UIExpeditionRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIExpeditionRankView:AddUIEventListener()

end

function UIExpeditionRankView:OnHide()

end

function UIExpeditionRankView:OnShow(data)
	self.controller:SetData(data)

end

--刷新
function UIExpeditionRankView:OnRefreshRankList()
	self.rankList = ManagerContainer.DataMgr.ExpeditionDataMgr:GetListfRank()	
	if self.rankList~= nil and #self.rankList >= 1 then	
		self.noRankList:SetActive(false)
		self.scrollView:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
				self.scrollView.loopVerticalScrollRect,
				nil,
				self.rankList,
				0,
				self,
				self.OnRefreshRankData)			
	else
		self.noRankList:SetActive(true)
		self.scrollView:SetActive(false)
	end
	self:RefreshSelfRank()

	-- self:FinishLoadItem()
end


function UIExpeditionRankView:GetRankImg(rankItemLua,nidx)
	if nidx == 1 then
		return rankItemLua.rank1
	elseif nidx == 2 then
		return rankItemLua.rank2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
	elseif nidx == 3 then
		return rankItemLua.rank3
	end
end

function UIExpeditionRankView:ShowRankImg(rankItemLua,Rank)
	self:GetRankImg(rankItemLua,1):SetActive(false)
	self:GetRankImg(rankItemLua,2):SetActive(false)
	self:GetRankImg(rankItemLua,3):SetActive(false)
	if Rank <= 3 and Rank > 0 then
		self:GetRankImg(rankItemLua,Rank):SetActive(true)
	end
end
-----------------loading loop view 
function UIExpeditionRankView:GetItemByIndex(loopListView, idx, dataIdx)	
	--LogError("GetItemByIndex"..tostring(dataIdx))	
	local itemData = ManagerContainer.DataMgr.ExpeditionDataMgr:GetRankDataByIdx(dataIdx+1)
	if not itemData then return nil end	
	local item = loopListView:NewListViewItem('ExpeditionRankItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'ExpeditionRankItem', item.gameObject)
	if itemLua then
		self:OnRefreshRankData(itemLua,idx,itemData)
	end
	return item
end

function UIExpeditionRankView:FinishLoadItem()
	local CurNum,MaxNum = ManagerContainer.DataMgr.ExpeditionDataMgr:GetNextRankListNum()	
	--LogError(tostring(CurNum))
	--LogError(tostring(MaxNum))
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(MaxNum)
	self.loadStatusLoopListCtr:RefreshDataLength(CurNum)
end

function UIExpeditionRankView:OnBeginLoad(isLeft)
	--LogError("OnBeginLoad")
	--Loading...........
	--LogError("Sending"..tostring(svrIdx))
	local svrIdx = ManagerContainer.DataMgr.ExpeditionDataMgr:GetListSvrStartIdx()	
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendScoreRankListReq(svrIdx + 1)	
	--self:FinishLoadItem()
end
----------------------------------------------
function UIExpeditionRankView:OnRefreshRankData(rankItemLua,idx,rankData)	
	if rankItemLua == nil  or rankData == nil then
		return
	end

	local Brief = rankData.brief_info
	local Rank = rankData.rank
	local Score = rankData.score

	self:ShowRankImg(rankItemLua,rankData.rank)

	local _jobIcon = nil;
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(Brief.config_id)
	if jobCfg ~= nil then
		_jobIcon = jobCfg.JobIcon
	end

	if nil == tonumber(Rank) then
		LogError("Expedition Rank Data Error "..tostring(Rank))
	end

	rankItemLua.guildCPTxt.text.text = tostring(Score)
	rankItemLua.rankTxt.text.text = tostring(Rank)
	
	rankItemLua.nameTxt.text.text = CommonUtil.GetVaildNickName(Brief.nick_name)
	rankItemLua.lvTxt.text.text = tostring(Brief.fight_power)

	local _playerHead = CommonUtil.GetPlayerHeadIcon(Brief)
	local _headFrameId = Brief.head_frame_id
	local _fakerData = {Level = Brief.level, ProfessionIcon = _jobIcon, HeadIcon = _playerHead, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, rankItemLua.headItem, _fakerData,false, _headFrameId, self, self.OnClickPlayerHead,Brief.uid);

	rankItemLua.vipIcon.image.enabled = false
	rankItemLua.vipIcon.image.sprite = nil
	local vipLv = Brief.vip_level
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					rankItemLua.vipIcon.image.sprite = sprite
					rankItemLua.vipIcon.image.enabled = true
				end
			end)
		end
	end

end


function UIExpeditionRankView:RefreshSelfRank()
	local userData = ManagerContainer.DataMgr.UserData
	local tbRank = ManagerContainer.DataMgr.ExpeditionDataMgr:GetSelfRank()

	local Rank = tbRank.rank
	if nil ~= tbRank.rank and tbRank.rank == 0 then
		Rank = I18N.T("NoRank")
	end
	if tbRank.rank > 100 then
		Rank = I18N.T("NoRank")
	end
	self:ShowRankImg(self.myRank,tbRank.rank)
	self.myRank.guildCPTxt.text.text = tostring(tbRank.score)
	self.myRank.rankTxt.text.text = tostring(Rank)	
	self.myRank.nameTxt.text.text = userData:GetUserNickname()	
	self.myRank.lvTxt.text.text = userData:GetTotalFightPower()

	local _playerHead = userData:GetUserHeadIcon()
	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();
	local _fakerData = {Level = userData:GetRoleLv(), ProfessionIcon = userData:GetJobIcon(), HeadIcon = _playerHead, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, self.myRank.headItem, _fakerData,false, _headFrameId, self, self.OnClickSelfHead);

	self.myRank.vipIcon.image.enabled = false
	self.myRank.vipIcon.image.sprite = nil
	local vipLv = userData:GetVipLv()
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					self.myRank.vipIcon.image.sprite = sprite
					self.myRank.vipIcon.image.enabled = true
				end
			end)
		end
	end
end

function UIExpeditionRankView:OnClickSelfHead()
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("ChatError1"))
end

function UIExpeditionRankView:OnClickPlayerHead(btn,param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end


function UIExpeditionRankView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIExpeditionRankView:OnClose()
end

function UIExpeditionRankView:OnDispose()
	-- if self.loadStatusLoopListCtr then
	-- 	self.loadStatusLoopListCtr:Dispose()
	-- 	self.loadStatusLoopListCtr = nil
	-- end
	self.scrollView.loopVerticalScrollRect:ClearCells()
	self.controller:OnDispose()
end

return UIExpeditionRankView

