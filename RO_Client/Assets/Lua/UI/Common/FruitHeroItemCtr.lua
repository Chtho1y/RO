local FruitHeroItemCtr = {}

function FruitHeroItemCtr:SetData(fruitView,item,herodata,configData,ItemCfgData,userName,IconPath)
    for i = 1, #configData do
        if herodata.qualityList and herodata.qualityList[configData[i][1]] ~= nil then
            item["fruit"..i.."Num"].text.text = herodata.qualityList[configData[i][1]].."/"..configData[i][3]
            item["fruit"..i.."Slider"].image.fillAmount = herodata.qualityList[configData[i][1]]/configData[i][3]
            if herodata.qualityList[configData[i][1]] == configData[i][3] then
                item["fruit"..i.."BtnUse"]:SetActive(false)
            end
        else
            item["fruit"..i.."Num"].text.text = "0/"..configData[i][3]
            item["fruit"..i.."Slider"].image.fillAmount = 0/configData[i][3]
        end
        if ItemCfgData then
            item["fruit"..i.."Name"].text.text = ItemCfgData[i]['Name']
        end
    end
    local isshow = herodata.owned == nil or  herodata.owned == true
    item.uncured:SetActive(not isshow)
    CommonUtil.SetTotalChildrenGray(item.heroHalf,not isshow)
    CommonUtil.SetTotalChildrenGray(item.fruit1BtnUse,not isshow)
    CommonUtil.SetTotalChildrenGray(item.fruit2BtnUse,not isshow)
    item.fruit1BtnUse.button.interactable = isshow
    item.fruit2BtnUse.button.interactable = isshow
    
    if IconPath then
        CommonUtil.LoadIcon(fruitView, IconPath, function (sprite)
            item.heroHalf.image.sprite = sprite
        end)
    end

    if userName then
        item.nameText.text.text = userName
    end
    CommonUtil.LoadIcon(fruitView, ItemCfgData[1]['Icon'], function (sprite)
        item.fruit1Icon.image.sprite = sprite
    end)
    CommonUtil.LoadIcon(fruitView, ItemCfgData[2]['Icon'], function (sprite)
        item.fruit2Icon.image.sprite = sprite
    end)
end
function FruitHeroItemCtr:SetBtnGray(item,flag)
    CommonUtil.SetTotalChildrenGray(item,flag)
end

return FruitHeroItemCtr