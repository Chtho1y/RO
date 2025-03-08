local UICardGotView = require("UICardTips/UICardGotView_Generate")
local CardIconBigItemCtr = require("Common/CardIconBigItemCtr")

function UICardGotView:OnAwake(data)
	self.controller = require("UICardTips/UICardGotCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICardGotView:AddEventListener()

end

function UICardGotView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICardGotView:Init()
	local logicData = self.controller:GetData()
	local bigCardItem = self.cardIconBigItem
	CardIconBigItemCtr:SetData(self, bigCardItem, logicData, nil, Enum.ItemIEnterType.CardRecreate)

	local cardCfgData = ManagerContainer.CfgMgr:GetCardDataById(logicData.cfgId)

	for _,v in pairs(CommonUtil.DeserializeCfgItemList(cardCfgData.Attribute1)) do
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.CardListAttrItem, function(itemlua)
			CommonUtil.BatchCreateItems(self, itemlua, self.attBox.transform, v, Enum.ItemIEnterType.CardRecreate)
		end)
	end
end

function UICardGotView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICardGotView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.alpha.button, function (buttton, params)
		self:UIClose()
	end)
end

function UICardGotView:OnHide()

end

function UICardGotView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICardGotView:OnClose()
end

function UICardGotView:OnDispose()

end

return UICardGotView

