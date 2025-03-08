--[[
    道具变化协议 (包含道具增加)
    装备变化协议 (包含装备增加))
    由于是分两条协议下发，所以当功能会同时增加两种时，需要合并到一个数据中，给显示获得道具的界面
]] local PopGotMgr = class("PopGotMgr")

local ShowPopType = {
    EquipAndItem = 1,
    Fashion = 2,
    EquipAndItemList = 3,
    SkillEquipList = 4
}

local DeltaTime = 100

-- 获得道具的显示页面中 道具的排序规则
local EquipAndItemSortRule = function(a, b)
    local cfgIdA = a.cfgId
    local cfgIdB = b.cfgId
    local itemCfgA = ManagerContainer.CfgMgr:GetItemById(cfgIdA)
    local itemCfgB = ManagerContainer.CfgMgr:GetItemById(cfgIdB)

    -- 如果任一配置为空，则将非空项排在前面；若都为空，则按 cfgId 比较
    if not itemCfgA or not itemCfgB then
        if not itemCfgA and not itemCfgB then
            return cfgIdA > cfgIdB
        elseif not itemCfgA then
            return false
        else
            return true
        end
    end

    local qualityA = itemCfgA.Quality or 0
    local qualityB = itemCfgB.Quality or 0
    local qualityLvA = 0
    local qualityLvB = 0

    if itemCfgA.ResType == Enum.ItemType.Equip then
        qualityA, qualityLvA = CommonUtil.GetEquipItemQuality(cfgIdA)
    end
    if itemCfgB.ResType == Enum.ItemType.Equip then
        qualityB, qualityLvB = CommonUtil.GetEquipItemQuality(cfgIdB)
    end

    if qualityA == qualityB then
        if qualityLvA == qualityLvB then
            return cfgIdA > cfgIdB
        else
            return qualityLvA > qualityLvB
        end
    else
        return qualityA > qualityB
    end
end

function PopGotMgr:ctor()
    self:ClearData()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.__cname, UIEventNames.EID_EQUIP_AND_ITEM_ADD, self,
        self.UpdatePopGot)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.__cname, UIEventNames.EID_EQUIP_AND_ITEM_ADD_LIST, self,
        self.UpdatePopGotList)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.__cname, UIEventNames.EID_FASHION_ADD, self, self.UpdateFashionGot)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.__cname, UIEventNames.EID_SKILL_EQUIP_ADD_LIST, self,
        self.UpdateSkillEquipList)
end

function PopGotMgr:Destroy()
    ManagerContainer.LuaEventMgr:Unregister(self.__cname)
    self:ClearData()
end

function PopGotMgr:UpdatePopGot(addItemMap)
    if self.isKeep then
        return
    end
    if self.addItemMap == nil then
        self.addItemMap = {}
    end
    local num = 0
    for key, value in pairs(addItemMap) do
        local count = 0
        local vip = 0
        if type(value) == "table" then
            count = value[1]
            vip = value[2]
        else
            count = value
        end
        if self.addItemMap[key] then
            self.addItemMap[key] = {self.addItemMap[key][1] + count, vip}
        else
            self.addItemMap[key] = {count, vip}
            num = num + 1
        end
    end
    if num <= 0 then
        return
    end
    if not self.showPopType then
        self.showPopType = ShowPopType.EquipAndItem
    end
    if self.timeId == nil then
        self.timeId = ManagerContainer.LuaTimerMgr:AddTimer(DeltaTime, 1, self, self.ShowView, nil)
    end
end

