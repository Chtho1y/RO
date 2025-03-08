local PetBook = class("PetBook")
local BitUtil = require("BitUtil")

local pageToggleData = {}
function PetBook:ctor()
end

function PetBook:InitGo(host,uiGo)
	self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BookItem", uiGo)
	self.controller = require("UICollect/PetBookCtr"):new()
	self.host.controller:SetPetBookCtr(self.controller)

	self:InitPanel()
end

function PetBook:InitPanel()
	self:InitGrid()
	self.viewLua.qtyCard:SetActive(false)
	self.viewLua.qtyPet:SetActive(true)
	self.viewLua.qtyCollection:SetActive(false)

	self.viewLua.btnMaterials:SetActive(false)
	self.viewLua.dscBox:SetActive(false)
end

function PetBook:Hide()
	self.viewLua.gameObject:SetActive(false)
end

function PetBook:Show()
	self.viewLua.gameObject:SetActive(true)
end

function PetBook:SelectToggle()
	CommonUtil.CreateToggleMouduleOnlyBtns(self.host, pageToggleData, self.viewLua.toggleGroup, Enum.CollectQualityType.ALL, self.host.OnValueChangedToggle)
end

function PetBook:InitGrid()
	self.viewLua.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function PetBook:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('PetCollect')
	local cfgData = self.controller:GetShowDataByIdx(itemIndex + 1)
	local state, curAdvLv, owned = ManagerContainer.DataMgr.PetDataMgr:GetPetCollectRewardState(cfgData.Id)

	local itemlua = CommonUtil.BindGridViewItem2Lua(self.host, "PetCollect", item.gameObject)
	CommonUtil.UpdateItemPrefab(self.host, itemlua, cfgData, nil, self, self.OnPetClick)

	if state and owned then
		self:RedPointRefresh(cfgData, curAdvLv, state, itemlua.uIRedPointRP)
	else
		itemlua.uIRedPointRP.gameObject:SetActive(false)
	end
	return item
end

function PetBook:RedPointRefresh(cfgData, advMaxLv, state, redPoint)
	if cfgData.PetReward then
		for i = 1,#cfgData.PetReward do
			local adv = cfgData.PetReward[i][1]
			if advMaxLv >= adv then
				local rewarded = BitUtil.RshiftNumBandOne(state, adv) == 1
				if not rewarded then
					redPoint.gameObject:SetActive(true)
					return
				end
			end
		end
	end
end
function PetBook:OnValueChangedToggle()
	local type = pageToggleData.toggleDefaultIndex
	self.controller:GetHandBookPetCfgDatasByType(type)

	local count = self.controller:GetCurCount(type)
	local length = self.controller:GetCurShowDatasLength()
	local maxCount = length
	self.viewLua.qtyPet.text.text.text = count.."/"..maxCount

	self.viewLua.qtyPet.iconAll:SetActive(type == Enum.CollectQualityType.ALL)
	self.viewLua.qtyPet.iconNormal:SetActive(type == Enum.CollectQualityType.NORMAL)
	self.viewLua.qtyPet.iconMini:SetActive(type == Enum.CollectQualityType.MINIBOSS)
	self.viewLua.qtyPet.iconMvp:SetActive(type == Enum.CollectQualityType.MVP)

	if length > 0 then
		--self.viewLua.scrollView.loopGridView:SetListItemCount(length, true)
		self.viewLua.scrollView.loopGridView:RefreshListByIndex(length)
	end
end

function PetBook:OnPetClick(button, params)
	local cfgId = params[0]

	local data = {type = Enum.CollectType.Pet, cfgId = cfgId}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UICollectTips, data)
end

function PetBook:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.host.uiData.name, UIEventNames.PET_HANDBOOK_REWARD_REFRESH, function()
		self:OnValueChangedToggle()
	end)
end

function PetBook:RemoveEventListener()

end

function PetBook:AddUIEventListener()
	self.host.uiBase:AddButtonEventListener(self.viewLua.btnBack.button, self, self.OnBtnBackClick)
end

function PetBook:OnBtnBackClick()
	if self.host and self.host.BookBack then
		self.host:BookBack()
	end
end

function PetBook:Dispose()

	self.viewLua.scrollView.loopGridView:Dispose()

	self.controller:OnDispose()
	self.controller = nil

    self.host = nil
	self.viewLua:GenerateDestroy()
    self.viewLua = nil
	pageToggleData = {}
end


return PetBook