local PlayerEntityView = class("PlayerEntityView", require("EntityView"))
local RoleViewSystem = require("RoleViewSystem")
-- local UIPlayerView = require("UIPlayerView")

function PlayerEntityView:ctor()
    self.moveState = 0
    self.roleViewSystem = RoleViewSystem:new()
    self.isUpdate = false
end

function PlayerEntityView:Dispose()
    if self.roleViewSystem then
        self.roleViewSystem:Dispose()
    end
    self.roleViewSystem = nil
    self.moveState = nil
    self.isUpdate = nil
    PlayerEntityView.super.Dispose(self)
end

function PlayerEntityView:EnterWorld()
    self.isUpdate = false
    PlayerEntityView.super.EnterWorld(self)
end

function PlayerEntityView:ExitWorld()
    -- if self.uiPlayerView then self.uiPlayerView:Dispose() end
    -- self.uiPlayerView = nil
    -- local uiAssetName = Constants.UI3DPath .. "/MainCity/UIPlayerView"
    -- if self.uiGo then ManagerContainer.ResMgr:RecycleGO(nil, uiAssetName, self.uiGo) end
    -- self.uiGo = nil
    if self.shadowGo then ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, 'Common/FX_Yinying', self.shadowGo) end
    self.shadowGo = nil
    if self.animator then self.animator = nil end
    if self.roleViewSystem then self.roleViewSystem:Recycle() end
    PlayerEntityView.super.ExitWorld(self)
    self.isUpdate = false
end

function PlayerEntityView:CollectPreloadAssets()
    PlayerEntityView.super.CollectPreloadAssets(self)
    if self.roleViewSystem then self.roleViewSystem:StatisticsPreloadAssets(self.loadSystem) end
    -- local uiAssetName = Constants.UI3DPath .. "/MainCity/UIPlayerView"
    self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject,  Constants.EffectPath, 'Common/FX_Yinying')
    -- self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, uiAssetName)
end

function PlayerEntityView:InitGenerateView()
    -- 创建Model
    local modelGo = self.roleViewSystem:Create()
    local modelTrans = modelGo.transform
    modelTrans:SetParent(self.avatarTrans)
    modelTrans.localPosition = Vector3.zero
    modelTrans.localRotation = Quaternion.identity
    -- 删除Prefab上的默认的碰撞体 (临时)
    local colliders = modelGo:GetComponentsInChildren(typeof(UnityEngine.Collider))
    for i = 0, colliders.Length - 1 do
        UnityEngine.Component.Destroy(colliders[i])
    end
    -- 添加阴影
    local shadowGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, 'Common/FX_Yinying')
    local shadowTrans = shadowGo.transform
    shadowTrans:SetParent(self.transform)
    shadowTrans.localPosition = Vector3.zero
    shadowTrans.localRotation = Quaternion.identity


    -- local uipoint = modelTrans:Find("ui_point")
    -- local uiPosition = uipoint.position
    -- 添加UI
    -- local uiAssetName = Constants.UI3DPath .. "/MainCity/UIPlayerView"
    -- local uiGo = ManagerContainer.ResMgr:GetGoFromPool(nil, uiAssetName)
    -- local uiTrans = uiGo.transform
    -- uiTrans:SetParent(self.transform)
    -- uiTrans.position = uiPosition
    -- uiTrans.rotation = Quaternion.identity
    -- local uiPlayerView = UIPlayerView:new(uiTrans, ManagerContainer.LuaMainCityMgr:GetMainCamera(), self.uid)

    self.animator = modelGo:GetComponent(Enum.TypeInfo.Animator)
    self.shadowGo = shadowGo
    -- self.uiGo = uiGo
    -- self.uiPlayerView = uiPlayerView

    if self.isUpdate then
        self:RefreshGenerateView()
    end
end

function PlayerEntityView:RefreshGenerateView()
    self.isUpdate = false
end

function PlayerEntityView:ForceRefreshGenerateView()
    self.isUpdate = true
    if self.isCreate then
        self:RefreshGenerateView()
    else
        self.loadSystem:Cancel()
        self:CollectPreloadAssets()
        self:BeginLoadAssets()
    end
end


function PlayerEntityView:GetName()
    return tostring(self.uid)
end

function PlayerEntityView:GetParent()
    return ManagerContainer.LuaGuildLobbyMgr:GetPlayerContainer()
end

function PlayerEntityView:SetPosition(pos)
    if self.pos:Equals(pos) then return end
    self.pos:Set(pos.x, pos.y, pos.z)
    if not self.transform then return end
    self.transform.position = self.pos
end

function PlayerEntityView:SetRotation(rot)
    if Quaternion.Equals(self.rot, rot) then return end
    self.rot:Set(rot.x, rot.y, rot.z, rot.w)
    if not self.avatarTrans then return end
    self.avatarTrans.rotation = self.rot
end

function PlayerEntityView:SetMoveState(moveState)
    if self.moveState == moveState then return end
    self.moveState = moveState
    self:_SetMoveState(moveState)
end

function PlayerEntityView:_SetMoveState(moveState)
    if not self.animator then return end
    if moveState == 1 then
        self.animator:CrossFade("f_walk", 0.1)
    elseif moveState == 2 then
        self.animator:CrossFade("f_run_1", 0.1)
    else
        self.animator:CrossFade("f_idle", 0.1)
    end
end


return PlayerEntityView