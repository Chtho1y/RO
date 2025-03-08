local UIHundredDojoGuildRankView = require("UIHundredDojo/UIHundredDojoGuildRankView_Generate")

function UIHundredDojoGuildRankView:OnAwake(data)
	self.controller = require("UIHundredDojo/UIHundredDojoGuildRankCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIHundredDojoGuildRankView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_CP_RANK_LIST_CHANGED, self, self.OnGuildCPRankListChanged)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_ENTER_SUCCESS, self, self.OnGuildEnterSuccess)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GUILD_CREATE_SUCCESS, self, self.OnGuildCreateSuccess)
end

function UIHundredDojoGuildRankView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIHundredDojoGuildRankView:Init()
	self.scrollView.loopGridView:InitGridView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)
	self.scrollView.loopGridView.ScrollRect.enabled = false
	self:RefreshListView()
	self:RefreshSelfView()

	local errorCode = self.controller:SendGuildWarCPRankReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIHundredDojoGuildRankView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIHundredDojoGuildRankView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonUniqueEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
end

function UIHundredDojoGuildRankView:OnHide()

end

function UIHundredDojoGuildRankView:OnShow(data)
	self.controller:SetData(data)

end

function UIHundredDojoGuildRankView:OnClose()
end

function UIHundredDojoGuildRankView:OnDispose()
	self.scrollView.loopGridView:Dispose()
	self.controller:OnDispose()
end

function UIHundredDojoGuildRankView:OnPageInEnd()
	UIHundredDojoGuildRankView.super.OnPageInEnd(self)
	self.scrollView.loopGridView.ScrollRect.enabled = true
end

function UIHundredDojoGuildRankView:OnGuildCPRankListChanged(data)
	self.controller:SetRankDatas(data)
	self:RefreshListView()
	self:RefreshSelfView()
end

function UIHundredDojoGuildRankView:OnGuildEnterSuccess()
	local errorCode = self.controller:SendGuildWarCPRankReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIHundredDojoGuildRankView:OnGuildCreateSuccess()
	local errorCode = self.controller:SendGuildWarCPRankReq()
	if errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIHundredDojoGuildRankView:OnClickCloseBtn()
	self:UIClose()
end


function UIHundredDojoGuildRankView:OnClickGuildItem(btn, param)
	local id = param[0]
	if not id then return end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIGuildInfo, id)
end

function UIHundredDojoGuildRankView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local rankData = self.controller:GetRankDataByItemIdx(itemIndex)
	if not rankData then return nil end
	local item = gridView:NewListViewItem('HundredDojoGuildRankItem')
	local itemLua = CommonUtil.BindGridViewItem2Lua(self, 'HundredDojoGuildRankItem', item.gameObject)
	local brief = rankData.brief
	local guildCP = rankData.cp_num or 0
	local guildRank = rankData.rank or 0
	if brief then
		local badgeResPath = nil
		if brief.guild_badge then
			local badgeCfgData = ManagerContainer.CfgMgr:GetGuildBadgeCfgById(brief.guild_badge)
			if badgeCfgData then
				badgeResPath = badgeCfgData.Pic
			end
		end
		self:RefreshGuildInfoItem(itemLua, brief.guild_id, brief.guild_name, brief.guild_level, badgeResPath, guildCP, true)
	else
		self:RefreshGuildInfoItem(itemLua)
	end
	self:RefreshGuildRankInfoItem(itemLua, guildRank)
	return item
end


function UIHundredDojoGuildRankView:RefreshGuildInfoItem(itemLua, guildId, guildName, guildLv, badgeResPath, guildCP, isClick)
	if not itemLua then return end
	itemLua.badge.image.enabled = false
	itemLua.badge.image.sprite = nil
	if not guildId then
		itemLua.nameTxt.text.text = ''
		itemLua.lvTxt.text.text = ''
		itemLua.guildCPTxt.text.text = ''
		itemLua.button.onClick:RemoveAllListeners()
		return
	end
	CommonUtil.LoadIcon(self, badgeResPath, function(sprite)
		if sprite then
			itemLua.badge.image.enabled = true
			itemLua.badge.image.sprite = sprite
		end
	end, itemLua, 'BadgeIcon')
	itemLua.nameTxt.text.text = tostring(guildName)
	itemLua.lvTxt.text.text = string.formatbykey('Lv') .. tostring(guildLv)
	itemLua.guildCPTxt.text.text = tostring(guildCP)
	if isClick then
		self.uiBase:AddButtonUniqueEventListener(itemLua.button, self, self.OnClickGuildItem, guildId)
	end
end

function UIHundredDojoGuildRankView:RefreshGuildRankInfoItem(itemLua, rank)
	if not itemLua then return end
	if not rank or rank <= 0 then
		itemLua.rank1:SetActive(false)
		itemLua.rank2:SetActive(false)
		itemLua.rank3:SetActive(false)
		itemLua.rank4:SetActive(false)
		itemLua.rankTxt.text.text = string.formatbykey('NoRank')
		itemLua.rankTxt:SetActive(true)
		return
	end
	itemLua.rank1:SetActive(rank == 1)
	itemLua.rank2:SetActive(rank == 2)
	itemLua.rank3:SetActive(rank == 3)
	itemLua.rank4:SetActive(rank == 4)
	if rank > 4 then
		itemLua.rankTxt.text.text = tostring(rank)
		itemLua.rankTxt:SetActive(true)
	else
		itemLua.rankTxt:SetActive(false)
	end
end


function UIHundredDojoGuildRankView:RefreshListView()
	local length = self.controller:GetRankListLength()
	if length <= 0 then
		self.noGuildList:SetActive(true)
		self.scrollView:SetActive(false)
		return
	end
	self.noGuildList:SetActive(false)
	self.scrollView:SetActive(true)
	self.scrollView.loopGridView:RefreshListByIndex(length, 0)
end

function UIHundredDojoGuildRankView:RefreshSelfView()
	if not self.controller:HasGuild() then
		self.noGuild:SetActive(true)
		self.selfRank:SetActive(false)
		return
	end
	local guildData = self.controller:GetCurGuildData()
	if not guildData then
		self.noGuild:SetActive(true)
		self.selfRank:SetActive(false)
		return
	end
	self.noGuild:SetActive(false)
	self.selfRank:SetActive(true)
	local brief = guildData:GetBriefData()
	local guildCP, guildRank = self.controller:GetSelfGuildCPAndRank()
	if brief then
		self:RefreshGuildInfoItem(self.selfRank, brief.id, brief.name, brief.level, brief.badgeResPath, guildCP, false)
	else
		self:RefreshGuildInfoItem(self.selfRank)
	end
	self:RefreshGuildRankInfoItem(self.selfRank, guildRank)
end



return UIHundredDojoGuildRankView

