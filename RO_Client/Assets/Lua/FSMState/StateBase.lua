local StateBase = class("StateBase")

function StateBase:ctor(n, id)
    self.name = n
    self.stateId = id
    self.entered = true;
end

function StateBase:GetTask()  
    return {}
end

function StateBase:IsFake()
    return false
end

function StateBase:GetStateName()
    return self.name
end

function StateBase:IsEntered()
    return self.entered
end

function StateBase:Enter()  
    print(string.format("%s enter", self.name))  
end

function StateBase:Update()  
    print(string.format("%s enter", self.name))  
end

function StateBase:Exit()  
    print(string.format("%s exit", self.name))  
end  

return StateBase