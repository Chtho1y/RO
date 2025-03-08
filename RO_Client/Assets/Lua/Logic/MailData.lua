local MailData = class("MailData", require("DataBase"))
local BitUtil = require("BitUtil")

function MailData:ctor()
    self.data = {}
end

function MailData:InitMailData(mailData)
    if mailData == nil then return end

    self.data.mailCount = mailData.total_mail_count
    if self.data.mailDatas == nil then
        self.data.mailDatas = {}
    end

    for _,v in pairs(mailData.mail_list) do
        local data = ProtocalDataNormal.ParseMailContentData(v)
        local mail = self:GetMailDataById(data.id)
        if mail == nil then
            self.data.mailDatas[#self.data.mailDatas + 1] = data
        else
            mail = data
        end

        data.newState = 1 - BitUtil.ParseMailReadState(data.state)
    end

    CommonUtil.ArraySortSelections(self.data.mailDatas, Enum.TableSortRule.Down, "newState", "id")
    self:HasNewMail()
    --local data = {}
    --data.state = Enum.MailStateEnum.NO_OPEN
    --data.title = "haha"
    --data.content = "1123123"
    --self.data.mailDatas[#self.data.mailDatas + 1] = data
    --
    --data = {}
    --data.state = Enum.MailStateEnum.NO_OPEN_NO_RECEIVE
    --data.title = "haha1"
    --data.content = "1231242342345345"
    --data.awards = {{key = 1, value = 100} , {key = 2, value = 200}, {key = 3, value = 300}}
    --self.data.mailDatas[#self.data.mailDatas + 1] = data
end

function MailData:QueryMailData()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_MAIL_LIST_REQ, {})
end

function MailData:HasNewMail()
    local newMail = false
    for _,v in pairs(self.data.mailDatas) do
        newMail = BitUtil.ParseMailReadState(v.state) == 0
        if newMail then
            break
        end
    end

    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.NewMail, newMail)
    return newMail
end

function MailData:GetMailDatas()
    return self.data.mailDatas
end

function MailData:GetMailTotalCount()
    return self.data.mailCount
end

function MailData:GetMailDataById(id)
    for k,v in pairs(self.data.mailDatas) do
        if id == v.id then
            return v, k
        end
    end
    return nil
end

function MailData:RefreshMailDatas(datas)
    self.data.mailCount = datas.total_mail_count

    if self.data.mailDatas == nil then
        self.data.mailDatas = {}
    end

    for _,v in pairs(datas.add_mail_list) do
        local data = ProtocalDataNormal.ParseMailContentData(v)
        self.data.mailDatas[#self.data.mailDatas + 1] = data

        data.newState = 1 - BitUtil.ParseMailReadState(data.state)
    end

    for _,v in pairs(datas.mail_state_list) do
        local mail = self:GetMailDataById(v.key)
        if mail then
            mail.state = v.value
            mail.newState = 1 - BitUtil.ParseMailReadState(mail.state)
        end
    end

    for _,v in pairs(datas.del_mail_list) do
        local mail, k = self:GetMailDataById(v)
        table.remove(self.data.mailDatas, k)
    end

    CommonUtil.ArraySortSelections(self.data.mailDatas, Enum.TableSortRule.Down, "newState", "id")

    self:HasNewMail()

end

function MailData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAIL_LIST_ACK, function(data)
        self:InitMailData(data)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_MAILS, true)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAIL_CHANGE_NTF, function(data)
        self:RefreshMailDatas(data)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_MAILS, true)
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAIL_READ_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            self:HasNewMail()
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.READ_MAIL)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAIL_REWARD_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            CommonUtil.ACKShowRewardList(data.reward_list)
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REWARD_MAIL, true)
        end
    end)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_MAIL_DEL_READ_ACK, function(data)
        if data.error == Enum.NetErrorCode.ERROR_OK then
            --ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.REFRESH_MAILS, true)
        end
    end)
end

function MailData:Clear()
    self.data = {}
end

function MailData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function MailData:UnRegisterNetEvents()

end

return MailData