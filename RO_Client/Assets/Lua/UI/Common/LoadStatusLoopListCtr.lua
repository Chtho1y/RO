local LoadStatusLoopListCtr = class('LoadStatusLoopListCtr')


function LoadStatusLoopListCtr:ctor(owner, loopListView, defaultDataLength, maxDataLength,
                                    hasBegin, beginPrefabName, beginLoadStatus,
                                    hasEnd, endPrefabName, endLoadStatus,
                                    getItemByIndexCB, updateLoadItemCB, beginLoadCB, cbOwner)
    self.owner = owner
    self.loopListView = loopListView
    self.listNum = defaultDataLength
    self.listMaxNum = maxDataLength
    self.curLoadStatus1 = beginLoadStatus or Enum.ListLoadingStatus.None
    self.curLoadStatus2 = endLoadStatus or Enum.ListLoadingStatus.None
    self.hasBegin = hasBegin
    self.beginPrefabName = beginPrefabName
    self.hasEnd = hasEnd
    self.endPrefabName = endPrefabName
    self.getItemByIndexCB = getItemByIndexCB
    self.updateLoadItemCB = updateLoadItemCB
    self.beginLoadCB = beginLoadCB
    self.cbOwner = cbOwner

    if hasBegin then self.listNum = self.listNum + 1 end
    if hasEnd then self.listNum = self.listNum + 1 end

    loopListView:InitListView(self.listNum, function(loopListView, idx)
		return self:GetItemByIndex(loopListView, idx)
    end)

    if hasBegin or hasEnd then
        loopListView.mOnDragingAction = function()
            self:OnDraging()
        end
        loopListView.mOnEndDragAction = function()
            self:OnEndDrag()
        end
    end
end

function LoadStatusLoopListCtr:Dispose()
    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
    self.loopListView.mOnDragingAction = nil
	self.loopListView.mOnEndDragAction = nil
    self.loopListView:Dispose()
    self.owner = nil
    self.loopListView = nil
    self.listNum = nil
    self.listMaxNum = nil
    self.curLoadStatus1 = nil
    self.curLoadStatus2 = nil
    self.hasBegin = nil
    self.beginPrefabName = nil
    self.hasEnd = nil
    self.endPrefabName = nil
    self.getItemByIndexCB = nil
    self.updateLoadItemCB = nil
    self.beginLoadCB = nil
end

function LoadStatusLoopListCtr:OnAllLoaded()
    self:OnLoaded1()
    self:OnLoaded2()
end

function LoadStatusLoopListCtr:RefreshDataLength(length, resetPos)
    self.listNum = length
    if self.hasBegin then self.listNum = self.listNum + 1 end
    if self.hasEnd then self.listNum = self.listNum + 1 end
    self.loopListView:SetListItemCount(self.listNum, resetPos or false)
    self.loopListView:RefreshAllShownItem()
end

function LoadStatusLoopListCtr:RefreshMaxDataLength(length)
    self.listMaxNum = length
    if self.hasBegin then self.listMaxNum = self.listMaxNum + 1 end
    if self.hasEnd then self.listMaxNum = self.listMaxNum + 1 end
end

function LoadStatusLoopListCtr:OnLoaded1()
    if not self.hasBegin then return end
    if self.curLoadStatus1 == Enum.ListLoadingStatus.WaitLoad then
        self.curLoadStatus1 = Enum.ListLoadingStatus.Loaded
        if self.delayTimer then
            self.delayTimer.time = self.delayTimer.duration
        else
            self.delayTimer = Timer.New(function()
                self:OnLoaded1Complete()
            end, 1, 1)
        end
        if not self.delayTimer.running then
            self.delayTimer:Start()
        end
        local item = self.loopListView:GetShownItemByItemIndex(0)
        if not item then return end
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.owner, self.beginPrefabName, item.gameObject)
        if not itemlua then return end
        self:UpdateLoadingItem1(itemlua)
    end
end

function LoadStatusLoopListCtr:OnLoaded1Complete()
    if self.curLoadStatus1 == Enum.ListLoadingStatus.Loaded then
        self.curLoadStatus1 = Enum.ListLoadingStatus.None
        local item = self.loopListView:GetShownItemByItemIndex(0)
        if not item then return end
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.owner, self.beginPrefabName, item.gameObject)
        if not itemlua then return end
        self:UpdateLoadingItem1(itemlua)
        itemlua.rectTransform.anchoredPosition3D = Vector3(0, -itemlua.layoutElement.preferredHeight, 0)
        self.loopListView:OnItemSizeChanged(0)
    end
end

