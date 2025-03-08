local UISuccessTipsView = require("UICommonTips/UISuccessTipsView_Generate")

function UISuccessTipsView:OnAwake(data)
	self.controller = require("UICommonTips/UISuccessTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISuccessTipsView:AddEventListener()

end

function UISuccessTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISuccessTipsView:Init()
	self:RefreshContent()
end

function UISuccessTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISuccessTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.alpha.button, self, self.OnClickAlphaBtn)
end

function UISuccessTipsView:OnHide()

end

function UISuccessTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UISuccessTipsView:OnClose()
end

function UISuccessTipsView:OnDispose()

end

function UISuccessTipsView:OnClickAlphaBtn()
	local isHasNext = self.controller:RemoveCurShowData()
	if isHasNext then
		self.gameObject:SetActive(false)
		self:RefreshContent()
		self.gameObject:SetActive(true)
	else
		self:UIClose()
	end
end

function UISuccessTipsView:RefreshContent()
	local type, data = self.controller:GetShowData()
	if type == 1 then -- 技能
		self.title.text.text = I18N.SetLanguageValue('TitleNewSkill')
		self.skillItem:SetActive(true)
		local skillType = data.skillType
		local skillId = data.skillId
		local skillData = ManagerContainer.CfgMgr:GetSkillCfgByType(skillType, skillId, 1)
		self.skillItem.icon.image.sprite = nil
		if skillData then
			CommonUtil.LoadIcon(self, skillData.Icon, function (sprite)
				self.skillItem.icon.image.sprite = sprite
			end, self, "IconAsyncIdx")
			self.skillItem.num.text.text = string.formatbykey('Lv') .. '1'
			self.skillItem.num:SetActive(false)
			self.nameTxt.text.text = string.formatbykey(skillData.Name)
		else
			self.nameTxt.text.text = ''
			self.skillItem.num:SetActive(false)
		end
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
				self.skillItem.frame.image.sprite = sprite
			end)
		else
			CommonUtil.LoadIcon(self, "FrameNew/frame_item_gray", function (sprite)
				self.skillItem.frame.image.sprite = sprite
			end)
		end
	else
		self.title.text.text = ''
		self.skillItem:SetActive(false)
		self.nameTxt.text.text = ''
	end
end

return UISuccessTipsView

