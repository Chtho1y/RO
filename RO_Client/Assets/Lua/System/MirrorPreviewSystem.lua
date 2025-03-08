local MirrorPreviewSystem = class("MirrorPreviewSystem", require("PreviewSystem"))


function MirrorPreviewSystem:ctor(_, _, _, _, lookCamera)
    local previewCameraGo = self.previewCameraGo
    local mirrorCamera = previewCameraGo:AddComponent(typeof(MirrorCamera))
    mirrorCamera.lookCamera = lookCamera
    mirrorCamera.reflectionPosition = Vector3(-0.96, 0.43, -0.96)
    mirrorCamera.reflectionRotation = Quaternion.Euler(0, 78.2, 90)
    mirrorCamera.reflectionUp = Vector3(-0.2044961, 0, 0.9788674)
    mirrorCamera.clipPlaneOffset = 0
    mirrorCamera:ResetCamera()

    self.mirrorCamera = mirrorCamera
end


function MirrorPreviewSystem:Dispose()
    if self.mirrorCamera then
        UnityEngine.Object.Destroy(self.mirrorCamera)
    end
    self.mirrorCamera = nil
    MirrorPreviewSystem.super.Dispose(self)
end

function MirrorPreviewSystem:InitRTDescriptor()
    local descriptor = MirrorPreviewSystem.super.InitRTDescriptor(self)
    descriptor.msaaSamples = 1
    descriptor.width = 512
    descriptor.height = 512
    return descriptor
end

return MirrorPreviewSystem