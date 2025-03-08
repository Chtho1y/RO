local PreviewSystem = class("PreviewSystem")
local GameObject = UnityEngine.GameObject
local Object = UnityEngine.Object
local Camera = UnityEngine.Camera
local RenderTexture = UnityEngine.RenderTexture
local CameraClearFlags = UnityEngine.CameraClearFlags
local RenderTextureDescriptor = UnityEngine.RenderTextureDescriptor
local RenderTextureFormat = UnityEngine.RenderTextureFormat

local previewLayer = 15
local hideLayer = 12
local preivewCullingMask = 32768  -- 1 << 15

local DefaultRTW = 512
local DefaultRTH = 512
local DefaultHDRTW = 1024
local DefaultHDRTH = 1024
--- 当前启用的PreivewSystem列表
local PreviewSystemList = {}
local PreviewSystemListDiff = false
--- 存储正在预览的对象
local PreviewSystemGos = {}
local NeedCheckDiff = false

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

local function SetRenderersEnable(renderers, enable)
    if not renderers then return end
    for i = 0, renderers.Length - 1 do
        if renderers[i] and not tolua.isnull(renderers[i]) then
            renderers[i].enabled = enable
        end
    end
end

local function AddPreviewSystemGo(go)
    if not go then return end

    NeedCheckDiff = true
    local previewSystemGo = PreviewSystemGos[go]
    if not previewSystemGo then
        previewSystemGo = {}
        PreviewSystemGos[go] = previewSystemGo
        previewSystemGo.layer = go.layer
        previewSystemGo.previewNum = 1
        previewSystemGo.renderers = go:GetComponentsInChildren(typeof(UnityEngine.Renderer))
    else
        previewSystemGo.previewNum = previewSystemGo.previewNum + 1
    end
    SetGoLayer(go, previewLayer)
    if PreviewSystemListDiff then
        SetRenderersEnable(previewSystemGo.renderers, false)
    end
end

local function UpdatePreviewSystemGo(go)
    if not go then return end
    local previewSystemGo = PreviewSystemGos[go]
    if not previewSystemGo then
        previewSystemGo = {}
        PreviewSystemGos[go] = previewSystemGo
        previewSystemGo.layer = go.layer
        previewSystemGo.previewNum = 1
    end
    previewSystemGo.renderers = go:GetComponentsInChildren(typeof(UnityEngine.Renderer))
    SetGoLayer(go, previewLayer)
    if PreviewSystemListDiff then
        SetRenderersEnable(previewSystemGo.renderers, false)
    end
end

local function RemovePreviewSystemGo(go)
    if not go then return end

    NeedCheckDiff = true
    local previewSystemGo = PreviewSystemGos[go]
    if not previewSystemGo then return end
    previewSystemGo.previewNum = previewSystemGo.previewNum - 1
    if previewSystemGo.previewNum > 0 then return end
    SetGoLayer(go, hideLayer)
    SetRenderersEnable(previewSystemGo.renderers, true)
    previewSystemGo = nil
    PreviewSystemGos[go] = nil
end

local function ResetPreviewSystemGos(isResetLayer)
    for go, previewSystemGo in pairs(PreviewSystemGos) do
        if go and previewSystemGo then
            if isResetLayer then SetGoLayer(go, previewSystemGo.layer) end
            SetRenderersEnable(previewSystemGo.renderers, true)
        end
    end
end

local function ClearPreviewSystemGos()
    if #PreviewSystemList > 0 then return end
    ResetPreviewSystemGos(true)
    PreviewSystemGos = {}
    PreviewSystemListDiff = false

    ManagerContainer.LuaGameMgr:DisableAntiAliasing()
end

local function CheckDiff()
    if not NeedCheckDiff then return end
    NeedCheckDiff = false
    local lastPreviewSystemListDiff = PreviewSystemListDiff
    PreviewSystemListDiff = false
    local previewSystemNum = #PreviewSystemList
    if previewSystemNum > 1 then
        for go, info in pairs(PreviewSystemGos) do
            if go and info then
                if info.previewNum ~= previewSystemNum then
                    PreviewSystemListDiff = true
                    break
                end
            end
        end
    end
    if lastPreviewSystemListDiff == PreviewSystemListDiff then
        return
    end
    lastPreviewSystemListDiff = PreviewSystemListDiff
    if PreviewSystemListDiff then
        for go, previewSystemGo in pairs(PreviewSystemGos) do
            if go and previewSystemGo then
                SetRenderersEnable(previewSystemGo.renderers, false)
            end
        end
    else
        -- 重置默认值
        ResetPreviewSystemGos(false)
    end
end

function PreviewSystem:ctor(name, rtW, rtH, camera)
    local previewCameraGo, previewCamera,isSelfCamera
    if camera then
        previewCameraGo = camera.gameObject
        previewCamera = camera
        isSelfCamera = false
    else
        if not name or name == '' then
            name = "Camera"
        end
        previewCameraGo = GameObject(name .. "(preivewCamera)")
        previewCamera = previewCameraGo:AddComponent(typeof(Camera))
        isSelfCamera = true
        if ManagerContainer.LuaModelMgr and ManagerContainer.LuaModelMgr.ModelRoot then
            previewCameraGo.transform:SetParent(ManagerContainer.LuaModelMgr.ModelRoot.transform)
        end
    end
    previewCamera.useOcclusionCulling = false
    previewCamera.cullingMask = preivewCullingMask
    previewCamera.clearFlags = CameraClearFlags.SolidColor
    previewCamera.nearClipPlane = 0.01
    previewCamera.allowHDR = false
    --previewCamera.orthographic = true
    --previewCamera.orthographicSize = 1.3

    if ManagerContainer.LuaGameMgr.IsGoodDevice then
        self.rtW = rtW or DefaultHDRTW
        self.rtH = rtH or DefaultHDRTH
    else
        self.rtW = DefaultRTW
        self.rtH = DefaultRTH
    end

    -- 设置 RenderTexture
    local renderTexture = RenderTexture.GetTemporary(self:InitRTDescriptor())
    previewCamera.targetTexture = renderTexture

    -- 设置PreviewCameraEvent
    local PreviewCameraEventType = typeof(PreviewCameraEvent)
    local previewCameraEvent = previewCameraGo:GetComponent(PreviewCameraEventType)
    if not previewCameraEvent then
        previewCameraEvent = previewCameraGo:AddComponent(PreviewCameraEventType)
    end
    previewCameraEvent:SetBindEvent(self, self._OnPreCull, self._OnPostRender)

    self.isSelfCamera = isSelfCamera
    self.previewCameraGo = previewCameraGo
    self.previewCamera = previewCamera
    self.renderTexture = renderTexture
    self.previewCameraEvent = previewCameraEvent

    self.showGos = {}

    ClearPreviewSystemGos()

    if ManagerContainer.LuaGameMgr.IsBadDevice then
        previewCamera.allowMSAA = false
    else
        ManagerContainer.LuaGameMgr:EnableAntiAliasing()
        previewCamera.allowMSAA = true
    end
    --previewCamera.allowMSAA = false

    table.insert(PreviewSystemList, self)
end

function PreviewSystem:Dispose()
    self:RemoveAllGo()
    if self.previewCamera then
        self.previewCamera.targetTexture = nil
    end
    if self.isSelfCamera then
        if self.previewCameraEvent then
            self.previewCameraEvent:SetBindEvent(nil, nil, nil)
        end
        if self.previewCameraGo then
            GameObject.Destroy(self.previewCameraGo)
        end
    else
        if self.previewCameraEvent then
            self.previewCameraEvent:SetBindEvent(nil, nil, nil)
            Object.Destroy(self.previewCameraEvent)
        end

    end
    if self.renderTexture then
        RenderTexture.ReleaseTemporary(self.renderTexture)
    end
    self.rtW = nil
    self.rtH = nil
    self.previewCameraGo = nil
    self.previewCamera = nil
    self.previewCameraEvent = nil
    self.renderTexture = nil
    self.showGos = nil
    self.previewLayer = nil 
    self.preivewCullingMask = nil
    for i = #PreviewSystemList, 1, -1 do
        if PreviewSystemList[i] == self then
            table.remove(PreviewSystemList, i)
            break
        end
    end
    ClearPreviewSystemGos()
end

function PreviewSystem:InitRTDescriptor(rtw, rth)
    local descriptor
    if rtw and rth then
        self.rtW = rtw
        self.rtH = rth
    end
    descriptor = RenderTextureDescriptor(self.rtW, self.rtH, RenderTextureFormat.ARGB32, 32)
    descriptor.autoGenerateMips = false
    if ManagerContainer.LuaGameMgr.IsBadDevice then
        descriptor.msaaSamples = 1
    else
        descriptor.msaaSamples = 4
    end
    return descriptor
end

function PreviewSystem:ReinitCameraRTSize(rtw, rth)
    if rtw and rth then
        local renderTexture = RenderTexture.GetTemporary(self:InitRTDescriptor(rtw, rth))
        if ManagerContainer.LuaGameMgr.IsBadDevice then
            renderTexture.antiAliasing = 0
        else
            renderTexture.antiAliasing = 4
        end
        self.previewCamera.targetTexture = renderTexture

        if self.renderTexture then
            RenderTexture.ReleaseTemporary(self.renderTexture)
        end
        self.renderTexture = renderTexture
    end
end

function PreviewSystem:GetRenderTexture()
    return self.renderTexture
end

function PreviewSystem:GetCamera()
    return self.previewCamera
end

function PreviewSystem:GetCameraGo()
    return self.previewCameraGo
end

function PreviewSystem:SetView(pos, rot)
    local transform = self.previewCameraGo.transform
    transform:SetPositionAndRotation(pos, rot)
end

function PreviewSystem:AddGo(go)
    if not go then return false end
    if not self.showGos then return false end
    local instanceID = go:GetInstanceID()
    if self.showGos[instanceID] then
        return false
    end
    self.showGos[instanceID] = go
    AddPreviewSystemGo(go)
    return true
end

function PreviewSystem:UpdateGo(go)
    if self:AddGo(go) then
        return
    end
    UpdatePreviewSystemGo(go)
end

function PreviewSystem:RemoveGo(go)
    if not go then return end
    if not self.showGos then return end
    local instanceID = go:GetInstanceID()
    if not self.showGos[instanceID] then
        return
    end
    self.showGos[instanceID] = nil
    RemovePreviewSystemGo(go)
end

function PreviewSystem:RemoveAllGo()
    for instanceID, go in pairs(self.showGos) do
        RemovePreviewSystemGo(go)
    end
    self.showGos = {}
end


function PreviewSystem:_OnPreCull()
    CheckDiff()
    if not PreviewSystemListDiff then return end
    for instanceID, go in pairs(self.showGos) do
        if go then
            local previewSystemGo = PreviewSystemGos[go]
            if previewSystemGo then
                SetRenderersEnable(previewSystemGo.renderers, true)
            end
        end
    end
end

function PreviewSystem:_OnPostRender()
    if not PreviewSystemListDiff then return end
    for instanceID, go in pairs(self.showGos) do
        if go then
            local previewSystemGo = PreviewSystemGos[go]
            if previewSystemGo then
                SetRenderersEnable(previewSystemGo.renderers, false)
            end
        end
    end
end

return PreviewSystem