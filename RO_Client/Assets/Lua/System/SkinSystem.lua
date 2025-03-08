--[[
    所有的skinDatas, extSkinDatas格式如下
    skinDatas =
    {
        [Enum.SkinSlotType.HeadTop] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.HeadMiddle] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.HeadBottom] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.Cloth] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.LeftHand] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.RightHand] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.BodyBack] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.HairStyle] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.Pupil] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3, customBindBone = String},
        [Enum.SkinSlotType.HairColor] = {hasValue = boolean, uvOffset = Vector2},
        [Enum.SkinSlotType.Face] = {hasValue = boolean, prefabGo = GameObject, pos = Vector3, rot = Quaternion, scale = Vector3},
    }
    hasValue 为 是否位置上设置了值，false则表示该位置上未放置东西
    prefabGo 为 prefab资源
    pos 为挂载点的相对坐标
    rot 为挂载点的相对旋转
    scale 为挂载点的相对缩放
    customBindBone 为自定义绑定骨骼，可为nil, 不为nil是会覆盖默认绑定骨骼节点

    有的skins, extSkins格式如下
    skins =
    {
        [Enum.SkinSlotType.HeadTop] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.HeadMiddle] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.HeadBottom] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.Cloth] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.LeftHand] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.RightHand] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.BodyBack] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.HairStyle] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.Pupil] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
        [Enum.SkinSlotType.HairColor] = {[HairColor] = Vector2},
        [Enum.SkinSlotType.Face] = {rendererInfos = {{renderer = Renderer, shareMaterials = Array(Materials)}}, materialMap = {[instanceId] = Material}},
    }
    rendererInfos 为 该位置上所有的渲染Renderer信息
    shareMaterials 为 该位置上渲染Renderer的默认材质球
    materialMap 为 该位置上所有的渲染Renderer改变的材质信息
]]


local SkinSystem = class("SkinSystem")
local Object = UnityEngine.Object
local Material = UnityEngine.Material
local Renderer = UnityEngine.Renderer
local SkinnedMeshRenderer = UnityEngine.SkinnedMeshRenderer
-- local MeshRenderer = UnityEngine.MeshRenderer

local RendererType = typeof(Renderer)
local SkinnedMeshRendererType = typeof(SkinnedMeshRenderer)
-- local MeshRendererType = typeof(MeshRenderer)


local GetMatUVOffset = function(material)
    return material.mainTextureOffset
end

local SetMatUVOffset = function(material, uvOffset)
    material.mainTextureOffset = uvOffset
end

-- local GetMatAlpha = function(material)
--     local color = material.color
--     return color.a
-- end

-- local SetMatAlpha = function(material, alpha)
--     local color = material.color
--     color.alpha = alpha
--     material.color = color
-- end





function SkinSystem:ctor()
    self.rootTrans = nil
    self.boneMap = {}
    self.skins = {}
    self.extSkins = {}
end

function SkinSystem:Dispose()
    self:Clear()
    self.rootTrans = nil
    self.boneMap = nil
    self.skins = nil
    self.extSkins = nil
end

function SkinSystem:Clear()
    for skinSlot,_ in pairs(self.skins) do
        self:_RemoveSkin(skinSlot, self.skins)
    end
    for skinSlot,_ in pairs(self.extSkins) do
        self:_RemoveSkin(skinSlot, self.extSkins)
    end
    for key,_ in pairs(self.boneMap) do
        self.boneMap[key] = nil
    end
    self.rootTrans = nil
end

function SkinSystem:Init(ownerTrans, skinDatas, extSkinDatas, isCombine)
    assert(ownerTrans, "ownerTrans is nil")
    self:Clear()
    self.rootTrans = ownerTrans
    self:_BuildBoneMap()
    self:SetSkins(skinDatas, extSkinDatas, isCombine)
end

function SkinSystem:SetBaseBone(ownerTrans)
    assert(ownerTrans, "ownerTrans is nil")
    if self.rootTrans == ownerTrans then return end
    self.rootTrans = ownerTrans
    self:_BuildBoneMap()
    self:_RebineSkins()
end

function SkinSystem:SetSkins(skinDatas, extSkinDatas, isCombine)
    local changed = false
    local skins = self.skins
    local extSkins = self.extSkins
    local skinData, hasValue
    for _, skinSlotType in pairs(Enum.SkinSlotType) do
        if skinDatas then
            skinData = skinDatas[skinSlotType]
            if skinData then
                hasValue = skinData.hasValue
                if hasValue then
                    changed = self:_AddSkin(skinSlotType, skinData, skins) or changed
                else
                    changed = self:_RemoveSkin(skinSlotType, skins) or changed
                end
            end
        end
        if extSkinDatas then
            skinData = extSkinDatas[skinSlotType]
            if skinData then
                hasValue = skinData.hasValue
                if hasValue then
                    changed = self:_SetSkinActive(skinSlotType, false) or changed
                    changed = self:_AddSkin(skinSlotType, skinData, extSkins) or changed
                else
                    changed = self:_SetSkinActive(skinSlotType, true) or changed
                    changed = self:_RemoveSkin(skinSlotType, extSkins) or changed
                end
            end
        end
    end
    if changed and isCombine then self:_CombineSkin() end
end

function SkinSystem:_AddSkin(skinSlotType, skinInfo, skins)
    local changed = false
    if skinSlotType == Enum.SkinSlotType.HairColor then
        local uvOffset = skinInfo.uvOffset
        -- 改变头发材质的颜色值
        skins[skinSlotType] = { uvOffset = uvOffset }
        -- 如果头发模型在，需要修改材质
        local hairData = skins[Enum.SkinSlotType.Hair]
        if hairData then
            -- 修改头发颜色
            changed =  self:_ChangeHairColor(hairData, uvOffset) or changed
        end
    else
        -- 删除当前位置上已有的表现
        changed = self:_RemoveSkin(skinSlotType, skins) or changed
        if not skinInfo then return changed end
        -- 预制体的改变
        local rendererInfos = self:_AddPrefab(skinSlotType, skinInfo)
        if not rendererInfos or #rendererInfos <= 0 then
            return changed
        end
        changed = true
        local data = { rendererInfos = rendererInfos }
        if skinSlotType == Enum.SkinSlotType.Hair then
            local hairColorData = skins[Enum.SkinSlotType.HairColor]
            if hairColorData and hairColorData.uvOffset then
                -- 修改头发颜色
                local uvOffset = hairColorData.uvOffset
                changed = self:_ChangeHairColor(data, uvOffset) or changed
            end
        end
        skins[skinSlotType] = data
    end
    return changed
end

function SkinSystem:_RemoveSkin(skinSlotType, skins)
    local changed = false
    if skinSlotType == Enum.SkinSlotType.HairColor then
        -- 删除头发材质的颜色值
        -- 头发模型在，需要恢复默认材质
        local hairData = skins[Enum.SkinSlotType.Hair]
        if hairData then
            -- 恢复默认头发颜色
            changed = self:_ChangeHairColor(hairData, nil) or changed
        end
    else
        -- 改变表现
        local skinInfo = skins[skinSlotType]
        if skinInfo then
            self:_ClearChangeMaterial(skinInfo)
            local rendererInfos = skinInfo.rendererInfos
            if rendererInfos then
                for i = #rendererInfos, 1, -1 do
                    local rendererInfo = rendererInfos[i]
                    if rendererInfo and not tolua.isnull(rendererInfo.renderer) and not tolua.isnull(rendererInfo.renderer.gameObject) then
                        -- TODO: 由于Destroy并不是立即删除，所以Animator中的BlendShape动画重定向时还会被定位到，导致动画表现错误
                        --       所以把当前对象移除Animator可索引区域
                        rendererInfo.renderer.transform:SetParent(nil)
                        Object.Destroy(rendererInfo.renderer.gameObject)
                    end
                    rendererInfo.sharedMaterials = nil
                    rendererInfos[i].renderer = nil
                    rendererInfos[i] = nil
                end
            end
            skinInfo.color = nil
            skinInfo.rendererInfos = nil
        end
    end
    skins[skinSlotType] = nil
    return changed
end

function SkinSystem:_SetSkinActive(skinSlotType, active)
    local changed = false
    if skinSlotType ~= Enum.SkinSlotType.HairColor then
        -- 改变表现
        local skinInfo = self.skins[skinSlotType]
        if skinInfo then
            local rendererInfos = skinInfo.rendererInfos
            if rendererInfos then
                for i = #rendererInfos, 1, -1 do
                    local rendererInfo = rendererInfos[i]
                    if rendererInfo and not tolua.isnull(rendererInfo.renderer) then
                        local activeSelf = rendererInfo.renderer.gameObject.activeSelf
                        if activeSelf ~= active then
                            rendererInfo.renderer.gameObject:SetActive(active)
                            changed = true
                        end
                    end
                end
            end
        end
    end
    return changed
end

function SkinSystem:_ChangeHairColor(hairData, uvOffset)
    return self:_ChangeMaterial(hairData, 'HairColor', uvOffset, SetMatUVOffset, GetMatUVOffset)
end

function SkinSystem:_ClearChangeMaterial(data)
    data.changes = nil
    self:_ResetMaterial(data)
end

function SkinSystem:_ChangeMaterial(data, key, value, changeFun, getDefaultValFun)
    local status = self:_SetChangeDataValue(data, key, value)
    -- 和当前值一致，不需要做修改
    if status == 0 then
        return false
    end
    -- 所有修改都取消了，重置材质球到默认材质球
    if status == 2 then
        return self:_ResetMaterial(data)
    end

    local rendererInfos = data.rendererInfos
    local materialMap = data.materialMap
    if materialMap == nil then
        materialMap = {}
        data.materialMap = materialMap
        -- 统计出需要改变的材质球
        for i = 1, #rendererInfos do
            local rendererInfo = rendererInfos[i]
            local sharedMaterials = rendererInfo.sharedMaterials
            local length = sharedMaterials.Length
            local newMaterials = System.Array.CreateInstance(typeof(Material), length)
            for j = 0, length - 1 do
                local sharedMaterial = sharedMaterials[j]
                if sharedMaterial then
                    local instanceId = sharedMaterial:GetInstanceID()
                    if materialMap[instanceId] then
                        newMaterials[j] = materialMap[instanceId][1]
                    else
                        -- 创建新材质球，并修改值
                        local newMaterial = Material(sharedMaterial)
                        materialMap[instanceId] = { newMaterial, sharedMaterial }
                        newMaterials[j] = newMaterial
                        if status == 3 then -- 修改材质球到这个值
                            changeFun(newMaterial, value)
                        end
                    end
                end
            end
            rendererInfo.renderer.sharedMaterials = newMaterials
        end
    else
        for _, materials in pairs(materialMap) do
            if status == 1 then -- 当修改需要重置回默认值
                local defaultValue = getDefaultValFun(materials[2])
                changeFun(materials[1], defaultValue)
            elseif status == 3 then -- 修改材质球到这个值
                changeFun(materials[1], value)
            end
        end
    end
    return true
end

--- 还原被修改的材质球
function SkinSystem:_ResetMaterial(data)
    local rendererInfos = data.rendererInfos
    local materialMap = data.materialMap
    -- 没有改变过材质球，不需要修改
    if not materialMap then return false end
    -- 还原默认材质
    for i = 1, #rendererInfos do
        local rendererInfo = rendererInfos[i]
        if not tolua.isnull(rendererInfo.renderer) then
            rendererInfo.renderer.sharedMaterials = rendererInfo.sharedMaterials
        end
    end
    -- 删除变化的材质球
    for instanceId, material in pairs(materialMap) do
        if not tolua.isnull(material) then
            Object.Destroy(material)
        end
        materialMap[instanceId] = nil
    end
    data.materialMap = nil
    return true
end

--- 设置变化值
---@return integer 0：和当前值一致；1：Key的变化重置回默认值；2：所有变化都重置回默认值；3：更新key的变化
function SkinSystem:_SetChangeDataValue(data, key, value)
    local changes = data.changes
    if changes == nil then
        if not value then
            return 0
        end
        changes = {}
        data.changes = changes
    end
    local oldValue = changes[key]
    if oldValue == value then
        return 0
    end
    if not value then
        changes[key] = nil
        local isChanged = CommonUtil.TableIsEmpty(changes)
        if isChanged then
            return 1
        else
            data.changes = nil
            return 2
        end
    end
    changes[key] = value
    return 3
end

function SkinSystem:_AddPrefab(skinSlotType, slotContent)
    local prefabGo = slotContent.prefabGo
    if tolua.isnull(prefabGo) then return nil end
    local pos = slotContent.pos
    local rot = slotContent.rot
    local scale = slotContent.scale
    local customBindBone = slotContent.customBindBone

    -- 后续需要加上不同部位只能有一种类型Renderer的判断
    -- if skinSlotType == Enum.SkinSlotType.HeadTop
    --     or skinSlotType == Enum.SkinSlotType.HeadMiddle
    --     or skinSlotType == Enum.SkinSlotType.HeadBottom
    --     or skinSlotType == Enum.SkinSlotType.Weapon
    --     or skinSlotType == Enum.SkinSlotType.BodyBack then
    -- else

    -- end
    local prefabTrans = prefabGo.transform
    local go = Object.Instantiate(prefabGo)
    go.name = prefabGo.name
    local trans = go.transform
    local boneTrans = self:_SetBindBone(prefabTrans, trans, skinSlotType, pos, rot, scale, customBindBone)
    local renderers = go:GetComponentsInChildren(RendererType)
    local length = renderers.Length
    local rendererInfos = nil
    local needDestroy = true
    if length > 0 then
        local layer = self.rootTrans.gameObject.layer
        rendererInfos = {}
        for i = 0, length - 1 do
            local renderer = renderers[i]
            renderer.gameObject.layer = layer
            local rendererTrans = renderer.transform
            if rendererTrans == trans then
                needDestroy = false
            end
            local classType = renderer:GetType()
            if classType == SkinnedMeshRendererType then
                self:_SMRRebindBone(renderer)
                rendererTrans.parent = self.rootTrans
            else
                rendererTrans.parent = boneTrans
            end
            local rendererInfo = { renderer = renderer, sharedMaterials = renderer.sharedMaterials}
            rendererInfos[#rendererInfos + 1] = rendererInfo
        end
    end
    if needDestroy then
        trans.parent = nil
        Object.Destroy(go)
    end
    return rendererInfos
end

function SkinSystem:_SetBindBone(srcTrans, trans, skinSlotType, pos, rot, scale, customBindBone)
    local boneTrans = nil

    if customBindBone and customBindBone ~= '' and self.boneMap[customBindBone] then
        boneTrans = self.boneMap[customBindBone]
    end
    if tolua.isnull(boneTrans) then
        local parentName = Enum.SkinSlotBindBone[skinSlotType]
        boneTrans = self.boneMap[parentName]
    end
    if tolua.isnull(boneTrans) then
        local parentTrans = srcTrans.parent
        if parentTrans then
            boneTrans = self.boneMap[parentTrans.name]
        end
    end
    if tolua.isnull(boneTrans) then
        boneTrans = self.rootTrans
    end
    trans.parent = boneTrans
    trans.localPosition = pos or srcTrans.localPosition
    trans.localRotation = rot or srcTrans.localRotation
    trans.localScale = scale or srcTrans.localScale
    return boneTrans
end

function SkinSystem:_RebineSkin(slotInfo)
    if not slotInfo then return end
    local rendererInfos = slotInfo.rendererInfos
    if not rendererInfos then return end
    for i = 1, #rendererInfos do
        local renderer = rendererInfos[i].renderer
        local rendererTrans = renderer.transform
        local classType = renderer:GetType()
        if classType  == typeof(SkinnedMeshRenderer) then
            self:_SMRRebindBone(renderer)
            rendererTrans.parent = self.rootTrans
            rendererTrans.localPosition = Vector3.zero
            rendererTrans.localRotation = Quaternion.identity
            rendererTrans.localScale = Vector3.one
        else
            local localPosition = rendererTrans.localPosition
            local localRotation = rendererTrans.localRotation
            local localScale = rendererTrans.localScale
            local parentTrans = rendererTrans.parent
            local parentName = parentTrans and parentTrans.name or ""
            local boneTrans = self.boneMap[parentName]
            rendererTrans.parent = boneTrans or self.rootTrans
            rendererTrans.localPosition = localPosition
            rendererTrans.localRotation = localRotation
            rendererTrans.localScale = localScale
        end
    end
end

--- 基本骨骼发生变化后，需要重新绑定表现
function SkinSystem:_RebineSkins()
    local skins = self.skins
    local extSkins = self.extSkins
    for _, skinSlotType in pairs(Enum.SkinSlotType) do
        if skinSlotType == Enum.SkinSlotType.HairColor then
            -- 骨骼发生变化，对材质球是无影响的
        else
            if skins then
                self:_RebineSkin(skins[skinSlotType])
            end
            if extSkins then
                self:_RebineSkin(extSkins[skinSlotType])
            end
        end
    end
end

-- 重定向SkinnedMeshRenderer的骨骼绑定
function SkinSystem:_SMRRebindBone(smr)
    local rootBone = smr.rootBone
    local name = rootBone.name
    if self.boneMap[name] then
        smr.rootBone = self.boneMap[name]
    else
        -- 暂时未做骨骼新增，看未来需求
        smr.rootBone = nil
        LogError(smr.gameObject.name .. "'s rootBone : ".. tostring(name) .. " is not find, Check It!!!!!!")
    end
    local bones = smr.bones
    for i = 0, bones.Length - 1 do
        name = bones[i].name
        if self.boneMap[name] then
            bones[i] = self.boneMap[name]
        else
            -- 暂时未做骨骼新增，看未来需求
            LogError(smr.gameObject.name .. "'s Bone : ".. tostring(name) .. " is not find, Check It!!!!!!")
        end
    end
    smr.bones = bones
end

-- 构建骨骼Map，方便后续骨骼查找
function SkinSystem:_BuildBoneMap()
    if not self.rootTrans then
        LogError("BaseModel is Null, not generate Bone Map")
        return self.boneMap
    end
    local rootBone = self.rootTrans:Find("Bip001")
    if not rootBone then
        LogError("BaseModel is not find \"Bip001\", not generate Bone Map")
        return self.boneMap
    end
    self:_GenerateBoneMap(rootBone)
end

function SkinSystem:_GenerateBoneMap(transform)
    if not transform then return end
    local name = transform.name
    if self.boneMap[name] then
        LogError("Has Some Name Bone" .. name .. ", Check It!!!!!!")
    end
    self.boneMap[name] = transform
    for i = 0, transform.childCount - 1 do
        self:_GenerateBoneMap(transform:GetChild(i))
    end
end


function SkinSystem:_CombineSkin()
end


return SkinSystem