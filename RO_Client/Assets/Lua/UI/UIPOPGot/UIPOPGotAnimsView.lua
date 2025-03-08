local UIPOPGotAnimsView = require("UIPOPGot/UIPOPGotAnimsView_Generate")
-- local UIMainCtr = require("UIMain/UIMainCtr")
local UIMainCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIMain)

local timer
local durationTime = 0.6

local rotation = 60
local offset = 1.3

local rangeCount = {{1, 100, 2}, {101, 1000, 5}, {1001, -1, 10}}
local maxCount = 10
local curCount = 0
local enterType

-- 随机角度区间
local rotationRange = {-60, 60}
-- 随机弧线距离
local offsetRange = {0.8, 1.5}
-- 产生间隔时间
local interTime = 0.1

local taskIngList = {}

function UIPOPGotAnimsView:OnAwake(data)
    self.controller = require("UIPOPGot/UIPOPGotAnimsCtr"):new()
    self.controller:Init(self)
    self.controller:SetData(data)
end

function UIPOPGotAnimsView:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.GOT_ITEM_ANIM, function(data)
        self.controller:SetData(data)
        self:Init()
    end)
end

function UIPOPGotAnimsView:FillContent(data, uiBase)
    self.uiBase = uiBase
    local gameObject = self.uiBase:GetRoot()
    if gameObject ~= nil then
        self.gameObject = gameObject
        self.transform = gameObject.transform
    end
    self:InitGenerate(self.transform, data)

    self:Init()
end

function UIPOPGotAnimsView:Init()
    local val = GlobalConfig.Instance:GetConfigStrValue(144)
    if val ~= "" and val ~= nil then
        rangeCount = CommonUtil.DeserializeGlobalStrToTable(val)
    end

    local data = self.controller:GetData()
    local list = data.list
    local startPoses = data.startPoses
    local endPoses = data.endPoses
    local needOffset = data.needOffset or false
    enterType = data.enterType

    curCount = 0
    maxCount = 0
    for i = 1, #startPoses do
        local endPos
        if endPoses ~= nil then
            endPos = endPoses[i]
        end
        self:AddGotAnim(list[i], startPoses[i], endPos, needOffset)
    end
end

function UIPOPGotAnimsView:AddGotAnim(data, startPos, endPos, needOffset)
    -- 增加 nil 检查，避免 itemCfgData 为 nil 导致后续报错
    if not itemCfgData then
        -- LogWarning("UIPOPGotAnimsView:AddGotAnim - itemCfgData is nil for cfgId: " .. tostring(data.cfgId))
        return
    end

    if endPos == nil and UIMainCtr then
        endPos = UIMainCtr:GetGotAnimEndPosByType(itemCfgData.ResType)
    end
    if endPos == nil then
        LogError(data.cfgId .. "  item type error no endPos")
        return
    end
    local task = {
        type = itemCfgData.ResType
    }

    if (itemCfgData.ResType >= Enum.ItemType.Equip and itemCfgData.ResType <= Enum.ItemType.FashionPaper) or
        itemCfgData.ResType == Enum.ItemType.SkillBook or itemCfgData.ResType == Enum.ItemType.Gift or
        itemCfgData.ResType == Enum.ItemType.Income then
        ManagerContainer.GoPoolMgr:SpawnItemGo(itemCfgData.ResType, function(itemlua)
            CommonUtil.BatchCreateItems(self, itemlua, self.transform, data, Enum.ItemIEnterType.GotAnim)
            itemlua.transform.position = startPos
            itemlua.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
            itemlua.qualityFX.gameObject:SetActive(false);

            local result = startPos.y > endPos.y and 1 or -1

            local oriVec = endPos - startPos
            local newVec = UnityEngine.Quaternion.AngleAxis(rotation * result, Vector3.forward) * oriVec

            local path = {}
            path[1] = startPos
            path[2] = startPos + (newVec.normalized * offset);
            path[3] = endPos;
            itemlua.transform:DOScale(0.3, durationTime):SetEase(DG.Tweening.Ease.InExpo):SetAutoKill()
            itemlua.transform:DOPath(path, durationTime, DG.Tweening.PathType.CatmullRom):SetEase(DG.Tweening.Ease
                                                                                                      .Linear)
                :OnComplete(function()
                    self:RemoveCompeltedAnim(task)
                    -- ManagerContainer.GoPoolMgr:RecycleGo(itemlua)
                    CommonUtil.RecycleFromBatchItems(self, itemlua)
                    -- CommonUtil.CloseUIClearAsyncSeqIds(self)
                end):SetAutoKill()
        end)
    elseif itemCfgData.ResType < Enum.ItemType.Equip then
        local count = 0
        if itemCfgData.Id ~= Enum.ItemIds.Box then
            for _, v in pairs(rangeCount) do
                if tonumber(v[2]) ~= -1 then
                    if data.num >= tonumber(v[1]) then
                        count = tonumber(v[3])
                    end
                else
                    if data.num >= tonumber(v[1]) and data.num <= tonumber(v[2]) then
                        count = tonumber(v[3])
                    end
                end
            end
        else
            count = data.num
        end

        maxCount = maxCount + count
        if count > 0 then
            timer = ManagerContainer.LuaTimerMgr:AddTimer(interTime, count, nil, function()
                ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.GotCoinItem, function(itemlua)
                    CommonUtil.BatchCreateItems(self, itemlua, self.transform, data, Enum.ItemIEnterType.GotAnim)
                    local pos = startPos
                    if needOffset then
                        pos = self:GetCircleRandomPos(startPos, 0.5)
                    end
                    itemlua.transform.position = pos

                    local rect = itemlua.gameObject:GetComponent(Enum.TypeInfo.RectTransform)
                    rect.anchoredPosition3D = Vector3.New(rect.anchoredPosition3D.x, rect.anchoredPosition3D.y, 0)

                    itemlua.basePar:SetActive(itemCfgData.ResType == Enum.ItemType.RoleBaseExp)
                    itemlua.baseParCtr.uIParticle.cachedParticleSystem:Play(itemCfgData.ResType ==
                                                                                Enum.ItemType.RoleBaseExp)
                    itemlua.jobPar:SetActive(itemCfgData.ResType == Enum.ItemType.RoleJobExp)
                    itemlua.jobParCtr.uIParticle.cachedParticleSystem:Play(itemCfgData.ResType ==
                                                                               Enum.ItemType.RoleJobExp)

                    local oriVec = endPos - pos

                    local randomRotation = math.random(rotationRange[1], rotationRange[2])
                    local randomOffset = math.random(offsetRange[1], offsetRange[2])
                    local newVec = UnityEngine.Quaternion.AngleAxis(randomRotation, Vector3.forward) * oriVec

                    itemlua.transform:DOShakePosition(0.1, Vector3.up * 100, 2):SetEase(DG.Tweening.Ease.EaseOutElastic)
                        :OnComplete(function()
                            -- itemlua.transform:DOPunchPosition(Vector3.up*100, 0.1, 2, 2):SetEase(DG.Tweening.Ease.EaseOutElastic):OnComplete(function ()
                            local path = {}
                            path[1] = pos
                            path[2] = pos + (newVec.normalized * randomOffset);
                            path[3] = endPos;
                            itemlua.transform:DOPath(path, durationTime, DG.Tweening.PathType.CatmullRom):SetEase(
                                DG.Tweening.Ease.Linear):OnComplete(function()
                                CommonUtil.RecycleFromBatchItems(self, itemlua)
                                -- ManagerContainer.GoPoolMgr:RecycleGo(itemlua)
                                curCount = curCount + 1
                                if curCount == maxCount then
                                    self:RemoveCompeltedAnim(task)

                                    -- CommonUtil.CloseUIClearAsyncSeqIds(self)

                                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GOT_ITEM_ANIM_END_NOTIFY,
                                        itemCfgData.ResType)
                                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GOT_ANIM_TYPE_END_NOTIFY,
                                        enterType)
                                end
                            end):SetAutoKill()
                        end):SetAutoKill()
                end)
            end, nil)
        end
    end

    taskIngList[#taskIngList + 1] = task
end

function UIPOPGotAnimsView:GetCircleRandomPos(center, radius)
    local rad = radius * 10
    return center + Vector3.New(math.random(-rad, rad) * 0.1, math.random(-rad, rad) * 0.1, 0)
end

function UIPOPGotAnimsView:RemoveCompeltedAnim(task)
    for i = 1, #taskIngList do
        if task == taskIngList[i] then
            table.remove(taskIngList, i)
            return
        end
    end
end

function UIPOPGotAnimsView:IsInSameTypeAnim(type)
    for i = 1, #taskIngList do
        if taskIngList[i].type == type then
            return true
        end
    end
    return false
end

function UIPOPGotAnimsView:RemoveEventListener()
    ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPOPGotAnimsView:AddUIEventListener()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPOPGotAnimsView:OnHide()

end

function UIPOPGotAnimsView:OnShow(data)
    self.controller:SetData(data)
    self:Init()
end

function UIPOPGotAnimsView:OnClose()
end

function UIPOPGotAnimsView:OnDispose()
    if timer then
        ManagerContainer.LuaTimerMgr:RemoveTimer(timer)
        timer = nil
    end

end

return UIPOPGotAnimsView