function LoadStatusLoopListCtr:OnLoaded2()
    if not self.hasEnd then return end
    if self.curLoadStatus2 == Enum.ListLoadingStatus.WaitLoad then
        self.curLoadStatus2 = Enum.ListLoadingStatus.None
    end
end

function LoadStatusLoopListCtr:SetHasBegin(status)
    self.hasBegin = status
end

function LoadStatusLoopListCtr:SetHasEnd(status)
    self.hasEnd = status
end



function LoadStatusLoopListCtr:GetItemByIndex(loopListView, idx)
    if idx < 0 then return nil end
    if self.hasBegin then
        if idx == 0 then
            local item = loopListView:NewListViewItem(self.beginPrefabName)
            local itemlua = CommonUtil.BindGridViewItem2Lua(self.owner, self.beginPrefabName, item.gameObject)
            self:UpdateLoadingItem1(itemlua)
            return item
        end
    end
    if self.hasEnd then
        if idx == self.listNum - 1 then
            local item = loopListView:NewListViewItem(self.endPrefabName)
            local itemlua = CommonUtil.BindGridViewItem2Lua(self.owner, self.endPrefabName, item.gameObject)
            self:UpdateLoadingItem2(itemlua)
            return item
        end
    end
    if self.getItemByIndexCB then
        return self.getItemByIndexCB(self.cbOwner or self.owner, loopListView, idx, (self.hasBegin and (idx - 1) or idx))
    end
	return nil
end

function LoadStatusLoopListCtr:OnDraging()
    if self.hasBegin then
        self:OnDraging1()
    end
    if self.hasEnd then
        if self.listNum < self.listMaxNum then
            self:OnDraging2()
        end
    end
end

function LoadStatusLoopListCtr:OnEndDrag()
    if self.hasBegin then
        self:OnEndDrag1()
    end
    if self.hasEnd then
        if self.listNum < self.listMaxNum then
            self:OnEndDrag2()
        end
    end
end


function LoadStatusLoopListCtr:OnDraging1()
    if self.loopListView.ShownItemCount == 0 then return end
	if self.curLoadStatus1 ~= Enum.ListLoadingStatus.None
		and self.curLoadStatus1 ~= Enum.ListLoadingStatus.WaitRelease then
			return
	end
	local item = self.loopListView:GetShownItemByItemIndex(0)
    if not item then return end
    local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.owner, self.beginPrefabName, item.gameObject)
    if not itemlua then return end
	local sr = self.loopListView.ScrollRect
    local pos = sr.content.anchoredPosition3D
    local height = itemlua.layoutElement.preferredHeight
    if pos.y < -height then
        if self.curLoadStatus1 ~= Enum.ListLoadingStatus.None then
            return
        end
        self.curLoadStatus1 = Enum.ListLoadingStatus.WaitRelease
        self:UpdateLoadingItem1(itemlua)
        itemlua.rectTransform.anchoredPosition3D = Vector3(0, height, 0)
    else
        if self.curLoadStatus1 ~= Enum.ListLoadingStatus.WaitRelease then
            return
        end
        self.curLoadStatus1 = Enum.ListLoadingStatus.None
        self:UpdateLoadingItem1(itemlua)
        itemlua.rectTransform.anchoredPosition3D = Vector3.zero
    end
end

function LoadStatusLoopListCtr:OnDraging2()
    if self.loopListView.ShownItemCount == 0 then return end
	if self.curLoadStatus2 ~= Enum.ListLoadingStatus.None
		and self.curLoadStatus2 ~= Enum.ListLoadingStatus.WaitRelease then
			return
	end
    local item = self.loopListView:GetShownItemByItemIndex(self.listNum - 1)
    if not item then return end
    local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.owner, self.endPrefabName, item.gameObject)
    if not itemlua then return end
    local item1 = self.loopListView:GetShownItemByItemIndex(self.listNum - 2)
    if not item1 then return end
    local min = item1.CachedRectTransform.rect.min
    local pos = item1.CachedRectTransform:TransformPoint(min)
    pos = self.loopListView.ScrollRect.viewport:InverseTransformPoint(pos)
    local height = itemlua.layoutElement.preferredHeight
	if pos.y + self.loopListView.ViewPortSize >= height then
        if self.curLoadStatus2 == Enum.ListLoadingStatus.None then
            self.curLoadStatus2 = Enum.ListLoadingStatus.WaitRelease
            self:UpdateLoadingItem2(itemlua)
        end
    else
        if self.curLoadStatus2 == Enum.ListLoadingStatus.WaitRelease then
            self.curLoadStatus2 = Enum.ListLoadingStatus.None
            self:UpdateLoadingItem2(itemlua)
        end
    end
