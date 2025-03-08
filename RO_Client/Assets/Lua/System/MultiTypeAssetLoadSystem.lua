local MultiTypeAssetLoadSystem = class("MultiTypeAssetLoadSystem")

local GetChildMap = function(parentMap, key)
    local map = parentMap[key]
    if not map then
        map = {}
        parentMap[key] = map
    end
    return map
end

function MultiTypeAssetLoadSystem:ctor()
    self.owner = nil
    self.ownerCB = nil
    self.ownerProgressCB = nil
    self.assetMap = {}
end

function MultiTypeAssetLoadSystem:Dispose()
    self:Cancel()
    self.owner = nil
    self.ownerCB = nil
    self.ownerProgressCB = nil
    self.assetMap = nil
    self.allLoadNum = nil
end

function MultiTypeAssetLoadSystem:SetCompleteCB(owner, ownerCB, ownerProgressCB)
    self.owner = owner
    self.ownerCB = ownerCB
    self.ownerProgressCB = ownerProgressCB
end

function MultiTypeAssetLoadSystem:AddLoadAsset(resourceType, assetPath, assetName, num)
    if not assetName or assetName == '' then return end
    local assetMap = GetChildMap(self, 'assetMap')
    local typeAssetMap = GetChildMap(assetMap, resourceType)
    local assetNameMap
    if not assetPath or assetPath == '' then
        assetNameMap = typeAssetMap
    else
        assetNameMap = GetChildMap(typeAssetMap, assetPath)
    end
    if assetNameMap[assetName] then
        assetNameMap[assetName] = assetNameMap[assetName] + (num or 1)
    else
        assetNameMap[assetName] = (num or 1)
    end
end

function MultiTypeAssetLoadSystem:AddToLoadSystem(multiTypeAssetLoadSystem)
    for resourceType, typeAssetMap in pairs(self.assetMap) do
        for assetPath, assetNameMap in pairs(typeAssetMap) do
            if type(assetNameMap) == 'number' then
                multiTypeAssetLoadSystem:AddLoadAsset(resourceType, nil, assetPath, assetNameMap)
            else
                for assetName, _ in pairs(assetNameMap) do
                    multiTypeAssetLoadSystem:AddLoadAsset(resourceType, assetPath, assetName)
                end
            end
        end
    end
end

function MultiTypeAssetLoadSystem:RemoveLoadAsset(resourceType, assetPath, assetName)
    local assetMap = self.assetMap
    if not assetMap then
        return
    end
    local typeAssetMap = assetMap[resourceType]
    if not typeAssetMap then
        return
    end
    if not assetPath or assetPath == '' then
        typeAssetMap[assetName] = nil
    else
        local assetNameMap = typeAssetMap[assetPath]
        if not assetNameMap then
            return
        end
        assetNameMap[assetName] = nil
    end
end

function MultiTypeAssetLoadSystem:RemoveLoadAllAsset()
    self.assetMap = {}
end

function MultiTypeAssetLoadSystem:Begin()
    self:Cancel()
    local assetMap = self.assetMap
    local hasLoad = false
    if assetMap then
        self.preloadSeqIds = {}
        for resourceType, typeAssetMap in pairs(self.assetMap) do
            for assetPath, assetNameMap in pairs(typeAssetMap) do
                if assetNameMap then
                    if type(assetNameMap) == 'number' then
                        if assetNameMap > 0 then
                            local seqId = ManagerContainer.ResMgr:LuaLoadAssets(resourceType, nil, {assetPath}, self, self.OneEnd)
                            if not ManagerContainer.ResMgr:SeqIdEquals(seqId, 0) then  -- 同步返回的不处理
                                self.preloadSeqIds[#self.preloadSeqIds + 1] = seqId
                                hasLoad = true
                            end
                        end
                    else
                        local assetNames = {}
                        for assetName, loadNum in pairs(assetNameMap) do
                            if loadNum and loadNum > 0 then
                                assetNames[#assetNames + 1] = assetName
                            end
                        end
                        if #assetNames > 0 then
                            local seqId = ManagerContainer.ResMgr:LuaLoadAssets(resourceType, assetPath, assetNames, self, self.OneEnd)
                            if not ManagerContainer.ResMgr:SeqIdEquals(seqId, 0) then  -- 同步返回的不处理
                                self.preloadSeqIds[#self.preloadSeqIds + 1] = seqId
                                hasLoad = true
                            end
                        end
                    end
                end
            end
        end
    end
    -- 没有加载的东西就直接完成
    if not hasLoad then
        self.allLoadNum = nil
        self.preloadSeqIds = nil
        self:End()
    else
        self.allLoadNum = #self.preloadSeqIds
    end
end

--- 单个类型的资源加载完成
function MultiTypeAssetLoadSystem:OneEnd(_, seqId)
    if ManagerContainer.ResMgr:SeqIdEquals(seqId, 0) then return end  -- 同步返回的不处理
    for i = 1, #self.preloadSeqIds do
        if ManagerContainer.ResMgr:SeqIdEquals(seqId, self.preloadSeqIds[i]) then
            table.remove(self.preloadSeqIds, i)
            break
        end
    end
    if not self.preloadSeqIds or #self.preloadSeqIds <= 0 then
        self.allLoadNum = nil
        self.preloadSeqIds = nil
        self:LoadProgressChanged(1)
        self:End()
    else
        if not self.allLoadNum or self.allLoadNum <= 0 then
            self:LoadProgressChanged(0)
        else
            self:LoadProgressChanged((self.allLoadNum - #self.preloadSeqIds) / self.allLoadNum)
        end
    end
end

function MultiTypeAssetLoadSystem:LoadProgressChanged(progress)
    if self.ownerProgressCB then
        if self.owner then
            self.ownerProgressCB(self.owner, progress)
        else
            self.ownerProgressCB(progress)
        end
    end
end

--- 预加载的资源已加载完成
function MultiTypeAssetLoadSystem:End()
    if self.ownerCB then
        if self.owner then
            self.ownerCB(self.owner)
        else
            self.ownerCB()
        end
    end
end

function MultiTypeAssetLoadSystem:Cancel()
    if self.preloadSeqIds then
        for i = 1, #self.preloadSeqIds do
            ManagerContainer.ResMgr:UnloadAssetBySeqId(self.preloadSeqIds[i])
        end
    end
    self.allLoadNum = nil
    self.preloadSeqIds = nil
end

return MultiTypeAssetLoadSystem