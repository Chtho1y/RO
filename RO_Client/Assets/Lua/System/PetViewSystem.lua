--[[
    @ 宠物 需要在预览和战斗中显示的 内容
    viewDatas = {
        [Enum.HeroExtGoesShowType.God_Art] = {prefabGo = GameObject, prefabPath = String}
    }
]]

local PetViewSystem = class("PetViewSystem")
local ViewSystem = require("ViewSystem")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local AnimatorType = typeof(UnityEngine.Animator)
local CfgMgr = ManagerContainer.CfgMgr
local function CombineDiff(map, key, value, diffMap)
    if not key then
        return false
    end
    if not map or map[key] ~= value then
        diffMap[key] = value
        return true
    end
    return false
end

local function GetAnimatorControllerPath(cfgId, inEnvType)
    local petCfg = ManagerContainer.CfgMgr:GetPetDataById(cfgId)
    if not petCfg then
        return Constants.AnimatorPath, petCfg.BattleCtrl
    end
    if Enum.RoleInEnvType.PetLvUp == inEnvType then
        return Constants.AnimatorPath, petCfg.ShowCtrl
    else
        return Constants.AnimatorPath, petCfg.ShowCtrl
    end
end


function PetViewSystem:ctor()
    self.viewSystem = nil
    self.param = nil 
    -- 实例化的对象，在系统销毁时，需要销毁或回收
    self.gameObject = nil
    -- 在异步创建中的扩展物件数据
    self.updateDiffExtSkins = nil
    -- 当前显示的扩展物件数据
    self.oldExtSkins = nil
    -- 如果不为空，说明基本骨骼都需要改变，则全部重新创建
    self.updatePetCfgId = nil
    self.oldPetCfgId = nil
    -- 在异步创建中的动作控制器
    self.updateInEnvType = nil

    -- 在异步创建中的额外显示数据
    self.updateExtGoesShow = nil
    -- 当前额外显示数据
    self.oldShowData = nil

    -- 当前显示的动作控制器
    self.oldInEnvType = nil
    self.ownercb = nil
    self.cb = nil
    self.loadSystem = MultiTypeAssetLoadSystem:new()
    self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)
end

function PetViewSystem:Dispose()
    self:Recycle()
    self.loadSystem:Dispose()
    self.loadSystem = nil
end

function PetViewSystem:SetParam(param)
    self.param = param
end

function PetViewSystem:RefreshData(inEnvType, cfgId, extGoesShowData, createdOwner, createdCB)
    -- 角色模型已经生成成功了
    local viewChanged = false
    if not tolua.isnull(self.gameObject) and self.oldPetCfgId == cfgId then
        viewChanged = self:UpdateHeroExtGoesShowView(extGoesShowData)
    else
        self:Recycle()
        self:UpdateHeroExtGoesShowView(extGoesShowData)
        self.updatePetCfgId = cfgId
        viewChanged = true
    end
    if viewChanged then
        self.loadSystem:Cancel()
        self.updateInEnvType = inEnvType;

        self.ownercb = createdOwner
        self.cb = createdCB
        self:RefreshLoadSystem()
    end
    return viewChanged
end

--- 刷新显示数据，并自动变更形象
function PetViewSystem:RefreshView(inEnvType, petCfgId, heroViewData, createdOwner, createdCB)
    -- 角色模型已经生成成功了
    local changed = self:RefreshData(inEnvType, petCfgId, heroViewData, createdOwner, createdCB)
    if not changed then
        if createdOwner and createdCB then
            createdCB(createdOwner, self.gameObject,false,self.param)          
        end
        self.ownercb = nil
        self.cb = nil
        return
    end
    self:BeginCreate()
end

--- 获得预加载的资源列表 table(reousrceType, table(path))
function PetViewSystem:StatisticsPreloadAssets(multiTypeAssetLoadSystem)
    if not multiTypeAssetLoadSystem then multiTypeAssetLoadSystem = MultiTypeAssetLoadSystem:new() end
    self.loadSystem:AddToLoadSystem(multiTypeAssetLoadSystem)
end

function PetViewSystem:RefreshLoadSystem()
    self.loadSystem:RemoveLoadAllAsset()
    local assetPath = nil
    local assetName = nil
    local cfgMgr = ManagerContainer.CfgMgr
    -- 基本骨骼
    if self.updatePetCfgId then
        local petCfg = cfgMgr:GetPetDataById(self.updatePetCfgId)
        if petCfg == nil then
            LogError(self.curLoadCfgId .. "isnt exist in PetCfg")
            return
        end
        local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(petCfg.AvatarId)
        if avatarData == nil then
            LogError(roleCfg.AvatarId .. "isnt exist in AvatarCfg")
            return
        end
        self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, avatarData.AvatarPrefab)
    end
    -- 动作控制器
    if self.updateInEnvType then
        assetPath, assetName = GetAnimatorControllerPath(self.updatePetCfgId or self.oldPetCfgId, self.updateInEnvType)
        self.loadSystem:AddLoadAsset(Enum.ResourceType.AnimatorController, assetPath, assetName)
    end

    if self.updateExtGoesShow then
        for heroViewType,val in pairs(self.updateExtGoesShow) do
            if heroViewType == Enum.HeroExtGoesShowType.Pet_Qiyue then
                if val.cfgIds and #val.cfgIds > 0 then
                    for i = 1, #val.cfgIds do
                        local cfgId = val.cfgIds[i]
                        local petCfgData = CfgMgr:GetPetDataById(cfgId)
                        if petCfgData then
                            local natureData = CfgMgr:GetNatureDataById(petCfgData.NatureType)
                            if natureData then
                                local avatarPrefab = natureData.PetContract
                                if avatarPrefab and avatarPrefab ~= '' then
                                    self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, avatarPrefab)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

---@generic 预加载的资源已加载完成
function PetViewSystem:PreloadedAssets()
    self:Create()
end

function PetViewSystem:BeginCreate()
    self.loadSystem:Begin()
end

function PetViewSystem:CancelCreate()
    self.loadSystem:Cancel()
    self.updateExtGoesShow = nil
    self.updatePetCfgId = nil
    self.updateInEnvType = nil
end

function PetViewSystem:Recycle()
    self:CancelCreate()
    if self.viewSystem then
        self.viewSystem:Dispose()
    end
    self.viewSystem = nil

    if not tolua.isnull(self.gameObject) then
        local go = self.gameObject
        local animator = go:GetComponent(AnimatorType)
        animator.runtimeAnimatorController = nil
        local petCfg = ManagerContainer.CfgMgr:GetPetDataById(self.oldPetCfgId)
        if petCfg == nil then
            LogError(self.curLoadCfgId .. "isnt exist in PetCfg")
            return
        end
        local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(petCfg.AvatarId)
        if avatarData == nil then
            LogError(roleCfg.AvatarId .. "isnt exist in AvatarCfg")
            return
        end
        ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, avatarData.AvatarPrefab, go)
    end
    self.gameObject = nil
    self.oldShowData = nil
    self.oldExtSkins = nil
    self.oldPetCfgId = nil
    self.oldInEnvType = nil
    self.ownercb = nil
    self.cb = nil
end

-- 需要预先加载好了资源
function PetViewSystem:Create()
    local assetPath = nil
    local assetName = nil
    local newGO = nil
    local cfgMgr = ManagerContainer.CfgMgr
    local isLeader = false
    -- 基本骨骼
    if self.updatePetCfgId then
        local petCfg = cfgMgr:GetPetDataById(self.updatePetCfgId)
        if petCfg == nil then
            LogError(self.curLoadCfgId .. "isnt exist in PetCfg")
            return
        end
        local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(petCfg.AvatarId)
        if avatarData == nil then
            LogError(roleCfg.AvatarId .. "isnt exist in AvatarCfg")
            return
        end
        newGO = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, avatarData.AvatarPrefab)
        if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
            newGO.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
        else
            newGO.transform.parent = nil
        end
        newGO.transform.position = Vector3.zero;
        newGO.transform.rotation = Quaternion.identity;
        newGO:SetActive(true)
        self.oldPetCfgId = self.updatePetCfgId

        self.gameObject = newGO
    end

    -- 动作控制器 (在有BlendShape的SkinnedMeshRenderer之后加，否则Animator不生效BlendShape动画)
    if self.updateInEnvType then
        assetPath, assetName = GetAnimatorControllerPath(self.updatePetCfgId or self.oldPetCfgId, self.updateInEnvType)
        local animatorController = ManagerContainer.ResMgr:GetAsset(assetPath, assetName)
        local go = self.gameObject
        if not tolua.isnull(go) then
            local animator = go:GetComponent(AnimatorType)
            if tolua.isnull(animator) then
                animator = go:AddComponent(AnimatorType)
            end
            animator.runtimeAnimatorController = animatorController
        end
        self.oldInEnvType = self.updateInEnvType
    end

    -- 额外显示物件
    local oldShowData = self.oldShowData
    if not oldShowData then
        oldShowData = {}
        self.oldShowData = oldShowData
    end
    if not self.viewSystem then
        self.viewSystem = ViewSystem.new()
    end
    -- 刷新额外显示
    if self.updateExtGoesShow then
        self.viewSystem:UpdateView(self.gameObject.transform, oldShowData, self.updateExtGoesShow)
    end 

    -- 更新完形象，清空队列中的数据
    self.updatePetCfgId = nil
    self.updateInEnvType = nil
    self.updateExtGoesShow = nil
    -- 回调
    if self.ownercb and self.cb then
        self.cb(self.ownercb, self.gameObject, (newGO ~= nil),self.Param)
    end
    self.ownercb = nil
    self.cb = nil
    return self.gameObject
end

function PetViewSystem:RolePlayAni(go, aniName)
    if tolua.isnull(go) then return end
    local animator = go:GetComponent(Enum.TypeInfo.Animator)
    if tolua.isnull(animator) then return end
    animator:Play(aniName)
end

function PetViewSystem:GetGameObject()
    return self.gameObject
end

----------------------------------------------拓展物件----------------------------------------------

local function ExtGoesShowUpdate(map, key, data, diffMap)
    if not key or not data then
        return false
    end
    diffMap[key] = data[key]
    if not map or map[key] ~= data[key] then
        return true
    end
    return false
end

local function HeroExtGoesShowViewUpdate(inEnvType, oldShowData, curExtGoesShow)
    local extGoesShow = {}
    local changed = false
    if ExtGoesShowUpdate(oldShowData, Enum.HeroExtGoesShowType.Pet_Qiyue, curExtGoesShow, extGoesShow) then
        changed = true
    end
    return changed, extGoesShow
end

function PetViewSystem:UpdateHeroExtGoesShowView(extGoesShow)
    local changed, viewUpdate = HeroExtGoesShowViewUpdate(self.updateInEnvType, self.oldShowData, extGoesShow)
    if changed then
        self.updateExtGoesShow = nil
    end
    self.updateExtGoesShow = viewUpdate
    return changed
end

-------------------------------------------------------------------------------------------------


return PetViewSystem