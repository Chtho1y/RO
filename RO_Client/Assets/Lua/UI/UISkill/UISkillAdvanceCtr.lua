local UISkillAdvanceCtr = class("UISkillAdvanceCtr", require("UICtrBase"))

function UISkillAdvanceCtr:Init(view)
	self.view = view
end

function UISkillAdvanceCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISkillAdvanceCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISkillAdvanceCtr:GetData()
	return self.data
end

function UISkillAdvanceCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISkillAdvanceCtr

