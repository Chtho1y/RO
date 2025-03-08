local UIPlayerView = class("UIPlayerView")

function UIPlayerView:ctor(root, camera, uid)
    self.text = root:Find("Text"):GetComponent(Enum.TypeInfo.Text)
    self.text.text = tostring(uid)
end

function UIPlayerView:Dispose()
    self.text = nil
end

return UIPlayerView