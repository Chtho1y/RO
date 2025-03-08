local UIRefineExtraPopView = require("UIEquipTips/UIRefineExtraPopView_Generate")

function UIRefineExtraPopView:OnAwake(data)
	self.controller = require("UIEquipTips/UIRefineExtraPopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIRefineExtraPopView:AddEventListener()

end

function UIRefineExtraPopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIRefineExtraPopView:Init()
	local lv = self.controller:GetData()
	local list = {}
    local count = ManagerContainer.CfgMgr:GetEquipRefineCount()
	for i = 1, count do
		local refineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(i)
		local refineEff = refineData["Suit"]
		if refineEff~=nil and #refineEff > 0 then
			list[#list + 1] = {lv = i, attr = refineEff, curLv = lv}
		end
	end
	for _,v in pairs(list) do
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.EquipRefineLvItem, function(itemlua)
			CommonUtil.BatchCreateItems(self, itemlua, self.box.transform, v)
		end)
	end
end

function UIRefineExtraPopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRefineExtraPopView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.alpha.button, function ()
		self:UIHide()
	end)
end

function UIRefineExtraPopView:OnHide()

end

function UIRefineExtraPopView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIRefineExtraPopView:OnClose()

end

function UIRefineExtraPopView:OnDispose()

end

return UIRefineExtraPopView

