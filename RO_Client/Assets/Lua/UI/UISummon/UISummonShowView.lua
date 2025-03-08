local UISummonShowView = require("UISummon/UISummonShowView_Generate")
local PetViewSystem = require('PetViewSystem')
local PreviewSystem = require("PreviewSystem")
local CardIconBigItemCtr = require("Common/CardIconBigItemCtr")

function UISummonShowView:OnAwake(data)
	self.controller = require("UISummon/UISummonShowCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISummonShowView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UISummonShowView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISummonShowView:Init()
	self.loading = false
	self.isPageInEnd = false
	self:RefreshView()
end

function UISummonShowView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISummonShowView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.skip.button, self, self.OnClickSkipBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnNext.button, self, self.OnClickNextBtn)
end

function UISummonShowView:OnHide()

end

function UISummonShowView:OnShow(data)
	self.controller:SetData(data)

end

function UISummonShowView:OnClose()
end

function UISummonShowView:OnDispose()
	self.loading = nil
	self.isPageInEnd = nil
	self.isAniming = nil
	if self.animTimer then
		self.animTimer:Stop()
	end
	self:DisposeShow()
	self.controller:OnDispose()
end

function UISummonShowView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.isPageInEnd = true
	if not self.loading then
		self:LoadComplete()
	end
end

function UISummonShowView:OnClickSkipBtn()
	if not self.isPageInEnd then
		return
	end
	if self.loading or self.isAniming then
		if self.controller:GetCurMustShowComplete() then
			return
		end
	end
	if self.controller:CheckMustShow() then
		local showData = self.controller:GetShowData()
		if showData then
			self:RefreshView()
			return
		end
	end
	self:EnterResultView()
end

function UISummonShowView:OnClickNextBtn()
	if not self.isPageInEnd then
		return
	end
	if self.loading or self.isAniming then
		if self.controller:GetCurMustShowComplete() then
			return
		end
	end
	self.controller:ChangeNextData()
	local showData = self.controller:GetShowData()
	if showData then
		self:RefreshView()
		return
	end
	self:EnterResultView()
end

function UISummonShowView:RefreshView()
	self.loading = true
	self.itemShow.animator:Play('ItemShow', -1, 0)
	self.itemShow.animator:Update(0)
	self.itemShow.animator.enabled = false
	local showData = self.controller:GetShowData()
	if not showData then
		self:EnterResultView()
		return
	end
	local itemCfgData = ManagerContainer.CfgMgr:GetItemById(showData.cfgId)
	if not itemCfgData then
		LogError('[wboy] itemCfg is not exist id : ' .. Inspect(showData))
		self:EnterResultView()
		return
	end
	-- 清理上一次显示的东西
	self:ClearLastShow()

	local isBlue = (not itemCfgData.Quality or itemCfgData.Quality <= 2)
	local isPink = (itemCfgData.Quality and itemCfgData.Quality == 3)
	local isYellow = (itemCfgData.Quality and itemCfgData.Quality >= 4)

	self.bGBlueBottom:SetActive(isBlue)
	self.bGBlue:SetActive(isBlue)
	self.bGPinkBottom:SetActive(isPink)
	self.bGPink:SetActive(isPink)
	self.bGYellowBottom:SetActive(isYellow)
	self.bGYellow:SetActive(isYellow)

	self.nameTxt.text.text = string.formatbykey(itemCfgData.Name)
	self.label:SetActive(false)
	self.labelNew:SetActive(showData.isNew)

	if showData.isNew then
		if not self.newRPGo then
			if not self.newRpSeqId then
				self.newRpSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.UICommonPath, {'UINewRP'}, self, self.NewRPLoadComplete)
				if ManagerContainer.ResMgr:SeqIdEquals(self.newRpSeqId, 0) then
					self.newRpSeqId = nil
					self:NewRPLoadComplete()
				end
			end
		end
	end

	if itemCfgData.ResType == Enum.ItemType.Pet then
		if not self.petViewSystem then
			self.petViewSystem = PetViewSystem:new()
		end
		self.petViewSystem:RefreshView(Enum.RoleInEnvType.PetLvUp, showData.cfgId, showData.extGoesShowData, self, self.PetLoadComplete)
	elseif itemCfgData.ResType == Enum.ItemType.Card then
		if not self.cardItemLua then
			self.cardLoadSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.UIItemDir, {'CardIconBigItem'}, self, self.CardLoadComplete)
			if ManagerContainer.ResMgr:SeqIdEquals(self.cardLoadSeqId, 0) then
				self.cardLoadSeqId = nil
				self:CardLoadComplete()
			end
		else
			self:CardLoadComplete()
		end
	elseif itemCfgData.ResType == Enum.ItemType.SkillEquip then
		local artifactCfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(showData.cfgId)
		if not artifactCfgData then
			if self.artifactGo then
				ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, self.artifactPath, self.artifactGo)
				self.artifactPath = nil
				self.artifactGo = nil
			end
		elseif self.artifactPath ~= artifactCfgData.AvatarPrefab or not self.artifactGo then
			if self.artifactGo then
				ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, self.artifactPath, self.artifactGo)
				self.artifactPath = nil
				self.artifactGo = nil
			end
			self.artifactSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.ModelPath, {artifactCfgData.AvatarPrefab}, self, self.ArtifactLoadComplete)
			if ManagerContainer.ResMgr:SeqIdEquals(self.artifactSeqId, 0) then
				self.artifactSeqId = nil
				self:ArtifactLoadComplete()
			end
		else
			self:ArtifactLoadComplete()
		end
		if artifactCfgData then			
			self:ShowSkillEquipStar(artifactCfgData.ArtifactMaxLevel)
		end
	else
		if not self.iconItemLua then
			self.defaultLoadSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.GameObject, Constants.UIItemDir, {'IconItem'}, self, self.DefaultLoadComplete)
			if ManagerContainer.ResMgr:SeqIdEquals(self.defaultLoadSeqId, 0) then
				self.defaultLoadSeqId = nil
				self:DefaultLoadComplete()
			end
		else
			self:DefaultLoadComplete()
		end
	end
end

--神器星级显示
function UISummonShowView:ClearSkillEquipStar()
	self:ShowSkillEquipStar()
end

function UISummonShowView:ShowSkillEquipStar(nStartCnt)
	if not nStartCnt or nStartCnt <=0 then
		self.starBox:SetActive(false)
	else
		self.starBox:SetActive(true)
		local tbStarGroup = {}
		if nStartCnt > 5 then
			nStartCnt = 5
		end
		tbStarGroup[1] = self.star1
		tbStarGroup[2] = self.star2
		tbStarGroup[3] = self.star3
		tbStarGroup[4] = self.star4
		tbStarGroup[5] = self.star5		
		for i = 1,#tbStarGroup do
			local bIsShow = false
			bIsShow = nStartCnt >= i
			tbStarGroup[i]:SetActive(bIsShow)
		end
	end
end

function UISummonShowView:ClearLastShow()
	if self.previewSystem then
		self.previewSystem:RemoveAllGo()
	end
	self.rT:SetActive(false)
	self.item:SetActive(false)
	self.modelImg.rawImage.texture = nil
	if self.petViewSystem then
		self.petViewSystem:Recycle()
	end
	if self.artifactSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.artifactSeqId)
		self.artifactSeqId = nil
	end
	if self.cardLoadSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.cardLoadSeqId)
		self.cardLoadSeqId = nil
	end
	if self.defaultLoadSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.defaultLoadSeqId)
		self.defaultLoadSeqId = nil
	end
	if self.cardItemLua then
		self.cardItemLua:SetActive(false)
	end
	if self.iconItemLua then
		self.iconItemLua:SetActive(false)
	end
	self:ClearSkillEquipStar()
end

function UISummonShowView:DisposeShow()
	if self.previewSystem then
		self.previewSystem:Dispose()
		self.previewSystem = nil
	end
	if self.petViewSystem then
		self.petViewSystem:Dispose()
		self.petViewSystem = nil
	end
	self.modelImg.rawImage.texture = nil
	if self.newRpSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.newRpSeqId)
		self.newRpSeqId = nil
	end
	if self.newRPGo then
		ManagerContainer.ResMgr:RecycleGO(Constants.UICommonPath, 'UINewRP', self.newRPGo.gameObject)
		self.newRPGo = nil
	end
	if self.autoRotateContainer then
		UnityEngine.GameObject.Destroy(self.autoRotateContainer)
	end
	if self.artifactGo then
		ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, self.artifactPath, self.artifactGo)
		self.artifactPath = nil
		self.artifactGo = nil
	end
	if self.cardLoadSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.cardLoadSeqId)
		self.cardLoadSeqId = nil
	end
	if self.cardItemLua then
		ManagerContainer.ResMgr:RecycleGO(Constants.UIItemDir, 'CardIconBigItem', self.cardItemLua.gameObject)
		self.cardItemLua = nil
	end
	if self.defaultLoadSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(self.defaultLoadSeqId)
		self.defaultLoadSeqId = nil
	end
	if self.iconItemLua then
		ManagerContainer.ResMgr:RecycleGO(Constants.UIItemDir, 'IconItem', self.iconItemLua.gameObject)
		self.iconItemLua = nil
	end
end

function UISummonShowView:PetLoadComplete(modelGo)
	local showData = self.controller:GetShowData()
	local petCfgData = ManagerContainer.CfgMgr:GetPetDataById(showData.cfgId)
	local camPos = CommonUtil.TableToVector3(petCfgData.CamPos or {-0.116, 2.28, 3.89})
	local camRot = CommonUtil.TableToQuaternion(petCfgData.CamRot or {12.174, 177.372, 0.085})
	if not self.previewSystem then
		self.previewSystem = PreviewSystem:new("SummonPreviewSystem", 1024, 1024)
	end
	self.previewSystem:SetView(camPos, camRot)
	self.modelImg.rawImage.texture = self.previewSystem:GetRenderTexture()
	self.previewSystem:UpdateGo(modelGo)
	modelGo:SetActive(true)
	self.petViewSystem:RolePlayAni(modelGo, "s_click")
	if petCfgData then
		self.label:SetActive(true)
		self.mVP:SetActive(petCfgData.Quality == Enum.CardType.MVP)
		self.mini:SetActive(petCfgData.Quality == Enum.CardType.MINIBOSS)
		self.normal:SetActive(petCfgData.Quality == Enum.CardType.NORMAL)
	end
	self.rT:SetActive(true)

	self:LoadComplete()
end

function UISummonShowView:CardLoadComplete()
	self.cardLoadSeqId = nil
	if not self.cardItemLua then
		local cardItem = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIItemDir, 'CardIconBigItem')
		if cardItem then
			cardItem.transform:SetParent(self.item.transform)
			cardItem.transform.localPosition = Vector3.zero
			cardItem.transform.localRotation = Quaternion.identity
			cardItem.transform.localScale = Vector3.one
			self.cardItemLua = CommonUtil.BindGridViewItem2Lua(self, 'CardIconBigItem', cardItem.gameObject)
		end
	end
	if self.cardItemLua then
		self.cardItemLua:SetActive(true)
		local showData = self.controller:GetShowData()
		CardIconBigItemCtr:SetData(self, self.cardItemLua, showData)
		local cardData = ManagerContainer.CfgMgr:GetCardDataById(showData.cfgId)
		if cardData then
			self.label:SetActive(true)
			self.mVP:SetActive(cardData.CardType == Enum.CardType.MVP)
			self.mini:SetActive(cardData.CardType == Enum.CardType.MINIBOSS)
			self.normal:SetActive(cardData.CardType == Enum.CardType.NORMAL)
		end
		self.item:SetActive(true)
	end

	self:LoadComplete()
end

