local MinePlayerEntityView = class("MinePlayerEntityView", require("PlayerEntityView"))

function MinePlayerEntityView:ctor()
    self.isShowAniming = false
end

function MinePlayerEntityView:CollectPreloadAssets()
    local userData = ManagerContainer.DataMgr.UserData
    self.roleViewSystem:RefreshData(Enum.RoleInEnvType.GuildLobby, userData:GetUserRoleId(), userData:GetViewData())
    MinePlayerEntityView.super.CollectPreloadAssets(self)
    -- 主角光环
    self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.EffectPath, 'Hero/Common/FX_Hero_guanghuan')
end

function MinePlayerEntityView:ExitWorld()
    if self.guanghuanGo then ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath, 'Hero/Common/FX_Hero_guanghuan', self.guanghuanGo) end
    self.guanghuanGo = nil
    MinePlayerEntityView.super.ExitWorld(self)
end

function MinePlayerEntityView:InitGenerateView()
    MinePlayerEntityView.super.InitGenerateView(self)
    -- 添加主角光环
    local guanghuanGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.EffectPath, 'Hero/Common/FX_Hero_guanghuan')
    local guanghuanTrans = guanghuanGo.transform
    guanghuanTrans:SetParent(self.transform)
    guanghuanTrans.localPosition = Vector3.zero
    guanghuanTrans.localRotation = Quaternion.identity
    self.guanghuanGo = guanghuanGo
end

function MinePlayerEntityView:RefreshGenerateView()
    MinePlayerEntityView.super.RefreshGenerateView(self)
    local userData = ManagerContainer.DataMgr.UserData
    self.roleViewSystem:RefreshView(Enum.RoleInEnvType.GuildLobby, userData:GetUserRoleId(), userData:GetViewData())
end

return MinePlayerEntityView