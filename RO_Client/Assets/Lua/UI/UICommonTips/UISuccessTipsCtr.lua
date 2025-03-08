local UISuccessTipsCtr = class("UISuccessTipsCtr", require("UICtrBase"))

function UISuccessTipsCtr:Init(view)
	self.view = view
end

function UISuccessTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
end

function UISuccessTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISuccessTipsCtr:OnDispose()
	self.view = nil
end

function UISuccessTipsCtr:GetShowData()
	local type, data = ManagerContainer.NewGotTipsMgr:GetShowData()
	return type, data
end

function UISuccessTipsCtr:RemoveCurShowData()
	local isHasNext = ManagerContainer.NewGotTipsMgr:RemoveCurShowData()
	return isHasNext
end

return UISuccessTipsCtr

