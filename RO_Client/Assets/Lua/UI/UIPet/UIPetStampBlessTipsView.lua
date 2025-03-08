local UIPetStampBlessTipsView = require("UIPet/UIPetStampBlessTipsView_Generate")

function UIPetStampBlessTipsView:OnAwake(data)
	self.controller = require("UIPet/UIPetStampBlessTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetStampBlessTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPetStampBlessTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetStampBlessTipsView:Init()
	self:RefreshTop()
	self:RefreshBottom()
end

function UIPetStampBlessTipsView:RefreshTop()
	local petData = self.controller:GetCurPetData()
	local stampSuit = petData.stampSuit
	self.petBlessLv.lightGreen:SetActive(stampSuit[1] == 1)
	self.petBlessLv.lightBlue:SetActive(stampSuit[1] == 2)
	self.petBlessLv.lightPurple:SetActive(stampSuit[1] == 3)
	self.petBlessLv.lightGold:SetActive(stampSuit[1] == 4)
	self.petBlessLv.lightRed:SetActive(stampSuit[1] == 5)
	for i = 1, 6 do
		local quality = stampSuit[4][i]
		local slot = self.petBlessLv["slot"..i]
		slot:SetActive(quality ~= nil)
		if quality then
			local image = slot.image
			local slotTb = tolua.getpeer(slot)
			CommonUtil.LoadIcon(self, Constant.Pet_Stamp_Bless_Icons[quality], function (sprite)
				image.sprite = sprite
			end, slotTb, 'BlessIcon')
		end
	end
end

function UIPetStampBlessTipsView:RefreshBottom()
	local petData = self.controller:GetCurPetData()
	local stampSuit = petData.stampSuit
	local curQuality = stampSuit[1]

	local curSuitCount = stampSuit[2]
	self.currentLv.unactivatedState:SetActive(curSuitCount < 6)
	self.currentLv.activedState:SetActive(curSuitCount == 6)
	local curLv = curQuality == 0 and 1 or curQuality
	self.currentLv.lv.text.text = I18N.SetLanguageValue("Stamp"..(curLv + 4), curSuitCount)
	local curIcon = curSuitCount < 6 and Constant.Pet_Stamp_Bless_Active_Icons[1] or Constant.Pet_Stamp_Bless_Active_Icons[curQuality + 1]
	local colorTb = tolua.getpeer(self.currentLv.color)
	CommonUtil.LoadIcon(self, curIcon, function (sprite)
		self.currentLv.color.image.sprite = sprite
	end, colorTb, 'BlessIcon1')

	local suitCfgData = ManagerContainer.CfgMgr:GetPetEquipSuitCfgDataByQuality(curLv)
	if suitCfgData then
		local state = curSuitCount == 6
		local color = state and Constant.GreenColorText or Constant.GrayColorText
		local parent = self.currentLv
		for i = 1, 5 do
			local attr = suitCfgData.Suit[i]
			local itemLua = parent["cardBlessAttrItem"..i]
			itemLua:SetActive(attr ~= nil)
			if attr then
				local attrId = attr[1]
				local attrNum = attr[2]*0.0001
				attrNum = attrId > 21 and CommonUtil.GetPreciseDecimal(attrNum, 3) or math.floor(attrNum)

				itemLua.text.text.text = I18N.T("Attr_" .. attrId)
				itemLua.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrNum, true)
				CommonUtil.SetTextColor(itemLua.text.text, color)
				CommonUtil.SetTextColor(itemLua.number.text, color)
			end
		end
	end

	local nextQuality = curQuality + 1
	self.nextLv:SetActive(curQuality > 0 and nextQuality <= 5)
	if curQuality > 0 and nextQuality <= 5 then
		local nextSuitCount = stampSuit[3]
		self.nextLv.unactivatedState:SetActive(nextSuitCount < 6)
		self.nextLv.activedState:SetActive(nextSuitCount == 6)
		local curLv = nextQuality <= 1 and 2 or nextQuality
		self.nextLv.lv.text.text = I18N.SetLanguageValue("Stamp"..(curLv + 4), nextSuitCount)
		local colorTb = tolua.getpeer(self.nextLv.color)
		CommonUtil.LoadIcon(self, Constant.Pet_Stamp_Bless_Active_Icons[1], function (sprite)
			self.nextLv.color.image.sprite = sprite
		end, colorTb, 'BlessIcon2')

		local suitCfgData = ManagerContainer.CfgMgr:GetPetEquipSuitCfgDataByQuality(curLv)
		if suitCfgData then
			local state = nextSuitCount == 6
			local color = state and Constant.GreenColorText or Constant.GrayColorText
			local parent = self.nextLv
			for i = 1, 5 do
				local attr = suitCfgData.Suit[i]
				local itemLua = parent["cardBlessAttrItem"..i]
				itemLua:SetActive(attr ~= nil)
				if attr then
					local attrId = attr[1]
					local attrNum = attr[2]*0.0001
					attrNum = attrId > 21 and CommonUtil.GetPreciseDecimal(attrNum, 3) or math.floor(attrNum)

					itemLua.text.text.text = I18N.T("Attr_" .. attrId)
					itemLua.number.text.text = CommonUtil.HeroAttrFormatValue(attrId, attrNum, true)
					CommonUtil.SetTextColor(itemLua.text.text, color)
					CommonUtil.SetTextColor(itemLua.number.text, color)
				end
			end
		end
	end
end

function UIPetStampBlessTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetStampBlessTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
end

function UIPetStampBlessTipsView:OnCloseClick()
	self:UIClose()
end

function UIPetStampBlessTipsView:OnHide()

end

function UIPetStampBlessTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetStampBlessTipsView:OnClose()
end

function UIPetStampBlessTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIPetStampBlessTipsView

