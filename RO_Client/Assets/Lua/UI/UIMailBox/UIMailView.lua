local UIMailView = require("UIMailBox/UIMailView_Generate")
local BitUtil = require("BitUtil")

local MailIdEnum = {
	ArenaRank = 10001,
	ArenaDan = 10002,
	SeasonReward1 = 20001,
	SeasonReward2 = 20002,
}

function UIMailView:OnAwake(data)
	self.controller = require("UIMailBox/UIMailCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIMailView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REWARD_MAIL, self, self.RewardMail)
end

function UIMailView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIMailView:Init()
	local data = self.controller:GetData()
	self:RefreshState()
	local param, param1
	if data.paramList then
		param = data.paramList[1]
		param1 = data.paramList[2]
		if data.type == Enum.MailType.Competition then
			--if data.configId == MailIdEnum.SeasonReward1 or data.configId == MailIdEnum.SeasonReward2 then
				if data.paramList[1] then
					local conpetionId = data.paramList[1]
					local competionData = ManagerContainer.CfgMgr:GetCompetitionDataById(conpetionId)
					param = I18N.T(competionData.CompetitionName)
					param1 = I18N.T(competionData.CompetitionTitle)
				end
			--end
		elseif data.type == Enum.MailType.VipLevelUp then
			local vipLv = data.paramList[1]
			local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
			if vipCfg then
				param = I18N.T(vipCfg.Name)
			end
		elseif data.type == Enum.MailType.GuildWarHight then
			local id = data.paramList[1]
			local langKey = self:GetGuildWarRewardName(id, 'Ranking', 'DeaconName')
			if langKey then
				param = I18N.T(langKey)
			end
		elseif data.type == Enum.MailType.GuildWarNormal then
			local id = data.paramList[1]
			local langKey = self:GetGuildWarRewardName(id, 'Ranking', 'GuildsmenName')
			if langKey then
				param = I18N.T(langKey)
			end
		elseif data.type == Enum.MailType.GuildWarScore then
			local id = data.paramList[1]
			local langKey = self:GetGuildWarRewardName(id, 'PointMvp', 'PointMvpName')
			if langKey then
				param = I18N.T(langKey)
			end
		elseif data.type == Enum.MailType.GuildWarKiller then
			local id = data.paramList[1]
			local langKey = self:GetGuildWarRewardName(id, 'KillerMvp', 'KillerMvpName')
			if langKey then
				param = I18N.T(langKey)
			end
		elseif data.type == Enum.MailType.GuildDemonBoss then
			local id = data.paramList[1]
			if id and id > 0 then
				local data = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(id)
				if data and data.WeekDay then
					param = I18N.T('DemonMailDesc0'..data.WeekDay)
				end
			end
		else
			if data.configId == MailIdEnum.ArenaRank then
				param = data.paramList[1]
			elseif data.configId == MailIdEnum.ArenaDan then
				local levelId = data.paramList[1]
				local arenaLevelData = ManagerContainer.CfgMgr:GetArenaLevelById(levelId)
				param = I18N.T(arenaLevelData.ArenaLevelName)
			end
		end
	end

	local mailTitle, mailContent = data.title, data.content
	local mailCfgData = ManagerContainer.CfgMgr:GetMailDataByCfgId(data.configId)
	if mailCfgData then
		mailTitle = I18N.T(mailCfgData.Title)
		mailContent = I18N.SetLanguageValue(mailCfgData.Text, param, param1)
	end

	self.mailTtle.text.text = mailTitle
	self.text.text.text = mailContent

	if data.expireTime then
		local endTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(data.expireTime)
		local time = DateTimeUtil.convertSeconds2TimeStr1(endTime, true, false)
		self.timer.text.text = I18N.SetLanguageValue("RemainTime", time)
	end

	local award = data.rewardList and #data.rewardList > 0
	self.award:SetActive(award)
	self.btnDraw:SetActive(award)
	if award then
		CommonUtil.LoopGridViewEleCreateNew(self, self.scrollView.loopHorizontalScrollRect, self.content.horizontalLayoutGroup, data.rewardList, 0, self, self.UpdateAwardItem)
	end
end

function UIMailView:UpdateAwardItem(itemLua, idx, itemData)
	if not itemLua or not itemData then
		return
	end
	local data = {cfgId = itemData.key, num = itemData.value}
	CommonUtil.UpdateItemPrefab(self, itemLua, data, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
end

function UIMailView:ShowItemTips(button, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIMailView:RefreshState()
	local data = self.controller:GetData()
	local state = data.state

	local readState = BitUtil.ParseMailReadState(state) == 1
	local rewardState = BitUtil.ParseMailRewardState(state) == 1

	self.litter:SetActive(not readState)
	self.item:SetActive(not readState and not rewardState and #data.rewardList > 0)
	self.litterOpen:SetActive(readState)
	self.itemOpen:SetActive(readState and not rewardState and #data.rewardList > 0)

	--CommonUtil.SetTotalChildrenGray(self.btnDraw, rewardState)
	self.btnDraw.text.uILocalizeScript:SetContent(rewardState and "BtnHaveReceive" or "BtnReceive")
	self.btnDraw.button.interactable = not rewardState
end

function UIMailView:RewardMail(needRefresh)
	if needRefresh then
		local data = self.controller:GetData()
		local id = data.id
		data = ManagerContainer.DataMgr.MailData:GetMailDataById(id)
		self.controller:SetData(data)
	end
	self:RefreshState()
end

function UIMailView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIMailView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnDraw.button, function ()
		local data = self.controller:GetData()
		local rewardState = BitUtil.ParseMailRewardState(data.state) == 1
		if rewardState then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("RewardAlready")
			return
		end
		self.controller:SendRewardMail(data.id)
	end)
end

function UIMailView:OnHide()


end

function UIMailView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIMailView:OnClose()

end

function UIMailView:OnDispose()
	self.scrollView.loopHorizontalScrollRect:ClearCells()

end


function UIMailView:OnDispose()
end


function UIMailView:GetGuildWarRewardName(id, keyName, desName)
	local GuildWarAgainstCfg = ManagerContainer.CfgMgr:GetGuildWarAgainstCfg()
	if GuildWarAgainstCfg then
		for key, value in pairs(GuildWarAgainstCfg) do
			if value[keyName] == id then
				return value[desName]
			end
		end
	end
end

return UIMailView

