local UICtrBase = class("UICtrBase")

function UICtrBase:ctor()

end

function UICtrBase:OnDispose()
	self.view = nil
	self.data = nil
end

return UICtrBase