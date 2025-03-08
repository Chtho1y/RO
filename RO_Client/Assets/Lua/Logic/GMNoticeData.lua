local GMNoticeData = class("GMNoticeData", require("DataBase"))
local ProtocalDataNormal = require("ProtocalDataNormal")


function GMNoticeData:ctor()
    self.data = {}

end

function GMNoticeData:AddNewNotice(data)
    self.data.curNotice = ProtocalDataNormal.ParseGMNoticeData(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GM_SCROLL_NOTICE)
end

function GMNoticeData:NilCurNotice()
    self.data.curNotice = nil
end

function GMNoticeData:GetCurNotice()
    return self.data.curNotice
end

function GMNoticeData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_WEB_GM_NOTICE_NTF, function(data)
        self:AddNewNotice(data.notice_info)
    end)
end

function GMNoticeData:Save()

end

function GMNoticeData:Clear()
    self.data = {}
end

function GMNoticeData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function GMNoticeData:UnRegisterNetEvents()

end

return GMNoticeData