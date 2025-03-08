local UIFashionPaperTipsView = require("UIFashion/UIFashionPaperTipsView_Generate")

function UIFashionPaperTipsView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionPaperTipsCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionPaperTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.RefreshMoney)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.RefreshMoney)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.RefreshItem)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LIST_CHANGE, self, self.RefreshOwnSign)
end

function UIFashionPaperTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionPaperTipsView:Init()
	local cfgId = self.controller:GetCfgId()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	-- 道具图标
	ManagerContainer.GoPoolMgr:SpawnItemGo(itemCfgData.ResType, function(itemlua)
		CommonUtil.BatchCreateItems(self, itemlua, self.contentItem.transform, self.controller:GetData())
	end)
	-- 道具名称
	self.textName.text.text = itemCfgData.Name
	-- 道具类型
	self.textType.uILocalizeScript:SetContent("ItemTypeDes_" .. itemCfgData.ResType)
	-- 道具描述
	self.desTxt.text.text = itemCfgData.Describe

	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionPaperCfgData.FashionId)
	local fashionQuality = fashionCfgData.FashionQuality
	-- 一条属性的时候
	if type(fashionQuality[1]) == 'number' then
		fashionQuality = {fashionQuality}
	end
	for i = 1, #fashionQuality do
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.EquipBaseAttrItem, function(itemlua)
			CommonUtil.BatchCreateItems(self, itemlua, self.equipBox.attrs.grid.transform, fashionQuality[i], Enum.ItemIEnterType.ItemTips)
		end)
	end

	-- 显示材料
	self:RefreshMakeMaterials()
	self:RefreshOwnSign()
end

function UIFashionPaperTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionPaperTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, function()
		ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	end)
	self.uiBase:AddUIEventHandlerClickListener(self.uIEventHandler, function (go)
		if go and go.transform:IsChildOf(self.transform) then
			return
		end
		ManagerContainer.LuaUIMgr:Hide(self.uiData.id)
	end)
	self.uiBase:AddButtonEventListener(self.composeBtn.button, self, self.OnClickComposeBtn)
	self.uiBase:AddButtonEventListener(self.decomposeBtn.button, self, self.OnClickDecomposeBtn)
end

function UIFashionPaperTipsView:OnHide()
	self.hideFrameCount = Time.frameCount
end

function UIFashionPaperTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
	if self.hideFrameCount and self.hideFrameCount < Time.frameCount then
		self.window.animator:Rebind()
	end
end

function UIFashionPaperTipsView:OnClose()

end

function UIFashionPaperTipsView:OnDispose()

	for i = #self.materialItems, 1, -1 do
		local materialItem = self.materialItems[i]
		self.materialItems[i] = nil
		if materialItem ~= self.materialItem then
			if tolua.getpeer(materialItem.text) ~= nil then
				tolua.setpeer(materialItem.text, nil)
			end
			if tolua.getpeer(materialItem.number) ~= nil then
				tolua.setpeer(materialItem.number, nil)
			end
			if tolua.getpeer(materialItem) ~= nil then
				tolua.setpeer(materialItem, nil)
			end
		end
	end
	self.materialItems = nil
end

function UIFashionPaperTipsView:OnClickComposeBtn()
	self:UIClose()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionCompose, {cfgId = self.controller:GetCfgId()})
end

function UIFashionPaperTipsView:OnClickDecomposeBtn()
	local cfgId = self.controller:GetCfgId()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	local itemName1 = I18N.SetLanguageValue(itemCfgData.Name)
	local itemNum1 = self.controller:GetOwnedItemNum(cfgId)
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local resolveItem = fashionPaperCfgData.ResolveItem
	local content = ""
	for i = 1, #resolveItem do
		local cfgId = resolveItem[i][1]
		local num = resolveItem[i][2]
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		local quality = itemCfgData.Quality
		local name = I18N.SetLanguageValue(itemCfgData.Name)
		content = content ..string.format(Constant.ColorTextArray[quality],name.."X"..(itemNum1 * num))
		if i < #resolveItem then
			content = content .. string.format("<color=#000000>%s</color>", ",")
		end
	end

	local data = {"DecomposeFashionSure", {itemName1, itemNum1, content}, nil, self, self.SureDecomposeFashion}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIFashionPaperTipsView:SureDecomposeFashion()
	self.controller:SendDecomposeMsg()
	self:UIClose()
end

function UIFashionPaperTipsView:RefreshMoney()
	self:RefreshMakeMaterials()
end

function UIFashionPaperTipsView:RefreshItem()
	self:RefreshMakeMaterials()
end

function UIFashionPaperTipsView:RefreshMakeMaterials()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(self.controller:GetCfgId())
	local makeMaterial = fashionPaperCfgData.MakeMaterial
	if type(makeMaterial[1]) == 'number' then
		makeMaterial = {makeMaterial}
	end
	if not self.materialItems then self.materialItems = {self.materialItem} end
	local txtNum = #self.materialItems
	local num = #makeMaterial
	local material = nil
	local curOwnedNum = nil
	for i = 1, num do
		material = makeMaterial[i]
		local materialItemCfgData = ManagerContainer.CfgMgr:GetItemById(material[1])
		if materialItemCfgData.ResType == Enum.ItemType.Coin
				or materialItemCfgData.ResType == Enum.ItemType.Diamond then
		else
			local materialItem = self.materialItems[i]
			if not materialItem then
				materialItem = UnityEngine.GameObject.Instantiate(self.materialItem)
				if tolua.getpeer(materialItem) == nil then
					tolua.setpeer(materialItem, {})
				end
				local materialItemTrans = materialItem.transform
				materialItemTrans:SetParent(self.materialItem.transform.parent)
				materialItemTrans.localPosition = Vector3.zero
				materialItemTrans.localRotation = Quaternion.identity
				materialItemTrans.localScale = Vector3.one
				materialItem.text = materialItemTrans:Find("Text").gameObject
				if tolua.getpeer(materialItem.text) == nil then
					tolua.setpeer(materialItem.text, {})
				end
				materialItem.text.text = materialItem.text:GetComponent(Enum.TypeInfo.Text)
				materialItem.number = materialItemTrans:Find("Number").gameObject
				if tolua.getpeer(materialItem.number) == nil then
					tolua.setpeer(materialItem.number, {})
				end
				materialItem.number.text = materialItem.number:GetComponent(Enum.TypeInfo.Text)
				self.materialItems[i] = materialItem
			end
			materialItem:SetActive(true)
			materialItem.text.text.text = I18N.SetLanguageValue(materialItemCfgData.Name)
			curOwnedNum = ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(material[1])
			if curOwnedNum >= material[2] then
				materialItem.number.text.text = curOwnedNum .. '/' .. material[2]
			else
				materialItem.number.text.text = string.format(Constant.RedColorText, curOwnedNum .. '/' .. material[2])
			end
		end
	end

	for i = num + 1, txtNum do
		self.materialItems[i]:SetActive(false)
	end
end

function UIFashionPaperTipsView:RefreshOwnSign()
	local owned = self.controller:GetIsOwned()
	local enterType = self.controller:GetEnterType()
	if enterType == Enum.ItemIEnterType.Bag then
		self.btnBox:SetActive(true)
		self.composeBtn:SetActive(not owned)
		self.decomposeBtn:SetActive(owned)
	else
		self.btnBox:SetActive(false)
	end
	self.composedTxt:SetActive(owned)
end

return UIFashionPaperTipsView

