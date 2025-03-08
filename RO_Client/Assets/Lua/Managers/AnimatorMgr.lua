local AnimatorMgr = class("AnimatorMgr")

function AnimatorMgr:ctor()

end 

function AnimatorMgr:PlayUIAni(animator, name, inter, cb)
  animator:Play(name)
  if inter ~= nil then
    return ManagerContainer.LuaTimerMgr:AddLuaTimer(inter, 1, function(sequence, param)
      cb()
    end, nil)
  else
    if cb ~= nil then
      cb()
    end
  end
end 

function AnimatorMgr:Destroy()
  if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
  end
end
return AnimatorMgr