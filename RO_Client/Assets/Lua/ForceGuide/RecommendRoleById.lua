local RecommendRoleById = class("RecommendRoleById", require("ForceGuide/ForceGuideBase"))

function RecommendRoleById:ctor(data)

end

function RecommendRoleById:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local roleMainView = page.MLuaTable
    roleMainView:RecommendRoleById(tonumber(param), self, self.EnterCallBack)
end

function RecommendRoleById:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return RecommendRoleById