local UIFashionView = require("UIFashion/UIFashionView_Generate")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")
local MirrorPreviewSystem = require("MirrorPreviewSystem")

local DOTween = DG.Tweening.DOTween

local roleViewSystem = nil
local previewSystem = nil
local mirrorPreviewSystem = nil

local SaveInterval = 1
local LastSaveTime = nil
local SwitchInterval = 0.5
local LastSwitchTime = nil

local userSex
local lvUpState
local washState
--- 提示换装窗口结束后，下一步操作
local NoticeNextType =
{
	EnterRoleView = 1,
	EnterBookView = 2,
}

function UIFashionView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_JOB_CHANGE_SUCCESS, self, self.RefreshShowModel)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LIST_CHANGE, self, self.RefreshFashionDataAndShow)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_WEAR_CHANGE, self, self.RefreshFashionWearChange)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LV_UP_CHANGE, self, self.RefreshFashionDataAndShow)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_WASH_CHANGE, self, self.RefreshDetailView)
end

function UIFashionView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionView:Init()
	lvUpState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(68)
	washState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(69)

	userSex = ManagerContainer.DataMgr.UserData:GetSex()
	self:InitFashionChangeView()
	self:OnToggleChangeSwitch(nil, nil, true)
	self:InitShowModel()
end

function UIFashionView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIFashionView:AddUIEventListener()
	self.model.uIEventTriggerListener.onDrag = function()
		local deltaX = self.model.uIEventTriggerListener.currentEventData.delta.x
		if roleViewSystem then
			local go = roleViewSystem:GetGameObject()
			if go then
				go.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
			end
		end
	end

	self.uiBase:AddToggleEventListener(self.switch.toggle, self, self.OnToggleChangeSwitch, nil)

	-- 换时装
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togAll.toggle, self, self.OnToggleChangeFashionToggle, nil)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togHeadTop.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.HeadTop)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togHeadMiddle.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.HeadMiddle)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togHeadMiddle.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.HeadMiddle)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togHeadBottom.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.HeadBottom)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togClothes.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.Cloth)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togWeapon.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.Weapon)
	self.uiBase:AddToggleEventListener(self.toggleScrollView.togBack.toggle, self, self.OnToggleChangeFashionToggle, Enum.FashionSlotType.BodyBack)
	self.uiBase:AddButtonEventListener(self.btnGoto.button, self, self.OnClickFashionGotoBtn)
	self.uiBase:AddButtonEventListener(self.btnAllAttr.button, self, self.OnClickFashionAllAttrBtn)
	self.uiBase:AddButtonEventListener(self.btnSave.button, self, self.OnClickFashionSaveBtn)

	self.uiBase:AddButtonEventListener(self.uIBook.btnUpgrade.button, self, self.OnClickUpgradeBtn)
	self.uiBase:AddButtonEventListener(self.uIBook.btnWash.button, self, self.OnClickWashBtn)
	self.uiBase:AddButtonEventListener(self.btnSuites.button, self, self.OnClickSuitesBtn)
end

function UIFashionView:OnHide()
	if self.pageSequence then
		self.pageSequence:Kill()
		self.pageSequence = nil
	end
	if previewSystem then
		previewSystem:Dispose()
	end
	previewSystem = nil
	if mirrorPreviewSystem then
		mirrorPreviewSystem:Dispose()
	end
	mirrorPreviewSystem = nil
	if roleViewSystem then
		roleViewSystem:Dispose()
	end
	roleViewSystem = nil
end

function UIFashionView:OnShow(data)
	self.controller:SetData(data)
	self.uIBook:SetActive(false)
	self:OnToggleChangeSwitch(nil, nil, true)
	self:InitShowModel()
end

function UIFashionView:OnClose()
end

function UIFashionView:OnDispose()
	self.controller:OnDispose()
	self.model.uIEventTriggerListener.onDrag = nil
	self.scrollView.loopGridView:Dispose()
	self:DisposeJobOnly()
	if self.pageSequence then
		self.pageSequence:Kill()
		self.pageSequence = nil
	end
	if previewSystem then
		previewSystem:Dispose()
	end
	previewSystem = nil
	if mirrorPreviewSystem then
		mirrorPreviewSystem:Dispose()
	end
	mirrorPreviewSystem = nil
	if roleViewSystem then
		roleViewSystem:Dispose()
	end
	roleViewSystem = nil
