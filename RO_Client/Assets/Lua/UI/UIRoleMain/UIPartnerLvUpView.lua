local UIPartnerLvUpView = require("UIRoleMain/UIPartnerLvUpView_Generate")
local ColorExtension = require("ColorExtension")

local oldAttrs = {}
local newAttrs = {}

local lackLvUp = false
local lackCoin = false
local lackAdvance = false
function UIPartnerLvUpView:OnAwake(data)
	self.controller = require("UIRoleMain/UIPartnerLvUpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPartnerLvUpView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_TRAIN_ATTRS, function()
		self:LvUpSuccessDisplay()
		self:Refresh()
		--self:RereshLvUpRP()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ADVENCE_SUCCESS, function()
		self:RefreshAdvenceSuccessWnd()
		self:Refresh()
	end)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ACTOR_SERVER_CHANGE_ATTRS, function(tbArrtDeffrent)
		--LogError(Inspect(tbArrtDeffrent))
		self:Refresh()
	end)
end

function UIPartnerLvUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPartnerLvUpView:Init()
	self:Refresh()
end

function UIPartnerLvUpView:LvUpSuccessDisplay()
	--self.fx_ui_lv_up.uIParticle:PlayCachedParticalSystem(false)
	self.fx_ui_lv_up.uIParticle:PlayCachedParticalSystem(true)
end

function UIPartnerLvUpView:RereshLvUpRP()
	local logicData = self.controller:GetHeroLogicData()
	local lvData = ManagerContainer.CfgMgr:GetParterAttributeByLv(logicData.baseLevel)
	local maxLv = self.controller:GetPartnerCurMaxLv()
	local ownExp = ManagerContainer.DataMgr.UserData:GetHeroExp()

	local stepData = self.controller:GetHeroStepData()
	self.popLvUp.btnLvUp.redPoint1:SetActive(logicData.baseLevel < maxLv and lvData.Exp < ownExp and (stepData == nil and true or logicData.advanceLevel <= #stepData.AddLv))
end

function UIPartnerLvUpView:Refresh()
	local logicData = self.controller:GetHeroLogicData()
	local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(logicData.configId)
	--HeroHeadIcon:SetInactivationHeroIcon(self, cfgData, self.popLvUp.headItem, logicData)

	local curMaxLv, advenceMaxLv = self.controller:GetPartnerCurMaxLv()
	-- local maxLv = advenceMaxLv or curMaxLv
	local maxLv = advenceMaxLv
	if advenceMaxLv == nil or curMaxLv > advenceMaxLv then
		maxLv = curMaxLv
	end

	local stepData = self.controller:GetHeroStepData()
	if logicData.baseLevel >= maxLv and logicData.advanceLevel >= #stepData.AddLv then
		--self.popLvUp:SetActive(false)
		--self.popLvOK.animator:Play("PopWindowOut")
		self.AnyBtn.button.onClick:Invoke()
		return
	end

	local actorData = ManagerContainer.LuaActorDataMgr:GetActorsById(logicData.id);
	CommonUtil.SetPlayerHeadAndFrame(self, self.popLvUp.headItem, actorData,false,actorData.HeadFrameId)

	self.popLvUp.nameText.uILocalizeScript:SetContent(cfgData.Name)

	local curLv = logicData.baseLevel

	self.popLvUp.lV.number.text.text = CommonUtil.StringConcat(curLv, "/", maxLv)

	--for i = 1, 5 do
	--	self.popLvUp.grid["step"..i]:SetActive(false)
	--end
	self.evolution:SetActive(stepData ~= nil)
	if stepData ~= nil then
		for i = 1, #stepData.AddLv do
			local num = math.floor((i- 1) / 5) + 1
			local idx = (i - 1) % 5 + 1
			local num1 = math.floor((logicData.advanceLevel - 1) / 5 + 1)
			local idx1 = (logicData.advanceLevel - 1) % 5 + 1
			local step = self.popLvUp.grid["step"..idx]
			if num < num1 then
				step["ic"..num]:SetActive(true)
			elseif num == num1 then
				step["ic"..num]:SetActive(idx <= idx1)
			else
				step["ic"..num]:SetActive(false)
			end
		end
	end

	for i = 1, 5 do
		local attr = self.popLvUp["attr"..i]
		attr:SetActive(false)
	end
	local dic = ManagerContainer.LuaActorDataMgr:GetLvUpLocalPreviewSecondAttrVal(
			logicData.id,
			logicData.baseLevel
	)
	if dic == nil then
		LogError("cant find follew "..logicData.id)
		return
	end
	local iter = dic:GetEnumerator()
	local curAttrs = {}
	while iter:MoveNext() do
		curAttrs[iter.Current.Key] = iter.Current.Value
	end

	local dic = ManagerContainer.LuaActorDataMgr:GetLvUpPreviewSecondAttrVal(
			logicData.id,
			logicData.baseLevel
	)
	local iter = dic:GetEnumerator()
	local SverCurAttrs = {}
	while iter:MoveNext() do
		SverCurAttrs[iter.Current.Key] = iter.Current.Value
	end

	if logicData.baseLevel < maxLv then
		--升级
		local dic = ManagerContainer.LuaActorDataMgr:GetLvUpLocalPreviewSecondAttrVal(
				logicData.id,
				logicData.baseLevel + 1
		)
		local iter = dic:GetEnumerator() 

		local newAttrs = {}
		while iter:MoveNext() do
			--下一级服务器属性 = 服务器当前 + （本地下一级 - 本地当前）  客户端属性有一部分没有 只算改变差值
			local Attr = SverCurAttrs[iter.Current.Key] + 
									iter.Current.Value - curAttrs[iter.Current.Key]
			newAttrs[iter.Current.Key] = math.floor(Attr)
		end

		self.popLvUp.lVLimit.text.text.text = I18N.T("LV")
		self.popLvUp.lVLimit.number1.text.text = logicData.baseLevel
		self.popLvUp.lVLimit.number2.text.text = logicData.baseLevel + 1
		self.popLvUp.lVLimit:SetActive(true)

		local idx = 0
		for k,v in pairs(newAttrs) do
			if k == Enum.HeroAttrType.Life or (k >= Enum.HeroAttrType.Attack and k <= Enum.HeroAttrType.MagicDefense) then
				idx = idx + 1
				if idx > 5 then
					break
				end
				local attr = self.popLvUp["attr"..idx]
				if attr then
					local val = math.floor(SDataUtil.InvConvert(v))
					local val1 = math.floor(SverCurAttrs[k])
					attr.text.text.text = I18N.T("Attr_" .. k)
					attr.number1.text.text = val1
					attr.number2.text.text = val
					if k == Enum.HeroAttrType.Attack or k == Enum.HeroAttrType.MagicAttack then
						attr:SetActive(val ~= val1 and cfgData.JobType ~= 4 and cfgData.JobType ~= 5)
					else
						attr:SetActive(val ~= val1)
					end
				end
			end
		end
		self:RefreshTrainCost()
	else
		local nextMaxLv = self.controller:GetPartnerNextMaxLv()
		local stepData = self.controller:GetHeroStepData()

		self.popLvUp.lVLimit.text.text.text = I18N.T("LVLimit")
		self.popLvUp.lVLimit.number1.text.text = curMaxLv
		self.popLvUp.lVLimit:SetActive(true)

		local data = stepData["Attribute"..(logicData.advanceLevel + 1)]
		if data == nil then
			self.popLvUp.lVLimit.number2.text.text = "--"

			local idx = 0
			for k,v in pairs(SverCurAttrs) do
				idx = idx + 1
				if idx > 1 then
					break
				end
				local attr = self.popLvUp["attr"..idx]
				if attr then
					local val = math.floor(SverCurAttrs[k])
					attr.text.text.text = I18N.T("Attr_" .. k)
					attr.number1.text.text = val
					attr.number2.text.text = "--"
					attr:SetActive(true)
				end
			end
		else
			self.popLvUp.lVLimit.number2.text.text = nextMaxLv
			local idx = 0
			for k,v in pairs(data) do
				idx = idx + 1
				if idx > 5 then
					break
				end
				local attr = self.popLvUp["attr"..idx]
				if attr then
					local val = math.floor(SverCurAttrs[v[1]])
					attr.text.text.text = I18N.T("Attr_" .. v[1])
					attr.number1.text.text = val
					attr.number2.text.text = val + v[2]
					attr:SetActive(true)
				end
			end
		end
	end

	local canAdvence = self.controller:CanAdvence()
	self.popLvUp.btnLvUp:SetActive(not canAdvence and logicData.owned and logicData.baseLevel < maxLv)
	self.popLvUp.btnAdvance:SetActive(canAdvence)

	if canAdvence then
		self:RefreshAdvenceCost()
	end

	self:RefreshSkillRecommend()
	--self:RereshLvUpRP()
end

function UIPartnerLvUpView:RefreshTrainCost()
	local logicData = self.controller:GetHeroLogicData()
	local lvData = ManagerContainer.CfgMgr:GetParterAttributeByLv(logicData.baseLevel)

	local ownExp = ManagerContainer.DataMgr.UserData:GetHeroExp()
	local num = CommonUtil.FormatNumber(lvData.Exp)
	self.popLvUp.cost.number.text.text = num
	lackLvUp = ownExp < lvData.Exp
	CommonUtil.IsConditionOutColor(self.popLvUp.cost.number.text, lvData.Exp > ownExp, num)
end

function UIPartnerLvUpView:RefreshSkillRecommend()
	local skillPreview = self.popLvUp.skillPreview
	local lv, skillType, skillId = CommonUtil.FindNextUnlockSkill(self.controller:GetData())
	if self.recommendSkillId == nil and skillId == nil then
		skillPreview:SetActive(false)
		return
	end

	if self.recommendSkillId == skillId then return end

	if self.recommendSkillId ~= nil then
		self:RefreshUnLockNewSkill(self.recommendSkillType, self.recommendSkillId)
	end

	self.recommendSkillId = skillId
	self.recommendSkillType = skillType

	if skillId == nil then
		skillPreview:SetActive(false)
		return
	end

	skillPreview.skillItem.icon.image.sprite = nil
	local skillCfgData
	if skillType and skillId then
		skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(skillType, skillId, 1)
	end
	if skillCfgData then
		skillPreview:SetActive(true)
		skillPreview.text.text.text = I18N.SetLanguageValue('UnRockSkill', lv)

		CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
			skillPreview.skillItem.icon.image.sprite = sprite
		end, self, "SkillPreviewIconAsyncIdx")
		skillPreview.skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(1))
		skillPreview.skillName.text.text = I18N.SetLanguageValue(skillCfgData.Name)
		local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, 1)
		local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillCfgId)
		if skillLevelCfgData then
			if skillLevelCfgData.DescParam then
				if type(skillLevelCfgData.DescParam) == 'table' then
					skillPreview.textDsc.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(skillLevelCfgData.DescParam))
				else
					skillPreview.textDsc.text.text = string.formatbykey(skillLevelCfgData.Desc, skillLevelCfgData.DescParam)
				end
			else
				skillPreview.textDsc.text.text = string.formatbykey(skillLevelCfgData.Desc)
			end
		else
			skillPreview.textDsc.text.text = ''
		end
	else
		skillPreview:SetActive(false)
		skillPreview.skillItem.num.text.text = ''
		skillPreview.skillName.text.text = ''
		skillPreview.textDsc.text.text = ''
	end
end

function UIPartnerLvUpView:RefreshUnLockNewSkill(skillType, skillId)
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(skillType, skillId, 1)
	if skillCfgData == nil then return end

	local item = self.skillPreviewItem

	CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
		item.skillItem.icon.image.sprite = sprite
	end, self, "SkillPreview1IconAsyncIdx")
	item.skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(1))
	item.skillName.text.text = I18N.SetLanguageValue(skillCfgData.Name)
	local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, 1)
	local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillCfgId)
	if skillLevelCfgData then
		if skillLevelCfgData.DescParam then
			if type(skillLevelCfgData.DescParam) == 'table' then
				item.desText.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(skillLevelCfgData.DescParam))
			else
				item.desText.text.text = string.formatbykey(skillLevelCfgData.Desc, skillLevelCfgData.DescParam)
			end
		else
			item.desText.text.text = string.formatbykey(skillLevelCfgData.Desc)
		end
	else
		item.desText.text.text = ''
	end

	local skillShowData = ManagerContainer.CfgMgr:GetSkillShowCfgById(skillId)
	local tags = nil
	local num = 0
	if skillShowData then
		tags = skillShowData.Label
		if tags then
			if type(tags[1]) == 'number' then
				tags = {tags}
			end
			num = #tags
		end
	end
	for i = 1, 4 do
		local skillTagItem = item['skillTagItem' .. i]
		if skillTagItem then
			if i <= num then
				local tagId = tags[i][1]
				local colorId = tags[i][2]
				skillTagItem:SetActive(true)
				skillTagItem.bgColorID.image.color = ColorExtension.HexStringToColor(I18N.SetLanguageValue('ColorID' .. tostring(colorId)))
				skillTagItem.textSkillID.uILocalizeScript:SetContent('SkillTagID' .. tostring(tagId))
			else
				skillTagItem:SetActive(false)
			end
		end
	end

	self.popSkillUnlock:SetActive(true)
end

function UIPartnerLvUpView:RefreshAdvenceCost()
	local logicData = self.controller:GetHeroLogicData()
	local stepData = self.controller:GetHeroStepData()

	local ownCoin = ManagerContainer.DataMgr.UserData:GetOwnCoin()

	local num = logicData.advanceLevel + 1 <= #stepData.CostMoney and CommonUtil.FormatNumber(stepData.CostMoney[logicData.advanceLevel + 1]) or 0
	self.popLvUp.cost1.number.text.text = num
	if logicData.advanceLevel + 1 <= #stepData.CostMoney then
		lackCoin = ownCoin < stepData.CostMoney[logicData.advanceLevel + 1]
		CommonUtil.IsConditionOutColor(self.popLvUp.cost1.number.text, stepData.CostMoney[logicData.advanceLevel + 1] > ownCoin, num)
	end

	local stoneData = ManagerContainer.CfgMgr:GetItemById(Enum.ItemIndex.PartnerStone)
	CommonUtil.LoadIcon(self, stoneData.Icon, function (sprite)
		self.popLvUp.cost2.icon.image.sprite = sprite
	end)
	local ownStone = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.AngelTear)
	local num = logicData.advanceLevel + 1 <= #stepData.CostStone and CommonUtil.FormatNumber(stepData.CostStone[logicData.advanceLevel + 1]) or 0
	self.popLvUp.cost2.number.text.text = num
	if logicData.advanceLevel + 1 <= #stepData.CostMoney then
		lackAdvance = ownStone < stepData.CostStone[logicData.advanceLevel + 1]
		CommonUtil.IsConditionOutColor(self.popLvUp.cost2.number.text, stepData.CostStone[logicData.advanceLevel + 1] > ownStone, num)
	end
end


function UIPartnerLvUpView:RefreshAdvenceSuccessWnd()
	local curMaxLv = self.controller:GetPartnerCurMaxLv()
	local lastMaxLv = self.controller:GetPartmerLastMaxLv()
	local stepData = self.controller:GetHeroStepData()
	local logicData = self.controller:GetHeroLogicData()

	local headLua = self.popEvolutionOK.headItem
	local actorData = ManagerContainer.LuaActorDataMgr:GetActorsById(logicData.id);
	CommonUtil.SetPlayerHeadAndFrame(self, headLua, actorData,false,actorData.HeadFrameId)

	local data = stepData["Attribute"..logicData.advanceLevel]
	if data == nil then
		LogError(logicData.configId.." 伙伴上一阶 "..(logicData.advanceLevel - 1).."  进阶属性错误")
	end

	-- for i = 1, self.popEvolutionOK.grid.transform.childCount do
	-- 	self.popEvolutionOK.grid.transform:GetChild(i - 1).gameObject:SetActive(false)
	-- end

	self.popEvolutionOK.grid:SetActive(stepData ~= nil)
	if stepData ~= nil then
		for i = 1, #stepData.AddLv do
			local num = math.floor((i- 1) / 5) + 1
			local idx = (i - 1) % 5 + 1
			local num1 = math.floor((logicData.advanceLevel - 1) / 5 + 1)
			local idx1 = (logicData.advanceLevel - 1) % 5 + 1
			local step = self.popEvolutionOK.grid["step"..idx]
			if num < num1 then
				step["ic"..num]:SetActive(true)
			elseif num == num1 then
				step["ic"..num]:SetActive(idx <= idx1)
			else
				step["ic"..num]:SetActive(false)
			end
		end
	end

	self.popEvolutionOK.lVLimit.number1.text.text = lastMaxLv
	self.popEvolutionOK.lVLimit.number2.text.text = curMaxLv
	self.popEvolutionOK.lVLimit:SetActive(true)
	
	for i = 1, 5 do
		local attr = self.popEvolutionOK["attr"..i]
		attr:SetActive(data[i] ~= nil)
		if data[i] then
			local val = math.floor(SDataUtil.InvConvert(logicData.attrs[data[i][1]]))
			attr.text.text.text = I18N.T("Attr_" .. data[i][1])
			attr.number1.text.text = val
			attr.number2.text.text = data[i][2] + val
		end
	end
	self.popEvolutionOK:SetActive(true)
end

function UIPartnerLvUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end
 
function UIPartnerLvUpView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.popLvUp.btnLvUp.repeatButton:AddRepeatClickEventListener(function (index, isOver)
		if lackLvUp then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LackExpPartner")
			return
		end
		self.controller:PartnerLvUpReq(self.controller:GetHeroLogicId())
	end)

	self.uiBase:AddButtonEventListener(self.popLvUp.btnAdvance.button, function ()
		if lackCoin then
			CommonUtil.ItemNotEnoughHandle(Enum.ItemType.Coin)
			return
		end
		if lackAdvance then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("LackAngelsTears")
			return
		end
		self.controller:PartnerAdvenceLvUpReq(self.controller:GetHeroLogicId())
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.popLvUp.btnClose.button, function ()
		self:UIClose()
	end)
end

function UIPartnerLvUpView:OnHide()

end

function UIPartnerLvUpView:OnShow(data)
	self.controller:SetData(data)

end

function UIPartnerLvUpView:OnClose()
end

function UIPartnerLvUpView:OnDispose()
	self.controller:OnDispose()
end

return UIPartnerLvUpView

