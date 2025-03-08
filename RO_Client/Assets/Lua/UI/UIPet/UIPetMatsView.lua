local UIPetMatsView = require("UIPet/UIPetMatsView_Generate")
local PetMatsGridView = require("UIPet/PetMatsGridView")

local petMatsGridView
function UIPetMatsView:OnAwake(data)
	self.controller = require("UIPet/UIPetMatsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetMatsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_PAGE_IN_END_NTF, self, self.OnUIPageInEndNtf)
end

function UIPetMatsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetMatsView:Init()
	local fromUIId = self.controller:GetFromUIId()
	if fromUIId == Enum.UIPageName.UIPetLvUp then
		self.textTitle.uILocalizeScript:SetContent("TitleChooseMet")
		self.mats.text.uILocalizeScript:SetContent("DscChooseSillUpMet")
	elseif fromUIId == Enum.UIPageName.UIPetRelations then
		self.textTitle.uILocalizeScript:SetContent("TitlePetRelations")
		self.mats.text.uILocalizeScript:SetContent("DscPetChooseSupport")
	elseif fromUIId == Enum.UIPageName.UIPetMySupport then
		self.textTitle.uILocalizeScript:SetContent("TitleChooseSupport")
		self.mats.text.uILocalizeScript:SetContent("DscChooseSupport")
	end

end

function UIPetMatsView:OnUIPageInEndNtf()
	if not petMatsGridView then
		petMatsGridView = PetMatsGridView:new()
		petMatsGridView:Init(self.controller:GetEnterType(), self, self.mats.loopGridView)
	end

	self:Refresh()
end

function UIPetMatsView:Refresh(resetPos)
	if petMatsGridView then
		petMatsGridView:Refresh(resetPos)
	end

	local selectedData, idx = self.controller:GetCurSelectedIdx()
	if selectedData then
		self.lastSelectedData = selectedData
		self.lastSelectedItemlua = petMatsGridView:GetShowItemByIdx(idx)
	end
end

function UIPetMatsView:OnItemClick(button, params)
	local data = params[0]
	local fromUIId = self.controller:GetFromUIId()
	if fromUIId == Enum.UIPageName.UIPetLvUp then
		if data.isBattle then
			return
		end
	elseif fromUIId == Enum.UIPageName.UIPetRelations then
		if not data.canUse then
			return
		end
	elseif fromUIId == Enum.UIPageName.UIPetMySupport then
		if data.isUsed then
			return
		end
	end

	self.selectedIdx = data.idx
	self.curSelectedData = data
	if not self.lastSelectedData or self.lastSelectedData ~= self.curSelectedData then
		if data and data.isRelevant and fromUIId == Enum.UIPageName.UIPetLvUp then
			local data = {"PetCostNotify8", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end

		if data and (data.level > 1 or self.controller:WasSkillUp(data)) and self.controller:GetEnterType() == Enum.ItemIEnterType.PetMats then
			local data = {"PetCostNotify4", nil, nil, self, self.PetClickSure}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			return
		end
	end
	self:PetClickSure()
end

function UIPetMatsView:PetClickSure()
	if self.selectedIdx then
		local sameItem = false
		if self.curSelectedData and self.lastSelectedData and self.curSelectedData.idx == self.lastSelectedData.idx then
			sameItem = true
			self.controller:SetSelectedData(nil)
			self.curSelectedData.selected = 0
		else
			self.controller:SetSelectedData(self.selectedIdx)
			self.curSelectedData.selected = 1

			if self.lastSelectedData then
				self.lastSelectedData.selected = 0
				if petMatsGridView then
					local luaitem = petMatsGridView:GetShowItemByIdx(self.lastSelectedData.idx)
					if luaitem then
						luaitem.selected:SetActive(false)
					end
				end
			end
		end
		if petMatsGridView then
			local luaitem = petMatsGridView:GetShowItemByIdx(self.selectedIdx)
			if luaitem then
				luaitem.selected:SetActive(self.curSelectedData.selected > 0)
			end
		end
		self.lastSelectedData = (sameItem and {nil} or {self.curSelectedData})[1]
		self.selectedIdx = nil
	end
end

function UIPetMatsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetMatsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnCancel.button, self, self.OnCancelClick)
	self.uiBase:AddButtonEventListener(self.btnSure.button, self, self.OnSureClick)
end

function UIPetMatsView:OnCloseClick()
	self:UIClose()
end

function UIPetMatsView:OnCancelClick()
	self.controller:SetSelectedData(nil)
	self:OnCloseClick()
end

function UIPetMatsView:OnSureClick()
	self:OnCloseClick()
	local fromUIId = self.controller:GetFromUIId()
	if fromUIId == Enum.UIPageName.UIPetLvUp then
		local id = self.controller:GetCurSelectedIdByIdx()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_SKILLUP_REFRESH_NTF, id)
	elseif fromUIId == Enum.UIPageName.UIPetRelations then
		local relationCfgId = self.controller:GetRelationCfgId()
		local data = self.controller:GetCurSelectedDataByIdx()
		if not relationCfgId or not data then
			return
		end
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_RELATION_CHANGE_NTF, {relationCfgId = relationCfgId, petData = data})
	elseif fromUIId == Enum.UIPageName.UIPetMySupport then
		local id = self.controller:GetCurSelectedIdByIdx()
		local idx = self.controller:GetSupportIdx()
		if not id or not idx then
			return
		end
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PET_MY_SUPPORT_CHANGE_NTF, {id, idx})
	end
end

function UIPetMatsView:OnHide()
	if petMatsGridView then
		petMatsGridView:OnHide()
	end
end

function UIPetMatsView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetMatsView:OnClose()
end

function UIPetMatsView:OnDispose()
	if petMatsGridView then
		petMatsGridView:OnDispose()
		petMatsGridView = nil
	end
	self.lastSelectedItemlua = nil
	self.lastSelectedData = nil
	self.selectedIdx = nil
	self.curSelectedData = nil
	self.curSelectedItemlua = nil

	self.controller:OnDispose()
end

return UIPetMatsView

