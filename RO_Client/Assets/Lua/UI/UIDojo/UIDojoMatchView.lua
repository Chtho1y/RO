local UIDojoMatchView = require("UIDojo/UIDojoMatchView_Generate")

function UIDojoMatchView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoMatchCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoMatchView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Progress, self, self.OnLoadingProgress)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Loading_Complete, self, self.OnLoadingComplete)
end

function UIDojoMatchView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self.emptyNode:SetActive(true)
	self:Init()
end

function UIDojoMatchView:Init()
	self.MatchingNode:SetActive(false)
	self.VSNode:SetActive(true)
	self:SetOurMembers()
	self:SetEnemyMembers()
	self.progress.image.fillAmount = 0
	self.progressTxt.text.text = "0%"
	ManagerContainer.LuaTimerMgr:AddTimer(1000, 1,self,self.NtfLoaded,nil)
end

function UIDojoMatchView:NtfLoaded()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loaded_Page_OK)
end

function UIDojoMatchView:SetOurMembers()
	local data = self.controller:GetData()
	if data then
		local ourMembers = data['ourActors']
		if ourMembers ~= nil then
			CommonUtil.LoopGridViewEleCreateNew(self,
										self.rightMemberScrollView.loopVerticalScrollRect,
										self.rightContent.gridLayoutGroup,ourMembers,0,self,self.OnUpdateOurMemberData)
		end
	end
end

function UIDojoMatchView:SetEnemyMembers()
	local data = self.controller:GetData()
	if data then
		local enemyMembers =  data['enemyActors']
		if enemyMembers ~= nil then
			CommonUtil.LoopGridViewEleCreateNew(self,
										self.leftMemberScrollView.loopVerticalScrollRect,
										self.leftContent.gridLayoutGroup,enemyMembers,0,self,self.OnUpdateEnemyMemberData)
			self.emptyNode:SetActive(false)
		end
	end
end

function UIDojoMatchView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIDojoMatchView:AddUIEventListener()
end

function UIDojoMatchView:OnHide()

end

function UIDojoMatchView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoMatchView:OnClose()
end

function UIDojoMatchView:OnDispose()
	self.rightMemberScrollView.loopVerticalScrollRect:ClearCells()
	self.leftMemberScrollView.loopVerticalScrollRect:ClearCells()
end

function UIDojoMatchView:OnUpdateOurMemberData(actorLua,idx,actorData)
	self:SetActorItemData(actorLua,actorData)
end

function UIDojoMatchView:OnUpdateEnemyMemberData(actorLua,idx,actorData)
	self:SetActorItemData(actorLua,actorData)
end

function UIDojoMatchView:SetActorItemData(actorLua,actorData)
	if actorLua == nil or actorData == nil then
		return
	end

	CommonUtil.SetPlayerHeadAndFrame(self, actorLua, actorData,false,actorData.HeadFrameId)
	actorLua.name.text.text = actorData.Name
end

function UIDojoMatchView:OnLoadingProgress(progress)
	if progress > 1 then
		progress = 1
	end
	self.progress.image.fillAmount = progress
	self.progressTxt.text.text = math.floor(progress*100).."%"
end

function UIDojoMatchView:OnLoadingComplete()
	LogWarning("UIDojoMatchView:OnLoadingComplete ")

	self.progress.image.fillAmount = 1
	self.progressTxt.text.text = "100%"
	ManagerContainer.LuaTimerMgr:AddTimer(300, 1,self,self.OnDelayClose,nil)
end

function UIDojoMatchView:OnDelayClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoMatch)
end

return UIDojoMatchView

