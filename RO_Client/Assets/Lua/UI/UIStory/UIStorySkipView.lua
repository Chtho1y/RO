local UIStorySkipView = require("UIStory/UIStorySkipView_Generate")

function UIStorySkipView:OnAwake(data)
	self.controller = require("UIStory/UIStorySkipCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIStorySkipView:AddEventListener()

end

function UIStorySkipView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIStorySkipView:Init()
end

function UIStorySkipView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIStorySkipView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.skip.button, self, self.OnClickSkipBtn)
end

function UIStorySkipView:OnHide()

end

function UIStorySkipView:OnShow(data)
	self.controller:SetData(data)

end

function UIStorySkipView:OnClose()
end

function UIStorySkipView:OnDispose()
	self.controller:OnDispose()
end


function UIStorySkipView:OnClickSkipBtn()
	ManagerContainer.StoryMgr:SkipCurStoryChapter()
end

return UIStorySkipView

