local UIStoryPlayVideoCtr = class("UIStoryPlayVideoCtr", require("UICtrBase"))

function UIStoryPlayVideoCtr:Init(view)
	self.view = view
end

function UIStoryPlayVideoCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIStoryPlayVideoCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIStoryPlayVideoCtr:GetData()
	return self.data
end

function UIStoryPlayVideoCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIStoryPlayVideoCtr:GetVideoPath()
	return self.data
end

return UIStoryPlayVideoCtr

