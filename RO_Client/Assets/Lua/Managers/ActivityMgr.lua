local ActivityMgr = class("ActivityMgr")

function ActivityMgr:ctor()
end

function ActivityMgr:Destroy()
    if tolua.getpeer(self) ~= nil then
        tolua.setpeer(self, nil)
    end
end

return ActivityMgr