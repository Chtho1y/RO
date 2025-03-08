local UINewStoryView = require("UINewStory/UINewStoryView_Generate")

function UINewStoryView:OnAwake(data)
	self.controller = require("UINewStory/UINewStoryCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINewStoryView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
end

function UINewStoryView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINewStoryView:Init()
	self.storyAnim.animator:Play('LoginStory', -1)
	self.storyAnim.animator:Update(0)
	self.storyAnim.animator.enabled = false
end

function UINewStoryView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UINewStoryView:AddUIEventListener()

end

function UINewStoryView:OnHide()

end

function UINewStoryView:OnShow(data)
	self.controller:SetData(data)

end

function UINewStoryView:OnClose()
end

function UINewStoryView:OnDispose()
	if self.closeTimer then
		self.closeTimer:Stop()
		self.closeTimer = nil
	end
	if self.animTimer then
		self.animTimer:Stop()
		self.animTimer = nil
	end
	self.controller:OnDispose()
end

function UINewStoryView:UIClose()
	self.super.UIClose(self)
end

function UINewStoryView:OnUICloseCompleted(owner)
	if not owner then return end
	if owner.uiData.id ~= Enum.UIPageName.UILanuch then return end
	self.storyAnim.animator.enabled = true
	self.storyAnim.animator:Play('LoginStory', -1)
	self.storyAnim.animator:Update(0)

	if self.closeTimer then
		self.closeTimer.duration = 15
		self.closeTimer.loop = 1
		self.closeTimer.time = 15
	else
		self.closeTimer = Timer.New(slot(self.UIClose, self), 15, 1)
	end
	if not self.closeTimer.running then
		self.closeTimer:Start()
	end
	if self.animTimer then
		self.animTimer.duration = 14
		self.animTimer.loop = 1
		self.animTimer.time = 14
	else
		self.animTimer = Timer.New(slot(self.PlayCamAnim, self), 14, 1)
	end
	if not self.animTimer.running then
		self.animTimer:Start()
	end
end

function UINewStoryView:PlayCamAnim()
	LuaBattleBridge.PlayCamAnim("CM_vcam1",true)
end

return UINewStoryView

