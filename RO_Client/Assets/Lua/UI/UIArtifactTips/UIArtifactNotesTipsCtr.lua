local UIArtifactNotesTipsCtr = class("UIArtifactNotesTipsCtr", require("UICtrBase"))

function UIArtifactNotesTipsCtr:Init(view)
	self.view = view
end

function UIArtifactNotesTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIArtifactNotesTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIArtifactNotesTipsCtr:GetData()
	return self.data
end

function UIArtifactNotesTipsCtr:GetSkillEquipData()
	return self.data.skillEquipData
end

function UIArtifactNotesTipsCtr:GetIdx()
	return self.data.idx
end

function UIArtifactNotesTipsCtr:GetHeroId()
	return self.data.heroId
end

function UIArtifactNotesTipsCtr:GetCondition1State()
	return self.data.condition1
end

function UIArtifactNotesTipsCtr:GetCondition2State()
	return self.data.condition2
end

function UIArtifactNotesTipsCtr:GetCondition3State()
	return self.data.condition3
end

function UIArtifactNotesTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIArtifactNotesTipsCtr

