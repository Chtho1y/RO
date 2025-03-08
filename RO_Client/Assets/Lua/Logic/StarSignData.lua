local StarSignData = class("StarSignData", require("DataBase"))

function StarSignData:ctor()
    self.activeList = {}
    self.currScore = 0
    self.nextLevelScore = 0
    self.lastLevelScore = 0
    self.target = 0
	self.light = false
    self.activeCount = 0
end

function StarSignData:InitData(data)

end

function StarSignData:SendStarInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_STAR_INFO_REQ)
end

function StarSignData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_STAR_DIVINE_ACK,self.OnStarRewardChange,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_STAR_CLOSE_REWARD_ACK,self.OnStarRewardRefresh,self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_COMPETITION_STAR_INFO_ACK,self.OnStarRewardInitInfo,self)
end

function StarSignData:GetStarTargetData()
    return  self.target or 0
end

function StarSignData:OnStarRewardInitInfo(data)
    local stars = data.stars
    if stars then
        self.activeList = {}
        self.activeCount = #stars
        for i = 1, #stars do
            local tempData = stars[i]
            self.activeList[tempData] = tempData
        end
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STAR_SIGN_INIT)
end

function StarSignData:OnStarRewardRefresh(data)
    self.activeList = {}
    self.activeCount = 0
    if data.reward_list and #data.reward_list > 0 then
		local rewards = {}
		for key, value in pairs(data.reward_list) do
			table.insert(rewards,{cfgId = value.key, num = value.value})
		end
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot,{rewards = rewards})
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STAR_SIGN_INIT)
end

function StarSignData:GetStarActiveCount()
    return self.activeCount or 0
end

function StarSignData:GetStarActiveListData()
    return self.activeList or nil
end
function StarSignData:GetStarActiveLightData()
    return self.light or false
end

function StarSignData:OnStarRewardChange(data)
    local stars = data.stars
    if stars then
		self.activeList = {}
        self.activeCount = #stars
        for i = 1, #stars do
            local tempdata = stars[i]
            self.activeList[tempdata] = tempdata
        end
    end
    self.target = data.star
	self.light  = data.light
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.STAR_SIGN_CHANGE)
end


function StarSignData:Clear()
    self.activeList = nil
    self.currScore = nil
    self.nextLevelScore = nil
    self.lastLevelScore = nil
    self.target = nil
	self.light = nil
    self.activeCount = nil
end

function StarSignData:Destroy()
    if self.Clear then
        self:Clear()
    end
    self:UnRegisterNetEvents()
end

function StarSignData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_STAR_DIVINE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_STAR_CLOSE_REWARD_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_COMPETITION_STAR_INFO_ACK)
end

return StarSignData