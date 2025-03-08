local PartnerLvUpById = class("PartnerLvUpById", require("ForceGuide/ForceGuideBase"))

function PartnerLvUpById:ctor(data)

end

function PartnerLvUpById:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local roleMainView = page.MLuaTable
    roleMainView:PartnerLvUpById(tonumber(param), self, self.EnterCallBack)
end

function PartnerLvUpById:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return PartnerLvUpById