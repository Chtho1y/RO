local UIChapterCtr = class("UIChapterCtr", require("UICtrBase"))

function UIChapterCtr:Init(view)
	self.view = view
end

---@param data integer 章节Id StoryChapterCfg的Id
function UIChapterCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChapterCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChapterCtr:GetData()
	return self.data
end

function UIChapterCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIChapterCtr:GetCfgId()
	return self.data
end

return UIChapterCtr

