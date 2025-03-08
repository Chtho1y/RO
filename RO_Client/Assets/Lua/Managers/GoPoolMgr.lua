local GoPoolMgr = class("GoPoolMgr")

local loadCbList = {}
local loadingPrefabList = {}

function GoPoolMgr:ctor()
    self.goPool = {}
end

--创建道具go
function GoPoolMgr:SpawnItemGo(itemType, cb)
    local prefabName = CommonUtil.GetResTypePrefabName(itemType)
    if prefabName == nil then
        return
    end

    self:SpawnGo(prefabName, cb)
end

function GoPoolMgr:SpawnPrefabGo(prefabName, cb)
    if Enum.PrefabNames[prefabName] == nil then
        return
    end
    self:SpawnGo(prefabName, cb)
end

--创建grid go
function GoPoolMgr:SpawnGo(prefabName, cb)
    if self.goPool[prefabName] == nil then
        self.goPool[prefabName] = {}
    end
    local pool = self.goPool[prefabName]
    if #pool == 0 then
        if loadCbList[prefabName] == nil then
            loadCbList[prefabName] = {}
        end
        local list = loadCbList[prefabName]
        list[#list + 1] = cb

        if loadingPrefabList[prefabName] == nil then
            loadingPrefabList[prefabName] = function(go)
                if loadCbList[prefabName] and #loadCbList[prefabName] > 0 then
                    for _, v in pairs(loadCbList[prefabName]) do
                        local gridItemView = go:GetComponent(Enum.TypeInfo.UIGridViewMark)
                        if gridItemView.GridItemName ~= "" then
                            local itemlua = require("GridViewItem/"..gridItemView.GridItemName.."_Generate"):new()
                            --itemlua.gameObject = UnityEngine.GameObject.Instantiate(go)
                            local goName = gridItemView.OriName ~= "" and gridItemView.OriName or gridItemView.GridItemName
                            itemlua.gameObject = ManagerContainer.ResMgr:GetGoFromPool(Constants.UIItemDir, goName)
                            itemlua.prefabName = gridItemView.GridItemName
                            itemlua.oriName = goName
                            itemlua:InitGenerate(itemlua.gameObject.transform)
                            itemlua.gameObject:SetActive(true)
                            v(itemlua)
                            --v = nil
                        end
                    end
                    loadingPrefabList[prefabName] = nil
                    loadCbList[prefabName] = {}
                end
            end
            self:LoadGameObjectPrefab(prefabName, loadingPrefabList[prefabName])
        end
    else
        local itemlua = table.remove(pool, 1)
        --if prefabName == "EquipItem" then
        --    LogError("pop  "..prefabName.."   "..#pool)
        --end
        itemlua.gameObject:SetActive(true)
        cb(itemlua)
    end
end

function GoPoolMgr:SpawnGoNewLua(itemlua, cb)
    if itemlua == nil then return end

    if self.goPool[itemlua.prefabName] == nil then
        self.goPool[itemlua.prefabName] = {}
    end

    local pool = self.goPool[itemlua.prefabName]
    if #pool == 0 then
        --itemlua1.gameObject = UnityEngine.GameObject.Instantiate(itemlua.gameObject)
        ManagerContainer.ResMgr:GetGOFromPool(Constants.UIItemDir, itemlua.prefabName, function (go)
            local itemlua1 = require("GridViewItem/"..itemlua.prefabName.."_Generate"):new()
            itemlua1.gameObject = go
            itemlua1.prefabName = itemlua.prefabName
            itemlua1:InitGenerate(itemlua1.gameObject.transform)
            itemlua1.gameObject:SetActive(true)
            cb(itemlua1)
        end)
    else
        local itemlua = table.remove(pool, 1)
        --if prefabName == "EquipItem" then
        --    LogError("pop  "..prefabName.."   "..#pool)
        --end
        itemlua.gameObject:SetActive(true)
        cb(itemlua)
    end
end

function GoPoolMgr:SpawnGoNewLuaTotalPath(prefabPath, itemlua, cb)
    if itemlua == nil then return end

    if self.goPool[itemlua.prefabName] == nil then
        self.goPool[itemlua.prefabName] = {}
    end

    local pool = self.goPool[itemlua.prefabName]
    if #pool == 0 then
        --itemlua1.gameObject = UnityEngine.GameObject.Instantiate(itemlua.gameObject)
        ManagerContainer.ResMgr:GetGOFromPool(prefabPath, itemlua.prefabName, function (go)
            local itemlua1 = require("GridViewItem/"..itemlua.prefabName.."_Generate"):new()
            itemlua1.gameObject = go
            itemlua1.prefabName = itemlua.prefabName
            itemlua1:InitGenerate(itemlua1.gameObject.transform)
            itemlua1.gameObject:SetActive(true)
            cb(itemlua1)
        end)
    else
        local itemlua = table.remove(pool, 1)
        --if prefabName == "EquipItem" then
        --    LogError("pop  "..prefabName.."   "..#pool)
        --end
        itemlua.gameObject:SetActive(true)
        cb(itemlua)
    end
end

function GoPoolMgr:LoadGameObjectPrefab(prefabName, cb)
    ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.SingleGameObject, Constants.UIItemDir, {prefabName}, nil, cb)
end

function GoPoolMgr:RecycleGo(itemlua)
    if not itemlua then
        return false
    end
    if tolua.isnull(itemlua.gameObject) then
        itemlua:GenerateDestroy()
        itemlua.gameObject = nil
        itemlua.transform = nil
        itemlua.uiParticle = nil
        return true
    end

    local prefabName = itemlua.oriName ~= "" and itemlua.oriName or itemlua.prefabName
    local pool = self.goPool[prefabName]
    if pool == nil then
        return false
    end
    if not itemlua.inited then
        return false
    end
    if CommonUtil.EleInTable(itemlua, pool) then
        return false
    end
    pool[#pool + 1] = itemlua

    if itemlua.AsyncSeqIds then
        for k,v in pairs(itemlua.AsyncSeqIds) do
            ManagerContainer.ResMgr:UnloadAssetBySeqId(v)
            itemlua.AsyncSeqIds[k] = nil
        end
    end

    itemlua.uiParticle = nil
    itemlua.gameObject:SetActive(false)
    itemlua.transform:SetParent(ManagerContainer.ResMgr.PoolNode)
    return true
end

function GoPoolMgr:Dispose()
    for k, v in pairs(self.goPool) do
        for _,v1 in pairs(v) do
            DG.Tweening.DOTween.Kill(v1.transform)
            --CommonUtil.DestroyGO(v1.gameObject)
            --ManagerContainer.ResMgr:GetGOFromPool(Constants.UIItemDir, v1.prefabName, v1.gameObject)
            v1:GenerateDestroy()
            v1.uiParticle = nil
            v1.gameObject = nil
            v1.transform = nil
            v1 = nil
        end
        v = nil
        self.goPool[k] = nil
    end
    self.goPool = {}

    loadCbList = {}
    loadingPrefabList = {}
end

function GoPoolMgr:Destroy()
    self:Dispose()
    self.goPool = nil
    loadingPrefabList = nil
    loadCbList = nil

    if tolua.getpeer(self) ~= nil then
        tolua.setpeer(self, nil)
    end
end
return GoPoolMgr