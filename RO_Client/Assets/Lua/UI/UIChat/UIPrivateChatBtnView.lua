local UIPrivateChatBtnView = require("UIChat/UIPrivateChatBtnView_Generate")

local updateBeat
local isDragging = false

local tmpPos = Vector3.zero
local pos = Vector2.zero
local edgeX = Vector2.zero
local edgeY = Vector2.zero

local UIClickSound
function UIPrivateChatBtnView:OnAwake(data)
	self.controller = require("UIChat/UIPrivateChatBtnCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPrivateChatBtnView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PRIVATER_CHAT_BTN_DISPLAY,self,self.PrivateBtnDisplay);
end

function UIPrivateChatBtnView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPrivateChatBtnView:Init()
	UIClickSound = GlobalConfig.Instance:GetConfigStrValue(176)

	if not updateBeat then
		updateBeat = UpdateBeat:CreateListener(self.Update, self)
	end
	local sizeDelta = self.btnEmoji.rectTransform.sizeDelta
	edgeX.x = sizeDelta.x/2 - self.rectTransform.rect.size.x
	edgeX.y = -sizeDelta.x/2
	edgeY.x = sizeDelta.y/2
	edgeY.y = self.rectTransform.rect.size.y - sizeDelta.y/2

	UpdateBeat:AddListener(updateBeat)

	self:GetBtnPosRecord()
end

function UIPrivateChatBtnView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPrivateChatBtnView:OnPrivateChatOpen()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChatPrivate)
end

function UIPrivateChatBtnView:Update()
	if not isDragging then return end

	local position = self.btnEmoji.uIEventTriggerListener.currentEventData.position
	tmpPos = ManagerContainer.LuaUIMgr:ScreenPointToLocalPointInRectangle(self.rectTransform, position)

	tmpPos.x = tmpPos.x - self.rectTransform.rect.size.x*0.5
	tmpPos.y = tmpPos.y + self.rectTransform.rect.size.y*0.5

	tmpPos.x = CommonUtil.Clamp(edgeX.x, edgeX.y, tmpPos.x)
	tmpPos.y = CommonUtil.Clamp(edgeY.x, edgeY.y, tmpPos.y)

	self.btnEmoji.rectTransform.anchoredPosition = tmpPos
end

function UIPrivateChatBtnView:PrivateBtnDisplay(state)
	self.btnEmoji:SetActive(state)
end

--function UIPrivateChatBtnView:OnBtnDragging()
--	local position = self.btnEmoji.uIEventTriggerListener.currentEventData.position
--	local sizeDelta = self.btnEmoji.rectTransform.sizeDelta
--
--	local result = CommonUtil.IsScreenUIMoveLimit(position, sizeDelta)
--	if not result then return end
--
--	self.btnEmoji.rectTransform.anchoredPosition3D = CommonUtil.ConvertScreenPos2UIPos(position)
--end

function UIPrivateChatBtnView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	--self.uiBase:AddButtonEventListener(self.btnEmoji.button, self, self.OnPrivateChatOpen)

	self.btnEmoji.uIEventTriggerListener.onClick = function()
		MusicMgr.Instance:PlayUISound(UIClickSound, false)
		self:OnPrivateChatOpen()
	end

	self.btnEmoji.uIEventTriggerListener.onPointerDown = function()
		isDragging = true
	end

	self.btnEmoji.uIEventTriggerListener.onPointerUp = function()
		isDragging = false

		self:SaveBtnPosRecord()
	end

	--self.btnEmoji.uIEventTriggerListener.onPointerExit = function()
	--	isDragging = false
	--end

	--self.btnEmoji.uIEventTriggerListener.onDrag = function()
	--	self:OnBtnDragging()
	--end
end

function UIPrivateChatBtnView:SaveBtnPosRecord()
	local uid = ManagerContainer.DataMgr.UserData:GetUserId()
	local pos = self.btnEmoji.rectTransform.anchoredPosition
	local json = {pos.x, pos.y}
	UnityEngine.PlayerPrefs.SetString(tostring(uid).."PrivateBtnPos", JSON:encode(json))
end

function UIPrivateChatBtnView:GetBtnPosRecord()
	local uid = ManagerContainer.DataMgr.UserData:GetUserId()
	local str = UnityEngine.PlayerPrefs.GetString(tostring(uid).."PrivateBtnPos")
	if str ~= nil and str ~= "" then
		local json = JSON:decode(str)
		self.btnEmoji.rectTransform.anchoredPosition = Vector2(json[1], json[2])
	end
end

function UIPrivateChatBtnView:OnHide()

end

function UIPrivateChatBtnView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIPrivateChatBtnView:OnClose()

end

function UIPrivateChatBtnView:OnDispose()
	if updateBeat ~= nil then
		UpdateBeat:RemoveListener(updateBeat)
		updateBeat = nil
	end

	self.btnEmoji.uIEventTriggerListener.onClick = nil

	self.btnEmoji.uIEventTriggerListener.onPointerDown = nil

	self.btnEmoji.uIEventTriggerListener.onPointerUp = nil
end

return UIPrivateChatBtnView

