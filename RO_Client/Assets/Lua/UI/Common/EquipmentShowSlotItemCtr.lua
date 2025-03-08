--这个脚本是UIRoleMessage界面中用来显示角色装备的装备槽位控制脚本
local EquipmentShowSlotItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function EquipmentShowSlotItemCtr:SetData(_wnd, _item, _data, _index, _slotsData, _slotIndex, _id, _jobConfigId,_name)
    _item.tipButton.button.onClick:RemoveAllListeners();
    --[[
    --只要招募了就能开启装备槽位，所以显示的时候只有
    if not _data then
        _item.mask.gameObject:SetActive(true);
        _item.equipState.gameObject:SetActive(false);
        _item.cardPlus.gameObject:SetActive(false);
        _item.equipItem.gameObject:SetActive(false);
        _item.lv.gameObject:SetActive(false);
    else]]--
        --_item.mask.gameObject:SetActive(false);
    if _data and _data.equip_id and _data.equip_id > 0 then	--装备了武器
        _item.cardPlus.gameObject:SetActive(true);
        _item.iconItem.gameObject:SetActive(true);
        --_item.position.gameObject:SetActive(false);
        --设置装备的插卡信息start
        for i = 1, Constant.CARD_SLOT_LIMIT do
            _item["slot" .. i]:SetActive(false)
            _item["card" .. i]:SetActive(false)
        end
        local _showCardBg = false;
        for i = 1, Constant.CARD_SLOT_LIMIT do
            local id = _data.card_id_list[i] or 0
            local condition = ManagerContainer.CfgMgr:GetCardUnlockConditionById(_index * 100 + i)
            if condition ~= nil then
                local result =  id > 0--ConditionJudge:ConditionPassResult1(condition.UnlockingCondition[1])
                _item["slot" .. i]:SetActive(result)
                _item["card" .. i]:SetActive(result and id > 0)
                if result then
                    _showCardBg = true;
                    if id > 0 then
                        local cardData = ManagerContainer.CfgMgr:GetCardDataById(id)
                        CommonUtil.LoadIcon(_wnd, Constant.Card_Quality_Icons[cardData.CardType], function (sprite)
                            _item["card" .. i].image.sprite = sprite
                        end)
                    end
                end
            end
        end
        _item.cardPlus:SetActive(_showCardBg);
        if _showCardBg then
            local equipData = ManagerContainer.CfgMgr:GetEquipById(_data.equip_id)
            if equipData == nil then
                LogError(slots[idx].equip_id.. " isnt exist in EquipCfg")
                return
            end
            local divide = Constant.Quality_Equip_Divide[equipData.EquipLevel]
            local quality = divide[1]
            CommonUtil.LoadIcon(_wnd, Constant.Quality_EquipPlus_Icons[quality], function (sprite)
                _item.bgPlus.image.sprite = sprite
            end)
        end
        --设置装备的插卡信息end
        local itemCfgData = ManagerContainer.CfgMgr:GetItemById(_data.equip_id)
        local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(_data.equip_id)

        if not itemCfgData then
            LogError("在道具表中找不到该装备" .. _data.equip_id)
        end

        if not equipCfgData then
            LogError("在装备表中找不到该装备" .. _data.equip_id)
        end
        _item.iconItem.num:SetActive(_index <= #_slotsData and _slotsData[_index].level > 0)
        local _iconItemLogic = {
            cfgId = _data.equip_id;
            num = _data.level;
        }
        IconItemCtr:SetData(_wnd, _item.iconItem, _iconItemLogic, Enum.ItemIEnterType.EquipTips)
        if _data._jobData then
            --设置tip
            local _tipData = {
                cfgId = _data.equip_id,
                num = 0,
                slotIndex = _slotIndex,
                id = _id,
                slotType = _index,
                cbOwner = _wnd,
                cb = nil,
                cb1 = nil,
                jobType = _data._jobData.JobType,
                canRefine = false,
                _isView = true; --仅仅是为了查看
                _slots = _slotsData,  --这个要是传过去，就不去找自己的slots了，而是要用这个参数
                _cardIdList = _data.card_id_list,
                heroConfigId = _jobConfigId,
                nickName = _name;
            }
            local _openTips = function()
                local _data = {_tipData, Enum.ItemIEnterType.HeroEquip, true}
                ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIEquipTips, _data)
            end
            _wnd.uiBase:AddButtonEventListener(_item.tipButton.button, _openTips);
        end
    else	--槽位是开启了，但是没装备上武器
        _item.cardPlus.gameObject:SetActive(false);
        _item.iconItem.gameObject:SetActive(false);
        --_item.position.gameObject:SetActive(true);
        --_item.lv.gameObject:SetActive(false);

        _wnd.uiBase:AddButtonEventListener(_item.tipButton.button, function()
            ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("该槽位还未装备！");
        end);
    end
    --end
end

return EquipmentShowSlotItemCtr