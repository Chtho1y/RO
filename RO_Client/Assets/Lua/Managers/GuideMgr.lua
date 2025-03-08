local GuideMgr = class("GuideMgr")

function GuideMgr:ctor()
    --ManagerContainer.LuaEventMgr:RegisterUIEvent("GuideMgr", UI_FILLCONTENT_COMPELETED, function (wnd)
    --
    --end)
end

function GuideMgr:Destroy()

    
    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

return GuideMgr