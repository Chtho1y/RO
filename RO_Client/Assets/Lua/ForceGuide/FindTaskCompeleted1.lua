local FindTaskCompeleted1 = class("FindTaskCompeleted1", require("ForceGuide/ForceGuideBase"))

function FindTaskCompeleted1:ctor(data)

end

function FindTaskCompeleted1:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local battleView = page.MLuaTable
    battleView:FindTaskCompeleted1(tonumber(param), self, self.EnterCallBack)
end

function FindTaskCompeleted1:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return FindTaskCompeleted1