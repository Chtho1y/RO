local UIParterGotView = require("UIPOPGot/UIParterGotView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIParterGotView:OnAwake(data)
	self.controller = require("UIPOPGot/UIParterGotCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIParterGotView:AddEventListener()

end

function UIParterGotView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIParterGotView:Init()
	local datas = self.controller:GetData()
	local length = #datas
	for i = 1, 10 do
		local status = i <= length
		self["itemRoot"..i]:SetActive(status)
		if status then
			local data = datas[i]
			local item = self["item"..i].gameObject
			if i >= length then
				item.animation:Play()
				local animationState = item.animation.this:get("GotItemScaleIn")
				animationState.speed = 1
			elseif i >= length - 1 then
				item.animation:Play()
				local animationState = item.animation.this:get("GotItemScaleIn")
				animationState.speed = 2
			end
			local itemItem = self["iconItem"..i].gameObject
			local itemLua = CommonUtil.BindGridViewItem2Lua(self, itemItem.name, itemItem)
			local heroData = ManagerContainer.CfgMgr:GetPartnerDataById(data.cfgId)
			local data1 = {cfgId = data.cfgId, num = 1}
			IconItemCtr:SetData(self, itemLua, data1, Enum.ItemIEnterType.Partner)
			self["itemName"..i].text.text = I18N.T(heroData.Name)
		end
	end
end

function UIParterGotView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIParterGotView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.alpha.button, function()
		self:UIClose()
	end)
end

function UIParterGotView:OnHide()

end

function UIParterGotView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIParterGotView:OnClose()
	ManagerContainer.PopGotMgr:PageViewKeep(false)
end

function UIParterGotView:OnDispose()

end

return UIParterGotView

