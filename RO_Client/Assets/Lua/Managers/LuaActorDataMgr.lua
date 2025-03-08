local LuaActorDataMgr = class("LuaActorDataMgr", function()
    return ActorDataMgr.Instance
end)

function LuaActorDataMgr:ctor()
    
end 

function LuaActorDataMgr:RegisterAllDataEvents()

end

function LuaActorDataMgr:ClearAllData()

end

function LuaActorDataMgr:SetPartnerStep(uid,cfgId, step)
    local partnerData = self:GetFellowActorData(uid,cfgId)
    partnerData:SetStep(step)
end

function LuaActorDataMgr:Destroy()

    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end
return LuaActorDataMgr