local UIPetExchangeMatsView = require("UIPet/UIPetExchangeMatsView_Generate")
local RectOffset = UnityEngine.RectOffset

function UIPetExchangeMatsView:OnAwake(data)
	self.controller = require("UIPet/UIPetExchangeMatsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetExchangeMatsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPetExchangeMatsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	self:Init()
end

function UIPetExchangeMatsView:InitGrid()
    self.mats.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
        return self:GetItemByRowColumn(gridView, itemIndex, row, column)
    end, nil)

    self:InitData()
end

function UIPetExchangeMatsView:InitData()
    local loopGridView = self.mats.loopGridView
    loopGridView.ItemPadding =  Vector2(20, 20)

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
    self.defaultRectOffset = padding
    self.isInit = true
    self.controller:SetGridRowColumn(row, column)
end
function UIPetExchangeMatsView:Refresh(resetPos)
    self.controller:RefreshShowDataType()
    local loopGridView = self.mats.loopGridView
    local length = self.controller:GetShowDataLength()
    if resetPos then
        loopGridView:RefreshListByIndex(length, 0)
    else
        loopGridView:RefreshListByIndex(length)
    end

    local realLength = self.controller:GetRealShowDataLength()
    if self.noPets then
        self.noPets:SetActive(realLength == 0)
    end

    loopGridView.gameObject:SetActive(true)
end
function UIPetExchangeMatsView:MoveToIndex(idx)
    self.mats.loopGridView:MovePanelToItemByIndex(idx)
end


function UIPetExchangeMatsView:GetItemByRowColumn(gridView, itemIndex, row, column)
    local data = self.controller:GetShowData(itemIndex)
    local item = nil
    if data then
		local enterType = self.controller:GetenterType()
		local showData = CommonUtil.TableClone(data)
		showData.idx = itemIndex
		if enterType == 0 then
			item = gridView:NewListViewItem("IconPetItem")
			item.gameObject.name = itemIndex
			local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconPetItem", item.gameObject)
			CommonUtil.UpdateItemPrefab(self, itemlua, showData, self.enterType, self, self.OnItemClick)
			if self.SelectIndexList[itemIndex] then
				itemlua.selected:SetActive(true)
			end
		elseif  enterType == 1 then
			item = gridView:NewListViewItem("CardIconItem")
			item.gameObject.name = itemIndex
			local itemlua = CommonUtil.BindGridViewItem2Lua(self, "CardIconItem", item.gameObject)
			CommonUtil.UpdateItemPrefab(self, itemlua.iconItem, showData, self.enterType, self, self.OnItemClick)
			itemlua.add:SetActive(false)
			itemlua.mask:SetActive(false)
			self.uiBase:AddButtonUniqueEventListener(itemlua.bg.button, self, self.OnItemClick, itemIndex,showData)
			self.uiBase:AddButtonUniqueEventListener(itemlua.btnRemove.button, self, self.OnRemoveItemClick, itemIndex,showData.cfgId)
			if self.SelectIndexList[itemIndex] then
				itemlua.selected2:SetActive(true)
				itemlua.btnRemove:SetActive(true)
				itemlua.iconItem.num.text.text = self.SelectIndexList[itemIndex].."/"..showData.num
			else
				itemlua.selected2:SetActive(false)
				itemlua.btnRemove:SetActive(false)
				itemlua.iconItem.num.text.text = "0/"..showData.num
			end
		end
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end
function UIPetExchangeMatsView:OnItemClick(button, params)
	local enterType = self.controller:GetenterType()
	local data = enterType == 0 and params[0] or params[1]
	local conditions = self.controller:Getconditions()
	local count = self.controller:GetSelectCount()
	self.selectedIdx = data.idx
	local luaitem = self:GetShowItemByIdx(self.selectedIdx)
	if enterType == 0 then
		self.selectedPetUid = data.id
		if luaitem and  luaitem.selected.activeSelf then
			self:PetClickSure()
			return
		end
		local maxSelectNum = self.controller:GetMaxSelectNum()
		if count >= maxSelectNum then
			self:PetClickSure()
			return
		end
		local otherSelectList = self.controller:GetotherSelectList()
		if otherSelectList[data.id] then
			local data = {"PetExchangetips2", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
		if conditions then
			if conditions[2] < data.level or conditions[3] <self:GetSkillLv(data.skillList)  then
				local data = {"PetCostNotify11", nil, nil, self, self.PetClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			elseif data.isRelevant then
				local data = {"PetCostNotify8", nil, nil, self, self.PetClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			elseif data.isSupport then
				local data = {"PetCostNotify10", nil, nil, self, self.PetClickSure}
				ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			else
				self:PetClickSure()
			end
		end
	elseif enterType == 1 then
		self.selectedPetUid = data.cfgId
		if luaitem and  luaitem.selected2.activeSelf then
			self:PetClickSure()
			return
		end
		local maxSelectNum = self.controller:GetMaxSelectNum()
		if count >= maxSelectNum then
			self:PetClickSure()
			return
		end
		local otherSelectList = self.controller:GetotherSelectList()
		if otherSelectList[data.cfgId] then
			local data = {"PetExchangetips2", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
		self:PetClickSure()
	end
end

function UIPetExchangeMatsView:OnRemoveItemClick(button,params)
	local index = params[0]
	local cfgId = params[1]
	local selectList = self.SelectIndex
	local count = self.controller:GetSelectCount()
	local maxSelectNum = self.controller:GetMaxSelectNum()
	local luaitem = self:GetShowItemByIdx(index)
	local num = CommonUtil.GetOwnResCountByItemId(cfgId)
	if selectList[cfgId] then
		count = count - 1
		selectList[cfgId] = selectList[cfgId] - 1
		if selectList[cfgId] > 0 then
			luaitem.selected2:SetActive(true)
			luaitem.btnRemove:SetActive(true)
			luaitem.iconItem.num.text.text = selectList[cfgId].."/"..num
		else
			luaitem.selected2:SetActive(false)
			luaitem.btnRemove:SetActive(false)
			count  = count - selectList[cfgId]
			luaitem.iconItem.num.text.text = "0/"..num
			selectList[cfgId] = nil
		end
	end
	self.controller:SetCurrSelectCount(count)
	self.number.text.text = I18N.SetLanguageValue(count.."/"..maxSelectNum)
end

function UIPetExchangeMatsView:PetClickSure()
	local enterType = self.controller:GetenterType()
	local maxSelectNum = self.controller:GetMaxSelectNum()
	local luaitem = self:GetShowItemByIdx(self.selectedIdx)
	local selectList = self.SelectIndex
	local count = self.controller:GetSelectCount()
	if count < maxSelectNum  then
		if selectList[self.selectedPetUid] then
			if luaitem then
				if enterType == 0 then
					luaitem.selected:SetActive(false)
					selectList[self.selectedPetUid] = nil
					count  = count - 1
				elseif enterType == 1 then
					luaitem.selected2:SetActive(false)
					luaitem.btnRemove:SetActive(false)
					count  = count - selectList[self.selectedPetUid]
					local num = CommonUtil.GetOwnResCountByItemId(self.selectedPetUid)
					luaitem.iconItem.num.text.text = "0/"..num
					selectList[self.selectedPetUid] = nil
				end
			end
		else
			if enterType == 0 then
				luaitem.selected:SetActive(true)
				selectList[self.selectedPetUid] = 1
				count  = count + 1
			elseif enterType == 1 then
				luaitem.selected2:SetActive(true)
				luaitem.btnRemove:SetActive(true)
				local num = CommonUtil.GetOwnResCountByItemId(self.selectedPetUid)
				selectList[self.selectedPetUid] = math.min(num,maxSelectNum - count)
				luaitem.iconItem.num.text.text = selectList[self.selectedPetUid].."/"..num
				count  = count + selectList[self.selectedPetUid]
			end
		end
	else
		if selectList[self.selectedPetUid] then
			if luaitem then
				if enterType == 0 then
					luaitem.selected:SetActive(false)
					selectList[self.selectedPetUid] = nil
					count  = count - 1
				elseif enterType == 1 then
					luaitem.selected2:SetActive(false)
					luaitem.selected2:SetActive(false)
					luaitem.btnRemove:SetActive(false)
					count  = count - selectList[self.selectedPetUid]
					local num = CommonUtil.GetOwnResCountByItemId(self.selectedPetUid)
					luaitem.iconItem.num.text.text = "0/"..num
					selectList[self.selectedPetUid] = nil
				end
			end
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("PetExchangetips1")
		end
	end
	self.controller:SetCurrSelectCount(count)
	self.number.text.text = I18N.SetLanguageValue(count.."/"..maxSelectNum)
end

function UIPetExchangeMatsView:GetSkillLv(skillList)
    local count = 0
    if skillList and #skillList > 0 then
        for i = 1, #skillList do
            count = count + skillList[i].level
        end
    end
    return count
end

function UIPetExchangeMatsView:GetShowItemByIdx(idx)
    local item = self.mats.loopGridView:GetShownItemByItemIndex(idx)
    if item then
		local enterType = self.controller:GetenterType()
		local itemlua
		if enterType == 0 then
			itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "IconPetItem", item.gameObject)
		elseif enterType == 1 then
			itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "CardIconItem", item.gameObject)
		end
        return itemlua
    end
end

function UIPetExchangeMatsView:Init()
	local count = self.controller:GetSelectCount()
	self.SelectIndexList = {}
	self.SelectIndex =  CommonUtil.TableClone(self.controller:GetSelectList())
	self:InitLastSelect(self.SelectIndex)
	self:InitGrid()
	self:Refresh(true)
	local enterType = self.controller:GetenterType()
	local conditions = self.controller:Getconditions()
	if enterType == 0 then
		self.number.text.text = I18N.SetLanguageValue(count.."/"..conditions[4])
		local title = ""
		if conditions[5] then
			if conditions[1] == 2 then
				title = "Mini"
			elseif conditions[1] == 3 then
				title = "Mvp"
			end
		else
			local CfgData = ManagerContainer.CfgMgr:GetItemById(conditions[1])
			title = CfgData.Name
		end
		self.tips.text.text = string.formatbykey('PetExChangeConditionTips',title,tostring(conditions[2]),tostring(conditions[3]))
	elseif enterType == 1 then
		local title = ""
		if conditions[5] then
			if conditions[6] == 2 then
				title = "Mini"
			elseif conditions[6] == 3 then
				title = "Mvp"
			end
			self.tips.text.text = string.formatbykey('CardExChangeConditionTips',title,tostring(conditions[2] or ""))
		else
			local CfgData = ManagerContainer.CfgMgr:GetItemById(conditions[2])
			title = CfgData.Name
			self.tips.text.text = string.formatbykey('CardExChangeConditionTips1',title,tostring(conditions[4]))
		end
		self.number.text.text = I18N.SetLanguageValue(count.."/"..conditions[4])
	end
	self.mats.loopGridView.ScrollRect.enabled = false
end

function UIPetExchangeMatsView:InitLastSelect(list)
	if list then
		for k, v in pairs(list) do
			local index = self:GetSelectPetIndexByUid(k)
			if index ~= 0 then
				self.SelectIndexList[index - 1] = v
				self.SelectIndex[k] = v
			end
		end
	end
end
function UIPetExchangeMatsView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.mats.loopGridView.ScrollRect.enabled = true
end

function UIPetExchangeMatsView:GetSelectPetIndexByUid(id)
	local showDatas = self.controller:GetShowDatas()
	local enterType = self.controller:GetenterType()
	if showDatas and #showDatas > 0 then
		for i = 1, #showDatas do
			if enterType == 0 then
				if showDatas[i].id == id then
					return i
				end
			elseif enterType == 1 then
				if showDatas[i].cfgId == id then
					return i
				end
			end
		end
	end
	return 0
end


function UIPetExchangeMatsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIPetExchangeMatsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnCancel.button, self, self.OnCancelClick)
	self.uiBase:AddButtonEventListener(self.btnSure.button, self, self.OnSureClick)
end

function UIPetExchangeMatsView:OnCloseClick()
	self:UIClose()
end

function UIPetExchangeMatsView:OnCancelClick()
	self:OnCloseClick()
end

function UIPetExchangeMatsView:OnSureClick()
	local list = self.controller:GetSelectList() 
	for key, value in pairs(list) do
		list[key] = nil
	end
	if self.SelectIndex then
		for key, value in pairs(self.SelectIndex) do
			list[key] = value
		end
	end
	self.SelectIndex = nil
	self.controller:executeCallBack()
	self:OnCloseClick()
end

function UIPetExchangeMatsView:OnHide()

end

function UIPetExchangeMatsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetExchangeMatsView:OnClose()
end

function UIPetExchangeMatsView:OnDispose()
	self.mats.loopGridView:Dispose()
	self.controller:OnDispose()
end

return UIPetExchangeMatsView
