local FindSkillTargetById = class("FindSkillTargetById", require("ForceGuide/ForceGuideBase"))

function FindSkillTargetById:ctor(data)

end

function FindSkillTargetById:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local skillSettingView = page.MLuaTable
    skillSettingView:FindSkillItemById(tonumber(param), self, self.EnterCallBack)
end

function FindSkillTargetById:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return FindSkillTargetById