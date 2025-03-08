local UIPetBattleView = require("UIPet/UIPetBattleView_Generate")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")
local PetMatsGridView = require("UIPet/PetMatsGridView")
local RoleListItemCtr = require("Common/RoleListItemCtr")
local IconPetItemCtr = require("Common/IconPetItemCtr")

local petMatsGridView
local portraitPath = "UIDojo/Portrait"

local OpsEnum =
{
	UpBattle = 1,
	Replace = 2,
	OnekeyDown = 3,
}
local lastOps = OpsEnum.UpBattle

local deltaVec = Vector2.zero
local curPos = Vector2.zero

local lockIds = {42,43,44,45,46,47}

local updateBeat
local isDragging = false

local tmpPos = Vector3.zero
local pos = Vector2.zero
local edgeX = Vector2.zero
local edgeY = Vector2.zero

function UIPetBattleView:OnAwake(data)
	self.controller = require("UIPet/UIPetBattleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPetBattleView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.PET_BATTLE_SUCCESS_NTF, self, self.OnBattleNtf)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FILTER_NTF, self, self.RefreshDatasByFilter)
end

function UIPetBattleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPetBattleView:Init()
	self.mask:SetActive(false)

	self.controller:RefreshCurPetBattleLock()

	if not updateBeat then
		updateBeat = UpdateBeat:CreateListener(self.Update, self)
	end
	local sizeDelta = self.slotList.slot1.rectTransform.sizeDelta
	edgeX.x = sizeDelta.x/2 - UIMgr.SCREEN_WIDTH/2
	edgeX.y = UIMgr.SCREEN_WIDTH/2 -sizeDelta.x/2
	edgeY.x = sizeDelta.y/2 - UIMgr.SCREEN_HEIGHT/2
	edgeY.y = UIMgr.SCREEN_HEIGHT/2 - sizeDelta.y/2

	UpdateBeat:AddListener(updateBeat)

	lastOps = OpsEnum.UpBattle

	deltaVec.x = self.slotList.slot1.rectTransform.sizeDelta.x/2
	self.showState = false
	self.heroLuaItems = {}
	self.petLuaItems = {}

	if not petMatsGridView then
		petMatsGridView = PetMatsGridView:new()
		petMatsGridView:Init(Enum.ItemIEnterType.Pet, self, self.scrollview.loopGridView)
	end

	self.loadSystem = MultiTypeAssetLoadSystem:new()
	self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)

	self.slotEmpty:SetActive(false)
	for i = 1, 6 do
		self.slotBattle["slot"..i]:SetActive(false)
	end

	self:PetGridOver()
end

function UIPetBattleView:RefreshDatasByFilter(uiId, data, isFilter)
	if uiId ~= self.uiData.id then return end

	self.controller:SetFilterData(data, isFilter)
	self.controller:ClearSelectedInfo()
	self:Refresh(true)
	self.showState = false
	self:RefreshSlotBtns()
end

function UIPetBattleView:PetGridOver()
	self:Refresh()
	self:PreLoadRes()
end

function UIPetBattleView:PreLoadRes()
	self.loadSystem:RemoveLoadAllAsset()

	self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.UIPath, portraitPath)
	self.loadSystem:Begin()
end

function UIPetBattleView:PreloadedAssets()
	self:RefreshTop()
end

function UIPetBattleView:OnBattleNtf(result)
	self.controller:InitHeroBattleDatas()
	self:Refresh(true)
	self:InitBattlePets()

    self.showState = false
    self:RefreshSlotBtns()

	if result then
		local content = ""
		if lastOps == OpsEnum.UpBattle then
			content = "Petfight_003"
		elseif lastOps == OpsEnum.Replace then
			content = "Petfight_004"
		elseif lastOps == OpsEnum.OnekeyDown then
			content = "Petfight_005"
		end
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T(content))
	end

	if self.mastTimer then
		self.mastTimer:Stop()
		self.mastTimer = nil
	end
	self:MaskHide()
end

function UIPetBattleView:MaskHide()
	self.mask:SetActive(false)
end

function UIPetBattleView:RefreshTop()
	self:InitHerosInfo()
	self:InitBattlePets()

	self:InitSelectedPet()

	local curId = self.controller:GetCurSelectedId()
	self:RefreshSlotBtns(curId)
	--local unlockCount = self.controller:GetUnlockCount()
	--local petBattleCount = self.controller:GetBattlePetCount()
	--local remainEmptySlot = unlockCount - petBattleCount
	--if remainEmptySlot > 0 then
	--	for i = 1, 6 do
	--		self.slotTrigger["slot"..i.."_lock"]:SetActive(false)
	--	end
	--end

	self.slotEmpty:SetActive(true)
end

function UIPetBattleView:InitSelectedPet()
	local data, idx = self.controller:InitCurSelectedData()
	if not data then return end
	local offset = math.fmod(idx, 5) + 1
	petMatsGridView:MoveToIndex(idx - offset)
	local itemlua = petMatsGridView:GetShowItemByIdx(idx)
	self:OnItemClick1(data, itemlua)
end

function UIPetBattleView:InitHerosInfo()
	local battleHeroList = self.controller:GetList()
	for i = 1, 6 do
		local heroPerent = self["hero"..i].transform
		local hero
		if heroPerent.childCount >= 1 then
			hero = heroPerent:GetChild(0).gameObject
		else
			hero = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, portraitPath)
			if hero then
				hero.transform:SetParent(heroPerent)
				hero.transform.localPosition = Vector3.zero
				hero.transform.localRotation = Quaternion.identity
				hero.transform.localScale = Vector3.one
			end
		end
		if hero then
			self.heroLuaItems[i] = CommonUtil.BindGridViewItem2Lua(self, "Portrait", hero)
			local heroData = self.controller:GetHeroDataByUid(i)
			if heroData then
				local cfgData = CommonUtil.GetHeroCfgDataByUid(heroData.id)
				RoleListItemCtr:SetData(self, self.heroLuaItems[i].role, {i, heroData, cfgData})
				self.heroLuaItems[i].role.plus:SetActive(true)

				local quality = heroData.strengthLevel
				local frameIcon = quality == 0 and Constant.Quality_Role_PlusFrame_Defaut_Icons or Constant.Quality_Role_PlusFrame_Icons[quality]
				CommonUtil.LoadIcon(self, frameIcon, function (sprite)
					self.heroLuaItems[i].role.plusFrame.image.sprite = sprite
				end)

				if battleHeroList then
					self.heroLuaItems[i].role.labelUp:SetActive(i ~= 1 and CommonUtil.EleInTable(heroData.id, battleHeroList))
				end
			end
		end
	end
end

function UIPetBattleView:InitBattlePets()
	for i = 1, 6 do
		local petId = self.controller:GetPetBattlePetId(i)
		if petId and petId > 0 then
			self:AddBattlePet(i, petId)
		else
			self.slotTrigger["slot"..i].uIEventTriggerListener.onDrag = nil
			self.slotTrigger["slot"..i].uIEventTriggerListener.onDrag = nil
			self.slotTrigger["slot"..i].uIEventTriggerListener.onPointerUp = nil
			self.slotTrigger["slot"..i].uIEventTriggerListener.onClick = function()
				self:BattlePetClick(i)
			end
		end
	end
end

function UIPetBattleView:AddBattlePet(idx, petId)
	self.controller:SetPetBattlePetId(idx, petId)

	if self.petLuaItems[idx] then
		local parent = self.slotList["slot"..idx].transform
		local pet = self.petLuaItems[idx].gameObject
		pet.transform:SetParent(parent)
		pet.transform.localPosition = Vector3.zero
		pet.transform.localRotation = Quaternion.identity
		pet.transform.localScale = Vector3.one
		self.petLuaItems[idx].rectTransform.anchoredPosition = Vector2.zero

		local petData = self.controller:GetPetDataById(petId)
		if not petData then
			petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)
		end
		IconPetItemCtr:SetData(self, self.petLuaItems[idx], petData, Enum.ItemIEnterType.Pet)
	else
		ManagerContainer.GoPoolMgr:SpawnGo("IconPetItem", function (itemlua)
			local parent = self.slotList["slot"..idx].transform
			local pet = itemlua.gameObject
			pet.transform:SetParent(parent)
			pet.transform.localPosition = Vector3.zero
			pet.transform.localRotation = Quaternion.identity
			pet.transform.localScale = Vector3.one

			itemlua.rectTransform.anchoredPosition = Vector2.zero

			self.petLuaItems[idx] = itemlua
			local petData = self.controller:GetPetDataById(petId)
			if not petData then
				petData = ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(petId)
			end
			if petData then
				IconPetItemCtr:SetData(self, self.petLuaItems[idx], petData, Enum.ItemIEnterType.Pet)

				self.slotTrigger["slot"..idx].uIEventTriggerListener.onBeginDrag = function()
					self:BattlePetBeginDrag(idx)
				end
				self.slotTrigger["slot"..idx].uIEventTriggerListener.onDrag = function()
					self:BattlePetOnDrag(idx)
				end
				self.slotTrigger["slot"..idx].uIEventTriggerListener.onPointerUp = function()
					self:BattlePetOnPointerUp(idx)
				end
				self.slotTrigger["slot"..idx].uIEventTriggerListener.onClick = nil
			end
		end)
	end
