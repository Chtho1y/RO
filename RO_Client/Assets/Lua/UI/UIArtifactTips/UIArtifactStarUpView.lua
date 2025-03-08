local UIArtifactStarUpView = require("UIArtifactTips/UIArtifactStarUpView_Generate")
local IconItemCtr = require ("Common.IconItemCtr")
local RectOffset = UnityEngine.RectOffset

function UIArtifactStarUpView:OnAwake(data)
	self.controller = require("UIArtifactTips/UIArtifactStarUpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIArtifactStarUpView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SKILL_EQUIP_LV_UP_REFRESH, self, self.StarUpSuccess)
end

function UIArtifactStarUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIArtifactStarUpView:Init()
	self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(false)
	self:InitGrid()
	self:Refresh()
end

function UIArtifactStarUpView:StarUpSuccess()
	self.controller:ClearSelected()
	self:RefreshTop()
	self:RefreshStarInfo()
	self:RefreshCostGrid()
	self.fx_ui_refine_success.uIParticle:PlayCachedParticalSystem(true)
end

function UIArtifactStarUpView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	self:RefreshCostGrid()
end

function UIArtifactStarUpView:InitGrid()
    self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
        return self:GetItemByRowColumn(gridView, itemIndex, row, column)
    end, nil)

    self:InitGridData()

    --self.delayTimer = FrameTimer.New(function()
    --    self:InitData()
    --end, 1)
    --self.delayTimer:Start()
end

function UIArtifactStarUpView:InitGridData()
    local loopGridView = self.scrollView.loopGridView

    local itemSize = loopGridView.ItemSize
    local itemPadding = loopGridView.ItemPadding
    local padding = loopGridView.Padding
    local itemSizeWithPadding = itemPadding + itemSize
    local width = loopGridView.ViewPortWidth - padding.left - padding.right + itemPadding.x
    local height = loopGridView.ViewPortHeight - padding.top
    local row = Mathf.Floor(width / (itemSizeWithPadding.x))
    local column = Mathf.Ceil(height / (itemSizeWithPadding.y))
    local realWidth = row * itemSizeWithPadding.x
    local offset = width - realWidth
    if offset > 0 then
        offset = offset * 0.5
        local newPadding = RectOffset(offset + padding.left, offset + padding.right, padding.top, padding.bottom)
        loopGridView:SetPadding(newPadding)
    end
    loopGridView:SetGridFixedGroupCount(SuperScrollView.GridFixedType.ColumnCountFixed, row)
    self.controller:SetGridRowColumn(row, column)

    --if self.startCB then
    --    self.startCB(self.root)
    --end
end

function UIArtifactStarUpView:Refresh()
	self:RefreshTop()
	self:RefreshJobInfo()
	self:RefreshStarInfo()
end

function UIArtifactStarUpView:RefreshTop()
	local skillEquipData = self.controller:GetSkillEquipData()
	local cfgId = skillEquipData.cfgId
	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)

	IconItemCtr:SetData(self, self.skillEquipSlot.iconItem, skillEquipData, Enum.ItemIEnterType.HeroSq) 
	self.skillEquipSlot.iconItem:SetActive(true)
	self.textName.text.text = I18N.T(cfgData.Name)
end

function UIArtifactStarUpView:RefreshJobInfo()
	local heroId = self.controller:GetHeroId()
	local heroCfgId = self.controller:GetHeroCfgId()
	local nickname = self.controller:GetHeroNickname()

	local jobIcon
	if heroId == 1 then
		local jobData = ManagerContainer.CfgMgr:GetJobDataById(heroCfgId)
		jobIcon = jobData.JobIcon
	else
		local heroCfgData = ManagerContainer.CfgMgr:GetPartnerDataById(heroCfgId)
		jobIcon = heroCfgData.JobIcon
	end

	CommonUtil.LoadIcon(self, jobIcon, function (sprite)
		self.jobIcon.image.sprite = sprite
	end)

	local name
	if heroId == 1 then
		local cfgData = ManagerContainer.CfgMgr:GetJobDataById(heroCfgId)
		if nickname == nil then
			name = CommonUtil.GetHeroJobAndNameByUid(heroId, heroCfgId) 
		else
			if cfgData == nil then
				name = nickname
			else
				name = I18N.T(cfgData.JobName) .. nickname
			end
		end
	else
		name = CommonUtil.GetHeroJobAndNameByUid(heroId, heroCfgId) 
	end
	self.heroName.text.text = name
end

local function IsTheJob(heroId, skillEquipCfgData)
	local jobData = CommonUtil.GetHeroJobCfgDataByUid(heroId)
	return jobData.JobType == skillEquipCfgData.JobType and jobData.JobBranch == skillEquipCfgData.JobBranch and jobData.JobStage == skillEquipCfgData.JobStage
end

local resLackState
function UIArtifactStarUpView:RefreshStarInfo()
	resLackState = nil

	local heroId = self.controller:GetHeroId()
	local skillEquipData = self.controller:GetSkillEquipData()
	local curStarLv = skillEquipData.starLv
	local nextStartLv = curStarLv + 1
	local limit = skillEquipData.maxStarLv
	local state = nextStartLv <= limit

	self.starGrp2:SetActive(state)
	self.costDsc.uILocalizeScript:SetContentAndValues("ArtifactStartips", {nextStartLv})
	self.costDsc:SetActive(state)

	for i = 1, Constant.SkillEquipMaxStarLimit do
		local item = self.starGrp1["star"..i]
		item:SetActive(false)
		local item = self.starGrp2["star"..i]
		item:SetActive(false)
	end

	for i = 1, limit do
		local item = self.starGrp1["star"..i]
		item:SetActive(true)
		if item then
			item.star:SetActive(i <= curStarLv)
		end
	end

	if state then
		for i = 1, limit do
			local item = self.starGrp2["star"..i]
			item:SetActive(true)
			if item then
				item.star:SetActive(i <= nextStartLv)
			end
		end
	end

	local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
	local content = string.format(Constant.GreenColorText,I18N.T(limit and cfgData.FuncDesc[nextStartLv] or cfgData.FuncDesc[curStarLv]))
	if not IsTheJob(heroId, cfgData) then
		content = content..I18N.SetLanguageValue("ArtifactEmployTips", I18N.T(cfgData.JobName))
	end
	self.upDsc.text.text = content

	self.btnRefine:SetActive(state)
	if state then
		local condition = cfgData.Condition[nextStartLv]
		local key = condition[2][1]
		local num = condition[2][2]

		local ownNum = CommonUtil.GetOwnResCountByItemId(key)
		if ownNum < num then
			resLackState = {key, true}
			self.number.text.text = string.format(Constant.PinkColorText,num)
		else
			resLackState = {key, false}
			self.number.text.text = num
		end
	end

	self.scrollView:SetActive(state)
end

function UIArtifactStarUpView:RefreshCostGrid(resetPos)
	self.controller:RefreshShowDatas()
	local loopGridView = self.scrollView.loopGridView
	local length = self.controller:GetShowDataLength()
    if resetPos then
        loopGridView:RefreshListByIndex(length, 0)
    else
        loopGridView:RefreshListByIndex(length)
    end
end

function UIArtifactStarUpView:GetItemByRowColumn(gridView, itemIndex, row, column)
    local length = self.controller:GetShowDataLength()
    if (itemIndex < 0 or itemIndex >= length) then
        return nil
    end
    local showData = self.controller:GetShowData(itemIndex)
    local item = nil
    if showData then
        item = gridView:NewListViewItem("IconItem")
        item.gameObject.name = itemIndex
        local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
        CommonUtil.UpdateItemPrefab(self, itemlua, showData, Enum.ItemIEnterType.Bag, self, self.OnItemClick, itemIndex)
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end

function UIArtifactStarUpView:OnItemClick(button, params)
	local data = params[0]
	local idx = params[2]

	local oldIdx = self.controller:SelectSkillEquip(data)

	if oldIdx then
		local itemlua = self:GetShowItemByIdx(oldIdx - 1)
		if itemlua then
			itemlua.selected:SetActive(false)
		end
	end
	local itemlua = self:GetShowItemByIdx(idx)
	if itemlua then
		itemlua.selected:SetActive(data.selected == 1)
	end
end

function UIArtifactStarUpView:GetShowItemByIdx(idx)
    local item = self.scrollView.loopGridView:GetShownItemByItemIndex(idx)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "IconItem", item.gameObject)
        return itemlua
    end
end

function UIArtifactStarUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIArtifactStarUpView:OnCloseClick()
	self:UIClose()
end

function UIArtifactStarUpView:OnStarUpClick()
	local selectedCount = self.controller:GetSelectedCostCount()
	if selectedCount == 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ArtifactSmeltButtonTips4")
		return
	end
	local enough = self.controller:IsCostSkillEuipEnough()
	if not enough then 
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("TitleArtifactStarUpTips")
		return 
	end
	
	if resLackState and resLackState[2] then 
		CommonUtil.ItemNotEnoughHandle(resLackState[1])
		return 
	end

	self.controller:SendStarUpReq()
end

function UIArtifactStarUpView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnRefine.button, self, self.OnStarUpClick)
end

function UIArtifactStarUpView:OnHide()

end

function UIArtifactStarUpView:OnShow(data)
	self.controller:SetData(data)

end

function UIArtifactStarUpView:OnClose()
	self.scrollView.loopGridView:Dispose()
end

function UIArtifactStarUpView:OnDispose()
	self.controller:OnDispose()
end

return UIArtifactStarUpView

