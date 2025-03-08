local UIGuildWarBuffView = require("UIGuildWar/UIGuildWarBuffView_Generate")

function UIGuildWarBuffView:OnAwake(data)
	self.controller = require("UIGuildWar/UIGuildWarBuffCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildWarBuffView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_FIELD_ENDED, self, self.OnBattleFieldEnded)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_WAR_BATTLE_SELF_DATA_CHANGED, self, self.OnSelfDataChanged)
end

function UIGuildWarBuffView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildWarBuffView:Init()
	self.buyBuffItemPool = {self.guildWarBuyBuffItem}
	self:RefreshView()
end

function UIGuildWarBuffView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildWarBuffView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
end

function UIGuildWarBuffView:OnHide()

end

function UIGuildWarBuffView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildWarBuffView:OnClose()
end

function UIGuildWarBuffView:OnDispose()
	if self.buyBuffItemPool then
		for _,buyBuffItem in pairs(self.buyBuffItemPool) do
			if buyBuffItem and buyBuffItem ~= self.guildWarBuyBuffItem then
				CommonUtil.DestroyGO(buyBuffItem.gameObject)
			end
		end
		self.buyBuffItemPool = nil
	end
	self.controller:OnDispose()
end

function UIGuildWarBuffView:OnBattleFieldEnded(battleIdx)
	local battleFieldData = self.controller:GetBattleFieldData()
	if battleFieldData and battleFieldData.id ~= battleIdx then return end
	self:UIClose()
	ManagerContainer.LuaUIMgr:CloseMessageBox('GuildWarBuyBuffTip')
end

function UIGuildWarBuffView:OnSelfDataChanged()
	self:RefreshView()
end

function UIGuildWarBuffView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildWarBuffView:SureBuy(buffCfg)
	if not buffCfg then return end
	local battleFieldData = self.controller:GetBattleFieldData()
	local lv = 0
	if battleFieldData and battleFieldData.buffDic then
		lv = battleFieldData.buffDic[buffCfg.Id] or 0
	end
	lv = lv + 1
	local price = buffCfg.Price
	if price and price[lv] then
		local costCfgId = price[lv][1]
		local costNum = price[lv][2]
		local ownNum = self.controller:GetOwnResCountByItemId(costCfgId)
		if ownNum < costNum then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
			self:UIClose()
			return
		end
		local errorCode = self.controller:SendGuildWarBuyBuffReq(buffCfg.Id)
		if errorCode ~= 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle13')
	end
end

function UIGuildWarBuffView:OnClickBuyBtn(_, params)
	local buffCfg = params[0]
	if not buffCfg then return end
	local battleFieldData = self.controller:GetBattleFieldData()
	local lv = 0
	if battleFieldData and battleFieldData.buffDic then
		lv = battleFieldData.buffDic[buffCfg.Id] or 0
	end
	lv = lv + 1
	local price = buffCfg.Price
	if price and price[lv] then
		local costCfgId = price[lv][1]
		local costNum = price[lv][2]
		local ownNum = self.controller:GetOwnResCountByItemId(costCfgId)
		if ownNum < costNum then
			CommonUtil.ItemNotEnoughHandle(costCfgId, Enum.UIPageName.UIGuildWar)
			self:UIClose()
			return
		end
		local itemName = tostring(costNum)
		local cfgData = ManagerContainer.CfgMgr:GetItemById(costCfgId)
		if cfgData then
			itemName = itemName .. string.formatbykey(cfgData.Name)
		end
		local data = {'GuildWarBuyBuffTip', {buffCfg.Desc, itemName}, buffCfg, self, self.SureBuy}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('GuildWarBattle13')
	end
end

function UIGuildWarBuffView:RefreshView()
	local buffCfgs = self.controller:GetBuffCfgs()
	local battleFieldData = self.controller:GetBattleFieldData()
	local len = #buffCfgs
	for i = 1, len do
		local buffCfg = buffCfgs[i]
		local itemLua = self:GetBuyBuffItem(i)
		itemLua:SetActive(true)
		itemLua.icon.image.enabled = false
		itemLua.icon.image.sprite = nil
		CommonUtil.LoadIcon(self, buffCfg.Icon, function(sprite)
			if sprite then
				itemLua.icon.image.sprite = sprite
				itemLua.icon.image.enabled = true
			end
		end)
		local lv = 0
		if battleFieldData and battleFieldData.buffDic then
			lv = battleFieldData.buffDic[buffCfg.Id] or 0
		end
		itemLua.num.text.text = tostring(lv)
		itemLua.dsc.text.text = string.formatbykey(buffCfg.Desc)
		local price = buffCfg.Price
		for j = 1, 10 do
			local lvLua = itemLua['lv' .. tostring(j)]
			if price and price[j] then
				lvLua:SetActive(true)
				lvLua.uIImageSwitchSprite:ChangeSprite((lv < j) and 0 or 1)
			else
				lvLua:SetActive(false)
			end
		end
		self.uiBase:AddButtonUniqueEventListener(itemLua.btnBuy.button, self, self.OnClickBuyBtn, buffCfg)
	end
	for i = len + 1, #self.buyBuffItemPool do
		local itemLua = self.buyBuffItemPool[i]
		itemLua:SetActive(false)
	end
end

function UIGuildWarBuffView:GetBuyBuffItem(offsetIdx)
	local itemLua = self.buyBuffItemPool[offsetIdx]
	if not itemLua then
		local newGo = UnityEngine.GameObject.Instantiate(self.guildWarBuyBuffItem.gameObject)
		itemLua = CommonUtil.BindGridViewItem2Lua(self, 'GuildWarBuyBuffItem', newGo)
		itemLua.transform:SetParent(self.dscBox.transform)
		itemLua.transform.localPosition = Vector3.zero
		itemLua.transform.localScale = Vector3.one
		itemLua.transform.localRotation = Quaternion.identity
		self.buyBuffItemPool[offsetIdx] = itemLua
	end
	return itemLua
end

return UIGuildWarBuffView