end

function UIPetBattleView:RemoveBattlePet(idx, onDispose)
	self.controller:SetPetBattlePetId(idx)

	self.slotTrigger["slot"..idx].uIEventTriggerListener.onDrag = nil
	self.slotTrigger["slot"..idx].uIEventTriggerListener.onPointerUp = nil
	self.slotTrigger["slot"..idx].uIEventTriggerListener.onBeginDrag = nil
	if not onDispose then
		self.slotTrigger["slot"..idx].uIEventTriggerListener.onClick = function()
			self:BattlePetClick(idx)
		end
	else
		self.slotTrigger["slot"..idx].uIEventTriggerListener.onClick = nil
	end

	ManagerContainer.GoPoolMgr:RecycleGo(self.petLuaItems[idx])
	self.petLuaItems[idx] = nil
end

function UIPetBattleView:Refresh(resetPos)
	if petMatsGridView then
		petMatsGridView:Refresh(resetPos)
	end

	self.btnFilter.check:SetActive(self.controller:GetIsFilter())
end

function UIPetBattleView:OnItemClick(button, params)
	local data = params[0]
	local itemlua = params[1]

	self:OnItemClick1(data, itemlua)
end

function UIPetBattleView:OnItemClick1(data, itemlua)
	local lastData = self.controller:GetLastSelectedPetData()
	if lastData then
		local idx = self.controller:GetPetDataIdxById(lastData.id)
		local lastItemlua = petMatsGridView:GetShowItemByIdx(idx)
		if lastItemlua then
			lastItemlua.selected:SetActive(false)
		end
	end

	if lastData == nil or lastData == data then
		self.showState = not self.showState
	end

	if lastData == data then
		self.controller:SetCurSelectedPetData(nil)
		if itemlua then
			itemlua.selected:SetActive(false)
		end
	else
		self.controller:SetCurSelectedPetData(data)
		if itemlua then
			itemlua.selected:SetActive(true)
		end
	end

	self:RefreshSlotBtns(data.id)
end

function UIPetBattleView:RefreshSlotBtns(curPetId)
	local unlockCount = self.controller:GetUnlockCount()
	local lockCount = self.controller:GetLockCount()
	local petBattleCount = self.controller:GetBattlePetCount()

	local remainEmptySlot = unlockCount - petBattleCount

	--self.slotTrigger:SetActive(remainEmptySlot == 0)

	self.battlePetCount.text.text = petBattleCount.."/"..unlockCount

	for i = 1, 6 do
		local heroData = self.controller:GetHeroDataByUid(i)
		local petId = self.controller:GetPetBattlePetId(i)
		self.slotEmpty["slot"..i.."Btn"]:SetActive(false)
		if self.showState then
			if remainEmptySlot > 0 then
				self.slotEmpty["slot"..i.."Btn"]:SetActive(((not petId or petId == 0) and (heroData.id == 1 or heroData.owned)) or (petId and petId > 0 and petId ~= curPetId))
				self.slotBattle["slot"..i]:SetActive(petId and petId > 0 and petId == curPetId)
				self.slotTrigger["slot"..i]:SetActive(heroData.id > 1 and not heroData.owned)
				if petId and petId > 0 and curPetId ~= petId then
					self.slotEmpty["slot"..i.."Btn"].text.uILocalizeScript:SetContent("BtnPetReplace")
				else
					self.slotEmpty["slot"..i.."Btn"].text.uILocalizeScript:SetContent("BtnPetFollow")
				end
				self.slotTrigger["slot"..i.."_lock"]:SetActive(false)

				if not petId or petId == 0 then
					remainEmptySlot = remainEmptySlot - 1
				end
			else
				if unlockCount == petBattleCount then
					if petId and petId > 0 then
						self.slotEmpty["slot"..i.."Btn"]:SetActive((not petId or petId == 0) or (petId and petId > 0 and petId ~= curPetId))
						self.slotBattle["slot"..i]:SetActive(petId and petId > 0 and petId == curPetId)
						self.slotTrigger["slot"..i]:SetActive(false)
						self.slotTrigger["slot"..i.."_lock"]:SetActive(false)
						if petId and petId > 0 and curPetId ~= petId then
							self.slotEmpty["slot"..i.."Btn"].text.uILocalizeScript:SetContent("BtnPetReplace")
						else
							self.slotEmpty["slot"..i.."Btn"].text.uILocalizeScript:SetContent("BtnPetFollow")
						end
					else
						self.slotEmpty["slot"..i.."Btn"]:SetActive(false)
						self.slotBattle["slot"..i]:SetActive(false)
						self.slotTrigger["slot"..i]:SetActive(false)
					end
				else
					if heroData.id > 1 and not heroData.owned then
						self.slotEmpty["slot"..i.."Btn"]:SetActive(false)
						self.slotBattle["slot"..i]:SetActive(false)
						self.slotTrigger["slot"..i]:SetActive(true)
					else
						self.slotEmpty["slot"..i.."Btn"]:SetActive((not petId or petId == 0) or (petId and petId > 0 and petId ~= curPetId))
						self.slotBattle["slot"..i]:SetActive(petId and petId > 0 and petId == curPetId)
						self.slotTrigger["slot"..i]:SetActive(false)
						self.slotTrigger["slot"..i.."_lock"]:SetActive(false)
						if petId and petId > 0 and curPetId ~= petId then
							self.slotEmpty["slot"..i.."Btn"].text.uILocalizeScript:SetContent("BtnPetReplace")
						else
							self.slotEmpty["slot"..i.."Btn"].text.uILocalizeScript:SetContent("BtnPetFollow")
						end
					end
				end
			end

		else
			self.slotEmpty["slot"..i.."Btn"]:SetActive(false)
			self.slotBattle["slot"..i]:SetActive(false)
			self.slotTrigger["slot"..i]:SetActive(true)
			if not petId or petId == 0 then
				if remainEmptySlot > 0 then
					self.slotTrigger["slot"..i.."_lock"]:SetActive(false)
					self.slotTrigger["slot"..i]:SetActive(false)
					--local unlockState = self.controller:GetSlotUnLockState(i)
					--local noOwnedLock = heroData.id > 1 and not heroData.owned and not unlockState
					--self.slotTrigger["slot"..i.."_lock"]:SetActive(noOwnedLock)
					----remainEmptySlot = remainEmptySlot - 1
				else
					self.slotTrigger["slot"..i.."_lock"]:SetActive(true)
					self.slotTrigger["slot"..i]:SetActive(false)
				end
			else
				self.slotTrigger["slot"..i.."_lock"]:SetActive(false)
			end
		end
	end
end

function UIPetBattleView:BattlePetBeginDrag(idx)
	self.beginDrag = true
	local itemlua = self.petLuaItems[idx]
	if itemlua == nil then return end

	self.dragItem = itemlua
	self.uIEventTriggerListener = self.slotTrigger["slot"..idx].uIEventTriggerListener
	--local root = itemlua.transform.parent.parent
	itemlua.transform:SetParent(self.window.transform)
end

function UIPetBattleView:BattlePetOnDrag(idx)
	--local itemlua = self.petLuaItems[idx]
	--if itemlua == nil then return end
	--
	--local position = UIEventTriggerListener.currentEventData.delta
	----position = CameraMgr.Instance.UICamera:ScreenToViewportPoint(position)
	----position.x = (position.x - 0.5) * UIMgr.SCREEN_WIDTH
	----position.y = (position.y - 0.5) * UIMgr.SCREEN_HEIGHT
	--itemlua.rectTransform.anchoredPosition = itemlua.rectTransform.anchoredPosition + position
end

function UIPetBattleView:Update()
	if not self.beginDrag then return end
	local position = self.uIEventTriggerListener.currentEventData.position
	tmpPos = CameraMgr.Instance.UICamera:ScreenToViewportPoint(position)
	pos.x = (tmpPos.x - 0.5) * UIMgr.SCREEN_WIDTH;
	pos.y = (tmpPos.y - 0.5) * UIMgr.SCREEN_HEIGHT;
	pos.x = CommonUtil.Clamp(edgeX.x, edgeX.y, pos.x)
	pos.y = CommonUtil.Clamp(edgeY.x, edgeY.y, pos.y)

	--curPos = self.dragItem.rectTransform.anchoredPosition
	--self.dragItem.rectTransform.anchoredPosition = Vector2.Lerp(curPos, pos, 20*Time.deltaTime)
	self.dragItem.rectTransform.anchoredPosition = pos
end

function UIPetBattleView:BattlePetClick(idx)
	local heroData = self.controller:GetHeroDataByUid(idx)
	if heroData.id > 1 and not heroData.owned then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petfight_002")
		return
	end
	local itemlua = self.petLuaItems[idx]
	if itemlua == nil then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petfight_007")
		return
	end
end

function UIPetBattleView:BattlePetOnPointerUp(idx)
	self.uIEventTriggerListener = nil
	self.dragItem = nil

	if not self.beginDrag then return end
	self.beginDrag = false
	local itemlua = self.petLuaItems[idx]
	if itemlua == nil then return end

	local unlockCount = self.controller:GetUnlockCount()
	local petBattleCount = self.controller:GetBattlePetCount()
	local remainEmptySlot = unlockCount - petBattleCount

	local outArea = true
	local relaceIdx = idx
	local targetPetId
	for i = 1, 6 do
		local heroData = self.controller:GetHeroDataByUid(i)
		local parent = self.slotTrigger["slot"..i]
		local minX = CommonUtil.ConvertUIPos2ScreenPos(parent.transform.position).x - deltaVec.x
		local maxX = CommonUtil.ConvertUIPos2ScreenPos(parent.transform.position).x + deltaVec.x
		local curX = CommonUtil.ConvertUIPos2ScreenPos(itemlua.transform.position).x

		local oriPetId = self.controller:GetPetBattlePetId(idx)
		targetPetId = self.controller:GetPetBattlePetId(i)
		--if not targetPetId or targetPetId == 0 then
		--	remainEmptySlot = remainEmptySlot - 1
		--end
		if curX >= minX and curX <= maxX then
			if remainEmptySlot <= 0 and (not targetPetId or targetPetId == 0) then
				break
			end
			if i == 1 or heroData.owned then
                outArea = false
                relaceIdx = i
				self.controller:SetPetBattlePetId(idx, targetPetId)
				self.controller:SetPetBattlePetId(i, oriPetId)
			end
			break
		end
	end

	if relaceIdx == idx then
		local parent = self.slotList["slot"..relaceIdx]
		itemlua.transform:SetParent(parent.transform)
		itemlua.rectTransform.anchoredPosition = Vector2.zero
		return
	end

	local parent
	if targetPetId and targetPetId > 0 then
		parent = self.slotList["slot"..idx]
	else
		parent = self.slotList["slot"..relaceIdx]
		self:ResetBattlePetItemlua(idx, relaceIdx, itemlua)
	end
	itemlua.transform:SetParent(parent.transform)
	if outArea then
		itemlua.rectTransform.anchoredPosition = Vector2.zero
	else
		if not targetPetId or targetPetId == 0 then
			lastOps = OpsEnum.UpBattle
		else
			lastOps = OpsEnum.Replace
		end

		self.controller:SendPetBattle()
	end
end

function UIPetBattleView:ResetBattlePetItemlua(oriIdx, repIdx, itemlua)
	self.petLuaItems[oriIdx] = nil
	self.slotTrigger["slot"..oriIdx].uIEventTriggerListener.onBeginDrag = nil
	self.slotTrigger["slot"..oriIdx].uIEventTriggerListener.onDrag = nil
	self.slotTrigger["slot"..oriIdx].uIEventTriggerListener.onPointerUp = nil
	self.slotTrigger["slot"..oriIdx].uIEventTriggerListener.onClick = function()
		self:BattlePetClick(oriIdx)
	end

	self.petLuaItems[repIdx] = itemlua

	self.slotTrigger["slot"..repIdx].uIEventTriggerListener.onBeginDrag = function()
		self:BattlePetBeginDrag(repIdx)
	end
	self.slotTrigger["slot"..repIdx].uIEventTriggerListener.onDrag = function()
		self:BattlePetOnDrag(repIdx)
	end
	self.slotTrigger["slot"..repIdx].uIEventTriggerListener.onPointerUp = function()
		self:BattlePetOnPointerUp(repIdx)
	end
	self.slotTrigger["slot"..repIdx].uIEventTriggerListener.onClick = nil
end

function UIPetBattleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPetBattleView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnCloseClick)

	self.uiBase:AddButtonEventListener(self.slotEmpty.slot1Btn.button, self, self.OnBattleClick, 1)
	self.uiBase:AddButtonEventListener(self.slotEmpty.slot2Btn.button, self, self.OnBattleClick, 2)
	self.uiBase:AddButtonEventListener(self.slotEmpty.slot3Btn.button, self, self.OnBattleClick, 3)
	self.uiBase:AddButtonEventListener(self.slotEmpty.slot4Btn.button, self, self.OnBattleClick, 4)
	self.uiBase:AddButtonEventListener(self.slotEmpty.slot5Btn.button, self, self.OnBattleClick, 5)
	self.uiBase:AddButtonEventListener(self.slotEmpty.slot6Btn.button, self, self.OnBattleClick, 6)

	self.uiBase:AddButtonEventListener(self.btnOneKeyBattle.button, self, self.OnOneKeyBattleClick)
	self.uiBase:AddButtonEventListener(self.btnFilter.button, self, self.OnFilterClick)

	self.uiBase:AddButtonEventListener(self.btnPlayRule.button, self, self.OnClickPlayRuleBtn)

	local lockContent = self.controller:GetLockContent()
	if lockContent then
		for i = 1, 6 do
			self.slotTrigger["slotLock"..i].uIEventTriggerListener.onClick = function()
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(lockContent)
			end
		end
	end
end

function UIPetBattleView:OnFilterClick()
	local data = {uiId = self.uiData.id, enter = Enum.ItemIEnterType.Pet, filterData = self.controller:GetFilterData()}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFilter, data)
end

function UIPetBattleView:OnCloseClick()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiData.id)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID, nil, nil, false)
	end
end

function UIPetBattleView:OnClickPlayRuleBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'PetBattleExplain'})
end

function UIPetBattleView:OnBattleClick(button, params)
	local idx = params[0]

	local heroData = self.controller:GetHeroDataByUid(idx)
	if not heroData then
		return
	end

	if heroData.id > 1 and not heroData.owned then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petfight_002")
		return
	end

	local curSelectedData = self.controller:GetCurSelectedPetData()
	if not curSelectedData then
		return
	end
	local curSelectedId = curSelectedData.id
	local result = self.controller:HasSamePetInBattle(curSelectedId, idx)
	if result then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("543")
		return
	end

	local petId = self.controller:GetPetBattlePetId(idx)
	if petId and petId > 0 then
		if petId ~= curSelectedData.id then
			local oldPetId = petId
			self:ReplacePet(curSelectedData.id, oldPetId)
			lastOps = OpsEnum.Replace
		else
			self:RemoveBattlePet(idx)
		end
	else
		self:ReplacePet(curSelectedData.id)
		lastOps = OpsEnum.UpBattle
	end
	self.controller:SetPetBattlePetId(idx, curSelectedData.id)
	--self:AddBattlePet(idx, curSelectedData.id)

	self.controller:SetCurSelectedPetData(nil)

	--self.controller:SendPetBattle()

	self.showState = not self.showState
	self:RefreshSlotBtns()

	self:FlyShow(curSelectedId, idx)
end

