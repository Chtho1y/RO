local UIArtifactTipsCtr = class("UIArtifactTipsCtr", require("UICtrBase"))

function UIArtifactTipsCtr:Init(view)
	self.view = view
end

function UIArtifactTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIArtifactTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIArtifactTipsCtr:GetData()
	return self.data
end

function UIArtifactTipsCtr:GetSkillEquipData()
	return self.data[1].logicData
end

function UIArtifactTipsCtr:GetHeroId()
	return self.data[1].heroId
end

function UIArtifactTipsCtr:GetHeroCfgId()
	return self.data[1].heroCfgId
end

function UIArtifactTipsCtr:GetHeroNickname()
	return self.data[1].nickname
end

function UIArtifactTipsCtr:GetEnterType()
	return self.data[2]
end

function UIArtifactTipsCtr:GetEnterFrom()
	return self.data[3]
end

function UIArtifactTipsCtr:SendSlotUpReq()
	ManagerContainer.DataMgr.SkillEquipData:SendSkillEquipSlotLevelUpReq(self.data[1].heroId, 1)
end


function UIArtifactTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIArtifactTipsCtr

