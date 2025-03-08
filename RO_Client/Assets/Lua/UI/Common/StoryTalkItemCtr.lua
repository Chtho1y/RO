local StoryTalkItemCtr = {}

function StoryTalkItemCtr:SetData(wnd, item, logicData)
    local curCfgData = logicData[1]
    local curTalk = logicData[2]
    local bgSprite = logicData[3]
    local isCur = logicData[4]
    local listItem = logicData[5]
    --local roleImage = logicData[5]

    item.talkLft:SetActive(curTalk.SpeakSite == 1)
    item.talkRgt:SetActive(curTalk.SpeakSite == 2)

    local talkItem = curTalk.SpeakSite == 1 and item.talkLft or item.talkRgt
    talkItem.next:SetActive(isCur)

    local roleName = curTalk.SpeakSite == 1 and curTalk.LeftName or curTalk.RightName
    if roleName == "player" then
        talkItem.text.text.text = ManagerContainer.DataMgr.UserData:GetUserNickname()
    else
        talkItem.text.text.text = I18N.T(roleName)
    end

    talkItem.bg.image.sprite = bgSprite

    local content = I18N.T(curTalk.SpeakId)
    local speed = 0.05
    if curTalk.WordTime > 0 then
        speed = curTalk.WordTime*0.001
    end

    talkItem.dsc.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, 39);
    talkItem.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, 185);
    item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, 185);
    --item.layoutElement.preferredHeight = 185

    local length = StringUtil.GetTextLeng(talkItem.dsc.text, content)
    local idx = math.floor(length / 728)
    if idx > 0 then
        local increase = idx * 47
        if increase > talkItem.dsc.rectTransform.sizeDelta.y - 39 then
            local size = talkItem.dsc.rectTransform.sizeDelta.y + increase
            if size > talkItem.dsc.rectTransform.sizeDelta.y then
                talkItem.dsc.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, size);
            end

            size = talkItem.rectTransform.sizeDelta.y + increase
            if size > talkItem.rectTransform.sizeDelta.y then
                talkItem.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, size);
            end

            size = item.rectTransform.sizeDelta.y + increase
            --item.layoutElement.preferredHeight = size
            item.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, size);

            wnd.scrollView.loopListView:OnItemSizeChanged(listItem.ItemIndex)
        end
    end

    if not isCur then
        talkItem.dsc.text.text = content
        item.canvasGroup.alpha = 0.5
        talkItem.transform.localPosition = Vector3.zero
    else
        local pos = item.transform.localPosition
        pos.y = -30
        item.transform.localPosition = pos

        pos = talkItem.transform.localPosition
        pos.x = curTalk.SpeakSite == 1 and -300 or 300
        talkItem.transform.localPosition = pos
        talkItem.dsc.text.text = ""
        item.canvasGroup.alpha = 1
        talkItem.transform:DOLocalMoveX(0, 0.3):SetAutoKill()

        wnd.lastNext = talkItem.next
        wnd.curTalkContent = content
        wnd.curTalkDsc = talkItem.dsc.text
        --wnd.curTalkDscContent = talkItem.dsc.contentSizeFitter
        local duration = #content * speed
        --DG.Tweening.DOTween.Kill(curTalkDsc)
        wnd.curTalkDsc.text = ""
        --LogError("Add next4444")
        wnd.curTalkTweener = wnd.curTalkDsc:DOText(content, duration):OnComplete(function()
            wnd.curTalkOverStatus = true
        end):SetAutoKill()
        wnd.curTalkDsc.transform:DOScaleZ(1, curCfgData.PlayInterval):OnComplete(function()
            --LogError("next4444")
            wnd:PlayStoryPerform()
        end):SetAutoKill()
    end
end

return StoryTalkItemCtr