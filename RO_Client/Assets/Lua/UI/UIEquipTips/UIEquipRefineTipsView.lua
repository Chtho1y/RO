local UIEquipRefineTipsView = require("UIEquipTips/UIEquipRefineTipsView_Generate")
local CostItemCtr = require("Common/CostItemCtr")

local defineLvStr = " <color=#1f9300>+%s</color>"
function UIEquipRefineTipsView:OnAwake(data)
	self.controller = require("UIEquipTips/UIEquipRefineTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIEquipRefineTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SLOT_REFINE_LV_UP_SUCCESS, function(result)
		if result == Enum.NetErrorCode.ERROR_OK then
			--ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.RefineSuccess)
			self:RefineResultDisplay(true)
			self:Init()
		elseif result == Enum.NetErrorCode.ERROR_RES_NOT_ENOUGH then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(result)
		else
			self:RefineResultDisplay(false)
			--ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.RefineFailure)
		end
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, function()
		--self:Init()
		local slotIndex = self.controller:GetSlotIndex()
		local slotType = self.controller:GetSlotType()
		local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
		local refineLv = slots[slotType].level
		local nextRefineLv = refineLv + 1
		local nextRefineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(nextRefineLv)
		if nextRefineData ~= nil then
			self:RefreshCurRefineCost(slotType, nextRefineData)
		end
	end)

end

function UIEquipRefineTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIEquipRefineTipsView:RefineResultDisplay(result)
	if result then
		self.fx_ui_refine_failure.uIParticle:PlayCachedParticalSystem(false)
		self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(true)
	else
		self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(false)
		self.fx_ui_refine_failure.uIParticle:PlayCachedParticalSystem(true)
	end
end

function UIEquipRefineTipsView:Init()
	CommonUtil.BatchDisposeItems(self)

	local cfgId = self.controller:GetCfgId()
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

	local slotIndex = self.controller:GetSlotIndex()
	local slotType = self.controller:GetSlotType()
	local slots = ManagerContainer.DataMgr.UserData:GetCurSlotInfos(slotIndex)
	local refineLv = slots[slotType].level
	-- 道具图标

	ManagerContainer.GoPoolMgr:SpawnItemGo(itemCfgData.ResType, function(itemlua)
		CommonUtil.BatchCreateItems(self, itemlua, self.contentItem.transform, self.controller.data, Enum.ItemIEnterType.HeroEquip)
	end)
	-- 道具名称
	local name = I18N.T(itemCfgData.Name)
	self.textName.text.text = name
	self.refineLvBox:SetActive(refineLv > 0)
	if refineLv > 0 then
		self.textRefineLv.text.text = "+"..refineLv
	end
	-- 道具类型
	self.textType.uILocalizeScript:SetContent("ItemTypeDes_" .. itemCfgData.ResType)

	-- 装备基本属性
	local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
	local baseAttrs = {}
	for k,v in pairs(Enum.HeroAttrType) do
		if equipCfgData[k] and equipCfgData[k] ~= 0 then
			table.insert(baseAttrs, {Enum.HeroAttrType[k], equipCfgData[k], refineLv})
		end
	end

	local curRefineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(refineLv)
	if curRefineData == nil then
		self.boxCurrent.level.number.uILocalizeScript:SetContent("None")
	else
		self.boxCurrent.level.number.text.text = CommonUtil.StringConcat("+", refineLv)
	end
	for _,v in pairs(baseAttrs) do
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.EquipBaseAttrItem, function(itemlua)
			CommonUtil.BatchCreateItems(self, itemlua, self.boxCurrent.grid.transform, v, Enum.ItemIEnterType.EquipRefine, false)
		end)
	end

	local nextRefineLv = refineLv + 1
	local nextRefineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(nextRefineLv)
	--self.boxMAX:SetActive(nextRefineData == nil)
	--self.boxNext:SetActive(nextRefineData ~= nil)
	self.boxCost:SetActive(nextRefineData ~= nil)

	--self.chance:SetActive(nextRefineData ~= nil)

	self.dscMax:SetActive(nextRefineData == nil)

	local baseAttrs1 = clone(baseAttrs)
	for k,v in pairs(baseAttrs1) do
		v[3] = nextRefineData == nil and refineLv or nextRefineLv
		v[4] = nextRefineData == nil
	end
	for _,v in pairs(baseAttrs1) do
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.EquipBaseAttrItem, function(itemlua)
			CommonUtil.BatchCreateItems(self, itemlua, self.boxNext.grid.transform, v, Enum.ItemIEnterType.EquipRefine, true)
		end)
	end

	self.boxNext.level.number:SetActive(nextRefineData ~= nil)
	if nextRefineData ~= nil then
		self.boxNext.level.text.uILocalizeScript:SetContent("NextLv")
		self.boxNext.level.number.text.text = CommonUtil.StringConcat("+", nextRefineLv)

		self:RefreshCurRefineCost(slotType, nextRefineData)
		self.chanceVal.text.text = CommonUtil.StringConcat(nextRefineData.rate/100, "%")
	else
		self.boxNext.level.text.uILocalizeScript:SetContentWithColor("Limit", Constant.GreenColorText)
		--CommonUtil.SetTextColor(self.boxNext.level.text.text, Constant.GreenColorText)
	end

	self.btn_Refine:SetActive(nextRefineData ~= nil)
end

local coinLack, matLack = false,false
local mateId
function UIEquipRefineTipsView:RefreshCurRefineCost(slotType, nextRefineData)
	local is1 = CommonUtil.EleInTable(slotType, nextRefineData.Place1)
	local index = is1 and 1 or 2

	local data = {cfgId = Enum.ItemType.Coin, cost = nextRefineData["Costzeny"..index]}
	CostItemCtr:SetData(self, self.cost1, data, self, self.ShowItemTips)
	coinLack = CommonUtil.ResLackErrorNotice(Enum.ItemType.Coin, nextRefineData["Costzeny"..index], true)

	local data1 = {cfgId = nextRefineData["Costitem"..index][1][1], num = 0, cost = nextRefineData["Costitem"..index][1][2]}
	CostItemCtr:SetData(self, self.cost2, data1, self, self.ShowItemTips)
	mateId = nextRefineData["Costitem"..index][1][1]
	matLack = CommonUtil.ResLackErrorNotice(nextRefineData["Costitem"..index][1][1], nextRefineData["Costitem"..index][1][2], true)
end

function UIEquipRefineTipsView:ShowItemTips(button, params)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, params[0])
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIEquipRefineTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIEquipRefineTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, self.controller:GetData())
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btn_Refine.button, function ()
		if coinLack then
			CommonUtil.ItemNotEnoughHandle(Enum.ItemType.Coin)
			return
		end
		if matLack then
			CommonUtil.ItemNotEnoughHandle(mateId)
			return
		end
		self.controller:SendSlotRefineReq()
	end)
end

function UIEquipRefineTipsView:OnHide()

end

function UIEquipRefineTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIEquipRefineTipsView:OnClose()

end

function UIEquipRefineTipsView:OnDispose()

	self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(false)
	self.fx_ui_refine_failure.uIParticle:PlayCachedParticalSystem(false)


end

return UIEquipRefineTipsView

