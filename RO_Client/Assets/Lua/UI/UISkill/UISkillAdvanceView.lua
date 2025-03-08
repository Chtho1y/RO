local UISkillAdvanceView = require("UISkill/UISkillAdvanceView_Generate")
local ColorExtension = require("ColorExtension")

function UISkillAdvanceView:OnAwake(data)
	self.controller = require("UISkill/UISkillAdvanceCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISkillAdvanceView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UISkillAdvanceView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISkillAdvanceView:Init()
	local data = self.controller:GetData()
	self:SetTagBox(1,data[1].id,data[1].lv,true)
	self:SetTagBox(2,data[2].id,data[2].lv,false)
	self.skillPreviewItem1.scrollView.scrollRect.enabled = false
	self.skillPreviewItem2.scrollView.scrollRect.enabled = false
end

function UISkillAdvanceView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UISkillAdvanceView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnCancel.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnSkillAdvance.button, self, self.OnClickAdvanceBtn)
end

function UISkillAdvanceView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.skillPreviewItem1.scrollView.scrollRect.enabled = true
	self.skillPreviewItem2.scrollView.scrollRect.enabled = true
end

function UISkillAdvanceView:SetTagBox(idx,skillId,lv,isNext)
	local skillPreviewItem = self["skillPreviewItem"..idx]
	if  not skillPreviewItem then
		return
	end
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgById(skillId)
	skillPreviewItem.skillItem.icon.image.sprite = nil
	if skillCfgData then
		if skillCfgData.Icon then
			CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
				skillPreviewItem.skillItem.icon.image.sprite = sprite
			end, skillPreviewItem, "SkillIconAsyncIdx")
		end
		skillPreviewItem.skillItem.num.text.text =  (I18N.SetLanguageValue('Lv') .. tostring(lv))
		skillPreviewItem.skillName.text.text = I18N.SetLanguageValue(skillCfgData.Name)
		local skillTreeCfgData
		local IsLeaderHero = math.floor(skillId / 10000) == 1
		if IsLeaderHero then
			skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
		else
			skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
		end
		local quality = skillTreeCfgData and skillTreeCfgData.SkillQuality or 0
		if quality ~= 0 then
			CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[quality], function (sprite)
				skillPreviewItem.skillItem.frame.image.sprite = sprite
			end)
		else
			CommonUtil.LoadIcon(self, "FrameNew/frame_item_gray", function (sprite)
				skillPreviewItem.skillItem.frame.image.sprite = sprite
			end)
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
			local skillTagItem = skillPreviewItem['skillTagItem' .. i]
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
		self:SetDesText(skillPreviewItem.desText,skillId,lv,isNext)
	else
		skillPreviewItem.skillItem.icon.image.sprite = nil
		skillPreviewItem.skillItem.num.text.text = ''
		skillPreviewItem.skillName.text.text = ''
		skillPreviewItem.skillTagItem1:SetActive(false)
		skillPreviewItem.skillTagItem2:SetActive(false)
		skillPreviewItem.skillTagItem3:SetActive(false)
		skillPreviewItem.skillTagItem4:SetActive(false)
	end
end

function UISkillAdvanceView:OnClickCloseBtn()
	self:UIClose()
end

function UISkillAdvanceView:OnClickAdvanceBtn()
	local data = self.controller:GetData()
	local curSkillId = data[1].id
	local heroId = data[3]
	local errorCode, itemCfgId = CommonUtil.CheckSkillCanAvance(heroId,curSkillId)
	if errorCode == 0 then
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_LEVEL_UP_REQ, {hero_id = heroId, skill_id=curSkillId})
	else
		if errorCode == 139 then
			CommonUtil.ItemNotEnoughHandle(itemCfgId, self.uiData.id)
		elseif errorCode == 200 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('NeedAdvanceJobTips')
		elseif errorCode == 141 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('LearnSkillCondition04')
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
		end
	end
	self:UIClose()
end

function UISkillAdvanceView:SetDesText(desText,skillId,skillLv,isNext)
	local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLv)
	local skillCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillCfgId)
	if skillCfgData then
		local descParam = skillCfgData.DescParam
		if descParam then
			if type(descParam) == 'table' then
				if isNext then
					local ls = {}
					local colorStr = '<color=' .. string.formatbykey('ColorID8') .. '>'
					for i = 1, #descParam do
						ls[i] = colorStr .. tostring(descParam[i]) .. '</color>'
					end
					descParam = ls
				end
				desText.text.text = string.formatbykey(skillCfgData.Desc, unpack(descParam))
			else
				if isNext then
					desText.text.text = string.formatbykey(skillCfgData.Desc, '<color=' .. I18N.formatbykey('ColorID8') .. '>' .. tostring(descParam) .. '</color>')
				else
					desText.text.text = string.formatbykey(skillCfgData.Desc, descParam)
				end
			end
		else
			desText.text.text = string.formatbykey(skillCfgData.Desc)
		end
	else
		desText.text.text = ''
	end
end

function UISkillAdvanceView:OnHide()

end

function UISkillAdvanceView:OnShow(data)
	self.controller:SetData(data)

end

function UISkillAdvanceView:OnClose()
end

function UISkillAdvanceView:OnDispose()
	self.controller:OnDispose()
end

return UISkillAdvanceView

