local UIArtifactReforgeView = require("UIArtifactTips/UIArtifactReforgeView_Generate")
local IconItemCtr = require "Common.IconItemCtr"

local pageToggleData = {}

local transCost
function UIArtifactReforgeView:OnAwake(data)
	self.controller = require("UIArtifactTips/UIArtifactReforgeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIArtifactReforgeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_REFORGE_SUCCESS, self, self.ReforgeSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.RefreshCost)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_SHIFT_REFRESH, self, self.TransSuccess)
end

function UIArtifactReforgeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIArtifactReforgeView:Init()
	local costStr = GlobalConfig.Instance:GetConfigStrValue(342)
	transCost = CommonUtil.DeserializeGlobalStrToNumberTable(costStr)

	self.fX_UI_ShenQi_01.uIParticle:PlayCachedParticalSystem(false)
	self.reforgeBox:SetActive(false)
	self.transBox:SetActive(false)

	self.mask:SetActive(false)
	self.selectedName:SetActive(false)
	self.slotIconItem:SetActive(false)

	self.transItem1Name:SetActive(false)
	self.transItem1:SetActive(false)
	self.transItem2Name:SetActive(false)
	self.transItem2:SetActive(false)

	-- self.unselected:SetActive(true)
	self.unselected.text.text.text = I18N.T("ArtifactReforgeDsc01")
	self:InitGrid()
	self.toggleGroup.toggleGroup:SetAllTogglesOff()

	self:RefreshCost()
end

function UIArtifactReforgeView:ReforgeSuccess(newSkillEquip)
	self.controller:SetCurSelectedIdx()
	self:ShowSelectedSkillEquip()

	self.fX_UI_ShenQi_01.uIParticle:PlayCachedParticalSystem(true)
	self.mask:SetActive(true)

	if self.delayShowTimer then
		self.delayShowTimer:Stop()
		self.delayShowTimer = nil
	end
	if not self.delayShowTimer then
		self.delayShowTimer = Timer.New(function()
			self:ShowReward(newSkillEquip)
			self.mask:SetActive(false)

			self:OnToggleSwitch()
			self.scrollview.loopGridView:RefreshAllShownItem()
		end, 2.5)
	end
	if not self.delayShowTimer.running then
		self.delayShowTimer:Start()
	end
end

function UIArtifactReforgeView:ShowReward(newSkillEquip)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SKILL_EQUIP_ADD_LIST, {{newSkillEquip.cfgId, 1, newSkillEquip.starLv}})
end

function UIArtifactReforgeView:InitGrid()
	self.scrollview.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIArtifactReforgeView:OnToggleSwitch(idx)
	self.controller:RefrshShowDatas(pageToggleData.toggleDefaultIndex)
	self.reforgeBox:SetActive(pageToggleData.toggleDefaultIndex == 1)
	self.transBox:SetActive(pageToggleData.toggleDefaultIndex == 2)
	self:RefreshCurrency()

	self.btnArtifactReforge.number.text.text = 0
	self.fX_UI_ShenQi_01.uIParticle:PlayCachedParticalSystem(false)
	if pageToggleData.toggleDefaultIndex == 1 then
		self.unselected.text.text.text = I18N.T("ArtifactReforgeDsc01")
		self.btnArtifactReforge.text.uILocalizeScript:SetContent("BtnReforge")
		self.mask:SetActive(false)
		self.selectedName:SetActive(false)
		self.slotIconItem:SetActive(false)
		local cfgData = ManagerContainer.CfgMgr:GetItemById(Enum.ItemIds.Diamond)
		if cfgData.Icon and cfgData.Icon ~= '' then
			self.btnArtifactReforge.icon.image.enabled = false
			CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				self.btnArtifactReforge.icon.image.sprite = sprite
				self.btnArtifactReforge.icon.image.enabled = true
			end, 'ItemIcon1')
		end
	elseif pageToggleData.toggleDefaultIndex == 2 then
		self.TransUnselected.TransTips.text.text = I18N.T("ArtifactTransDsc01")
		self.btnArtifactReforge.text.uILocalizeScript:SetContent("BtnArtifactTransfer")
		self.transItem1Name:SetActive(false)
		self.transItem1:SetActive(false)
		self.transItem2Name:SetActive(false)
		self.transItem2:SetActive(false)

		local cfgData = ManagerContainer.CfgMgr:GetItemById(Enum.ItemIds.SkillEquipTransItem)
		if cfgData.Icon and cfgData.Icon ~= '' then
			self.btnArtifactReforge.icon.image.enabled = false
			CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				self.btnArtifactReforge.icon.image.sprite = sprite
				self.btnArtifactReforge.icon.image.enabled = true
			end, 'ItemIcon1')
		end
	end

	local loopGridView = self.scrollview.loopGridView
	local length = self.controller:GetShowDataLength()
	loopGridView:SetListItemCount(length, false)
	loopGridView:RefreshAllShownItem()
end

function UIArtifactReforgeView:RefreshCurrency()
	local cfgData, num
	if pageToggleData.toggleDefaultIndex == 1 then
		cfgData = ManagerContainer.CfgMgr:GetItemById(Enum.ItemIds.Diamond)
		num = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Diamond)
	elseif pageToggleData.toggleDefaultIndex == 2 then
		cfgData = ManagerContainer.CfgMgr:GetItemById(Enum.ItemIds.SkillEquipTransItem)
		num = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.SkillEquipTransItem)
	end

	self.currencyIcon.image.enabled = false
	CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
		self.currencyIcon.image.sprite = sprite
		self.currencyIcon.image.enabled = true
	end, 'CurrencyIcon')
	self.currencyNum.text.text = CommonUtil.FormatNumber(num)
end

function UIArtifactReforgeView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local showData = self.controller:GetShowData(itemIndex)
    local item = nil
    if showData then
        item = gridView:NewListViewItem("IconItem")
        item.gameObject.name = itemIndex
        local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
        CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.Bag, self, self.OnItemClick, itemIndex)
		itemlua.selected:SetActive(showData.reforgeSelected)
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end

function UIArtifactReforgeView:OnItemClick(button, params)
	local idx = params[2]
	if pageToggleData.toggleDefaultIndex == 1 then
		local oldIdx = self.controller:SetCurSelectedIdx(idx + 1)
		self:RefreshSelectedSkillEquipShow(oldIdx)
	elseif pageToggleData.toggleDefaultIndex == 2 then
		local result, oldIdx,newIdx = self.controller:SetTransSelected(idx + 1)
		if result > 0 then
			if result == 1 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactTransUnFull02")
			elseif result == 2 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactTransUnFull03")
			elseif result == 3 then
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactTransUnFull04")
			end
			return
		end
		self:RefreshTransSelectedSkillEquipShow(oldIdx)
	end
end

function UIArtifactReforgeView:RefreshSelectedSkillEquipShow(oldIdx)
	if oldIdx then
		local oldItemLua = self:GetSkillEquipItemByIdx(oldIdx)
		if oldItemLua then
			oldItemLua.selected:SetActive(false)
		end
	end
	local curIdx = self.controller:GetCurSelecteIdx()
	if curIdx then
		local curItemLua = self:GetSkillEquipItemByIdx(curIdx)
		curItemLua.selected:SetActive(true)
	end	

	self:ShowSelectedSkillEquip()
end

function UIArtifactReforgeView:ShowSelectedSkillEquip()
	local curIdx = self.controller:GetCurSelecteIdx()
	self.selectedName:SetActive(curIdx ~= nil)
	self.slotIconItem:SetActive(curIdx ~= nil)
	-- self.unselected:SetActive(curIdx == nil)
	self.unselected.text.text.text = curIdx == nil and I18N.T("ArtifactReforgeDsc01") or I18N.T("ArtifactReforgeDsc02")
	if curIdx then
		local skillEquipData = self.controller:GetShowData(curIdx - 1)
		if skillEquipData then
			IconItemCtr:SetData(self, self.slotIconItem, skillEquipData, Enum.ItemIEnterType.Bag)
			local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
			self.selectedName.text.text = I18N.T(cfgData.Name)
		end
	end
	self:RefreshCost()
end

function UIArtifactReforgeView:RefreshTransSelectedSkillEquipShow(oldIdx)
	if oldIdx then
		local oldItemLua = self:GetSkillEquipItemByIdx(oldIdx)
		if oldItemLua then
			oldItemLua.selected:SetActive(false)
		end
	end
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransSelectedIdx()
	if leftSelectedIdx then
		local curItemLua = self:GetSkillEquipItemByIdx(leftSelectedIdx)
		if curItemLua then
			curItemLua.selected:SetActive(true)
		end
	end	
	if rightSelectedIdx then
		local curItemLua = self:GetSkillEquipItemByIdx(rightSelectedIdx)
		if curItemLua then
			curItemLua.selected:SetActive(true)
		end
	end	
	self:ShowTransSelectedSkillEquip()
end

function UIArtifactReforgeView:ShowTransSelectedSkillEquip()
	LogHRWarning("ShowTransSelectedSkillEquip")
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransSelectedIdx()
	self.transItem1Name:SetActive(leftSelectedIdx ~= nil)
	self.transItem1:SetActive(leftSelectedIdx ~= nil)
	self.transItem2Name:SetActive(rightSelectedIdx ~= nil)
	self.transItem2:SetActive(rightSelectedIdx ~= nil)

	if leftSelectedIdx then
		local skillEquipData = self.controller:GetShowData(leftSelectedIdx - 1)
		if skillEquipData then
			IconItemCtr:SetData(self, self.transItem1, skillEquipData, Enum.ItemIEnterType.Bag)
			local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
			self.transItem1Name.text.text = I18N.T(cfgData.Name)
		end
	end
	if rightSelectedIdx then
		local skillEquipData = self.controller:GetShowData(rightSelectedIdx - 1)
		if skillEquipData then
			IconItemCtr:SetData(self, self.transItem2, skillEquipData, Enum.ItemIEnterType.Bag)
			local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
			self.transItem2Name.text.text = I18N.T(cfgData.Name)
		end
	end
	self:RefreshTransCost()
end

function UIArtifactReforgeView:GetSkillEquipItemByIdx(idx)
	local item = self.scrollview.loopGridView:GetShownItemByItemIndex(idx - 1)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "IconItem", item.gameObject)
        return itemlua
    end
end

local lackRes
function UIArtifactReforgeView:RefreshCost()
	lackRes = {}
	local curIdx = self.controller:GetCurSelecteIdx()
	if not curIdx then
		self.btnArtifactReforge.number.text.text = 0
		return
	end
	local skillEuipData = self.controller:GetShowData(curIdx - 1)
	if skillEuipData then
		local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEuipData.cfgId)
		local cost = cfgData.ReforgeCost
		if cost then
			for i = 1, 1 do
				local cst = cost[i]
				if cst then
					local cfgData = ManagerContainer.CfgMgr:GetItemById(cst[1])
					if cfgData then
						-- self.btnArtifactReforge.icon.image.enabled = false
						local ownNum = CommonUtil.GetOwnResCountByItemId(cst[1])
						-- if cfgData.Icon and cfgData.Icon ~= '' then
						-- 	CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
						-- 		self.btnArtifactReforge.icon.image.sprite = sprite
						-- 		self.btnArtifactReforge.icon.image.enabled = true
						-- 	end, 'ItemIcon'..i)
						-- end
						if ownNum < cst[2] then
							lackRes = {cst[1], true}
							self.btnArtifactReforge.number.text.text = string.format(Constant.PinkColorText, cst[2])
						else
							lackRes = {cst[1], false}
							self.btnArtifactReforge.number.text.text = cst[2]
						end
					else
						self.btnArtifactReforge.number.text.text = 0
					end
				end
			end
		end
	end
end

function UIArtifactReforgeView:RefreshTransCost()
	lackRes = {}
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransSelectedIdx()
	if not leftSelectedIdx then
		self.btnArtifactReforge.number.text.text = 0
		return
	end
	local leftData = self.controller:GetShowData(leftSelectedIdx - 1)
	local maxStarLv = leftData.maxStarLv
	for i = 1, #transCost do
		if maxStarLv == tonumber(transCost[i][1]) then
			local key = tonumber(transCost[i][2])
			local num = tonumber(transCost[i][3])
			local cfgData = ManagerContainer.CfgMgr:GetItemById(key)
			if cfgData then
				-- self.btnArtifactReforge.icon.image.enabled = false
				local ownNum = CommonUtil.GetOwnResCountByItemId(key)
				-- if cfgData.Icon and cfgData.Icon ~= '' then
				-- 	CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				-- 		self.btnArtifactReforge.icon.image.sprite = sprite
				-- 		self.btnArtifactReforge.icon.image.enabled = true
				-- 	end, 'ItemIcon'..i)
				-- end
				if ownNum < num then
					lackRes = {key, true}
					self.btnArtifactReforge.number.text.text = string.format(Constant.PinkColorText, num)
				else
					lackRes = {key, false}
					self.btnArtifactReforge.number.text.text = num
				end
			else
				self.btnArtifactReforge.number.text.text = 0
			end
		end
	end
end

