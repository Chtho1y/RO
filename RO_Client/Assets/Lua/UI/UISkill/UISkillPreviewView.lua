local UISkillPreviewView = require("UISkill/UISkillPreviewView_Generate")

local ColorExtension = require("ColorExtension")

function UISkillPreviewView:OnAwake(data)
	self.controller = require("UISkill/UISkillPreviewCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISkillPreviewView:AddEventListener()

end

function UISkillPreviewView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISkillPreviewView:Init()
	self.skillList.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self:RefreshList()
end

function UISkillPreviewView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISkillPreviewView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.alpha.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
end

function UISkillPreviewView:OnHide()

end

function UISkillPreviewView:OnShow(data)
	self.controller:SetData(data)
	self:RefreshList()
end

function UISkillPreviewView:OnClose()
end

function UISkillPreviewView:OnDispose()
	self.skillList.loopGridView:Dispose()

end


function UISkillPreviewView:RefreshList()
	local count = self.controller:GetSkillListCount()
	local loopGridView = self.skillList.loopGridView
	if loopGridView.ItemTotalCount == count then
		loopGridView:SetListItemCount(0, true)
		loopGridView:SetListItemCount(count, true)
	else
		loopGridView:SetListItemCount(count, true)
	end
end

function UISkillPreviewView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('SkillPreviewItem')
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'SkillPreviewItem', item.gameObject)
	if not itemlua then return nil end
	itemlua.skillItem.icon.image.sprite = nil
	local skillData = self.controller:GetSkillItemInfoByIndex(itemIndex)
	if skillData then
		local skillId = skillData.SkillId
		local skillType = skillData.SkillType
		local skillLv = 1
		local skillCfgData = ManagerContainer.CfgMgr:GetSkillCfgByType(skillType, skillId, skillLv)
		if skillCfgData then
			if skillCfgData.Icon then
				CommonUtil.LoadIcon(self, skillCfgData.Icon, function (sprite)
					itemlua.skillItem.icon.image.sprite = sprite
				end, itemlua, "SkillIconAsyncIdx")
			end
			itemlua.skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLv))
			itemlua.skillName.text.text = I18N.SetLanguageValue(skillCfgData.Name)
			local skillCfgId = CommonUtil.GetSkillCfgIdByIdAndLv(skillId, skillLv)
			local skillLevelCfgData = ManagerContainer.CfgMgr:GetSkillLevelCfgById(skillCfgId)
			if skillLevelCfgData then
				if skillLevelCfgData.DescParam then
					if type(skillLevelCfgData.DescParam) == 'table' then
						itemlua.desText.text.text = string.formatbykey(skillLevelCfgData.Desc, unpack(skillLevelCfgData.DescParam))
					else
						itemlua.desText.text.text = string.formatbykey(skillLevelCfgData.Desc, skillLevelCfgData.DescParam)
					end
				else
					itemlua.desText.text.text = string.formatbykey(skillLevelCfgData.Desc)
				end
			else
				itemlua.desText.text.text = ''
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
				local skillTagItem = itemlua['skillTagItem' .. i]
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
			return item
		end
	end
	itemlua.skillItem.num.text.text = ''
	itemlua.skillName.text.text = ''
	itemlua.desText.text.text = ''
	itemlua.skillTagItem1:SetActive(false)
	itemlua.skillTagItem2:SetActive(false)
	itemlua.skillTagItem3:SetActive(false)
	itemlua.skillTagItem4:SetActive(false)
	LogError('[Wboy] Skill Cfg Data is Error. itemIndex :' .. tostring(itemIndex))
	return item
end

function UISkillPreviewView:OnClickCloseBtn()
	self:UIClose()
end

return UISkillPreviewView

