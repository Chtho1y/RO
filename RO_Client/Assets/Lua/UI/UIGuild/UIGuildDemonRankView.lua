local UIGuildDemonRankView = require("UIGuild/UIGuildDemonRankView_Generate")
local RankList = {}
local LoadStatusLoopListCtr = require('Common/LoadStatusLoopListCtr')
local DemonGuildRankItemCtr = require('Common/DemonGuildRankItemCtr')
local DemonChampRankItemCtr = require('Common/DemonChampRankItemCtr')

function UIGuildDemonRankView:OnAwake(data)
	self.controller = require("UIGuild/UIGuildDemonRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildDemonRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_DEMON_RANK_INFO, self, self.RefreshPlayerInfo)
end

function UIGuildDemonRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildDemonRankView:InitGrid()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	self.loadStatusLoopListCtr = LoadStatusLoopListCtr:new(self, self.scrollView.loopListView, 0, 50,
															false, nil, nil,
															true, 'LoadingItem', Enum.ListLoadingStatus.WaitLoad,
															self.GetItemByIndex, nil, self.OnBeginLoad)
	self.scrollView.scrollRect.enabled = false
end

function UIGuildDemonRankView:RefreshPlayerInfo()
	self:InitData()
	local page = self.controller:GetPageType()
	local maxLength = 0
	local dataLength = 0
	if page == 1 then
		RankList = ManagerContainer.DataMgr.GuildDemonData:GetGuildInfos()
		maxLength = ManagerContainer.DataMgr.GuildDemonData:GetGuildRankLimit()
		dataLength = ManagerContainer.DataMgr.GuildDemonData:GetGuildInfosLength()
	elseif page == 2 then
		RankList = ManagerContainer.DataMgr.GuildDemonData:GetGuildMvpInfos()
		maxLength = ManagerContainer.DataMgr.GuildDemonData:GetGuildRankMvpLimit()
		dataLength = ManagerContainer.DataMgr.GuildDemonData:GetGuildMvpInfosLength()
	end
	self.noRankList:SetActive(RankList and #RankList == 0)
	self.noRankListTxt.text.text  = page == 1 and I18N.SetLanguageValue('DemonRankDesc01') or I18N.SetLanguageValue('DemonRankDesc02')
	self.loadStatusLoopListCtr:OnAllLoaded()
	self.loadStatusLoopListCtr:RefreshMaxDataLength(maxLength)
	self.loadStatusLoopListCtr:RefreshDataLength(dataLength)
end

function UIGuildDemonRankView:OnBeginLoad(isLeft)
	local page = self.controller:GetPageType()
	if page == 1 then
		ManagerContainer.DataMgr.GuildDemonData:SendGetGuildDemonRankInfoReq()
	elseif page == 2 then
		ManagerContainer.DataMgr.GuildDemonData:SendGetGuildDemonMvpRankInfoReq()
	end
end

function UIGuildDemonRankView:GetItemByIndex(gridView, idx, itemIndex)
	local item = nil
	local itemLua = nil
	local page = self.controller:GetPageType()
	local showData = RankList[itemIndex + 1]
	if page == 1 then
		item = gridView:NewListViewItem('DemonGuildRankItem')
		itemLua = CommonUtil.BindGridViewItem2Lua(self, 'DemonGuildRankItem', item.gameObject)
	elseif page == 2 then
		item = gridView:NewListViewItem('DemonChampRankItem')
		itemLua = CommonUtil.BindGridViewItem2Lua(self, 'DemonChampRankItem', item.gameObject)
	end
	CommonUtil.UpdateItemPrefab(self, itemLua, showData)
	return item
end

function UIGuildDemonRankView:Init()
	self.controller:SetPageType(1)
	self.guildRank.toggle.isOn = true
	self:InitGrid()
	local page = self.controller:GetPageType()
	if page == 1 then
		ManagerContainer.DataMgr.GuildDemonData:SendGetGuildDemonRankInfoReq()
	elseif page == 2 then
		ManagerContainer.DataMgr.GuildDemonData:SendGetGuildDemonMvpRankInfoReq()
	end
end

function UIGuildDemonRankView:InitData()
	local page = self.controller:GetPageType()
	self.mvpRank:SetActive(page == 2)
	self.myGuildRank:SetActive(page == 1)
	if page == 1 then
		RankList = ManagerContainer.DataMgr.GuildDemonData:GetGuildInfos()
		local guildInfo = ManagerContainer.DataMgr.GuildDemonData:GetRankSelfGuildBrief()
		if guildInfo then
			local rank = guildInfo.rank
			local harmValue = guildInfo.damage
			local brief = guildInfo.data.brief
			local data = {rank = rank,damage = harmValue,brief = brief}
			DemonGuildRankItemCtr:SetData(self,self.myGuildRank,data)
		else 
			self.myGuildRank:SetActive(false)
		end
	elseif page == 2 then
		local mvpInfo = ManagerContainer.DataMgr.GuildDemonData:GetRankSelfMvpInfo() 
		if mvpInfo then
			local data = {rank = mvpInfo.rank,damage = mvpInfo.damage,guildName = mvpInfo.guild_name,guildBadeg =mvpInfo.guild_badge,isSelf = true}
			DemonChampRankItemCtr:SetData(self,self.mvpRank,data)
		else
			self.mvpRank:SetActive(false)
		end
	end
	if not RankList then
		return
	end
end

function UIGuildDemonRankView:OnClickOtherHeadBtn(button,params)
	local uid = params[0]
	local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
	if selfUid == uid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIGuildDemonRankView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self.scrollView.scrollRect.enabled = true
end


function UIGuildDemonRankView:OnValueChangedToggle(toggle, PageType, isOn)
	if not isOn then return end
	if self.controller:SetPageType(PageType) then
		local page = self.controller:GetPageType()
		if page == 1 then
			ManagerContainer.DataMgr.GuildDemonData:ClearGuildMvpRankViewInfos()
			ManagerContainer.DataMgr.GuildDemonData:SendGetGuildDemonRankInfoReq()
		elseif page == 2 then
			ManagerContainer.DataMgr.GuildDemonData:ClearGuildRankViewInfos()
			ManagerContainer.DataMgr.GuildDemonData:SendGetGuildDemonMvpRankInfoReq()
		end
	end
end

function UIGuildDemonRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGuildDemonRankView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.closeBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddToggleEventListener(self.guildRank.toggle, self, self.OnValueChangedToggle, 1)
	self.uiBase:AddToggleEventListener(self.playerRank.toggle, self, self.OnValueChangedToggle, 2)
end

function UIGuildDemonRankView:OnHide()

end

function UIGuildDemonRankView:OnClickCloseBtn()
	self:UIClose()
end

function UIGuildDemonRankView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildDemonRankView:OnClose()
end

function UIGuildDemonRankView:OnDispose()
	self.controller:OnDispose()
	if self.loadStatusLoopListCtr then
		self.loadStatusLoopListCtr:Dispose()
		self.loadStatusLoopListCtr = nil
	end
	ManagerContainer.DataMgr.GuildDemonData:ClearGuildRankViewInfos()
	ManagerContainer.DataMgr.GuildDemonData:ClearGuildMvpRankViewInfos()
end

return UIGuildDemonRankView

