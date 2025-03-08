local UIWorldMapView = require("UIBigMap/UIWorldMapView_Generate")

local DOTween = DG.Tweening.DOTween

local MAINLAND_KEY = "MainLand"
local MAP_KEY = "map"

function UIWorldMapView:OnAwake(data)
	self.controller = require("UIBigMap/UIWorldMapCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIWorldMapView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BIGMAP_TOPPLAYER_RANK_CHANGED, self, self.RefreshTopPlayerRankAndPos)
end

function UIWorldMapView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIWorldMapView:Init()
	self:RefreshMapLit()
	self:RefreshTopPlayerRank()
	self:RefreshSelfPos()
	self:RefreshOnePos()
	self:AlginCenter()
	self.selected:SetActive(false)
	self.inputMask:SetActive(false)
end

function UIWorldMapView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIWorldMapView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	for i = 1, 3 do
		local topRank = self.rankContainer['topRank' .. i]
		if topRank then
			self.uiBase:AddButtonUniqueEventListener(topRank.button, self, self.OnClickBtnTopRank, i)
		end
	end
	self.uiBase:AddButtonUniqueEventListener(self.onePos.button, self, self.OnClickOnePos)
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBtnBack)
	self.uiBase:AddButtonUniqueEventListener(self.selected.button, self, self.OnClickSelected)
end

function UIWorldMapView:OnHide()

end

function UIWorldMapView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIWorldMapView:OnClose()
end

function UIWorldMapView:OnDispose()
	self.selectedMapLastPos = nil
	self.selectedSignLastPos = nil
	self:StopMoveToNextMap()
end

function UIWorldMapView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:PlayMoveToNextMap()
end

function UIWorldMapView:RefreshMapLit()
	local curMapId = self.controller:GetCurMapId()
	local showMapId = self.controller:GetShowMapId()
	for i = curMapId, 1, -1 do
		local mapLua = self:GetMapLua(i)
		if mapLua then
			mapLua.map:SetActive(i <= showMapId)
			self.uiBase:AddButtonUniqueEventListener(mapLua.map.image.button, self, self.OnClickMap, i)
		end
	end
end

function UIWorldMapView:RefreshTopPlayerRankAndPos()
	self:RefreshTopPlayerRank()
	self:RefreshOnePos()
end

function UIWorldMapView:RefreshTopPlayerRank()
	local playerList = self.controller:GetTopRankPlayerList()
	self.rankContainer:SetActive(true)
	local length = playerList and #playerList or 0
	for i = 3, 1, -1 do
		local keyName = 'topRank' .. i
		local topRank = self.rankContainer[keyName]
		if length < i then
			topRank:SetActive(false)
		else
			topRank:SetActive(true)
			local playerInfo = playerList[i]
			local mapId = playerInfo.mapId
			local mapLevel = playerInfo.mapLevel
			local useName = playerInfo.nickName
			local headId = playerInfo.headId
			topRank.nameTxt.text.text = useName
			topRank.orderTxt.text.text = self.controller:GetMapName(mapId, mapLevel)

			local roleId     = CommonUtil.JobIdToRoleId(playerInfo.jobId,playerInfo.sex)
			local roleCfg    = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
			local headIcon = (roleCfg and roleCfg.HeadId or '')

			local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerInfo.jobId)

			local _fakerData = {Level = playerInfo.level, ProfessionIcon = jobCfg.JobIcon, HeadIcon = headIcon, IsHero = true}
			topRank.headNode.headItem.head.button.enabled = false
			CommonUtil.SetPlayerHeadAndFrame(self, topRank.headNode.headItem,  _fakerData, false, playerInfo.headFrameId)
		end
	end
end

function UIWorldMapView:RefreshSelfPos()
	local contentStr = self.controller:GetShowMapName()
	self.selfPos.dscLeft.desTxt.text.text = contentStr
	self.selfPos.dscRight.desTxt.text.text = contentStr
	if self:RectTransformContain(self.scrollView.scrollRect.content, self.selfPos.dscLeft.rectTransform) then
		self.selfPos.dscLeft:SetActive(true)
		self.selfPos.dscRight:SetActive(false)
	else
		self.selfPos.dscLeft:SetActive(false)
		self.selfPos.dscRight:SetActive(true)
	end
	local curMapId = self.controller:GetShowMapId()
	local mapLua = self:GetMapLua(curMapId)
	if not mapLua then
		self.selfPos:SetActive(false)
		return
	end
	self.selfPos:SetActive(true)
	self.selfPos.transform.position = mapLua.pos.transform.position
end

function UIWorldMapView:RefreshOnePos()
	local playerList = self.controller:GetTopRankPlayerList()
	if not playerList or not playerList[1] then
		self.onePos:SetActive(false)
		return
	end
	local mapId = playerList[1].mapId
	local mapLua = self:GetMapLua(mapId)
	if not mapLua then
		self.onePos:SetActive(false)
		return
	end
	self.onePos:SetActive(true)
	-- local curMapId = self.controller:GetCurMapId()
	-- local pos
	-- if curMapId == mapId then
	-- 	pos = Vector3.zero
	-- 	if self.selfPos.dscLeft.activeSelf then
	-- 		pos.x = pos.x + 100
	-- 	else
	-- 		pos.x = pos.x - 100
	-- 	end
	-- 	pos = mapLua.pos.transform:TransformPoint(pos)
	-- else
	-- 	pos = mapLua.pos.transform.position
	-- end
	-- self.onePos.transform.position = pos
	self.onePos.transform.position = mapLua.pos.transform.position
end

function UIWorldMapView:AlginCenter()
	local curMapId = self.controller:GetShowMapId()
	local mapLua = self:GetMapLua(curMapId)
	if mapLua then
		local scrollRect = self.scrollView.scrollRect
		local viewport = scrollRect.viewport
		local content = scrollRect.content
		local viewportW = viewport.rect.width
		local contentW = content.rect.width
		local vaildW = contentW - viewportW
		local pos = content:InverseTransformPoint(mapLua.pos.transform.position)
		local val = Mathf.Clamp01((pos.x -  viewportW * 0.5) / vaildW)
		scrollRect.horizontalNormalizedPosition = val
	end
end

function UIWorldMapView:OnClickOnePos()
	-- 显示玩家详细信息
	local playerList = self.controller:GetTopRankPlayerList()
	if not playerList then
		return
	end
	local playerInfo = playerList[1]
	if not playerInfo then return end
	local uid = playerInfo.uid
	if not uid then return end
	local curUserId = ManagerContainer.DataMgr.UserData:GetUserId()
	if int64.equals(curUserId, uid) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
	else
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
	end
end

function UIWorldMapView:OnClickBtnTopRank(btn, params)
	local i = params[0]
	-- 显示玩家详细信息
	local playerList = self.controller:GetTopRankPlayerList()
	if not playerList then
		return
	end
	local playerInfo = playerList[i]
	if not playerInfo then return end
	local uid = playerInfo.uid
	if not uid then return end
	local curUserId = ManagerContainer.DataMgr.UserData:GetUserId()
	if int64.equals(curUserId, uid) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
	else
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
	end
end

function UIWorldMapView:OnClickBtnBack()
	self:UIClose()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBigMap, {id = self.controller:GetCurMapId()}, nil, nil, false)
end

function UIWorldMapView:OnClickMap(btn, params)
	local mapId = params[0]
	local mapLua = self:GetMapLua(mapId)
	if not mapLua then return end
	if self.lastSelectMapId == mapId then
		self:OnClickSelected()
		self:UIClose()
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBigMap, {id = mapId}, nil, nil, false)
		return
	end
	self.lastSelectMapId = mapId
	self.selected:SetActive(true)
	self.selectedMapLastPos = mapLua.map.transform.localPosition
	self.selectedSignLastPos = self.sign.transform.localPosition
	mapLua.map.transform:SetParent(self.selected.transform)
	self.sign.transform:SetParent(self.selected.transform)
	mapLua.map.animator:Play("MapSelected")
end

function UIWorldMapView:OnClickSelected()
	local mapId = self.lastSelectMapId
	if not mapId then return end
	local mapLua = self:GetMapLua(mapId)
	if not mapLua then return end
	self.lastSelectMapId = nil
	mapLua.map.animator:Play("MapActived")
	mapLua.map.transform:SetParent(mapLua.transform)
	mapLua.map.transform:SetAsFirstSibling()
	self.sign.transform:SetParent(self.scrollView.scrollRect.content.transform)
	self.sign.transform:SetAsLastSibling()
	self.selected:SetActive(false)
	if self.selectedMapLastPos then
		mapLua.map.transform.localPosition = self.selectedMapLastPos
		self.selectedMapLastPos = nil
	end
	if self.selectedSignLastPos then
		self.sign.transform.localPosition = self.selectedSignLastPos
		self.selectedSignLastPos = nil
	end
end


function UIWorldMapView:PlayMoveToNextMap()
	local isChangeMap = self.controller:IsChangeMap()
	if not isChangeMap then
		self:StopMoveToNextMap()
		return
	end
	-- 判断新区域是否在屏幕内
	local scrollRect = self.scrollView.scrollRect
	local viewport = scrollRect.viewport
	local content = scrollRect.content
	local viewportW = viewport.rect.width
	local contentW = content.rect.width
	local vaildW = contentW - viewportW
	local curMapId = self.controller:GetCurMapId()
	local mapLua = self:GetMapLua(curMapId)
	if not mapLua then
		self:StopMoveToNextMap()
		return
	end
	self:OnClickSelected()
	self.inputMask:SetActive(true)
	local seq = DOTween.Sequence()
	self.mtnmSeq = seq
	self.selfPos.dscLeft:SetActive(false)
	self.selfPos.dscRight:SetActive(false)
	mapLua.map:SetActive(true)
	mapLua.map.animator:Play("MapUnlock")
	local time1 = 0.5
	local time2 = 0.2
	local time3 = 0.5
	local time4 = 0.1
	local timeCfg = GlobalConfig.Instance:GetConfigStrValue(145)
	if timeCfg then
		local timeArr = string.split(timeCfg, ';')
		if timeArr then
			time1 = timeArr[1] and tonumber(timeArr[1]) or time1
			time2 = timeArr[2] and tonumber(timeArr[2]) or time2
			time3 = timeArr[3] and tonumber(timeArr[3]) or time3
			time4 = timeArr[4] and tonumber(timeArr[4]) or time4
		end
	end
	seq:AppendInterval(time1)
	if self:RectTransformContain(viewport, mapLua.transform) then
		seq:Append(self.selfPos.transform:DOMove(mapLua.pos.transform.position, time2))
	else
		local targetPos = content:InverseTransformPoint(mapLua.pos.transform.position)
		local curPos = content:InverseTransformPoint(self.selfPos.transform.position)
		local val = scrollRect.horizontalNormalizedPosition
		scrollRect.horizontalNormalizedPosition = Mathf.Clamp01((targetPos.x -  viewportW * 0.5) / vaildW)
		seq:AppendCallback(function()
			scrollRect.horizontalNormalizedPosition = val
		end)
		local tweener = DOTween.To(DG.Tweening.Core.DOGetter_UnityEngine_Vector3(function()
			return curPos
		end), DG.Tweening.Core.DOSetter_UnityEngine_Vector3(function (value)
			curPos = value
			scrollRect.horizontalNormalizedPosition = Mathf.Clamp01((curPos.x -  viewportW * 0.5) / vaildW)
			self.selfPos.transform.position = content:TransformPoint(curPos)
		end), targetPos, time3)
		seq:Append(tweener)
	end
	seq:AppendInterval(time4)
	seq:AppendCallback(function()
		self:StopMoveToNextMap()
	end)
end

function UIWorldMapView:StopMoveToNextMap()
	if self.mtnmSeq then
		self.mtnmSeq:Kill()
		self.mtnmSeq = nil
	end
	self.inputMask:SetActive(false)
	if self.controller:IsChangeMap() then
		self:UIClose()
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BIGMAP_ENTER_NEXTMAP_END)
	end
end


























function UIWorldMapView:GetMapLua(mapId)
	local key = MAP_KEY .. tostring(mapId)
	local mapLua = self[key]
	if mapLua then
		return mapLua
	else
		LogError("Not Find Map's transform. mapId : " .. tostring(mapId))
		return nil
	end
end

--- 是否a 包含 b
function UIWorldMapView:RectTransformContain(a, b)
	local rectA = a.rect
	local minA = a:TransformPoint(rectA.min)
	local maxA = a:TransformPoint(rectA.max)
	local rectB = b.rect
	local minB = b:TransformPoint(rectB.min)
	local maxB = b:TransformPoint(rectB.max)
	return (minB.x >= minA.x and minB.x < maxA.x and minB.y >= minA.y and minB.y < maxA.y
			and maxB.x >= minA.x and maxB.x < maxA.x and maxB.y >= minA.y and maxB.y < maxA.y)
end

return UIWorldMapView

