local UISummonAnimView = require("UISummon/UISummonAnimView_Generate")

function UISummonAnimView:OnAwake(data)
	self.controller = require("UISummon/UISummonAnimCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISummonAnimView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_CLOSE_COMPELETED, self, self.OnUICloseCompleted)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_PAGE_OUT_END_NTF, self, self.OnUIViewCloseAnimEnd)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SUMMON_AGAIN_DATA_CHANGED, self, self.OnSummonAgainDataChanged)
end

function UISummonAnimView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISummonAnimView:Init()
	self.againData = nil
	self.white:SetActive(false)
	self.guide:SetActive(false)
	if self.controller:HasNeedShowItem() then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonShow, nil, self.uiData.id)
	else
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonResult)
	end

	-- 下面是正常流程，后续再说
	-- self.white:SetActive(true)
	-- self.guide:SetActive(false)
	-- self.white.image:DOFade(1, 0)
	-- if not self.timer then
	-- 	self.timer = Timer.New(slot(self.TimerEnd, self), 1, -1)
	-- end
	-- self:LoadComplete()
end

function UISummonAnimView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	-- 下面是正常流程，后续再说
	-- local uIEventTriggerListener = self.drawRect.uIEventTriggerListener
	-- uIEventTriggerListener.onBeginDrag = nil
	-- uIEventTriggerListener.onEndDrag = nil
end

function UISummonAnimView:AddUIEventListener()
	-- 下面是正常流程，后续再说
	-- local uIEventTriggerListener = self.drawRect.uIEventTriggerListener
	-- uIEventTriggerListener.onBeginDrag = function()
	-- 	self:OnBeginDragDrawRect()
	-- end
	-- uIEventTriggerListener.onEndDrag = function()
	-- 	self:OnEndDragDrawRect()
	-- end
end

function UISummonAnimView:OnHide()

end

function UISummonAnimView:OnShow(data)
	self.controller:SetData(data)
end

function UISummonAnimView:OnClose()
end

function UISummonAnimView:OnDispose()
	self.againData = nil
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	if self.openDelayTimer then
		self.openDelayTimer:Stop()
		self.openDelayTimer = nil
	end
	self.controller:OnDispose()
end

function UISummonAnimView:OnUICloseCompleted(owner)
	-- 下面是正常流程，后续再说
	-- if owner.uiData.id == Enum.UIPageName.UISummonShow then
	-- 	self.white:SetActive(true)
	-- 	self.white.image:DOFade(0, 0)
	-- end
end

function UISummonAnimView:OnUIViewCloseAnimEnd(id)
	if id == Enum.UIPageName.UISummonResult then
		if self.againData then
			if not self.openDelayTimer then
				self.openDelayTimer = FrameTimer.New(slot(self.Init, self), 1)
			else
				self.openDelayTimer.count = Time.frameCount + 1
			end
			if not self.openDelayTimer.running then
				self.openDelayTimer:Start()
			end
			self.againData = false
		end
	end
end

function UISummonAnimView:OnSummonAgainDataChanged()
	self.againData = true
end

function UISummonAnimView:OnBeginDragDrawRect()
	if self.eventDataHashCode then return end
	local currentEventData = self.drawRect.uIEventTriggerListener.currentEventData
	if not currentEventData then return end
	self.eventDataHashCode = currentEventData:GetHashCode()
	if self.timer.state == 2 then
		self.timer:Stop()
	end
	self.guide:SetActive(false)
end

function UISummonAnimView:OnEndDragDrawRect()
	if not self.eventDataHashCode then return end
	local currentEventData = self.drawRect.uIEventTriggerListener.currentEventData
	if not currentEventData then return end
	if self.eventDataHashCode ~= currentEventData:GetHashCode() then
		return
	end
	self.eventDataHashCode = nil
	local deltaPos = currentEventData.position - currentEventData.pressPosition
	if Mathf.Approximately(deltaPos.y, 0) then
		if self.timer.state == 2 then
			self.timer.time = 5
			self.timer.duration = 5
			if not self.timer.running then
				self.timer:Start()
			end
		end
		return
	end
	self.white:SetActive(true)
	self.white.image:DOFade(1, 1)
	self.timer.state = 3
	self.timer.time = 1
	self.timer.duration = 1
	if not self.timer.running then
		self.timer:Start()
	end
end

function UISummonAnimView:LoadComplete()
	self.white:SetActive(true)
	self.white.image:DOFade(0, 1)
	self.timer.state = 1
	self.timer.time = 1
	self.timer.duration = 1
	if not self.timer.running then
		self.timer:Start()
	end
end

function UISummonAnimView:TimerEnd()
	if self.timer.state == 1 then
		self.white:SetActive(false)
		self.timer.state = 2
		self.timer.time = 0
		self.timer.duration = 5
		if not self.timer.running then
			self.timer:Start()
		end
	elseif self.timer.state == 2 then
		self.guide:SetActive(true)
		self.timer:Stop()
	elseif self.timer.state == 3 then
		self.timer:Stop()
		if self.controller:HasNeedShowItem() then
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonShow, nil, self.uiData.id)
		else
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonResult)
		end
	end
end

return UISummonAnimView

