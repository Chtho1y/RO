local ChatTextItemCtr = {}
local TaskJumpCtr = require("Common/TaskJumpCtr")

function ChatTextItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB)
    item.chlWorld:SetActive(false)
    item.chlSystem:SetActive(logicData.isSystem and logicData.type ~= Enum.ChatSystemType.Guild)
    item.chlGuildSystem:SetActive(logicData.isSystem and logicData.type == Enum.ChatSystemType.Guild)

    --item.system:SetActive(enterType == Enum.ItemIEnterType.System)
    --item.player:SetActive(enterType ~= Enum.ItemIEnterType.System)
    item.easyPlayer:SetActive(not logicData.isSystem)
    item.vipIcon.image.enabled = false
    item.vipIcon.image.sprite = nil
    item.titleImg.image.enabled = false
    item.titleImg.image.sprite = nil

    item.text.symbolText.raycastTarget = false
    if item.text.symbolTextEvent then
        item.text.symbolTextEvent:RegisterClickEvent(nil, nil)
    end
    if enterType == Enum.ItemIEnterType.System then
        --公告类型 1通关 2获得伙伴 3宝箱 4稀有道具
        local paramName = ""
        if logicData.type == Enum.ChatSystemType.Loggedin then
            item.text.symbolText.text = I18N.T(logicData.nickname)
            --local content = I18N.T(logicData.nickname)
            --item.text.symbolText.text = "#h"..content.."{6}#h"
            --if item.text.symbolTextEvent then
            --    item.text.symbolTextEvent:RegisterClickEvent(wnd, wnd.SystemChatHyperClick)
            --end
        elseif logicData.type == Enum.ChatSystemType.PassMap then
            local levelData = ManagerContainer.CfgMgr:GetLevelDataById(logicData.paramIds[1])
            if levelData ~= nil then
                paramName = levelData.Name
                item.text.symbolText.text = I18N.SetLanguageValue("SystemMessageType1", CommonUtil.GetVaildNickName(logicData.nickname), I18N.T(paramName))
            end
        elseif logicData.type == Enum.ChatSystemType.Item then
            local itemData = ManagerContainer.CfgMgr:GetItemById(logicData.paramIds[1])
            paramName = string.format(Constant.ChatSystemColorArray[itemData.Quality], I18N.T(itemData.Name))
            local num = (logicData.paramIds[2] and logicData.paramIds[2] > 1) and "x"..logicData.paramIds[2] or ""
            local sourceType = logicData.paramIds[3]
            local sourceItemId = logicData.paramIds[4]
            if sourceType then
                if sourceType ~= Enum.DropSource.Gift then
                    item.text.symbolText.text = I18N.SetLanguageValue("ChatNotice01", CommonUtil.GetVaildNickName(logicData.nickname), paramName, I18N.T("dropsource_"..sourceType))..num
                else
                    if sourceItemId == 514 then
                        --老旧卡包
                        item.text.symbolText.text = I18N.SetLanguageValue("ChatNotice01", CommonUtil.GetVaildNickName(logicData.nickname), paramName, I18N.T("dropsource_"..sourceType.."_"..sourceItemId))..num
                    end
                end
            end
        elseif logicData.type == Enum.ChatSystemType.WorldBoss then
            local worldBossName = ""
            if logicData.paramIds and logicData.paramIds[1] then                
                local worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(logicData.paramIds[1],0)
                if nil == worldBossCfgData then
                    worldBossCfgData = ManagerContainer.DataMgr.WorldBossData:GetWorldBossDataById(logicData.paramIds[1],1)
                end
                if worldBossCfgData then
                    local npcCfgData = ManagerContainer.CfgMgr:GetNpcCfgById(worldBossCfgData.SummonId)
                    if npcCfgData then
                        worldBossName = I18N.SetLanguageValue(npcCfgData.Name)
                    end
                end
            end
            local content = I18N.SetLanguageValue("SystemMessageType6", worldBossName, "{"..logicData.type.."}")
            item.text.symbolText.text = content --"#h"..content.."{"..logicData.type.."}#h"
            if item.text.symbolTextEvent then

                item.text.symbolText.raycastTarget = true
                item.text.symbolTextEvent:RegisterClickEvent(nil, function (hyperParam)
                    local systemType = tonumber(hyperParam)
                    if systemType == 6 then
                        --世界BOSS
                        TaskJumpCtr:JumpBuyCfgId(15)
                    end
                end)
            end
        elseif logicData.type == Enum.ChatSystemType.ArenaWinStreak then
            item.text.symbolText.text = I18N.SetLanguageValue("ArenaNotice", CommonUtil.GetVaildNickName(logicData.nickname), unpack(logicData.paramIds))
        elseif logicData.type == Enum.ChatSystemType.TimeLimitDel then
            item.text.symbolText.text = I18N.SetLanguageValue("CompetitionTip2", logicData.nickname)
        elseif logicData.type == Enum.ChatSystemType.ItemExchange then
            local activityData = ManagerContainer.CfgMgr:GetActivityCfg(logicData.paramIds[1])
            local activityName = activityData and activityData.Name or ""
            local exchangeData  = ManagerContainer.CfgMgr:GetActivitiesPetExchangeCfgById(logicData.paramIds[2])
            local itemCfgId   = exchangeData and exchangeData.Reward and exchangeData.Reward[1][1] or 0
            local itemData    = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
            local itemName = itemData and itemData.Name or ""
            if itemData.ResType == Enum.ItemType.Card then
                local cardData = ManagerContainer.CfgMgr:GetCardDataById(itemCfgId)
                local lv  = cardData.CardLevel
                item.text.symbolText.text = I18N.SetLanguageValue("ChangeTakeNotice1", CommonUtil.GetVaildNickName(logicData.nickname),activityName,lv,itemName)
            else
                item.text.symbolText.text = I18N.SetLanguageValue("ChangeTakeNotice", CommonUtil.GetVaildNickName(logicData.nickname),activityName,itemName)
            end
        elseif logicData.type == Enum.ChatSystemType.StarDivine then
            local data = ManagerContainer.CfgMgr:GetCompetitionDevineCfgById(logicData.paramIds[1] + 1)
            if data and data.BroadcastKey then
                item.text.symbolText.text = I18N.SetLanguageValue(data.BroadcastKey, CommonUtil.GetVaildNickName(logicData.nickname))
            end
        elseif logicData.type == Enum.ChatSystemType.GuildDemonBoss then
            if logicData.paramIds and logicData.paramIds[1] then 
                item.text.symbolText.text = I18N.SetLanguageValue("GuildDemonBossNotice", logicData.nickname,logicData.paramIds[2])
            end
        elseif logicData.type == Enum.ChatSystemType.IdolGiftBroad then
            item.text.symbolText.text = I18N.SetLanguageValue("IdolGiftBroad", CommonUtil.GetVaildNickName(logicData.nickname))
        elseif logicData.type == Enum.ChatSystemType.Competition then
            local content = ""
            local score = logicData.paramIds[1] or 0
            if score < 101 then
                content = "CompetitionTip5"
            elseif score < 401 then
                content = "CompetitionTip6"
            elseif score < 501 then
                content = "CompetitionTip7"
            end
            item.text.symbolText.text = I18N.SetLanguageValue(content, CommonUtil.GetVaildNickName(logicData.nickname), score)
        elseif logicData.type == Enum.ChatSystemType.Guild then
            if logicData.paramIds then
                local type = logicData.paramIds[1]
                if type == 1 then
                    item.text.symbolText.text = I18N.SetLanguageValue('Guildchat_003', CommonUtil.GetVaildNickName(logicData.nickname), CommonUtil.GetGuildPostStr(logicData.paramIds[2]))
                elseif type == 2 then
                    item.text.symbolText.text = I18N.SetLanguageValue('Guildchat_001', CommonUtil.GetVaildNickName(logicData.nickname))
                elseif type == 3 then
                    item.text.symbolText.text = I18N.SetLanguageValue('Guildchat_002', CommonUtil.GetVaildNickName(logicData.nickname), CommonUtil.GetGuildPostStr(logicData.paramIds[2]), "{".. logicData.paramIds[3] .."}")
                    if item.text.symbolTextEvent then
                        item.text.symbolText.raycastTarget = true
                        item.text.symbolTextEvent:RegisterClickEvent(nil, function (hyperParam)
                            TaskJumpCtr:JumpBuyCfgId(20, tonumber(hyperParam))
                        end)
                    end
                end
            end
        elseif logicData.type == Enum.ChatSystemType.TurnWheelPrize then           
            if logicData.paramIds then
                local ItemId = logicData.paramIds[1]
                local ItemCount = logicData.paramIds[2]
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(ItemId)
                if itemCfgData then
                    local paramName = string.format(Constant.ChatSystemColorArray[itemCfgData.Quality], I18N.T(itemCfgData.Name))
                    local num = (ItemCount and ItemCount > 1) and "x"..logicData.paramIds[2] or ""
                    item.text.symbolText.text = I18N.SetLanguageValue("ChatNotice01", CommonUtil.GetVaildNickName(logicData.nickname), paramName , I18N.T("dropsource_dajiang"))..num
                end
            end
        elseif logicData.type == Enum.ChatSystemType.ActivityWheel then           
            if logicData.paramIds then
                local actitivyId = logicData.paramIds[1]
                local ItemId = logicData.paramIds[2]
                local ItemCount = logicData.paramIds[3]
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(ItemId)
                local ActivityName = ""
                if actitivyId then
                    local cfgData = ManagerContainer.CfgMgr:GetActivityCfg(actitivyId)
                    if cfgData then
                        ActivityName = cfgData.Name
                    end
                end
                if itemCfgData then
                    local num = (ItemCount and ItemCount > 1) and "x"..logicData.paramIds[3] or ""
                    item.text.symbolText.text = I18N.SetLanguageValue("ActivityRoulettel", CommonUtil.GetVaildNickName(logicData.nickname), ActivityName ,  I18N.T(itemCfgData.Name))..num
                end
            end
        elseif logicData.type == Enum.ChatSystemType.ActCollection then
            if logicData.paramIds then
                local actitivyId = logicData.paramIds[1]
                if actitivyId then
                    local cfgData = ManagerContainer.CfgMgr:GetActivityCfg(actitivyId)
                    if cfgData then
                        if cfgData.Type == Enum.ActivityType.ACTIVITY_TYPE_FESTIVAL_REWARD then
                            local actitivySubId = logicData.paramIds[2]
                            local subCfgData = ManagerContainer.CfgMgr:GetActivitiesCollectionCfgById(actitivySubId)
                            if subCfgData and subCfgData.ShowItem then
                                local itemListStr = nil
                                for i = 1, #subCfgData.ShowItem do
                                    local itemId = subCfgData.ShowItem[i]
                                    
                                    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemId)
                                    if itemCfgData then
                                        if itemListStr then
                                            itemListStr = itemListStr .. ',' .. I18N.T(itemCfgData.Name)
                                        else
                                            itemListStr = I18N.T(itemCfgData.Name)
                                        end
                                    end
                                end
                                if itemListStr then
                                    item.text.symbolText.text = I18N.SetLanguageValue("SetsWordActivity04", CommonUtil.GetVaildNickName(logicData.nickname), I18N.T(cfgData.Name), itemListStr)
                                end
                            end
                        end
                    end
                end
                
            end
        elseif logicData.type == Enum.ChatSystemType.GoddessLike then
            if logicData.paramIds then
                local actitivyId = logicData.paramIds[1]
                local ItemId = logicData.paramIds[2]
                local ItemCount = logicData.paramIds[3]
                local cfgData = ManagerContainer.CfgMgr:GetActivityCfg(actitivyId)
                local actName = cfgData and string.formatbykey(cfgData.Name) or ''
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(ItemId)
                local itemName = nil
                if itemCfgData then
                    itemName = string.format(Constant.ChatSystemColorArray[itemCfgData.Quality], I18N.T(itemCfgData.Name))
                else
                    itemName = ''
                end
                item.text.symbolText.text = I18N.SetLanguageValue("GiftBroadcast", CommonUtil.GetVaildNickName(logicData.nickname), actName, tostring(ItemCount), itemName)
            end
        end
    else
        local fromData = logicData.fromData
        local content = logicData.message

        local context = CommonUtil.GetVaildNickName(fromData.nickname)
        item.nickname.text.text = context
        if fromData.sex ~= nil then
            CommonUtil.SetTextColor(item.nickname.text, fromData.sex  == 1 and Constant.PinkColorText or Constant.BlueColorText)
        end

        local vipLv = fromData.vipLv
        local vipIcon = nil
        if vipLv and vipLv >= 0 then
            local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
            if vipCfg then
                vipIcon = vipCfg.SmallIcon
            end
        end
        local titleId = fromData.titleId
        local titleIcon = nil
        if titleId and titleId > 0 then
            local titleCfg = ManagerContainer.CfgMgr:GetDesignationCfgById(titleId)
            if titleCfg then
                titleIcon = titleCfg.ChatSource
            end
        end
        CommonUtil.LoadIcon(wnd, titleIcon, function (sprite)
            if sprite then
                item.titleImg.image.sprite = sprite
                item.titleImg.image.enabled = true
            end
        end, item)
        CommonUtil.LoadIcon(wnd, vipIcon, function (sprite)
            if sprite then
                item.vipIcon.image.sprite = sprite
                item.vipIcon.image.enabled = true
            end
        end, item, 'VipIcon')

        local msg = content.message
        if content.subType == Enum.ChatSubType.Expedition then
            local expedition = Enum.ChatSubType.Expedition..";"..fromData.uid
            local color = content.used and Constant.GrayColorSymbolText or Constant.DefaultColorSymbolText
            local color1 = content.used and Constant.GrayColorSymbolText or Constant.OrangeColorSymbolText
            msg = color..I18N.SetLanguageValue("ExpeditionHelp4", color1, "{"..expedition.."}")
            if item.text.symbolTextEvent then
                item.text.symbolText.raycastTarget = not content.used
                if not content.used then
                    item.text.symbolTextEvent:RegisterClickEvent(nil, function (hyperParam)
                        local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
                        local isOneDay = ManagerContainer.LuaTimerMgr:TwoTimeSecondBetweenOneDay(content.sendTime, curTime)
                        if not isOneDay then
                            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionBailout")
                            content.used = true
                            return
                        end

                        local list = string.split(hyperParam, ";")
                        local uid = ManagerContainer.DataMgr.UserData:GetUserId()
                        if tostring(uid) == list[2] then
                            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionHelpLog2")
                            return
                        end

                        content.used = true
                        local systemType = tonumber(list[1])
                        if systemType == Enum.ChatSubType.Expedition then
                            --远征求助
                            local uid = int64.new(list[2])
                            ManagerContainer.DataMgr.ExpeditionDataMgr:SendRescueFriendReq(uid, Enum.ExpeditionHelpSource.Guild, content.sendTime64)
                        end
                    end)
                end
            end
        end

        if logicData.type == Enum.ChatDataType.Guild then
            item.text.symbolText.text = string.formatbykey('GuildChatColor', StringUtil.FilterEmoji(msg))
        else
            item.text.symbolText.text = StringUtil.FilterEmoji(msg)
        end

        if onClickOwner and onClickCB then
            item.player.button.interactable = true
            wnd.uiBase:AddButtonUniqueEventListener(item.nameBg.button, onClickOwner, onClickCB, item.player, fromData)
        else
            item.player.button.interactable = true
        end
    end

    local parent = item.transform.parent
    if parent then
        local rectTrans = parent:GetComponent(Enum.TypeInfo.RectTransform)
        local width = rectTrans.rect.size.x
        item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Horizontal, width);
        item.text.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Horizontal, width - 40);
    end

    item.text.contentSizeFitter:SetLayoutVertical()
    local size = item.text.rectTransform.sizeDelta
    item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, 100);
    if size.y > 38 then
        local newY = item.rectTransform.sizeDelta.y + (size.y - 38)
        item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, newY);
    end
end

return ChatTextItemCtr