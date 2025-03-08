local UIRoleNaturePointView = require("UIRoleMain/UIRoleNaturePointView_Generate")

local oneAttrAddDic = {}
local twoAttrAddDic = {}

local baseList = {}
local addList = {}

function UIRoleNaturePointView:OnAwake(data)
	self.controller = require("UIRoleMain/UIRoleNaturePointCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
	self:InitConfigData()
end

function UIRoleNaturePointView:InitConfigData()
	local cfgdata = GlobalConfig.Instance:GetConfigStrValue(312)
	self.cfgData  =  CommonUtil.DeserializeGlobalStrToNumberTable(cfgdata)
end


function UIRoleNaturePointView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HERO_ATTR_ADD_SUCCESS, function(isReset)
		if isReset then
			twoAttrAddDic = {}
		end
		--self:RefreshAttrChangeSuccess()
		self:RefreshCurNaturePop()
	end)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTOR_SERVER_CHANGE_ATTRS, function(tbArrtDeffrent)		
		--LogError(Inspect(tbArrtDeffrent))
		twoAttrAddDic = {}
		--self:RefreshAttrChangeSuccess()
		self:RefreshCurNaturePop()
	end)
end

function UIRoleNaturePointView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init(true)
end

function UIRoleNaturePointView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:RefreshCurNaturePop()
end

function UIRoleNaturePointView:Init(init)
	local logicData = self.controller:GetHeroLogicData()
	self.attr_plane.cUIPolygon:InitVertexsCount(6)

	self.strStart.transform.localPosition = self:RefreshAttrPlanePercentVec(logicData.attrs[Enum.HeroAttrType.STR], self.strEnd.transform.localPosition)
	self.agiStart.transform.localPosition = self:RefreshAttrPlanePercentVec(logicData.attrs[Enum.HeroAttrType.AGI], self.agiEnd.transform.localPosition)
	self.intStart.transform.localPosition = self:RefreshAttrPlanePercentVec(logicData.attrs[Enum.HeroAttrType.INT], self.intEnd.transform.localPosition)
	self.vitStart.transform.localPosition = self:RefreshAttrPlanePercentVec(logicData.attrs[Enum.HeroAttrType.VIT], self.vitEnd.transform.localPosition)
	self.dexStart.transform.localPosition = self:RefreshAttrPlanePercentVec(logicData.attrs[Enum.HeroAttrType.DEX], self.dexEnd.transform.localPosition)
	self.lukStart.transform.localPosition = self:RefreshAttrPlanePercentVec(logicData.attrs[Enum.HeroAttrType.LUK], self.lukEnd.transform.localPosition)
	self.attr_plane.cUIPolygon:RefreshPolygonVertexs()

	--self:RefreshCurNaturePop(init)

	self:RefreshRoleTop()
end

function UIRoleNaturePointView:RefreshRoleTop()
	local ownedCount = ManagerContainer.DataMgr.PartnerData:GetOwnedPartnerCount()
	self.btnLeft:SetActive(ownedCount > 0)
	self.btnRight:SetActive(ownedCount > 0)

	local id = self.controller:GetData()
	local cfgData = CommonUtil.GetHeroCfgDataByUid(id)

	CommonUtil.LoadIcon(self, cfgData.BattleCartoonImg, function (sprite)
		self.roleImg.role.image.sprite = sprite
	end)

	local heroData = self.controller:GetHeroLogicData()
	local jobName, roleName = CommonUtil.GetHeroSplitJobAndNameByUid(id, heroData.configId)
	self.roleImg.textBox.uILocalizeScript:SetContentAndValues("DscRoleTalk", {jobName, roleName})
end

function UIRoleNaturePointView:RefreshCurNaturePop(init)
	for i = Enum.HeroAttrType.STR, Enum.HeroAttrType.LUK do
		oneAttrAddDic[i] = 0
	end
	twoAttrAddDic = {}
	--self.controller:NilOldSlot()
	self.controller:ResetRemainPoints()

	self:RefreshPoints()
	self:RereshTopAttrs(init)
	-- 慧勇需求，在打开过属性界面，主界面的提示分配属性点的按钮就不显示
	--ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.MAIN_VIEW_SET_ATTR_BTN)
end

local function PointIncreased()
	for _,v in pairs(oneAttrAddDic) do
		if v > 0 then
			return true
		end
	end
	return false