function UIPetBattleView:FlyShow(id, slotIdx)
	local idx = self.controller:GetPetDataIdxById(id)
	local itemlua = petMatsGridView:GetShowItemByIdx(idx)
	if not itemlua then
		self.controller:SendPetBattle()
		return
	end

	local target = self.slotEmpty["slot"..slotIdx.."Btn"]

	self.flyGo = UnityEngine.GameObject.Instantiate(itemlua.gameObject)
	self.flyGo.transform:Find("Selected").gameObject:SetActive(false)
	self.flyGo.transform:SetParent(self.window.transform)
	self.flyGo.transform.localScale = Vector3.one
	self.flyGo.transform.position = itemlua.transform.position

	local rectTransform = self.flyGo:GetComponent(Enum.TypeInfo.RectTransform)
	local position = CameraMgr.Instance.UICamera:WorldToScreenPoint(self.flyGo.transform.position)
	position = CameraMgr.Instance.UICamera:ScreenToViewportPoint(position)
	position.x = (position.x - 0.5) * UIMgr.SCREEN_WIDTH
	position.y = (position.y - 0.5) * UIMgr.SCREEN_HEIGHT
	local vec = Vector2(0.5,0.5)
	rectTransform.anchorMin = vec
	rectTransform.anchorMax = vec
	local oldPivot = rectTransform.pivot
	rectTransform.pivot = vec
	rectTransform.anchoredPosition = position
	oldPivot.x = 0.5 - oldPivot.x
	oldPivot.y = 0.5 - oldPivot.y
	rectTransform.anchoredPosition = rectTransform.anchoredPosition + Vector2.Scale(rectTransform.sizeDelta, oldPivot)

	local pos = target.transform:TransformPoint(self.flyGo.transform.localPosition)
	local targetPos = self.flyGo.transform:InverseTransformPoint(pos)

	self.mask:SetActive(true)
	self.flyGo.transform:DOLocalMove(targetPos, 0.3):OnComplete(function ()
		UnityEngine.GameObject.Destroy(self.flyGo)
		self.flyGo = nil

		self.controller:SendPetBattle()
	end)
	if not self.mastTimer then
	    self.mastTimer = Timer.New(slot(self.MaskHide, self), 3, 1)
	end
	if not self.mastTimer.running then
		self.mastTimer:Start()
	end
end

function UIPetBattleView:ReplacePet(curSelectedId, oldId)
	for i = 1, 6 do
		local petId = self.controller:GetPetBattlePetId(i)
		if petId == curSelectedId then
			if oldId then
				self.controller:SetPetBattlePetId(i, oldId)
				--self:AddBattlePet(i, oldId)
			else
				self:RemoveBattlePet(i)
			end
			return
		end
	end
end

function UIPetBattleView:OnOneKeyBattleClick()
	local length = self.controller:GetBattlePetCount()
	if length == 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("Petfight_005")
		return
	end
	for i = 1, 6 do
		local petId = self.controller:GetPetBattlePetId(i)
		if petId and petId > 0 then
			self:RemoveBattlePet(i)
		end
	end
	lastOps = OpsEnum.OnekeyDown
	self.controller:SendPetBattle(true)
end

function UIPetBattleView:GetFirstPetItem()
	if petMatsGridView then
		return petMatsGridView:GetShowItemByIdx(1)
	end
	return
end

function UIPetBattleView:PetBattle(owner, ownerCB)
	local item = self:GetFirstPetItem()
	if not item or not item.gameObject then
		if owner and ownerCB then
			ownerCB(owner)
		end
		return
	end

	if owner and ownerCB then
		ownerCB(owner, item.bg)
	end
end

function UIPetBattleView:OnHide()
	if petMatsGridView then
		petMatsGridView:OnHide()
	end
end

function UIPetBattleView:OnShow(data)
	self.controller:SetData(data)

end

function UIPetBattleView:OnClose()
	for i = 1, 6 do
		self.slotTrigger["slotLock"..i].uIEventTriggerListener.onClick = nil
	end
	if self.flyGo then
		DG.Tweening.DOTween.Kill(self.flyGo.transform)
		UnityEngine.GameObject.Destroy(self.flyGo)
		self.flyGo = nil

		self.controller:SendPetBattle()
	end

	if self.mastTimer then
		self.mastTimer:Stop()
		self.mastTimer = nil
	end

	if petMatsGridView then
		petMatsGridView:OnDispose()
		petMatsGridView = nil
	end
end

function UIPetBattleView:OnDispose()
	self.mask:SetActive(false)

	if updateBeat ~= nil then
		UpdateBeat:RemoveListener(updateBeat)
		updateBeat = nil
	end
	self.uIEventTriggerListener = nil
	for i = 1, 6 do
		self:RemoveBattlePet(i, true)
	end

	self.heroLuaItems = nil
	self.petLuaItems = nil

	self.controller:OnDispose()

	if self.loadSystem then
		self.loadSystem:Dispose()
		self.loadSystem = nil
	end
	--ManagerContainer.LuaBattleMgr:SetTeamData(true)
end

return UIPetBattleView

