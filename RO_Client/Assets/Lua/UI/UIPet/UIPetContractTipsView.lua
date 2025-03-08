local UIPetContractTipsView = require("UIPet/UIPetContractTipsView_Generate")
local PetMatsGridView = require("UIPet/PetMatsGridView")

local sameNatureTypeAdd = 0

local petMatsGridView
function UIPetContractTipsView:OnAwake(data)
	self.controller = require("UIPet/UIPetContractTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetContractTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPetContractTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetContractTipsView:Init()
	sameNatureTypeAdd = GlobalConfig.Instance:GetConfigIntValue(351)* 0.01

	if not petMatsGridView then
		petMatsGridView = PetMatsGridView:new()
		petMatsGridView:Init(Enum.ItemIEnterType.PetQiyueMat, self, self.scrollView.loopGridView)
	end

	self:RefreshPetNatureIcon()
	self:RefreshAddAttrPreview()
end

function UIPetContractTipsView:RefreshPetNatureIcon()
	local curQiyuePetId = self.controller:GetQiyuePetId()
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(curQiyuePetId)
	if not petData then 
		CommonUtil.LoadIcon(self, Constant.Natural_Unknow_Icon, function (sprite)
			self.petExtra.nature.image.sprite = sprite
		end)
		return 
	end

	local qiyuePetCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	if not qiyuePetCfgData then 
		return 
	end

	local natureId = qiyuePetCfgData.NatureType
	local natureCfgData = ManagerContainer.CfgMgr:GetNatureDataById(natureId)
	local icon = natureCfgData.Icon

	CommonUtil.LoadIcon(self, icon, function (sprite)
		self.petExtra.nature.image.sprite = sprite
	end)
end

function UIPetContractTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	if petMatsGridView then
		petMatsGridView:Refresh(true)
	end
end

function UIPetContractTipsView:OnItemClick(button, params)
	local data = params[0]
	local itemlua = params[1]

	local lastData = self.controller:SetSelectedData(data)
	if itemlua then
		itemlua.selected:SetActive(true)
	end

	if lastData then
		local _,idx = self.controller:GetPetDataIdxInShowDatas(lastData.id)
		local lastItemlua = petMatsGridView:GetShowItemByIdx(idx)
		if lastItemlua then
			lastItemlua.selected:SetActive(false)
		end
	end

	self:RefreshAddAttrPreview()
end

function UIPetContractTipsView:RefreshAddAttrPreview()
	local data = self.controller:GetSelectedData()
	local cfgData = ManagerContainer.CfgMgr:GetPetDataById(data and data.cfgId or 0)
	if not cfgData then
		self.contractEffect.number.text.text = "0%"
		self.skillExtra.number.text.text = "0%"
		self.petExtra.number.text.text = "0%"
		return
	end

	local curQiyuePetId = self.controller:GetQiyuePetId()
	local petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(curQiyuePetId)
	local qiyuePetCfgData
	if petData then
		qiyuePetCfgData = ManagerContainer.CfgMgr:GetPetDataById(petData.cfgId)
	end

	local isSameNature = false
	if qiyuePetCfgData then
		isSameNature = cfgData.NatureType == qiyuePetCfgData.NatureType
	end
	local count1 = (cfgData.contract * 0.01).."%"
	local count2 = ((data and data.totalSkillUpCount or 0) * cfgData.understand * 0.01).."%"

	self.contractEffect.number.text.text = isSameNature and string.format(Constant.GreenColorText, count1) or count1
	self.petExtra.number.text.text = isSameNature and string.format(Constant.GreenColorText, sameNatureTypeAdd.."%") or "0%"
	self.skillExtra.number.text.text = isSameNature and string.format(Constant.GreenColorText, count2) or count2
end

function UIPetContractTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetContractTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.btnOK.button, self, self.OnOkClick)
	self.uiBase:AddButtonEventListener(self.btnCancel.button, self, self.OnCloseClick)
end

function UIPetContractTipsView:OnCloseClick()
	self:UIClose()
end

function UIPetContractTipsView:OnOkClick()
	self.controller:SendSlotChangeReq()
	self:UIClose()
end

function UIPetContractTipsView:OnHide()

end

function UIPetContractTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetContractTipsView:OnClose()
	if petMatsGridView then
		petMatsGridView:OnDispose()
		petMatsGridView = nil
	end
end

function UIPetContractTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIPetContractTipsView

