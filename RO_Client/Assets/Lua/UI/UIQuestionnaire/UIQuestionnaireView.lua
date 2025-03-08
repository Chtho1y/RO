local UIQuestionnaireView = require("UIQuestionnaire/UIQuestionnaireView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

local urlAddress
local rewards
function UIQuestionnaireView:OnAwake(data)
	self.controller = require("UIQuestionnaire/UIQuestionnaireCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIQuestionnaireView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIQuestionnaireView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIQuestionnaireView:Init()
	local userUid = ManagerContainer.DataMgr.UserData:GetUserId()
	urlAddress = GlobalConfig.Instance:GetConfigStrValue(246)
	--urlAddress = string.format(urlAddress, tostring(userUid))

	local str = GlobalConfig.Instance:GetConfigStrValue(247)
	rewards = CommonUtil.DeserializeGlobalStrToTable(str)

	self:RefreshReward()
end

function UIQuestionnaireView:RefreshReward()
	for i = 1, 3 do
		local reward = rewards[i]
		local item = self["item"..i]
		if reward and item then
			local iconItem = item.iconItem
			local data = {cfgId = tonumber(reward[1]), num = tonumber(reward[2])}
			IconItemCtr:SetData(self, iconItem, data, Enum.ItemIEnterType.Bag, self, self.ShowItemClick)
		end
	end
end

function UIQuestionnaireView:ShowItemClick(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIQuestionnaireView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIQuestionnaireView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnGotoQuestion.button, self, self.OnGotoClick)
	self.uiBase:AddButtonUniqueEventListener(self.BtnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnCloseClick)
end

function UIQuestionnaireView:OnCloseClick()
	self:UIClose()
end

function UIQuestionnaireView:OnGotoClick()
	ManagerContainer.LuaGameMgr:OpenUrl(urlAddress)
	self:UIClose()
end

function UIQuestionnaireView:OnHide()

end

function UIQuestionnaireView:OnShow(data)
	self.controller:SetData(data)

end

function UIQuestionnaireView:OnClose()
end

function UIQuestionnaireView:OnDispose()
	self.controller:OnDispose()
end

return UIQuestionnaireView

