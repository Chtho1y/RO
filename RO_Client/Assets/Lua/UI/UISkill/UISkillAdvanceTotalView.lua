local UISkillAdvanceTotalView = require("UISkill/UISkillAdvanceTotalView_Generate")

function UISkillAdvanceTotalView:OnAwake(data)
	self.controller = require("UISkill/UISkillAdvanceTotalCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end
local skilldata,attrs

function UISkillAdvanceTotalView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UISkillAdvanceTotalView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISkillAdvanceTotalView:Init()
	local data = self.controller:GetData()
	if data ~= nil then
		skilldata = data[1]
		local attrsdata = data[2]
		self.masteredSkill.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
			return self:GetSkillItemByRowColumn(gridView, itemIndex, row, column)
		end, nil)
		self.property.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
			return self:GetPropertyItemByRowColumn(gridView, itemIndex, row, column)
		end, nil)
		attrs = {}
		for k, v in pairs(attrsdata) do
			attrs[#attrs + 1] = {attrId = k,attrValue = v}
		end
		self.masteredSkill.loopGridView:RefreshListByIndex(skilldata and #skilldata or 0)
		self.property.loopGridView:RefreshListByIndex(attrs and #attrs or 0)
	end
end

function UISkillAdvanceTotalView:GetPropertyItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
	item = gridView:NewListViewItem('FashionPropertyItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'FashionPropertyItem', item.gameObject)
	itemLua.name.text.text = I18N.SetLanguageValue('Attr_'..attrs[itemIndex + 1].attrId)
	itemLua.number.text.text = attrs[itemIndex + 1].attrValue
	return item
end

function UISkillAdvanceTotalView:GetSkillItemByRowColumn(gridView, itemIndex, row, column)
	local item = nil
		item = gridView:NewListViewItem('MasteredSkillItem')
		local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'MasteredSkillItem', item.gameObject)
		local cfgdata = ManagerContainer.CfgMgr:GetSkillCfgById(skilldata[itemIndex + 1])
		if not cfgdata  then
			return
		end
			CommonUtil.LoadIcon(self, cfgdata.Icon, function (sprite)
				itemLua.skillItem.icon.image.sprite = sprite
			end)
			local skillTreeCfgData
			local skillId = cfgdata.SkillId
			local IsLeaderHero = math.floor(skillId / 10000) == 1
			if IsLeaderHero then
				skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
			else
				skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
			end
			local quality = skillTreeCfgData and skillTreeCfgData.SkillQuality or 0
			if quality ~= 0 then
				CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[quality], function (sprite)
					itemLua.skillItem.frame.image.sprite = sprite
				end)
			else
				CommonUtil.LoadIcon(self, "FrameNew/frame_item_gray", function (sprite)
					itemLua.skillItem.frame.image.sprite = sprite
				end)
			end
			itemLua.text.text.text = I18N.SetLanguageValue(cfgdata.Name)
			itemLua.skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillTreeCfgData.MaxLv))
	return item
end

function UISkillAdvanceTotalView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISkillAdvanceTotalView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
end

function UISkillAdvanceTotalView:OnClickCloseBtn()
	self:UIClose()
end

function UISkillAdvanceTotalView:OnHide()

end

function UISkillAdvanceTotalView:OnShow(data)
	self.controller:SetData(data)

end

function UISkillAdvanceTotalView:OnClose()
end

function UISkillAdvanceTotalView:OnDispose()
	self.masteredSkill.loopGridView:Dispose()
	self.property.loopGridView:Dispose()
	self.controller:OnDispose()
end

return UISkillAdvanceTotalView