end

function UIFashionView:InitShowModel()
	if not roleViewSystem then
		roleViewSystem = RoleViewSystem:new()
	end
	if not previewSystem then
		previewSystem = PreviewSystem:new("Preview")
		previewSystem:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
	end
	if not mirrorPreviewSystem then
		mirrorPreviewSystem = MirrorPreviewSystem:new("MirrorPreview", nil, nil, nil, previewSystem:GetCamera())
	end
	self.model:SetActive(true)
	self.model.rawImage.texture = previewSystem:GetRenderTexture()
	self.mirrorModel:SetActive(true)
	self.mirrorModel.rawImage.texture = mirrorPreviewSystem:GetRenderTexture()
	self:RefreshShowModel()
end

function UIFashionView:RefreshShowModel()
	roleViewSystem:RefreshView(Enum.RoleInEnvType.FashionView, self.controller:GetRoleCfgId(), self.controller:GetViewData(), nil, self, self.RefreshShowComplete)
end

function UIFashionView:RefreshShowComplete(go, isNewGo)
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	if curViewPageType ~= ViewPageType.Change then return end
	if previewSystem then
		previewSystem:UpdateGo(go)
	end
	if mirrorPreviewSystem then
		mirrorPreviewSystem:UpdateGo(go)
	end
end

function UIFashionView:InitFashionChangeView()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIFashionView:GetItemByRowColumn(gridView, itemIndex, row, column)
	-- local length = self.controller:GetShowDataLength()
	-- if (itemIndex < 0 or itemIndex >= length) then
	-- 	return nil
	-- end
	local fashionCfgData = self.controller:GetShowData(itemIndex)
	local item
	if fashionCfgData then
		item = gridView:NewListViewItem('FashionWearItem')
		local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'FashionWearItem', item.gameObject)
		CommonUtil.CloseUIClearAsyncSeqIds(itemlua)
		itemlua.icon.image.sprite = nil
		itemlua.icon.image.enabled = false
		itemlua.frame.image.sprite = nil
		itemlua.frame.image.enabled = false
		local cfgId = fashionCfgData.FashionId
		CommonUtil.LoadIcon(self, fashionCfgData.FashionIcon, function (sprite)
			itemlua.icon.image.sprite = sprite
			itemlua.icon.image.enabled = true
		end, itemlua, "FashionWearItemIconAsyncIdx")
		CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[fashionCfgData.FashionQuality], function (sprite)
			itemlua.frame.image.sprite = sprite
			itemlua.frame.image.enabled = true
		end, itemlua, "FashionWearItemFrameAsyncIdx")
		local ViewPageType = self.controller:GetViewPageType()
		local curViewPageType = self.controller:GetCurViewPageType()
		local seleced = false
		local seleced2 = false
		local disable = false
		if (curViewPageType == ViewPageType.Change) then
			seleced2 = false
			seleced = self.controller:IsWear(cfgId)
			if seleced then
				self.controller:SetCurSelectItemIndex(itemIndex)
			end
			disable = not self.controller:CanWear(fashionCfgData)
			CommonUtil.SetTotalChildrenGray(itemlua.group, false)
			itemlua.group.canvasGroup.alpha = 1
            itemlua.redPoint:SetActive(ManagerContainer.DataMgr.FashionData:IsNew(cfgId))
		else
			seleced = false
			local curItemIndex = self.controller:GetCurSelectItemIndex()
			seleced2 = (curItemIndex == itemIndex)
			CommonUtil.SetTotalChildrenGray(itemlua.group, not self.controller:IsOwner(cfgId))
			itemlua.group.canvasGroup.alpha = self.controller:IsOwner(cfgId) and 1 or 0.6
            itemlua.redPoint:SetActive(ManagerContainer.DataMgr.FashionData:CanLvUp(cfgId))
            if seleced2 then
                self.uIBook.btnUpgrade.uIRedPointRP:SetActive(lvUpState and ManagerContainer.DataMgr.FashionData:CanLvUp(cfgId))
            end
        end
		itemlua.icon:SetActive(true)
		itemlua.bg:SetActive(true)
		itemlua.frame:SetActive(true)
		itemlua.selected:SetActive(seleced)
		itemlua.selected2:SetActive(seleced2)
		itemlua.disable:SetActive(disable)
		itemlua.bg.button.onClick:RemoveAllListeners()
		itemlua.bg.button.onClick:AddListener(function()
			self:OnClickItem(fashionCfgData, itemIndex)
		end)

		local fashionLogicData = self.controller:GetFashionLogicData(fashionCfgData.FashionId)
		itemlua.num.text.text = "Lv "..(fashionLogicData and fashionLogicData.lv or 1)
	else
		item = gridView:NewListViewItem('IconEmptyItem')
	end
	return item
end

function UIFashionView:OnClickItem(fashionCfgData, itemIndex)
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
    local cfgId = fashionCfgData.FashionId
	if (curViewPageType == ViewPageType.Change) then
		local loopGridView = self:GetLoopGridView()
		local changed = ManagerContainer.DataMgr.FashionData:CancelNewState(cfgId)
		local errorCode, lastCfgId = self.controller:ChangeWear(fashionCfgData)
		if errorCode == 2 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('WeaponfashionTip_3')
			if changed then
				loopGridView:RefreshItemByItemIndex(itemIndex)
			end
			return
		elseif errorCode ~= 0 then
			if changed then
				loopGridView:RefreshItemByItemIndex(itemIndex)
			end
			return
		end
		self.controller:SetCurSelectItemIndex(itemIndex)
		local lastItemIndex = self.controller:GetItemIndexByCfgId(lastCfgId)
		if lastItemIndex then
			loopGridView:RefreshItemByItemIndex(lastItemIndex)
		end
		loopGridView:RefreshItemByItemIndex(itemIndex)
		self:RefreshShowModel()
		local curSelectFashionSlotType = self.controller:GetCurSelectFashionSlotType()
		if self.controller:RefreshRPInfo(curSelectFashionSlotType) then
			self:RefreshToggleView()
		end
	else
		local curItemIndex = self.controller:GetCurSelectItemIndex()
		if not self.controller:SetCurSelectItemIndex(itemIndex) then return end
		local loopGridView = self:GetLoopGridView()
		if curItemIndex then
			loopGridView:RefreshItemByItemIndex(curItemIndex)
		end
		loopGridView:RefreshItemByItemIndex(itemIndex)
		self:RefreshDetailView()
        self.uIBook.btnUpgrade.uIRedPointRP:SetActive(ManagerContainer.DataMgr.FashionData:CanLvUp(cfgId))
	end
end

function UIFashionView:RefreshFashionDataAndShow()
	self.controller:RefreshShowData()
	self:RefreshGridView(false)
	self:RefreshToggleView()
	self:RefreshDetailView()
end

function UIFashionView:RefreshFashionWearChange()
	if self.controller:IsSaveFashionSuccess() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(100006)
	end
end

function UIFashionView:RefreshView(resetPos)
	--self:RefreshPageView()
	self:RefreshGridView(resetPos)
	self:RefreshToggleView()
	self:RefreshDetailView()
end

function UIFashionView:RefreshPageView()
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	if curViewPageType == ViewPageType.Change then
		self.model:SetActive(true)
		self.mirrorModel:SetActive(true)
		if mirrorPreviewSystem and roleViewSystem then
			mirrorPreviewSystem:AddGo(roleViewSystem:GetGameObject())
		end
		if previewSystem and roleViewSystem then
			previewSystem:AddGo(roleViewSystem:GetGameObject())
		end
	else
		if mirrorPreviewSystem and roleViewSystem then
			mirrorPreviewSystem:RemoveGo(roleViewSystem:GetGameObject())
		end
		if previewSystem and roleViewSystem then
			previewSystem:RemoveGo(roleViewSystem:GetGameObject())
		end
		self.model:SetActive(false)
		self.mirrorModel:SetActive(false)
	end
	self.controller:SetCurSelectItemIndex(0)

	--if self.pageSequence then
	--	self.pageSequence:Kill()
	--	self.pageSequence = nil
	--end
	--local seq = nil
	--if self.uIBook.activeSelf then
	--	seq = DOTween.Sequence()
	--	seq:AppendCallback(function()
	--		self.uIFashionAnim.animator:Play('BookIn')
	--	end)
	--else
	--	seq = DOTween.Sequence()
	--	seq:AppendCallback(function()
	--		self.uIFashionAnim.animator:Play('FashionIn')
	--	end)
	--end
	--self.pageSequence = seq
	self:RefreshSwitchToggleView()
end

function UIFashionView:RefreshSwitchToggleView()
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	if curViewPageType == ViewPageType.Change then
		self.switch.animator:CrossFade('SwitchToFashion', 0.1)
		self.switch.toggle.isOn = true
        self.uIFashionAnim.animator:Play('FashionIn')
	else
		self.switch.animator:CrossFade('SwitchToBook', 0.1)
		self.switch.toggle.isOn = false
        self.uIFashionAnim.animator:Play('BookIn')
	end

	self.btnSave:SetActive(curViewPageType == ViewPageType.Change)
end

function UIFashionView:RefreshToggleView()
	local togglelua = self:GetToggleLua()
	if not togglelua then return end
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	local isNeedPoint = (curViewPageType == ViewPageType.Change)
	togglelua.togAll.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus())
	togglelua.togHeadTop.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.HeadTop))
	togglelua.togHeadMiddle.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.HeadMiddle))
	togglelua.togHeadBottom.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.HeadBottom))
	togglelua.togClothes.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.Cloth))
	togglelua.togWeapon.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.Weapon))
	togglelua.togBack.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.BodyBack))
	-- togglelua.togHair.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.HairStyle))
	-- togglelua.togEye.redPoint:SetActive(isNeedPoint and self.controller:GetRPStatus(Enum.FashionSlotType.Pupil))

	-- CommonUtil.SetTotalChildrenGray(togglelua.togWeapon, self.controller:IsBeginner())
	self:RefreshSelectToggleView()
end

function UIFashionView:RefreshSelectToggleView()
	local togglelua = self:GetToggleLua()
	if not togglelua then return end
	local curSelectFashionSlotType = self.controller:GetCurSelectFashionSlotType()
	if togglelua then
		local toggleGroup = togglelua.content.toggleGroup
		local oldAllowSwitchOff = toggleGroup.allowSwitchOff
		toggleGroup.allowSwitchOff = true
		togglelua.togAll.toggle.isOn = (curSelectFashionSlotType == nil)
		togglelua.togHeadTop.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.HeadTop)
		togglelua.togHeadMiddle.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.HeadMiddle)
		togglelua.togHeadBottom.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.HeadBottom)
		togglelua.togClothes.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.Cloth)
		togglelua.togWeapon.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.Weapon)
		togglelua.togBack.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.BodyBack)
		-- togglelua.togHair.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.HairStyle)
		-- togglelua.togEye.toggle.isOn = (curSelectFashionSlotType == Enum.FashionSlotType.Pupil)
		toggleGroup.allowSwitchOff = oldAllowSwitchOff
	end
end

function UIFashionView:RefreshGridView(resetPos)
	local loopGridView = self:GetLoopGridView()
	local length = self.controller:GetShowDataLength()
	if resetPos then
		loopGridView:RefreshListByIndex(length, 0)
	else
		loopGridView:RefreshListByIndex(length)
	end
end

function UIFashionView:RefreshDetailView()
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	if curViewPageType ~= ViewPageType.Book then
		return
	end
	local curSelectItemIndex = self.controller:GetCurSelectItemIndex()
	local fashionCfgData = self.controller:GetShowData(curSelectItemIndex)
	if not fashionCfgData then
		local curSelectItemIndex = 1
		fashionCfgData = self.controller:GetShowData(curSelectItemIndex)
		if not fashionCfgData then
			return
		end
		self:OnClickItem(fashionCfgData, curSelectItemIndex - 1)
		return
	end
	local maxLv = ManagerContainer.CfgMgr:GetFashionMaxLv()
	local isOwned = self.controller:IsOwner(fashionCfgData.FashionId)
	local curLv = 0

	local detail = self.uIBook.detail
	local suites = self.suites
	detail.icon.image.sprite = nil
	detail.itemName:SetActive(fashionCfgData ~= nil)
	detail.slotPosName:SetActive(fashionCfgData ~= nil)
	detail.describe:SetActive(fashionCfgData ~= nil)
	detail.icon:SetActive(fashionCfgData ~= nil)
	if fashionCfgData then
		local fashionLogicData = self.controller:GetFashionLogicData(fashionCfgData.FashionId)
		curLv = fashionLogicData and fashionLogicData.lv or 1
		detail.itemName.text.text = I18N.SetLanguageValue(fashionCfgData.FashionName)
		detail.lv.text.text = curLv .. "/"..maxLv
		detail.slotPosName.text.text = I18N.SetLanguageValue('FashionSlot_' .. tostring(fashionCfgData.FashionLocation))
		detail.describe.text.text = I18N.SetLanguageValue(fashionCfgData.FashionDepict)
		CommonUtil.LoadIcon(self, fashionCfgData.FashionIcon, function (sprite)
			detail.icon.image.sprite = sprite
		end, self, "DetailIconAsyncIdx")
		self:RefreshJobOnly(fashionCfgData.FashionUseJob)

		if fashionLogicData then
			local attrs = fashionLogicData.attrs
			table.sort(attrs, function (a,b)
				if a.jobType == b.jobType then
					return a.attrId < b.attrId
				else
					local posA = ManagerContainer.CfgMgr:GetPartnerPostIdByJobType(a.jobType)
					local posB = ManagerContainer.CfgMgr:GetPartnerPostIdByJobType(b.jobType)
					return posA < posB
				end
			end)
			for i = 1, 5 do
				local propertyItem = detail['propertyItem' .. i]
				if propertyItem then
					local fashionAttr = attrs[i]
					if fashionAttr then
						local jobType = fashionAttr.jobType
						local attrId = fashionAttr.attrId
						local attrValue = fashionAttr.value
						local jobName = self.controller:GetJobTypeName(jobType)
						propertyItem.prName.text.text = jobName..I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))
						propertyItem.number.text.text = "+"..attrValue
						propertyItem:SetActive(true)
					else
						propertyItem:SetActive(false)
					end
				end
			end
		else
			for i = 1, 5 do
				local propertyItem = detail['propertyItem' .. i]
				if propertyItem then
					propertyItem:SetActive(i <= fashionCfgData.AttrNum)
					if i <= fashionCfgData.AttrNum then
						propertyItem.prName.text.text = I18N.T("RandomAttr1")
						propertyItem.number.text.text = I18N.T("RandomAttr2")
					end
				end
			end
		end

		CommonUtil.SetTotalChildrenGray(self.uIBook.btnUpgrade, not lvUpState or not isOwned)
		CommonUtil.SetTotalChildrenGray(self.uIBook.btnWash, not washState or not isOwned)

		self.uIBook.btnUpgrade.button.enabled = isOwned
		self.uIBook.btnWash.button.enabled = isOwned
		if isOwned then
			if lvUpState then
				self.uIBook.btnUpgrade:SetActive(curLv < maxLv)
				self.uIBook.labelMax:SetActive(curLv >= maxLv)
			else
				self.uIBook.labelMax:SetActive(false)
			end
		end

		for i = 1, 4 do
			local suitesLvItem = suites['suitesLvItem' .. i]
			if suitesLvItem then
				suitesLvItem:SetActive(false)
			end
		end
		local suitIds = fashionCfgData.SuitId
		local idx = 0
		for i = 1, #suitIds do
			idx = idx + 1
			if idx > 4 then
				break
			end
			local suitesLvItem = suites['suitesLvItem' .. idx]
			local suitId = suitIds and suitIds[i] or nil
			if suitesLvItem then
				local suitCfgData = ManagerContainer.CfgMgr:GetFashionSuitDataById(suitId)

				local state = suitCfgData and (suitCfgData.SuitSex == 0 or suitCfgData.SuitSex == userSex)
 				suitesLvItem:SetActive(state)
				if state then
					suitesLvItem.suitesName.text.text = I18N.T(suitCfgData.SuitName)
					local lv = self.controller:GetFashionSuitLv(suitId)
					suitesLvItem.activity:SetActive(lv > 0)
					suitesLvItem.numlv.text.text = lv > 0 and lv or 1
				else
					idx = idx - 1
				end
			end
		end
	else
		for i = 1, 5 do
			local propertyItem = detail['propertyItem' .. i]
			if propertyItem then
				propertyItem:SetActive(false)
			end
		end

		for i = 1, 4 do
			local suitesLvItem = suites['suitesLvItem' .. i]
			if suitesLvItem then
				suitesLvItem:SetActive(false)
			end
		end
	end
end

function UIFashionView:RefreshJobOnly(jobIds)
	if not jobIds then
		self.uIBook.detail.noJob:SetActive(true)
		self.uIBook.detail.jobBox:SetActive(false)
		return
	end
	local len1 = #jobIds
	if len1 <= 0 then
		self.uIBook.detail.noJob:SetActive(true)
		self.uIBook.detail.jobBox:SetActive(false)
		return
	end
	local len2
	if not self.jobBoxIcons then
		self.jobBoxIcons = {}
		len2 = 0
	else
		len2 = #self.jobBoxIcons
	end
	self.uIBook.detail.noJob:SetActive(false)
	self.uIBook.detail.jobBox:SetActive(true)
	self.uIBook.detail.jobBox.icon:SetActive(false)
	local parent = self.uIBook.detail.jobBox.icon.transform.parent
	for i = 1, len1 do
		local jobBoxIcon
		if i <= len2 then
			jobBoxIcon = self.jobBoxIcons[i]
		else
			jobBoxIcon = {}
			local go = CommonUtil.Instantiate(self.uIBook.detail.jobBox.icon, parent)
			jobBoxIcon.go = go
			jobBoxIcon.image = go:GetComponent(Enum.TypeInfo.Image)
			self.jobBoxIcons[i] = jobBoxIcon
		end
		local jobCfgData = ManagerContainer.CfgMgr:GetJobDataById(jobIds[i])
		jobBoxIcon.go:SetActive(true)
		jobBoxIcon.image.enabled = false
		jobBoxIcon.image.sprite = nil
		CommonUtil.CloseUIClearAsyncSeqIds(jobBoxIcon)
		if jobCfgData then
			CommonUtil.LoadIcon(self, jobCfgData.JobIcon, function(sprite)
				jobBoxIcon.image.enabled = true
				jobBoxIcon.image.sprite = sprite
			end, jobBoxIcon, 'JobIcon')
		end
	end

	for i = len1 + 1, len2 do
		local jobBoxIcon = self.jobBoxIcons[i]
		jobBoxIcon.go:SetActive(false)
		jobBoxIcon.image.sprite = nil
	end
end

function UIFashionView:DisposeJobOnly()
	if self.jobBoxIcons then
		for _, jobBoxIcon in pairs(self.jobBoxIcons) do
			CommonUtil.CloseUIClearAsyncSeqIds(jobBoxIcon)
			CommonUtil.DestroyGO(jobBoxIcon.go)
			jobBoxIcon.go = nil
			jobBoxIcon.image = nil
		end
		self.jobBoxIcons = nil
	end
end

function UIFashionView:GetToggleLua()
	return self.toggleScrollView
end

function UIFashionView:GetLoopGridView()
	return self.scrollView.loopGridView
end

function UIFashionView:OnToggleChangeSwitch(toggle, params, value)
	-- 在一帧内不重复刷新
	if self:IsSomeFrameCount('lastSwitchChange') then
		return
	end
	local timeStamp = Time.GetTimestamp()
	if LastSwitchTime and (LastSwitchTime + SwitchInterval) >= timeStamp then
		self:RefreshSwitchToggleView()
		return
	end
	LastSwitchTime = timeStamp
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	if curViewPageType == ViewPageType.Change then
		if not value then
			if self.controller:IsChangeFashion() then
				local data = {"ChangeFashionSure", nil, NoticeNextType.EnterBookView, self, self.SureChangeFashion, self.CancelChangeFashion}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
				--self:RefreshSwitchToggleView()
				return
			end
		end
	end
	local newViewPageType = value and ViewPageType.Change or ViewPageType.Book
	if not self.controller:ChangeViewPage(newViewPageType) then
		return
	end
    self:RefreshPageView()
	self:RefreshView(true)
end

function UIFashionView:OnToggleChangeFashionToggle(toggle, params, value)
	if not value then return end
	-- 在一帧内不重复刷新
	if self:IsSomeFrameCount(toggle.name .. '_LastChange') then
		return
	end
	local fashionSlotType = params
	local curSelectFashionSlotType = self.controller:GetCurSelectFashionSlotType()
	if curSelectFashionSlotType == fashionSlotType then return end
	-- if fashionSlotType == Enum.FashionSlotType.Weapon then
	-- 	if self.controller:IsBeginner() then
	-- 		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FashionTabLockTips')
	-- 		self:RefreshSelectToggleView()
	-- 		return
	-- 	end
	-- end
	self.controller:RefreshShowDataType(fashionSlotType)
	self:RefreshView(true)
end


function UIFashionView:OnClickFashionGotoBtn()
	local ViewPageType = self.controller:GetViewPageType()
	local curViewPageType = self.controller:GetCurViewPageType()
	if curViewPageType == ViewPageType.Change then
		if self.controller:IsChangeFashion() then
			local data = {"ChangeFashionSure", nil, NoticeNextType.EnterRoleView, self, self.SureChangeFashion, self.CancelChangeFashion}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
	end
	self:SureChangeFashion(NoticeNextType.EnterRoleView)
end

function UIFashionView:OnClickFashionAllAttrBtn()
	local attrs, attrs1 = self.controller:GetAllFashionAttr()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionTotal, {title="TitleFashionSuitAttrAll", title1 = "TitleFashionAttrAll", attrs=attrs, attrs1 = attrs1})
end

function UIFashionView:SureChangeFashion(nextType)
	self.controller:SendFashionChange()
	if nextType == NoticeNextType.EnterRoleView then
		ManagerContainer.LuaUIMgr:OpenSourceUI(self, self.controller:GetHeroId())
		--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleMain1, self.controller:GetHeroId())
	elseif nextType == NoticeNextType.EnterBookView then
		self:SetCurFrameCount('lastSwitchChange')
		local ViewPageType = self.controller:GetViewPageType()
		if not self.controller:ChangeViewPage(ViewPageType.Book) then
			return
		end
		self:RefreshPageView()
		self:RefreshView(true)
	end
end

function UIFashionView:CancelChangeFashion(nextType)
	self.controller:CacheViewData()
	self:RefreshShowModel()
	if nextType == NoticeNextType.EnterRoleView then
		ManagerContainer.LuaUIMgr:OpenSourceUI(self, self.controller:GetHeroId())
		-- ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleMain1, self.controller:GetHeroId())
	elseif nextType == NoticeNextType.EnterBookView then
		self:SetCurFrameCount('lastSwitchChange')
		local ViewPageType = self.controller:GetViewPageType()
		if not self.controller:ChangeViewPage(ViewPageType.Book) then
			return
		end
		self:RefreshPageView()
		self:RefreshView(true)
	end
end

function UIFashionView:OnClickFashionSaveBtn()
	if LastSaveTime and (LastSaveTime + SaveInterval) >= Time.GetTimestamp() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(100007)
		return
	end
	LastSaveTime = Time.GetTimestamp()
	self.controller:SendFashionChange()
end

function UIFashionView:OnClickFashionShopBtn()
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FunctionLock')
end

function UIFashionView:SetCurFrameCount(keyName)
	self[keyName] = Time.frameCount
end

function UIFashionView:IsSomeFrameCount(keyName)
	local value = self[keyName]
	if value and value >= Time.frameCount then
		return true
	end
	self[keyName] = Time.frameCount
	return false
end

function UIFashionView:OnClickUpgradeBtn()
	local curSelectItemIndex = self.controller:GetCurSelectItemIndex()
	local fashionCfgData = self.controller:GetShowData(curSelectItemIndex)
	if fashionCfgData then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionLvUp, fashionCfgData.FashionId)
	end
end

function UIFashionView:OnClickWashBtn()
	local curSelectItemIndex = self.controller:GetCurSelectItemIndex()
	local fashionCfgData = self.controller:GetShowData(curSelectItemIndex)
	if fashionCfgData then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionWash, fashionCfgData.FashionId)
	end
end

function UIFashionView:OnClickSuitesBtn()
	local curSelectItemIndex = self.controller:GetCurSelectItemIndex()
	local fashionCfgData = self.controller:GetShowData(curSelectItemIndex)
	if fashionCfgData then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionSuitesTips, fashionCfgData.FashionId)
	end
end

return UIFashionView

