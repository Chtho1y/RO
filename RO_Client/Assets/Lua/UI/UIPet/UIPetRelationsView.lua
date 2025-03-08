local UIPetRelationsView = require("UIPet/UIPetRelationsView_Generate")

local initHeight = 300
local curSelectedIdx
function UIPetRelationsView:OnAwake(data)
	self.controller = require("UIPet/UIPetRelationsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetRelationsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_FRIEND_SUPPORT_OPEN_NTF, self, self.OpenFriendSupport)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_RELATION_CHANGE_NTF, self, self.OnPetRelationNeedChangeNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_RELATION_CHANGE_SUCCESS_NTF, self, self.OnPetRelationChangeSuccessNtf)
end

function UIPetRelationsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetRelationsView:Init()
	self:InitGrid()
	-- self:Refresh()
end

function UIPetRelationsView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	if not self.timer then
		self.timer = FrameTimer.New(slot(self.Refresh, self), 1)
	end
	if not self.timer.running then
		self.timer:Start()
	end
end

function UIPetRelationsView:InitGrid()
	initHeight = self.petRelationItem.rectTransform.sizeDelta.y
	self.scrollView.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIPetRelationsView:Refresh(resetPos)
	self.controller:RefreshRelationDatas()
	self.controller:RefreshAllAttrs()

	local loopListView = self.scrollView.loopListView
	local length = self.controller:GetRelationDataLength()
	if resetPos then
		loopListView:SetListItemCount(length, 0)
	else
		loopListView:SetListItemCount(length)
	end
	loopListView:RefreshAllShownItem()

	-- if not self.delayTimer then
	-- 	self.delayTimer = FrameTimer.New(slot(self.RefreshAllRPShow, self), 1)
	-- end
	-- if not self.delayTimer.running then
	-- 	self.delayTimer:Start()
	-- end
end

function UIPetRelationsView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetRelationDataLength()
	if (itemIndex < 0 or itemIndex >= length) then
		return nil
	end
	
	local showData = self.controller:GetRelationShowDataByIdx(itemIndex)
	local item = gridView:NewListViewItem("PetRelationItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "PetRelationItem", item.gameObject)

	itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, initHeight);

	itemlua.grid:SetActive(curSelectedIdx == itemIndex)
	itemlua.down:SetActive(curSelectedIdx ~= itemIndex)
	itemlua.up:SetActive(curSelectedIdx == itemIndex)

	local count = CommonUtil.UpdateItemPrefab(self, itemlua, showData, nil, self, self.OnPetItemClick, curSelectedIdx == itemIndex)

	self.uiBase:AddButtonUniqueEventListener(itemlua.btnexpand.button, self, self.OnRelationClick, itemIndex)

	if curSelectedIdx == itemIndex then
        local girdHeight = count * itemlua.relationAttr1.rectTransform.sizeDelta.y + 80
        itemlua.grid.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, girdHeight);

		local newY = girdHeight + itemlua.rectTransform.sizeDelta.y
		itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, newY);
	end

	if not self.relationPars then
		self.relationPars = {}
	end
	for i = 1, 3 do
		local goId = itemlua['relationAttr'..i].gameObject:GetInstanceID()
		if not self.relationPars[goId] then
			self.relationPars[goId] = itemlua['relationAttr'..i].uIEffectCfg
		end
	end

	self:RefreshRelationRPStateByCfgId(itemlua, showData.Id)

	return item
end

function UIPetRelationsView:RefreshAllRPShow()
	local relationCfgs = self.controller:RefreshRelationDatas()
	for i = 1, #relationCfgs do
		local cfgId = relationCfgs[i].Id
		local itemlua = self:GetRelationItemByIdx(i)
		LogHRWarning("RefreshAllRPShow   "..i)
		self:RefreshRelationRPStateByCfgId(itemlua, cfgId)
	end
end