function UISummonShowView:ArtifactLoadComplete()
	local showData = self.controller:GetShowData()
	local artifactCfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(showData.cfgId)
	if artifactCfgData then
		self.label:SetActive(true)
		self.mVP:SetActive(artifactCfgData.Quality == Enum.CardType.MVP)
		self.mini:SetActive(artifactCfgData.Quality == Enum.CardType.MINIBOSS)
		self.normal:SetActive(artifactCfgData.Quality == Enum.CardType.NORMAL)
	end
	self.artifactSeqId = nil

	if not self.autoRotateContainer then
		self.autoRotateContainer = UnityEngine.GameObject("AutoRotateContainer")
		local aroundSphereMove = self.autoRotateContainer:AddComponent(typeof(AroundSphereMove))
		aroundSphereMove.selfRotateSpeed = 50
		if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
            self.autoRotateContainer.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
        end
	end
	if not self.artifactGo then
		local artifactGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, artifactCfgData.AvatarPrefab)
		if artifactGo then
			artifactGo.transform:SetParent(self.autoRotateContainer.transform)
			artifactGo.transform.localPosition = Vector3.zero
			artifactGo.transform.localRotation = Quaternion.identity
			artifactGo.transform.localScale = Vector3.one
			self.artifactGo = artifactGo
			self.artifactPath = artifactCfgData.AvatarPrefab
		end
	end
	if self.artifactGo then
		self.artifactGo:SetActive(true)
	end

	if not self.previewSystem then
		self.previewSystem = PreviewSystem:new("SummonPreviewSystem", 1024, 1024)
	end
	self.previewSystem:SetView(Vector3(0, 0, 1.435), Quaternion.Euler(0, 180, 0))
	self.modelImg.rawImage.texture = self.previewSystem:GetRenderTexture()
	self.previewSystem:UpdateGo(self.artifactGo)
	self.rT:SetActive(true)

	self:LoadComplete()
end

function UISummonShowView:DefaultLoadComplete()
	self.defaultLoadSeqId = nil
	if not self.iconItemLua then
		local iconItem = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIItemDir, 'IconItem')
		if iconItem then
			iconItem.transform:SetParent(self.item.transform)
			iconItem.transform.localPosition = Vector3.zero
			iconItem.transform.localRotation = Quaternion.identity
			iconItem.transform.localScale = Vector3.one
			self.iconItemLua = CommonUtil.BindGridViewItem2Lua(self, 'IconItem', iconItem.gameObject)
		end
	end
	if self.iconItemLua then
		self.iconItemLua:SetActive(true)
		local showData = self.controller:GetShowData()
		CommonUtil.UpdateItemPrefab(self, self.iconItemLua, showData, Enum.ItemIEnterType.Bag)
		self.item:SetActive(true)
	end

	self:LoadComplete()
end

function UISummonShowView:LoadComplete()
	self.loading = false
	if not self.isPageInEnd then return end
	self.itemShow.animator.enabled = true
	self.itemShow.animator:Play('ItemShow')
	self.particle.uIParticle:PlayCachedParticalSystem(true)
	self.isAniming = true
	if self.controller:GetCurMustShowComplete() then
		if not self.animTimer then
			self.animTimer = Timer.New(function()
				self.isAniming = false
			end, 1.3)
		else
			self.animTimer.time = 1.3
			self.animTimer.duration = 1.3
		end
		if not self.animTimer.running then
			self.animTimer:Start()
		end
	else
		if self.animTimer then
			if self.animTimer.running then
				self.animTimer:Stop()
			end
		end
	end
end

function UISummonShowView:NewRPLoadComplete()
	self.newRpSeqId = nil
	if not self.newRPGo then
		local newRPGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, 'UINewRP')
		if newRPGo then
			newRPGo.transform:SetParent(self.labelNew.transform)
			newRPGo.transform.localPosition = Vector3.zero
			newRPGo.transform.localRotation = Quaternion.identity
			newRPGo.transform.localScale = Vector3.one
			newRPGo:SetActive(true)
			self.newRPGo = newRPGo
		end
	end
end



function UISummonShowView:EnterResultView()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISummonResult, self.controller:GetData())
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

return UISummonShowView

