local RedPointMgr = class("RedPointMgr")

function RedPointMgr:ctor()
    self.HeroRPCtr = require("HeroRPCtr"):new()
    self.PetRPCtr = require("PetRPCtr"):new()
    self.RSLimitGiftRPCtr = require("RSLimitGiftRPCtr"):new()
end

function RedPointMgr:Init()
    for _,v in pairs(self) do
        if iskindof(v, "RPBase") then
            if v.Init then
                v:Init()
            end
        end
    end
end

function RedPointMgr:Destroy()
    for k,v in pairs(self) do
        if iskindof(v, "RPBase") then
            if v.Dispose then
                v:Dispose()
            end
        end
        self[k] = nil
    end

    if tolua.getpeer(self) ~= nil then
		  tolua.setpeer(self, nil)
    end
end

return RedPointMgr