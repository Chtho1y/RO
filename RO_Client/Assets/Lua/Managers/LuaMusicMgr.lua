local LuaMusicMgr = class("MusicMgr", function()
  return MusicMgr.Instance
end)

function LuaMusicMgr:ctor()

end 

function LuaMusicMgr:Destroy()

    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

return LuaMusicMgr