local ActivityShopItem = class("ActivityShopItem",require("Activities/ActivityTypeItem"))

function ActivityShopItem:Init(cfg)
    ActivityShopItem.super.Init(self, cfg)
    self.actShopIds = cfg.ActShopID
end

function ActivityShopItem:GetActShopIds()
    return self.actShopIds
end



return ActivityShopItem