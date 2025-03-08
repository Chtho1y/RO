local ExchangegItemCtr = {}
local ExchangegItemCtr = require("Common/IconItemCtr")

function PetRelationItemCtr:SetData(wnd, item, logicData, enterType, onClickOwner, onClickCB)
    -- local cfgData = logicData

    -- item.textName.text.text = I18N.T(cfgData.Name)

    -- local relationData = ManagerContainer.DataMgr.PetDataMgr:GetPetRelationDataByCfgId(cfgData.Id)

    -- local cfgIds = {}
    -- for j = 3, 1, -1 do
    --     local condition = cfgData['Condition'..j]
    --     local state
    --     if condition then
    --         local advance = 0
    --         for k,v in pairs(condition) do
    --             cfgIds[#cfgIds + 1] = v[1]
    --             advance = v[2]
    --         end

    --         local curCount = 0
    --         if relationData and relationData.relationPets then
    --             for k,v1 in pairs(relationData.relationPets) do
    --                 local cfgId = condition[k][1]
    --                 local num = condition[k][2]
    --                 if v1.cfgId == cfgId and v1.advanceLevel >= num and v1.petId > 0 then
    --                     curCount = curCount + 1
    --                 end
    --             end
    --         end

    --         if item.grid.activeSelf and relationData and relationData.newActived == j then
    --             if item['relationAttr'..j].uIEffectCfg and not item['relationAttr'..j].uIEffectCfg.Ready then
    --                 item['relationAttr'..j].uIEffectCfg:LoadEffect()
    --             end

    --             if item['relationAttr'..j].uIEffectCfg then
    --                 item['relationAttr'..j].uIEffectCfg:ShowEffect("FX_UI_TuPo_New",item['relationAttr'..j].fx.transform)
    --             end
    --         end

    --         item['relationAttr'..j].count.text.text = curCount .."/3"

    --         state = curCount >= 3
    --         item['relationAttr'..j].activedState:SetActive(state)
    --         item['relationAttr'..j].unactivatedState:SetActive(not state)
    --         local color = Constant.GrayColor
    --         if j == 1 then
    --             color = state and Constant.BlueColor or color
    --         elseif j == 2 then
    --             color = state and Constant.PurpleColor or color
    --         elseif j == 3 then
    --             color = state and Constant.GoldColor or color
    --         end
    --         item['relationAttr'..j].bgActivedState.image.color = Color(color[1], color[2], color[3], color[4])

    --         item['relationAttr'..j].attrDsc.text.text = I18N.SetLanguageValue("Petadfetter_001", advance)
    --     end
    --     local attribute = cfgData['attribute'..j]
    --     for i = 1, 3 do
    --         item['relationAttr'..j]["attr"..i]:SetActive(false)
    --     end
    --     if attribute then
    --         for i = 1,#attribute do
    --             if item['relationAttr'..j]["attr"..i] then
    --                 item['relationAttr'..j]["attr"..i]:SetActive(attribute[i] ~= nil)
    --                 if attribute[i] then
    --                     local key = attribute[i][1]
    --                     local val = key > 21 and CommonUtil.GetPreciseDecimal(attribute[i][2]*0.0001, 3) or math.floor(attribute[i][2])
    --                     item['relationAttr'..j]["attr"..i].text.text = I18N.T("Attr_"..attribute[i][1]).." "..CommonUtil.HeroAttrFormatValue(key, val, true)

    --                     local color = state and Constant.GreenColor or Constant.GrayColor
    --                     item['relationAttr'..j]["attr"..i].text.color = Color(color[1], color[2], color[3], color[4])
    --                     item['relationAttr'..j]["attr"..i]:SetActive(true)
    --                 end
    --             end
    --         end
    --     end
    -- end

    -- if relationData then
    --     for k,v in pairs(relationData.relationPets) do
    --         local cfgId = cfgIds[k]
    --         local advanceLv = v.advanceLevel
    --         if v.petId == 0 then
    --             advanceLv = 0
    --         end
    --         local data = {cfgId = cfgId, advanceLevel = advanceLv}
    --         IconPetItemCtr:SetData(wnd,item['item'..k].iconPetItem, data, Enum.ItemIEnterType.PetRelation, onClickOwner, onClickCB, {cfgData.Id, k})

    --         CommonUtil.SetTotalChildrenGray(item['item'..k].iconPetItem.gameObject, v.petId == 0)
    --         item['item'..k].iconPetItem.nameBg:SetActive(v.petId > 0)
    --         item['item'..k].iconPetItem.qualityFX:SetActive(v.petId > 0)
    --         if v.petId > 0 then
    --             local uid = v.uid
    --             local nickname = uid == 0 and ManagerContainer.DataMgr.UserData:GetUserNickname() or ManagerContainer.DataMgr.PetDataMgr:GetRelationPlayerNameByUid(uid)
    --             item['item'..k].iconPetItem.petName.text.text = CommonUtil.GetShortVaildNickName(nickname)
    --         end
    --     end
    -- else
    --     for i = 1, 3 do
    --         local cfgId = cfgIds[i]
    --         local data = {cfgId = cfgId, advanceLevel = 0}
    --         IconPetItemCtr:SetData(wnd,item['item'..i].iconPetItem, data, Enum.ItemIEnterType.PetRelation, onClickOwner, onClickCB, {cfgData.Id, i})

    --         CommonUtil.SetTotalChildrenGray(item['item'..i].iconPetItem.gameObject, true)
    --         item['item'..i].iconPetItem.nameBg:SetActive(false)
    --         item['item'..i].iconPetItem.qualityFX:SetActive(false)
    --     end
    -- end

    -- local rpIdxList = ManagerContainer.RedPointMgr.PetRPCtr:RefresgPetRelationState(cfgData.Id)
    -- for i = 1, 3 do
    --     local parent = item['item'..i].transform
    --     local redPoint = parent:Find("redPoint")
    --     local isIn = CommonUtil.EleInTable(i, rpIdxList)
    --     if redPoint then
    --         redPoint.gameObject:SetActive(isIn)
    --     else
    --         if isIn and rpIdxList and next(rpIdxList) then
    --             local go = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIPath, "Common/UIRedPointRP")
    --             if go then
    --                 redPoint = go.transform
    --                 redPoint:SetParent(parent)
    --                 redPoint.localRotation = Quaternion.identity
    --                 redPoint.localScale = Vector3.one
    --                 local rectTransform = redPoint:GetComponent(Enum.TypeInfo.RectTransform)
    --                 rectTransform.anchoredPosition3D = Vector3(60, 60, 0)

    --                 go.name = "redPoint"
    --             end
    --         end
    --     end
    -- end

    --item.grid:SetActive(false)
    --item.down:SetActive(true)
    --item.up:SetActive(false)
end

return ExchangegItemCtr