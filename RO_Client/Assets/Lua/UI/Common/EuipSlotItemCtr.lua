local EuipSlotItem = {}
local ConditionJudge = require("Common/ConditionJudge")

function EuipSlotItem:SetData(wnd, item, logicData, onClickOwner, onClickCB, needPar)
    local isLeader = logicData[1]
    local logicData1 = logicData[2]
    local jobData = logicData[3]
    local slots = logicData[4]
    local slotIndex = logicData[5]
    local idx = logicData[6]

    item.mask:SetActive(logicData1 ~= nil and not isLeader and not logicData1.owned)
    --item:SetActive(logicData1.isBattle)
    --if logicData1.isBattle then
        if slots == nil then
            item.blank:SetActive(true)
            item.cardPlus:SetActive(false)

            item.textLv:SetActive(false)

            item.icon:SetActive(false)
            item.frame:SetActive(false)
            item.level:SetActive(false)

            --item.button.interactable = true
            item.cardPlus:SetActive(false)

            if logicData1 then
                local slotDressRPStatus =
                isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatusByIdx(idx)
                        or ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusByIdAndIdx(logicData1.id, idx)
                item.redPointItem:SetActive((isLeader or logicData1.owned) and slotDressRPStatus ~= Enum.RedPointEnum.None)
                item.redPointItem.equipment:SetActive(slotDressRPStatus == Enum.RedPointEnum.EquipDressRP)

                local data = {cfgId = 0, num = 0, slotIndex = slotIndex, slotType = idx, cbOwner = wnd, cb = wnd.ChangeCurEquip, jobType = jobData.JobType}
                wnd.uiBase:AddButtonUniqueEventListener(item.button, onClickOwner, onClickCB, data)
            end
        else
            item.blank:SetActive(idx > #slots or slots[idx].equip_id == 0)
            item.icon:SetActive(idx <= #slots and slots[idx].equip_id > 0)
            item.frame:SetActive(idx <= #slots and slots[idx].equip_id > 0)
            item.level:SetActive(idx <= #slots and slots[idx].equip_id > 0)

            --item.button.interactable = idx <= #slots and slots[idx].equip_id > 0

            if logicData1 then
                local slotDressRPStatus = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatusByIdx(idx)
                        or ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusByIdAndIdx(logicData1.id, idx)
                local slotRefineRPStatus = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipRefineRPStatusByIdx(idx)
                        or ManagerContainer.RedPointMgr.HeroRPCtr:GetpartnerEquipRefineRPStatusByIdAndIdx(logicData1.id, idx)
                item.redPointItem:SetActive((isLeader or logicData1.owned) and (slotDressRPStatus ~= Enum.RedPointEnum.None or slotRefineRPStatus ~= Enum.RedPointEnum.None))
                item.redPointItem.equipment:SetActive(slotDressRPStatus == Enum.RedPointEnum.EquipDressRP)
                item.redPointItem.refine:SetActive(slotDressRPStatus == Enum.RedPointEnum.None and slotRefineRPStatus == Enum.RedPointEnum.EquipRefineRP)
            end

            if needPar then
                item.par:SetActive(true)
                item.equipFx.uIParticle.cachedParticleSystem:Play(true)
            end

            item.textLv:SetActive(idx <= #slots and slots[idx].level > 0)
            for j = 1, Constant.CARD_SLOT_LIMIT do
                item["slot"..j]:SetActive(false)
                item["card"..j]:SetActive(false)
            end

            local isOpened = false
            if idx <= #slots then
                for j = 1, Constant.CARD_SLOT_LIMIT do
                    local id = slots[idx].card_id_list[j] or 0
                    local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(idx * 100 + j)
                    if condition ~= nil then
                        local result = ConditionJudge:ConditionPassResult1(condition.UnlockingCondition[1])
                        item["slot"..j]:SetActive(result)
                        item["card"..j]:SetActive(result and id > 0)
                        if result then
                            isOpened = true
                            if id > 0 then
                                local cardData = ManagerContainer.CfgMgr:GetCardDataById(id)
                                CommonUtil.LoadIcon(wnd, Constant.Card_Quality_Icons[cardData.CardType], function (sprite)
                                    item["card"..j].image.sprite = sprite
                                end)
                            end
                        end
                    end
                end
            end
            item.cardPlus:SetActive(isOpened)
            if idx <= #slots and slots[idx].equip_id > 0 then
                item.textLv.text.text = CommonUtil.StringConcat("+", slots[idx].level)

                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(slots[idx].equip_id)

                if itemCfgData == nil then
                    LogError(slots[idx].equip_id.. " isnt exist in ItemCfg")
                    return
                end
                local equipData = ManagerContainer.CfgMgr:GetEquipById(slots[idx].equip_id)
                if equipData == nil then
                    LogError(slots[idx].equip_id.. " isnt exist in EquipCfg")
                    return
                end

                CommonUtil.LoadIcon(wnd, itemCfgData.Icon, function (sprite)
                    item.icon.image.sprite = sprite
                end, item, 'IconIcon')

                CommonUtil.LoadIcon(wnd, Constant.Quality_CardBg_Icons[itemCfgData.Quality], function (sprite)
                    item.frame.image.sprite = sprite
                end, item, 'IconFrame')

                local divide = Constant.Quality_Equip_Divide[equipData.EquipLevel]
                CommonUtil.LoadIcon(wnd, Constant.Quality_Equip_LV_Icons[divide[2]], function (sprite)
                    item.level.image.sprite = sprite
                end, item, 'IconLevel')

                if jobData then
                    local data = {cfgId = slots[idx].equip_id, num = 0, slotIndex = slotIndex, slotType = idx, cbOwner = wnd, cb = wnd.ChangeCurEquip, cb1 = wnd.PutOffCurEquip, jobType = jobData.JobType, canRefine = slotRefineRPStatus == Enum.RedPointEnum.EquipRefineRP}
                    wnd.uiBase:AddButtonUniqueEventListener(item.button, wnd, wnd.RefreshEquipTips, data)
                end

                local divide = Constant.Quality_Equip_Divide[equipData.EquipLevel]
                local quality = divide[1]
                CommonUtil.LoadIcon(wnd, Constant.Quality_EquipPlus_Icons[quality], function (sprite)
                    item.bgPlus.image.sprite = sprite
                end)
            else
                if jobData then
                    local data = {cfgId = 0, num = 0, slotIndex = slotIndex, slotType = idx, cbOwner = wnd, cb = wnd.ChangeCurEquip, jobType = jobData.JobType}
                    wnd.uiBase:AddButtonUniqueEventListener(item.button, onClickOwner, onClickCB, data)
                end

                CommonUtil.LoadIcon(wnd, Constant.Quality_CardBg_Default_Icon, function (sprite)
                    item.bgPlus.image.sprite = sprite
                end)
            end
        end
    --end
end

return EuipSlotItem