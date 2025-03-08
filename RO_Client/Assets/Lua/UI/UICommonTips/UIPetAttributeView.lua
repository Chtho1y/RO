local UIPetAttributeView = require("UICommonTips/UIPetAttributeView_Generate")

local AttrFilterList
function UIPetAttributeView:OnAwake(data)
	self.controller = require("UICommonTips/UIPetAttributeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetAttributeView:AddEventListener()

end

function UIPetAttributeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetAttributeView:Init()

	if not AttrFilterList then
		local val = GlobalConfig.Instance:GetConfigStrValue(230)
		if val ~= "" and val ~= nil then
			AttrFilterList = CommonUtil.DeserializeGlobalStrToTable(val)
		end
	end

	self:Refresh()
end

function UIPetAttributeView:Refresh()
	local type = self.controller:GetType()
	local cfgId = self.controller:GetCfgId()
	local id = self.controller:GetId()
	local actorData, petData
	if not cfgId then
		actorData = self.controller:GetPetActorData()
		if not actorData then
			return
		end
		petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(id)
		cfgId = petData.cfgId
	end

	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
	if not petCfgData then
		return
	end

	local multiply = petCfgData.ConversionRate*0.0001

	local baseList1 = self.controller:GetBaseAttrList()
	local addList1 = self.controller:GetAddAttrList()

	local baseList = {}
	local addList = {}

	if not baseList1 and not addList1 then
		local relationAttrs = {}
		if petData.heroId == 0 then
			relationAttrs = self.controller:GetRelationAddAttrs()
		end

		local list = {}
		for k,v in pairs(Enum.HeroAttrType) do
			list[#list + 1] = v
		end
		table.sort(list, function (a,b)
			return a < b
		end)
		for _,v in pairs(list) do
			if not CommonUtil.EleInTable(tostring(v), AttrFilterList) then
				if v >= Enum.HeroAttrType.Life and v <= Enum.HeroAttrType.CastAcceleration then
					local num = SDataUtil.Add(actorData:GetFinalAttr(v), (relationAttrs[v] or 0))
					num = SDataUtil.InvConvert(SDataUtil.Multiply(num, multiply))
					num = math.floor(num)
					if SDataUtil.IsGreater(num, 0) then
						baseList[#baseList + 1] = {v, num, 0}
					end
				else
					if v >= Enum.HeroAttrType.Nature_None_Damage_Percent then
						local num = SDataUtil.Add(actorData:GetFinalAttr(v), (relationAttrs[v] and relationAttrs[v]*0.0001 or 0))
						num = SDataUtil.InvConvert(SDataUtil.Multiply(num, multiply))
						--num = math.floor(num)
						if SDataUtil.IsGreater(num, 0) then
							addList[#addList + 1] = {v, num, 0}
						end
					end
				end
			end
		end
	else
		for _,v in pairs(baseList1) do
			if not CommonUtil.EleInTable(tostring(v[1]), AttrFilterList) then
				local num = v[2]
				num = SDataUtil.InvConvert(SDataUtil.Multiply(num, multiply))
				num = math.floor(num)
				if SDataUtil.IsGreater(num, 0) then
					baseList[#baseList + 1] = {v[1], num, 0}
				end
			end
		end
		for _,v in pairs(addList1) do
			if not CommonUtil.EleInTable(tostring(v[1]), AttrFilterList) then
				local num = v[2]
				num = SDataUtil.InvConvert(SDataUtil.Multiply(num, multiply))
				--num = math.floor(num)
				if SDataUtil.IsGreater(num, 0) then
					addList[#addList + 1] = {v[1], num, 0}
				end
			end
		end
	end

	CommonUtil.LoopGridViewEleCreate(self, self.baseSView.loopVerticalScrollRect, self.baseSView.content.gridLayoutGroup, baseList, 0, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, baseList[idx + 1])
	end)

	CommonUtil.LoopGridViewEleCreate(self, self.addSView.loopVerticalScrollRect, self.addSView.content.gridLayoutGroup, addList, 0, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, addList[idx + 1])
	end)

	self.addSView:SetActive(#addList > 0)
	self.none:SetActive(#addList == 0)
end

function UIPetAttributeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetAttributeView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
end

function UIPetAttributeView:OnCloseClick()
	self:UIClose()
end

function UIPetAttributeView:OnHide()

end

function UIPetAttributeView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetAttributeView:OnClose()
end

function UIPetAttributeView:OnDispose()
	self.baseSView.loopVerticalScrollRect:ClearCells()
	self.addSView.loopVerticalScrollRect:ClearCells()

	self.controller:OnDispose()
end

return UIPetAttributeView