function UIArtifactReforgeView:TransSuccess()
	local oldLeftData, oldRightData = self.controller:GetOldLeftAndRightData()
	if not oldLeftData or not oldRightData then return end
	IconItemCtr:SetData(self, self.iconItem1, oldLeftData, Enum.ItemIEnterType.Bag)
	IconItemCtr:SetData(self, self.iconItem2, oldRightData, Enum.ItemIEnterType.Bag)
	self.uITransSuccess:SetActive(true)
end

function UIArtifactReforgeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIArtifactReforgeView:AddUIEventListener()
	CommonUtil.CreateToggleMouduleOnlyBtns(self, pageToggleData, self.toggleGroup, 1, self.OnToggleSwitch)

	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnArtifactPool.button, self, self.OnPoolClick)
	self.uiBase:AddButtonEventListener(self.btnArtifactReforge.button, self, self.OnReforgeClick)
	self.uiBase:AddButtonEventListener(self.btnInfo.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.reforgeBox.bg.button, self, self.OnReforgeBoxClick)

	self.uiBase:AddButtonEventListener(self.transBox.bg1.button, self, self.OnClickLeft)
	self.uiBase:AddButtonEventListener(self.transBox.bg2.button, self, self.OnClickRight)
end

function UIArtifactReforgeView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "ArtifactReforgeExplain"})
end

function UIArtifactReforgeView:OnCloseClick()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIArtifactReforgeView:OnPoolClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIArtifactPool)
end

function UIArtifactReforgeView:OnReforgeClick()
	if pageToggleData.toggleDefaultIndex == 1 then
		local curIdx = self.controller:GetCurSelecteIdx()
		if not curIdx then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactReforgeChoose")
			return
		end
		if lackRes[2] then
			CommonUtil.ItemNotEnoughHandle(lackRes[1], Enum.UIPageName.UIArtifactReforge)
			return
		end

		local data = {"SkillEquipReforgeTips", nil, nil, self, self.OnSure}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	elseif pageToggleData.toggleDefaultIndex == 2 then
		local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransSelectedIdx()
		if not leftSelectedIdx or not rightSelectedIdx then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactTransChoose")
			return
		end
		if lackRes[2] then
			CommonUtil.ItemNotEnoughHandle(lackRes[1], Enum.UIPageName.UIArtifactReforge)
			return
		end

		local data = {"SkillEquipTransTips", nil, nil, self, self.OnSure}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	end
	
end

function UIArtifactReforgeView:OnSure()
	if pageToggleData.toggleDefaultIndex == 1 then
		self.controller:SendReforgeReq()
	elseif pageToggleData.toggleDefaultIndex == 2 then
		self.controller:SendTransReq()
	end
end

function UIArtifactReforgeView:OnReforgeBoxClick()
	local curIdx = self.controller:GetCurSelecteIdx()
	if not curIdx then return end
	self.controller:SetCurSelectedIdx()
	self:RefreshSelectedSkillEquipShow(curIdx)
	self:ShowSelectedSkillEquip()
end

function UIArtifactReforgeView:OnClickLeft()
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransSelectedIdx()
	if not leftSelectedIdx then return end
	self.controller:ClearLeftTransSelectedIdx()
	self:RefreshTransSelectedSkillEquipShow(leftSelectedIdx)
end

function UIArtifactReforgeView:OnClickRight()
	local leftSelectedIdx, rightSelectedIdx = self.controller:GetTransSelectedIdx()
	if not rightSelectedIdx then return end
	self.controller:ClearRightTransSelectedIdx()
	self:RefreshTransSelectedSkillEquipShow(rightSelectedIdx)
end

function UIArtifactReforgeView:OnSubClose(path)
	self.super.OnSubClose(self, path)
    local target = CommonUtil.ParseUITargetPath(self, path)
    if target == nil then
        return
    end
	if target == self.uITransSuccess then
		self:OnToggleSwitch()
		self.scrollview.loopGridView:RefreshAllShownItem()
	end
end

function UIArtifactReforgeView:OnHide()

end

function UIArtifactReforgeView:OnShow(data)
	self.controller:SetData(data)

end

function UIArtifactReforgeView:OnClose()
	self.scrollview.loopGridView:Dispose()
	if self.delayShowTimer then
		self.delayShowTimer:Stop()
		self.delayShowTimer = nil
	end
end

function UIArtifactReforgeView:OnDispose()
	self.controller:OnDispose()
end

return UIArtifactReforgeView

