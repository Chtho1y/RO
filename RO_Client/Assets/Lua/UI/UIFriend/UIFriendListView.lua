local UIFriendListView = require("UIFriend/UIFriendListView_Generate")
local FriendRecruitView = require("UIFriend/FriendRecruitView")

local recruitKey = false
function UIFriendListView:OnAwake(data)
	self.controller = require("UIFriend/UIFriendListCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFriendListView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFriendListView:Init()
	self.headUrl = GlobalConfig.Instance:GetConfigStrValue(179)
	self.lastIndex = 0
	self.lastReqTime = 0 
	self.pageToggleData = {}
	self.searchNode:SetActive(false)
	self.recommendScrollView:SetActive(false)
	self.scrollview.loopVerticalScrollRect:SetDragLuaCallback(self.OnDragScrollView)
	self.fansRedPoint:SetActive(ManagerContainer.DataMgr.FriendDataMgr:HasNewFans())

	self.recruitFriendBtn:SetActive(recruitKey)
	if recruitKey then
		if not self.friendRecruitView then
			self.friendRecruitView = FriendRecruitView:new()
			self.friendRecruitView:Init(self, self.recruitUI)
		end
	end
end

function UIFriendListView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Update_FriendDataList,self,self.OnUpdateDataList)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Refresh_FriendData,self,self.OnRefreshData)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Show_SearchFriendData,self,self.OnShowSearchData)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.FRIEND_INVITATION_MASTER_INFO_REFRESH,self, self.OnMasterInfoRefresh)
	if self.friendRecruitView then
		self.friendRecruitView:AddEventListener()
	end
end

function UIFriendListView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFriendListView:AddUIEventListener()
	CommonUtil.CreateToggleMouduleOnlyBtns(self, self.pageToggleData, self.toggleGroup, self.controller:GetDefaultPageType(), self.OnClickToggle)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.searchBtn.button,self,self.OnClickSearch)
	self.uiBase:AddButtonEventListener(self.refreshBtn.button,self,self.OnClickRefresh)

	if self.friendRecruitView then
		self.friendRecruitView:AddUIEventListener()
	end
end

function UIFriendListView:OnHide()

end

function UIFriendListView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIFriendListView:OnClose()
	self.pageToggleData = nil
end

function UIFriendListView:OnDispose()
	if self.friendRecruitView then
		self.friendRecruitView:Dispose()
		self.friendRecruitView = nil
	end
	self.scrollview.loopVerticalScrollRect:ClearCells()
	self.recommendScrollView.loopVerticalScrollRect:ClearCells()
end

function UIFriendListView:OnClickClose()
	--ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIFriendList)
	--ManagerContainer.LuaUIMgr:BackToMainCity()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIFriendListView:OnClickSearch()
	local searchName = StringUtil.Trim(self.searchNameInput.inputField.text)
	if searchName == nil or searchName == "" then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("请输入要搜索的玩家名字~")
	else
		self.controller:RequestSearchPlayerByName(searchName)
	end
end

function UIFriendListView:OnClickRefresh()
	self.searchNameInput.inputField.text = ""
	self.controller:RequestFriendRecommend()
end

function UIFriendListView:OnClickToggle(index)
	--if self.pageToggleData.toggleDefaultIndex ~= index then
	--	return
	--end

	self.scrollview.loopVerticalScrollRect:ClearCells()
	self.emptyTips:SetActive(false)
	--self.numRoot:SetActive(true)
	if index == Enum.FriendTogglePageType.InterestList then
		self.searchNode:SetActive(false)
		self.recommendScrollView:SetActive(false)
		self:RecruitViewDisplayState(false)
		self.controller:RequestDataByType(Enum.FriendTogglePageType.InterestList)
		self:RefreshInterestListData()
		self.numIcon.image.sprite =  self.numIcon.switchSprite:GetSprite("ic_qty_1")
	elseif index == Enum.FriendTogglePageType.FansList then
		self.searchNode:SetActive(false)
		self.recommendScrollView:SetActive(false)
		self:RecruitViewDisplayState(false)
		self.controller:RequestDataByType(Enum.FriendTogglePageType.FansList)
		self:RefreshFansListData()
		self.numIcon.image.sprite =  self.numIcon.switchSprite:GetSprite("ic_qty_2")
	elseif index == Enum.FriendTogglePageType.BlackList then
		self.searchNode:SetActive(false)
		self.recommendScrollView:SetActive(false)
		self:RecruitViewDisplayState(false)
		self.controller:RequestDataByType(Enum.FriendTogglePageType.BlackList)
		self:RefreshBlackListData()
		self.numIcon.image.sprite =  self.numIcon.switchSprite:GetSprite("ic_qty_3")
	elseif index == Enum.FriendTogglePageType.FriendRecommend then
		self.numRoot:SetActive(false)
		self.searchNode:SetActive(true)
		self.scrollview:SetActive(false)
		self:RecruitViewDisplayState(false)
		self.controller:RequestFriendRecommend()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FriendRecommend)
		self.numIcon.image.sprite =  self.numIcon.switchSprite:GetSprite("ic_qty_1")
	elseif index == Enum.FriendTogglePageType.FriendInvitation then
		self.numRoot:SetActive(false)
		self.searchNode:SetActive(true)
		self.scrollview:SetActive(false)
		self.recommendScrollView:SetActive(false)

		self:RecruitViewDisplayState(true)
		self.friendRecruitView:Refresh()
	end
	if self.lastIndex == Enum.FriendTogglePageType.FansList and index ~= Enum.FriendTogglePageType.FansList then
		self.controller:CleanRedPoint()
	end

	self.lastIndex = index
end

function UIFriendListView:RecruitViewDisplayState(state)
	self.recruitUI:SetActive(state)
	self.numRoot:SetActive(not state)
	self.myRecruitCode:SetActive(state)
	self.btnRecruitShop:SetActive(state)
end

function UIFriendListView:OnUpdateDataList(type)
	if self.pageToggleData.toggleDefaultIndex ~= type then
		return
	end

	if type == Enum.FriendTogglePageType.InterestList then
		self.controller:ReqestFriendBriefData(Enum.FriendTogglePageType.InterestList)
	elseif type == Enum.FriendTogglePageType.FansList then
		self.controller:ReqestFriendBriefData(Enum.FriendTogglePageType.FansList)
	elseif type == Enum.FriendTogglePageType.BlackList then
		self.controller:ReqestFriendBriefData(Enum.FriendTogglePageType.BlackList)
	elseif type == Enum.FriendTogglePageType.FriendRecommend then
		self:RefreshRecommendData()
	end
end

function UIFriendListView:OnRefreshData(type)
	self.fansRedPoint:SetActive(ManagerContainer.DataMgr.FriendDataMgr:HasNewFans())
	if self.pageToggleData.toggleDefaultIndex ~= type then
		return
	end

	if type == Enum.FriendTogglePageType.InterestList then
		self:RefreshInterestListData()
	elseif type == Enum.FriendTogglePageType.FansList then
		self:RefreshFansListData()
	elseif type == Enum.FriendTogglePageType.BlackList then
		self:RefreshBlackListData()
	elseif type == Enum.FriendTogglePageType.FriendRecommend then
		self:RefreshRecommendData()
	end
end

function UIFriendListView:OnDragScrollView()
	 if self.pageToggleData.toggleDefaultIndex~= Enum.FriendTogglePageType.FriendRecommend then
		local curTime = Time.realtimeSinceStartup
		if (curTime - self.lastReqTime) >= 0.1 then
			self.controller:ReqestFriendBriefData(self.pageToggleData.toggleDefaultIndex)
			self.lastReqTime = curTime
		end
	end
end

function UIFriendListView:OnShowSearchData()
	if self.pageToggleData.toggleDefaultIndex ~= Enum.FriendTogglePageType.FriendRecommend then
		return
	end

	local searchName = StringUtil.Trim(self.searchNameInput.inputField.text)
	if searchName == nil or searchName == "" then
		self:RefreshRecommendData()
		return
	end

	
	self.recommendScrollView:SetActive(false)

	local searchData = self.controller:GetSearchData()
	if searchData == nil or #searchData == 0 then
		self.emptyContent.text.text = I18N.T("SearchFriendsDefault")
		self.emptyTips:SetActive(true)
	else
		self.emptyTips:SetActive(false)
		self.recommendScrollView:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
								self.recommendScrollView.loopVerticalScrollRect,
								self.recommendScrollView.content.gridLayoutGroup,searchData,0,self,self.OnUpdateRecommendData)
	end
	
end

function UIFriendListView:RefreshInterestListData()
	local dataList = self.controller:GetDataByType(Enum.FriendTogglePageType.InterestList)
	if not dataList or #dataList == 0 then
		self.emptyContent.text.text = I18N.T("FollowFriendsListDefault")
		self.emptyTips:SetActive(true)
		self.scrollview:SetActive(false)
	else
		self.emptyTips:SetActive(false)
		self.scrollview:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
								self.scrollview.loopVerticalScrollRect,
								self.scrollview.content.gridLayoutGroup,dataList,0,self,self.OnUpdateInterestData)
	end
	self.num.text.text = self.controller:GetNum(Enum.FriendTogglePageType.InterestList) .. "/" .. self.controller:GetMaxNum(Enum.FriendTogglePageType.InterestList)
end

function UIFriendListView:RefreshFansListData()
	local dataList = self.controller:GetDataByType(Enum.FriendTogglePageType.FansList)
	if not dataList or #dataList == 0 then
		self.emptyContent.text.text = I18N.T("MyFansListDefault")
		self.emptyTips:SetActive(true)
		self.scrollview:SetActive(false)
	else
		self.emptyTips:SetActive(false)
		self.scrollview:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
								self.scrollview.loopVerticalScrollRect,
								self.scrollview.content.gridLayoutGroup,dataList,0,self,self.OnUpdateFansData)
	end
	self.num.text.text = self.controller:GetNum(Enum.FriendTogglePageType.FansList) .. "/" .. self.controller:GetMaxNum(Enum.FriendTogglePageType.FansList)
end

function UIFriendListView:RefreshBlackListData()
	local dataList = self.controller:GetDataByType(Enum.FriendTogglePageType.BlackList)
	if not dataList or #dataList == 0 then
		self.emptyContent.text.text = I18N.T("BlacklistDefault")
		self.emptyTips:SetActive(true)
		self.scrollview:SetActive(false)
	else
		self.emptyTips:SetActive(false)
		self.scrollview:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
								self.scrollview.loopVerticalScrollRect,
								self.scrollview.content.gridLayoutGroup,dataList,0,self,self.OnUpdateBlackData)
	end
	self.num.text.text = self.controller:GetNum(Enum.FriendTogglePageType.BlackList) .. "/" .. self.controller:GetMaxNum(Enum.FriendTogglePageType.BlackList)
end

function UIFriendListView:RefreshRecommendData()
	local dataList = self.controller:GetDataByType(Enum.FriendTogglePageType.FriendRecommend)
	if not dataList or #dataList == 0 then
		self.emptyContent.text.text = I18N.T("RecommendFriendsDefault")
		self.emptyTips:SetActive(true)
		self.recommendScrollView:SetActive(false)
	else
		self.emptyTips:SetActive(false)
		self.recommendScrollView:SetActive(true)
		CommonUtil.LoopGridViewEleCreateNew(self,
								self.recommendScrollView.loopVerticalScrollRect,
								self.recommendScrollView.content.gridLayoutGroup,dataList,0,self,self.OnUpdateRecommendData)
	end
	self.num.text.text = self.controller:GetNum(Enum.FriendTogglePageType.InterestList) .. "/" .. self.controller:GetMaxNum(Enum.FriendTogglePageType.InterestList)
end

function UIFriendListView:OnUpdateInterestData(itemLua,idx,itemData)
	self:SetItemData(itemLua,itemData,Enum.FriendTogglePageType.InterestList)
end

function UIFriendListView:OnUpdateFansData(itemLua,idx,itemData)
	self:SetItemData(itemLua,itemData,Enum.FriendTogglePageType.FansList)
end

function UIFriendListView:OnUpdateBlackData(itemLua,idx,itemData)
	self:SetItemData(itemLua,itemData,Enum.FriendTogglePageType.BlackList)
end

function UIFriendListView:OnUpdateRecommendData(itemLua,idx,itemData)
	self:SetItemData(itemLua,itemData,Enum.FriendTogglePageType.FriendRecommend)
end

function UIFriendListView:SetItemData(itemLua,itemData,type)
	if itemLua == nil or itemData == nil then
		return
	end

	local _jbIcon = nil;
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(itemData.job)
	if jobCfg ~= nil then
		_jbIcon = jobCfg.JobIcon;
	end

	local _headIcon = nil;
	if itemData.head ~= nil then
		_headIcon = itemData.head;
	end
--[[
	CommonUtil.LoadIcon(self, self.headUrl, function (sprite)
		itemLua.headItem.headFrame.image.sprite = sprite
	end)
]]--

	local _fakerData = {Level = itemData.level, ProfessionIcon = _jbIcon, HeadIcon = _headIcon, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, itemLua.headItem, _fakerData,false, itemData.headFrameId, self, self.OnClickPlayerHead, itemData.uid);

	itemLua.redPoint:SetActive(itemData:IsNew())
	--itemLua.headItem.levelText.text.text = tostring(itemData.level)
	itemLua.playerName.text.text = itemData.name
	itemLua.fightPower.text.text = tostring(itemData.fightPower)
	itemLua.statusLbl.text.text = itemData:GetOnlineStatus()
	itemLua.playerFollow.image.sprite = itemLua.playerFollow.switchSprite:GetSprite(itemData:StatusImage())

	if type == Enum.FriendTogglePageType.InterestList then
		itemLua.followBtn:SetActive(false)
		itemLua.unfollowBtn:SetActive(true)
		itemLua.chatBtn:SetActive(true)
		itemLua.removeBlackBtn:SetActive(false)
	elseif type == Enum.FriendTogglePageType.FansList then
		local attended = (CommonUtil.And(itemData.status,Enum.FriendStatusType.MyInterest) == Enum.FriendStatusType.MyInterest)
		itemLua.followBtn:SetActive(not attended)
		itemLua.unfollowBtn:SetActive(attended)
		itemLua.chatBtn:SetActive(true)
		itemLua.removeBlackBtn:SetActive(false)
	elseif type == Enum.FriendTogglePageType.BlackList then
		itemLua.followBtn:SetActive(false)
		itemLua.unfollowBtn:SetActive(false)
		itemLua.chatBtn:SetActive(false)
		itemLua.removeBlackBtn:SetActive(true)
	else
		local attended = (CommonUtil.And(itemData.status,Enum.FriendStatusType.MyInterest) == Enum.FriendStatusType.MyInterest)
		itemLua.followBtn:SetActive(not attended)
		itemLua.unfollowBtn:SetActive(attended)
		itemLua.chatBtn:SetActive(false)
		itemLua.removeBlackBtn:SetActive(false)
	end

	self.uiBase:AddButtonUniqueEventListener(itemLua.followBtn.button, self, self.OnClickFollowPlayer, itemData.uid)
	self.uiBase:AddButtonUniqueEventListener(itemLua.unfollowBtn.button, self, self.OnClickUnfollowPlayer, itemData.uid)
	self.uiBase:AddButtonUniqueEventListener(itemLua.chatBtn.button, self, self.OnClickChatWithPlayer, itemData.uid,itemData.name,itemData.head, itemData.job, itemData.level,itemData.sex)
	self.uiBase:AddButtonUniqueEventListener(itemLua.removeBlackBtn.button, self, self.OnClickRemoveBlackPlayer, itemData.uid)
	--self.uiBase:AddButtonUniqueEventListener(itemLua.headItem.head.button,self,self.OnClickPlayerHead,itemData.uid)
end

function UIFriendListView:OnClickFollowPlayer(btn,param)
	local uid = param[0]
	self.controller:FollowPlayer(uid)
end

function UIFriendListView:OnClickUnfollowPlayer(btn,param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:ShowMessageBox("UnfollowPlayer",nil,uid,self,self.OnConfirmUnfollow,nil)
end

function UIFriendListView:OnConfirmUnfollow(uid)
	self.controller:UnfollowPlayer(uid)
end

function UIFriendListView:OnClickChatWithPlayer(btn,param)
	local uid = param[0]
	local nickName = param[1]
	local headId = param[2]
	local jobId = param[3]
	local level = param[4]
	local sex = param[5]
	self.controller:ChatToPlayer(uid,nickName,headId, jobId, level,sex)
end

function UIFriendListView:OnClickRemoveBlackPlayer(btn,param)
	local uid = param[0]
	self.controller:RemoveBlackPlayer(uid)
end

function UIFriendListView:OnClickPlayerHead(btn,param)
	local uid = param[0]
	self.controller:ShowPlayerInfo(uid)
end

function UIFriendListView:OnMasterInfoRefresh(briefInfo)
	if self.friendRecruitView then
		self.friendRecruitView:RefreshMasterInfo(briefInfo)
	end
end

return UIFriendListView

