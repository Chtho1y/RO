
local ViewSystem = class("ViewSystem")
local Object = UnityEngine.Object
local GameObject = UnityEngine.GameObject
local UnityEngineUtils = UnityEngine.UnityEngineUtils

local CfgMgr = ManagerContainer.CfgMgr

local function CalcQiyuePoses(count, radius)
    if count == 1 then
        return {{radius, 0, 0}}
    elseif count == 2 then
        return {{radius, 0, 0}, {-radius, 0, 0}}
    elseif count == 3 then
        return {{radius, 0, 0}, {-radius/1.414, 0, radius/1.414}, {-radius/1.414, 0, -radius/1.414}}
    elseif count == 4 then
        return {{radius, 0, 0}, {0, 0, radius}, {-radius, 0, 0}, {0, 0, -radius}}
    end
end

function ViewSystem:ctor()
    self.extGoesMap = {}
end

function ViewSystem:Dispose()
    self:Clear()
    self.extGoesMap = nil
    self.qiyueOffset = nil
end

function ViewSystem:Clear()
    for heroExtGoesShow,data in pairs(self.extGoesMap) do
        if heroExtGoesShow == Enum.HeroExtGoesShowType.God_Art then
            local go = data.prefabGo
            if go then
                go:DestroyComponent(typeof(AroundSphereMove))
            end
            ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, data.prefabPath, data.prefabGo)
        elseif heroExtGoesShow == Enum.HeroExtGoesShowType.Pet_Qiyue then
            local datas = self.extGoesMap[heroExtGoesShow]
            for i = 1, #datas do
                local go = datas[i].prefabGo
                if go then 
                    local qiyuePoint = go.transform:Find("Qiyue_Point/Qiyue_Point1")
                    if not tolua.isnull(qiyuePoint) then
                        qiyuePoint.gameObject:DestroyComponent(typeof(AroundSphereMove))
                    end
                end
                ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, datas[i].prefabPath, datas[i].prefabGo)
            end
        else
            ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, data.prefabPath, data.prefabGo)
        end
    end
end

function ViewSystem:UpdateGodArt(heroExtGoesShow, parent, oldShowData, cfgId)
    local oldCfgId = oldShowData[heroExtGoesShow]
    if oldCfgId ~= cfgId then
        if self.extGoesMap[heroExtGoesShow] then
            local data = self.extGoesMap[heroExtGoesShow]
            local go = data.prefabGo
            if go then
                go:DestroyComponent(typeof(AroundSphereMove))
            end
            ManagerContainer.ResMgr:RecycleGO(Constants.ModelPath, data.prefabPath, data.prefabGo)
            self.extGoesMap[heroExtGoesShow] = nil
        end
    else
        return
    end

    local cfgData = CfgMgr:GetArtifactCfgDataByCfgId(cfgId)
    if cfgData then
        local avatarPrefab = cfgData.AvatarPrefab
        if avatarPrefab and avatarPrefab ~= '' then
            local godArtGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, avatarPrefab)
            if not tolua.isnull(parent) and not tolua.isnull(godArtGo) then
               local point = UnityEngineUtils.RecurisiveFindTransformChild(parent, "Bip001 Spine")
               if not tolua.isnull(point) then
                    local around = godArtGo:GetComponent(typeof(AroundSphereMove))
                    if not around then
                        around = godArtGo:AddComponent(typeof(AroundSphereMove))
                    end
                    around.moveRadius = tonumber(cfgData.MoveRadius) or 0.5
                    around.moveAngleSpeed = tonumber(cfgData.MoveAngleSpeed) or 3
                    around.shakeDir = cfgData.ShakeDir and Vector3(cfgData.ShakeDir[1], cfgData.ShakeDir[2], cfgData.ShakeDir[3]) or Vector3(0,0,1)
                    around.shakeSpeed = tonumber(cfgData.ShakeSpeed) or 1
                    around.selfRotateSpeed = tonumber(cfgData.SelfRotateSpeed) or 2

                    around.OffsetAngle = CommonUtil.TableToQuaternion(cfgData.OffsetAngle)
                    around.Scale = tonumber(cfgData.Scale) or 1
                    around.OffsetHeight = tonumber(cfgData.OffsetHeight) or 0

                    godArtGo.transform:SetParent(point)
                    godArtGo.transform.localPosition = Vector3.zero
                    godArtGo.transform.localScale = Vector3.one

                    self.extGoesMap[heroExtGoesShow] = {prefabGo = godArtGo, prefabPath = avatarPrefab}
               end
            end
        end
    end
    oldShowData[heroExtGoesShow] = cfgId
end

function ViewSystem:UpdateStrengthHalo(heroExtGoesShow, parent, oldShowData, val)
    local oldVal = oldShowData[heroExtGoesShow]
    if oldVal ~= val then
        if self.extGoesMap[heroExtGoesShow] then
            local data = self.extGoesMap[heroExtGoesShow]
            ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, data.prefabPath, data.prefabGo)
            self.extGoesMap[heroExtGoesShow] = nil
        end
    else
        return
    end

    local lv = val
    if val >= #Constant.PartnerStrengthEffectPath then
        lv = #Constant.PartnerStrengthEffectPath
    end
    local effectName = Constant.PartnerStrengthEffectPath[lv]
    local effect = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, effectName)
    if not tolua.isnull(parent) and not tolua.isnull(effect) then
        local point = parent:Find("Foot_Point")
        if not tolua.isnull(point) then
            effect.transform:SetParent(point)
            effect.transform.localPosition = Vector3.zero
            effect.transform.localScale = Vector3.one
           
            self.extGoesMap[heroExtGoesShow] = {prefabGo = effect, prefabPath = effectName}
        end
     end
     oldShowData[heroExtGoesShow] = val
end

function ViewSystem:UpdatePetQiyueShow(heroExtGoesShow, parent, oldShowData, val)
    local oldVal = oldShowData[heroExtGoesShow]
    if oldVal then
        if oldVal.sumNum ~= val.sumNum then
            if self.extGoesMap[heroExtGoesShow] then
                local datas = self.extGoesMap[heroExtGoesShow]
                for i = 1, #datas do
                    ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, datas[i].prefabPath, datas[i].prefabGo)
                end
                self.extGoesMap[heroExtGoesShow] = nil
            end
        else
            return
        end
    end

    local cfgData = CfgMgr:GetPetDataById(val.battlePetId)
    if cfgData and val.cfgIds and #val.cfgIds > 0 then
        local radius = 1
        self.qiyueOffset = CalcQiyuePoses(val.count, radius)
        self.extGoesMap[heroExtGoesShow] = {}
        local offsetPos = cfgData.OffsetPos and Vector3(cfgData.OffsetPos[1], cfgData.OffsetPos[2], cfgData.OffsetPos[2]) or Vector3.zero
        local qiyuePoint1
        if val.count > 0 then
            if not tolua.isnull(parent) then
                local qiyuePoint = parent:Find("Qiyue_Point")
                if tolua.isnull(qiyuePoint) then
                    qiyuePoint = GameObject("Qiyue_Point")
                    qiyuePoint.transform:SetParent(parent)
                    qiyuePoint.transform.localScale = Vector3.one
                    qiyuePoint = qiyuePoint.transform
                end

                qiyuePoint.localPosition = cfgData.OffsetPos and Vector3(cfgData.OffsetPos[1], cfgData.OffsetPos[2], cfgData.OffsetPos[3]) or Vector3.zero
                qiyuePoint1 = qiyuePoint:Find("Qiyue_Point1")
                if tolua.isnull(qiyuePoint1) then
                    qiyuePoint1 = GameObject("Qiyue_Point1")
                    qiyuePoint1.transform:SetParent(qiyuePoint)
                    qiyuePoint1.transform.localScale = Vector3.one
                    qiyuePoint1.transform.localPosition = Vector3.zero
                    qiyuePoint1 = qiyuePoint1.transform
                end

                local around = qiyuePoint1.gameObject:GetComponent(typeof(AroundSphereMove))
                if not around then
                    around = qiyuePoint1.gameObject:AddComponent(typeof(AroundSphereMove))
                end
                around.moveRadius = 0
                around.moveAngleSpeed = 0
                around.shakeDir = Vector3.zero
                around.shakeSpeed = 0
                around.selfRotateSpeed = tonumber(cfgData.SelfRotateSpeed) or 2

                around.Scale = tonumber(cfgData.Scale) or 1
                around.OffsetHeight = 0
            end
        end
        for i = 1, #val.cfgIds do
            local cfgId = val.cfgIds[i]
            local petCfgData = CfgMgr:GetPetDataById(cfgId)
            if petCfgData then
                local natureData = CfgMgr:GetNatureDataById(petCfgData.NatureType)
                if natureData then
                    local avatarPrefab = natureData.PetContract
                    if avatarPrefab and avatarPrefab ~= '' then
                        local qiyueGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, avatarPrefab)
                        if not tolua.isnull(qiyuePoint1) and not tolua.isnull(qiyueGo) then
                            qiyueGo.transform:SetParent(qiyuePoint1)
                            if self.qiyueOffset and self.qiyueOffset[i] then
                                qiyueGo.transform.localPosition = Vector3(self.qiyueOffset[i][1], self.qiyueOffset[i][2], self.qiyueOffset[i][3])
                            else
                                qiyueGo.transform.localPosition = Vector3.zero
                            end
                            qiyueGo.transform.localScale = Vector3.one

                            self.extGoesMap[heroExtGoesShow][#self.extGoesMap[heroExtGoesShow] + 1] = {prefabGo = qiyueGo, prefabPath = avatarPrefab}
                        end
                    end
                end
            end
        end
    end
    oldShowData[heroExtGoesShow] = val
end

function ViewSystem:UpdateView(parent, oldShowData, updateView)
    if updateView then
        for heroExtGoesShow,val in pairs(updateView) do
            if val then
                if heroExtGoesShow == Enum.HeroExtGoesShowType.God_Art then
                   self:UpdateGodArt(heroExtGoesShow, parent, oldShowData, val)
                elseif heroExtGoesShow == Enum.HeroExtGoesShowType.Strength_Halo then
                    if val < 100 then
                        self:UpdateStrengthHalo(heroExtGoesShow, parent, oldShowData, val)
                    end
                elseif heroExtGoesShow == Enum.HeroExtGoesShowType.Pet_Qiyue then
                    self:UpdatePetQiyueShow(heroExtGoesShow, parent, oldShowData, val)
                end
            end
        end
    end
end

return ViewSystem