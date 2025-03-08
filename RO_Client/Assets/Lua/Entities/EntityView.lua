local EntityView = class("EntityView")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")
local GameObject = UnityEngine.GameObject

--- 构造
---@param pos Vector3 初始坐标
---@param rot Vector3 初始方向
function EntityView:ctor(uid, pos, rot)
    self.uid = uid
    self.pos = pos:Clone()
    self.rot = rot:Clone()
    self.isInWorld = false
    self.isCreated = false
    self.loadSystem = MultiTypeAssetLoadSystem:new()
    self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)
end

--- 销毁
function EntityView:Dispose()
    if self.isInWorld then self:ExitWorld() end
    if self.loadSystem then
        self.loadSystem:Dispose()
        self.loadSystem = nil
    end
    self.uid = nil
    self.pos = nil
    self.rot = nil
    self.isInWorld = nil
    self.isCreated = nil
end

function EntityView:EnterMap()
    self:CollectPreloadAssets()
end

function EntityView:ExitMap()
    self:ExitWorld()
end

--- 进入游戏世界
function EntityView:EnterWorld()
    self.isInWorld = true
    self.isCreated = false
    self:CreateContainer()
    self:BeginLoadAssets()
end

--- 退出游戏世界
function EntityView:ExitWorld()
    if self.loadSystem then
        self.loadSystem:Cancel()
    end
    self.avatarGo = nil
    self.avatarTrans = nil
    if self.gameObject then GameObject.Destroy(self.gameObject) end
    self.gameObject = nil
    self.transform = nil
    self.isInWorld = false
    self.isCreated = false
end

--- 更新
function EntityView:Update(deltaTime)
end

--- 获得名字
function EntityView:GetName()
    return self:getClassName()
end

--- 获得根节点
function EntityView:GetParent()
    return nil
end

function EntityView:GetTransform()
    return self.transform
end

function EntityView:CreateContainer()
    -- 创建容器
    self.gameObject = GameObject(self:GetName())
    self.transform = self.gameObject.transform
    self.transform:SetParent(self:GetParent())
    self.transform:SetPositionAndRotation(self.pos, Quaternion.identity)
    -- 创建转向容器（模型需要转向，而UI则不需要转向）
    self.avatarGo = GameObject("Avatar")
    self.avatarTrans = self.avatarGo.transform
    self.avatarTrans:SetParent(self.transform)
    self.avatarTrans:SetPositionAndRotation(self.pos, self.rot)
end

function EntityView:CollectPreloadAssets()
    self.loadSystem:RemoveLoadAllAsset()
end

function EntityView:BeginLoadAssets()
    self.loadSystem:Begin()
end

--- 获得需要预加载的资源内容
---@return nil or table(Enum.ResourceType, table(string, int))
function EntityView:StatisticsPreloadAssets(multiTypeAssetLoadSystem)
    if not multiTypeAssetLoadSystem then return end
    self.loadSystem:AddToLoadSystem(multiTypeAssetLoadSystem)
end

--- 预加载的资源已加载完成
function EntityView:PreloadedAssets()
    if not self.isCreated then
        self.isCreated = true
        self:InitGenerateView()
    end
    self:OtherGenerateView()
end

function EntityView:InitGenerateView()
end

function EntityView:OtherGenerateView()
end

function EntityView:_SetLayer(trans, layer, enterChild)
    if not trans then return end
    trans.gameObject.layer = layer
    if not enterChild then return end
    for i = 0, trans.childCount - 1 do
        self:_SetLayer(trans:GetChild(i), layer, enterChild)
    end
end

function EntityView:_SetTag(trans, tag, enterChild)
    if not trans then return end
    trans.tag = tag
    if not enterChild then return end
    for i = 0, trans.childCount - 1 do
        self:_SetTag(trans:GetChild(i), tag, enterChild)
    end
end

function EntityView:_SetLayerAndTag(trans, layer, tag, enterChild)
    if not trans then return end
    trans.tag = tag
    trans.gameObject.layer = layer
    if not enterChild then return end
    for i = 0, trans.childCount - 1 do
        self:_SetLayerAndTag(trans:GetChild(i), layer, tag, enterChild)
    end
end

return EntityView