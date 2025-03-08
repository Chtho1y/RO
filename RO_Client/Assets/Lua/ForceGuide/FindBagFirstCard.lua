local FindBagFirstCard = class("FindBagFirstCard", require("ForceGuide/ForceGuideBase"))

function FindBagFirstCard:ctor(data)

end

function FindBagFirstCard:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local bagView = page.MLuaTable
    bagView:FindBagFirstCard(self, self.EnterCallBack)
end

function FindBagFirstCard:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return FindBagFirstCard