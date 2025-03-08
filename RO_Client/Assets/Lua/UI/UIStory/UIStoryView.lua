local UIStoryView = require("UIStory/UIStoryView_Generate")

local closeDelay = 1

local curIdx = 0
local isStoryOver = false

local prelaodSuccess = false
local storyInAnimOver = false

local curTalkCfgDatas
local assetSeqId

local isDraging = false

local talkList = {}

local TransitionType = {
	IN = 1,
	OUT = 2,
	IN_AND_OUT = 3,
}

local UIClickSound
function UIStoryView:OnAwake(data)
	self.controller = require("UIStory/UIStoryCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIStoryView:AddEventListener()

end

function UIStoryView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:InitOnce()
	self:Init()
end

function UIStoryView:InitOnce()
	UIClickSound = GlobalConfig.Instance:GetConfigStrValue(176)
	self.scrollView.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
end

function UIStoryView:Init()
	self.selectionBg:SetActive(false)

	self.selectionIdx = nil
	isStoryOver = false
	self.curTalkOverStatus = false

    local curCfgData = self.controller:GetData()
	--LogError(Inspect(curCfgData))
    curTalkCfgDatas = ManagerContainer.CfgMgr:GetStoryPerformDataById(curCfgData.StoryId)
	--LogError(Inspect(curTalkCfgDatas))
	if curCfgData.Transition then
		if curCfgData.TransitionType == TransitionType.IN or curCfgData.TransitionType == TransitionType.IN_AND_OUT then
			self.darkScreen:SetActive(true)
			self.transform:DOScale(1, 0.5):OnComplete(function ()
				storyInAnimOver = true
				self:StartStory()
			end)
		end
	else
		storyInAnimOver = true
		self:StartStory()
	end

	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UISTORY_UI_START_OR_OVER, true)

	self.skip:SetActive(curCfgData.Skip)
	self.bgMove:SetActive(curCfgData.NeedBg)
	local preloadAssets = self:PreloadAllStoryAssets(curCfgData.StoryId)

	if #preloadAssets > 0 then
		assetSeqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.Sprite, nil, preloadAssets, nil, function()
			if ManagerContainer.ResMgr:SeqIdEquals(assetSeqId, 0) then
				assetSeqId = nil
			end
			prelaodSuccess = true
            self:StartStory()
		end)
	else
		prelaodSuccess = true
	end

	self.arrowLft:SetActive(false)
	self.arrowRgt:SetActive(false)
end

function UIStoryView:StartStory()
	if not storyInAnimOver or not prelaodSuccess then return end
	self.darkScreen:SetActive(false)

	curIdx = 0

	--LogError("StartStory")
	self.delayTimer = FrameTimer.New(function()
		self:PlayStoryPerform()
	end, 1)
	self.delayTimer:Start()
end

function UIStoryView:PlayStoryPerform()
	if self.controller == nil then return end

	local curCfgData = self.controller:GetData()

    curIdx = curIdx + 1
	--LogError("PlayStoryPerform   "..curIdx)
    local curTalk = curTalkCfgDatas[curIdx]
	if curTalk == nil then
		--self:StoryOver()
		if curCfgData.SelectionTexts == nil then
			self:StoryOver()
		else
			--显示选择选项
			self:RefreshSelectionGroup()
		end
		return
	end

	local needFihgterPerformance = false
	local need2DPerformance = false

    local fighterAniOverTime = curTalk.OverTime > 0 and curTalk.OverTime/100 or 0
    if curTalk.Camp ~= nil then
		needFihgterPerformance = true
        self.oriFighterState = {}
        for i = 1, #curTalk.Camp do
            local camp = curTalk.Camp[i] or 0
            local id = curTalk.CfgId[i]
            local dir = curTalk.Dir[i] or 0
            local dirStartTime = curTalk.DirStartTime[i] or 0
            local aniName = curTalk.AniName[i]
            local aniStartTime = curTalk.AniStartTime[i] or 0
            local eff = curTalk.Eff[i]
            local effStartTime = curTalk.EffStartTime[i] or 0

            if id == nil then
                break
            end

            local cfgId = id
            if id == 1 then
                cfgId = ManagerContainer.DataMgr.UserData:GetUserRoleId()
            end

            local data = {cfgId = cfgId, camp = camp, oriDir = LuaBattleBridge.GetOriFighterRotate(cfgId, camp)}
            self.oriFighterState[i] = data

            self.left.transform:DOScaleZ(1, dirStartTime):OnComplete(function ()
                LuaBattleBridge.DoFighterRotate(cfgId, camp, dir)
            end):SetAutoKill()

            if aniName ~= "" then
				self.left.transform:DOScaleZ(1, aniStartTime):OnComplete(function ()
                    LuaBattleBridge.DoFighterPlayAnimation(cfgId, camp, aniName)
                end):SetAutoKill()
            end
            if eff ~= "" and eff ~= 0 then
				self.left.transform:DOScaleZ(1, effStartTime):OnComplete(function ()
                    LuaBattleBridge.DoFighterPlayEffect(cfgId, camp, eff)
                end):SetAutoKill()
            end
        end
    else
        self.oriFighterState = nil
    end

	local leftSprite
	if curTalk.LeftName == "player" then
		need2DPerformance = true
		local icon = self:GetPlayerRoleCartoonIcon()
		leftSprite = ManagerContainer.ResMgr:LuaFindSpriteByPathAndName(nil, CommonUtil.GetIconsTotalPath(icon))
	else
		if curTalk.LeftImg ~= "" then
			need2DPerformance = true
			leftSprite = ManagerContainer.ResMgr:LuaFindSpriteByPathAndName(nil, CommonUtil.GetIconsTotalPath(curTalk.LeftImg))
		end
	end

	if leftSprite ~= nil then
		need2DPerformance = true
		self.left.role.image.sprite = leftSprite
	end

	local rightSprite
	if curTalk.RightName == "player" then
		need2DPerformance = true
		local icon = self:GetPlayerRoleCartoonIcon()
		rightSprite = ManagerContainer.ResMgr:LuaFindSpriteByPathAndName(nil, CommonUtil.GetIconsTotalPath(icon))
	else
		if curTalk.RightImg ~= "" then
			need2DPerformance = true
			rightSprite = ManagerContainer.ResMgr:LuaFindSpriteByPathAndName(nil, CommonUtil.GetIconsTotalPath(curTalk.RightImg))
		end
	end

	if rightSprite ~= nil then
		need2DPerformance = true
		self.right.role.image.sprite = rightSprite
	end

	if curTalk.LeftAct ~= "" then
		need2DPerformance = true
		if curTalk.LeftActBgTime > 0 then
			self.left.transform:DOScaleZ(1, curTalk.LeftActBgTime*0.001):OnComplete(function ()
				self.left.animator:Play(curTalk.LeftAct)
			end)
		else
			self.left.animator:Play(curTalk.LeftAct)
		end
	end
	if curTalk.RightAct ~= "" then
		need2DPerformance = true
		if curTalk.RightActBgTime > 0 then
			self.right.transform:DOScaleZ(1, curTalk.RightActBgTime*0.001):OnComplete(function ()
				self.right.animator:Play(curTalk.RightAct)
			end)
		else
			self.right.animator:Play(curTalk.RightAct)
		end
	end
	local speekSite = 0
	if curTalk.SpeakId ~= "" then
		need2DPerformance = true
		if curTalk.SpeakSite > 0 then
			speekSite = curTalk.SpeakSite
		end
	end
	self.curTalkContent = nil
	self.curTalkDsc = nil
	self.curTalkDscContent = nil
	self.curTalkOverStatus = false

	if speekSite > 0 and curTalk.SpeakId ~= "" then
		table.insert(talkList,1,curTalk)
		self.scrollView.loopListView:SetListItemCount(#talkList, false);
		self.scrollView.loopListView:RefreshAllShownItem();
		--self.scrollView.loopListView:MovePanelToItemIndex(0, 0)
	else
		if curIdx >= #curTalkCfgDatas then
			--LogError("over")
			local curCfgData = self.controller:GetData()
			if curCfgData.SelectionTexts == nil then
				self:StoryOver()
			else
				--显示选择选项
				self:RefreshSelectionGroup()
			end
		else
			DG.Tweening.DOTween.Kill(self.transform)

			local overTime = 0.5
			if needFihgterPerformance and not need2DPerformance then
				overTime = fighterAniOverTime
			end
			self.transform:DOScaleZ(1, overTime):OnComplete(function ()
				--LogError("next11111")

				DG.Tweening.DOTween.Kill(self.left.transform)
				self:PlayStoryPerform()
			end):SetAutoKill()
		end
	end
end

function UIStoryView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item = gridView:NewListViewItem('StoryTalkItem')
	item.gameObject.name = itemIndex
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'StoryTalkItem', item.gameObject)
	local curCfgData = self.controller:GetData()
	local logicData = talkList[itemIndex + 1]
	local data = {curCfgData, logicData,
				  logicData.SpeakSite == 1 and self[logicData.LeftNameColour].image.sprite or self[logicData.RightNameColour].image.sprite,
				  itemIndex == 0, item}
	CommonUtil.UpdateItemPrefab(self, itemlua, data)
	if itemIndex == 0 then
		if not self:GetIsDraging() then
			self.arrowLft:SetActive(logicData.SpeakSite == 1)
			self.arrowRgt:SetActive(logicData.SpeakSite == 2)
		end
	end
	return item
end

function UIStoryView:StoryOver()
	if isStoryOver then return end

	isStoryOver = true

	CommonUtil.ResetAnimator(self.left.animator)
	CommonUtil.ResetAnimator(self.right.animator)
	--CommonUtil.ResetAnimator(self.selectionBg.animator)

	self.arrowLft:SetActive(false)
	self.arrowRgt:SetActive(false)

	if self.oriFighterState ~= nil then
		for i = 1, #self.oriFighterState do
			local data = self.oriFighterState[i]
			LuaBattleBridge.DoFighterRotate(data.cfgId, data.camp, data.oriDir)
		end
		self.oriFighterState = nil
	end

	if ManagerContainer.UIStoryMgr:NeedNextStory() then
		DG.Tweening.DOTween.Kill(self.transform)

		local curData = ManagerContainer.UIStoryMgr:StartNextStory(self.selectionIdx)
		self.controller:SetData(curData)
		self:Init()
	else
		self.transform:DOScaleZ(1, closeDelay):OnComplete(function ()
			self:CloseUI()
		end)
	end
end

function UIStoryView:GetPlayerRoleCartoonIcon()
	local roleId = ManagerContainer.DataMgr.UserData:GetUserRoleId()
	local roleData = ManagerContainer.CfgMgr:GetRoleDataById(roleId)
	if roleData == nil then
		return ""
	end
	return roleData.CartoonImg
end

function UIStoryView:RefreshSelectionGroup()
	self.arrowLft:SetActive(false)
	self.arrowRgt:SetActive(false)

	local curCfgData = self.controller:GetData()
	for i = 1, 3 do
		local selection = self.selectionBg["selection"..i]
		local state = curCfgData.SelectionTexts ~= nil and curCfgData.SelectionTexts[i] ~= nil
		selection:SetActive(state)
		if state then
			selection.text.text.text = I18N.T(curCfgData.SelectionTexts[i])
		end
	end
	self.selectionBg:SetActive(true)
end

local function GetCurTalkData(index)
	local idx = 0
	for i = 1,#curTalkCfgDatas do
		if curTalkCfgDatas[i].SpeakId ~= "" and curTalkCfgDatas[i].SpeakSite > 0 then
			idx = idx + 1
			if idx == index then
				return curTalkCfgDatas[i]
			end
		end
	end
	return nil
end

function UIStoryView:PreloadAllStoryAssets()
	local list = {}
	for _,v in pairs(curTalkCfgDatas) do
		if v.LeftName == "player" then
			local icon = self:GetPlayerRoleCartoonIcon()
			local path = CommonUtil.GetIconsTotalPath(icon)
			if icon ~= "" and not CommonUtil.EleInTable(path, list) then
				list[#list + 1] = path
			end
		else
			local path = CommonUtil.GetIconsTotalPath(v.LeftImg)
			if v.LeftImg ~= "" and not CommonUtil.EleInTable(path, list) then
				list[#list + 1] = path
			end
		end

		if v.RightName == "player" then
			local icon = self:GetPlayerRoleCartoonIcon()
			local path = CommonUtil.GetIconsTotalPath(icon)
			if icon ~= "" and not CommonUtil.EleInTable(path, list) then
				list[#list + 1] = path
			end
		else
			local path = CommonUtil.GetIconsTotalPath(v.RightImg)
			if v.RightImg ~= "" and not CommonUtil.EleInTable(path, list) then
				list[#list + 1] = path
			end
		end
	end
	return list
end

function UIStoryView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIStoryView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.skip.button, self, self.CloseUI)

	self.window.uIEventTriggerListener.onPointerUp = function ()
		if isDraging then
			isDraging = false
			return
		end
		MusicMgr.Instance:PlayUISound(UIClickSound, false)

		self:OnContentClick()
	end

	self.window.uIEventTriggerListener.onPointerExit = function ()
		if isDraging then
			isDraging = false
			return
		end
		self:OnContentClick()
	end

	self.scrollView.uIEventTriggerListener.onPointerUp = function ()
		if isDraging then
			isDraging = false
			return
		end

		MusicMgr.Instance:PlayUISound(UIClickSound, false)

		self:OnContentClick()
	end

	self.scrollView.loopListView.mOnBeginDragAction = function ()
		self:OnBeginDragAction()
	end

	self.uiBase:AddButtonEventListener(self.selectionBg.selection1.button, self, self.OnSelectionClick, 1)
	self.uiBase:AddButtonEventListener(self.selectionBg.selection2.button, self, self.OnSelectionClick, 2)
	self.uiBase:AddButtonEventListener(self.selectionBg.selection3.button, self, self.OnSelectionClick, 3)
end

function UIStoryView:GetIsDraging()
	return isDraging
end

function UIStoryView:OnSelectionClick(button, params)
	local data = params.Length > 0 and params[0] or nil
	if data ~= nil then
		if data == 1 then
			self.selectionBg.animator:Play("SelectionA")
		elseif data == 2 then
			self.selectionBg.animator:Play("SelectionB")
		elseif data == 3 then
			self.selectionBg.animator:Play("SelectionC")
		end

		self.selectionIdx = data
	end
end

function UIStoryView:OnSubClose(path)
	local target = CommonUtil.ParseUITargetPath(self, path)
	if target == nil then
		return
	end

	if target == self.selectionBg then
		target:SetActive(false)

		local curCfgData = self.controller:GetData()
		if curCfgData.SelectionNext == nil then
			self:StoryOver()
		else
			DG.Tweening.DOTween.Kill(self.transform)
			self:Reset()
			local curData = ManagerContainer.UIStoryMgr:StartNextStory(self.selectionIdx)
			self.controller:SetData(curData)
			self:Init()
		end
	end


end

function UIStoryView:CloseUI()
	DG.Tweening.DOTween.Kill(self.transform)

	local curCfgData = self.controller:GetData()
	if curCfgData.Transition then
		if curCfgData.TransitionType == TransitionType.OUT or curCfgData.TransitionType == TransitionType.IN_AND_OUT then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UISTORY_UI_START_OR_OVER, false, self.selectionIdx)
		end
	else
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UISTORY_UI_START_OR_OVER, false, self.selectionIdx)
	end
end

function UIStoryView:OnContentClick()
	--LogError("OnContentClick")
	if isStoryOver then
		return
	end

	--self.scrollView.loopVerticalScrollRect:MoveTo(0);
	if self.curTalkDsc ~= nil then
		if not self.curTalkOverStatus then
			self.curTalkOverStatus = true
			self.curTalkTweener:Kill(false)
			DG.Tweening.DOTween.Kill(self.curTalkDsc.transform)
			self.curTalkDsc.text = self.curTalkContent
		else
			DG.Tweening.DOTween.Kill(self.curTalkDsc.transform)
			self.lastNext:SetActive(false)
			--LogError("next3333")
			self:PlayStoryPerform()
		end
	end
end

function UIStoryView:OnBeginDragAction()
	--LogError("OnBeginDragAction")
	isDraging = true
	self:OnContentClick()

	self.arrowLft:SetActive(false)
	self.arrowRgt:SetActive(false)
end

function UIStoryView:OnHide()

end

function UIStoryView:OnShow(data)
	self.controller:SetData(data)
	--DG.Tweening.DOTween.Kill(self.transform)
	--
	--self:Init()
end

function UIStoryView:OnClose()
	self:Reset()
end

function UIStoryView:Reset()
	DG.Tweening.DOTween.Kill(self.transform)
	DG.Tweening.DOTween.Kill(self.left.transform)
	DG.Tweening.DOTween.Kill(self.right.transform)
	CommonUtil.ResetAnimator(self.left.animator)
	CommonUtil.ResetAnimator(self.right.animator)

	if self.curTalkDsc ~= nil then
		self.curTalkOverStatus = true
		self.curTalkTweener:Kill(false)
		DG.Tweening.DOTween.Kill(self.curTalkDsc.transform)
		self.curTalkDsc.text = self.curTalkContent
	end

	if self.delayTimer then
		self.delayTimer:Stop()
		self.delayTimer = nil
	end

	if assetSeqId then
		ManagerContainer.ResMgr:UnloadAssetBySeqId(assetSeqId)
		assetSeqId = nil
	end
	self.curTalkCfgDatas = nil
	self.lastNext = nil
	self.curTalkContent = nil
	self.curTalkDsc = nil

	isDraging = false
	storyInAnimOver = false
	prelaodSuccess = false
end

function UIStoryView:OnDispose()
	if self.inited then
		self:Reset()

		self.window.uIEventTriggerListener.onPointerUp = nil
		self.window.uIEventTriggerListener.onPointerExit = nil
		self.scrollView.uIEventTriggerListener.onPointerUp = nil
		self.scrollView.loopListView.mOnBeginDragAction = nil

		--self.scrollView.loopVerticalScrollRect:ClearCells()
		self.scrollView.loopListView:Dispose();

		talkList = nil
	end
end

return UIStoryView

