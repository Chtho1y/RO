local UIGuildWarActivityShopCtr = class("UIGuildWarActivityShopCtr", require("UICtrBase"))

function UIGuildWarActivityShopCtr:Init(view)
	self.view = view
end

function UIGuildWarActivityShopCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildWarActivityShopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildWarActivityShopCtr:GetData()
	return self.data
end

function UIGuildWarActivityShopCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.shopType = nil
	self.shopSubType = nil
	self.idx = nil
end

function UIGuildWarActivityShopCtr:InitData()
    self.shopType = Enum.RuneShopType.GuildWar
    local guildsmenRewords = {}
    local mvpRewords = {}
    local GuildWarAgainstCfg = ManagerContainer.CfgMgr:GetGuildWarAgainstCfg()
    for key, value in pairs(GuildWarAgainstCfg) do
        if value.Ranking > 0 and value.GuildsmenReword then
            local itemDatas = {}
            for _,v in pairs(value.GuildsmenReword) do
                local itemData = {cfgId = v[1], num = v[2]}
                itemDatas[#itemDatas + 1] = itemData
            end
            guildsmenRewords[#guildsmenRewords + 1] = {value.Ranking, value.GuildsmenName, itemDatas}
        end
        if (value.PointMvp > 0 and value.PointMvpReword) then
            local itemDatas = {}
            for _,v in pairs(value.PointMvpReword) do
                local itemData = {cfgId = v[1], num = v[2]}
                itemDatas[#itemDatas + 1] = itemData
            end
            mvpRewords[#mvpRewords + 1] = {1, value.PointMvp, value.PointMvpName, itemDatas}
        end
        if (value.KillerMvp > 0 and value.KillerMvpReword) then
            local itemDatas = {}
            for _,v in pairs(value.KillerMvpReword) do
                local itemData = {cfgId = v[1], num = v[2]}
                itemDatas[#itemDatas + 1] = itemData
            end
            mvpRewords[#mvpRewords + 1] = {2, value.KillerMvp, value.KillerMvpName, itemDatas}
        end
    end
    table.sort(guildsmenRewords, function (a, b)
        return a[1] < b[1]
    end)
    table.sort(mvpRewords, function (a, b)
        if a[2] == b[2] then
            return a[1] < b[1]
        end
        return a[2] < b[2]
    end)

    self.guildsmenRewords = guildsmenRewords
    self.mvpRewords = mvpRewords
end

function UIGuildWarActivityShopCtr:GetIdx()
	return self.idx
end

function UIGuildWarActivityShopCtr:GetCurShopType()
    return self.shopType, self.shopSubType
end

function UIGuildWarActivityShopCtr:RefreshCurShopData(forceRefresh)
	 ManagerContainer.DataMgr.RuneShopDataMgr:RefreshShopData(self.shopType, self.shopSubType, forceRefresh)
	self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
	if self.curShopData then
		if not self.curShopData:IsValidShow() then
			self.curShopData:RefreshShowGoodsDatas()
		end
		return true
	end
	return false
end

function UIGuildWarActivityShopCtr:GetGuildsmenRewords()
    return self.guildsmenRewords
end

function UIGuildWarActivityShopCtr:GetMvpRewords()
    return self.mvpRewords
end

function UIGuildWarActivityShopCtr:GetShowGoodsDatas()
    if not self.curShopData then
        self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
        if self.curShopData then
            if not self.curShopData:IsValidShow() then
                self.curShopData:RefreshShowGoodsDatas()
            end
        end
    end
	return self.curShopData and self.curShopData:GetShowGoodsDatas() or nil
end

function UIGuildWarActivityShopCtr:SendPay(goodsId)
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(self.shopType, self.shopSubType, goodsId)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

function UIGuildWarActivityShopCtr:SendRewardReq(rewardType)
	ManagerContainer.DataMgr.RankActivitiesMgr:SendRewardReq(self.type, rewardType)
end

return UIGuildWarActivityShopCtr