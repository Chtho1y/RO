local PetMatsGridView = class("PetMatsGridView")
local PetMatsGridCtr = require("UIPet/PetMatsGridCtr")
local RectOffset = UnityEngine.RectOffset

function PetMatsGridView:ctor()
    self.enterType = nil
    self.root = nil
    self.loopView = nil
    self.startCB = nil

    self.itemName = nil

    self.controller = PetMatsGridCtr:new()
end

function PetMatsGridView:Init(enterType, root, loopView)
    self.enterType = enterType
    self.root = root
    self.loopView = loopView
    self.controller:InitRoot(self.root.controller, self.enterType)

    self:SetItemName()

    self:AddEventListener()
    self:InitGrid()
end

function PetMatsGridView:SetItemName()
    self.itemName = "IconPetItem"

    if self.enterType == Enum.ItemIEnterType.Pet then
        self.itemName = "IconPetItem"
    elseif self.enterType == Enum.ItemIEnterType.SkillEquip then
        self.itemName = "IconItem"
    end
end

function PetMatsGridView:AddEventListener()

end

function PetMatsGridView:InitGrid()
    self.loopView:InitGridView(0, function(gridView, itemIndex, row, column)
        return self:GetItemByRowColumn(gridView, itemIndex, row, column)
    end, nil)

    self:InitData()

    --self.delayTimer = FrameTimer.New(function()
    --    self:InitData()
    --end, 1)
    --self.delayTimer:Start()
end

function PetMatsGridView:InitData()
    local loopGridView = self.loopView
    loopGridView.ItemPadding = self.enterType == Enum.ItemIEnterType.PetRelation and Vector2(20, 80) or Vector2(20, 20)

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

    --if self.startCB then
    --    self.startCB(self.root)
    --end
end

function PetMatsGridView:Refresh(resetPos)
    self.controller:RefreshShowDataType()
    local loopGridView = self.loopView
    local realLength = self.controller:GetRealShowDataLength()
    if self.root.noPets then
        self.root.noPets:SetActive(realLength == 0)
    end
    loopGridView.gameObject:SetActive(true)

    local length = self.controller:GetShowDataLength()
    if resetPos then
        loopGridView:RefreshListByIndex(length, 0)
    else
        loopGridView:RefreshListByIndex(length)
    end
end

function PetMatsGridView:MoveToIndex(idx)
    self.loopView:MovePanelToItemByIndex(idx)
end

function PetMatsGridView:GetShowDataLength()
    return self.controller:GetShowDataLength()
end

function PetMatsGridView:GetItemByRowColumn(gridView, itemIndex, row, column)
    local length = self.controller:GetShowDataLength()
    if (itemIndex < 0 or itemIndex >= length) then
        return nil
    end
    local showData = self.controller:GetShowData(itemIndex)
    local item = nil
    if showData then
        item = gridView:NewListViewItem(self.itemName)
        item.gameObject.name = itemIndex
        local itemlua = CommonUtil.BindGridViewItem2Lua(self.root, self.itemName, item.gameObject)
        CommonUtil.UpdateItemPrefab(self.root, itemlua, showData, self.enterType, self.root, self.root.OnItemClick, itemIndex)
    else
        item = gridView:NewListViewItem('IconEmptyItem')
    end
    return item
end

function PetMatsGridView:GetShowItemByIdx(idx)
    local item = self.loopView:GetShownItemByItemIndex(idx - 1)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.root, self.itemName, item.gameObject)
        return itemlua
    end
end

function PetMatsGridView:OnHide()
    --if self.delayTimer then
    --    self.delayTimer:Stop()
    --end
    --self.delayTimer = nil

    --local loopGridView = self.loopView
    --if loopGridView and self.defaultRectOffset then
    --    loopGridView:SetPadding(self.defaultRectOffset)
    --end
    --self.defaultRectOffset = nil
end

function PetMatsGridView:OnDispose()
    self:OnHide()
    self.loopView:Dispose()

    self.controller:Dispose()
    self.controller = nil

    self.enterType = nil
    self.root = nil
    self.loopView = nil
    --self.startCB = nil
end

return PetMatsGridView