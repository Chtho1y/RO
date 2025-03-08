local UIArtifactRewardsListCtr = class("UIArtifactRewardsListCtr", require("UICtrBase"))

function UIArtifactRewardsListCtr:Init(view)
	self.view = view
end

function UIArtifactRewardsListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIArtifactRewardsListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIArtifactRewardsListCtr:GetData()
	return self.data
end

function UIArtifactRewardsListCtr:OnDispose()
	self.data = nil
	self.view = nil
end


function UIArtifactRewardsListCtr:GetShowDataLength()
	return self.data and #self.data or 0
end

function UIArtifactRewardsListCtr:GetShowDataByIdx(idx)
	return self.data and self.data[idx]
end
return UIArtifactRewardsListCtr

