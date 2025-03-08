local UICollectView = require("UICollect/UICollectView_Generate")
local CardBook = require("UICollect/CardBook")
local PetBook = require("UICollect/PetBook")
local KeepSakeBook = require("UICollect/KeepSakeBook")

function UICollectView:OnAwake(data)
	self.controller = require("UICollect/UICollectCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICollectView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.KEEPSAKE_LEVEL_UP_SUCCESS_NTF, function()
		if self.keepSakeBookLua then
			self.numexchage.text.text = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.KeepSakeExchange)
			self.keepSakeBookLua:OnValueChangedToggle()
		end
	end)
end

function UICollectView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICollectView:Init()
	self:RefreshPetEnterLock()
	self:RefreshCollectionEnterLock()
	self:InitSubGo()
end

function UICollectView:RefreshPetEnterLock()
	local unLockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(56, true)
	self.lockPet:SetActive(not unLockState)
	if not unLockState then
		self.lockPet.text.uILocalizeScript:SetContent(content)
	end
end

function UICollectView:RefreshCollectionEnterLock()
	local unLockState, val, content = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(65, true)
	self.lockCollection:SetActive(not unLockState)
	if not unLockState then
		self.lockCollection.text.uILocalizeScript:SetContent(content)
	end
end

function UICollectView:InitSubGo()
	if not self.cardBookLua then
		self.cardBookLua = CardBook:new()
		local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, "UICollect/BookItem")
		local trans = go.transform
		trans:SetParent(self.bookAnim.transform)
		trans:GetComponent(Enum.TypeInfo.RectTransform).anchoredPosition3D = Vector3.zero
		trans.localRotation = Quaternion.identity
		trans.localScale = Vector3.one
		trans:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta = Vector2.one
		trans.name = "CardBook"

		self.cardBookLua:InitGo(self, go)
		if self.cardBookLua then
			self.cardBookLua:AddEventListener()
			self.cardBookLua:AddUIEventListener()
		end
	end

	if not self.petBookLua then
		self.petBookLua = PetBook:new()
		local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, "UICollect/BookItem")
		local trans = go.transform
		trans:SetParent(self.bookAnim.transform)
		trans:GetComponent(Enum.TypeInfo.RectTransform).anchoredPosition3D = Vector3.zero
		trans.localRotation = Quaternion.identity
		trans.localScale = Vector3.one
		trans:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta = Vector2.one
		trans.name = "PetBook"

		self.petBookLua:InitGo(self, go)
		if self.petBookLua then
			self.petBookLua:AddEventListener()
			self.petBookLua:AddUIEventListener()
		end
	end

	if not self.keepSakeBookLua then
		self.keepSakeBookLua = KeepSakeBook:new()
		local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, "UICollect/BookItem")
		local trans = go.transform
		trans:SetParent(self.bookAnim.transform)
		trans:GetComponent(Enum.TypeInfo.RectTransform).anchoredPosition3D = Vector3.zero
		trans.localRotation = Quaternion.identity
		trans.localScale = Vector3.one
		trans:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta = Vector2.one
		trans.name = "keepSakeBook"

		self.keepSakeBookLua:InitGo(self, go)
		if self.keepSakeBookLua then
			self.keepSakeBookLua:AddEventListener()
			self.keepSakeBookLua:AddUIEventListener()
		end
	end
end

function UICollectView:OnValueChangedToggle()
	self.myExchangeCards:SetActive(self.type == Enum.CollectType.KeepSake)
	if self.type == Enum.CollectType.Card then
		if self.cardBookLua and self.cardBookLua.OnValueChangedToggle then
			self.cardBookLua:OnValueChangedToggle()
		end
	elseif self.type == Enum.CollectType.Pet then
		if self.petBookLua and self.petBookLua.OnValueChangedToggle then
			self.petBookLua:OnValueChangedToggle()
		end
	elseif self.type == Enum.CollectType.KeepSake then
		self.numexchage.text.text = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.KeepSakeExchange)
		if self.keepSakeBookLua and self.keepSakeBookLua.OnValueChangedToggle then
			self.keepSakeBookLua:OnValueChangedToggle()
		end
	end
end

function UICollectView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	if self.cardBookLua then
		self.cardBookLua:RemoveEventListener()
	end
	if self.petBookLua then
		self.petBookLua:RemoveEventListener()
	end
	if self.keepSakeBookLua then
		self.keepSakeBookLua:RemoveEventListener()
	end
end

function UICollectView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnCardBook.button, self, self.OnBtnCardBookClick)
	self.uiBase:AddButtonEventListener(self.btnPetBook.button, self, self.OnBtnPetBookClick)
	self.uiBase:AddButtonEventListener(self.btnCollectionBook.button, self, self.OnBtnKeepSakeBookClick)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)
end

function UICollectView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'CollectPlayExplain'})
end

function UICollectView:OnBtnCardBookClick(button, params)
	self.type = Enum.CollectType.Card
	self.window.animator:Play("Book")

	self.cardBookLua:Show()
	self.petBookLua:Hide()
	self.keepSakeBookLua:Hide()

	if self.cardBookLua and self.cardBookLua.SelectToggle then
		self.cardBookLua:SelectToggle()
	end
end

function UICollectView:OnBtnPetBookClick(button, params)
	self.type = Enum.CollectType.Pet
	self.window.animator:Play("Book")

	self.cardBookLua:Hide()
	self.petBookLua:Show()
	self.keepSakeBookLua:Hide()

	if self.petBookLua and self.petBookLua.SelectToggle then
		self.petBookLua:SelectToggle()
	end
end

function UICollectView:OnBtnKeepSakeBookClick(button, params)
	self.type = Enum.CollectType.KeepSake
	self.window.animator:Play("Book")

	self.cardBookLua:Hide()
	self.petBookLua:Hide()
	self.keepSakeBookLua:Show()

	if self.keepSakeBookLua and self.keepSakeBookLua.SelectToggle then
		self.keepSakeBookLua:SelectToggle()
	end
end

function UICollectView:BookBack()
	self.type = nil
	self.window.animator:Play("List")
	CommonUtil.CloseUIClearAsyncSeqIds(self)
end

function UICollectView:OnCloseClick()
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UICollectView:OnHide()

end

function UICollectView:OnShow(data)
	self.controller:SetData(data)

end

function UICollectView:OnClose()
end

function UICollectView:OnDispose()
	if self.cardBookLua then
		local go = self.cardBookLua.viewLua.gameObject
		self.cardBookLua:Dispose()
		self.cardBookLua = nil
		ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, "UICollect/BookItem", go)
	end
	if self.petBookLua then
		local go = self.petBookLua.viewLua.gameObject
		self.petBookLua:Dispose()
		self.petBookLua = nil
		ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, "UICollect/BookItem", go)
	end
	if self.keepSakeBookLua then
		local go = self.keepSakeBookLua.viewLua.gameObject
		self.keepSakeBookLua:Dispose()
		self.keepSakeBookLua = nil
		ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, "UICollect/BookItem", go)
	end
	self.controller:OnDispose()
end

return UICollectView

