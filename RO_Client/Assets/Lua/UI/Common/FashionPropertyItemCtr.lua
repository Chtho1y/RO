local FashionPropertyItemCtr = {}

local function GetJobTypeName(jobType)
    if not jobType then return "" end
    local colorStr = "<color=%s>%s</color>"
    local leaderColor = GlobalConfig.Instance:GetConfigStrValue(306)
    local name = string.format(colorStr, leaderColor, I18N.T("protagonist"))
    if jobType > 0 then
        --伙伴
        local name1, color = ManagerContainer.CfgMgr:GetPartnerCfgDataByJobType(jobType)
        name = string.format(colorStr, color, I18N.T(name1))
    end
    return name
end

function FashionPropertyItemCtr:SetData(wnd, itemlua, logicData)
    local attrId = logicData[1]
    local attrValue = logicData[2]
    local jobType = logicData[3]
    local name = GetJobTypeName(jobType)
    itemlua.name.text.text = name..I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))
    itemlua.number.text.text = jobType and "+"..attrValue or CommonUtil.HeroAttrFormatValue(attrId, attrValue)
end

return FashionPropertyItemCtr