local UISkillAdvanceTotalCtr = class("UISkillAdvanceTotalCtr", require("UICtrBase"))

function UISkillAdvanceTotalCtr:Init(view)
	self.view = view
end

function UISkillAdvanceTotalCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISkillAdvanceTotalCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISkillAdvanceTotalCtr:GetData()
	return self.data
end

function UISkillAdvanceTotalCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISkillAdvanceTotalCtr

