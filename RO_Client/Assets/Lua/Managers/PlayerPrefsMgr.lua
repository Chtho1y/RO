--[[
    临时数据或者不太重要的数据，存储本地
    封装接口，后续可以做数据加密
]]

local PlayerPrefsMgr = class("PlayerPrefsMgr")
local PlayerPrefs = UnityEngine.PlayerPrefs


function PlayerPrefsMgr:Destroy()
    PlayerPrefs.Save()
end

function PlayerPrefsMgr:HasGlobalKey(key)
    return PlayerPrefs.HasKey(key)
end

function PlayerPrefsMgr:DeleteGlobalKey(key)
    return PlayerPrefs.DeleteKey(key)
end

function PlayerPrefsMgr:GetGlobalInt(key, defaultValue)
    defaultValue = defaultValue or 0
    return PlayerPrefs.GetInt(key, defaultValue)
end

function PlayerPrefsMgr:SetGlobalInt(key, value)
    value = value or 0
    return PlayerPrefs.SetInt(key, value)
end

function PlayerPrefsMgr:GetGlobalBoolean(key, defaultValue)
    local sureValue = defaultValue
    if self:HasGlobalKey(key) then
        sureValue = (self:GetGlobalInt(key, 0) == 1)
    end
    return sureValue
end

function PlayerPrefsMgr:SetGlobalBoolean(key, value)
    local sureValue = value and 1 or 0
    return self:SetGlobalInt(key, sureValue)
end

function PlayerPrefsMgr:GetGlobalFloat(key, defaultValue)
    defaultValue = defaultValue or 0
    return PlayerPrefs.GetFloat(key, defaultValue)
end

function PlayerPrefsMgr:SetGlobalFloat(key, value)
    value = value or 0
    return PlayerPrefs.SetFloat(key, value)
end

function PlayerPrefsMgr:GetGlobalString(key, defaultValue)
    defaultValue = defaultValue or ''
    return PlayerPrefs.GetString(key, defaultValue)
end

function PlayerPrefsMgr:SetGlobalString(key, value)
    value = value or ''
    return PlayerPrefs.SetString(key, value)
end



function PlayerPrefsMgr:HasKey(key)
    local correctKey = self:CurUserKey(key)
    return PlayerPrefs.HasKey(correctKey)
end

function PlayerPrefsMgr:DeleteKey(key)
    local correctKey = self:CurUserKey(key)
    return PlayerPrefs.DeleteKey(correctKey)
end

function PlayerPrefsMgr:GetInt(key, defaultValue)
    local correctKey = self:CurUserKey(key)
    defaultValue = defaultValue or 0
    return PlayerPrefs.GetInt(correctKey, defaultValue)
end

function PlayerPrefsMgr:SetInt(key, value)
    local correctKey = self:CurUserKey(key)
    value = value or 0
    return PlayerPrefs.SetInt(correctKey, value)
end

function PlayerPrefsMgr:GetBoolean(key, defaultValue)
    local correctKey = self:CurUserKey(key)
    local sureValue = defaultValue
    if self:HasKey(correctKey) then
        sureValue = (self:GetInt(correctKey, 0) == 1)
    end
    return sureValue
end

function PlayerPrefsMgr:SetBoolean(key, value)
    local correctKey = self:CurUserKey(key)
    local sureValue = value and 1 or 0
    return self:SetInt(correctKey, sureValue)
end

function PlayerPrefsMgr:GetFloat(key, defaultValue)
    local correctKey = self:CurUserKey(key)
    defaultValue = defaultValue or 0
    return PlayerPrefs.GetFloat(correctKey, defaultValue)
end

function PlayerPrefsMgr:SetFloat(key, value)
    local correctKey = self:CurUserKey(key)
    value = value or 0
    return PlayerPrefs.SetFloat(correctKey, value)
end

function PlayerPrefsMgr:GetString(key, defaultValue)
    local correctKey = self:CurUserKey(key)
    defaultValue = defaultValue or ''
    return PlayerPrefs.GetString(correctKey, defaultValue)
end

function PlayerPrefsMgr:SetString(key, value)
    local correctKey = self:CurUserKey(key)
    value = value or ''
    return PlayerPrefs.SetString(correctKey, value)
end


function PlayerPrefsMgr:CurUserKey(key)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    if uid then
        return tostring(uid) .. key
    else
        return key
    end
end

return PlayerPrefsMgr