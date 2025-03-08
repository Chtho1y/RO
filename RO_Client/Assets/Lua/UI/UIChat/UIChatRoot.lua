local UIChatRoot = class("UIChatRoot")
local NickNameCtr = require("Common/NickNameCtr")

local regexPattern = "%[e%d+%]"
local sendCd,sendCdList

function UIChatRoot:ctor()
    local sendCdCfg =  GlobalConfig.Instance:GetConfigStrValue(90)
    local list = CommonUtil.DeserializeGlobalStrToNumberTable(sendCdCfg)
    sendCdList = list[1]
    if ManagerContainer.PayMgr:GetTotalRecharge() > 0 then
        sendCd = sendCdList[2]
    else
        sendCd = sendCdList[1]
    end
end
function UIChatRoot:OnPayTotalRechargeChanged()
    if ManagerContainer.PayMgr:GetTotalRecharge() > 0 then
        sendCd = sendCdList[2]
    else
        sendCd = sendCdList[1]
    end
end

function UIChatRoot:Init(root, channelType, window, inputField, bgOpeCB,isNewChat)
    self.root = root
    if isNewChat then
        self.tempViewLua = root.viewLua
    else
        self.tempViewLua = root
    end
    self.channelType = channelType
    self.window = window
    self.inputField = inputField
    self.bgOpeCB = bgOpeCB

    self.canSend = true
    self:InitPanel()
    self.tempViewLua.funcbg:SetActive(false)
    self:AddEventListener()
end

function UIChatRoot:InitPanel()
    local loopGridViewInitParam = SuperScrollView.LoopGridViewInitParam.CopyDefaultInitParam()
    loopGridViewInitParam.mSnapVecThreshold = 9999

    local datas = self:GetDatas()
    local max = datas and #datas or 0
    self.window.loopListView:InitListView(max, function(gridView, itemIndex)
        return self:RefreshChats(gridView, itemIndex)
    end)

    self:RefreshInputStatus()
    self.window.loopListView:MovePanelToItemIndex(max, 0)
end

function UIChatRoot:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.root.uiData.name, UIEventNames.REFRESH_WOLRD_CHAT, self, self.OnRefreshChat)
    ManagerContainer.LuaEventMgr:RegisterUIEvent(self.root.uiData.name, UIEventNames.PAY_TOTAL_RECHARGE_CHANGED, self, self.OnPayTotalRechargeChanged)
end

function UIChatRoot:OnRefreshChat(channelType)
    if self.channelType ~= channelType then return end
    self:RefreshWindow(true)
end

function UIChatRoot:GetChannelType()
    return self.channelType
end

function UIChatRoot:SetChannelType(channelType, forceRefresh)
    if self.channelType == channelType and not forceRefresh then return end
    self.channelType = channelType
    self.window.loopListView:SetListItemCount(0, false)
    self:RefreshWindow(true)
end

function UIChatRoot:RefreshWindow(resetPos)
    if not self.root.uiBase.IsActive then return end

    local datas = self:GetDatas()
    local max = datas and #datas or 0
    self.window.loopListView:SetListItemCount(max, false)
    if self.beginDrag then return end

    self:RefreshInputStatus()
    if resetPos then
        self.window.loopListView:MovePanelToItemIndex(max, 0)
    else
        --self.window.loopListView:RefreshAllShownItem()
    end
end

function UIChatRoot:RefreshInputStatus()
    if self.inputField then
        if self.channelType ~= Enum.ChatChannel.System then
            self.window.loopListView.ScrollRect.viewport.sizeDelta = Vector2(0, -150)
            self.root.input:SetActive(true)
            self.window.loopListView:ResetListView(false)
        else
            self.window.loopListView.ScrollRect.viewport.sizeDelta = Vector2.zero
            self.root.input:SetActive(false)
        end
    end
end

function UIChatRoot:GetDatas()
    if self.channelType == Enum.ChatChannel.World then
        return ManagerContainer.DataMgr.ChatData:GetWorldChatDatas()
    elseif self.channelType == Enum.ChatChannel.System then
        return ManagerContainer.DataMgr.ChatData:GetSystemDatas()
    elseif self.channelType == Enum.ChatChannel.Guild then
        return ManagerContainer.DataMgr.ChatData:GetGuildChatDatas()
    end
    return nil
end

function UIChatRoot:RefreshChats(gridView, itemIndex)
    local datas = self:GetDatas()
    if not datas then return nil end
    local logicData = datas[itemIndex + 1]
    if not logicData then return nil end

    local item = gridView:NewListViewItem(Enum.PrefabNames.ChatTextItem)
    item.gameObject.name = itemIndex
    local itemLua = CommonUtil.BindGridViewItem2Lua(self.root, Enum.PrefabNames.ChatTextItem, item.gameObject)
    if logicData.isSystem then
        CommonUtil.UpdateItemPrefab(self.root, itemLua, logicData, Enum.ItemIEnterType.System)
    else
        CommonUtil.UpdateItemPrefab(self.root, itemLua, logicData, Enum.ItemIEnterType.WorldChat, self, self.OnTargetSelected)
    end
    return item
end

function UIChatRoot:OnTargetSelected(button, params)
    local playerHead = params[0]
    self.curSelectedData = params[1]

    local userUid = ManagerContainer.DataMgr.UserData:GetUserId()
    if self.curSelectedData.uid == tostring(userUid) then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
        self.curSelectedData = nil
    end
    if self.curSelectedData == nil then return end

    local position = CommonUtil.LocalUIPos2ScreenPos(playerHead.transform.position)

    local isLeft = position.x < UnityEngine.Screen.width/2
    local isBottom = position.y < UnityEngine.Screen.height/2

    position.x = position.x + self.tempViewLua.headOrder.rectTransform.sizeDelta.x/2 - UnityEngine.Screen.width/2
    local sizeY = self.tempViewLua.headOrder.rectTransform.sizeDelta.y/2
    if isBottom then
        position.y = position.y + (sizeY > 0 and sizeY or 246) - UnityEngine.Screen.height/2
    else
        position.y = position.y - (sizeY > 0 and sizeY or 246) - UnityEngine.Screen.height/2
    end
    self.tempViewLua.headOrder.rectTransform.anchoredPosition3D = position

    self:RefreshFuncBg()
    self.tempViewLua.funcbg:SetActive(true)
    if self.root.uiview and self.root.uiview.dragBg  then
        self.root.uiview.dragBg:SetActive(false)
    end
end

function UIChatRoot:RefreshFuncBg()
    local friendState = ManagerContainer.DataMgr.FriendDataMgr:HasInterestPlayer(int64.new(self.curSelectedData.uid))
    self.tempViewLua.btnAddFriend.text.text.text = friendState and I18N.T("RemoveFriends") or I18N.T("AddFriends")

    local blockState = ManagerContainer.DataMgr.FriendDataMgr:HasBlackPlayer(int64.new(self.curSelectedData.uid))
    self.tempViewLua.btnBlock.text.text.text = blockState and I18N.T("RemoveBlackList") or I18N.T("AddBlackList")
end

function UIChatRoot:AddUIEventListener()

    if self.window.uIEventTriggerListener then
        self.window.uIEventTriggerListener.onClick = function()
            if self.tempViewLua.OnBtnClose then
                self.tempViewLua:OnBtnClose()
            end
            if self.bgOpeCB then
                self.bgOpeCB(self.root)
            end
        end
        self.window.uIEventTriggerListener.onBeginDrag = function()
            self.beginDrag = true
        end

        self.window.uIEventTriggerListener.onEndDrag = function()
            if self.bgOpeCB then
                self.bgOpeCB(self.root)
            end
        end

        self.window.uIEventTriggerListener.onPointerUp = function()
            self.beginDrag = false
        end
        self.window.uIEventTriggerListener.onPointerExit = function()
            self.beginDrag = false
        end
    end

    if self.tempViewLua.btnPrivateChat then
        self.root.uiBase:AddButtonUniqueEventListener(self.tempViewLua.btnPrivateChat.button,self, self.OnPrivateChat)
    end
    if self.tempViewLua.funcbg then
        self.root.uiBase:AddButtonUniqueEventListener(self.tempViewLua.funcbg.button, self, self.OnCloseFuncBg)
    end
    if self.tempViewLua.btnInfor then
        self.root.uiBase:AddButtonUniqueEventListener(self.tempViewLua.btnInfor.button, self,self.OnPlayerQuery)
    end
    if self.tempViewLua.btnAddFriend then
        self.root.uiBase:AddButtonUniqueEventListener(self.tempViewLua.btnAddFriend.button, self, self.AddFriend)
    end
    if self.tempViewLua.btnBlock then
        self.root.uiBase:AddButtonUniqueEventListener(self.tempViewLua.btnBlock.button, self, self.AddBlack)
    end

    if self.inputField then
        self.inputField.inputField.onValueChanged:RemoveAllListeners()
        self.root.uiBase:AddInputFileEventListener(self.inputField.inputField, function(input, content)
            self:OnInputChanged(content)
        end)
    end
    if self.tempViewLua.btnSend then
        self.root.uiBase:AddButtonUniqueEventListener(self.tempViewLua.btnSend.button,self, self.OnSendClick)
    end
end

function UIChatRoot:OnInputChanged(content)
    local temp = content
    --local length = StringUtil.GetTextLeng(self.inputField.inputField.textComponent, temp)
    if string.len(temp) > Constant.CHAT_BYTE_LIMIT then
        temp = string.sub(temp, 0, Constant.CHAT_BYTE_LIMIT)
    end
    temp = string.gsub(temp, "#", "")
    --temp = string.gsub(temp, "#h", "")
    --temp = string.gsub(temp, "#t", "")
    --temp = string.gsub(temp, "#c", "")
    temp = StringUtil.FilterEmoji(temp)

    self.inputField.inputField.text = temp
end

function UIChatRoot:OnPrivateChat(button, params)
    self.tempViewLua.funcbg:SetActive(false)
    if self.curSelectedData == nil then return end

    ManagerContainer.LuaUIMgr:PrivateChatOtherPlayer(self.curSelectedData.uid, self.curSelectedData.nickname, self.curSelectedData.imgId, self.curSelectedData.jobId, self.curSelectedData.level, self.curSelectedData.sex)
end

function UIChatRoot:OnCloseFuncBg(button, params)
    self.tempViewLua.funcbg:SetActive(false)
end

function UIChatRoot:OnPlayerQuery()
    ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(self.curSelectedData.uid);
    self.tempViewLua.funcbg:SetActive(false)
end

function UIChatRoot:AddFriend()
    if self.curSelectedData and self.curSelectedData.uid then
        local friendState = ManagerContainer.DataMgr.FriendDataMgr:HasInterestPlayer(int64.new(self.curSelectedData.uid))
        if friendState then
            ManagerContainer.DataMgr.FriendDataMgr:DeleteFriendReq(int64.new(self.curSelectedData.uid))
        else
            ManagerContainer.DataMgr.FriendDataMgr:AddFriendReq(int64.new(self.curSelectedData.uid))
        end
    end

    self:OnCloseFuncBg()
end

function UIChatRoot:AddBlack()
    if self.curSelectedData and self.curSelectedData.uid then
        local blockState = ManagerContainer.DataMgr.FriendDataMgr:HasBlackPlayer(int64.new(self.curSelectedData.uid))
        if blockState then
            ManagerContainer.DataMgr.FriendDataMgr:RemoveBlackReq(int64.new(self.curSelectedData.uid))
        else
            ManagerContainer.DataMgr.FriendDataMgr:AddBlackReq(int64.new(self.curSelectedData.uid))
        end
    end
    self:OnCloseFuncBg()
end

function UIChatRoot:OnSendClick(button, params)
    if  self.tempViewLua.emojiWindow and self.tempViewLua.emojiWindow.activeSelf then
        self.root:OnEmojiBgClick()
    end

    local _openCreateName = NickNameCtr:NeedOpenCreate()
    if _openCreateName then
        NickNameCtr:OpenNickNamePage(true);
        return;
    end

    if not self.canSend then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatFast")
        return
    end

    local emojis = ManagerContainer.CfgMgr:GetEmojiCfg()
    for k, v in string.gmatch(self.inputField.inputField.text, regexPattern) do
        local num = tonumber(string.match(k, '%d+'))
        if num >= #emojis then
            self.inputField.inputField.text = string.gsub(self.inputField.inputField.text, k, "")
        end
    end
    if self.inputField.inputField.text == "[]" then
        self.inputField.inputField.text = ""
    end

    if self.inputField.inputField.text == "" then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatContentEmpty")
        return
    end
    local chatDataType, sdkChatType = self:GetChatDataType()
    if not chatDataType then
        self.inputField.inputField.text = ""
        return
    end
    
    local content = self.inputField.inputField.text
    local level = ManagerContainer.DataMgr.UserData:GetRoleLv()
    if SDKMgr.Instance:CheckSpeech(level, sdkChatType, content) then
        self:StartSendCD()
        self.root.controller:SendChatReq(content, chatDataType)
        self.inputField.inputField.text = ""
        self:ReportChat(true)
    else
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShieldTips01")
    end
end

function UIChatRoot:ReportChat(success)
    if not SDKMgr.Instance:IsReportAction() then
        return
    end
    local datas = System.Collections.Generic.Dictionary_object_object()
    datas:Add('event', 'mj_speak')
    datas:Add('is_achieve', (success and 1 or 0))
    SDKMgr.Instance:ReportAction(datas)
end

function UIChatRoot:GetChatDataType()
    if self.channelType == Enum.ChatChannel.World then
        return Enum.ChatDataType.World, ChannelType.WORLD
    elseif self.channelType == Enum.ChatChannel.Guild then
        return Enum.ChatDataType.Guild, ChannelType.GUILD
    end
    return nil
end

function UIChatRoot:StartSendCD()
    self.canSend = false
    if self.sendCDTimer then
        self.sendCDTimer.time = sendCd
    else
        self.sendCDTimer = Timer.New(function()
            self.canSend = true
        end, sendCd)
    end
    if not self.sendCDTimer.running then
        self.sendCDTimer:Start()
    end
end

function UIChatRoot:Dispose()
    if self.inputField then
        self.inputField.inputField.onValueChanged:RemoveAllListeners()
    end
    self.beginDrag = false
    self.canSend = true
    self.curSelectedData = nil

    if self.sendCDTimer then
        self.sendCDTimer:Stop()
    end

    if self.window.uIEventTriggerListener then
        self.window.uIEventTriggerListener.onClick = nil
        self.window.uIEventTriggerListener.onBeginDrag = nil
        self.window.uIEventTriggerListener.onPointerUp = nil
        self.window.uIEventTriggerListener.onPointerExit = nil
        self.window.uIEventTriggerListener.onEndDrag = nil
    end
    self.window.loopListView:Dispose()

    self.bgOpeCB = nil
    self.root = nil
    self.type = nil
    self.window = nil
    self.inputField = nil
end

return UIChatRoot