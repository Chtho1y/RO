local CardAttrItemCtr = {}

function CardAttrItemCtr:SetData(wnd, item, logicData)
    local attrId = logicData[1]
    local val = logicData[2]
    local cfgData = logicData[3]
    local state = logicData[4]

    item.nameText.uILocalizeScript:SetContent("Attr_" .. attrId)
    item.numberText.text.text = CommonUtil.HeroAttrFormatValue(attrId, val)

    item.blessLv:SetActive(false)
    if state then
        for _,v in pairs(cfgData.Suit1) do
            local mapAttrData = ManagerContainer.CfgMgr:GetFightCfgByAttrId(v[1])
            if attrId == v[1] or mapAttrData.Mapping == attrId then
                item.blessLv:SetActive(true)
                item.numBless.text.text = "(+"..(v[2]*0.01).."%)"
            end
        end
    end
end

return CardAttrItemCtr