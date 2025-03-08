local EquipRefineAttrItemCtr = {}
local EquipBaseAttrItemCtr = require("Common/EquipBaseAttrItemCtr")
local RefinePercentItemCtr = require("Common/RefinePercentItemCtr")

function EquipRefineAttrItemCtr:SetData(wnd, item, logicData)
    local baseAttrLua = item.equipBaseAttrItem
    EquipBaseAttrItemCtr:SetData(wnd, baseAttrLua, logicData)

    local nextRefineLv = logicData[3] + 1
    local nextRefineData = ManagerContainer.CfgMgr:GetEquipRefineDataByLv(nextRefineLv)
    item.refinePercentItem:SetActive(nextRefineData ~= nil)
    item.image:SetActive(nextRefineData ~= nil)
    if nextRefineData ~= nil then
        local delta = math.floor(logicData[2]*nextRefineData.Result * 0.01)

        local refineAttrLua = item.refinePercentItem
        RefinePercentItemCtr:SetData(wnd, refineAttrLua, delta)
    end
end

return EquipRefineAttrItemCtr