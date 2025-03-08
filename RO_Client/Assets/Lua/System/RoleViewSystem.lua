--[[
    @ 所有的skinDatas格式如下
    skinDatas =
    {
        [Enum.SkinSlotType.HeadTop] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.HeadMiddle] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.HeadBottom] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.Cloth] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.LeftHand] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.RightHand] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.BodyBack] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.HairStyle] = {prefabGo = GameObject, customBindBone = String}
        [Enum.SkinSlotType.Pupil] = {prefabGo = GameObject, customBindBone = String},
        [Enum.SkinSlotType.HairColor] = {uvOffset = Vector2},
        [Enum.SkinSlotType.Face] = {prefabGo = GameObject},
    }
    prefabGo 为 prefab资源
    customBindBone 为自定义绑定骨骼，可为nil, 不为nil是会覆盖默认绑定骨骼节点


    @ 英雄 需要在预览和战斗中显示的 内容
    viewDatas = {
        [Enum.HeroExtGoesShowType.God_Art] = {prefabGo = GameObject, prefabPath = String}
    }
]]

local RoleViewSystem = class("RoleViewSystem")
local SkinSystem = require("SkinSystem")
local ViewSystem = require("ViewSystem")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local AnimatorType = typeof(UnityEngine.Animator)
local AnimControlSkinType = typeof(AnimControlSkin)

local RoleCfgKey = {
    [Enum.FashionSlotType.HeadTop]     = "HeadTop",
    [Enum.FashionSlotType.HeadMiddle]  = "HeadMiddle",
    [Enum.FashionSlotType.HeadBottom]  = "HeadBottom",
    [Enum.FashionSlotType.Cloth]       = "ClothId",
    [Enum.FashionSlotType.BodyBack]    = "BodyBackId",
    [Enum.FashionSlotType.Weapon]      = "WeaponId",
    [Enum.FashionSlotType.HairStyle]   = "Hair",
    [Enum.FashionSlotType.Pupil]       = "Eye",
}

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

local function SkinsDiff(roleCfgId, oldSkins, viewData)
    local changed = false
    local diffSkins = {}
    local cfgMgr = ManagerContainer.CfgMgr
    local roleCfg = cfgMgr:GetRoleDataById(roleCfgId)
    if not roleCfg and not viewData then
        return changed, diffSkins
    end

    local getFashionById = cfgMgr.GetFashionById
    local fashionViewData = viewData and viewData.fashionData or nil
    local FashionSlotType = Enum.FashionSlotType
    local SkinSlotType = Enum.SkinSlotType
    --- 找是否有互斥的数据 （目前是头发）
    local isHideHair = false
    if fashionViewData then
        local fashionId = fashionViewData[FashionSlotType.HeadTop]
        if fashionId then
            local fashionData = getFashionById(cfgMgr, fashionId)
            if fashionData then
                isHideHair = fashionData.FashionHideHair
            end
        end
    end
  
    local avatarId, skinSlotType, fashionData
    skinSlotType = SkinSlotType.Face
    if roleCfg.Sex == Enum.SexType.Man then
        avatarId = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_man_face_model_path)
    else
        avatarId = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_woman_face_model_path)
    end
    changed = CombineDiff(oldSkins, skinSlotType, avatarId, diffSkins)
    for _, fashionSlotType in pairs(FashionSlotType) do
        avatarId = 0
        fashionData = nil
        if fashionViewData then
            local fashionId = fashionViewData[fashionSlotType]
            if fashionId then
                fashionData = getFashionById(cfgMgr, fashionId)
            end
        end
        if fashionSlotType == FashionSlotType.Weapon then
            if roleCfg.LeftWeapon and roleCfg.LeftWeapon ~= 0 then
                if fashionData then avatarId = fashionData.RoleAvatarID end
                skinSlotType = SkinSlotType.LeftHand
                avatarId = ((avatarId and avatarId ~= 0 ) and avatarId or roleCfg.LeftWeapon)
                if not avatarId then avatarId = 0 end
                if CombineDiff(oldSkins, skinSlotType, avatarId, diffSkins) then
                    changed = true
                end
            end
            avatarId = 0
            if roleCfg.RightWeapon and roleCfg.RightWeapon ~= 0 then
                if fashionData then avatarId = fashionData.ExtRoleAvatarID end
                skinSlotType = SkinSlotType.RightHand
                avatarId = ((avatarId and avatarId ~= 0 ) and avatarId or roleCfg.RightWeapon)
                if not avatarId then avatarId = 0 end
                if CombineDiff(oldSkins, skinSlotType, avatarId, diffSkins) then
                    changed = true
                end
            end
        else
            if fashionData then
                avatarId = fashionData.ExtRoleAvatarID
                if not avatarId or avatarId == 0 then
                    avatarId = fashionData.RoleAvatarID
                end
            end
            -- 去默认的配置中找
            if not avatarId or avatarId == 0 then
                local key = RoleCfgKey[fashionSlotType]
                if key then
                    avatarId = roleCfg[key]
                end
            end
            skinSlotType = Enum.FashionSlotToSkinSlot[fashionSlotType]
            if skinSlotType == SkinSlotType.HairStyle and isHideHair then
                avatarId = 0
            end
            if not avatarId then avatarId = 0 end
            if CombineDiff(oldSkins, skinSlotType, avatarId, diffSkins) then
                changed = true
            end
        end
    end
    return changed, diffSkins
end

local function GetAnimatorControllerPath(roleCfgId, roleInEnvType)
    local roleCfg = ManagerContainer.CfgMgr:GetRoleDataById(roleCfgId)
    if not roleCfg then
        roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(roleCfgId)
    end
    if Enum.RoleInEnvType.CreateRole == roleInEnvType or Enum.RoleInEnvType.FashionView == roleInEnvType then
        return Constants.AnimatorPath, roleCfg.CreateShowCtrl
    -- elseif Enum.RoleInEnvType.GuildLobby == roleInEnvType then
    --     return Constants.AnimatorPath, roleCfg.CityCtrl
    elseif Enum.RoleInEnvType.RoleMainView == roleInEnvType then
        return Constants.AnimatorPath, roleCfg.RoleShowCtrl or roleCfg.ShowCtrl
    elseif Enum.RoleInEnvType.Transfer == roleInEnvType then
        return Constants.AnimatorPath, roleCfg.TransferShowCtrl
    else
        return Constants.AnimatorPath, roleCfg.BattleCtrl
    end
end

local function GetSkinDatas(oldSkins, updateDiffSkins)
    local skinDatas = nil
    if updateDiffSkins then
        skinDatas = {}
        local cfgMgr = ManagerContainer.CfgMgr
        local getRoleAvatarById = cfgMgr.GetRoleAvatarById
        local hasValue, prefabGo, avatarPrefab, pos, rot, scale
        for skinSlotType,avatarId in pairs(updateDiffSkins) do
            hasValue = false
            prefabGo = nil
            pos = nil
            rot = nil
            scale = nil
            if avatarId and avatarId > 0 then
                hasValue = true
                local roleAvatarCfg = getRoleAvatarById(cfgMgr, avatarId)
                if roleAvatarCfg then
                    avatarPrefab = roleAvatarCfg.AvatarPrefab
                    if avatarPrefab and avatarPrefab ~= '' then
                        prefabGo = ManagerContainer.ResMgr:GetAsset(Constants.ModelPath, avatarPrefab)
                    end
                    pos = CommonUtil.TableToVector3(roleAvatarCfg.ModelPosition)
                    rot = CommonUtil.TableToQuaternion(roleAvatarCfg.ModelRotation)
                    scale = CommonUtil.TableToVector3(roleAvatarCfg.ModelScale, Vector3.one)
                end
            end
            skinDatas[skinSlotType] = {hasValue = hasValue, prefabGo = prefabGo, pos = pos, rot = rot, scale = scale}
            CombineDiff(oldSkins, skinSlotType, avatarId, oldSkins)
        end
    end
    return skinDatas
end



function RoleViewSystem:ctor()
    self.skinSystem = nil
    self.viewSystem = nil
    self.HeroId = nil 
    -- 实例化的对象，在系统销毁时，需要销毁或回收
    self.gameObject = nil
    -- 在异步创建中的皮肤数据
    self.updateDiffSkins = nil
    -- 在异步创建中的扩展皮肤数据
    self.updateDiffExtSkins = nil
    -- 当前显示的皮肤数据
    self.oldSkins = nil
    -- 当前显示的扩展皮肤数据
    self.oldExtSkins = nil
    -- 如果不为空，说明基本骨骼都需要改变，则全部重新创建
    self.updateRoleCfgId = nil
    self.oldRoleCfgId = nil
    -- 在异步创建中的动作控制器
    self.updateRoleInEnvType = nil

    -- 在异步创建中的额外显示数据
    self.updateExtGoesShow = nil
    -- 当前额外显示数据
    self.oldShowData = nil

    -- 当前显示的动作控制器
    self.oldRoleInEnvType = nil
    self.ownercb = nil
    self.cb = nil
    self.loadSystem = MultiTypeAssetLoadSystem:new()
    self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)
end

function RoleViewSystem:Dispose()
    self:Recycle()
    self.loadSystem:Dispose()
    self.loadSystem = nil
end

function RoleViewSystem:SetHeroId(Id)
    self.HeroId = Id
end

function RoleViewSystem:RefreshData(roleInEnvType, roleCfgId, viewData, extGoesShowData, createdOwner, createdCB)
    -- 角色模型已经生成成功了
    local skinChanged, viewChanged = false, false
    if not tolua.isnull(self.gameObject) and self.oldRoleCfgId == roleCfgId then
        skinChanged = self:UpdateSkinData(roleInEnvType, roleCfgId, viewData)
        viewChanged = self:UpdateHeroExtGoesShowView(extGoesShowData)
    else
        self:Recycle()
        self:UpdateSkinData(roleInEnvType, roleCfgId, viewData)
        self:UpdateHeroExtGoesShowView(extGoesShowData)
        self.updateRoleCfgId = roleCfgId
        skinChanged = true
        viewChanged = true
    end
    if skinChanged or viewChanged then
        self.loadSystem:Cancel()

        self.ownercb = createdOwner
        self.cb = createdCB
        self:RefreshLoadSystem()
    end
    return skinChanged or viewChanged
end

function RoleViewSystem:UpdateSkinData(roleInEnvType, roleCfgId, viewData)
    local changed,diffSkins = SkinsDiff(roleCfgId, self.oldSkins, viewData)
    changed = (roleInEnvType ~= self.oldRoleInEnvType) or changed
    if changed then
        -- self:CancelCreate()
        self.updateDiffSkins = nil
        self.updateRoleInEnvType = nil
    end
    self.updateDiffSkins = diffSkins
    self.updateRoleInEnvType = (roleInEnvType ~= self.oldRoleInEnvType) and roleInEnvType or nil
    return changed
end

--- 刷新显示数据，并自动变更形象
function RoleViewSystem:RefreshView(roleInEnvType, roleCfgId, viewData, heroViewData, createdOwner, createdCB)
    -- 角色模型已经生成成功了
    local changed = self:RefreshData(roleInEnvType, roleCfgId, viewData, heroViewData, createdOwner, createdCB)
    if not changed then
        if createdOwner and createdCB then
            createdCB(createdOwner, self.gameObject,false,self.HeroId)          
        end
        self.ownercb = nil
        self.cb = nil
        return
    end
    self:BeginCreate()
end

--- 强制修改当前皮肤
--- changeExtSkins {{[Enum.SkinSlotType.HeadTop] = RoleAvatarId}}
--- RoleAvatarId为 RoleAvatarCfg的Id
function RoleViewSystem:ChangeExtSkins(changeExtSkins)
    if not changeExtSkins then return end
    local changed = false
    local diffExtSkins = {}
    for skinSlotType, avatarId in pairs(changeExtSkins) do
        if CombineDiff(self.oldExtSkins, skinSlotType, avatarId, diffExtSkins) then
            changed = true
        end
    end
    if changed then
        self.updateDiffExtSkins = diffExtSkins
        self:CancelCreate()
        self:RefreshLoadSystem()
        self:BeginCreate()
    end
end

--- CS代码强制修改当前皮肤
function RoleViewSystem:CSChangeExtSkins(skinSlotTypes, roleAvatarIds)
    if not roleAvatarIds or not skinSlotTypes then return end
    local len1 = roleAvatarIds.Length
    local len2 = skinSlotTypes.Length
    local len = Mathf.Max(len1, len2)
    if len <= 0 then return end
    local changed = false
    local diffExtSkins = {}
    for i = 0, len - 1 do
        local skinSlotType = skinSlotTypes[i]
        local avatarId = roleAvatarIds[i]
        if CombineDiff(self.oldExtSkins, skinSlotType, avatarId, diffExtSkins) then
            changed = true
        end
    end
    if changed then
        self.updateDiffExtSkins = diffExtSkins
        self:CancelCreate()
        self:RefreshLoadSystem()
        self:BeginCreate()
    end
end

--- 获得预加载的资源列表 table(reousrceType, table(path))
function RoleViewSystem:StatisticsPreloadAssets(multiTypeAssetLoadSystem)
    if not multiTypeAssetLoadSystem then multiTypeAssetLoadSystem = MultiTypeAssetLoadSystem:new() end
    self.loadSystem:AddToLoadSystem(multiTypeAssetLoadSystem)
end

function RoleViewSystem:RefreshLoadSystem()
    self.loadSystem:RemoveLoadAllAsset()
    local assetPath = nil
    local assetName = nil
    local cfgMgr = ManagerContainer.CfgMgr
    -- 基本骨骼
    if self.updateRoleCfgId then
        local roleCfg = cfgMgr:GetRoleDataById(self.updateRoleCfgId)
        local baseName
        if roleCfg then
            if roleCfg.Sex == Enum.SexType.Man then
                baseName = GlobalConfig.c_man_base_model_path
            else
                baseName = GlobalConfig.c_woman_base_model_path
            end
            assetName = GlobalConfig.Instance:GetConfigStrValue(baseName)
        else
            roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(self.updateRoleCfgId)
            local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(roleCfg.AvatarId)
            assetName = avatarData.AvatarPrefab
        end
        self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, assetName)
    end
    -- 动作控制器
    if self.updateRoleInEnvType then
        assetPath, assetName = GetAnimatorControllerPath(self.updateRoleCfgId or self.oldRoleCfgId, self.updateRoleInEnvType)
        self.loadSystem:AddLoadAsset(Enum.ResourceType.AnimatorController, assetPath, assetName)
    end
    local getRoleAvatarById = cfgMgr.GetRoleAvatarById
    if self.updateDiffSkins then
        for skinSlotType,avatarId in pairs(self.updateDiffSkins) do
            if avatarId and avatarId > 0 then
                local roleAvatarCfg = getRoleAvatarById(cfgMgr, avatarId)
                if roleAvatarCfg then
                    local avatarPrefab = roleAvatarCfg.AvatarPrefab
                    if avatarPrefab and avatarPrefab ~= '' then
                        self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, avatarPrefab)
                    end
                end
            end
        end
    end
    if self.updateDiffExtSkins then
        for skinSlotType,avatarId in pairs(self.updateDiffExtSkins) do
            if avatarId and avatarId > 0 then
                local roleAvatarCfg = getRoleAvatarById(cfgMgr, avatarId)
                if roleAvatarCfg then
                    local avatarPrefab = roleAvatarCfg.AvatarPrefab
                    if avatarPrefab and avatarPrefab ~= '' then
                        self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, avatarPrefab)
                    end
                end
            end
        end
    end
    if self.updateExtGoesShow then
        for heroViewType,val in pairs(self.updateExtGoesShow) do
            if val and val > 0 then
                if heroViewType == Enum.HeroExtGoesShowType.God_Art then
                    local cfgData = cfgMgr:GetArtifactCfgDataByCfgId(val)
                    if cfgData then
                        local avatarPrefab = cfgData.AvatarPrefab
                        if avatarPrefab and avatarPrefab ~= '' then
                            self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, avatarPrefab)
                        end
                    end
                elseif heroViewType == Enum.HeroExtGoesShowType.Strength_Halo then
                    local lv = val
                    if val >= #Constant.PartnerStrengthEffectPath then
                        lv = #Constant.PartnerStrengthEffectPath
                    end
                    local effectName = Constant.PartnerStrengthEffectPath[lv]
                    self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, effectName)
                end
            end
        end
    end
end

---@generic 预加载的资源已加载完成
function RoleViewSystem:PreloadedAssets()
    self:Create()
end

function RoleViewSystem:BeginCreate()
    self.loadSystem:Begin()
end

function RoleViewSystem:CancelCreate()
    self.loadSystem:Cancel()
    self.updateDiffSkins = nil
    self.updateExtGoesShow = nil
    self.updateRoleCfgId = nil
    self.updateRoleInEnvType = nil
end

function RoleViewSystem:Recycle()
    self:CancelCreate()
    if self.skinSystem then
        self.skinSystem:Dispose()
    end
    self.skinSystem = nil
    if self.viewSystem then
        self.viewSystem:Dispose()
    end
    self.viewSystem = nil

    if not tolua.isnull(self.gameObject) then
        local go = self.gameObject
        local animator = go:GetComponent(AnimatorType)
        animator.runtimeAnimatorController = nil
        local animControlSkin = go:GetComponent(AnimControlSkinType)
        if animControlSkin then
            animControlSkin:SetBindLuaCallback(nil, nil)
        end
        local roleCfg = ManagerContainer.CfgMgr:GetRoleDataById(self.oldRoleCfgId)
        local baseName, assetName
        if roleCfg then
            if roleCfg.Sex == Enum.SexType.Man then
                baseName = GlobalConfig.c_man_base_model_path
            else
                baseName = GlobalConfig.c_woman_base_model_path
            end
            assetName = GlobalConfig.Instance:GetConfigStrValue(baseName)
        else
            roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(self.oldRoleCfgId)
            local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(roleCfg.AvatarId)
            assetName = avatarData.AvatarPrefab
        end
        ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, assetName, go)
    end
    self.gameObject = nil
    self.oldSkins = nil
    self.oldShowData = nil
    self.oldExtSkins = nil
    self.oldRoleCfgId = nil
    self.oldRoleInEnvType = nil
    self.ownercb = nil
    self.cb = nil
end

-- 需要预先加载好了资源
function RoleViewSystem:Create()
    local assetPath = nil
    local assetName = nil
    local newGO = nil
    local cfgMgr = ManagerContainer.CfgMgr
    local isLeader = false
    -- 基本骨骼
    if self.updateRoleCfgId then
        local roleCfg = cfgMgr:GetRoleDataById(self.updateRoleCfgId)
        local baseName
        if roleCfg then
            isLeader = true
            if roleCfg.Sex == Enum.SexType.Man then
                baseName = GlobalConfig.c_man_base_model_path
            else
                baseName = GlobalConfig.c_woman_base_model_path
            end
            assetName = GlobalConfig.Instance:GetConfigStrValue(baseName)
        else
            roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(self.updateRoleCfgId)
            local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(roleCfg.AvatarId)
            assetName = avatarData.AvatarPrefab
        end
        newGO = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, assetName)
        if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
            newGO.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
        else
            newGO.transform.parent = nil
        end
        newGO.transform.position = Vector3.zero;
        newGO.transform.rotation = Quaternion.identity;
        newGO:SetActive(true)
        self.oldRoleCfgId = self.updateRoleCfgId

        self.gameObject = newGO
    else
        local roleCfg = cfgMgr:GetRoleDataById(self.oldRoleCfgId)
        if roleCfg then
            isLeader = true
        end
    end
    -- 其它部位  时装 暂时只有主角有
    if isLeader then
        local oldSkins = self.oldSkins
        if not oldSkins then
            oldSkins = {}
            self.oldSkins = oldSkins
        end
        local skinDatas = GetSkinDatas(oldSkins, self.updateDiffSkins)

        local oldExtSkins = self.oldExtSkins
        if not oldExtSkins then
            oldExtSkins = {}
            self.oldExtSkins = oldExtSkins
        end
        local skinExtDatas = GetSkinDatas(oldExtSkins, self.updateDiffExtSkins)
        
        if not self.skinSystem then
            self.skinSystem = SkinSystem.new()
        end
        if not tolua.isnull(newGO) then
            -- 新角色生成
            self.skinSystem:Init(self.gameObject.transform, skinDatas, skinExtDatas, true)
        else
            -- 刷新形象
            self.skinSystem:SetSkins(skinDatas, skinExtDatas, true)
        end
    end
    -- 动作控制器 (在有BlendShape的SkinnedMeshRenderer之后加，否则Animator不生效BlendShape动画)
    if self.updateRoleInEnvType then
        assetPath, assetName = GetAnimatorControllerPath(self.updateRoleCfgId or self.oldRoleCfgId, self.updateRoleInEnvType)
        local animatorController = ManagerContainer.ResMgr:GetAsset(assetPath, assetName)
        local go = self.gameObject
        if not tolua.isnull(go) then
            local animator = go:GetComponent(AnimatorType)
            if tolua.isnull(animator) then
                animator = go:AddComponent(AnimatorType)
            end
            animator.runtimeAnimatorController = animatorController
            local animControlSkin = go:GetComponent(AnimControlSkinType)
            if tolua.isnull(animControlSkin) then
                animControlSkin = go:AddComponent(AnimControlSkinType)
            end
            animControlSkin:SetBindLuaCallback(self, self.CSChangeExtSkins)
        end
        self.oldRoleInEnvType = self.updateRoleInEnvType
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
    self.updateDiffSkins = nil
    self.updateDiffExtSkins = nil
    self.updateRoleCfgId = nil
    self.updateRoleInEnvType = nil
    self.updateExtGoesShow = nil
    -- 回调
    if self.ownercb and self.cb then
        self.cb(self.ownercb, self.gameObject, (newGO ~= nil),self.HeroId)
    end
    self.ownercb = nil
    self.cb = nil
    return self.gameObject
end

function RoleViewSystem:RolePlayAni(go, aniName)
    if tolua.isnull(go) then return end
    local animator = go:GetComponent(Enum.TypeInfo.Animator)
    if tolua.isnull(animator) then return end
    animator:Play(aniName)
end

function RoleViewSystem:GetGameObject()
    return self.gameObject
end

----------------------------------------------神器----------------------------------------------

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

local function HeroExtGoesShowViewUpdate(roleInEnvType, oldShowData, curExtGoesShow)
    local extGoesShow = {}
    local changed = false
    if ExtGoesShowUpdate(oldShowData, Enum.HeroExtGoesShowType.God_Art, curExtGoesShow, extGoesShow) then
        changed = true
    end
    if roleInEnvType ~= Enum.RoleInEnvType.Battle then
        if ExtGoesShowUpdate(oldShowData, Enum.HeroExtGoesShowType.Strength_Halo, curExtGoesShow, extGoesShow) then
            changed = true
        end
    end
    return changed, extGoesShow
end

function RoleViewSystem:UpdateHeroExtGoesShowView(extGoesShow)
    local changed, viewUpdate = HeroExtGoesShowViewUpdate(self.updateRoleInEnvType, self.oldShowData, extGoesShow)
    if changed then
        self.updateExtGoesShow = nil
    end
    self.updateExtGoesShow = viewUpdate
    return changed
end

-------------------------------------------------------------------------------------------------


return RoleViewSystem