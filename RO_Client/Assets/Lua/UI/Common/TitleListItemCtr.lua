local TitleListItemCtr = {}

function TitleListItemCtr:SetData(wnd, item, logicData)
    local titleId = logicData.titleId
    local state = logicData.state
    local titleCfgData = ManagerContainer.CfgMgr:GetDesignationCfgById(titleId)
    if not titleCfgData then
        LogError("titleCfgData is not exist by TitleListItemCtr")
       return
    end
    item.taskDsc.text.text = titleCfgData.TaskConditionDesc
    item.target:SetActive(state == 1 and titleCfgData.IfShowTaskNum == 1)
    item.target.text.text = logicData.currCount.."/"..logicData.totalCount
    if state > 2 and titleCfgData.Time > 0 then --称号卸下状态（即已激活）并为时限称号  则显示剩余时间
    local servertime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
        local time = (logicData.endTime - (servertime/1000))/60/60
        time = type(time) == "number" and time or #time
        if time <= 0 then
            item.timeLimit.text.text = I18N.SetLanguageValue("LessOneHour")
        else
            local h = math.floor(time % 24)
            local d = math.floor(time / 24)
            item.timeLimit.text.text = I18N.SetLanguageValue("DesignationTime",d,h)
        end
    else
        item.timeLimit.text.text = titleCfgData.TimeDesc
    end
    item.btnEquip:SetActive(state == 4)
    item.btnActive:SetActive(state == 2)
    local parent = item.btnActive.transform
    local redPoint = parent:Find("redPoint")
    if redPoint then
        redPoint.gameObject:SetActive(state == 2)
    else
        if state == 2 then
            self:CreateRP(parent, redPoint, "redPoint", "Common/UIRedPointRP")
        end
    end
    item.btnRemove:SetActive(state == 3)
    item.equipLight:SetActive(state == 3)
    item.mask:SetActive(state == 1)

    CommonUtil.LoadIcon(wnd, titleCfgData.ChatSource, function (sprite)
        item.titleImg.image.sprite = sprite
    end)
    item.property1:SetActive(false)
    item.property2:SetActive(false)
    local attrs = titleCfgData.Attribute
    if attrs and #attrs > 0 then
        for i = 1, #attrs do
            if item["property"..i] and item["PropertyText"..i] then
                item["property"..i]:SetActive(true)
                item["property"..i].text.text = I18N.SetLanguageValue("Attr_"..attrs[i][1])
                item["PropertyText"..i].text.text = CommonUtil.HeroAttrFormatValue(attrs[i][1], attrs[i][2])
            end
        end
    end
    
    wnd.uiBase:AddButtonUniqueEventListener(item.btnEquip.button, wnd, wnd.OnBtnEquipClick, logicData)
    wnd.uiBase:AddButtonUniqueEventListener(item.btnActive.button, wnd, wnd.OnBtnActiveClick, logicData)
    wnd.uiBase:AddButtonUniqueEventListener(item.btnRemove.button, wnd, wnd.OnBtnRemoveClick, logicData)
end

function TitleListItemCtr:CreateRP(parent, redPoint, name, path)
	local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, path)
    if go then
        redPoint = go.transform
        redPoint:SetParent(parent)
        redPoint.localRotation = Quaternion.identity
        redPoint.localScale = Vector3.one
        local rectTransform = redPoint:GetComponent(Enum.TypeInfo.RectTransform)
        rectTransform.anchoredPosition3D = Vector3(90, 35, 0)
        go.name = name
    end
end

return TitleListItemCtr