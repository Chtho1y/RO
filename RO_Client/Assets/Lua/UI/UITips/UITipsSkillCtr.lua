local UITipsSkillCtr = class("UITipsSkillCtr", require("UICtrBase"))

function UITipsSkillCtr:Init(view)
	self.view = view
end

function UITipsSkillCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UITipsSkillCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UITipsSkillCtr:GetData()
	return self.data
end

function UITipsSkillCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UITipsSkillCtr

