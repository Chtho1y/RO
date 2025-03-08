local BigMapView = class('BigMapView')
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local ExecuteSequenceData = require('ExecuteSequenceData')

local PointStartItemPath = 'UIBigMap/PointStartItem'
local PointPlayerItemPath = 'UIBigMap/PointPlayerItem'
local PointIconItemPath = 'UIBigMap/PointIconItem'

local MapAreaIconAsyncIdx = 'MapAreaIconAsyncIdx'
local HeadIconAsyncIdx = 'HeadIconAsyncIdx'

function BigMapView:ctor(uiViewBase)
	self.viewBase = uiViewBase
	self.view = uiViewBase.bigMap
	self.loadSystem = MultiTypeAssetLoadSystem:new()
	self.loadSystem:SetCompleteCB(self, self._PreloadedAssets)
	self.storyIconLuaCtrs = {}
	self.storyGoLuaCtrs = {}
	self.executeSequenceData = nil
	self.isExecutePlayEffect = false
	self:_StartPageOpenFrameTimer()
	self:_InitReference()
end

function BigMapView:_StartPageOpenFrameTimer()
	self.pageOpenFrameTimer = FrameTimer.New(function()
		if self.targetAlginPointPos then
			local normalizedPosition = self:_CalcAlginNormalizedPosition(self.targetAlginPointPos)
			self.view.scrollRect.normalizedPosition = normalizedPosition
		end
	end, 1, -1)
	self.pageOpenFrameTimer:Start()
end

function BigMapView:_EndPageOpenFrameTimer()
	if self.pageOpenFrameTimer then
		self.pageOpenFrameTimer:Stop()
	end
	self.pageOpenFrameTimer = nil
end

function BigMapView:Dispose()
	self:_DisposeReference()
	self:_DisposeData()
end

function BigMapView:_DisposeData()
	self.isExecutePlayEffect = nil
	if self.executeSequenceData then
		ManagerContainer.ExecuteSequenceMgr:Exit(self.executeSequenceData)
		self.executeSequenceData = nil
	end
	self.loadSystem:Dispose()
    self.loadSystem = nil
	self.curMapId = nil
	self.curLevelId = nil
	self.showMapId = nil
	self.showRect = nil
	self.mapData = nil
	self.levelDatas = nil
	self.levelPoss = nil
	self.storyIconLuaCtrs = nil
	self.storyGoLuaCtrs = nil
	self.selfPlayerLuaCtr = nil
	self.targetAlginPointPos = nil
	self:_EndPageOpenFrameTimer()
end


function BigMapView:_InitReference()
    local bigPoints = self.view.bigPoints.transform
    local go = bigPoints:Find("BigPoint").gameObject
    go:SetActive(false)
	self.bigPointGo = go
	local smallPoints = self.view.smallPoints.transform
	go = smallPoints:Find("SmallPoint").gameObject
    go:SetActive(false)
    self.smallPointGo = go
    self.bigPoints = {}
	self.smallPoints = {}
end

function BigMapView:_DisposeReference()
	CommonUtil.CloseUIClearAsyncSeqIds(self)
	self:_DisposeSelfPlayerLuaCtr()
	self:_DisposeStoryIconLuaCtrs()
	self:_DisposeStoryGoLuaCtrs()
	self:_DisposeBigPoints()
	self:_DisposeSmallPoints()
	self:_DisposeStartPoint()
	self.bigPointGo = nil
	self.smallPointGo = nil
	self.bigPoints = nil
	self.smallPoints = nil
end

function BigMapView:InitData(curMapId, curLevelId, showMapId, enterType, showRect)
	self.enterType = enterType
	self.curMapId = curMapId
	self.curLevelId = curLevelId
	self.showMapId = showMapId
	self.showRect = showRect
	local cfgMgr = ManagerContainer.CfgMgr
	self.mapData = cfgMgr:GetMapData(showMapId)
	local levelDatas = {}
	local levelPoss = {}
	local levelId = 1
	local levelData = cfgMgr:GetLevelDataByMapAndLevel(showMapId, levelId)
	while (levelData ~= nil) do
		levelDatas[levelId] = levelData
		levelPoss[levelId] = CommonUtil.TableToVector2(levelData.LevelPointCoordinate)
		levelId = levelId + 1
		levelData = cfgMgr:GetLevelDataByMapAndLevel(showMapId, levelId)
	end
	self.levelDatas = levelDatas
	self.levelPoss = levelPoss
	self.levelStartPos = CommonUtil.TableToVector2(self.mapData.AreaStartPos)
	local isCanScroll = enterType ~= Enum.BigMapEnterType.NextLevel
	local scrollRect = self.view.scrollRect
	scrollRect.horizontal = isCanScroll
	scrollRect.vertical = isCanScroll
	self:_RefreshMapBg()
	self:_RefreshPoints()
	if enterType == Enum.BigMapEnterType.NextLevel then
		return
	end
	if self.curMapId == 1 and self.curLevelId == 1 then
		return
	end
	ManagerContainer.DataMgr.BigMapData:SendGetData()
end

function BigMapView:OnLevelChanged(curMapId, curLevelId, showMapId)
	if self.curMapId == curMapId and self.curLevelId == curLevelId and self.showMapId == showMapId then
		return
	end
	if self.enterType and self.enterType ~= Enum.BigMapEnterType.Default then
		return
	end
	self.curMapId = curMapId
	self.curLevelId = curLevelId
	self:RefreshSelfPos()
	self:_DisposeStoryIconLuaCtrs()
	self:_DisposeStoryGoLuaCtrs()
	self:_DisposeBigPoints()
	self:_DisposeSmallPoints()
	self:_DisposeStartPoint()
	self:_RefreshPoints()
end

function BigMapView:RefreshSelfHead()
	local luaCtr = self.selfPlayerLuaCtr
	if not luaCtr then return end

	local headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
	local image = luaCtr.iconImage
	if not image then return end
	image.sprite = nil

	if headIcon then
        CommonUtil.LoadIcon(self, headIcon, function (sprite)
            image.sprite = sprite
        end, self, HeadIconAsyncIdx)
    end
end

function BigMapView:RefreshSelfRank()
	local luaCtr = self.selfPlayerLuaCtr
	if not luaCtr then return end
	local rank, rankPercent = ManagerContainer.DataMgr.BigMapData:GetSelfRankInfo()
	if luaCtr.myRankGo then
		luaCtr.myRankGo:SetActive(rank and rank == 1 or false)
	end
    local contentStr = ''
    if rank then
        contentStr = I18N.SetLanguageValue('MapRanking', rank)
    elseif rankPercent then
        contentStr = I18N.SetLanguageValue('MapPercentage', CommonUtil.GetPreciseDecimal(rankPercent, 2))
    else
        local defaultNum = GlobalConfig.Instance:GetConfigFloatValue(131)
        defaultNum = CommonUtil.GetPreciseDecimal(defaultNum, 2)
        contentStr = I18N.SetLanguageValue('MapPercentage', tostring(defaultNum))
	end
	if luaCtr.dscLeftTxt then
		luaCtr.dscLeftTxt.text = contentStr
	end
	if luaCtr.dscRightTxt then
		luaCtr.dscRightTxt.text = contentStr
	end
end

function BigMapView:RefreshSelfPos()
	local luaCtr = self.selfPlayerLuaCtr
	if not luaCtr then return end
	local mapId = self.showMapId
	local curMapId = self.curMapId
	local go = luaCtr.go
	if mapId ~= curMapId then
		if go then
			go:SetActive(false)
		end
		return
	end
	local curLevelId = self.curLevelId
	local pointPos = self.levelPoss[curLevelId]
	if not pointPos then
		if go then
			go:SetActive(false)
		end
		return
	end
	if go then
		go:SetActive(true)
		go.transform.localPosition = pointPos
	end
	if self:_RectTransformContain(self.view.scrollRect.viewport, luaCtr.dscLeftRect) then
		if luaCtr.dscLeftGo then
			luaCtr.dscLeftGo:SetActive(true)
		end
		if luaCtr.dscRightGO then
			luaCtr.dscRightGO:SetActive(false)
		end
	else
		if luaCtr.dscLeftGo then
			luaCtr.dscLeftGo:SetActive(false)
		end
		if luaCtr.dscRightGO then
			luaCtr.dscRightGO:SetActive(true)
		end
	end
end

function BigMapView:AlginCenter()
	if self.showMapId ~= self.curMapId then
		return
	end
	self:_AlginCenterLevelId(self.curLevelId)
end

function BigMapView:OnPageInEnd()
	if self.isExecutePlayEffect then return end
	if self.targetAlginPointPos then
		self.view.scrollRect.normalizedPosition = self:_CalcAlginNormalizedPosition(self.targetAlginPointPos)
		if self.pageOpenFrameTimer then
			self.pageOpenFrameTimer.duration = 1
			self.pageOpenFrameTimer.loop = 1
			self.pageOpenFrameTimer.count = Time.frameCount + 1
		else
			self.pageOpenFrameTimer = FrameTimer.New(function()
				if self.targetAlginPointPos then
					local normalizedPosition = self:_CalcAlginNormalizedPosition(self.targetAlginPointPos)
					self.view.scrollRect.normalizedPosition = normalizedPosition
				end
			end, 1)
		end
	else
		self:_EndPageOpenFrameTimer()
	end
	self.isExecutePlayEffect = true
	if self.executeSequenceData then
		ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
	end
end

function BigMapView:_AlginCenterLevelId(levelId, moveTime)
	local pointPos = self.levelPoss[levelId]
	if not pointPos then
		return
	end
	self:_AlginCenterPos(pointPos, moveTime)
end

function BigMapView:_AlginCenterPos(pointPos, moveTime)
	if self.isExecutePlayEffect then
		local normalizedPosition = self:_CalcAlginNormalizedPosition(pointPos)
		if moveTime and moveTime > 0 then
			self.view.scrollRect:DONormalizedPos(normalizedPosition, moveTime)
		else
			self.view.scrollRect.normalizedPosition = normalizedPosition
		end
	else
		self.targetAlginPointPos = pointPos
	end
end

function BigMapView:_CalcAlginNormalizedPosition(pointPos)
	local scrollRect = self.view.scrollRect
	local viewport = scrollRect.viewport
	local content = scrollRect.content
	local viewportRect = viewport.rect
	local contentRect = content.rect
	local viewportW = viewportRect.width
	local contentW = contentRect.width
	local vaildW = contentW - viewportW
	local viewportH = viewportRect.height
	local contentH = contentRect.height
	local vaildH = contentH - viewportH
	local valW = Mathf.Clamp01((pointPos.x / vaildW) + 0.5)
	local valH = Mathf.Clamp01((pointPos.y / vaildH) + 0.5)
	return Vector2(valW, valH)
end

-- function BigMapView:RefreshTopPlayerRankAndPos(playerList)
-- 	local oneRank = self.view.oneRank
-- 	if not playerList then
-- 		oneRank:SetActive(false)
-- 		return
-- 	end
-- 	local playerInfo = playerList[1]
-- 	if not playerInfo then
-- 		oneRank:SetActive(false)
-- 		return
-- 	end
-- 	local uid = playerInfo.uid
-- 	local curUserId = ManagerContainer.DataMgr.UserData:GetUserId()
-- 	if int64.equals(curUserId, uid) then
-- 		oneRank:SetActive(false)
-- 		return
-- 	end
-- 	local mapId = playerInfo.mapId
-- 	if mapId ~= self.showMapId then
-- 		oneRank:SetActive(false)
-- 		return
-- 	end
-- 	local mapLevel = playerInfo.mapLevel
-- 	local pointPos = self.levelPoss[mapLevel]
-- 	if not pointPos then
-- 		oneRank:SetActive(false)
-- 		return
-- 	end
-- 	oneRank:SetActive(true)
-- 	oneRank.transform.position = pointPos
-- end

function BigMapView:_RefreshMapBg()
	local mapData = self.mapData
	local image = self.view.bottomImage.image
	image.sprite = nil
	image.enabled = false
	CommonUtil.LoadIcon(self, mapData.AreaPic, function (sprite)
		image.sprite = sprite
		image.enabled = true
	end, self, MapAreaIconAsyncIdx)
	self.view.bottomImage.rectTransform.sizeDelta = CommonUtil.TableToVector2(mapData.PicSize)
	local scrollSize = CommonUtil.TableToVector2(mapData.ScrollSize)
	self.view.content.rectTransform.sizeDelta = scrollSize
end

function BigMapView:_RefreshPoints()
	local uiPath = Constants.UIPath
	local iconDir = Constants.IconDir
	local loadSystem = self.loadSystem
	loadSystem:Cancel()
	loadSystem:RemoveLoadAllAsset()
	local cfgMgr = ManagerContainer.CfgMgr
	local showRect = self.showRect
	local line = self.view.linePath.uIBigMapLine
	local levelDatas = self.levelDatas
	local levelPoss = self.levelPoss
	local levelDataNum = #levelDatas
	local smallStartIdx = 1
	local smallEndIdx = levelDataNum
	local enterType = self.enterType
	local isOneStory = true
	line:ClearPoints()
	local startPos = self.levelStartPos
	if not showRect or showRect:Contains(startPos) then
		self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiPath, PointStartItemPath)
	end
	line:AddPoint(startPos)
	local bigIdx = 1
	for i = 1, levelDataNum do
		local pointPos = levelPoss[i]
		line:AddPoint(pointPos)
		if not showRect or showRect:Contains(pointPos) then
			local levelData = levelDatas[i]
			local pointType = levelData.LevelPointType or 0
			if pointType == 0 then
				bigIdx = self:_GetBigPoint(bigIdx, pointPos)
				if self:_IsPassedPoint(i) then
					smallStartIdx = i + 1
				else
					if not smallEndIdx then
						smallEndIdx = i - 1
					end
					local storySection = levelData.StorySection
					local storySectionData = cfgMgr:GetStorySectionById(storySection)
					if storySectionData then
						local artType = storySectionData.ArtType
						local artRes = storySectionData.ArtRes
						if artType == Enum.StorySectionArtType.Icon then
							loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiPath, PointIconItemPath)
							loadSystem:AddLoadAsset(Enum.ResourceType.Sprite, iconDir, artRes)
						else
							loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiPath, artRes)
						end
						if isOneStory and enterType == Enum.BigMapEnterType.DropPoint then
							isOneStory = false
							if storySectionData.StartDropPos and #storySectionData.StartDropPos > 0 then
								self:_AlginCenterPos(CommonUtil.TableToVector2(storySectionData.StartDropPos))
							end
						end
					end
				end
			end
		end
	end
	line:SetAllDirty()
	if self.curMapId ~= self.showMapId then
		line.passPointIdx = (self.curMapId > self.showMapId and levelDataNum or 0)
	else
		line.passPointIdx = self.curLevelId
	end
	local smallIdx = 1
	if self.enterType ~= Enum.BigMapEnterType.DropPoint then
		if smallStartIdx < smallEndIdx and smallEndIdx <= levelDataNum then
			for i = smallStartIdx, smallEndIdx do
				local levelData = levelDatas[i]
				local pointType = levelData.LevelPointType or 0
				if pointType == 0 then
					break
				end
				smallIdx = self:_GetSmallPoint(smallIdx, levelPoss[i])
				local storySection = levelData.StorySection
				local storySectionData = cfgMgr:GetStorySectionById(storySection)
				if storySectionData then
					local artType = storySectionData.ArtType
					local artRes = storySectionData.ArtRes
					if artType == Enum.StorySectionArtType.Icon then
						loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiPath, PointIconItemPath)
						loadSystem:AddLoadAsset(Enum.ResourceType.Sprite, iconDir, artRes)
					else
						loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiPath, artRes)
					end
				end
			end
		end
	end
	for i = smallIdx, #self.smallPoints do
		self.smallPoints[i]:SetActive(false)
	end
	if self:_IsSelfAtCurMap() then
		if not self.selfPlayerLuaCtr then
			loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiPath, PointPlayerItemPath)
		end
		if isOneStory then
			self:AlginCenter()
		end
	else
		self:_DisposeSelfPlayerLuaCtr()
	end
	loadSystem:Begin()
end

function BigMapView:_PreloadedAssets()
	local uiPath = Constants.UIPath
	local enterType = self.enterType
	local cfgMgr = ManagerContainer.CfgMgr
	local resMgr = ManagerContainer.ResMgr
	local showRect = self.showRect
	local levelDatas = self.levelDatas
	local levelPoss = self.levelPoss
	local levelDataNum = #levelDatas
	local isOneStory = true
	local uiStoryMgr = nil
	if enterType == Enum.BigMapEnterType.DropPoint then
		self.executeSequenceData = ExecuteSequenceData:new()
		uiStoryMgr = ManagerContainer.UIStoryMgr
	end

	local startPos = self.levelStartPos
	if self:_IsSelfAtCurMap() then
		if not self.selfPlayerLuaCtr then
			local selfGoItem = resMgr:GetGoFromPool(uiPath, PointPlayerItemPath)
			local iconImage, myRankGo, dscLeftGo, dscLeftTxt, dscRightGO, dscRightTxt, selfGoAnimator
			if selfGoItem then
				local selfGoItemTrans = selfGoItem.transform
				selfGoItemTrans:SetParent(self.view.selfContainer.transform, false)
				selfGoItemTrans.localPosition = startPos
				selfGoItemTrans.localRotation = Quaternion.identity
				selfGoItemTrans.localScale = Vector3.one
				iconImage = selfGoItemTrans:Find('Root/Item/Content/Icon'):GetComponent(Enum.TypeInfo.Image)
				myRankGo = selfGoItemTrans:Find('Root/Item/MyRank').gameObject
				dscLeftGo = selfGoItemTrans:Find('Root/DscLeft').gameObject
				dscLeftTxt = selfGoItemTrans:Find('Root/DscLeft/DesTxt'):GetComponent(Enum.TypeInfo.Text)
				dscRightGO = selfGoItemTrans:Find('Root/DscRight').gameObject
				dscRightTxt = selfGoItemTrans:Find('Root/DscRight/DesTxt'):GetComponent(Enum.TypeInfo.Text)
				selfGoAnimator = selfGoItem:GetComponent(Enum.TypeInfo.Animator)
			end
			local luaCtr = {}
			luaCtr.go = selfGoItem
			luaCtr.iconImage = iconImage
			luaCtr.myRankGo = myRankGo
			luaCtr.dscLeftGo = dscLeftGo
			if dscLeftGo then
				luaCtr.dscLeftRect = dscLeftGo:GetComponent(Enum.TypeInfo.RectTransform)
			end
			luaCtr.dscLeftTxt = dscLeftTxt
			luaCtr.dscRightGO = dscRightGO
			luaCtr.dscRightTxt = dscRightTxt
			luaCtr.animator = selfGoAnimator
			self.selfPlayerLuaCtr = luaCtr
		end

		self:RefreshSelfHead()
		self:RefreshSelfRank()
		self:RefreshSelfPos()
		if enterType ~= Enum.BigMapEnterType.DropPoint then
			self:AlginCenter()
		end
	end
	if not showRect or showRect:Contains(startPos) then
		self:_CreateStartPoint(startPos)
	end
	local smallStartIdx = 1
	local smallEndIdx = levelDataNum
	for i = 1, levelDataNum do
		local pointPos = levelPoss[i]
		if not showRect or showRect:Contains(pointPos) then
			if self:_IsPassedPoint(i) then
				smallStartIdx = i + 1
			else
				if not smallEndIdx then
					smallEndIdx = i - 1
				end
				local levelData = levelDatas[i]
				local pointType = levelData.LevelPointType or 0
				if pointType == 0 then
					local storySection = levelData.StorySection
					local storySectionData = cfgMgr:GetStorySectionById(storySection)
					if storySectionData then
						if enterType == Enum.BigMapEnterType.DropPoint then
							local startDropMoveTime = storySectionData.StartDropMoveTime
							if storySectionData.StartDropPos and #storySectionData.StartDropPos > 0 then
								self.executeSequenceData:AppendFunc(false, self, self._AlginCenterPos, CommonUtil.TableToVector2(storySectionData.StartDropPos), startDropMoveTime)
								if (startDropMoveTime and startDropMoveTime > 0) then
									self.executeSequenceData:AppendInterval(startDropMoveTime)
								end
							end
							if isOneStory and self.selfPlayerLuaCtr then
								isOneStory = false
								if self.selfPlayerLuaCtr.go then
									self.selfPlayerLuaCtr.go:SetActive(false)
								end
								self.executeSequenceData:AppendFunc(false, self, self._PlayFallDownAnim, self.selfPlayerLuaCtr)
								self.executeSequenceData:AppendInterval(1)
							end
							if storySectionData.StartDropDlgId > 0 then
								-- 需要至少延迟一帧时间，避免对话框刚刚关闭就需要打开，导致逻辑混乱
								self.executeSequenceData:AppendFrameInterval(1)
								self.executeSequenceData:AppendFunc(false, uiStoryMgr, uiStoryMgr.MapStartStoryByStoryId, storySectionData.StartDropDlgId)
								self.executeSequenceData:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
							end
						end
						local artType = storySectionData.ArtType
						local artRes = storySectionData.ArtRes
						if artType == Enum.StorySectionArtType.Icon then
							local luaCtr = self:_CreateStoryIconLuaCtr(i, artRes, pointPos)
							if enterType == Enum.BigMapEnterType.DropPoint then
								if luaCtr.go then
									luaCtr.go:SetActive(false)
								end
								self.executeSequenceData:AppendFunc(false, self, self._PlayFallDownAnim, luaCtr)
							elseif enterType == Enum.BigMapEnterType.Default then
								self.viewBase.uiBase:AddButtonUniqueEventListener(luaCtr.button, self, self._OnClickStoryItem, i)
							end
						else
							local luaCtr = self:_CreateStoryGoLuaCtr(i, artRes, pointPos)
							if enterType == Enum.BigMapEnterType.DropPoint then
								if luaCtr.go then
									luaCtr.go:SetActive(false)
								end
								self.executeSequenceData:AppendFunc(false, self, self._PlayFallDownAnim, luaCtr)
							elseif enterType == Enum.BigMapEnterType.Default then
								self.viewBase.uiBase:AddButtonUniqueEventListener(luaCtr.button, self, self._OnClickStoryItem, i)
							end
						end
						if enterType == Enum.BigMapEnterType.DropPoint then
							self.executeSequenceData:AppendInterval(1)
							if storySectionData.EndDropDlgId > 0 then
								self.executeSequenceData:AppendFunc(false, uiStoryMgr, uiStoryMgr.MapStartStoryByStoryId, storySectionData.EndDropDlgId)
								self.executeSequenceData:AppendUIListener(Enum.UIPageName.UIStory, UIEventNames.UI_PAGE_OUT_END_NTF)
							end
						end
					end
				end
			end
		end
	end

	if enterType ~= Enum.BigMapEnterType.DropPoint then
		if smallStartIdx < smallEndIdx and smallEndIdx <= levelDataNum then
			for i = smallStartIdx, smallEndIdx do
				local levelData = levelDatas[i]
				local pointType = levelData.LevelPointType or 0
				if pointType == 0 then
					break
				end
				if not self:_IsPassedPoint(i) then
					local storySection = levelData.StorySection
					local storySectionData = cfgMgr:GetStorySectionById(storySection)
					if storySectionData then
						local artType = storySectionData.ArtType
						local artRes = storySectionData.ArtRes
						local pointPos = levelPoss[i]
						local luaCtr = nil
						if artType == Enum.StorySectionArtType.Icon then
							luaCtr = self:_CreateStoryIconLuaCtr(i, artRes, pointPos)
						else
							luaCtr = self:_CreateStoryGoLuaCtr(i, artRes, pointPos)
						end
						if luaCtr and enterType == Enum.BigMapEnterType.Default then
							self.viewBase.uiBase:AddButtonUniqueEventListener(luaCtr.button, self, self._OnClickStoryItem, i)
						end
					end
				end
			end
		end
	end

	if enterType == Enum.BigMapEnterType.DropPoint then
		if not self.executeSequenceData:HasDelayMethod() then
			self.executeSequenceData:AppendInterval(1)
		end
		self.executeSequenceData:AppendFunc(false, self, self._FallDownComplete)
		if self.isExecutePlayEffect then
			ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
		end
	elseif enterType == Enum.BigMapEnterType.NextLevel then
		self:_PlayNextLevelEffect()
	end
end

function BigMapView:_OnClickStoryItem(btn, params)
	local levelId = params[0]
	local levelData = self.levelDatas[levelId]
	if not levelData then return end
	local storySection = levelData.StorySection
	local storySectionData = ManagerContainer.CfgMgr:GetStorySectionById(storySection)
	if not storySectionData then return end
	if storySectionData.ClickDlgId > 0 then
		ManagerContainer.UIStoryMgr:MapStartStoryByStoryId(storySectionData.ClickDlgId)
	end
end

function BigMapView:_PlayFallDownAnim(luaCtr)
	if luaCtr.go then
		luaCtr.go:SetActive(true)
	end
	self:_PlayAnim(luaCtr, 'PointDropDown')
end

function BigMapView:_PlayAnim(luaCtr, animName)
	if luaCtr.animator then
		luaCtr.animator:Play(animName)
	end
end

function BigMapView:_FallDownComplete()
	self.viewBase:BigMapViewComplete()
end

function BigMapView:_PlayNextLevelEffect()
	if not self:_IsSelfAtCurMap() then return end
	local nextLevelId = self.curLevelId + 1
	local levelData = self.levelDatas[nextLevelId]
	if not levelData then return end
	if not self.selfPlayerLuaCtr then return end
	local pointUpAnimTime = 0.2
	local pointFlyAnimTime = 1
	local pointDownTime = 2
	if self.selfPlayerLuaCtr.animator then
		local runtimeAnimatorController = self.selfPlayerLuaCtr.animator.runtimeAnimatorController
		if runtimeAnimatorController then
			if runtimeAnimatorController:GetType() == typeof(UnityEngine.AnimatorOverrideController) then
				runtimeAnimatorController = runtimeAnimatorController.this
				local clip = runtimeAnimatorController:get('PointUp')
				if clip then pointUpAnimTime = clip.length end
				clip = runtimeAnimatorController:get('PointFly')
				if clip then pointFlyAnimTime = clip.length end
				clip = runtimeAnimatorController:get('PointDown')
				if clip then pointDownTime = clip.length end
			else
				local clips = runtimeAnimatorController.animationClips
				for i = 0, clips.Length - 1 do
					local clip = clips[i]
					if clip then
						local clipName = clip.name
						if clipName == 'PointUp' then
							pointUpAnimTime = clip.length
						elseif clipName == 'PointFly' then
							pointFlyAnimTime = clip.length
						elseif clipName == 'PointDown' then
							pointDownTime = clip.length
						end
					end
				end
			end
		end
	end
	self.executeSequenceData = ExecuteSequenceData:new()
	self.executeSequenceData:AppendFunc(false, self, self._PlayAnim, self.selfPlayerLuaCtr, 'PointUp')
	self.executeSequenceData:AppendInterval(pointUpAnimTime)
	self.executeSequenceData:AppendFunc(false, self, self._PlayAnim, self.selfPlayerLuaCtr, 'PointFly')
	self.executeSequenceData:AppendFunc(false, self, self._PlayMoveToNextLevel, pointFlyAnimTime)
	self.executeSequenceData:AppendInterval(pointFlyAnimTime)
	self.executeSequenceData:AppendFunc(false, self, self._PlayAnim, self.selfPlayerLuaCtr, 'PointDown')
	self.executeSequenceData:AppendFunc(false, self, self._MoveToNextLevelDeleteStorySection)
	self.executeSequenceData:AppendInterval(pointDownTime)
	self.executeSequenceData:AppendFunc(false, self, self._MoveToNextLevelComplete)
	if self.isExecutePlayEffect then
		ManagerContainer.ExecuteSequenceMgr:Execute(self.executeSequenceData)
	end
end

function BigMapView:_PlayMoveToNextLevel(time)
	local nextLevelId = self.curLevelId + 1
	local levelPos = self.levelPoss[nextLevelId]
	if not levelPos then return end
	if not self.selfPlayerLuaCtr then return end
	if not self.selfPlayerLuaCtr.go then return end
	self.selfPlayerLuaCtr.go.transform:DOLocalMove(levelPos, time)
end

function BigMapView:_MoveToNextLevelDeleteStorySection()
	local nextLevelId = self.curLevelId + 1
	self.view.linePath.uIBigMapLine.passPointIdx = nextLevelId
	local levelData = self.levelDatas[nextLevelId]
	if not levelData then return end
	local storySection = levelData.StorySection
	local storySectionData = ManagerContainer.CfgMgr:GetStorySectionById(storySection)
	if not storySectionData then return end
	local artType = storySectionData.ArtType
	if artType == Enum.StorySectionArtType.Icon then
		-- self:_DisposeStoryIconLuaCtr(self.curLevelId + 1)
		local luaCtr = self.storyIconLuaCtrs[nextLevelId]
		if luaCtr then
			if luaCtr.go then
				luaCtr.go:SetActive(false)
			end
			local levelPos = nil
			if luaCtr.image then
				levelPos = luaCtr.image.transform.position
			end
			if not levelPos then
				levelPos = self.levelPoss[nextLevelId]
				levelPos = self.view.content.rectTransform:TransformPoint(levelPos)
			end
			-- 为了完美衔接道具掉落的表现
			if storySectionData.Type == Enum.StorySectionEventType.GotItem
				or storySectionData.Type == Enum.StorySectionEventType.UnlockHangBox
				or storySectionData.Type == Enum.StorySectionEventType.UnlockTask then
				self.executeSequenceData:InsertNextUIListener(Enum.UIPageName.UIPopGotSingle, UIEventNames.UI_PAGE_IN_END_NTF)
				self.hasNextStory = ManagerContainer.StoryMgr:StartStorySection(storySection, levelPos)
			end
		end
	else
		-- self:_DisposeStoryGoLuaCtr(self.curLevelId + 1)
		local luaCtr = self.storyGoLuaCtrs[nextLevelId]
		if luaCtr then
			if luaCtr.go then
				luaCtr.go:SetActive(false)
			end
		end
	end
end

function BigMapView:_MoveToNextLevelComplete()
	local nextLevelId = self.curLevelId + 1
	local levelData = self.levelDatas[nextLevelId]
    if levelData then
        local luaCtr = self.storyIconLuaCtrs[nextLevelId]
        local levelPos = nil
        if luaCtr and luaCtr.image then
            levelPos = luaCtr.image.transform.position
        end
        if not levelPos then
            levelPos = self.levelPoss[nextLevelId]
            levelPos = self.view.content.rectTransform:TransformPoint(levelPos)
        end
		local storySection = levelData.StorySection
		local storySectionData = ManagerContainer.CfgMgr:GetStorySectionById(storySection)
		if storySectionData then
			if storySectionData.Type ~= Enum.StorySectionEventType.GotItem
				and storySectionData.Type ~= Enum.StorySectionEventType.UnlockHangBox
				and storySectionData.Type ~= Enum.StorySectionEventType.UnlockTask then
				self.hasNextStory = ManagerContainer.StoryMgr:StartStorySection(storySection, levelPos)

				self:_DisposeStoryIconLuaCtr(nextLevelId)
				self:_DisposeStoryGoLuaCtr(nextLevelId)
				self.viewBase:BigMapViewComplete(self.hasNextStory)
				return
			end
		end
    end

	self:_DisposeStoryIconLuaCtr(nextLevelId)
	self:_DisposeStoryGoLuaCtr(nextLevelId)
	self.viewBase:BigMapViewComplete(self.hasNextStory)
	--ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER, true)
end

function BigMapView:_GetBigPoint(idx, pointPos)
	local point = self.bigPoints[idx]
	if not point then
		point = CommonUtil.Instantiate(self.bigPointGo, self.view.bigPoints.transform)
		if tolua.getpeer(point) == nil then
			tolua.setpeer(point, {})
		end
		-- point.button = point:GetComponent(Enum.TypeInfo.Button)
		self.bigPoints[idx] = point
	end
	point:SetActive(true)
	point.transform.localPosition = pointPos
	return idx + 1
end

function BigMapView:_DisposeBigPoints()
	for _, bigPoint in pairs(self.bigPoints) do
		if bigPoint then
			CommonUtil.DestroyGO(bigPoint)
			if tolua.getpeer(bigPoint) ~= nil then
				tolua.setpeer(bigPoint, nil)
			end
		end
	end
end

function BigMapView:_GetSmallPoint(idx, pointPos)
	local point = self.smallPoints[idx]
	if not point then
		point = CommonUtil.Instantiate(self.smallPointGo, self.view.smallPoints.transform)
		if tolua.getpeer(point) == nil then
			tolua.setpeer(point, {})
		end
		-- point.button = point:GetComponent(Enum.TypeInfo.Button)
		self.smallPoints[idx] = point
	end
	point:SetActive(true)
	point.transform.localPosition = pointPos
	return idx + 1
end

function BigMapView:_DisposeSmallPoints()
	for _, smallPoint in pairs(self.smallPoints) do
		if smallPoint then
			CommonUtil.DestroyGO(smallPoint)
			if tolua.getpeer(smallPoint) ~= nil then
				tolua.setpeer(smallPoint, nil)
			end
		end
	end
end

function BigMapView:_CreateStartPoint(pointPos)
	if not self.startPoint then
		local startItem = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, PointStartItemPath)
		self.startPoint = startItem
	end
	if self.startPoint then
		local startItemTrans = self.startPoint.transform
		startItemTrans:SetParent(self.view.startPoint.transform, false)
		startItemTrans.localPosition = pointPos
		startItemTrans.localRotation = Quaternion.identity
		startItemTrans.localScale = Vector3.one
		self.startPoint:SetActive(true)
	end
end


function BigMapView:_DisposeStartPoint()
	if self.startPoint then
		ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, PointStartItemPath, self.startPoint)
		self.startPoint = nil
	end
end

function BigMapView:_CreateStoryIconLuaCtr(levelId, artRes, pointPos)
	local iconItem = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, PointIconItemPath)
	local iconAnimator, iconImage, button
	if iconItem then
		local iconItemTrans = iconItem.transform
		iconItemTrans:SetParent(self.view.storyPoints.transform, false)
		iconItem:SetActive(true)
		iconItemTrans.localPosition = pointPos
		iconItemTrans.localRotation = Quaternion.identity
		iconItemTrans.localScale = Vector3.one
		iconAnimator = iconItem:GetComponent(Enum.TypeInfo.Animator)
		iconImage = iconItemTrans:Find('Root/Item/Content/Icon'):GetComponent(Enum.TypeInfo.Image)
		button = iconItemTrans:Find('Root/Button'):GetComponent(Enum.TypeInfo.Button)
		iconImage.sprite = ManagerContainer.ResMgr:GetAsset(Constants.IconDir, artRes)
		iconAnimator:Play('PointKeep')
	end
	local luaCtr = {}
	luaCtr.go = iconItem
	luaCtr.image = iconImage
	luaCtr.button = button
	luaCtr.animator = iconAnimator
	self.storyIconLuaCtrs[levelId] = luaCtr
	return luaCtr
end

function BigMapView:_DisposeStoryIconLuaCtrs()
	for i = #self.levelDatas, 1, -1 do
		self:_DisposeStoryIconLuaCtr(i)
	end
end

function BigMapView:_DisposeStoryIconLuaCtr(levelId)
	local luaCtr = self.storyIconLuaCtrs[levelId]
	if luaCtr then
		if luaCtr.go then
			ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, PointIconItemPath, luaCtr.go)
		end
		if luaCtr.image then
			luaCtr.image.sprite = nil
		end
		luaCtr.go = nil
		luaCtr.image = nil
		luaCtr.animator = nil
		self.storyIconLuaCtrs[levelId] = nil
	end
end

function BigMapView:_CreateStoryGoLuaCtr(levelId, artRes, pointPos)
	local goItem = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, artRes)
	local goAnimator, button
	if goItem then
		local goItemTrans = goItem.transform
		goItemTrans:SetParent(self.view.storyPoints.transform, false)
		goItem:SetActive(true)
		goItemTrans.localPosition = pointPos
		goItemTrans.localRotation = Quaternion.identity
		goItemTrans.localScale = Vector3.one
		goAnimator = goItem:GetComponent(Enum.TypeInfo.Animator)
		button = goItemTrans:Find('Root/Button'):GetComponent(Enum.TypeInfo.Button)
		goAnimator:Play('PointKeep')
	end
	local luaCtr = {}
	luaCtr.go = goItem
	luaCtr.assetName = artRes
	luaCtr.button = button
	luaCtr.animator = goAnimator
	self.storyGoLuaCtrs[levelId] = luaCtr
	return luaCtr
end

function BigMapView:_DisposeStoryGoLuaCtrs()
	for i = #self.levelDatas, 1, -1 do
		self:_DisposeStoryGoLuaCtr(i)
	end
end

function BigMapView:_DisposeStoryGoLuaCtr(levelId)
	local luaCtr = self.storyGoLuaCtrs[levelId]
	if luaCtr then
		if luaCtr.go then
			ManagerContainer.ResMgr:RecycleGO(uiPath, luaCtr.assetName, luaCtr.go)
		end
		luaCtr.go = nil
		luaCtr.assetName = nil
		luaCtr.animator = nil
		self.storyGoLuaCtrs[levelId] = nil
	end
end

function BigMapView:_DisposeSelfPlayerLuaCtr()
	if not self.selfPlayerLuaCtr then return end
	local luaCtr = self.selfPlayerLuaCtr
	ManagerContainer.ResMgr:RecycleGO(Constants.UIPath, PointPlayerItemPath, luaCtr.go)
	luaCtr.go = nil
	luaCtr.iconImage = nil
	luaCtr.myRankGo = nil
	luaCtr.dscLeftGo = nil
	luaCtr.dscLeftRect = nil
	luaCtr.dscLeftTxt = nil
	luaCtr.dscRightGO = nil
	luaCtr.dscRightTxt = nil
	luaCtr.animator = nil
	self.selfPlayerLuaCtr = nil
end



function BigMapView:_IsSelfAtCurMap()
	return self.showMapId == self.curMapId
end

function BigMapView:_IsPassedPoint(levelId)
	if self.showMapId == self.curMapId then
		return self.curLevelId >= levelId
	else
		return (self.curMapId > self.showMapId)
	end
end


function BigMapView:_RectTransformContain(a, b)
	if not a or not b then return false end
	local rectA = a.rect
	local minA = a:TransformPoint(rectA.min)
	local maxA = a:TransformPoint(rectA.max)
	local rectB = b.rect
	local minB = b:TransformPoint(rectB.min)
	local maxB = b:TransformPoint(rectB.max)
	return (minB.x >= minA.x and minB.x < maxA.x and minB.y >= minA.y and minB.y < maxA.y
			and maxB.x >= minA.x and maxB.x < maxA.x and maxB.y >= minA.y and maxB.y < maxA.y)
end

return BigMapView