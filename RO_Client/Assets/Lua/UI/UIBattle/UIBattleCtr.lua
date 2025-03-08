local UIBattleCtr = class("UIBattleCtr", require("UICtrBase"))

function UIBattleCtr:Init(view)
	self.view = view
end

function UIBattleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end

	self.data = data
end

function UIBattleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIBattleCtr:InitHeroData()
end

function UIBattleCtr:UpToLimit()
	local usedCnt = ManagerContainer.LuaBattleMgr:UsedQuickBattleTimes();
	local maxCnt = ManagerContainer.LuaBattleMgr:MaxQuickBattleTimes();
	return usedCnt >= maxCnt;
end

function UIBattleCtr:IsUnlockQuickBattle()
	local curMapId,curLevelId = ManagerContainer.LuaBattleMgr:GetCurMapAndLevel()
	local curUniqueId  = curMapId * 10000 + curLevelId

	return curUniqueId > GlobalConfig.Instance:GetConfigIntValue(89)
end

function UIBattleCtr:UnlockQuickBattleCondition()
	return  "通关" .. LuaBattleBridge.GetLevelName(GlobalConfig.Instance:GetConfigIntValue(89)) .. "关卡后解锁快速挂机功能"
end

function UIBattleCtr:SendGetMainTaskRewardReq()
	--local curGoalData = ManagerContainer.DataMgr.StageGoalData:GetCurGoalData()
	--ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_MAIN_TASK_REWARD_REQ, {task_id = curGoalData.taskId })
end

function UIBattleCtr:SendPlayerQuery(uid)
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid);
	--[[
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GET_OTHER_PLAYER_DETAIL_INFO_REQ,
			{t_uid = int64.new(uid)})]]--
end


function UIBattleCtr:GeAnchoredPosition3DByType(type)
	if self.view == nil then return nil end

	return self.view:GeAnchoredPosition3DByType(type)
end

function UIBattleCtr:GetMiniMapPosition()
	if self.view == nil then return nil end
	return self.view:GetMiniMapPosition()
end

function UIBattleCtr:GetBattleState()
	if self.view == nil then return nil end
	return self.view:GetBattleState()
end

function UIBattleCtr:SetChatChannelType(type)
	self.curChatType = type
end

function UIBattleCtr:GetChatChannelType()
	self.curChatType = self.curChatType or Enum.ChatChannel.World
	return self.curChatType
end

function UIBattleCtr:SetNewForceId(id)
	self.newForceId = id
end

function UIBattleCtr:GetNewForceId()
	return self.newForceId
end

function UIBattleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBattleCtr

