local UIGuildDemonCtr = class("UIGuildDemonCtr", require("UICtrBase"))

function UIGuildDemonCtr:Init(view)
	self.view = view
end

function UIGuildDemonCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildDemonCtr:GetShowData()
	return self.data or {}
end

function UIGuildDemonCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildDemonCtr:ChallengeBoss()
	ManagerContainer.DataMgr.GuildDemonData:StartGuildDemonBattle()
end


function UIGuildDemonCtr:GetData()
	return self.data
end

function UIGuildDemonCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIGuildDemonCtr

