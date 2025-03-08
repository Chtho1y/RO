local UIExpeditionHelpCtr = class("UIExpeditionHelpCtr", require("UICtrBase"))

function UIExpeditionHelpCtr:Init(view)
	self.view = view
end

function UIExpeditionHelpCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpeditionHelpCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionHelpCtr:GetData()
	return self.data
end

function UIExpeditionHelpCtr:InitFriendData()
	self.friendList = ManagerContainer.DataMgr.FriendDataMgr:GetExpedotopmHelpList()
	self.friendIDList = ManagerContainer.DataMgr.FriendDataMgr:GetAllExpedotopmHelpIDList()
end

function UIExpeditionHelpCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.friendList = nil
	self.friendIDList = nil
end

function UIExpeditionHelpCtr:FriendList()
	return self.friendList
end


function UIExpeditionHelpCtr:IsReqFinished()
	return self.friendIDList and #self.friendIDList == 0 
end

function UIExpeditionHelpCtr:ReqestFriendBriefData()
	if not self.friendIDList or #self.friendIDList == 0 then
		return
	end
	local cnt = 10
	local uid_list = {}

	if cnt > #self.friendIDList then
		cnt = #self.friendIDList
	end
	for i = 1, cnt do
		uid_list[#uid_list+1] = self.friendIDList[i]
	end

	--LogError("ReqestFriendBriefData : " .. Inspect(uid_list))
	ManagerContainer.DataMgr.FriendDataMgr:ReqFriendBriefData(Enum.FriendTogglePageType.InterestList,uid_list)
end

return UIExpeditionHelpCtr

