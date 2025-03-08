local UIChapterView = require("UIChapter/UIChapterView_Generate")

function UIChapterView:OnAwake(data)
	self.controller = require("UIChapter/UIChapterCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChapterView:AddEventListener()

end

function UIChapterView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChapterView:Init()
	local cfgId = self.controller:GetCfgId()
	if cfgId then
		local storyChapterCfgData = ManagerContainer.CfgMgr:GetStoryChapterById(cfgId)
		if storyChapterCfgData then
			self.textC.uILocalizeScript:SetContent(storyChapterCfgData.Name)
			self.text2.uILocalizeScript:SetContent(storyChapterCfgData.Content)

			CommonUtil.LoadIcon(self, storyChapterCfgData.Icon, function (sprite)
				self.logo1.image.sprite = sprite
				self.logoLt.image.sprite = sprite
			end, self, 'IconAsyncIdx')
		end
	end

	local animator = self.uICapterAnim.animator
	local showStateInfo = animator:GetCurrentAnimatorStateInfo(0)
	local closeTime
	if showStateInfo then
		closeTime = showStateInfo.length
		local normalizedTime = showStateInfo.normalizedTime
		closeTime = (1 - normalizedTime) * closeTime
	end
	if not closeTime then closeTime = 0 end
	if not self.timer then
		self.timer = Timer.New(function()
			self:UIClose()
		end, closeTime, 1)
	end
	if self.timer.running then
		self.timer.time = closeTime
	else
		self.timer:Start()
	end
end

function UIChapterView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChapterView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIChapterView:OnHide()

end

function UIChapterView:OnShow(data)
	self.controller:SetData(data)

end

function UIChapterView:OnClose()
end

function UIChapterView:OnDispose()
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	self.controller:OnDispose()
end

return UIChapterView