function PopGotMgr:UpdatePopGotList(addItemMap)
    if self.isKeep then
        return
    end
    if self.addItemMap == nil then
        self.addItemMap = {}
    end
    local num = 0
    for _, value in pairs(addItemMap) do
        local count = value[2]
        local vip = value[3]
        local key = value[1]

        self.addItemMap[#self.addItemMap + 1] = {key, count, vip}
        num = num + 1
    end
    if num <= 0 then
        return
    end
    if not self.showPopType then
        self.showPopType = ShowPopType.EquipAndItemList
    end
    if self.timeId == nil then
        self.timeId = ManagerContainer.LuaTimerMgr:AddTimer(DeltaTime, 1, self, self.ShowView, nil)
    end
end

function PopGotMgr:UpdateSkillEquipList(addItemMap)
    if self.isKeep then
        return
    end
    if self.addSkillEquipMap == nil then
        self.addSkillEquipMap = {}
    end
    local num = 0
    for _, value in pairs(addItemMap) do
        local count = value[2]
        local starLv = value[3]
        local key = value[1]

        self.addSkillEquipMap[#self.addSkillEquipMap + 1] = {key, count, starLv}
        num = num + 1
    end
    if num <= 0 then
        return
    end
    if not self.showPopType then
        self.showPopType = ShowPopType.SkillEquipList
    end
    if self.timeId == nil then
        self.timeId = ManagerContainer.LuaTimerMgr:AddTimer(DeltaTime, 1, self, self.ShowView, nil)
    end
end

function PopGotMgr:UpdateFashionGot(addFashionMap)
    if self.isKeep then
        return
    end
    if self.addFashionMap == nil then
        self.addFashionMap = {}
    end
    local num = 0
    for key, value in pairs(addFashionMap) do
        if self.addFashionMap[key] then
            self.addFashionMap[key] = self.addFashionMap[key] + value
        else
            self.addFashionMap[key] = value
            num = num + 1
        end
    end
    if num <= 0 then
        return
    end
    if not self.showPopType then
        self.showPopType = ShowPopType.Fashion
    end
    if self.timeId == nil then
        self.timeId = ManagerContainer.LuaTimerMgr:AddTimer(DeltaTime, 1, self, self.ShowView, nil)
    end
end

function PopGotMgr:ShowView()
    if self.showPopType == ShowPopType.EquipAndItem then
        local addItems = {}
        for key, value in pairs(self.addItemMap) do
            table.insert(addItems, {
                cfgId = key,
                num = value[1],
                vip = value[2]
            })
        end
        table.sort(addItems, EquipAndItemSortRule)
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIPOPGot) then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {
                rewards = addItems
            })
            self:PageViewKeep(true)
        end
    elseif self.showPopType == ShowPopType.EquipAndItemList then
        local addItems = {}
        for _, value in pairs(self.addItemMap) do
            table.insert(addItems, {
                cfgId = value[1],
                num = value[2],
                vip = value[3]
            })
        end
        table.sort(addItems, EquipAndItemSortRule)
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIPOPGot) then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {
                rewards = addItems
            })
            self:PageViewKeep(true)
        end
    elseif self.showPopType == ShowPopType.Fashion then
        local addFashions = {}
        for key, _ in pairs(self.addFashionMap) do
            table.insert(addFashions, {
                cfgId = key
            })
        end
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIFashionGot) then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionGot, addFashions)
            self:PageViewKeep(true)
        end
    elseif self.showPopType == ShowPopType.SkillEquipList then
        local addSkillEquip = {}
        for _, value in pairs(self.addSkillEquipMap) do
            table.insert(addSkillEquip, {
                cfgId = value[1],
                num = value[2],
                starLv = value[3]
            })
        end
        table.sort(addSkillEquip, EquipAndItemSortRule)
        if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIPOPGot) then
            ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {
                rewards = addSkillEquip
            })
            self:PageViewKeep(true)
        end
    end
end

function PopGotMgr:PageViewKeep(isKeep)
    self.isKeep = isKeep or false
    if not self.isKeep then
        self:ClearData()
    end
end

function PopGotMgr:ClearData()
    self.addItemMap = nil
    self.addFashionMap = nil
    self.addSkillEquipMap = nil
    if self.timeId then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.timeId)
        self.timeId = nil
    end
    self.timeId = nil
    self.showPopType = nil
    self.isKeep = false
end

return PopGotMgr
