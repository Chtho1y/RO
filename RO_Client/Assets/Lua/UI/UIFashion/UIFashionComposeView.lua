local UIFashionComposeView = require("UIFashion/UIFashionComposeView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local PreviewSystem = require('PreviewSystem')
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")
local previewSystem = nil
local AroundSphereMoveType = typeof(AroundSphereMove)
local GameObject = UnityEngine.GameObject

local ConsumePos = {
	[1] = {Vector2(0, -220)},
	[2] = {Vector2(-200, -220), Vector2(200, -220)},
	[3] = {Vector2(-250, -50), Vector2(0, -220), Vector2(250, -50)},
	[4] = {Vector2(-300, -50), Vector2(-100, -220), Vector2(100, -220), Vector2(300, -50)},
}


function UIFashionComposeView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionComposeCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionComposeView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.COIN_CHANGED, self, self.RefreshMoney)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.RefreshMoney)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.RefreshItem)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FASHION_LIST_CHANGE, self, self.RefreshOwnSign)
end

function UIFashionComposeView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionComposeView:Init()
	local cfgId = self.controller:GetCfgId()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionPaperCfgData.FashionId)

	if not previewSystem then
		previewSystem = PreviewSystem:new('FashionPaperPreview')
		local pos = CommonUtil.TableToVector3(fashionCfgData.ShowCamPos)
		local rot = CommonUtil.TableToQuaternion(fashionCfgData.ShowCamRot)
		previewSystem:SetView(pos, rot)
	end
	self.rawImage.rawImage.texture = previewSystem:GetRenderTexture()
	if not self.AroundSphereMoveContainer then
		self.AroundSphereMoveContainer = GameObject("AroundSphereMoveContainer")
		local aroundSphereMove = self.AroundSphereMoveContainer:AddComponent(AroundSphereMoveType)
		aroundSphereMove.selfRotateSpeed = 50
		if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
            self.AroundSphereMoveContainer.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
        end
	end
	-- 模型
	self:RecycleModel()
	if not self.loadSystem then
		self.loadSystem = MultiTypeAssetLoadSystem:new()
	end
	self.loadSystem:SetCompleteCB(self, self.RefreshModel)
	self.loadSystem:RemoveLoadAllAsset()
	local hasShow = false
	local showRoleAvatarIDs = fashionCfgData.ShowRoleAvatarID
	if showRoleAvatarIDs then
		local num = #showRoleAvatarIDs
		if num > 0 then
			for i = 1, num do
				local roleAvatarID = showRoleAvatarIDs[1]
				local roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(roleAvatarID)
				if roleAvatarCfg then
					self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, roleAvatarCfg.AvatarPrefab)
				end
			end
			hasShow = true
		end
	end
	if not hasShow then
		local roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(fashionCfgData.RoleAvatarID)
		if roleAvatarCfg then
			self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, roleAvatarCfg.AvatarPrefab)
		end
	end
	self.loadSystem:Begin()
	-- 名字
	self.nameTxt.text.text = I18N.SetLanguageValue(fashionCfgData.FashionName)
	-- 显示材料
	self:RefreshMakeMaterials()
end

function UIFashionComposeView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionComposeView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.composeBtn.button, self, self.OnClickComposeBtn)
end

function UIFashionComposeView:OnHide()
	self:RecycleModel()
	if self.loadSystem then
		self.loadSystem:Dispose()
		self.loadSystem = nil
	end
	if self.AroundSphereMoveContainer then
		GameObject.Destroy(self.AroundSphereMoveContainer)
	end
	self.AroundSphereMoveContainer = nil
	if previewSystem then
		previewSystem:Dispose()
		previewSystem = nil
	end
end

function UIFashionComposeView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIFashionComposeView:OnClose()

end

function UIFashionComposeView:OnDispose()
	self:RecycleModel()
	if self.loadSystem then
		self.loadSystem:Dispose()
		self.loadSystem = nil
	end
	if self.AroundSphereMoveContainer then
		GameObject.Destroy(self.AroundSphereMoveContainer)
	end
	self.AroundSphereMoveContainer = nil
	if previewSystem then
		previewSystem:Dispose()
		previewSystem = nil
	end
end

function UIFashionComposeView:OnClickCloseBtn()
	self:UIClose()
end

function UIFashionComposeView:OnClickComposeBtn()
	local errorCode = self.controller:GetErrorCode()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FashionPaperMakeError' .. errorCode)
		return
	end
	local cfgId = self.controller:GetCfgId()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionPaperCfgData.FashionId)
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	if not fashionCfgData.FashionUseJob or IsTableHasValue(fashionCfgData.FashionUseJob, jobCfgId) then
		self:SureComposeFashion()
	else
		local data = {"ComposeFashionSure", nil, nil, self, self.SureComposeFashion}
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
	end
end

function UIFashionComposeView:SureComposeFashion()
	local errorCode = self.controller:GetErrorCode()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('FashionPaperMakeError' .. errorCode)
		return
	end
	self.controller:SendCompose()
	self:UIClose()
end

function UIFashionComposeView:RefreshMoney()
	self:RefreshMakeMaterials()
end

function UIFashionComposeView:RefreshItem()
	self:RefreshMakeMaterials()
end

function UIFashionComposeView:RefreshMakeMaterials()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(self.controller:GetCfgId())
	local makeMaterial = clone(fashionPaperCfgData.MakeMaterial)
	if type(makeMaterial[1]) == 'number' then
		makeMaterial = {makeMaterial}
	end
	local num = #makeMaterial
	local materialCfgId = nil
	local materialNum = nil
	local moneyCfgId = nil
	local moneyNum = nil
	for i = num, 1, -1 do
		materialCfgId = makeMaterial[i][1]
		materialNum = makeMaterial[i][2]
		local materialItemCfgData = ManagerContainer.CfgMgr:GetItemById(materialCfgId)
		if materialItemCfgData.ResType == Enum.ItemType.Coin
			or materialItemCfgData.ResType == Enum.ItemType.Diamond then
			moneyCfgId = materialCfgId
			moneyNum = materialNum
			-- 移除一个货币显示到列表，会单独显示
			table.remove(makeMaterial, i)
			break
		end
	end
	num = #makeMaterial
	if num > 4 then num = 4 end

	for i = 1, 4 do
		local consumeLua = self['consume' .. i]
		if i <= num then
			materialCfgId = makeMaterial[i][1]
			materialNum = makeMaterial[i][2]
			consumeLua:SetActive(true)
			local itemLua = self["Item"..i]
			local curOwnedNum = CommonUtil.GetOwnResCountByItemId(materialCfgId)
			if curOwnedNum >= materialNum then
				consumeLua.text.text.text = string.format(Constant.DeepGreenColorText, (curOwnedNum .. '/' .. materialNum))
			else
				consumeLua.text.text.text = string.format(Constant.RedColorText, (curOwnedNum .. '/' .. materialNum))
			end
			consumeLua.rectTransform.anchoredPosition = ConsumePos[num][i]
			local data = {cfgId = materialCfgId, num = curOwnedNum}
			IconItemCtr:SetData(self, itemLua, data, nil, self, self.ShowItemTips)
		else
			consumeLua:SetActive(false)
		end
	end
	if moneyCfgId == nil or moneyNum == nil then
		self.coinZ.coinIcon:SetActive(true)
		self.coinZ.diamondIcon:SetActive(false)
		self.coinZ.text.text.text = '0'
	else
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(moneyCfgId)
		self.coinZ.coinIcon:SetActive(itemCfgData.ResType == Enum.ItemType.Coin)
		self.coinZ.diamondIcon:SetActive(itemCfgData.ResType == Enum.ItemType.Diamond)
		local curOwnedNum = CommonUtil.GetOwnResCountByItemId(moneyCfgId)
		if curOwnedNum >= moneyNum then
			self.coinZ.text.text.text = tostring(moneyNum)
		else
			self.coinZ.text.text.text = string.format(Constant.RedColorText, moneyNum)
		end
	end
end

function UIFashionComposeView:RefreshModel()
	local cfgId = self.controller:GetCfgId()
	local fashionPaperCfgData = ManagerContainer.CfgMgr:GetFashionPaperById(cfgId)
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionPaperCfgData.FashionId)

	local hasShow = false
	local showRoleAvatarIDs = fashionCfgData.ShowRoleAvatarID
	local showModelPoss = fashionCfgData.ShowModelPos
	local showModelRots = fashionCfgData.ShowModelRot
	if showRoleAvatarIDs then
		local num = #showRoleAvatarIDs
		if num > 0 then
			for i = 1, num do
				self:CreateFashionModel(showRoleAvatarIDs[i], (showModelPoss and showModelPoss[i] or nil), (showModelRots and showModelRots[i] or nil))
			end
			hasShow = true
		end
	end
	if not hasShow then
		self:CreateFashionModel(fashionCfgData.RoleAvatarID, (showModelPoss and showModelPoss[1] or nil), (showModelRots and showModelRots[1] or nil))
	end
end

function UIFashionComposeView:CreateFashionModel(roleAvatarID, modelPos, modelRot)
	local roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(roleAvatarID)
	if roleAvatarCfg then
		local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, roleAvatarCfg.AvatarPrefab)
		if go then
			if not self.fashionGos then
				self.fashionGos = {}
			end
			local modelPosition = CommonUtil.TableToVector3(modelPos)
			local modelRatate = CommonUtil.TableToQuaternion(modelRot)
			local fashionTrans = go.transform
			local srcPos = fashionTrans.localPosition
			local srcRot = fashionTrans.localRotation
			fashionTrans:SetParent(self.AroundSphereMoveContainer.transform)
			fashionTrans.localPosition = modelPosition
			fashionTrans.localRotation = modelRatate
			if previewSystem then
				previewSystem:AddGo(go)
			end
			self.fashionGos[#self.fashionGos + 1] = {go, roleAvatarCfg.AvatarPrefab, srcPos, srcRot}
		end
	end
end

function UIFashionComposeView:RecycleModel()
	if self.loadSystem then
		self.loadSystem:Cancel()
	end

	if self.fashionGos then
		for _, fashionGo in pairs(self.fashionGos) do
			local go = fashionGo[1]
			local path = fashionGo[2]
			local srcPos = fashionGo[3]
			local srcRot = fashionGo[4]
			if previewSystem then
				previewSystem:RemoveGo(go)
			end
			go.transform:SetParent(nil)
			go.transform.localPosition = srcPos
			go.transform.localRotation = srcRot
			ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, path, go)
		end
	end
	self.fashionGos = nil
end

function UIFashionComposeView:ShowItemTips(button, params)
	local data = params[0]

	--ManagerContainer.LuaUIMgr:OpenItemTips(data.cfgId, nil, data)
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

return UIFashionComposeView

