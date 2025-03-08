local UIQuestionnaireCtr = class("UIQuestionnaireCtr", require("UICtrBase"))

function UIQuestionnaireCtr:Init(view)
	self.view = view
end

function UIQuestionnaireCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIQuestionnaireCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIQuestionnaireCtr:GetData()
	return self.data
end

function UIQuestionnaireCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIQuestionnaireCtr

