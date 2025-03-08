local CompetitionExchange = class("CompetitionExchange")
local IconItemCtr = require("Common/IconItemCtr")

local itemIdx = 0
local scores
function CompetitionExchange:ctor()
    self.root = nil
end

function CompetitionExchange:Init(root)
    self.root = root

    local content = GlobalConfig.Instance:GetConfigStrValue(219)
    if content ~= "" and content ~= nil then
        scores = CommonUtil.DeserializeGlobalStrToTable(content)
    end
    self:AddEventListener()
    self:Refresh()
end

function CompetitionExchange:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.root.uiData.name, UIEventNames.SEASON_EXCHANGE_NTF, function(delta)
        self:Refresh()
        if delta > 0 then
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("CompetitionTip4", delta)
        end
    end)
end

function CompetitionExchange:Refresh()
    local curCompetitionData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
    self.root.myScore.num.text.text = curCompetitionData.comParam

    local seasons = ManagerContainer.CfgMgr:GetCompetitionDatasByType(curCompetitionData.competitionId)
    if not next(seasons) then
        return
    end
    local competitionType = seasons[1].CompetitionType
    local percent = ManagerContainer.DataMgr.CompetitionData:GetRankPercent()
    if percent > 0 then
        local tips = ""--percent > 60 and I18N.T("DscSeasonTips3") or I18N.T("DscSeasonTips4")
        self.root.collection.num.uILocalizeScript:SetContentAndValues("DscSeasonR"..competitionType, {tips, percent, ""})
    else
        self.root.collection.num.uILocalizeScript:SetContentAndValues("DscSeasonR"..competitionType, {I18N.T("DscSeasonTips4"), 60, ""})
    end

    local periodIdx = ManagerContainer.DataMgr.CompetitionData:GetCurPeriodIdx()
    if not periodIdx then
        return
    end

    local periodData = ManagerContainer.DataMgr.CompetitionData:GetCurPeriodData(periodIdx)
    if not periodData then
        return
    end

    local rewardCompetitionId = periodData.paramList[1]
    self.competitionCfgData = ManagerContainer.CfgMgr:GetCompetitionDataById(rewardCompetitionId)
    if not self.competitionCfgData then
        return
    end

    CommonUtil.LoadIcon(self.root, self.competitionCfgData.CompetitionTitleIcon, function (sprite)
        self.root.reward.icon.image.sprite = sprite
    end)

    self.root.reward.num.uILocalizeScript:SetContent(self.competitionCfgData.CompetitionTitle)

    local delta = curCompetitionData.nextComScore - curCompetitionData.comParam
    self.root.next:SetActive(percent > 0 and delta > 0)
    self.root.next.num.text.text = delta

    self:RefreshExchangeItems()
end

local function GetScore(id)
    for k,v in pairs(scores) do
        if tonumber(v[1]) == id then
            if k < 4 then
                return v[2]
            elseif k == 4 then
                return v[2].."~"..v[3]
            end
        end
    end
    return 0
end

function CompetitionExchange:RefreshExchangeItems()
    if not self.competitionCfgData then return end

    local items = self.competitionCfgData.HuodongItem
    for i = 1, 4 do
        local item = self.root["item"..i]
        if items and item and items[i] then
            local itemData = ManagerContainer.DataMgr.BagData:GetItemByCfgId(items[i])
            local num = itemData and itemData.num or 0
            local data = {cfgId = items[i], num = num}
            item.num.text.text = GetScore(items[i])
            IconItemCtr:SetData(self.root, item.iconSmallItem, data, Enum.ItemIEnterType.Bag, self.root, self.root.ShowItemTips)

            item.iconSmallItem.num:SetActive(true)
            item.iconSmallItem.num.text.text = num
        end
    end
end

function CompetitionExchange:ShowItemTips(button, params)
    local data = params[0]
    local itemData = ManagerContainer.DataMgr.BagData:GetItemDataByCfgId(data.cfgId)
    if not itemData then
        itemData = data
    end
    local data1 = clone(itemData)
    data1.displayBtn = true
    local _extData = {_id = data1.id}
    ManagerContainer.LuaUIMgr:OpenTips(data1, _extData)
end

function CompetitionExchange:OnSureClick(button, params)
    if not self.competitionCfgData then return end

    local idx = params[0]

    local itemList = {}
    local items = self.competitionCfgData.HuodongItem
    local itemData = ManagerContainer.DataMgr.BagData:GetItemByCfgId(items[idx])
    local cfgData = ManagerContainer.CfgMgr:GetItemById(items[idx])
    local num = itemData and itemData.num or 0
    if num > 0 then
        itemList[#itemList + 1] = {key = items[idx], value = idx < 4 and num or 1}
    end
    if #itemList == 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(idx < 4 and "DscSeasonResult11" or "DscSeasonResult12", I18N.T(cfgData.Name))
        return
    end

    ManagerContainer.DataMgr.CompetitionData:SendExchangeScoreReq(itemList)
end

function CompetitionExchange:Dispose()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SEASON_EXCHANGE_NTF_MAIN)

    self.competitionCfgData = nil

    self.root = nil
end

return CompetitionExchange