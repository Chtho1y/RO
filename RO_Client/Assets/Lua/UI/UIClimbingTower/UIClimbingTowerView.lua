local UIClimbingTowerView = require("UIClimbingTower/UIClimbingTowerView_Generate")
local PreviewSystem = require "PreviewSystem"
local RoleViewSystem = require "RoleViewSystem"
local IconItemCtr = require "Common.IconItemCtr"

local previewSystem
local moveState = false
local LastmoveState = false

function UIClimbingTowerView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_REFRESH_CLIMBINGTOWER_DATA,self,self.UpdateLevelsData)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_CHANGE_TOWER_SHOW_REFRESH,self,self.ShowChange)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_REFRESH_PEAKTOWER_WIN_DATA,self,self.UpdatePeakTowerDataAfterWin)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.EID_Refresh_ClimbingTower_FriendInfo,self,self.RefreshClimbingTowerFriendInfo)

	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_TOWER_LEVEL_MIN_FIGHT_POWER_ACK, self.OnFightPowerAck,self)
end

function UIClimbingTowerView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerView:Init()
	self.initedOver = false
	self.otherType = nil
	self.uIGoto:SetActive(true)
	self.text2.uILocalizeScript:SetContent("GoToLvlUp")
	self.text1.uILocalizeScript:SetContentAndValues("LvlUpNum", {0})	
	self:OnHeroLvChanged()
	--会跳往主角界面
	if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMain) == false then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMain)
	end
	--打开限时礼包
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.LIMIT_RECHARGE_OPEN_UI_NTF)
	-- --适配宽度
	-- if nil ~= self.scrollview and nil ~= self.scrollview.content and nil ~= self.scrollview.content.gridLayoutGroup then
	-- 	local rectTrans = self.scrollview.content:GetComponent(Enum.TypeInfo.RectTransform)
	-- 	if nil ~= rectTrans then					
	-- 		self.scrollview.content.gridLayoutGroup.cellSize =  Vector2(rectTrans.rect.width, self.scrollview.content.gridLayoutGroup.cellSize.y)
	-- 	end
	-- end
	-- self:InitGrid()
	self.cover:SetActive(true)
	self.cover.animator:Play("CoverKeep")

	--保护机制 5秒后关闭云
	if self.cloudTimer then
		self.cloudTimer:Stop()
	end
	if not self.cloudTimer then
		self.cloudTimer = Timer.New(slot(self.CloudOut, self), 1)
	end
	if not self.cloudTimer.running then
		self.cloudTimer:Start()
	end

	self:Refresh()

	if not self.queryTimer then
		self.queryTimer = FrameTimer.New(slot(self.QueryDatas, self), 1)
	end
	if not self.queryTimer.running then
		self.queryTimer:Start()
	end
end

function UIClimbingTowerView:QueryDatas()
	local type = self.controller:GetCurTowerType()
	self.controller:SendTowerInfoReq(type)
end

function UIClimbingTowerView:Refresh()
	local type = self.controller:GetCurTowerType()
	if type == Enum.UnlimitTowerType.PeakTower then
		self.rewardLoopGridMap = {}
		self.scrollItemGoes = {}
		self.roleSystemMap = {}
		self.previewSystemMap = {}
		self.scrollview.loopListView.mOnSnapItemFinished = function(loopListView, loopListViewItem)
			return self:OnSnapItemFinished(loopListView, loopListViewItem)
		end
		self.boardTitle.uILocalizeScript:SetContent("TopTowerTitle")
	elseif type == Enum.UnlimitTowerType.ClimbingTower then
		self.boardTitle.uILocalizeScript:SetContent("TitleClimbingTower")
	end

	self.btnTowerTop:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
	self.btnTower:SetActive(type == Enum.UnlimitTowerType.PeakTower)
	self.btnStatistics:SetActive(type == Enum.UnlimitTowerType.ClimbingTower)
end

function UIClimbingTowerView:InitGrid()
	self.scrollview.loopListView:InitListView(0, function(gridView, itemIndex)
		return self:GetItemByRowColumn(gridView, itemIndex)
	end, nil)
end

function UIClimbingTowerView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIClimbingTowerView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.rankBtn.button,self,self.OnClickRank)
	self.uiBase:AddButtonEventListener(self.playRuleBtn.button, self, self.OnClickPlayRuleBtn)
	self.uiBase:AddButtonEventListener(self.btnStatistics.button,self,self.OnClickBtnStatistics)
 	--角色升级动画弹出播放
	self.uiBase:AddButtonEventListener(self.btnInOut.button,self,self.OnPlayChangeShowState)
	-- 前往角色界面
	self.uiBase:AddButtonEventListener(self.btnGoto.button,self,self.OnShowRoleWnd)

	self.uiBase:AddButtonEventListener(self.btnTower.button, self, self.OnBtnTowerClick)
	self.uiBase:AddButtonEventListener(self.btnTowerTop.button, self, self.OnBtnTowerClick)
end

function UIClimbingTowerView:OnSnapItemFinished(loopListView, loopListViewItem)
	for _,v in pairs(self.scrollItemGoes) do
		local instanceId = v.gameObject:GetInstanceID()
		if v.gameObject.activeSelf then
			self.previewSystemMap[instanceId]:RemoveGo(v.gameObject)
		end
	end
end

function UIClimbingTowerView:ShowChange(needChange)
	self:Clear()
	self.cover:SetActive(true)
	
	self:InitGrid()

	--保护机制 5秒后关闭云
	if not self.cloudTimer then
		self.cloudTimer = Timer.New(slot(self.CloudOut, self), 1)
	end
	if not self.cloudTimer.running then
		self.cloudTimer:Start()
	end

	if needChange and self.otherType then
		self.controller:ChangeToOtherType()
		self.otherType = nil
	end
	self:Refresh()
end

function UIClimbingTowerView:CloudOut()
	self.cover.animator:Play("CoverOut")
end

function UIClimbingTowerView:OnBtnTowerClick()
	self.otherType = 1 - self.controller:GetCurTowerType()
	local needQuery = self.controller:SendTowerInfoReq(self.otherType)
	if not needQuery then
		self:ShowChange(true)
		self:UpdateLevelsData()
	end
end

--角色升级后 升级动画弹出播放
function UIClimbingTowerView:OnHeroLvChanged()
	local nCount,nId = self:GetLeveUpNum()
	if nCount > 0 then
		moveState = true
		if nil ~= self.light then
			self.light:SetActive(true)
		end
	else
		if nil ~= self.light then
			self.light:SetActive(false)
		end
	end
	self:OnPlayChangeShow(nCount)
end

--获取上阵角色可升级数量
function UIClimbingTowerView:GetLeveUpNum()
	local nBattlePatnerNum = 0
	local nPartnerId = -1
	--可上阵伙伴
	local tbBattlePartner = self:GetSortPartner()
	for i = 1, #tbBattlePartner do
		--是否可升级
		local lvUpState = ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerLvUpRPStatusById(tbBattlePartner[i].id)
		if lvUpState then
			if nPartnerId == -1 then
				nPartnerId = tbBattlePartner[i].id
			end
			nBattlePatnerNum = nBattlePatnerNum + 1
		end
	end
	return nBattlePatnerNum , nPartnerId
end

function UIClimbingTowerView:GetSortPartner()
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnersDataByInBattle()
    local sortedPartnerDatas = {}
    for _,v in pairs(partnerDatas) do
        sortedPartnerDatas[#sortedPartnerDatas + 1] = v
    end
    table.sort(sortedPartnerDatas, function (a, b)
        if a.owned and b.owned then
            return a.post < b.post
        else
            if a.owned and not b.owned then
                return true
            elseif not a.owned and b.owned then
                return false
            else
                return a.post < b.post
            end
        end
    end)
    return sortedPartnerDatas
end

--按钮点击 角色升级动画弹出播放
function UIClimbingTowerView:OnPlayChangeShowState()
	moveState = not moveState
	self:OnPlayChangeShow()
end

--展示升级动画弹出播放
function UIClimbingTowerView:OnPlayChangeShow(nCount)
	if nil == self.text1 or nil == self.bgGoto then
		return
	end
	if nil ~= nCount then
		self.text1.uILocalizeScript:SetContentAndValues("LvlUpNum", {nCount})
	end

	if LastmoveState ~= moveState then
		if moveState then
			self.bgGoto.animator:CrossFade("UIGotoIn", 0.1)
		else
			self.bgGoto.animator:CrossFade("UIGotoOut", 0.1)
		end
		LastmoveState = moveState
	end
end

-- 前往角色界面
function UIClimbingTowerView:OnShowRoleWnd()
	local ncount,nId = self:GetLeveUpNum()
	if nId == -1 then
		nId = nil
	end
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Role, nId)
end

function UIClimbingTowerView:OnHide()

end

function UIClimbingTowerView:OnShow(data)
	self.controller:SetData(data)	
	self:UpdateLevelsData()
end

function UIClimbingTowerView:Clear()
	self.initedOver = false
	if self.queryTimer then
		self.queryTimer:Stop()
		self.queryTimer = nil
	end
	if self.cloudTimer then
		self.cloudTimer:Stop()
		self.cloudTimer = nil
	end
	if self.peakRefreshTimer then
		self.peakRefreshTimer:Stop()
		self.peakRefreshTimer = nil
	end
	local type = self.controller:GetCurTowerType()
	if type == Enum.UnlimitTowerType.PeakTower then
		if self.scrollItemGoes then
			self.scrollItemGoes = nil
		end

		if self.rewardLoopGridMap then
			for _, v in pairs(self.rewardLoopGridMap) do
				v:Dispose()
			end
			self.rewardLoopGridMap = nil
		end
		if self.previewSystemMap then
			for _, v in pairs(self.previewSystemMap) do
				v:Dispose()
			end
			self.previewSystemMap = nil
		end

		if self.roleSystemMap then
			for _, v in pairs(self.roleSystemMap) do
				v:Dispose()
			end
			self.rewardLoopGridMap = nil
		end
	end

	self.scrollview.loopListView:Dispose()
end

function UIClimbingTowerView:OnClose()
	self:Clear()
	self.cover:SetActive(false)
end

function UIClimbingTowerView:OnDispose()

end

function UIClimbingTowerView:RefreshClimbingTowerFriendInfo(levelIds)
	self.scrollview.loopListView:RefreshAllShownItem()
end

function UIClimbingTowerView:FindItemGo(levelId)
	if self.scrollview.content == nil then
		return nil
	end

	return self.scrollview.content.transform:Find(tostring(levelId))
end


function UIClimbingTowerView:UpdateLevelsData()
	self.controller:RefreshTowerDatas()
	local loopListView = self.scrollview.loopListView
	local length = self.controller:GetShowDataLength()
	local curTowerFloorIdx = self.controller:GetCurTowerFloorIdx()
	local type = self.controller:GetCurTowerType()
	if type == Enum.UnlimitTowerType.PeakTower then
		if curTowerFloorIdx < length then
			length = math.min(curTowerFloorIdx + 5, length) 
			if curTowerFloorIdx <= 2 then
				curTowerFloorIdx = 1
			else
				curTowerFloorIdx = curTowerFloorIdx - 1
			end
		else
			curTowerFloorIdx = length - 2
		end

		self.peakStep = 0
		loopListView:SetListItemCount(length, false)
		self.scrollview.loopListView:MovePanelToItemIndex(curTowerFloorIdx - 1, 0)

		if not self.peakRefreshTimer then
			self.peakRefreshTimer = FrameTimer.New(slot(self.RefreshPeakTowerItems, self), 10, 3)
		end

		if not self.peakRefreshTimer.running then
			self.peakRefreshTimer:Start()
		end
	elseif type == Enum.UnlimitTowerType.ClimbingTower then
		if curTowerFloorIdx <= 2 then
			curTowerFloorIdx = 1
		else
			curTowerFloorIdx = curTowerFloorIdx - 1
		end

		loopListView:SetListItemCount(length, false)
		if curTowerFloorIdx > 1 then
			loopListView:MovePanelToItemIndex(curTowerFloorIdx - 1, 0)
		end
	end
	
	self.initedOver = true
	-- self.cover.animator:Play("CoverOut")
end

function UIClimbingTowerView:RefreshPeakTowerItems()
	self.peakStep = self.peakStep + 1

	local length = self.controller:GetShowDataLength()
	for i = 1, length do
		self:RefreshTopPeakItemByIdx(nil, i)
	end

	if self.peakStep >= 3 then
		self.peakStep = -1
	end
end


function UIClimbingTowerView:SetNpcInfo(levelNode,npcImg,natureImg,npc,Level)
	--怪物等級為爬塔層數 * 2
	levelNode.text.text = tostring(Level * 2)
	CommonUtil.LoadIcon(self, npc.npcImg, function (sprite)
		npcImg.image.sprite = sprite
		npcImg.image:SetNativeSize()
		if npc.offset~= nil then
			npcImg.rectTransform.anchoredPosition = npc.offset
		end	
	end)

	CommonUtil.LoadIcon(self, npc.natureIcon, function (sprite)
		natureImg.image.sprite = sprite
	end)
end

function UIClimbingTowerView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local length = self.controller:GetShowDataLength();
	if (itemIndex < 0 or itemIndex >=length) then
		return nil
	end
	local type = self.controller:GetCurTowerType()
	if type == Enum.UnlimitTowerType.ClimbingTower then
		return self:RefreshClimbingTowerItem(gridView, itemIndex)
	elseif type == Enum.UnlimitTowerType.PeakTower then
		return self:RefreshPeakTowerItem(gridView, itemIndex)
	end
	return nil
end

function UIClimbingTowerView:RefreshClimbingTowerItem(gridView, idx)
	local levelData = self.controller:GetShowDataByIdx(idx)
	local item = gridView:NewListViewItem("ClimbingTowerLevelItem")
	local levelLua = CommonUtil.BindGridViewItem2Lua(self, "ClimbingTowerLevelItem", item.gameObject)
	levelLua.gameObject.name = levelData.levelId
	levelLua.levelNum.text.text = "第"..levelData.levelId.."层"
	levelLua.passedNode:SetActive(levelData.hasPassed)
	levelLua.challengeBtn:SetActive(levelData.levelId == self.controller:GetCurTowerFloorIdx())
	levelLua.friendNode:SetActive(levelData:HasFriend())
	levelLua.newLevelNode:SetActive(levelData.levelId > self.controller:GetCurTowerFloorIdx())
	levelLua.bottomNode:SetActive(levelData.levelId <= self.controller:GetCurTowerFloorIdx())

	if nil ~= levelData.CardUnlock and "" ~= levelData.CardUnlock then
		levelLua.unLock.unlocktext.uILocalizeScript:SetContent(levelData.CardUnlock) 
		levelLua.unLock:SetActive(true)
	else
		levelLua.unLock:SetActive(false)
	end
	
	if levelData.hasPassed then
		levelLua.npcList:SetActive(false)
	else
		levelLua.npcList:SetActive(true)
		for i=1, #levelData.npcs do
			local npc = levelData.npcs[i]
			if npc.npcImg ~= nil then
				if i == 1 then
					self:SetNpcInfo(levelLua.npcList.npcLevel1,levelLua.npcList.npc1,levelLua.npcList.natureIcon1,npc,levelData.levelId)
				elseif i == 2 then
					self:SetNpcInfo(levelLua.npcList.npcLevel2,levelLua.npcList.npc2,levelLua.npcList.natureIcon2,npc,levelData.levelId)
				elseif i == 3 then
					self:SetNpcInfo(levelLua.npcList.npcLevel3,levelLua.npcList.npc3,levelLua.npcList.natureIcon3,npc,levelData.levelId)
				elseif i == 4 then
					self:SetNpcInfo(levelLua.npcList.npcLevel4,levelLua.npcList.npc4,levelLua.npcList.natureIcon4,npc,levelData.levelId)
				end
			end
		end	
	end

	self:HideAllItems(levelLua)
	if levelData.specialReward ~= nil then
		for i =1, #levelData.specialReward do
			self:SetSpecialData(self:GetItemGo(levelLua,i),levelData.specialReward[i][1],levelData.specialReward[i][2])
		end	
		levelLua.bonusNode:SetActive(true)
	else
		levelLua.bonusNode:SetActive(false)
	end
	
	self.uiBase:AddButtonUniqueEventListener(levelLua.levelInfoBtn.button, self, self.OnClickViewLevelInfo, levelData.levelId)
	self.uiBase:AddButtonUniqueEventListener(levelLua.challengeBtn.button, self, self.OnClickChallengeBtn, levelData.levelId)
	self.uiBase:AddButtonUniqueEventListener(levelLua.friendNode.button, self, self.OnClickFriendBtn, levelData.levelId)
	return item
end

function UIClimbingTowerView:UpdatePeakTowerDataAfterWin(idx)
	self.controller:RefreshTowerDatas()
	local loopListView = self.scrollview.loopListView
	local length = self.controller:GetShowDataLength()
	local curTowerFloorIdx = self.controller:GetCurTowerFloorIdx()
	local type = self.controller:GetCurTowerType()
	if type == Enum.UnlimitTowerType.PeakTower then
		if curTowerFloorIdx < length then
			length = math.min(curTowerFloorIdx + 5, length) 
		end
	end
	self.peakStep = -1

	loopListView:SetListItemCount(length, false)

	loopListView:RefreshAllShownItem()
end

function UIClimbingTowerView:RefreshPeakTowerItem(gridView, idx)
	local showData = self.controller:GetShowDataByIdx(idx)
	local item = gridView:NewListViewItem("ClimbingTowerTopItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "ClimbingTowerTopItem", item.gameObject)
	local instanceId = item.gameObject:GetInstanceID()

	local curTowerFloorIdx = self.controller:GetCurTowerFloorIdx()

	local curState = curTowerFloorIdx > showData.floorIdx

	local selfUid = ManagerContainer.DataMgr.UserData:GetUserRoleId()
	local userData = showData:GetRoleInfo()

	local isRobot = userData.isRobot

	if not self.scrollItemGoes[instanceId] then
		self.scrollItemGoes[instanceId] = itemlua
	end
	item.gameObject.name = showData.floorIdx
	
	if not userData.inited then
		itemlua.playerNode:SetActive(false)
		itemlua.challengeBtn:SetActive(false)
		itemlua.btnBuy:SetActive(false)
		itemlua.rewards:SetActive(false)
		itemlua.passedNode:SetActive(false)
	
		itemlua.cover:SetActive(true)
		itemlua.btnBuy:SetActive(false)
		itemlua.challengeBtn:SetActive(false)
		itemlua.levelNum.text.text = I18N.SetLanguageValue("TopTowerLevel", showData.floorIdx) 
	
		itemlua.btnMessage:SetActive(false)
		return item
	end

	itemlua.playerNode:SetActive(not curState)
	itemlua.challengeBtn:SetActive(not curState)
	itemlua.btnBuy:SetActive(not curState)
	itemlua.rewards:SetActive(not curState)
	itemlua.passedNode:SetActive(curState)

	itemlua.nametext.text.text = userData.nickName
	itemlua.cover:SetActive(curTowerFloorIdx < showData.floorIdx)
	itemlua.btnBuy:SetActive(curTowerFloorIdx == showData.floorIdx)
	itemlua.challengeBtn:SetActive(curTowerFloorIdx == showData.floorIdx)
	itemlua.levelNum.text.text = I18N.SetLanguageValue("TopTowerLevel", showData.floorIdx) 

	itemlua.btnMessage:SetActive(not isRobot and selfUid ~= userData.uid)

	if self.peakStep == -1 then
		self:RefreshTopPeakItemByIdx(itemlua, showData.floorIdx)
	end
	
	return item
end	

function UIClimbingTowerView:RefreshTopPeakItemByIdx(itemlua, idx)
	if not itemlua then
		itemlua = self:GetTopPeakItemByIdx(idx)
	end
	if not itemlua then return end

	local showData = self.controller:GetShowDataByIdx(idx - 1)
	local instanceId = itemlua.gameObject:GetInstanceID()
	if not showData then return end
	local heroData = showData:GetRoleHeroData()
	local curTowerFloorIdx = self.controller:GetCurTowerFloorIdx()
	local curState = curTowerFloorIdx > showData.floorIdx
	local userData = showData:GetRoleInfo()

	if not curState then
		if self.peakStep == -1 or self.peakStep == 2 then
			if not self.roleSystemMap[instanceId] then
				self.roleSystemMap[instanceId] = RoleViewSystem:new()
			end
			if not self.previewSystemMap[instanceId] then
				self.previewSystemMap[instanceId] = PreviewSystem:new("Preview", 256, 256)
				self.previewSystemMap[instanceId]:SetView(Vector3(-0.116, 1.649, 2.5), Quaternion.Euler(12.174, -182.628, 0.085))
			end

			itemlua.pos:SetActive(true)
			local selectZone = userData.selectZone
			if selectZone == 0 then
				local serverData = ManagerContainer.LuaGameMgr.serverData
				selectZone = serverData and serverData.id or 0
			end
			itemlua.servertext.text.text = I18N.SetLanguageValue("TopTowerServer", selectZone)
			itemlua.atknum.text.text = userData.fightPower

			self.roleSystemMap[instanceId]:CancelCreate()
			self.previewSystemMap[instanceId]:RemoveAllGo()
			self.roleSystemMap[instanceId]:SetHeroId(instanceId)

			self.roleSystemMap[instanceId]:RefreshView(Enum.RoleInEnvType.RoleMainView, userData.roleCfgId, userData.viewData, heroData and heroData.extGoesShowData or nil, self, self.LoadModelCB)
		
			itemlua.roleModel.rawImage.texture = self.previewSystemMap[instanceId]:GetRenderTexture()
		end

		if self.peakStep == -1 or self.peakStep == 3 then
			local loopGridView = itemlua.scrollView.loopGridView
			if not self.rewardLoopGridMap[instanceId] then
				self.rewardLoopGridMap[instanceId] = loopGridView
			end
		
			if not itemlua.initedLoop then
				loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
					return self:GetRewardItemByRowColumn(gridView, itemIndex, row, column)
				end, nil)
				itemlua.initedLoop = true
			end
		
			local cfgData = ManagerContainer.CfgMgr:GetTopTowerRewardCfgDataByLv(showData.floorIdx)
			self.curPeakTowerItemRewardData = cfgData and cfgData.RewardItems or nil
			local rewardLength = cfgData and #cfgData.RewardItems or 0
			loopGridView:RefreshListByIndex(rewardLength, 0)
		
			local cost = cfgData and cfgData.BuyRoadCost or nil
			itemlua.btnBuy.icon.image.enabled = false
			if cost and cost[1] then
				local key = cost[1][1]
				local val = cost[1][2]
				local ownNum = CommonUtil.GetOwnResCountByItemId(key)
				local costCfgData = ManagerContainer.CfgMgr:GetItemById(key)
				if costCfgData.Icon and costCfgData.Icon ~= '' then
					CommonUtil.LoadIcon(self, costCfgData.Icon, function (sprite)
						itemlua.btnBuy.icon.image.sprite = sprite
						itemlua.btnBuy.icon.image.enabled = true
					end, 'ItemIcon'..idx)
				end
				if ownNum < val then
					itemlua.btnBuy.num.text.text = string.format(Constant.PinkColorText, val)
				else
					itemlua.btnBuy.num.text.text = val
				end
				self.uiBase:AddButtonUniqueEventListener(itemlua.btnBuy.button, self, self.OnPeakTowerBuyClick, showData.floorIdx, val)
			end
			self.uiBase:AddButtonUniqueEventListener(itemlua.challengeBtn.button, self, self.OnPeakTowerChallengeClick, showData.floorIdx)
			self.uiBase:AddButtonUniqueEventListener(itemlua.btnMessage.button, self, self.OnCheckFightInfo, showData.floorIdx)
		end
	end
end

function UIClimbingTowerView:LoadModelCB(go, result, instanceId)
	if not go then return end
    if self.previewSystemMap[instanceId] and go ~= nil then
        go.name = instanceId
        self.scrollItemGoes[instanceId].pos:SetActive(false)
        self.scrollItemGoes[instanceId].roleModel:SetActive(true)
        self.previewSystemMap[instanceId]:UpdateGo(go)
    end
    go:SetActive(true)
end

function UIClimbingTowerView:GetTopPeakItemByIdx(idx)
	local item = self.scrollview.loopListView:GetShownItemByItemIndex(idx - 1)
    if item then
        local itemlua = CommonUtil.GetBindGridViewItem2Lua(self, "ClimbingTowerTopItem", item.gameObject)
        return itemlua
    end
end

function UIClimbingTowerView:OnPeakTowerBuyClick(button, params)
	self.curBuyIdx = params[0]
	local data = {"PeakTowerBuyTips", {params[1]}, nil, self, self.ConfirmBuy}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
end

function UIClimbingTowerView:ConfirmBuy()
	if not self.curBuyIdx then return end

	self.controller:SendPeakTowerBuyReq(self.curBuyIdx)
end

function UIClimbingTowerView:OnPeakTowerChallengeClick(button, params)
	local floorIdx = params[0]
	self.controller:SendChallengeReq(floorIdx)
end

function UIClimbingTowerView:OnCheckFightInfo(button, params)
	local idx = params[0]
	self.controller:QueryCrossFightInfo(idx)
end

function UIClimbingTowerView:GetRewardItemByRowColumn(gridView, itemIndex, row, column)
	if not self.curPeakTowerItemRewardData then
		return nil
	end
	local showData = self.curPeakTowerItemRewardData[itemIndex + 1]
	if not showData then
		return nil
	end
	local item = gridView:NewListViewItem("IconSmallItem")
	local itemlua = CommonUtil.BindGridViewItem2Lua(self, "IconItem", item.gameObject)
	local data = {cfgId = showData[1], num = showData[2]}
	IconItemCtr:SetData(self, itemlua, data, Enum.ItemIEnterType.Bag, self, self.OnItemClick)
	return item
end

function UIClimbingTowerView:OnItemClick(button,params)
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIClimbingTowerView:SetSpecialData(itemlua,itemId,itemCnt)
	CommonUtil.SetRewardItemData(self,itemId,itemlua,itemCnt, self.OnClickItem)
	itemlua:SetActive(true)
end

function UIClimbingTowerView:GetItemGo(levelLua,idx)
	if idx == 1 then
		return levelLua.bonusNode.items.item1
	elseif idx ==2 then
		return levelLua.bonusNode.items.item2
	else
		return levelLua.bonusNode.items.item3
	end
end

function UIClimbingTowerView:HideAllItems(levelLua)
	for i = 1, 3 do
		local go = self:GetItemGo(levelLua,i)
		go:SetActive(false)
	end
end

function UIClimbingTowerView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIClimbingTowerView:OnClickClose()	
	--ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, Enum.MainViewPageType.Town)
	ManagerContainer.LuaUIMgr:OpenSourceUI(self)
end

function UIClimbingTowerView:OnDragScrollView()
	self.controller:SendFriendPassTowerInfo()
end

function UIClimbingTowerView:OnFightPowerAck(data)	
	local bIsOpen = true
	if self.controller == nil then return end
	if nil ~= data.min_tower_info then
		--LogError(Inspect(data.min_tower_info))
		local info = data.min_tower_info
		local levelInfo = self.controller:GetLevelInfo(info.tower_level)
		bIsOpen = tonumber(self.lastClickViewInfo) == tonumber(info.tower_level)		
		if levelInfo ~= nil then		
			levelInfo:SetLowestPlayerInfo(info.brief,info.fight_power,info.record_time,info.battle_time)
		end		
	end
	if bIsOpen then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerLevelInfo,self.lastClickViewInfo)
	end
end

function UIClimbingTowerView:OnClickViewLevelInfo(btn,param)
	local levelId = param[0]
	self.lastClickViewInfo = levelId
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_TOWER_LEVEL_MIN_FIGHT_POWER_REQ, {tower_level = levelId})
end

function UIClimbingTowerView:OnClickChallengeBtn(btn,param)
	local levelId = param[0]
	if levelId ~= self.controller:GetCurTowerFloorIdx() then
		return
	end

	self.controller:EnterBattle(levelId)
end

function UIClimbingTowerView:OnClickFriendBtn(btn,param)
	local levelId = param[0]

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerFriendInfo,levelId)
end

function UIClimbingTowerView:OnClickRank()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerRank)
end

function UIClimbingTowerView:OnClickPlayRuleBtn()
	local type = self.controller:GetCurTowerType()
	if type == Enum.UnlimitTowerType.ClimbingTower then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'PracticeTowerPlayExplain'})
	elseif type == Enum.UnlimitTowerType.PeakTower then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', 'TopTowerRule'})
	end
end

function UIClimbingTowerView:OnClickBtnStatistics()
	if LuaBattleBridge.HasStatistics(BattleMode.Time,BattleSubMode.ClimbingTower)  then
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleStatistics,{BattleMode.Time,BattleSubMode.ClimbingTower})
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("NullBattleInformation2")
	end
end

return UIClimbingTowerView

