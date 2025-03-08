local UIMinTipsView = require("UICommonTips/UIMinTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")

function UIMinTipsView:OnAwake(data)
	self.controller = require("UICommonTips/UIMinTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIMinTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_REFRESH_MINTIPS, self, self.RefreshTips)

end

function UIMinTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIMinTipsView:Init()
	self.itemGoList = {}
	self.itemLuaList = {}
	self.templateItem:SetActive(false)
	self:SetTips()
end

function UIMinTipsView:RefreshTips(data)
	self.controller:SetData(data)
	self:SetTips()
end

function UIMinTipsView:SetTips()
	local tipsType = self.controller:GetTipsType()
	if tipsType == 1 then
		local pos, strKey,strParams = self.controller:GetTipsData()
		self:SetUIPos(pos)
		self:SetContent(strKey,strParams)
		self.content:SetActive(true)
		self.iconsNode:SetActive(false)
	elseif tipsType == 2 then
		self.content:SetActive(false)
		self.iconsNode:SetActive(true)
		local pos, rewards = self.controller:GetRewardsData()
		self:SetUIPos(pos)
		self:SetRewards(rewards)
	end
end

function UIMinTipsView:SetUIPos(pos)
	local width  = self.node.rectTransform.sizeDelta.x 
	local aPos = pos
	local deltaY = UIMgr.SCREEN_HEIGHT * 0.5 - aPos.y 
	if deltaY < 90 then
		aPos.y = aPos.y - 45
		self.bg.rectTransform.pivot = Vector2(0.5,1)
	else
		aPos.y = aPos.y + 45
		self.bg.rectTransform.pivot = Vector2(0.5,0)
	end

	if aPos.x > 0 then
		local deltaX = UIMgr.SCREEN_WIDTH * 0.5 - aPos.x
		if deltaX < width * 0.5 then
			aPos.x = UIMgr.SCREEN_WIDTH * 0.5 - width * 0.5
		end
	elseif aPos.x < 0 then
		local deltaX = aPos.x + 0.5 * UIMgr.SCREEN_WIDTH
		if deltaX < 0.5 * width  then
			aPos.x = 0.5 * width - 0.5 * UIMgr.SCREEN_WIDTH
		end
	end

	self.node.rectTransform.anchoredPosition = aPos
	self.bg.rectTransform.anchoredPosition = Vector3(0,0,0)
end

function UIMinTipsView:SetContent(txtKey,params)
	if txtKey == nil then
		self.content.text.text = ""
	else
		if params~=nil and type(params) == 'table' then
			self.content.text.text = string.formatbykey(txtKey,unpack(params))
		else
			self.content.text.text = string.formatbykey(txtKey,params)
		end
		
	end	
end

function UIMinTipsView:SetRewards(rewards)
	for i = 1, #self.itemLuaList do
		self.itemLuaList[i]:SetActive(false)
	end

	if rewards == nil or #rewards == 0 then
		return
	end
	

	if #rewards >= 3 then
		self.iconsNode.gridLayoutGroup.constraintCount = 3
	else
		self.iconsNode.gridLayoutGroup.constraintCount = #rewards
	end

	local cnt = #rewards
	if cnt > 9 then
		cnt = 9
	end
	
	for i = 1, cnt do
		local itemLua = self:GetIconItemLua(i)
		local rewardData = {cfgId = rewards[i][1], num = rewards[i][2] }
		IconItemCtr:SetData(self, itemLua.iconItem, rewardData)
		if rewards[i][3] then
			itemLua.mask:SetActive(true)
		else
			itemLua.mask:SetActive(false)
		end
		itemLua:SetActive(true)
	end
end

function UIMinTipsView:GetIconItemLua(idx)
	if idx <= #self.itemLuaList then
		return self.itemLuaList[idx]
	end

	local itemGo = UnityEngine.GameObject.Instantiate(self.templateItem.gameObject)
	self.itemGoList[#self.itemGoList+1] = itemGo
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, "TipItem", itemGo)
	itemLua.prefabName = "TipItem"
	
	itemGo.name = "TipItem"
	itemLua.transform:SetParent(self.iconsNode.transform)
	itemLua.transform.localScale = Vector3(1,1,1)
	itemLua.rectTransform.anchoredPosition3D = Vector3(0,0,0)
	itemLua:SetActive(true)
	self.itemLuaList[#self.itemLuaList+1] = itemLua
	return itemLua
end

function UIMinTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIMinTipsView:AddUIEventListener()

end

function UIMinTipsView:OnHide()
end

function UIMinTipsView:OnShow(data)
	self.controller:SetData(data)
	self:SetTips()
end

function UIMinTipsView:OnClose()
	self:DestroyGoes()
	CommonUtil.ClearGridViewItem(self, "TipItem")
	self.itemLuaList = nil
end

function UIMinTipsView:OnDispose()
	self.controller:OnDispose()
end

function UIMinTipsView:DestroyGoes()
	if self.itemGoList ~= nil then
		for i = 1, #self.itemGoList do
			CommonUtil.DestroyGO(self.itemGoList[i])
		end
	end

	self.itemGoList = nil
end

return UIMinTipsView

