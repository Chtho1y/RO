local RankShopRewardIconItemCtr = {}
local IconItemCtr = require("Common/IconItemCtr")

function RankShopRewardIconItemCtr:SetData(wnd, itemLua, logicData, enterType, onClickOwner, onClickCB)
    IconItemCtr:SetData(wnd, itemLua.iconSmallItem, logicData, enterType, onClickOwner, onClickCB)
end

return RankShopRewardIconItemCtr