local VipChangeMgr = class('VipChangeMgr')

function VipChangeMgr:ctor()
    self.changeLv = nil
    self.changeExp = nil
    self:RegisterEvent()
end

function VipChangeMgr:Clear()
    self.changeLv = nil
    self.changeExp = nil
end

function VipChangeMgr:Destroy()
    self.changeLv = nil
    self.changeExp = nil
    self:UnRegisterEvent()
end

function VipChangeMgr:RegisterEvent()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.VIP_EXP_CHANGED, self, self.OnVipExpChanged)
end

function VipChangeMgr:UnRegisterEvent()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.VIP_LV_CHANGED, self, self.OnVipLvChanged)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.VIP_EXP_CHANGED, self, self.OnVipExpChanged)
end

function VipChangeMgr:OnVipLvChanged(lv, newLv)
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIVipLvUp) then
        if not self.changeLv then
            self.changeLv = {lv, newLv}
        else
            if self.changeLv[1] > lv then
                self.changeLv[1] = lv
            end
            if self.changeLv[2] < newLv then
                self.changeLv[2] = newLv
            end
        end
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVipLvUp, {lv, newLv})
    end
end

function VipChangeMgr:OnVipExpChanged(newLv, exp, newExp)
    if ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIVipExpTips) then
        if not self.changeExp then
            self.changeExp = {newLv, exp, newExp}
        else
            if self.changeExp[1]  < newLv then
                self.changeExp[1] = newLv
            end
            if self.changeExp[2] > exp then
                self.changeExp[2] = exp
            end
            if self.changeExp[3] < newExp then
                self.changeExp[3] = newExp
            end
        end
    else
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVipExpTips, {newLv, exp, newExp})
    end
end

function VipChangeMgr:GetNextChangeLv()
    local lvData = self.changeLv
    self.changeLv = nil
    return lvData
end

function VipChangeMgr:GetNextChangeExp()
    local expData = self.changeExp
    self.changeExp = nil
    return expData
end

return VipChangeMgr