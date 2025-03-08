local UIStoryPlayVideoView = require("UIStory/UIStoryPlayVideoView_Generate")

function UIStoryPlayVideoView:OnAwake(data)
	self.controller = require("UIStory/UIStoryPlayVideoCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIStoryPlayVideoView:AddEventListener()

end

function UIStoryPlayVideoView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIStoryPlayVideoView:Init()
	self.videoPlayer.uIPlayVideo:BindLuaCallBack(self, self.PlayComplete)
	self.videoPlayer.uIPlayVideo:Play(UnityEngine.Application.streamingAssetsPath .. '/' .. self.controller:GetVideoPath())
end

function UIStoryPlayVideoView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIStoryPlayVideoView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIStoryPlayVideoView:OnHide()

end

function UIStoryPlayVideoView:OnShow(data)
	self.controller:SetData(data)

end

function UIStoryPlayVideoView:OnClose()
end

function UIStoryPlayVideoView:OnDispose()
	self.videoPlayer.uIPlayVideo:BindLuaCallBack(nil, nil)
	self.controller:OnDispose()
end

function UIStoryPlayVideoView:PlayComplete(errorCode)
	self:UIClose()
end

return UIStoryPlayVideoView

