local UIChatPrivateCtr = class("UIChatPrivateCtr", require("UICtrBase"))

function UIChatPrivateCtr:Init(view)
	self.view = view
end

function UIChatPrivateCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChatPrivateCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChatPrivateCtr:GetData()
	return self.data
end

function UIChatPrivateCtr:SendPrivateChat(content, targetId)
	ManagerContainer.DataMgr.ChatData:SendPrivateChat(content, targetId)
	--content = StringUtil.TrimEdgeSpace(content)
	--local data = {type = 1, message = {message = content}, target_id = int64.new(targetId)}
	--ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHAT_MESSAGE_REQ, data)
end

function UIChatPrivateCtr:SendOfflinePrivateChatQuery(targetId)
	local data = {target_id = int64.new(targetId), self_id = ManagerContainer.DataMgr.UserData:GetUserId()}
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHAT_OFFLINE_MSG_REQ, data)
end

function UIChatPrivateCtr:QueryAllPrivateBriefInfo()
	local privateChats = ManagerContainer.DataMgr.ChatData:GetPrivateSortChatDatas()
	if #privateChats > 0 then
		local data1 = {}
		for _,v in pairs(privateChats) do
			data1[#data1 + 1] = int64.new(v.fromData.uid)
		end
		local data = {player_list = data1, type = Enum.FriendTogglePageType.PrivateChatBriefQuery}
		ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, data)
	end
end

function UIChatPrivateCtr:QueryPrivateBriefInfo(targetId)
	local data = {player_list = {int64.new(targetId)}, type = Enum.FriendTogglePageType.PrivateChatBriefQuery}
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_BRIEF_INFO_REQ, data)
end

function UIChatPrivateCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIChatPrivateCtr

