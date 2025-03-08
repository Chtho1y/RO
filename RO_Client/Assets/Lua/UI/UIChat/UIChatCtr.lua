local UIChatCtr = class("UIChatCtr", require("UICtrBase"))
local UIBattleCtr

function UIChatCtr:Init(view)
	self.view = view
	self.channelType  = nil;
end

function UIChatCtr:SetData(data)
	UIBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIBattle)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChatCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChatCtr:GetData()
	return self.data
end

function UIChatCtr:SendChatReq(content, chatDataType)
	ManagerContainer.DataMgr.ChatData:SendChatReq(content, chatDataType)
	--content = StringUtil.TrimEdgeSpace(content)
	--local data = {type = chatDataType, message = {message = content}}
	--ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHAT_MESSAGE_REQ, data)
end

function UIChatCtr:SendPlayerQuery(uid)
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid);
	--[[
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_DETAIL_INFO_REQ,
			{t_uid = int64.new(uid)})]]--
end

function UIChatCtr:SetChatChannelType(type)
	self.channelType  = type
end

function UIChatCtr:GetChatChannelType()
	return self.channelType or Enum.ChatChannel.World
end

function UIChatCtr:OnDispose()
	UIBattleCtr = nil
	self.data = nil
	self.view = nil
	self.channelType  = nil;
end

return UIChatCtr

