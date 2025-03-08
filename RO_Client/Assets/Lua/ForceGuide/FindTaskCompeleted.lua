local FindTaskCompeleted = class("FindTaskCompeleted", require("ForceGuide/ForceGuideBase"))

function FindTaskCompeleted:ctor(data)

end

function FindTaskCompeleted:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local taskView = page.MLuaTable
    taskView:FindTaskCompeleted(tonumber(param), self, self.EnterCallBack)
end

function FindTaskCompeleted:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return FindTaskCompeleted