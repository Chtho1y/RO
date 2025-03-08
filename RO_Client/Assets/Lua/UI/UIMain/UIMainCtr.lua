local UIMainCtr = class("UIMainCtr", require("UICtrBase"))

local awardTotalTime = 0

function UIMainCtr:Init(view)
	self.view = view
end

function UIMainCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIMainCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIMainCtr:GetGotAnimEndPosByType(type)
	if self.view == nil then return nil end

	return self.view:GetGotAnimEndPosByType(type)
end

function UIMainCtr:GeAnchoredPosition3DByType(type)
	if self.view == nil then return nil end

	return self.view:GeAnchoredPosition3DByType(type)
end

function UIMainCtr:GetTaskBtnPosition()
	if self.view == nil then return nil end

	return self.view:GetTaskBtnPosition()
end

function UIMainCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIMainCtr:SetAwardTotalTime(time)
	if not time then return end
	awardTotalTime = time * 0.001
end

function UIMainCtr:GetAwardTotalTime()
	return awardTotalTime
end

return UIMainCtr

