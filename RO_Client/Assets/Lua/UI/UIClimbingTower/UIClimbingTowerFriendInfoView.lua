local UIClimbingTowerFriendInfoView = require("UIClimbingTower/UIClimbingTowerFriendInfoView_Generate")

function UIClimbingTowerFriendInfoView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerFriendInfoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerFriendInfoView:AddEventListener()

end

function UIClimbingTowerFriendInfoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerFriendInfoView:Init()
	self.frameUrl = GlobalConfig.Instance:GetConfigStrValue(179)
	local levelInfo = self.controller:GetLevelInfo(self.controller:GetData())
	if levelInfo ~= nil then
		self:SetFriendData(levelInfo:GetFriendsInfo())
	end
end

function UIClimbingTowerFriendInfoView:SetFriendData(friendList)
	if friendList ~= nil then
		CommonUtil.LoopGridViewEleCreateNew(self,
			self.friendScrollView.loopVerticalScrollRect,
			self.content.gridLayoutGroup,friendList,0,self,self.SetPlayerInfo)
	end
end

function UIClimbingTowerFriendInfoView:SetPlayerInfo(headLua,idx,playerData)
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerData.job)
	local _fakerData = {Level = playerData.level, ProfessionIcon = jobCfg.JobIcon, HeadIcon = playerData.head, IsHero = true};
	CommonUtil.SetPlayerHeadAndFrame(self, headLua.headItem, _fakerData,false, playerData.headFrameId, self, self.OnClickPlayerHead, playerData.uid);

	headLua.playerName.text.text = playerData.name
	headLua.guildNode:SetActive(false)
	headLua.friendNode:SetActive(true)
end

function UIClimbingTowerFriendInfoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIClimbingTowerFriendInfoView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.CloseBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self,self.OnClickClose)
end

function UIClimbingTowerFriendInfoView:OnHide()

end

function UIClimbingTowerFriendInfoView:OnShow(data)
	self.controller:SetData(data)

end

function UIClimbingTowerFriendInfoView:OnClose()
end

function UIClimbingTowerFriendInfoView:OnDispose()
	self.controller:OnDispose()
end

function UIClimbingTowerFriendInfoView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIClimbingTowerFriendInfo)
end

function UIClimbingTowerFriendInfoView:OnClickPlayerHead(btn,param)
	local uid = param[0]
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

return UIClimbingTowerFriendInfoView

