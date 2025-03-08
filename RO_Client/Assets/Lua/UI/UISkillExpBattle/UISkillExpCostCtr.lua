local UISkillExpCostCtr = class("UISkillExpCostCtr", require("UICtrBase"))

function UISkillExpCostCtr:Init(view)
	self.view = view
end

function UISkillExpCostCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISkillExpCostCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISkillExpCostCtr:GetData()
	return self.data
end

function UISkillExpCostCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UISkillExpCostCtr

