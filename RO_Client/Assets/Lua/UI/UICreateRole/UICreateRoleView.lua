local UICreateRoleView = require("UICreateRole/UICreateRoleView_Generate")
local RoleViewSystem = require("RoleViewSystem")
local PreviewSystem = require("PreviewSystem")
local MirrorPreviewSystem = require("MirrorPreviewSystem")

local SelectType = {
	HairAndColor = 1,
	EyeColor = 2,
	Headwear = 3,
}
local curSelectType = SelectType.HairAndColor
local roleViewSystem = nil
local previewSystem = nil
local mirrorPreviewSystem = nil
local cancelToggleTigger = false

function UICreateRoleView:OnAwake(data)
	self.controller = require("UICreateRole/UICreateRoleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICreateRoleView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ENTER_BATTLE, function()
		-- ManagerContainer.LuaGameMgr:EnterBattle()
		-- 创建名字流程（临时使用，未来需要根据需求变更）
		-- self.controller:CreateNickName()
	end)
	-- ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.NICK_NAME_CREATED, function()
	-- 	ManagerContainer.LuaGameMgr:EnterBattle()
	-- end)
end

function UICreateRoleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICreateRoleView:Init()
	--暂时设置
	local ls = self.controller:GetCanSelectHairColors()
	self.color1.background.image.color = ls[1]
	self.color2.background.image.color = ls[2]
	self.color3.background.image.color = ls[3]
	self.color4.background.image.color = ls[4]
	self.color5.background.image.color = ls[5]
	self.color6.background.image.color = ls[6]
	self.color7.background.image.color = ls[7]


	if not roleViewSystem then
		roleViewSystem = RoleViewSystem:new()
	end
	if not previewSystem then
		previewSystem = PreviewSystem:new("Preview")
		previewSystem:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
	end
	if not mirrorPreviewSystem then
		mirrorPreviewSystem = MirrorPreviewSystem:new("MirrorPreview", previewSystem:GetCamera())
	end
	self.model:SetActive(true)
	self.model.rawImage.texture = previewSystem:GetRenderTexture()
	self.mirrorModel:SetActive(true)
	self.mirrorModel.rawImage.texture = mirrorPreviewSystem:GetRenderTexture()
	self:_RefreshShowModel()
	-- 加载阴影
	local shadowAssetName = Constants.EffectPath .. "/Common/FX_Yinying"
	self.seqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, nil, {shadowAssetName}, nil, function()
		if ManagerContainer.ResMgr:SeqIdEquals(self.seqId, 0) then
			self.seqId = nil
		end
		self.shadowGo = ManagerContainer.ResMgr:GetGoFromPool(nil, shadowAssetName)
		if previewSystem then
			previewSystem:AddGo(self.shadowGo)
		end
		if mirrorPreviewSystem then
			mirrorPreviewSystem:AddGo(self.shadowGo)
		end
	end)
end

function UICreateRoleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICreateRoleView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddToggleEventListener(self.boy.toggle, self, self.ChangeSex, Enum.SexType.Man)
	self.uiBase:AddToggleEventListener(self.girl.toggle, self, self.ChangeSex, Enum.SexType.Woman)

	self.uiBase:AddToggleEventListener(self.hairAndColor.toggle, self, self.ChangeSelectType, SelectType.HairAndColor)
	self.uiBase:AddToggleEventListener(self.eyeColor.toggle, self, self.ChangeSelectType, SelectType.EyeColor)
	self.uiBase:AddToggleEventListener(self.headwear.toggle, self, self.ChangeSelectType, SelectType.Headwear)

	self.uiBase:AddToggleEventListener(self.hair1.toggle, self, self.ChangeHair, 1)
	self.uiBase:AddToggleEventListener(self.hair2.toggle, self, self.ChangeHair, 2)
	self.uiBase:AddToggleEventListener(self.hair3.toggle, self, self.ChangeHair, 3)
	self.uiBase:AddToggleEventListener(self.hair4.toggle, self, self.ChangeHair, 4)

	self.uiBase:AddToggleEventListener(self.color1.toggle, self, self.ChangeHairColor, 1)
	self.uiBase:AddToggleEventListener(self.color2.toggle, self, self.ChangeHairColor, 2)
	self.uiBase:AddToggleEventListener(self.color3.toggle, self, self.ChangeHairColor, 3)
	self.uiBase:AddToggleEventListener(self.color4.toggle, self, self.ChangeHairColor, 4)
	self.uiBase:AddToggleEventListener(self.color5.toggle, self, self.ChangeHairColor, 5)
	self.uiBase:AddToggleEventListener(self.color6.toggle, self, self.ChangeHairColor, 6)
	self.uiBase:AddToggleEventListener(self.color7.toggle, self, self.ChangeHairColor, 7)

	self.uiBase:AddToggleEventListener(self.eyesColor1.toggle, self, self.ChangeEye, 1)
	self.uiBase:AddToggleEventListener(self.eyesColor2.toggle, self, self.ChangeEye, 2)
	self.uiBase:AddToggleEventListener(self.eyesColor3.toggle, self, self.ChangeEye, 3)
	self.uiBase:AddToggleEventListener(self.eyesColor4.toggle, self, self.ChangeEye, 4)

	self.uiBase:AddToggleEventListener(self.headwear1.toggle, self, self.ChangeHeadwear, 1)
	self.uiBase:AddToggleEventListener(self.headwear2.toggle, self, self.ChangeHeadwear, 2)
	self.uiBase:AddToggleEventListener(self.headwear3.toggle, self, self.ChangeHeadwear, 3)

	self.uiBase:AddButtonEventListener(self.btnLetsGo.button, self, self.OnClickStartGame)
	self.uiBase:AddButtonEventListener(self.btnBack.button, self, self.OnClickBack)

	self.model.uIEventTriggerListener.onDrag = function()
		local deltaX = self.model.uIEventTriggerListener.currentEventData.delta.x
		if roleViewSystem then
			local go = roleViewSystem:GetGameObject()
			if go then
				go.transform:Rotate(Vector3.New(0, deltaX > 0 and -7 or 7, 0))
			end
		end
	end
end

function UICreateRoleView:OnHide()


end

function UICreateRoleView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UICreateRoleView:OnClose()

end

function UICreateRoleView:OnDispose()
	self.model.uIEventTriggerListener.onDrag = nil
	if self.seqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.seqId)
	end
	self.seqId = nil
	if self.shadowGo then
		local shadowAssetName = Constants.EffectPath .. "/Common/FX_Yinying"
		ManagerContainer.ResMgr:RecycleGO(nil, shadowAssetName, self.shadowGo)
	end
	self.shadowGo = nil
	if mirrorPreviewSystem then
		mirrorPreviewSystem:Dispose()
	end
	mirrorPreviewSystem = nil
	if previewSystem then
		previewSystem:Dispose()
	end
	previewSystem = nil
	if roleViewSystem then
		roleViewSystem:Dispose()
	end
	roleViewSystem = nil

end


function UICreateRoleView:ChangeSex(toggle, sexType, result)
	if not result then return end

	if not self.controller:SetSexType(sexType) then
		return
	end
	if previewSystem and roleViewSystem then
		previewSystem:RemoveGo(roleViewSystem:GetGameObject())
	end
	if mirrorPreviewSystem and roleViewSystem then
		mirrorPreviewSystem:RemoveGo(roleViewSystem:GetGameObject())
	end
	self:_RefreshShowModel()
end

function UICreateRoleView:_RefreshShowModel()
	local roleCfgId = self.controller:GetRoleCfgId()
	local isMan = (self.controller:GetSexType() == Enum.SexType.Man)
	local isWoman = (not isMan)

	self.bgBoy:SetActive(isMan)
	self.bgGirl:SetActive(isWoman)
	self.mirrorBoy:SetActive(isMan)
	self.mirrorGirl:SetActive(isWoman)

	cancelToggleTigger = true
	self.boy.toggle.isOn = isMan
	self.girl.toggle.isOn = isWoman
	self.hairAndColor.toggle.isOn = true
	cancelToggleTigger = false
	self:ChangeSelectType(nil, SelectType.HairAndColor, true)

	if roleCfgId then
		roleViewSystem:RefreshView(Enum.RoleInEnvType.CreateRole, roleCfgId, self.controller:GetViewData(), nil, self, self.RefreshShowComplete)
	else
		roleViewSystem:Recycle()
	end
end

function UICreateRoleView:ChangeSelectType(toggle, selectType, result)
	if not result then return end

	if cancelToggleTigger then return end
	if selectType == SelectType.HairAndColor then
		self.hairRoot:SetActive(true)
		self.eyesRoot:SetActive(false)
		self.headwearRoot:SetActive(false)
		cancelToggleTigger = true
		self.toggleGroupHair.toggleGroup:SetAllTogglesOff()
		self.toggleGroupColor.toggleGroup:SetAllTogglesOff()
		self['hair' .. self.controller:GetSelectHairIndex()].toggle.isOn = true
		self['color' .. self.controller:GetSelectHairColorIndex()].toggle.isOn = true
		self:RefreshUIHair()
		self:RefreshUIHairColor()
		cancelToggleTigger = false
	elseif selectType == SelectType.EyeColor then
		self.hairRoot:SetActive(false)
		self.eyesRoot:SetActive(true)
		self.headwearRoot:SetActive(false)
		cancelToggleTigger = true
		self.toggleGroupEyesColor.toggleGroup:SetAllTogglesOff()
		self['eyesColor' .. self.controller:GetSelectEyeIndex()].toggle.isOn = true
		cancelToggleTigger = false
	-- elseif selectType == SelectType.Headwear then
	else
		self.hairRoot:SetActive(false)
		self.eyesRoot:SetActive(false)
		self.headwearRoot:SetActive(true)
		cancelToggleTigger = true
		self.toggleGroupHeadwear.toggleGroup:SetAllTogglesOff()
		self['headwear' .. self.controller:GetSelectHeadwearsIndex()].toggle.isOn = true
		cancelToggleTigger = false
	end
end

function UICreateRoleView:ChangeHair(toggle, index, result)
	if not result then return end

	if cancelToggleTigger then return end
	if self.controller:SetSelectHairIndex(index) then
		roleViewSystem:RefreshView(Enum.RoleInEnvType.CreateRole, self.controller:GetRoleCfgId(), self.controller:GetViewData(), nil, self, self.RefreshShowComplete)
	end
end

function UICreateRoleView:ChangeHairColor(toggle, index, result)
	if not result then return end

	if cancelToggleTigger then return end
	if self.controller:SetSelectHairColorIndex(index) then
		self:RefreshUIHairColor()
		roleViewSystem:RefreshView(Enum.RoleInEnvType.CreateRole, self.controller:GetRoleCfgId(), self.controller:GetViewData(), nil, self, self.RefreshShowComplete)
	end
end

function UICreateRoleView:ChangeEye(toggle, index, result)
	if not result then return end

	if cancelToggleTigger then return end
	if self.controller:SetSelectEyeIndex(index) then
		roleViewSystem:RefreshView(Enum.RoleInEnvType.CreateRole, self.controller:GetRoleCfgId(), self.controller:GetViewData(), nil, self, self.RefreshShowComplete)
	end
end

function UICreateRoleView:ChangeHeadwear(toggle, index, result)
	if not result then return end

	if cancelToggleTigger then return end
	if self.controller:SetSelectHeadwearsIndex(index) then
		roleViewSystem:RefreshView(Enum.RoleInEnvType.CreateRole, self.controller:GetRoleCfgId(), self.controller:GetViewData(), nil, self, self.RefreshShowComplete)
	end
end

function UICreateRoleView:OnClickStartGame()
	self.controller:OnCreateClick()
end

function UICreateRoleView:OnClickBack()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UILogin)
end


function UICreateRoleView:RefreshShowComplete(go, isNewGo)
	if previewSystem then
		previewSystem:UpdateGo(go)
	end
	if mirrorPreviewSystem then
		mirrorPreviewSystem:UpdateGo(go)
	end
end

function UICreateRoleView:RefreshUIHair()
	local isMan = (self.controller:GetSexType() == Enum.SexType.Man)
	local isWoman = (not isMan)
	self.hair1.headBoy:SetActive(isMan)
	self.hair1.headGirl:SetActive(isWoman)
	self.hair2.headBoy:SetActive(isMan)
	self.hair2.headGirl:SetActive(isWoman)
	self.hair3.headBoy:SetActive(isMan)
	self.hair3.headGirl:SetActive(isWoman)
	self.hair4.headBoy:SetActive(isMan)
	self.hair4.headGirl:SetActive(isWoman)
end

function UICreateRoleView:RefreshUIHairColor()
	local keyName = self:GetHairKeyName()
	local color = self.controller:GetSelectHairColor()
	self.hair1[keyName].color.image.color = color
	self.hair2[keyName].color.image.color = color
	self.hair3[keyName].color.image.color = color
	self.hair4[keyName].color.image.color = color
end

function UICreateRoleView:GetHairKeyName()
	local isMan = (self.controller:GetSexType() == Enum.SexType.Man)
	local keyName = isMan and 'headBoy' or 'headGirl'
	return keyName
end

return UICreateRoleView

