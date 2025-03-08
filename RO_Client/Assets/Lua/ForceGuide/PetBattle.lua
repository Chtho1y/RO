local PetBattle = class("PetBattle", require("ForceGuide/ForceGuideBase"))

function PetBattle:ctor(data)

end

function PetBattle:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local petBattleView = page.MLuaTable
    petBattleView:PetBattle(self, self.EnterCallBack)
end

function PetBattle:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return PetBattle