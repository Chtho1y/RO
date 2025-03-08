local EquipSlotItemNewCtr = {}
local ConditionJudge = require("Common/ConditionJudge")
local IconItemCtr = require("Common/IconItemCtr")

function EquipSlotItemNewCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB, needPar)
    local isLeader = logicData[1]
    local logicData1 = logicData[2]
    local jobData = logicData[3]
    local slots = logicData[4]
    local slotIndex = logicData[5]
    local idx = logicData[6]
    local refreshEquipTips = logicData[7]
    local _cardIdList = logicData[8]        --查看别的玩家的时候这个是直接传进来的

    item.mask:SetActive(logicData1 ~= nil and not isLeader and not logicData1.owned)
    item.iconItem.bg.button.image.raycastTarget = false;
    if slots == nil then
        item.blank:SetActive(true)
        item.cardPlus:SetActive(false)
        item.iconItem:SetActive(false);

        if logicData1 then
            local slotDressRPStatus = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatusByIdx(idx)
                    or ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusByIdAndIdx(logicData1.id, idx)

            item.redPointItem.bg:SetActive(true)
            item.redPointItem:SetActive((isLeader or logicData1.owned) and slotDressRPStatus ~= Enum.RedPointEnum.None)
            item.redPointItem.equipment:SetActive(slotDressRPStatus == Enum.RedPointEnum.EquipDressRP)

            local data = { cfgId = 0, num = 0, slotIndex = slotIndex, slotType = idx, cbOwner = wnd, cb = wnd.ChangeCurEquip, jobType = jobData.JobType }
            wnd.uiBase:AddButtonUniqueEventListener(item.button, onClickOwner, onClickCB, data)
        end
        --[[
        if _isTipBc then
            wnd.uiBase:AddButtonUniqueEventListener(item.button, onClickOwner, onClickCB)
        end]]--
    else
        item.blank:SetActive(idx > #slots or slots[idx].equip_id == 0)
        item.iconItem:SetActive(idx <= #slots and slots[idx].equip_id > 0 );
        --[[
        item.iconItem.icon:SetActive(idx <= #slots and slots[idx].equip_id > 0)
        item.iconItem.frame:SetActive(idx <= #slots and slots[idx].equip_id > 0)
        item.iconItem.level:SetActive(idx <= #slots and slots[idx].equip_id > 0)]]--
        local slotRefineRPStatus = false
        if logicData1 then
            local cardSlotRPStatus = ManagerContainer.RedPointMgr.HeroRPCtr:GetRoleCardSlotRP(slotIndex, idx)
            local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(20)
            if not unlockState then
                cardSlotRPStatus = Enum.RedPointEnum.None
            end
            item.redPointItem.bg:SetActive(cardSlotRPStatus ~= Enum.RedPointEnum.CardSlotRP)
            item.redPointItem.cardOpen:SetActive(cardSlotRPStatus == Enum.RedPointEnum.CardSlotRP)
            if cardSlotRPStatus ~= Enum.RedPointEnum.CardSlotRP then
                local slotDressRPStatus = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipDressRPStatusByIdx(idx)
                        or ManagerContainer.RedPointMgr.HeroRPCtr:GetPartnerEquipDressRPStatusByIdAndIdx(logicData1.id, idx)
                slotRefineRPStatus = isLeader and ManagerContainer.RedPointMgr.HeroRPCtr:GetHeroEquipRefineRPStatusByIdx(idx)
                        or ManagerContainer.RedPointMgr.HeroRPCtr:GetpartnerEquipRefineRPStatusByIdAndIdx(logicData1.id, idx)
                item.redPointItem.equipment:SetActive(slotDressRPStatus == Enum.RedPointEnum.EquipDressRP)

                local unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(17)
                item.redPointItem.refine:SetActive(slotDressRPStatus == Enum.RedPointEnum.None and slotRefineRPStatus == Enum.RedPointEnum.EquipRefineRP and unlockState)
            end

            item.redPointItem:SetActive((isLeader or logicData1.owned) and (item.redPointItem.cardOpen.activeSelf or item.redPointItem.equipment.activeSelf or item.redPointItem.refine.activeSelf))
        end

        if needPar then
            --item.par:SetActive(true)
            item.equipFx.uIParticle:PlayCachedParticalSystem(true)
        end

        item.iconItem.num:SetActive(idx <= #slots and slots[idx].level > 0)
        for j = 1, Constant.CARD_SLOT_LIMIT do
            item["slot" .. j]:SetActive(false)
            item["card" .. j]:SetActive(false)
        end

        local _setCard = function(result, id, j)
            item["slot" .. j]:SetActive(result)
            item["card" .. j]:SetActive(result and id > 0)
            if result then
                if id > 0 then
                    local cardData = ManagerContainer.CfgMgr:GetCardDataById(id)
                    CommonUtil.LoadIcon(wnd, Constant.Card_Quality_Icons[cardData.CardType], function(sprite)
                        item["card" .. j].image.sprite = sprite
                    end)
                end
            end
        end

        local isOpened = false
        local _hasCardIdList = _cardIdList ~= nil;
        if idx <= #slots then
            for j = 1, Constant.CARD_SLOT_LIMIT do
                if _hasCardIdList then  --TODO:目前查看他人的时候没有关卡信息，所以暂时只考虑插了卡的卡片槽位，后续如果策划有管卡信息的需求要求服务器一定要传过来，再改这里
                    local id = slots[idx].card_id_list[j] or 0;
                    if id > 0 then
                        isOpened = true;
                        _setCard(true, id, j);
                    end
                else
                    local id = slots[idx].card_id_list[j] or 0
                    local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(idx * 100 + j)
                    if condition ~= nil then
                        local result = ConditionJudge:ConditionPassResult1(condition.UnlockingCondition[1])
                        if result then isOpened = true; end
                        _setCard(result, id, j);
                    end
                end
            end
        end
        item.cardPlus:SetActive(isOpened)
        if idx <= #slots and slots[idx].equip_id > 0 then
            local _iconItemLogic = {
                cfgId = slots[idx].equip_id;
                num = slots[idx].level;
            }
            --local _iconItemLua = CommonUtil.BindGridViewItem2LuaStatic("IconItem", item.iconItem.gameObject)
            IconItemCtr:SetData(wnd, item.iconItem, _iconItemLogic, Enum.ItemIEnterType.EquipTips, nil, nil)
            if jobData then
                local data = { id = logicData1 and logicData1.id or 0, heroConfigId = logicData1.configId, cfgId = slots[idx].equip_id, num = 0, slotIndex = slotIndex, slotType = idx, cbOwner = wnd, cb = wnd.ChangeCurEquip, cb1 = wnd.PutOffCurEquip, jobType = jobData.JobType, canRefine = slotRefineRPStatus == Enum.RedPointEnum.EquipRefineRP }
                wnd.uiBase:AddButtonUniqueEventListener(item.button, wnd, refreshEquipTips, data)
            end

            local equipData = ManagerContainer.CfgMgr:GetEquipById(slots[idx].equip_id)
            if equipData == nil then
                LogError(slots[idx].equip_id.. " isnt exist in EquipCfg")
                return
            end
            local divide = Constant.Quality_Equip_Divide[equipData.EquipLevel]
            local quality = divide[1]
            CommonUtil.LoadIcon(wnd, Constant.Quality_EquipPlus_Icons[quality], function (sprite)
                item.bgPlus.image.sprite = sprite
            end)
        else
            if jobData then
                local data = { cfgId = 0, num = 0, slotIndex = slotIndex, slotType = idx, cbOwner = wnd, cb = wnd.ChangeCurEquip, jobType = jobData.JobType }
                wnd.uiBase:AddButtonUniqueEventListener(item.button, onClickOwner, onClickCB, data)
            end

            CommonUtil.LoadIcon(wnd, Constant.Quality_CardBg_Default_Icon, function(sprite)
                item.bgPlus.image.sprite = sprite
            end)
        end
    end
end

return EquipSlotItemNewCtr