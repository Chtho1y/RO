local UIPetAdvenceView = require("UIPet/UIPetAdvenceView_Generate")
local PetMatsGridView = require("UIPet/PetMatsGridView")

local petMatsGridView
local zenyLack = false
function UIPetAdvenceView:OnAwake(data)
	self.controller = require("UIPet/UIPetAdvenceCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetAdvenceView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_ADVENCE_REFRESH_NTF, self, self.OnAdvenceCallBackNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
end

function UIPetAdvenceView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetAdvenceView:Init()
	if not petMatsGridView then
		petMatsGridView = PetMatsGridView:new()
		petMatsGridView:Init(Enum.ItemIEnterType.PetMats, self, self.mats.loopGridView)
	end

	self:RefreshConditionDsc()

	self:Refresh()
end

function UIPetAdvenceView:Refresh(resetPos)
	if petMatsGridView then
		petMatsGridView:Refresh(resetPos)
	end

	self:RefreshSelections()
	self:RefreshAttrs()
	self:RefreshCost()
end

function UIPetAdvenceView:RefreshSelections()
	local selections = self.controller:GetSelections()
	for i = 1, 3 do
		local selection = selections[i]
		local item = self["item"..i]
		item.owned:SetActive(selection ~= nil)
		item.unowned:SetActive(selection == nil)

		if selection then
			local petData = self.controller:GetSelectionPetData(selection)
			CommonUtil.UpdateItemPrefab(self, item.iconPetItem, petData, Enum.ItemIEnterType.Pet, self, self.OnRemoveMatClick)
		end
	end

	local petData = clone(self.controller:GetSelectionPetData(selections[1]))
	petData.advanceLevel = petData.advanceLevel + 1
	petData.selected = 0
	CommonUtil.UpdateItemPrefab(self, self.item4.iconPetItem, petData, Enum.ItemIEnterType.Pet)
end

function UIPetAdvenceView:OnRemoveMatClick(button, params)
	local petData = params[0]
	if petData.id == self.controller:GetData() then
		return
	end
	self:RemoveMat(petData)
	self:RefreshSelections()
end

function UIPetAdvenceView:RemoveMat(data, itemlua)
	self.controller:RemoveSelection(data.selected)
	if itemlua then
		itemlua.selected:SetActive(false)
	else
		local data1 = self.controller:GetPetDataById(data.id)
		if data1 then
			local itemlua = petMatsGridView:GetShowItemByIdx(data1.idx)
			if itemlua then
				itemlua.selected:SetActive(false)
			end
		end
	end
end

function UIPetAdvenceView:RefreshConditionDsc()
	local id = self.controller:GetData()
	local curPetData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	local curPetCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(curPetData.cfgId)

	local nextAdvenceLv = curPetData.advanceLevel + 1

	local condition = curPetCfgData["Condition"..nextAdvenceLv.."1"]
	if condition then
		local typeDsc, advenceDsc, natureDsc
		local typeNum, advenceNum, natureNum
		for k,v in pairs(condition) do
			local type = v[1]
			local num = v[2]
			if type == Enum.PetRelationConditionType.Type then
				typeDsc = type
				typeNum = num
			elseif type == Enum.PetRelationConditionType.Advence then
				advenceDsc = type
				advenceNum = num
			elseif type == Enum.PetRelationConditionType.Nature then
				natureDsc = type
				natureNum = num
			end
		end

		local content = ""
		if typeDsc then
			if typeNum == 1 then
				content = content .. "Normal"
			elseif typeNum == 2 then
				content = content.. "Mini"
			elseif typeNum == 3 then
				content = content .. "Mvp"
			end
		end

		if advenceDsc then
			content = content .. I18N.SetLanguageValue("Petadfetter_002", advenceNum)
		end

		if natureDsc then
			content = content .. I18N.SetLanguageValue("Petadfetter_003", I18N.T("RoleFilter"..natureNum))
		end

		if curPetData.advanceLevel >= 5 then
			self.dsc.uILocalizeScript:SetContent("Petadvance_007")
		else
			self.dsc.uILocalizeScript:SetContentAndValues("Petadvance_004", {content})
		end
	end
end

function UIPetAdvenceView:RefreshAttrs()
	local id = self.controller:GetData()
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)

	local nextAdvenceLv = petData.advanceLevel + 1

	local data = petProgressCfgData["Attribute"..(nextAdvenceLv)]
	if data == nil then
		LogError(logicData.configId.." 宠物进阶 "..nextAdvenceLv.."  进阶属性错误")
		return
	end

	local curMaxLv, nextMaxLv = self.controller:GetCurAdvenceMaxLv()
	--self.attrs.lVLimit.text.text.text = I18N.T("LVLimit")
	self.attrs.lVLimit.number1.text.text = curMaxLv
	self.attrs.lVLimit.number2.text.text = nextMaxLv
	self.attrs.lVLimit:SetActive(true)

	local idx = 0
	for i = 1, 5 do
		local v = data[i]
		idx = idx + 1

		local attr = self.attrs["attr"..idx]
		attr:SetActive(v ~= nil)

		if attr and v then
			local key = v[1]
			local val = self.controller:GetCurPetAttr(key)
			if val then
				val = SDataUtil.InvConvert(val)
				attr.text.text.text = I18N.T("Attr_" .. v[1])
				val = key > 21 and CommonUtil.GetPreciseDecimal(val, 3) or math.floor(val)
				local val1 = key > 21 and CommonUtil.GetPreciseDecimal(v[2]*0.0001, 3) or math.floor(v[2])
				attr.number1.text.text = CommonUtil.HeroAttrFormatValue(key, val, true)
				attr.number2.text.text = CommonUtil.HeroAttrFormatValue(key, val + val1, true)
			end
		end
	end
end

function UIPetAdvenceView:RefreshCost()
	if self.controller:IsAdvenceFree() then
		zenyLack = false
		CommonUtil.IsConditionOutColor(self.cost1.num.text, false, string.formatbykey('Free'))
		return
	end

	local id = self.controller:GetData()
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
	local petProgressCfgData = ManagerContainer.CfgMgr:GetPetProgressCfgDataById(petData.cfgId)
	local nextAdvenceLv = petData.advanceLevel + 1

	local zenyCost = petProgressCfgData.CostMoney[nextAdvenceLv]
	local zenyOwned = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.Coin)
	zenyLack = zenyCost > zenyOwned
	CommonUtil.IsConditionOutColor(self.cost1.num.text, zenyCost > zenyOwned, CommonUtil.FormatNumber(zenyCost))
end

function UIPetAdvenceView:OnItemClick(button, params)
	local data = params[0]
	local itemlua = params[1]
	if data.isBattle then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petcompound_007")
		return
	end

	if data.id == self.controller:GetData() then
		return
	end

	if self.controller:IsInSelections(data.id) then
		self:RemoveMat(data, itemlua)
	else
		self.clickPetId = data.id
		self.curSelectedData = data
		self.curSelectedItemlua = itemlua
		if data.isRelevant then
			local data = {"PetCostNotify8", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
		if data.level > 1 or self.controller:WasSkillUp(data) then
			local data = {"PetCostNotify4", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
		if data.quality > 2 then
			local data = {"PetCostNotify9", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
		self:PetClickSure()
	end

	self:RefreshSelections()
end

function UIPetAdvenceView:PetClickSure()
	if self.clickPetId then
		local lastSelectedId = self.controller:AddSelection(self.clickPetId)
		if self.curSelectedItemlua then
			self.curSelectedItemlua.selected:SetActive(true)
		end
		self.clickPetId = nil
		self.curSelectedData = nil
		self.curSelectedItemlua = nil

		local data1 = self.controller:GetPetDataById(lastSelectedId)
		if data1 then
			local itemlua = petMatsGridView:GetShowItemByIdx(data1.idx)
			if itemlua then
				itemlua.selected:SetActive(false)
			end
		end

		self:RefreshSelections()
	end
end

function UIPetAdvenceView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIPetAdvenceView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.btnSure.button, self, self.OnSureClick)
end

function UIPetAdvenceView:OnCloseClick()
	self:UIClose()
end

function UIPetAdvenceView:OnSureClick()
	if zenyLack then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petadvance_001")
		return
	end
	local selections = self.controller:GetSelections()
	if #selections < 3 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petadvance_005")
		return
	end
	self.controller:SendPetAdvence()
end

function UIPetAdvenceView:OnAdvenceCallBackNtf()
	self:OnCloseClick()
end

function UIPetAdvenceView:OnVipLvChanged()
	self:RefreshCost()
end

function UIPetAdvenceView:OnHide()
	if petMatsGridView then
		petMatsGridView:OnHide()
	end
end

function UIPetAdvenceView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetAdvenceView:OnClose()
end

function UIPetAdvenceView:OnDispose()
	self.curSelectedData = nil
	self.curSelectedItemlua = nil

	if petMatsGridView then
		petMatsGridView:OnDispose()
		petMatsGridView = nil
	end

	self.controller:OnDispose()
end

return UIPetAdvenceView

