local BagCardInsert = class("BagCardInsert", require("ForceGuide/ForceGuideBase"))

function BagCardInsert:ctor(data)

end

function BagCardInsert:Enter(forceView, uiId, param, cb)
    self.wnd = forceView
    self.cb = cb

    local page = ManagerContainer.LuaUIMgr:GetPage(uiId)
    if page == nil then
        self.cb(self.wnd, true)
        return
    end

    --TODO
    local cardEquipListView = page.MLuaTable
    cardEquipListView:BagCardInsert(self, self.EnterCallBack)
end

function BagCardInsert:EnterCallBack(target)
    if self.wnd and self.cb then
        if target == nil then
            self.cb(self.wnd, true)
        else
            self.cb(self.wnd, false, target)
        end
    end
end

return BagCardInsert