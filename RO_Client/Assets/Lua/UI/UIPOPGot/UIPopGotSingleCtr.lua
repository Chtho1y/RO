local UIPopGotSingleCtr = class("UIPopGotSingleCtr", require("UICtrBase"))

function UIPopGotSingleCtr:Init(view)
	self.view = view
end

---@param data table {id=integer, startPos=Vector3}  id:StorySectionCfg的Id, startPos世界坐标
function UIPopGotSingleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self:InitData()
end

function UIPopGotSingleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPopGotSingleCtr:GetData()
	return self.data
end

function UIPopGotSingleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIPopGotSingleCtr:InitData()
	self.storySectionId = self.data.id
	self.startPos = self.data.startPos
end

function UIPopGotSingleCtr:GetStorySectionId()
	return self.storySectionId
end

function UIPopGotSingleCtr:GetStartPos()
	return self.startPos
end

return UIPopGotSingleCtr

