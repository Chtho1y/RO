local RedPointItemCtr = {}

function RedPointItemCtr:SetData(wnd, item, logicData, source, id)
    if source == Enum.HeroRPSource.HeadIcon then
        item.equipment:SetActive(logicData == Enum.RedPointEnum.EquipDressRP)

        item.lvUp:SetActive(logicData == Enum.RedPointEnum.EquipForgeRP)

        if not item.lvUp.activeSelf then
            item.lvUp:SetActive(logicData == Enum.RedPointEnum.CardLvUpRP)
        end

        item.refine:SetActive(logicData == Enum.RedPointEnum.EquipRefineRP)
        -- item.skillTree:SetActive(logicData == Enum.RedPointEnum.SkillUnlockRP)

        item.new:SetActive(logicData == Enum.RedPointEnum.FashionNewRP)
        if not item.new.activeSelf then
            item.new:SetActive(logicData == Enum.RedPointEnum.SkillUnlockRP)
        end

        item.redPoint:SetActive(logicData == Enum.RedPointEnum.SkillEquip)

        item.cardOpen:SetActive(logicData == Enum.RedPointEnum.CardSlotRP)

        item.card:SetActive(logicData == Enum.RedPointEnum.CardEmptyRP)

        item.hart:SetActive(logicData == Enum.RedPointEnum.RecruitRP)
        item.recommend:SetActive(logicData == Enum.RedPointEnum.RecommendRP)

        item.bg:SetActive(logicData ~= Enum.RedPointEnum.CardSlotRP and logicData ~= Enum.RedPointEnum.SkillEquip)
        item:SetActive(item.equipment.activeSelf or item.lvUp.activeSelf or item.refine.activeSelf
                or item.new.activeSelf or item.hart.activeSelf or item.recommend.activeSelf
                or item.card.activeSelf or item.redPoint.activeSelf or item.cardOpen.activeSelf
        )
    elseif source == Enum.HeroRPSource.EquipDress then
        item.equipment:SetActive(logicData == Enum.RedPointEnum.EquipDressRP)
        item:SetActive(item.equipment.activeSelf)
    elseif source == Enum.HeroRPSource.EquipForge then
        item:SetActive(logicData == Enum.RedPointEnum.EquipForgeRP)
        item.lvUp:SetActive(logicData == Enum.RedPointEnum.EquipForgeRP)
    else
        item.equipment:SetActive(logicData == Enum.RedPointEnum.EquipDressRP)

        item.lvUp:SetActive(logicData == Enum.RedPointEnum.EquipForgeRP)

        item.refine:SetActive(logicData == Enum.RedPointEnum.EquipRefineRP)

        item.new:SetActive(logicData == Enum.RedPointEnum.SkillUnlockRP)

        if not item.new.activeSelf then
            item.new:SetActive(logicData == Enum.RedPointEnum.FashionNewRP)
        end
        
        item.redPoint:SetActive(logicData == Enum.RedPointEnum.SkillEquip)

        item.cardOpen:SetActive(logicData == Enum.RedPointEnum.CardSlotRP)
        item.hart:SetActive(logicData == Enum.RedPointEnum.RecruitRP)
        item.recommend:SetActive(logicData == Enum.RedPointEnum.RecommendRP)

        item.bg:SetActive(logicData ~= Enum.RedPointEnum.CardSlotRP and logicData ~= Enum.RedPointEnum.SkillEquip)

        item:SetActive(item.equipment.activeSelf or item.lvUp.activeSelf or item.refine.activeSelf
                or item.new.activeSelf or item.hart.activeSelf or item.recommend.activeSelf
                or item.card.activeSelf or item.redPoint.activeSelf  or item.cardOpen.activeSelf
        )
    end
end

return RedPointItemCtr