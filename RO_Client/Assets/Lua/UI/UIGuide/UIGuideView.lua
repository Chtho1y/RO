local UIGuideView = require("UIGuide/UIGuideView_Generate")

local TransparentColor = {0.18,0.18,0.18, 0.3}
local BlackColor = {0.3,0.3, 0.3, 1}

function UIGuideView:OnAwake(data)
	self.controller = require("UIGuide/UIGuideCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuideView:AddEventListener()
	self.uiBase:AddUIEventHandlerClickListener(self.uIEventHandler, function (go)
		self:UIClose()
	end)
end

function UIGuideView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuideView:Init()
	local data = self.controller:GetData()
	local type = data.type
	local pos = data.pos
	local targetHeight = data.height

	if type == Enum.UIGuideSource.StageGoal then
		self.bg:SetActive(false)
		CommonUtil.SetGraphicColor(self.bg.image, TransparentColor)
		self.arrow_bg:SetActive(true)
		self.arrow_bg.transform.position = pos
		local height = self.arrow.rectTransform.sizeDelta.y
		self.arrow_bg.rectTransform.anchoredPosition = self.arrow_bg.rectTransform.anchoredPosition + Vector2.up * (targetHeight + height) * 0.5
	end
end

function UIGuideView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuideView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIGuideView:OnHide()

end

function UIGuideView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIGuideView:OnClose()

end

function UIGuideView:OnDispose()
	self.uIEventHandler:RemoveListener()

end

return UIGuideView

