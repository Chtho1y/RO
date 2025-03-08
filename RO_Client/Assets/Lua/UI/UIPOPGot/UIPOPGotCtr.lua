local UIPOPGotCtr = class("UIPOPGotCtr", require("UICtrBase"))

function UIPOPGotCtr:Init(view)
	self.view = view
end

function UIPOPGotCtr:SetData(data)
	-- 添加数据
	self.data = data
	self.asyncIdx = 0
	self.rewards = self.data.rewards
	self.title = self.data.title
end

function UIPOPGotCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPOPGotCtr:GetData()
	return self.data
end

function UIPOPGotCtr:GetRewards()
	return self.rewards
end

function UIPOPGotCtr:GetTitle()
	return self.title
end

function UIPOPGotCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPOPGotCtr

