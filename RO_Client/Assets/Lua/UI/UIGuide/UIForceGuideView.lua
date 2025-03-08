local UIForceGuideView = require("UIGuide/UIForceGuideView_Generate")

local boliPos = Vector2.zero
local expandSize = Vector2.zero
local offset = Vector2.zero

local lateUpdateBeat
function UIForceGuideView:OnAwake(data)
	self.controller = require("UIGuide/UIForceGuideCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIForceGuideView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_PAGE_IN_END_NTF, self, self.UIPageInEnd)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_FORCE_GUIDE_DISPLAY, self, self.NextForceGuide)
end

function UIForceGuideView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIForceGuideView:Init()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PRIVATER_CHAT_BTN_DISPLAY, false)

	if not lateUpdateBeat then
		lateUpdateBeat = LateUpdateBeat:CreateListener(self.LateUpdate, self)
	end

	LateUpdateBeat:AddListener(lateUpdateBeat)
	self.maskCloseDelayTime = 0
	self.delayFunc = nil
	self.target = nil

	self.mask.guideMask:Init(self, self.MaskAnimCompeleted, self.maskPoint.rectTransform)
	self:Refresh()
end

function UIForceGuideView:NextForceGuide(data)
	self.controller:SetData(data)
	self:Refresh()
end

function UIForceGuideView:Refresh()
	if self.errorOverTimer then
		--ManagerContainer.LuaTimerMgr:RemoveTimer(self.errorOverTimer)
		self.errorOverTimer:Stop()
		self.errorOverTimer = nil
	end

	self.mask.guideMask:SetDefaultState(true)

	local curGuideId = ManagerContainer.ForceGuideMgr:GetCurGuideId()
	local cfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(curGuideId)
	if cfgData == nil then
		LogHRWarning(curGuideId.." isnt in ForceGuideCfg")
		ManagerContainer.ForceGuideMgr:ForceGuideOver(true)
		return
	end

	self.guideCfgData = cfgData
	expandSize.x = self.guideCfgData.ExpandSize[1]
	expandSize.y = self.guideCfgData.ExpandSize[2]

	offset.x = self.guideCfgData.CenterOffset[1]
	offset.y = self.guideCfgData.CenterOffset[2]

	if self.guideCfgData.LogicLua ~= "" then
		local logicLua = require("ForceGuide/"..self.guideCfgData.LogicLua)
		logicLua:Enter(self, self.guideCfgData.UIId, self.guideCfgData.LuaParam, self.DelayMaskClose)
	else
		self:DelayMaskClose()
	end
end

function UIForceGuideView:DelayMaskClose(isError, target)
	if isError then
		ManagerContainer.ForceGuideMgr:ForceGuideOver(true)
		return
	end

	if self.guideCfgData == nil then return end

	if self.guideCfgData.MaskCloseDelayTime > 0 then
		self.maskCloseDelayTime = self.guideCfgData.MaskCloseDelayTime * 0.001
		self.delayFunc = self.StartCloseMask
		self.target = target
	else
		self:StartCloseMask(target)
	end
end

function UIForceGuideView:LateUpdate()
	if self.maskCloseDelayTime > 0 then
		self.maskCloseDelayTime = self.maskCloseDelayTime - Time.unscaledDeltaTime
		if self.maskCloseDelayTime <= 0 then
			self.delayFunc(self, self.target)
			self.delayFunc = nil
			self.target = nil
			self.maskCloseDelayTime = 0
		end
	end
end

function UIForceGuideView:StartCloseMask(target)
	self.maskPoint.image.raycastTarget = false

	local guidePage = ManagerContainer.LuaUIMgr:GetPage(self.guideCfgData.UIId)
	if guidePage then
		local pageView = guidePage.MLuaTable
		if target == nil then
			target = CommonUtil.ParseUITargetPath(pageView, self.guideCfgData.Path)
			if target == nil then
				ManagerContainer.ForceGuideMgr:ForceGuideOver(true)
				return
			end
		end

		local rectTrans = target:GetComponent(Enum.TypeInfo.RectTransform)
		if rectTrans == nil then
			ManagerContainer.ForceGuideMgr:ForceGuideOver(true)
			return
		end

		self.maskPoint:SetActive(true)
		local position = CameraMgr.Instance.UICamera:WorldToScreenPoint(target.transform.position)
		position = CameraMgr.Instance.UICamera:ScreenToViewportPoint(position)
		position.x = (position.x - 0.5) * UIMgr.SCREEN_WIDTH
		position.y = (position.y - 0.5) * UIMgr.SCREEN_HEIGHT
		self.maskPoint.rectTransform.anchoredPosition = position

		local rectTransform = target:GetComponent(Enum.TypeInfo.RectTransform)
		local pivot = rectTransform.pivot;
		pivot.x = 0.5 - pivot.x
		pivot.y = 0.5 - pivot.y
		self.maskPoint.rectTransform.anchoredPosition = self.maskPoint.rectTransform.anchoredPosition + Vector2.Scale(rectTransform.sizeDelta, pivot) + offset
		self.realSize = rectTransform.rect.size + expandSize
		self.targetPoint.transform.position = self.maskPoint.transform.position
		self.targetPoint:SetActive(true)

		boliPos.x = self.guideCfgData.BoLiPos[1]
		boliPos.y = self.guideCfgData.BoLiPos[2]
		self.boliPoint.rectTransform.anchoredPosition = boliPos + self.maskPoint.rectTransform.anchoredPosition
		self.boliPoint.text.text.text = I18N.T(self.guideCfgData.BoLiNote)
		self.boliPoint:SetActive(true)

		self.mask:SetActive(self.guideCfgData.Type == 0 or self.guideCfgData.Type == nil)
		self.maskPoint.rectTransform.sizeDelta = self.realSize
		if self.guideCfgData.Type == 0 or self.guideCfgData.Type == nil then
			self.maskPoint.image.raycastTarget = false
			self.uiBase:AddButtonUniqueEventListener(self.maskPoint.button, self, function ()
				if target == nil then
					self:ErrorOver()
					return
				end

				local nextId = self.guideCfgData.Id + 1
				local nextCfgData = ManagerContainer.CfgMgr:GetForceGuideDataById(nextId)
				if nextCfgData and self.guideCfgData.UIId ~= nextCfgData.UIId and self.guideCfgData.Group == nextCfgData.Group then
					local nextUIData = ManagerContainer.CfgMgr:GetUIData(nextCfgData.UIId)
					if nextUIData and nextUIData.page_anim_in_type == 0 then
						ManagerContainer.ForceGuideMgr:MaskOpenAnimCompeleted()
						ManagerContainer.ForceGuideMgr:SetHasMaskOpenCompeleted(true)
					end
				end

				--self.errorOverTimer = ManagerContainer.LuaTimerMgr:AddTimer(5000, 1, self, self.ErrorOver, nil)
				if self.errorOverTimer then
					self.errorOverTimer:Stop()
					self.errorOverTimer = nil
				end

				self.errorOverTimer = Timer.New(function ()
					self:ErrorOver()
				end, 5)
				self.errorOverTimer:Start()

				local button1 = target:GetComponent(Enum.TypeInfo.RepeatButton)
				if button1 then
					button1:ImmediatelyEffect()
				else
					button1 = target:GetComponent(Enum.TypeInfo.Button)
					if button1 then
						button1.onClick:Invoke()
					else
						local toggle = target:GetComponent(Enum.TypeInfo.Toggle)
						if toggle then
							toggle.onValueChanged:Invoke(true)
						end
					end
				end

					self:OnTargetClick()
				end)

			self.mask.guideMask:SetTargetInfoClose(self.maskPoint.transform.position, self.realSize, self.guideCfgData.MaskCloseTime * 0.001)
		elseif self.guideCfgData.Type == 1 then
			self.maskPoint.image.raycastTarget = true
			self.uiBase:AddButtonUniqueEventListener(self.maskPoint.button, self, function ()
				if target == nil then
					self:ErrorOver()
					return
				end

				local button1 = target:GetComponent(Enum.TypeInfo.Button)
				if button1 then
					button1.onClick:Invoke()
				end

				self:OnTargetClick()
			end)
		end
	else
		ManagerContainer.ForceGuideMgr:ForceGuideOver(true)
		return
	end
end

function UIForceGuideView:MaskAnimCompeleted(isClose)
	if isClose then
		self.maskPoint.image.raycastTarget = true
	else
		--self.maskPoint:SetActive(false)
		self.maskPoint.image.raycastTarget = false
		self.mask.guideMask:SetDefaultState(true)
		ManagerContainer.ForceGuideMgr:MaskOpenAnimCompeleted()
	end
end

function UIForceGuideView:OnTargetClick()
	self.boliPoint:SetActive(false)
	self.targetPoint:SetActive(false)

	if self.guideCfgData.Type == 0 or self.guideCfgData.Type == nil then
		self.mask.guideMask:SetTargetInfoOpen(self.maskPoint.transform.position, self.realSize, self.guideCfgData.MaskOpenTime * 0.001)
	elseif self.guideCfgData.Type == 1 then
		ManagerContainer.ForceGuideMgr:MaskOpenAnimCompeleted()
	end
end

function UIForceGuideView:ErrorOver()
	ManagerContainer.ForceGuideMgr:ForceGuideOver(true)
end

function UIForceGuideView:UIPageInEnd(id)

end

function UIForceGuideView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIForceGuideView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	--self.mask.uIEventTriggerListener.onClick = function()
	--	self:GetCurClickPos()
	--end

	self.uiBase:AddUIEventHandlerClickListener(self.uIEventHandler, function (go)
		if self.guideCfgData.Type == 0 or self.guideCfgData.Type == nil then return end

		self:OnTargetClick()
	end)
end

function UIForceGuideView:GetCurClickPos()
	local position = self.mask.uIEventTriggerListener.currentEventData.position
	position = CameraMgr.Instance.UICamera:ScreenToViewportPoint(position)
	position.x = (position.x - 0.5) * UIMgr.SCREEN_WIDTH
	position.y = (position.y - 0.5) * UIMgr.SCREEN_HEIGHT

	local delta = Vector2(position.x, position.y) - self.maskPoint.rectTransform.anchoredPosition
	LogHRWarning("forceGuide click delta position  x:"..delta.x.."   y:"..delta.y)
	self.boliPoint.rectTransform.anchoredPosition = position
end

function UIForceGuideView:OnHide()

end

function UIForceGuideView:OnShow(data)
	self.controller:SetData(data)
	self:Refresh()
end

function UIForceGuideView:OnClose()
	if self.errorOverTimer then
		--ManagerContainer.LuaTimerMgr:RemoveTimer(self.errorOverTimer)
		self.errorOverTimer:Stop()
		self.errorOverTimer = nil
	end

	if lateUpdateBeat ~= nil then
		LateUpdateBeat:RemoveListener(lateUpdateBeat)
		lateUpdateBeat = nil
	end

	self.delayFunc = nil
	self.target = nil

	self.uIEventHandler:RemoveListener()
	DG.Tweening.DOTween.Kill(self.transform)

	ManagerContainer.ForceGuideMgr:ForceOver()
end

function UIForceGuideView:OnDispose()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PRIVATER_CHAT_BTN_DISPLAY, true)

	self.mask.uIEventTriggerListener.onClick = nil
	self.mask.guideMask:Dispose()
	self.realSize = nil
	self.guideCfgData = nil

	self.controller:OnDispose()
end

return UIForceGuideView

