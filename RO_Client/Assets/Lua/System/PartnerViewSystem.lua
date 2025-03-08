local PartnerViewSystem = class("PartnerViewSystem")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local previewLayer = 15
local hideLayer = 12

local function SetTransformLayer(trans, layer)
    if not trans then return end
    trans.gameObject.layer = layer
    for i = 0, trans.childCount - 1 do
        SetTransformLayer(trans:GetChild(i), layer)
    end
end

local function SetGoLayer(modelGo, layer)
    if not modelGo then return end
    if tolua.isnull(modelGo) then return end
    SetTransformLayer(modelGo.transform, layer)
end

local TableToVector2 = function(table)
    if not table then return Vector2.zero end
    local x = table[1] or 0
    local y = table[2] or 0
    return Vector2.New(x, y)
end

local function GetAnimatorControllerPath(partnerCfg, partnerInEnvType)
    if Enum.RoleInEnvType.Transfer == partnerInEnvType then
        return Constants.AnimatorPath, partnerCfg.TransferShowCtrl
        -- elseif Enum.RoleInEnvType.MainCity == roleInEnvType then
        --     return Constants.AnimatorPath, roleCfg.CityCtrl
    elseif Enum.RoleInEnvType.RoleMainView == partnerInEnvType then
        return Constants.AnimatorPath, partnerCfg.ShowCtrl
    else
        return Constants.AnimatorPath, partnerCfg.BattleCtrl
    end
end

function PartnerViewSystem:ctor()
    self.partnerRoleMap = {}
    self.partnerRoleEffectMap = {}
    self.curLoadCfgId = nil
    self.curStrengthLv = nil
    self.singleStrengthEffectLoad = false
    self.ownercb = nil
    self.cb = nil
    self.loadSystem = MultiTypeAssetLoadSystem:new()
    self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)
end

function PartnerViewSystem:Dispose()
    self:RecycleAll()
    previewSystem = nil
    self.loadSystem:Dispose()
end

function PartnerViewSystem:GetExistPartnerView(cfgId)
    return self.partnerRoleMap[cfgId]
end

function PartnerViewSystem:RefreshView(partnerInEnvType, cfgId, createdOwner, createdCB, strengthLv)
    -- 角色模型已经生成成功了
    self.partnerInEnvType = partnerInEnvType or Enum.RoleInEnvType.RoleMainView

    local role = self:GetExistPartnerView(cfgId)
    if role == nil then
        self.curLoadCfgId = cfgId
        self.curStrengthLv = strengthLv
        self.ownercb = createdOwner
        self.cb = createdCB
        self:RefreshLoadSystem()
        self:BeginCreate()
    else
        self:CancelCreate()
        if createdOwner and createdCB then
            createdCB(createdOwner, role, (role ~= nil))
        end
        self.ownercb = nil
        self.cb = nil
        self.curLoadCfgId = nil
        self.curStrengthLv = nil
        self.singleStrengthEffectLoad = false
    end
    return role ~= nil
end

function PartnerViewSystem:RefreshStrengthLv(cfgId, strengthLv, owner, cb)
    if self.partnerRoleEffectMap[cfgId] then
        SetGoLayer(self.partnerRoleEffectMap[cfgId], hideLayer)
        local effectName = self.partnerRoleEffectMap[cfgId].name
        local effect = self.partnerRoleEffectMap[cfgId]
        if effect then
            ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, effectName, effect)
        end
        self.partnerRoleEffectMap[cfgId] = nil
    end

    self.singleStrengthEffectLoad = true
    self.curLoadCfgId = cfgId
    self.curStrengthLv = strengthLv

    self.loadSystem:RemoveLoadAllAsset()

    self.ownercb = owner
    self.cb = cb

    -- 特效
    if self.curLoadCfgId then
        self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, Constant.PartnerStrengthEffectPath..self.curStrengthLv)
    end

    self:BeginCreate()
end

function PartnerViewSystem:RefreshLoadSystem()
    self.loadSystem:RemoveLoadAllAsset()
    local assetName = nil
    -- 基本骨骼
    if self.curLoadCfgId then
        local roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(self.curLoadCfgId)
        if roleCfg == nil then
            LogError(self.curLoadCfgId .. "isnt exist in PartnerCfg")
            return
        end
        local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(roleCfg.AvatarId)
        if avatarData == nil then
            LogError(roleCfg.AvatarId .. "isnt exist in AvatarCfg")
            return
        end
        local assetPath, assetName = GetAnimatorControllerPath(roleCfg, self.partnerInEnvType)
        self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, avatarData.AvatarPrefab)
        self.loadSystem:AddLoadAsset(Enum.ResourceType.AnimatorController, assetPath, assetName)
        if self.curStrengthLv and self.curStrengthLv > 0 then
            local lv = self.curStrengthLv
            if self.curStrengthLv >= 6 then
                lv = 6
            end
            self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, Constant.PartnerStrengthEffectPath..lv)
        end
    end
end

---@generic 预加载的资源已加载完成
function PartnerViewSystem:PreloadedAssets()
    self:Create()
end

function PartnerViewSystem:BeginCreate()
    self.loadSystem:Begin()
end

function PartnerViewSystem:CancelCreate()
    if self.curLoadCfgId == nil then return end

    self.loadSystem:Cancel()
    self.curLoadCfgId = nil
end

function PartnerViewSystem:RecycleAll()
    for k,v in pairs(self.partnerRoleMap) do
        self:Recycle(k)
    end
    self.partnerRoleMap = {}
end

function PartnerViewSystem:Recycle(cfgId)
    self:CancelCreate()

    if self.partnerRoleMap[cfgId] then
        local animator = self.partnerRoleMap[cfgId]:GetComponent(Enum.TypeInfo.Animator)
        animator.runtimeAnimatorController = nil
        local roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(cfgId)
        local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(roleCfg.AvatarId)
        ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, avatarData.AvatarPrefab, self.partnerRoleMap[cfgId])

        if self.partnerRoleEffectMap[cfgId] then
            local effectName = self.partnerRoleEffectMap[cfgId].name
            local effect = self.partnerRoleEffectMap[cfgId]
            if effect then
                ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, effectName, effect)
            end
            self.partnerRoleEffectMap[cfgId] = nil
        end
        self.partnerRoleMap[cfgId] = nil
    end
    self.ownercb = nil
    self.cb = nil
    self.curStrengthLv = nil
    self.singleStrengthEffectLoad = false
end

-- 需要预先加载好了资源
function PartnerViewSystem:Create()
    if not self.singleStrengthEffectLoad then
        local assetName = nil
        local go = nil
        -- 基本骨骼
        if self.curLoadCfgId then
            local roleCfg = ManagerContainer.CfgMgr:GetPartnerDataById(self.curLoadCfgId)
            if roleCfg == nil then
                LogError(self.curLoadCfgId .. "isnt exist in PartnerCfg")
                return
            end
            local avatarData = ManagerContainer.CfgMgr:GetAvatarCfgById(roleCfg.AvatarId)
            if avatarData == nil then
                LogError(roleCfg.AvatarId .. "isnt exist in AvatarCfg")
                return
            end
            go = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, avatarData.AvatarPrefab)

            if go then
                self.partnerRoleMap[self.curLoadCfgId] = go
                if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
                    go.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
                else
                    go.transform.parent = nil
                end
                go.transform.position = Vector3.zero;
                go.transform.rotation = Quaternion.identity;
                go:SetActive(true)

                local assetPath, assetName = GetAnimatorControllerPath(roleCfg, self.partnerInEnvType)
                local animatorController = ManagerContainer.ResMgr:GetAsset(assetPath, assetName)
                local animator = go:GetComponent(Enum.TypeInfo.Animator)
                if not animator then
                    animator = go:AddComponent(Enum.TypeInfo.Animator)
                end
                animator.runtimeAnimatorController = animatorController

                if self.curStrengthLv and self.curStrengthLv > 0 then
                    local lv = self.curStrengthLv
                    if self.curStrengthLv >= #Constant.Quality_HeadFrame_Icons then
                        lv = #Constant.Quality_HeadFrame_Icons
                    end
                    local effectName = Constant.PartnerStrengthEffectPath..lv
                    local foot = go.transform:Find("Foot_Point")
                    local effect = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, effectName)
                    if effect then
                        effect.name = effectName
                        effect.transform:SetParent(foot)
                        effect.transform.localPosition = Vector3.zero
                        effect.transform.localScale = Vector3.one

                        self.partnerRoleEffectMap[self.curLoadCfgId] = effect
                    end
                end
            end
        end

        self.curLoadCfgId = nil

        if self.ownercb and self.cb then
            self.cb(self.ownercb, go, (go ~= nil))
        end
        self.ownercb = nil
        self.cb = nil
        return go
    else
        local go = self.partnerRoleMap[self.curLoadCfgId]
        if self.curStrengthLv and self.curStrengthLv > 0 then
            local lv = self.curStrengthLv
            if self.curStrengthLv >= #Constant.Quality_HeadFrame_Icons then
                lv = #Constant.Quality_HeadFrame_Icons
            end
            local effectName = Constant.PartnerStrengthEffectPath..lv
            local foot = go.transform:Find("Foot_Point")
            local effect = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, effectName)
            if effect then
                effect.name = effectName
                effect.transform:SetParent(foot)
                effect.transform.localPosition = Vector3.zero
                effect.transform.localScale = Vector3.one

                self.partnerRoleEffectMap[self.curLoadCfgId] = effect
            end
            --SetGoLayer(effect, previewLayer)
        end

        self.singleStrengthEffectLoad = false
        if self.ownercb and self.cb then
            local effect = self.partnerRoleEffectMap[self.curLoadCfgId]
            self.cb(self.ownercb, effect, (effect ~= nil))
        end

        self.curLoadCfgId = nil
        self.ownercb = nil
        self.cb = nil
    end
end

function PartnerViewSystem:HasGameObjects()
    return next(self.partnerRoleMap)
end

function PartnerViewSystem:GetGameObject(cfgId)
    return self.partnerRoleMap[cfgId]
end

function PartnerViewSystem:GetRoleEffect(cfgId)
    return self.partnerRoleEffectMap[cfgId]
end

function PartnerViewSystem:RolePlayAni(go, aniName)
    if go == nil then return end
    local animator = go:GetComponent(Enum.TypeInfo.Animator)
    if animator == nil then return end
    animator:Play(aniName)
end

return PartnerViewSystem