function UIPetRelationsView:RefreshRelationRPStateByCfgId(itemlua, cfgId)
	local relationRPStates = self.controller:GetRelationRPStates()
	if not relationRPStates then
		return
	end
	if itemlua then
		local rpState = relationRPStates[cfgId]
		if rpState then
			for i = 1, 3 do
				local parent = itemlua['item'..i].transform
				local redPoint = parent:Find("redPoint")
				if redPoint then
					redPoint.gameObject:SetActive(rpState[i])
				else
					if rpState[i] then
						local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, "Common/UIRedPointRP")
						if go then
							redPoint = go.transform
							redPoint:SetParent(parent)
							redPoint.localRotation = Quaternion.identity
							redPoint.localScale = Vector3.one
							local rectTransform = redPoint:GetComponent(Enum.TypeInfo.RectTransform)
							rectTransform.anchoredPosition3D = Vector3(60, 60, 0)

							go.name = "redPoint"
						end
					end
				end
			end
		else
			for i = 1, 3 do
				local parent = itemlua['item'..i].transform
				local redPoint = parent:Find("redPoint")
				if redPoint then
					redPoint.gameObject:SetActive(false)
				end
			end
		end
	end
end

function UIPetRelationsView:OnPetItemClick(button, params)
	local data = params[2]
	local cfgId = data[1]
	self.selectedIdx = data[2]
	--
	--local data = {relationCfgId = cfgId, relationIdx = idx, fromUIId = self.uiData.id}
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetMats, data)
	ManagerContainer.DataMgr.PetDataMgr:QueryAssistList(cfgId)
end

function UIPetRelationsView:OnRelationClick(button, params)
	local idx = params[0]
	local loopListView =self.scrollView.loopListView
	if curSelectedIdx == idx then
		curSelectedIdx = nil
	else
		local oldIdx = curSelectedIdx
		curSelectedIdx = idx
		if oldIdx then
			loopListView:RefreshItemByItemIndex(oldIdx)
		end
	end
	loopListView:RefreshItemByItemIndex(idx)

	local length = self.controller:GetRelationDataLength()
	if curSelectedIdx and curSelectedIdx + 1 == length then
		self.scrollView.loopListView:MovePanelToItemIndex(curSelectedIdx, 0)
	end
end

function UIPetRelationsView:GetRelationItemByIdx(idx)
	local item = self.scrollView.loopListView:GetShownItemByItemIndex(idx - 1)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "PetRelationItem", item.gameObject)
        return itemlua
    end
end

function UIPetRelationsView:OpenFriendSupport(cfgId)
	local data = {relationCfgId = cfgId, curRelationIdx = self.selectedIdx, fromUIId = self.uiData.id, enterType = Enum.ItemIEnterType.PetRelation}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetMats, data)
end

function UIPetRelationsView:OnPetRelationNeedChangeNtf(data)
	local relationCfgId = data.relationCfgId
	local petData = data.petData

	self.controller:SetRelationDataByRelationIdAndSlotIdx(relationCfgId, self.selectedIdx, petData)
	self.selectedIdx = nil
end

function UIPetRelationsView:OnPetRelationChangeSuccessNtf()
	--self.scrollView.loopListView:RefreshItemByItemIndex(cfgId - 1)
	self.controller:RefreshAllAttrs()
	self:Refresh()
end

function UIPetRelationsView:OnClickAllAttrBtn()
	local datas = self.controller:GetAllAttrs()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionTotal, {title="PetTotalProperty", attrs=datas})
end

function UIPetRelationsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)


end

function UIPetRelationsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnRelation.button, self, self.OnMySupportClick)
	self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.btnRelations.button, self, self.OnClickAllAttrBtn)
end

function UIPetRelationsView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "PetText003"})
end

function UIPetRelationsView:OnCloseClick()
	self:UIClose()
end

function UIPetRelationsView:OnMySupportClick()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPetMySupport)
end

function UIPetRelationsView:OnHide()

end

function UIPetRelationsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetRelationsView:OnClose()
	if self.relationPars then
		for i = 1, #self.relationPars do
			local effect = self.relationPars[i]
			effect:Clean()
		end
	end
	self.relationPars = nil
	
	if self.timer then
		self.timer:Stop()
		self.timer = nil
	end
	if self.delayTimer then
		self.delayTimer:Stop()
		self.delayTimer = nil
	end
end

function UIPetRelationsView:OnDispose()
	self.scrollView.loopListView:Dispose()
	self.controller:OnDispose()
end

return UIPetRelationsView

