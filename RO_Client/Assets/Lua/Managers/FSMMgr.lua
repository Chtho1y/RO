local FSMMgr = class("FSMMgr")

function FSMMgr:ctor()
    self.currentState = nil
    self.fakeState = nil
    self.stateDic = {}
end

function FSMMgr:RegisterStates()
    for k,v in pairs(Enum.StateEnum) do
        local state = require(k):new(v.name, v.stateId)
        self:AddState(state)
    end
end

function FSMMgr:GetCurrentState()
    return self.currentState
end

function FSMMgr:AddState(state)
    self.stateDic[state.stateId] = state
end
  
function FSMMgr:ChangeState(stateId, ...)
    local newState = self.stateDic[stateId]
    Log("FSMMgr:ChangeState   "..newState:GetStateName())
    if self.fakeState then
        self.fakeState:Exit()
        self.fakeState = nil
    end

    if not newState:IsFake() and self.currentState then
        self.currentState:Exit()
    end

    if newState:IsFake() then
        self.fakeState = newState
        if self.currentState.FakeExit then
            self.currentState:FakeExit();
        end
    else
        self.currentState = newState
    end

    newState:Enter(...)
end

function FSMMgr:GetState(stateId)
    local newState = self.stateDic[stateId]
    return newState
end

function FSMMgr:Update()
    if self.fakeState then
        self.fakeState:Update()
    end
    if self.currentState then
        self.currentState:Update()
    end
end

function FSMMgr:Destroy()
    self.currentState = nil
    self.fakeState = nil
    self.stateDic = {}

    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end

function FSMMgr:IsLoginState()
    return self.currentState.stateId == Enum.StateEnum.LoginState.stateId;
end

function FSMMgr:IsLoadingState()
    return self.currentState.stateId == Enum.StateEnum.LoadingState.stateId;
end

function FSMMgr:IsBattleState()
    return self.currentState.stateId == Enum.StateEnum.BattleState.stateId;
end

function FSMMgr:IsGuildLobbyState()
    return self.currentState.stateId == Enum.StateEnum.GuildLobbyState.stateId;
end

function FSMMgr:IsIdleState()
    return self.currentState.stateId == Enum.StateEnum.IdleState.stateId;
end

function FSMMgr:IsDojoState()
    return self.currentState.stateId == Enum.StateEnum.DojoState.stateId;
end

function FSMMgr:IsBossBattleState()
    return self.currentState.stateId == Enum.StateEnum.BossBattleState.stateId
end

function FSMMgr:IsCreateRoleState()
    return self.currentState.stateId == Enum.StateEnum.CreateRoleState.stateId
end

function FSMMgr:IsTimeBattleState()
    return self.currentState.stateId == Enum.StateEnum.TimeBattleState.stateId
end

function FSMMgr:IsFightingState()
    return self:IsBattleState() or self:IsDojoState() or self:IsBossBattleState() or self:IsTimeBattleState()
end

return FSMMgr