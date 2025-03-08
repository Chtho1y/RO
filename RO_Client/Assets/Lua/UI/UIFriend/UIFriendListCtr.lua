local UIFriendListCtr = class("UIFriendListCtr", require("UICtrBase"))

local FriendDataMgr =ManagerContainer.DataMgr.FriendDataMgr

function UIFriendListCtr:Init(view)
	self.view = view
end

function UIFriendListCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFriendListCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFriendListCtr:GetData()
	return self.data
end

function UIFriendListCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIFriendListCtr:GetMaxNum(type)
	if type == Enum.FriendTogglePageType.InterestList then
		return FriendDataMgr.maxFriendNum 
	elseif type == Enum.FriendTogglePageType.FansList then
		return FriendDataMgr.maxFansNum
	elseif type == Enum.FriendTogglePageType.BlackList then
		return FriendDataMgr.maxBlackNum
	else
		return 0
	end
end

function UIFriendListCtr:GetNum(type)
	if type == Enum.FriendTogglePageType.InterestList then
		return FriendDataMgr.totalFriendNum 
	elseif type == Enum.FriendTogglePageType.FansList then
		return FriendDataMgr.totalFansNum
	elseif type == Enum.FriendTogglePageType.BlackList then
		return FriendDataMgr.totalBlackNum
	else
		return 0
	end
end

function UIFriendListCtr:GetDefaultPageType()
	return self.data or Enum.FriendTogglePageType.InterestList
end

function UIFriendListCtr:GetDataByType(type)
	return FriendDataMgr:GetDataListByType(type)
end

function UIFriendListCtr:GetSearchData()
	return FriendDataMgr:GetSearchData()
end

function UIFriendListCtr:RequestSearchPlayerByName(targetName)
	FriendDataMgr:SearchFriendReq(targetName)
	-- ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_SearchFriendData)
end

function UIFriendListCtr:RequestDataByType(type)
	FriendDataMgr:RequestDataList(type)
	-- ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,type)
end

function UIFriendListCtr:RequestFriendRecommend()
	FriendDataMgr:GetFriendRecommendReq()
	-- ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_FriendData,Enum.FriendTogglePageType.FriendRecommend)
end

function UIFriendListCtr:ReqestFriendBriefData(type)
	local uid_list = FriendDataMgr:GetUidListByType(type,10)
	FriendDataMgr:ReqFriendBriefData(type,uid_list)
end

function UIFriendListCtr:FollowPlayer(uid)
	FriendDataMgr:AddFriendReq(uid)
end

function UIFriendListCtr:UnfollowPlayer(uid)
	FriendDataMgr:DeleteFriendReq(uid)
end

function UIFriendListCtr:RemoveBlackPlayer(uid)
	FriendDataMgr:RemoveBlackReq(uid)
end

function UIFriendListCtr:ChatToPlayer(uid,nickName,headId, jobId, level,sex)
	ManagerContainer.LuaUIMgr:PrivateChatOtherPlayer(uid,nickName,headId, jobId, level,sex)
end

function UIFriendListCtr:ShowPlayerInfo(uid)
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end


function UIFriendListCtr:CleanRedPoint()
	FriendDataMgr:CleanRedPoint()
end

return UIFriendListCtr

