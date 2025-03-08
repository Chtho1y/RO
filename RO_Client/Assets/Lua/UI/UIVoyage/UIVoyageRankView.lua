local UIVoyageRankView = require("UIVoyage/UIVoyageRankView_Generate")
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')

function UIVoyageRankView:OnAwake(data)
	self.controller = require("UIVoyage/UIVoyageRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIVoyageRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.VOYAGE_RANK_CHANGED, self, self.OnVoyageRankChanged)

end

function UIVoyageRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIVoyageRankView:Init()
	self.controller:InitData()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	local maxNum = self.controller:GetMaxNum()
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.rankList.loopListView, 0, maxNum,
															false, 'LoadingItem', Enum.ListLoadingStatus.None,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex,nil, self.OnBeginLoad)

	self.rankList.loopListView.ScrollRect.enabled = false
	local errorCode = self.controller:SendGetVoyageRankDatasReq(true)
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
	self:RefreshSelfVoyageRankItem()
end

function UIVoyageRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIVoyageRankView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCancelBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIVoyageRankView:OnHide()

end

function UIVoyageRankView:OnShow(data)
	self.controller:SetData(data)

end

function UIVoyageRankView:OnClose()
end

function UIVoyageRankView:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.controller:OnDispose()
end

function UIVoyageRankView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.rankList.loopListView.ScrollRect.enabled = true
end

function UIVoyageRankView:OnVoyageRankChanged()
	self:RefreshList()
end

function UIVoyageRankView:OnClickCancelBtn()
	self:UIClose()
end


function UIVoyageRankView:GetItemByIndex(loopListView, idx, dataIdx)
	local itemData = self.controller:GetRankDataById(dataIdx + 1)
	if not itemData then return nil end
	local item = loopListView:NewListViewItem('VoyageRankItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'VoyageRankItem', item.gameObject)
	if itemLua then
		local playerBrief = itemData.playerBrief
		local data = {IsHero = true}
		local headFrameId = nil
		local vipLv = nil
		local name = nil
		if playerBrief then
			local uid = playerBrief.uid
			vipLv = playerBrief.vipLv
			headFrameId = playerBrief.headFrame
			if int64.equals(uid, ManagerContainer.DataMgr.UserData:GetUserId()) then
				headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId()
				vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
			end
			local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(playerBrief.configId)
			local jobIcon = ''
			if jobCfg then
				jobIcon = jobCfg.JobIcon
			end
			data.Level = playerBrief.level
			data.ProfessionIcon = jobIcon
			data.HeadIcon = playerBrief.headPortraitName
			name = playerBrief.nickName
		end
		self:RefreshVoyageRankItem(itemLua, name, vipLv, data, headFrameId, itemData.score, itemData.rank)
	end
	return item
end

function UIVoyageRankView:RefreshSelfVoyageRankItem()
	local userdata = ManagerContainer.DataMgr.UserData
	local data = {IsHero = true}
	data.Level = userdata:GetRoleLv()
	local jobCfg = ManagerContainer.CfgMgr:GetJobDataById(userdata:GetJobCfgId())
	local jobIcon = ''
	if jobCfg then
		jobIcon = jobCfg.JobIcon
	end
	data.ProfessionIcon = jobIcon
	data.HeadIcon = userdata:GetUserHeadIcon()
	local headFrameId = userdata:GetHeadFrameId()
	local vipLv = userdata:GetVipLv()
	local name = userdata:GetUserNickname()
	self:RefreshVoyageRankItem(self.selfVoyageRankItem, name, vipLv, data, headFrameId, self.controller:GetSelfScore(), self.controller:GetSelfRank())
end

function UIVoyageRankView:RefreshVoyageRankItem(itemLua, name, vipLv, headData, headFrameId, score, rank)
	itemLua.nameTxt.text.text = tostring(name)
	if not score or score <= 0 then
		itemLua.scoreTxt.text.text = "0"
	else
		itemLua.scoreTxt.text.text = tostring(score)
	end
	if not rank or rank <= 0 then
		itemLua.rankTxt.text.text = string.formatbykey('NoRank')
		itemLua.rankTxt:SetActive(true)
		itemLua.rankSp:SetActive(false)
	elseif rank == 1 then
		itemLua.rankTxt:SetActive(false)
		itemLua.rankSp.uIImageSwitchSprite:ChangeSprite(0)
		itemLua.rankSp:SetActive(true)
	elseif rank == 2 then
		itemLua.rankTxt:SetActive(false)
		itemLua.rankSp.uIImageSwitchSprite:ChangeSprite(1)
		itemLua.rankSp:SetActive(true)
	elseif rank == 3 then
		itemLua.rankTxt:SetActive(false)
		itemLua.rankSp.uIImageSwitchSprite:ChangeSprite(2)
		itemLua.rankSp:SetActive(true)
	else
		itemLua.rankTxt.text.text = tostring(rank)
		itemLua.rankTxt:SetActive(true)
		itemLua.rankSp:SetActive(false)
	end
	itemLua.headItem.head.button.enabled = false
	CommonUtil.SetPlayerHeadAndFrame(self, itemLua.headItem, headData, false, headFrameId)

	itemLua.vipIcon.image.enabled = false
	itemLua.vipIcon.image.sprite = nil
	if vipLv and vipLv >= 0 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					itemLua.vipIcon.image.sprite = sprite
					itemLua.vipIcon.image.enabled = true
				end
			end, itemLua, 'VipIcon')
		end
	end
end

function UIVoyageRankView:OnBeginLoad(isBegin)
	local errorCode = self.controller:SendGetVoyageRankDatasReq(isBegin)
	if errorCode ~= 0 then
		self:RefreshList(isBegin)
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIVoyageRankView:RefreshList()
	local rankDatas = self.controller:GetRankDatas()
	local maxNum = self.controller:GetMaxNum()
	local whole = false
	local dataLength = 0
	if rankDatas then
		dataLength = #rankDatas
		whole = (dataLength >= maxNum)
	end
	self.loadStatusLoopListCtr:SetHasBegin(true)
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength((whole and dataLength or (dataLength + 1)))
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
	self:RefreshSelfVoyageRankItem()
end

return UIVoyageRankView

