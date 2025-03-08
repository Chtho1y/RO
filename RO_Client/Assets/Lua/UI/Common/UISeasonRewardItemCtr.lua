local UISeasonRewardItemCtr = {}

function UISeasonRewardItemCtr:SetData(wnd, item, logicData)
    local cfgData = logicData.cfgData
    local curId = logicData.curId
    local selectedPeriodIdx = logicData.selectedPeriodIdx
    local curPeriodIdx = logicData.curPeriodIdx
    local hasData = logicData.hasData
    local competitionId = logicData.competitionId

    CommonUtil.LoadIcon(wnd, cfgData.CompetitionTitleIcon, function (sprite)
        item.icon.image.sprite = sprite
    end)

    if cfgData.LabelIcon then
        CommonUtil.LoadIcon(wnd, cfgData.LabelIcon, function (sprite)
            item.flag.image.sprite = sprite
        end)
    end

    item.rewardName.text.text = I18N.T(cfgData.CompetitionTitle)
    local tips1 = I18N.T("DscSeasonTips5")
    if competitionId ~= 1 and competitionId == cfgData.CompetitionCondition[1][1] then --偶像祭特殊显示
        local minRank = cfgData.CompetitionCondition[1][2] 
        local maxRank = cfgData.CompetitionCondition[1][3]
        if minRank == maxRank then
            item.progress.text.text = I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType,"",I18N.SetLanguageValue("DscSeasonTips6",minRank), tips1)
        else
            item.progress.text.text = I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType,"",I18N.SetLanguageValue("DscSeasonTips6",minRank).."-"..I18N.SetLanguageValue("DscSeasonTips6",maxRank), tips1)
        end
    else
        item.progress.text.text = cfgData.CompetitionCondition[1][2] > 0 and I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionType, I18N.T("DscSeasonTips3"), cfgData.CompetitionCondition[1][2], tips1) or I18N.SetLanguageValue("DscSeasonR"..cfgData.CompetitionId, I18N.T("DscSeasonTips4"), cfgData.CompetitionCondition[1][3], tips1)
    end
    --item.cornerMark:SetActive(cfgData.Id == curId)
    item.cornerMark:SetActive(hasData and cfgData.Id == curId and selectedPeriodIdx >= curPeriodIdx)
    item.rewarded:SetActive(hasData and cfgData.Id == curId and selectedPeriodIdx < curPeriodIdx)

    local list = cfgData["CompetitionReward"..selectedPeriodIdx]
    CommonUtil.LoopGridViewEleCreateNew(wnd, item.scrollView.loopHorizontalScrollRect, item.content.gridLayoutGroup, list, 0, nil, function (itemLua, idx)
        local data = {cfgId = list[idx + 1][1], num = list[idx + 1][2]}
        CommonUtil.UpdateItemPrefab(wnd, itemLua, data, Enum.ItemIEnterType.Bag, wnd, wnd.ShowItemTips)
    end)
end

return UISeasonRewardItemCtr