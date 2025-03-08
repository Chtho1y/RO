local LuaToCSData = {}

function LuaToCSData.ConvertRoleDataToActorParam(roleData)
    local param = ActorParam.New()
    param.uid = roleData.uid
    param.baseId = roleData.id
    param.jobId = roleData.jobId or 0
    param.level = roleData.lv
    param.isMainRole = roleData.mainRole
    param.isRole = roleData.role
    param.strengthLevel = roleData.strengthLevel or 0
    
    if roleData.skills ~= nil then
        param.skills = System.Array.CreateInstance(Enum.TypeInfo.SkillParam, #roleData.skills)
        for i = 1, #roleData.skills do
            param.skills[i-1] = LuaToCSData.CreateSkillParamData(roleData.skills[i])
        end
    end

    if roleData.buffs ~= nil then
         param.buffs = System.Array.CreateInstance(Enum.TypeInfo.BuffParam, #roleData.buffs)
         for i =1, #roleData.buffs do
             param.buffs[i -1] = LuaToCSData.CreateBuffParamData(roleData.buffs[i])
         end
        --- buff 规则修改，如果后续无问题，上述注释可删除
        --local buffParamLs = ActorData.ParseBuffParam(roleData.buffs)
        --if buffParamLs then
        --    param.buffs = buffParamLs:ToArray()
        --end
    end

    param.fashion = roleData.fashion == nil and nil or LuaToCSData.CreateFashionParamData(param.baseId, param.jobId, roleData.fashion)
    return param
end


--- 创建 ActorParam 对象
---@param heroData table
---@param userData table
---@param skillData Class(SkillData)
---@param buffs table
---@param fashionData table
---@return ActorParam
function LuaToCSData.CreateActorParamData(heroData, skillData, buffs, userData, fashionData)
    local param = ActorParam.New()
    param.uid = heroData.id
    param.baseId = (userData == nil or userData.roleCfgId == nil)and 0 or userData.roleCfgId
    param.jobId = heroData.configId or 0
    param.level = heroData.baseLevel
    param.headFrameId = heroData.headFrame or 0
    param.isMainRole = heroData.isMainRole
    param.isRole = heroData.isRole
    if param.isMainRole or param.isRole then
        param.strengthLevel = 7
    else
        param.strengthLevel = heroData.strengthLevel or 0
    end

    if param.baseId == 0 then
        param.baseId = param.jobId
    end

    local skills = skillData:GetUsedSkills()
    CommonUtil.ReplaceBattleSkillBySkillEquip(heroData, skills)
    param.skills = System.Array.CreateInstance(Enum.TypeInfo.SkillParam, #skills)
    local idx = 0
    for _,v in pairs(skills) do
        param.skills[idx] = LuaToCSData.CreateSkillParamData(v)
        idx = idx + 1
    end

    -- param.buffs = System.Array.CreateInstance(Enum.TypeInfo.BuffParam, #buffs)
    -- idx = 0
    -- for _,v in pairs(buffs) do
    --     param.buffs[idx] = LuaToCSData.CreateBuffParamData(v)
    --     idx = idx + 1
    -- end
    if buffs then
        local buffParamLs = ActorData.ParseBuffParam(buffs)
        if buffParamLs then
            param.buffs = buffParamLs:ToArray()
        end
    end

    if userData ~= nil and fashionData ~= nil then
        param.fashion = LuaToCSData.CreateFashionParamData(param.baseId, param.jobId, fashionData)
    end

    param.petId = heroData.battlePetId > 0 and heroData.battlePetId + Enum.ActorUidField.Pet or 0
    return param
end

function LuaToCSData.CreatePetActorParamData(petData)
    local param = ActorParam.New()
    param.uid = petData.id > 0 and petData.id + Enum.ActorUidField.Pet or 0
    param.baseId = petData.cfgId
    param.level = petData.level

    param.skills = System.Array.CreateInstance(Enum.TypeInfo.SkillParam, #petData.skillList)
    local idx = 0
    for _,v in pairs(petData.skillList) do
        local data = { skillId = v.cfgId, lv = v.level, rate = v.rate}
        param.skills[idx] = LuaToCSData.CreateSkillParamData(data)
        idx = idx + 1
    end

    return param
end

--- 创建 SkillParam 对象
---@param data table
---@return SkillParam
function LuaToCSData.CreateSkillParamData(data)
    if data == nil or next(data) == nil then return nil end

    local rate = data.rate or 100
    return SkillParam.New(data.skillId, data.lv, rate)
end

--- 创建 BuffParam 对象
---@param data table
---@return BuffParam
function LuaToCSData.CreateBuffParamData(data)
    if data == nil or next(data) == nil then return nil end
    return BuffParam.New(data[1], data[2], data[3], data[4])
end

--- 创建 FashionParam 对象
---@param data table
---@return FashionParam
function LuaToCSData.CreateFashionParamData(roleCfgId, jobId, data)
    if data == nil or next(data) == nil then return nil end

    local hairColorParam = LuaToCSData.CreateHairColorParamData(data.hairColor)
    local bodies = {}

    --- 找是否有互斥的数据 （目前是头发）
    local isHideHair = false
    local headTopFashionId = data.fashionData[Enum.FashionSlotType.HeadTop]
    if headTopFashionId then
        local fashionData = ManagerContainer.CfgMgr:GetFashionById(headTopFashionId)
        if fashionData then
            isHideHair = fashionData.FashionHideHair
        end
    end

    -- local eyeBody = nil
    -- if data.eye ~= nil then
    --     bodies[#bodies + 1] = LuaToCSData.CreateEyeBodyPartParamData(data.eye)
    -- end
    -- local hairBody = nil
    -- if data.hair ~= nil then
    --     bodies[#bodies + 1] = LuaToCSData.CreateHairBodyPartParamData(data.hair)
    -- end

    local faceBody = LuaToCSData.CreateFacePartParamData(roleCfgId)
    if faceBody ~= nil then
        bodies[#bodies + 1] = faceBody
    end
    for i = Enum.FashionSlotType.HeadTop, Enum.FashionSlotType.Pupil do
        local fashionId = data.fashionData[i]
        if i == Enum.FashionSlotType.Weapon then
            local leftWeaponParam, rightWeaponParam = LuaToCSData.CreateWeaponPartParamData(roleCfgId, jobId, i, fashionId)
            if leftWeaponParam then
                bodies[#bodies + 1] = leftWeaponParam
            end
            if rightWeaponParam then
                bodies[#bodies + 1] = rightWeaponParam
            end
        else
            local fashionData = LuaToCSData.CreateBodyPartParamData(roleCfgId, jobId, i, fashionId, isHideHair)
            if fashionData ~= nil then
                bodies[#bodies + 1] = fashionData
            end
        end
    end

    local bodyArray = System.Array.CreateInstance(Enum.TypeInfo.BodyPartParam, #bodies)
    local num = 0
    for k,v in pairs(bodies) do
        bodyArray[num] = v
        num = num + 1
    end

    return FashionParam.New(bodies, hairColorParam)
end

--- 创建 HairColorParam 对象
---@param data table
---@return HairColorParam
function LuaToCSData.CreateHairColorParamData(data)
    if data == nil then return nil end

    local cfgData = ManagerContainer.CfgMgr:GetCreateHairColorById(data)
    if cfgData == nil then
        return HairColorParam.New(Color.New(1,1,1), Vector2(0,0))
    end
    
    local clr = Color.New(cfgData.HairColour[1], cfgData.HairColour[2], cfgData.HairColour[3])
    local offset = Vector2(cfgData.UVOffset[1], cfgData.UVOffset[2])
    return HairColorParam.New(clr, offset)
end

--- 创建 眼睛部位 BodyPartParam 对象
---@param data table
---@return BodyPartParam
function LuaToCSData.CreateEyeBodyPartParamData(data)
    if data == nil then return nil end

    local cfgData = ManagerContainer.CfgMgr:GetCreateEyeById(data)
    if cfgData == nil then
        return nil
    end
    return BodyPartParam.New(Enum.SkinSlotType.Eye, cfgData.EyeColour, Enum.SkinSlotBindBone[Enum.FashionSlotType.Eye], Vector3.zero, Vector3.zero, Vector3.zero)
end

--- 创建 头发部位 BodyPartParam 对象
---@param data table
---@return BodyPartParam
function LuaToCSData.CreateHairBodyPartParamData(data)
    if data == nil then return nil end

    local cfgData = ManagerContainer.CfgMgr:GetCreateHairById(data)
    if cfgData == nil then
        return nil
    end
    
    return BodyPartParam.New(Enum.SkinSlotType.HairStyle, cfgData.HairAvatar, Enum.SkinSlotBindBone[Enum.FashionSlotType.Hair], Vector3.zero, Vector3.zero, Vector3.zero)
end

--- 创建 脸部位 BodyPartParam 对象
---@return BodyPartParam
function LuaToCSData.CreateFacePartParamData(roleCfgId)
    if roleCfgId == nil then return nil end

    local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleCfgId)
    local avatarId = nil
    if roleCfgData.Sex == Enum.SexType.Man then
        avatarId = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_man_face_model_path)
    else
        avatarId = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_woman_face_model_path)
    end
    local avatarPrefab = nil
    local roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(avatarId)
    if roleAvatarCfg then
        avatarPrefab = roleAvatarCfg.AvatarPrefab
    end
    return BodyPartParam.New(Enum.SkinSlotType.Face, avatarPrefab, nil, Vector3.zero, Vector3.zero, Vector3.zero)
end

function LuaToCSData.CreateWeaponPartParamData(roleCfgId, jobId, type, data)
    local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleCfgId)
    local leftWeaponParam, rightWeaponParam
    local fashionCfgData = nil
    local roleAvatarID = nil
    local roleAvatarCfg = nil
    if data then
        fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(data)
    end
    if roleCfgData.LeftWeapon and roleCfgData.LeftWeapon ~= 0 then
        if fashionCfgData then
            roleAvatarID = fashionCfgData.RoleAvatarID
        end
        -- 去默认的配置中找
        if not roleAvatarID or roleAvatarID == 0 then
            roleAvatarID = roleCfgData.LeftWeapon
        end
        if roleAvatarID and roleAvatarID ~= 0 then
            roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(roleAvatarID)
        end
        if roleAvatarCfg then
            leftWeaponParam = BodyPartParam.New(Enum.SkinSlotType.LeftHand, roleAvatarCfg.AvatarPrefab, Enum.SkinSlotBindBone[Enum.SkinSlotType.LeftHand], CommonUtil.TableToVector3(roleAvatarCfg.ModelPosition), CommonUtil.TableToVector3(roleAvatarCfg.ModelRotation), CommonUtil.TableToVector3(roleAvatarCfg.ModelScale, Vector3.one))
        else
            leftWeaponParam = BodyPartParam.New(Enum.SkinSlotType.LeftHand, nil, Enum.SkinSlotBindBone[Enum.SkinSlotType.LeftHand], Vector3.zero, Vector3.zero, Vector3.zero)
        end
    end
    roleAvatarID = nil
    roleAvatarCfg = nil
    if roleCfgData.RightWeapon and roleCfgData.RightWeapon ~= 0 then
        if fashionCfgData then
            roleAvatarID = fashionCfgData.ExtRoleAvatarID
        end
        -- 去默认的配置中找
        if not roleAvatarID or roleAvatarID == 0 then
            roleAvatarID = roleCfgData.RightWeapon
        end
        if roleAvatarID and roleAvatarID ~= 0 then
            roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(roleAvatarID)
        end
        if roleAvatarCfg then
            rightWeaponParam = BodyPartParam.New(Enum.SkinSlotType.RightHand, roleAvatarCfg.AvatarPrefab, Enum.SkinSlotBindBone[Enum.SkinSlotType.RightHand], CommonUtil.TableToVector3(roleAvatarCfg.ModelPosition), CommonUtil.TableToVector3(roleAvatarCfg.ModelRotation), CommonUtil.TableToVector3(roleAvatarCfg.ModelScale, Vector3.one))
        else
            rightWeaponParam = BodyPartParam.New(Enum.SkinSlotType.RightHand, nil, Enum.SkinSlotBindBone[Enum.SkinSlotType.RightHand], Vector3.zero, Vector3.zero, Vector3.one)
        end
    end
    return leftWeaponParam, rightWeaponParam
end

--- 创建 其他部位 BodyPartParam 对象
---@param data table
---@return BodyPartParam
function LuaToCSData.CreateBodyPartParamData(roleCfgId, jobId, type, data, isHideHair)
    local skinSlotType = Enum.FashionSlotToSkinSlot[type]
    if isHideHair and skinSlotType == Enum.SkinSlotType.HairStyle then
        return nil
    end
    local roleAvatarCfg = nil
    local roleAvatarID = nil
    local linkPoint = Enum.SkinSlotBindBone[skinSlotType]
    if data ~= nil then
        local cfgData = ManagerContainer.CfgMgr:GetFashionById(data)
        if cfgData then
            roleAvatarID = cfgData.ExtRoleAvatarID
            if not roleAvatarID or roleAvatarID == 0 then
                roleAvatarID = cfgData.RoleAvatarID
            end
        end
    end
    -- 去默认的配置中找
    if not roleAvatarID or roleAvatarID == 0 then
        local roleCfgData = ManagerContainer.CfgMgr:GetRoleDataById(roleCfgId)
        roleAvatarID = nil
        if type == Enum.FashionSlotType.HeadTop then
            roleAvatarID = roleCfgData.HeadTop
        elseif type == Enum.FashionSlotType.HeadMiddle then
            roleAvatarID = roleCfgData.HeadMiddle
        elseif type == Enum.FashionSlotType.HeadBottom then
            roleAvatarID = roleCfgData.HeadBottom
        elseif type == Enum.FashionSlotType.Cloth then
            roleAvatarID = roleCfgData.ClothId
        elseif type == Enum.FashionSlotType.BodyBack then
            roleAvatarID = roleCfgData.BodyBackId
        elseif type == Enum.FashionSlotType.HairStyle then
            roleAvatarID = roleCfgData.Hair
        elseif type == Enum.FashionSlotType.Pupil then
            roleAvatarID = roleCfgData.Eye
        end
        if roleAvatarID == "" then
            -- LogError("fashion type error  "..type)
            return nil
        end
    end
    if roleAvatarID and roleAvatarID ~= 0 then
        roleAvatarCfg = ManagerContainer.CfgMgr:GetRoleAvatarById(roleAvatarID)
    end
    if roleAvatarCfg then
        return BodyPartParam.New(skinSlotType, roleAvatarCfg.AvatarPrefab, linkPoint, CommonUtil.TableToVector3(roleAvatarCfg.ModelPosition), CommonUtil.TableToVector3(roleAvatarCfg.ModelRotation), CommonUtil.TableToVector3(roleAvatarCfg.ModelScale, Vector3.one))
    else
        return BodyPartParam.New(skinSlotType, nil, linkPoint, Vector3.zero, Vector3.zero, Vector3.one)
    end
end

return LuaToCSData