end

function LoadStatusLoopListCtr:OnEndDrag1()
    if self.loopListView.ShownItemCount == 0 then return end
    if self.curLoadStatus1 ~= Enum.ListLoadingStatus.None
        and self.curLoadStatus1 ~= Enum.ListLoadingStatus.WaitRelease then
        return
    end
    local item = self.loopListView:GetShownItemByItemIndex(0)
    if not item then return end
    self.loopListView:OnItemSizeChanged(item.ItemIndex)
    if self.curLoadStatus1 ~= Enum.ListLoadingStatus.WaitRelease then
        return
    end
    self.curLoadStatus1 = Enum.ListLoadingStatus.WaitLoad
    local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.owner, self.beginPrefabName, item.gameObject)
    if not itemlua then return end
    self:UpdateLoadingItem1(itemlua)
    if self.beginLoadCB then
        self.beginLoadCB(self.cbOwner or self.owner, true)
    end
end

function LoadStatusLoopListCtr:OnEndDrag2()
    if self.loopListView.ShownItemCount == 0 then return end
    if self.curLoadStatus2 ~= Enum.ListLoadingStatus.None and self.curLoadStatus2 ~= Enum.ListLoadingStatus.WaitRelease then
        return
    end
    local item = self.loopListView:GetShownItemByItemIndex(self.listNum - 1)
    if not item then return end
    self.loopListView:OnItemSizeChanged(item.ItemIndex)
    if self.curLoadStatus2 ~= Enum.ListLoadingStatus.WaitRelease then
        return
    end
    self.curLoadStatus2 = Enum.ListLoadingStatus.WaitLoad
    local itemlua = CommonUtil.GetBindGridViewItem2Lua(self.owner, self.endPrefabName, item.gameObject)
    if not itemlua then return end
    self:UpdateLoadingItem2(itemlua)
    if self.beginLoadCB then
        self.beginLoadCB(self.cbOwner or self.owner, false)
    end
end

function LoadStatusLoopListCtr:UpdateLoadingItem1(itemlua)
    if self.updateLoadItemCB then
        self.updateLoadItemCB(self.owner, itemlua, self.curLoadStatus1, true)
        return
    end
    if self.curLoadStatus1 == Enum.ListLoadingStatus.None then
        itemlua.root:SetActive(false)
        itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, 0)
    elseif self.curLoadStatus1 == Enum.ListLoadingStatus.WaitContinureDrag then
		itemlua.root:SetActive(true)
		itemlua.wait:SetActive(false)
		itemlua.desTxt.text.text = string.formatbykey('GuildTips_039')
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, itemlua.layoutElement.preferredHeight)
	elseif self.curLoadStatus1 == Enum.ListLoadingStatus.WaitRelease then
		itemlua.root:SetActive(true)
		itemlua.wait:SetActive(false)
		itemlua.desTxt.text.text = string.formatbykey('GuildTips_039')
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, itemlua.layoutElement.preferredHeight)
	elseif self.curLoadStatus1 == Enum.ListLoadingStatus.WaitLoad then
		itemlua.root:SetActive(true)
		itemlua.wait:SetActive(true)
		itemlua.desTxt.text.text = string.formatbykey('GuildTips_038')
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, itemlua.layoutElement.preferredHeight)
	elseif self.curLoadStatus1 == Enum.ListLoadingStatus.Loaded then
		itemlua.root:SetActive(true)
		itemlua.wait:SetActive(false)
		itemlua.desTxt.text.text = string.formatbykey('GuildTips_042')
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, itemlua.layoutElement.preferredHeight)
	end
end

function LoadStatusLoopListCtr:UpdateLoadingItem2(itemlua)
    if self.updateLoadItemCB then
        self.updateLoadItemCB(self.owner, itemlua, self.curLoadStatus2, false)
        return
    end
    if self.curLoadStatus2 == Enum.ListLoadingStatus.None then
        itemlua.root:SetActive(false)
        itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, 0)
	elseif self.curLoadStatus2 == Enum.ListLoadingStatus.WaitRelease then
		itemlua.root:SetActive(true)
		itemlua.wait:SetActive(false)
		itemlua.desTxt.text.text = string.formatbykey('GuildTips_041')
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, itemlua.layoutElement.preferredHeight)
	elseif self.curLoadStatus2 == Enum.ListLoadingStatus.WaitLoad then
		itemlua.root:SetActive(true)
		itemlua.wait:SetActive(true)
		itemlua.desTxt.text.text = string.formatbykey('GuildTips_038')
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, itemlua.layoutElement.preferredHeight)
	end
end

return LoadStatusLoopListCtr