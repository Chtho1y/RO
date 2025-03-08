local UIForgePopView = require("UIForgePop/UIForgePopView_Generate")

function UIForgePopView:OnAwake(data)
	self.controller = require("UIForgePop/UIForgePopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIForgePopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EQUIP_FORGE_SUCCESS, function(type)
		self:UIClose()
	end)
end

function UIForgePopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIForgePopView:Init()
	local data = self.controller:GetData()
	local list = data[1]
	local totalCost = data[2]

	CommonUtil.LoopGridViewEleCreate(self,
			self.scrollView.loopVerticalScrollRect,
			self.content.gridLayoutGroup,
			list,
			0,
			function(itemlua, idx)
				CommonUtil.UpdateItemPrefab(self, itemlua, list[idx + 1], Enum.ItemIEnterType.EquipForgePop)
			end)

	self.text.text.text = totalCost
end

function UIForgePopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIForgePopView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnCompose.button, function()
		local data = self.controller:GetData()
		self.controller:SendEquipOneKeyForge(data[3], data[4])
	end)
end

function UIForgePopView:OnHide()

end

function UIForgePopView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIForgePopView:OnClose()
end

function UIForgePopView:OnDispose()

end

return UIForgePopView