end

function UIRoleNaturePointView:RefreshAttrPlanePercentVec(val, endPos)
	local percent = self.controller:GetAttrPlanePercent(SDataUtil.InvConvert(val))
	percent = math.min(100, percent + 10)
	local length = endPos - self.center.transform.localPosition
	return self.center.transform.localPosition + length * percent /100

	--self.attr_plane.meshVerticeMove:SetMeshPosition(GetAttrPlaneIndex(index), curPos)
end

local function GetBaseAttrsByType(baseAttrs, type)
	if baseAttrs == nil then return 0 end
	if baseAttrs[type] == nil then return 0 end
	return SDataUtil.InvConvert(baseAttrs[type] or 0)
end

function UIRoleNaturePointView:RefreshPoints()
	--local isLeader = self.controller:IsLeader()
	--local userData = self.controller:GetHeroLogicData()
	local baseAttrs = self.controller:GetLastBaseAttrs()

	--self.leadBox:SetActive(isLeader)
	--self.ptBox:SetActive(not isLeader)

	for k,v in pairs(oneAttrAddDic) do
		if k == Enum.HeroAttrType.STR then
			self.strStart.transform.localPosition = self:RefreshAttrPlanePercentVec(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)+ v, self.strEnd.transform.localPosition)
		elseif k == Enum.HeroAttrType.AGI then
			self.agiStart.transform.localPosition = self:RefreshAttrPlanePercentVec(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.AGI) + v, self.agiEnd.transform.localPosition)
		elseif k == Enum.HeroAttrType.INT then
			self.intStart.transform.localPosition = self:RefreshAttrPlanePercentVec(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.INT)+ v, self.intEnd.transform.localPosition)
		elseif k == Enum.HeroAttrType.VIT then
			self.vitStart.transform.localPosition = self:RefreshAttrPlanePercentVec(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.VIT)+ v, self.vitEnd.transform.localPosition)
		elseif k == Enum.HeroAttrType.DEX then
			self.dexStart.transform.localPosition = self:RefreshAttrPlanePercentVec(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.DEX)+ v, self.dexEnd.transform.localPosition)
		elseif k == Enum.HeroAttrType.LUK then
			self.lukStart.transform.localPosition = self:RefreshAttrPlanePercentVec(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.LUK)+ v, self.lukEnd.transform.localPosition)
		end
	end
	self.attr_plane.cUIPolygon:RefreshPolygonVertexs()
	--if isLeader then
		self.leadBox.str.number1.text.text = GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)
		self.leadBox.agi.number1.text.text = GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.AGI)
		self.leadBox.int.number1.text.text = GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.INT)
		self.leadBox.vit.number1.text.text = GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.VIT)
		self.leadBox.dex.number1.text.text = GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.DEX)
		self.leadBox.luk.number1.text.text = GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.LUK)

		local strCost = ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)+ oneAttrAddDic[Enum.HeroAttrType.STR]).cost
		local agiCost = ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.AGI)+ oneAttrAddDic[Enum.HeroAttrType.AGI]).cost
		local intCost = ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.INT)+ oneAttrAddDic[Enum.HeroAttrType.INT]).cost
		local vitCost = ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.VIT)+ oneAttrAddDic[Enum.HeroAttrType.VIT]).cost
		local dexCost = ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.DEX)+ oneAttrAddDic[Enum.HeroAttrType.DEX]).cost
		local lukCost = ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.LUK)+ oneAttrAddDic[Enum.HeroAttrType.LUK]).cost

		self.leadBox.str.number2.text.text = strCost
		self.leadBox.agi.number2.text.text = agiCost
		self.leadBox.int.number2.text.text = intCost
		self.leadBox.vit.number2.text.text = vitCost
		self.leadBox.dex.number2.text.text = dexCost
		self.leadBox.luk.number2.text.text = lukCost

		local totalPoints = self.controller:GetRemainPoint()
		self.leadBox.restPoint.number1.text.text = tostring(totalPoints)

		-- local strStatus = totalPoints >= strCost and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)+ 1) ~= nil
		local strStatus = SDataUtil.IsGreaterEqual(totalPoints,strCost) and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)+ 1) ~= nil
		self.leadBox.str.btnReduce:SetActive(oneAttrAddDic[Enum.HeroAttrType.STR] > 0 and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)+ 1) ~= nil )
		self.leadBox.str.btnIncrease:SetActive(strStatus)
		self.leadBox.str.numberGreen:SetActive(oneAttrAddDic[Enum.HeroAttrType.STR] > 0)

		-- local agiStatus = totalPoints >= agiCost and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(baseAttrs[Enum.HeroAttrType.AGI] + 1) ~= nil
		local agiStatus = SDataUtil.IsGreaterEqual(totalPoints,agiCost)  and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.AGI]) + 1) ~= nil
		self.leadBox.agi.btnReduce:SetActive(oneAttrAddDic[Enum.HeroAttrType.AGI] > 0 and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.AGI) + 1) ~= nil )
		self.leadBox.agi.btnIncrease:SetActive(agiStatus)
		self.leadBox.agi.numberGreen:SetActive(oneAttrAddDic[Enum.HeroAttrType.AGI] > 0)

		-- local intStatus = totalPoints >= intCost and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(baseAttrs[Enum.HeroAttrType.INT]+ 1) ~= nil
		local intStatus = SDataUtil.IsGreaterEqual(totalPoints,intCost) and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.INT])+ 1) ~= nil
		self.leadBox.int.btnReduce:SetActive(oneAttrAddDic[Enum.HeroAttrType.INT] > 0 and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.INT)+ 1) ~= nil )
		self.leadBox.int.btnIncrease:SetActive(intStatus)
		self.leadBox.int.numberGreen:SetActive(oneAttrAddDic[Enum.HeroAttrType.INT] > 0)

		-- local vitStatus = totalPoints >= vitCost and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(baseAttrs[Enum.HeroAttrType.VIT]+ 1) ~= nil
		local vitStatus = SDataUtil.IsGreaterEqual(totalPoints,vitCost) and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.VIT])+ 1) ~= nil
		self.leadBox.vit.btnReduce:SetActive(oneAttrAddDic[Enum.HeroAttrType.VIT] > 0 and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.VIT)+ 1) ~= nil )
		self.leadBox.vit.btnIncrease:SetActive(vitStatus)
		self.leadBox.vit.numberGreen:SetActive(oneAttrAddDic[Enum.HeroAttrType.VIT] > 0)

		-- local dexStatus = totalPoints >= dexCost and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(baseAttrs[Enum.HeroAttrType.DEX]+ 1) ~= nil
		local dexStatus = SDataUtil.IsGreaterEqual(totalPoints,dexCost) and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.DEX])+ 1) ~= nil
		self.leadBox.dex.btnReduce:SetActive(oneAttrAddDic[Enum.HeroAttrType.DEX] > 0 and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.DEX)+ 1) ~= nil )
		self.leadBox.dex.btnIncrease:SetActive(dexStatus)
		self.leadBox.dex.numberGreen:SetActive(oneAttrAddDic[Enum.HeroAttrType.DEX] > 0)

		-- local lukStatus = totalPoints >= lukCost and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(baseAttrs[Enum.HeroAttrType.LUK]+ 1) ~= nil
		local lukStatus = SDataUtil.IsGreaterEqual(totalPoints,lukCost) and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.LUK])+ 1) ~= nil
		self.leadBox.luk.btnReduce:SetActive(oneAttrAddDic[Enum.HeroAttrType.LUK] > 0 and ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.LUK)+ 1) ~= nil )
		self.leadBox.luk.btnIncrease:SetActive(lukStatus)
		self.leadBox.luk.numberGreen:SetActive(oneAttrAddDic[Enum.HeroAttrType.LUK] > 0)

		self.btnConfirm:SetActive(PointIncreased())
		-- self.btnRecommend:SetActive(totalPoints >= 0)
		self.btnRecommend:SetActive(strStatus or agiStatus or intStatus or vitStatus or dexStatus or lukStatus)
	--else
	--	self.ptBox.str.number1.text.text = tostring(userData.attrs[Enum.HeroAttrType.STR])
	--	self.ptBox.agi.number1.text.text = tostring(userData.attrs[Enum.HeroAttrType.AGI])
	--	self.ptBox.int.number1.text.text = tostring(userData.attrs[Enum.HeroAttrType.INT])
	--	self.ptBox.vit.number1.text.text = tostring(userData.attrs[Enum.HeroAttrType.VIT])
	--	self.ptBox.dex.number1.text.text = tostring(userData.attrs[Enum.HeroAttrType.DEX])
	--	self.ptBox.luk.number1.text.text = tostring(userData.attrs[Enum.HeroAttrType.LUK])
	--	self.btnConfirm:SetActive(false)
	--	self.btnRecommend:SetActive(false)
	--end

end

function UIRoleNaturePointView:RefreshTableAttrs(v, k, list)
	local isIn = false
	for _,v1 in pairs(list) do
		if v1[1] == k then
			isIn = true
			v1[2] = v
			v1[3] = twoAttrAddDic[k] or 0
		end
	end
	if not isIn then
		list[#list + 1] = {k, v, twoAttrAddDic[k] or 0}
	end
end

function UIRoleNaturePointView:RereshTopAttrs(init)
	-- ManagerContainer.DataMgr.UserData:RefreshAddPointAttr()
	local userData = self.controller:GetHeroLogicData()

	baseList = {}
	addList = {}
	for k,v in pairs(userData.attrs) do
		if (k >= Enum.HeroAttrType.Life and k <= Enum.HeroAttrType.CastAcceleration) then		
			baseList[#baseList + 1] = {k, v, twoAttrAddDic[k] or 0}
		else
			if #userData.attrs > 0 then
				if k >= Enum.HeroAttrType.RealHurt then
					if SDataUtil.InvConvertDouble(v) >  0 then
						addList[#addList + 1] = {k, v, twoAttrAddDic[k] or 0}
					end
				end
			end
		end
	end
	if self.baseSView.loopVerticalScrollRect.totalCount ~= #baseList then
		self.baseSView.loopVerticalScrollRect:ClearCells()
		CommonUtil.LoopGridViewEleCreateNew(self, self.baseSView.loopVerticalScrollRect, self.baseSView.content.gridLayoutGroup, baseList, 0, nil, function (itemLua, idx)
			CommonUtil.UpdateItemPrefab(self, itemLua, baseList[idx + 1])
		end)
	else
		self.baseSView.loopVerticalScrollRect:RefreshCellsData()
	end

	if self.addSView.loopVerticalScrollRect.totalCount ~= #addList then
		self.addSView.loopVerticalScrollRect:ClearCells()
		CommonUtil.LoopGridViewEleCreateNew(self, self.addSView.loopVerticalScrollRect, self.addSView.content.gridLayoutGroup, addList, 0, nil, function (itemLua, idx)
			CommonUtil.UpdateItemPrefab(self, itemLua, addList[idx + 1])
		end)
	else
		self.addSView.loopVerticalScrollRect:RefreshCellsData()
	end

	self.addSView:SetActive(#addList > 0)
	self.none:SetActive(#addList == 0)
end

function UIRoleNaturePointView:ChangeAttrPreview(attrType, increase)
	local baseAttrs = self.controller:GetLastBaseAttrs()

	local cost = 0
	if attrType == Enum.HeroAttrType.STR then
		cost = increase and -ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR)+ oneAttrAddDic[attrType]).cost or ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.STR])+ oneAttrAddDic[attrType] - 1).cost
	elseif attrType == Enum.HeroAttrType.AGI then
		cost = increase and -ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.AGI) + oneAttrAddDic[attrType]).cost or ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.AGI]) + oneAttrAddDic[attrType] - 1).cost
	elseif attrType == Enum.HeroAttrType.INT then
		cost = increase and -ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.INT)+ oneAttrAddDic[attrType]).cost or ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.INT])+ oneAttrAddDic[attrType] - 1).cost
	elseif attrType == Enum.HeroAttrType.VIT then
		cost = increase and -ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.VIT)+ oneAttrAddDic[attrType]).cost or ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.VIT])+ oneAttrAddDic[attrType] - 1).cost
	elseif attrType == Enum.HeroAttrType.DEX then
		cost = increase and -ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.DEX)+ oneAttrAddDic[attrType]).cost or ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.DEX])+ oneAttrAddDic[attrType] - 1).cost
	elseif attrType == Enum.HeroAttrType.LUK then
		cost = increase and -ManagerContainer.CfgMgr:GetHeroQualityPointByLv(GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.LUK)+ oneAttrAddDic[attrType]).cost or ManagerContainer.CfgMgr:GetHeroQualityPointByLv(SDataUtil.InvConvert(baseAttrs[Enum.HeroAttrType.LUK])+ oneAttrAddDic[attrType] - 1).cost
	end

	-- if self.controller:GetRemainPoint() + cost < 0 then
	-- 	return
	-- end

	if SDataUtil.IsLess(SDataUtil.Add(self.controller:GetRemainPoint(),cost),0 ) then
		return
	end

	local totalPoints = self.controller:ChangeRemainPoint(cost)

	self.leadBox.restPoint.number1.text.text = tostring(totalPoints)

	oneAttrAddDic[attrType] = oneAttrAddDic[attrType] + (increase and 1 or -1)

	self:RefreshAllAttr(attrType)
end

function UIRoleNaturePointView:RefreshAllAttr(attrType)
	local baseAttrs = self.controller:GetLastBaseAttrs()

	for i = Enum.HeroAttrType.STR, Enum.HeroAttrType.LUK do
		if oneAttrAddDic[i] == nil then
			oneAttrAddDic[i] = 0
		end
	end

	if attrType == Enum.HeroAttrType.STR then
		self.leadBox.str.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[attrType])
	elseif attrType == Enum.HeroAttrType.AGI then
		self.leadBox.agi.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[attrType])
	elseif attrType == Enum.HeroAttrType.INT then
		self.leadBox.int.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[attrType])
	elseif attrType == Enum.HeroAttrType.VIT then
		self.leadBox.vit.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[attrType])
	elseif attrType == Enum.HeroAttrType.DEX then
		self.leadBox.dex.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[attrType])
	elseif attrType == Enum.HeroAttrType.LUK then
		self.leadBox.luk.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[attrType])
	elseif attrType == nil then
		self.leadBox.str.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[Enum.HeroAttrType.STR])
		self.leadBox.agi.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[Enum.HeroAttrType.AGI])
		self.leadBox.int.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[Enum.HeroAttrType.INT])
		self.leadBox.vit.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[Enum.HeroAttrType.VIT])
		self.leadBox.dex.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[Enum.HeroAttrType.DEX])
		self.leadBox.luk.numberGreen.text.text = CommonUtil.StringConcat("+", oneAttrAddDic[Enum.HeroAttrType.LUK])
	end

	local dic = ManagerContainer.LuaActorDataMgr:GetRoleIncreaseSecondAttrVal(self.controller:GetData(),
			oneAttrAddDic[Enum.HeroAttrType.STR] + GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.STR),
			oneAttrAddDic[Enum.HeroAttrType.AGI] + GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.AGI),
			oneAttrAddDic[Enum.HeroAttrType.INT] + GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.INT),
			oneAttrAddDic[Enum.HeroAttrType.VIT] + GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.VIT),
			oneAttrAddDic[Enum.HeroAttrType.DEX] + GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.DEX),
			oneAttrAddDic[Enum.HeroAttrType.LUK] + GetBaseAttrsByType(baseAttrs, Enum.HeroAttrType.LUK)
	)
	local iter = dic:GetEnumerator()

	local userData = self.controller:GetHeroLogicData()
	while iter:MoveNext() do
		-- LogError("Add "..tostring(iter.Current.Value))					
		local newAttrs = userData.attrs
		-- LogError(Inspect(newAttrs))
		--服务器整数增量 = 取下整（当前本地增量 + 服务器当前 ）- 取下整（服务器当前）
		if newAttrs[iter.Current.Key] ~= nil then		
			local SfServerAdd = SDataUtil.Add(newAttrs[iter.Current.Key] ,  iter.Current.Value)
			local ServerAdd = SDataUtil.InvConvertDouble(SfServerAdd)
			local CurServer = SDataUtil.InvConvertDouble(newAttrs[iter.Current.Key]	)
			twoAttrAddDic[iter.Current.Key] = math.floor(ServerAdd) - math.floor(CurServer)	
		else
			twoAttrAddDic[iter.Current.Key] = math.floor(iter.Current.Value)
		end		
	end
	self:RefreshPoints()

	self:RereshTopAttrs()
end

function UIRoleNaturePointView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIRoleNaturePointView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.leadBox.str.btnReduce.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.STR, false)
	end)

	self.leadBox.str.btnIncrease.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.STR, true)
	end)

	self.leadBox.agi.btnReduce.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.AGI, false)
	end)

	self.leadBox.agi.btnIncrease.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.AGI, true)
	end)

	self.leadBox.int.btnReduce.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.INT, false)
	end)

	self.leadBox.int.btnIncrease.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.INT, true)
	end)

	self.leadBox.vit.btnReduce.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.VIT, false)
	end)

	self.leadBox.vit.btnIncrease.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.VIT, true)
	end)

	self.leadBox.dex.btnReduce.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.DEX, false)
	end)

	self.leadBox.dex.btnIncrease.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.DEX, true)
	end)

	self.leadBox.luk.btnReduce.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.LUK, false)
	end)

	self.leadBox.luk.btnIncrease.repeatButton:AddRepeatClickEventListener(function (idx, isOver)
		self:ChangeAttrPreview(Enum.HeroAttrType.LUK, true)
	end)

	self.uiBase:AddButtonEventListener(self.btnBack.button, function ()
		--ManagerContainer.LuaUIMgr:OpenSourceUI(self, self.controller:GetData())
		self:UIClose()
		if self.uiBase.MSourceUIID > 0 then
			ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID, self.controller:GetData())
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnConfirm.button, function ()
		self.controller:SendAttrChange(oneAttrAddDic)
	end)

	self.uiBase:AddButtonEventListener(self.btnPotentialFruit.button, function ()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFruitUse)
	end)
	self.uiBase:AddButtonEventListener(self.btnInfoImage.button, function ()
		local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(self.controller:GetData())
		local fruitPoint = 0 
		for i = 1, #self.cfgData do
			if herodata.qualityList and herodata.qualityList[self.cfgData[i][1]] ~= nil then
				fruitPoint = fruitPoint + herodata.qualityList[self.cfgData[i][1]] * self.cfgData[i][2]
			end
		end
		local basePoint = GlobalConfig.Instance:GetConfigIntValue(30)
		local pointCfg = ManagerContainer.CfgMgr.RoleAttributeCfg
		for i = 1, herodata.baseLevel - 1 do
			basePoint = basePoint + pointCfg[i]['GetPoint']
		end
		ManagerContainer.LuaUIMgr:ShowMinTips("PointShow",{basePoint,fruitPoint})
	end)
	

	self.uiBase:AddButtonEventListener(self.btnReset.button, function ()
		self.controller:SendResetPoint()
	end)

	self.uiBase:AddButtonEventListener(self.btnRecommend.button, function ()
		oneAttrAddDic = self.controller:CalcAutoPoints()
		local function AttrChanged()
			local result = false
			for k,v in pairs(oneAttrAddDic) do
				if v > 0 then
					result = true
				end
			end
			return result
		end
		self:RefreshAllAttr()

		if not AttrChanged() then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(Enum.ActionNotiveType.AutoAttrPointLack)
			return
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnLeft.button, self, self.OnLeftClick)
	self.uiBase:AddButtonEventListener(self.btnRight.button, self, self.OnRightClick)

	self.uiBase:AddButtonUniqueEventListener(self.btnInfo.button, self, self.OnClickInfoBtn)
end

function UIRoleNaturePointView:OnClickInfoBtn()
	-- 计算显示的数据
	if not self.infoDatas then
		self.infoDatas = {}
		self.infoDatas[1] = 'TitleNatureDsc'
		local datas = {}
		self.infoDatas[2] = datas
		for _,v in pairs(Enum.HeroAttrType) do
			if v <= Enum.HeroAttrType.Life then
				datas[#datas + 1] = {v, 'ShowAttr_'..v, 'ShowAttr_'..v..'_Desc'}
			end
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRoleInfoPop, self.infoDatas)
end

function UIRoleNaturePointView:OnLeftClick()
	self.controller:SwichParterHero(-1)
	self:Init()
	self:RefreshCurNaturePop()
end

function UIRoleNaturePointView:OnRightClick()
	self.controller:SwichParterHero(1)
	self:Init()
	self:RefreshCurNaturePop()
end

function UIRoleNaturePointView:OnHide()

end

function UIRoleNaturePointView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
	self:RefreshCurNaturePop()
end

function UIRoleNaturePointView:OnClose()

end

function UIRoleNaturePointView:OnDispose()
	self.baseSView.loopVerticalScrollRect:ClearCells()
	self.addSView.loopVerticalScrollRect:ClearCells()
	self.infoDatas = nil
	self.cfgData = nil
end

return UIRoleNaturePointView

