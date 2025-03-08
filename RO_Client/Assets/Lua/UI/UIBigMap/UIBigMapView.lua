local UIBigMapView = require("UIBigMap/UIBigMapView_Generate")

local BigMapView = require("UIBigMap/BigMapView")
local UIBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIBattle)

function UIBigMapView:OnAwake(data)
	self.controller = require("UIBigMap/UIBigMapCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBigMapView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_LEVEL_CHANGED, self, self.OnLevelChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BIGMAP_SELF_RANK_CHANGED, self, self.OnSelfRankChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.UI_PAGE_IN_END_NTF, self, self.OnUIPageInEndNtf)
end

function UIBigMapView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBigMapView:Init()
	if not self.bigMapView then
		self.bigMapView = BigMapView:new(self)
	end
	local curMapId = self.controller:GetCurMapId()
	local curLevelId = self.controller:GetCurLevelId()
	local mapId = self.controller:GetMapId()
	local enterType = self.controller:GetEnterType()
	self.bigMapView:InitData(curMapId, curLevelId, mapId, enterType)
	if enterType == Enum.BigMapEnterType.Default then
		self.btnBack:SetActive(true)
		self.btnBigMap:SetActive(true)
	else
		self.btnBack:SetActive(false)
		self.btnBigMap:SetActive(false)
	end
	self:RefreshMap()

	if self.delayFrameTimer then
		self.delayFrameTimer:Stop()
		self.delayFrameTimer = nil
	end
	self.delayFrameTimer = FrameTimer.New(function()
		local boxPos = UIBattleCtr:GetMiniMapPosition()
		if boxPos then
			self.window.transform.position = boxPos
		end
		LuaBattleBridge.BeginTweenPosition(self.window, 0.15, Vector3.zero, false)
	end, 1)
	self.delayFrameTimer:Start()


	self.awardTips:SetActive(false)
	ManagerContainer.LuaUIMgr:Hide(Enum.UIPageName.UIBattle)
end

function UIBigMapView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBigMapView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.btnBack.button, self, self.OnClickBtnBack)
	self.uiBase:AddButtonUniqueEventListener(self.btnBigMap.button, self, self.OnClickBtnBigMap)
	self.uiBase:AddButtonUniqueEventListener(self.awardTips.AnyBtn.button, self, self.OnClickBtnAlpha)
end

function UIBigMapView:OnHide()

end

function UIBigMapView:OnShow(data)
	self.controller:SetData(data)
end

function UIBigMapView:OnClose()
end

function UIBigMapView:OnDispose()
	if self.delayFrameTimer then
		self.delayFrameTimer:Stop()
		self.delayFrameTimer = nil
	end
	if self.bigMapView then
		self.bigMapView:Dispose()
		self.bigMapView = nil
	end
	self.isWaitBattleOpen = nil
end

function UIBigMapView:OnSelfRankChanged()
	if self.bigMapView then
		self.bigMapView:RefreshSelfRank()
	end
end

function UIBigMapView:OnLevelChanged()
	self.controller:RefreshLevelData()
	if self.bigMapView then
		local curMapId = self.controller:GetCurMapId()
		local curLevelId = self.controller:GetCurLevelId()
		local mapId = self.controller:GetMapId()
		self.bigMapView:OnLevelChanged(curMapId, curLevelId, mapId)
	end
end

function UIBigMapView:OnUIPageInEndNtf(id)
	if not self.isWaitBattleOpen then return end
	if id ~= Enum.UIPageName.UIBattle then return end
	self.window.transform.localPosition = Vector3.zero
	local boxPos = UIBattleCtr:GetMiniMapPosition()
	if boxPos then
		boxPos = self.window.transform.parent:InverseTransformPoint(boxPos)
	else
		boxPos = Vector3.zero
	end
	LuaBattleBridge.BeginTweenPosition(self.window, 0.15, boxPos, false)
	self.super.UIClose(self)
	self.isWaitBattleOpen = false
end

function UIBigMapView:RefreshMap()
	local mapData = self.controller:GetMapData()
	if mapData then
		self.nameTxt.text.text = (mapData.Name and I18N.SetLanguageValue(mapData.Name) or '')
	end
end

function UIBigMapView:UIClose()
	self.isWaitBattleOpen = true
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattle, nil, nil, nil, true)
end

function UIBigMapView:BigMapViewComplete(hasFollow)
	self:UIClose()
end

function UIBigMapView:OnPageInEnd()
	if self.bigMapView then
		self.bigMapView:OnPageInEnd()
	end
	if self.delayFrameTimer then
		self.delayFrameTimer:Stop()
		self.delayFrameTimer = nil
	end
	LuaBattleBridge.BeginTweenPosition(self.window, 0, Vector3.zero, false)
	self.super.OnPageInEnd(self)
end

function UIBigMapView:OnClickBtnBack()
	self:UIClose()
end

function UIBigMapView:OnClickBtnBigMap()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIWorldMap)
	ManagerContainer.LuaUIMgr:ClosePage(self.uiData.id, false)
end

function UIBigMapView:OnClickBtnAlpha()
	self.awardTips:SetActive(false)
end

return UIBigMapView

