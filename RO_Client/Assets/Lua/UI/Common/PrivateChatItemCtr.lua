local PrivateChatItem = {}

local regexPattern = "%[e%d+%]"
local function GetEmojiCfg(num)
    local s = tostring(num + 1)
    local emojis = ManagerContainer.CfgMgr:GetEmojiCfg()
    local result
    for k,v in pairs(emojis) do
        local find = string.find(s, tostring(k))
        if find == 1 then
            result = v
        end
    end
    return result
end

function PrivateChatItem:SetData(wnd, item, logicData)
    local chat = logicData[2]
    local lastChat = logicData[1]
    local fromData = chat.fromData

    local userUid = ManagerContainer.DataMgr.UserData:GetUserId()
    local isLeft = fromData.uid ~= tostring(userUid)

    item.chatBubbleLftItem:SetActive(isLeft)
    item.chatBubbleRgtItem:SetActive(not isLeft)

    if isLeft then
        item.chatBubbleLftItem.bg:SetActive(chat.message.subType == Enum.ChatSubType.None)
        item.chatBubbleLftItem.helpBg:SetActive(chat.message.subType == Enum.ChatSubType.Expedition)
    else
        item.chatBubbleRgtItem.bg:SetActive(chat.message.subType == Enum.ChatSubType.None)
        item.chatBubbleRgtItem.helpBg:SetActive(chat.message.subType == Enum.ChatSubType.Expedition)
    end

    local chatItem = isLeft and item.chatBubbleLftItem or item.chatBubbleRgtItem

    local height = 0
    local timeOut = false
    if lastChat ~= nil then
        local lastTime = lastChat.message.sendTime
        local nowTime = chat.message.sendTime
        local seconds = nowTime - lastTime
        local mtTenM = seconds/ManagerContainer.LuaTimerMgr.OneMinuteSeconds >= 10
        if mtTenM then
            seconds = ManagerContainer.LuaTimerMgr:GetTimeSecond() - nowTime
            local days = seconds/ManagerContainer.LuaTimerMgr.OneDaySeconds
            if days < 1 then
                local str = ManagerContainer.LuaTimerMgr:ParseTimeStamp2Format(nowTime, "%H:%M")
                item.chatTimeStampItem.text.text.text = str
            elseif days < 2 then
                item.chatTimeStampItem.text.text.text = I18N.T("PrivateChatDate1")
            elseif days < 3 then
                item.chatTimeStampItem.text.text.text = I18N.T("PrivateChatDate2")
            else
                item.chatTimeStampItem.text.text.text = I18N.T("PrivateChatDate3")
            end
        end

        item.chatTimeStampItem:SetActive(mtTenM)
        if mtTenM then
            height = item.chatTimeStampItem.rectTransform.sizeDelta.y
            timeOut = true
        end
    else
        item.chatTimeStampItem:SetActive(false)
    end

    --chatItem.text.rectTransform.sizeDelta = Vector2(0,10)
    if chat.message.subType == Enum.ChatSubType.None then
        local content = StringUtil.FilterEmoji(chat.message.message)
        chatItem.text.symbolText.text = content
        local length = StringUtil.GetTextLeng(chatItem.text.symbolText, content) + 10

        local emojis = ManagerContainer.CfgMgr:GetEmojiCfg()
        for k, v in string.gmatch(content, regexPattern) do
            local num = tonumber(string.match(k, '%d+'))
            if num < #emojis then
                length = length + 41
            end
        end
        length = math.min(length, 606)
        --local height = math.floor(length/606) + 1
        --textHeight = textHeight + height*39
        chatItem.text.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Horizontal, length);
        --chatItem.text.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, textHeight);
        chatItem.text.contentSizeFitter:SetLayoutVertical()

        local textHeight = chatItem.text.rectTransform.sizeDelta.y
        local bgWidth = length + 48
        local bgHeight = textHeight + 24 + 10

        chatItem.bg.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Horizontal, bgWidth);
        chatItem.bg.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, bgHeight);

        chatItem.rectTransform.anchoredPosition3D = Vector3.zero
        if timeOut then
            local rectPosition = chatItem.rectTransform.anchoredPosition3D
            chatItem.rectTransform.anchoredPosition3D = Vector3(rectPosition.x, -height, rectPosition.z)
        end
        height = height + bgHeight
        item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, height);
    elseif chat.message.subType == Enum.ChatSubType.Expedition then
        local color = chat.message.used and Constant.GrayColorSymbolText or Constant.DefaultColorSymbolText
        chatItem.helpText.symbolText.text = color..I18N.SetLanguageValue("ExpeditionHelp1", fromData.nickname)
        if chatItem.helpText1.symbolTextEvent then
            local content = Enum.ChatSubType.Expedition..";"..fromData.uid
            local color = chat.message.used and Constant.GrayColorSymbolText or Constant.RedColorSymbolText
            chatItem.helpText1.symbolText.text = color..I18N.SetLanguageValue("ExpeditionHelp2", "{"..content.."}")
            chatItem.helpText1.symbolText.raycastTarget = not chat.message.used
            if not chat.message.used then
                chatItem.helpText1.symbolTextEvent:RegisterClickEvent(nil, function (hyperParam)
                    local curTime = ManagerContainer.LuaTimerMgr:GetTimeSecond()
                    local isOneDay = ManagerContainer.LuaTimerMgr:TwoTimeSecondBetweenOneDay(chat.message.sendTime, curTime)
                    if not isOneDay then
                        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionBailout")
                        chat.message.used = true
                        return
                    end

                    local list = string.split(hyperParam, ";")
                    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
                    if tostring(uid) == list[2] then
                        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ExpeditionHelpLog2")
                        return
                    end
                    chat.message.used = true
                    local systemType = tonumber(list[1])
                    if systemType == Enum.ChatSubType.Expedition then
                        --远征求助
                        local uid = int64.new(list[2])
                        ManagerContainer.DataMgr.ExpeditionDataMgr:SendRescueFriendReq(uid, Enum.ExpeditionHelpSource.Private, chat.message.sendTime64)
                    end
                end)
            end
        end

        height = height + chatItem.helpBg.rectTransform.sizeDelta.y
        item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, height);
    end
end

return PrivateChatItem