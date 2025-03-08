local ResMgr = class("ResMgr", function()
    return ResourceMgr.Instance
end)

function ResMgr:ctor()
    self.uiGrayMat = nil
end

function ResMgr:SetGrayMat(mat)
    self.uiGrayMat = mat
end

function ResMgr:GetGrayMat()
    return self.uiGrayMat
end

function ResMgr:SetFrameQualityMat(mat)
    self.uiFrameQualityMat = mat
end

function ResMgr:GetFrameQualityMat()
    return self.uiFrameQualityMat or nil
end

function ResMgr:InitCommonMats()
    self:LuaLoadAssets(Enum.ResourceType.Material, Constants.CommonMaterialDir, {Constant.UIGrayName}, nil, function (material)
        self:SetGrayMat(material)
    end)

    self:LuaLoadAssets(Enum.ResourceType.Material, Constants.CommonMaterialDir, {Constant.UIFrameQualityName}, nil, function (material)
        self:SetFrameQualityMat(material)
    end)
end

function ResMgr:LuaLoadAssetGameObject(UIIdx, idx, path, loadType, callback, assetName)
    local assetNames = self:AsyncLoadReqInsert(UIIdx, idx, callback, assetName)
    if assetNames == false then
        return 0
    end

    if assetNames ~= nil then
        local seqId = self:LoadAssetGameObject(path, loadType, AsyncLoadGameObjectResponse, unpack(assetNames))
        self:SetAsyncLoadReqSeqId(seqId, assetName)
        return seqId
    end
end

--- 预下载
function ResMgr:DoPreDownload(obj,preconfigName)
    self:CreatePreDownloadComponent(obj, preconfigName)
end

function ResMgr:LuaLoadAssets(resourceType, assetPath, assetNames, cbOwner, cb)
    local seqId = nil
    local methodOwner = nil
    local method = nil
    if Enum.ResourceType.GameObject == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetGameObjects
    elseif Enum.ResourceType.SingleGameObject == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetGameObject
    elseif Enum.ResourceType.AnimatorController == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetRuntimeAnimatorControllers
    elseif Enum.ResourceType.Sprite == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetSprites
    elseif Enum.ResourceType.SingleSprite == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetSprite
    elseif Enum.ResourceType.Texture2D == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetTexture
    elseif Enum.ResourceType.Material == resourceType then
        methodOwner = ManagerContainer.ResMgr
        method = methodOwner.LoadAssetMaterial
    else
        LogError("未支持的加载方式，检查一下")
        if cbOwner then
            cb(cbOwner, nil, seqId, assetPath)
        else
            cb(nil, seqId, assetPath)
        end
        return seqId
    end
    seqId = method(methodOwner, assetPath, ELoadType.OTHER, function(objs, compeletSeqId, asseath, ...)
        if cbOwner then
            cb(cbOwner, objs, compeletSeqId, assetPath,assetNames, ...)
        else
            cb(objs, compeletSeqId, assetPath,assetNames, ...)
        end
    end, unpack(assetNames))
    return seqId
end

function ResMgr:SeqIdEquals(seqIdA, seqIdB)
    if tostring(seqIdA) == tostring(seqIdB) then
        return true
    end
    return false
end

function ResMgr:LuaFindSpriteByPathAndName(pathName, assetName)
    return self:FindSpriteByPathAndName(pathName, assetName)
end

function ResMgr:ClearUIAsyncLoadReqsBySeqId(seqId)
    self:UnloadAssetBySeqId(seqId)
end

function ResMgr:Destroy()
    self.uiGrayMat = nil
    LuaAsyncLoadCache = nil

    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end

return ResMgr