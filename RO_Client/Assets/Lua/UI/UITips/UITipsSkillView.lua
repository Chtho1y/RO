local UITipsSkillView = require("UITips/UITipsSkillView_Generate")
local ColorExtension = require("ColorExtension")

local targetData
function UITipsSkillView:OnAwake(data)
	self.controller = require("UITips/UITipsSkillCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UITipsSkillView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UITipsSkillView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UITipsSkillView:Init()
	targetData = self.controller:GetData()
	self:InitSkill()
end

function UITipsSkillView:InitSkill()
	local skillId = targetData.cfgId
	local skillLevel = targetData.num or 0
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(Enum.SkillType.Active, skillId, skillLevel)
	local skillLevelCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLevel)
	local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillLevelCfgId)

	local skillNextLevelCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLevel + 1)
	local skillNextLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillNextLevelCfgId)

	local skillShowData = ManagerContainer.CfgMgr:GetSkillShowCfgById(skillId)

	CommonUtil.SetCommonSkillItem(self, self.skillItem, skillId, skillLevel)

	if skillCfgData then
		self.textName.text.text = string.formatbykey(skillCfgData.Name)
		if skillCfgData.SpcSkillDec then
			self.dscGai.txt.text.text = self:GetSpcSkillDesc(skillCfgData.SpcSkillDec, skillLevel)
			self.dscGai:SetActive(true)
		else
			self.dscGai:SetActive(false)
		end
	else
		self.textName.text.text = ''
		self.dscGai:SetActive(false)
	end

	if skillLevelCfgData then
		self.dscCurrent.level.text.text = skillLevel

		self.type1.text2.text.text = tostring(skillLevelCfgData.CD) .. string.formatbykey('S')
		self.type2.text2.text.text = tostring(skillLevelCfgData.Cost) .. string.formatbykey('sp')
		local descParam = skillLevelCfgData.DescParam
		if descParam then
			if type(descParam) == 'table' then
				self.dscCurrent.txt.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(descParam))
			else
				self.dscCurrent.txt.text.text = string.formatbykey(skillLevelCfgData.Desc, descParam)
			end
		else
			self.dscCurrent.txt.text.text = string.formatbykey(skillLevelCfgData.Desc)
		end
	else
		self.type1.text2.text.text = '-'
		self.type2.text2.text.text = '-'
		self.dscCurrent.txt.text.text = ''
	end

	self.dscNext:SetActive(not targetData.isMax)
	self.maxLevel:SetActive(targetData.isMax)
	if not targetData.isMax and skillNextLevelCfgData then
		self.dscNext.level.text.text = skillLevel + 1
		local descParam = skillNextLevelCfgData.DescParam
		if descParam then
			if type(descParam) == 'table' then
				self.dscNext.txt.text.text = string.formatbykey(skillNextLevelCfgData.Desc, unpack(descParam))
			else
				self.dscNext.txt.text.text = string.formatbykey(skillNextLevelCfgData.Desc, descParam)
			end
		else
			self.dscNext.txt.text.text = string.formatbykey(skillNextLevelCfgData.Desc)
		end
	end

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
		local skillTagItem = self['skillTagItem' .. i]
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

	self.type1:SetActive(true)
	self.type2:SetActive(true)
	self.type1.text1.uILocalizeScript:SetContent('SkillCD1')
	self.type2.text1.uILocalizeScript:SetContent('SkillCost')

	self.skillTag:SetActive(true)
end

function UITipsSkillView:GetSpcSkillDesc(spcSkillDecs, skillLevel)
	if not spcSkillDecs then
		return ''
	end
	local content1 = nil
	local content2 = nil
	local spcSkillDec
	for i = 1, #spcSkillDecs do
		spcSkillDec = spcSkillDecs[i]
		if spcSkillDec then
			if spcSkillDec[1] then
				if spcSkillDec[1] <= skillLevel then
					if content1 then
						content1 = content1 .. '\n' .. string.formatbykey(spcSkillDec[2])
					else
						content1 = string.formatbykey(spcSkillDec[2])
					end
				else
					if content2 then
						content2 = content2 .. '\n' .. string.formatbykey(spcSkillDec[2])
					else
						content2 = string.formatbykey(spcSkillDec[2])
					end
				end
			end
		end
	end
	if content1 then
		content1 = string.format(Constant.GreenColorText, content1)
	end
	if content2 then
		if content1 then
			content1 = content1 .. '\n' .. content2
		else
			content1 = content2
		end
	end
	return tostring(content1)
end

function UITipsSkillView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UITipsSkillView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickClose)
end

function UITipsSkillView:OnClickClose(button, params)
	self:UIClose()
end

function UITipsSkillView:OnHide()

end

function UITipsSkillView:OnShow(data)
	self.controller:SetData(data)

end

function UITipsSkillView:OnClose()
end

function UITipsSkillView:OnDispose()
	self.controller:OnDispose()
end

return UITipsSkillView

