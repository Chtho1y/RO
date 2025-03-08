local LuaModelMgr = class("LuaModelMgr", function()
    return ModelMgr.Instance
end)

function LuaModelMgr:ctor()
    
end 

function LuaModelMgr:Destroy()
    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end

return LuaModelMgr