local HeadFrameDataMgr = class("HeadFrameDataMgr", require("DataBase"))
local HeadFrameData = require("HeadFrame/HeadFrameData")

function HeadFrameDataMgr:ctor()
    self._allFrameData = nil;
    self.bInited = false
end

function HeadFrameDataMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_CHANGE_HEAD_FRAME_ACK,self.OnChangeHeadFrameAck, self);
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HEAD_FRAME_CHANGE_NTF,self.OnHeadFrameChangeNtf, self);
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_HEAD_FRAME_INFO_ACK,self.OnHeadFrameInfoAck, self);
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_USE_HEAD_FRAME_ITEM_ACK,self.OnUseHeadFrameItemAck, self);

    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_HeadFrame_RP, self, self.OnRefreshHeadFrameRP)
end

function HeadFrameDataMgr:Clear()
    self._allFrameData = nil;
    self.bInited = false
end

function HeadFrameDataMgr:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function HeadFrameDataMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CHANGE_HEAD_FRAME_ACK);
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_HEAD_FRAME_CHANGE_NTF);
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_HEAD_FRAME_INFO_ACK);
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_USE_HEAD_FRAME_ITEM_ACK);

    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_HeadFrame_RP, self, self.OnRefreshHeadFrameRP)
end

function HeadFrameDataMgr:InitData(serverData)
    if self.bInited then
        return
    end

    local _allHeadFrameDataOriginal = ManagerContainer.CfgMgr:GetAllHeadFrameData();
    self._allFrameData = {};
    for _k, _v in pairs(_allHeadFrameDataOriginal) do
        if Constant.OpenPay  or not _v.NoPay then
            self._allFrameData[#self._allFrameData+1] = HeadFrameData:new(_v)
        end
    end

    if serverData ~= nil then
        --头像框列表
        if serverData.head_frame_list ~= nil then
            for i = 1, #serverData.head_frame_list do
                local frame = self:GetHeadFrameById(serverData.head_frame_list[i].head_frame_id)
                if frame ~= nil then
                    frame:SyncServerData(serverData.head_frame_list[i].head_frame_time)
                    frame:SetFrameState(Enum.HeadFrameState.GotFrame)
                end
            end
        end
    end

    self:SortFrame()
    self:ReadRedPointData()
    self.bInited = true
end

function HeadFrameDataMgr:UseHeadFrameItem(itemUid,headFrameId,cnt)
    local headFrame = self:GetHeadFrameById(headFrameId)
    if headFrame == nil then
        self:SendUseHeadFrameReq(itemUid,cnt)
    elseif headFrame:IsOwned() and headFrame:IsForever() then
        local cost = headFrame.resolveCost * cnt
        ManagerContainer.LuaUIMgr:ShowMessageBox("ConvertHeadFrame",{headFrame.name,cost},{itemUid,cnt},self,self.OnConfirmUseHeadFrame,nil)
    else
        self:SendUseHeadFrameReq(itemUid,cnt)
    end
end

function HeadFrameDataMgr:OnConfirmUseHeadFrame(tbl)
    local itemUid = tbl[1]
    local cnt = tbl[2]
    self:SendUseHeadFrameReq(itemUid,cnt)
end

function HeadFrameDataMgr:SendUseHeadFrameReq(id,cnt)
    -- LogError("id = " .. tostring(id) .. " cnt = " .. cnt)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_USE_HEAD_FRAME_ITEM_REQ, {item_id = id,item_num = cnt})
end

function HeadFrameDataMgr:OnUseHeadFrameItemAck(data)
    if data.error == 0 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("HeadFrameUseSuCcess")
    elseif data.error == 462 then
        ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("HeadFrameResolveSuCcess")
    end
end

function HeadFrameDataMgr:SendHeadFrameInfoReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_HEAD_FRAME_INFO_REQ)
end

function HeadFrameDataMgr:OnHeadFrameInfoAck(_data)
    if _data.error ~= Enum.NetErrorCode.ERROR_OK then
        return
    end

    if _data.head_frame ~= nil  then
        for i=1, #_data.head_frame do
            local frame = self:GetHeadFrameById(_data.head_frame[i].head_frame_id)
            if frame ~= nil then
                frame:SyncServerData(_data.head_frame[i].head_frame_time)
            end
        end
    end

    for i = 1, #self._allFrameData do
        local frame = self._allFrameData[i]
        if frame:IsLoss() then
            if ManagerContainer.DataMgr.BagData:GetItemByCfgId(frame.frameId) ~= nil then
                frame:SetFrameState(Enum.HeadFrameState.GotItem)
            end
        end
    end
    
    self:SortFrame()
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIChangeHeadFrame);
end

function HeadFrameDataMgr:OnHeadFrameChangeNtf(_data)
    if _data.head_frame ~= nil then
        for i =1, #_data.head_frame do
            local frame = self:GetHeadFrameById(_data.head_frame[i].head_frame_id)
            if frame ~= nil then
                frame:SyncServerData(_data.head_frame[i].head_frame_time)
                if _data.head_frame[i].head_frame_time == 0 then
                    frame:SetFrameState(Enum.HeadFrameState.Loss)
                else
                    if frame:IsLoss() or frame:IsGot() then
                        frame:SetRedPointStatus(true)
                    end
                    frame:SetFrameState(Enum.HeadFrameState.GotFrame)
                end
            end
        end
    end

    self:SortFrame()
    self:SaveRedPointData()
    ManagerContainer.DataMgr.UserData:InitHeroAttrFromBattle()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HEAD_FRAME_CHANGE)
end

function HeadFrameDataMgr:SendChangeHeadFrameReq(frameId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CHANGE_HEAD_FRAME_REQ, { head_frame_id = frameId })
end

function HeadFrameDataMgr:OnChangeHeadFrameAck(_data)
    if _data.error ~= Enum.NetErrorCode.ERROR_OK then
        return
    end

    local _oldId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();
    local oldFrame = self:GetHeadFrameById(_oldId)
    if oldFrame ~= nil then
        oldFrame:SetFrameState(Enum.HeadFrameState.GotFrame)
    end

    ManagerContainer.DataMgr.UserData:SetHeadFrameId(_data.head_frame_id)
    self:SortFrame()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.HEAD_FRAME_CHANGE)
end

function HeadFrameDataMgr:GetHeadFrameById(headFrameId)
    if self._allFrameData == nil then
        return nil
    end

    for i=1, #self._allFrameData do
        local frame = self._allFrameData[i]
        if frame.frameId == headFrameId then
            return frame
        end
    end
    return nil
end

--获取头像框的数据
function HeadFrameDataMgr:GetAllHeadFrames()
    return self._allFrameData;
end

function HeadFrameDataMgr:HasNewHeadFrame()
    if self._allFrameData == nil then
        return false
    end

    for i=1, #self._allFrameData do
        if self._allFrameData[i].redPointState then
            return true
        end
    end

    return false
end

function HeadFrameDataMgr:OnRefreshHeadFrameRP()
    local hasRP = self:HasNewHeadFrame()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.RED_POINT_MGR_NOTICE, Enum.RPNotifyType.HeadFrame, hasRP)
end

function HeadFrameDataMgr:SaveRedPointData()
    local rpStr = ""
    for i=1, #self._allFrameData do
        local frame = self._allFrameData[i]
        local rpFlag = 0
        if frame.redPointState then
            rpFlag = 1
        end
        if i < #self._allFrameData then
            rpStr = rpStr .. frame.frameId .. ":" .. rpFlag .. ";"
        else
            rpStr = rpStr .. frame.frameId .. ":" .. rpFlag
        end
    end

    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetString(tostring(uid).."_headframesRP",rpStr)
end

function HeadFrameDataMgr:ReadRedPointData()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local headFramesRPStr = UnityEngine.PlayerPrefs.GetString(tostring(uid).."_headframesRP")
    
    if headFramesRPStr ~= nil and headFramesRPStr ~= "" then
        local temp1 = string.split(headFramesRPStr,';')
        if temp1 ~= nil then
            for i =1, #temp1 do
                local temp2 = string.split(temp1[i],':')
                if temp2 ~= nil and #temp2 == 2 then
                    local frame = self:GetHeadFrameById(tonumber(temp2[1]))
                    if frame ~= nil then
                        frame:SetRedPointStatus(tonumber(temp2[2]) > 0)
                    end
                end
            end
        end
    end
end

function HeadFrameDataMgr:CalcAttrs()
    local attrList = {}
    for _,v in pairs(Enum.HeroAttrType) do
        attrList[v] = 0
    end

    if self._allFrameData ~= nil then
		for i=1, #self._allFrameData do
			local frame = self._allFrameData[i]
			if frame:IsOwned() then
				local attrs = frame:GetAttrs()
				if attrs ~= nil then
					for j = 1, #attrs do
						if attrList[attrs[j][1]] == nil then
							attrList[attrs[j][1]] = attrs[j][2]
						else
							attrList[attrs[j][1]] =  attrList[attrs[j][1]] + attrs[j][2]
						end
					end
				end
			end
		end
    end
    return attrList
end

function HeadFrameDataMgr:SortFrame()
    if self._allFrameData == nil or #self._allFrameData < 2 then
        return
    end

    table.sort(
        self._allFrameData,
        function(a, b)
            if a:IsOwned() and (not b:IsOwned()) then
                return true
            end

            if (not a:IsOwned()) and b:IsOwned() then
                return false
            end

            if a:IsOwned() and b:IsOwned() then
                return a.frameId > b.frameId
            end

            -- if a:IsGot() and (not b:IsGot()) then
            --     return true
            -- end 

            -- if (not a:IsGot()) and b:IsGot() then
            --     return false
            -- end

            -- if a:IsGot() and  b:IsGot() then
            --     return a.frameId > b.frameId
            -- end 

            return a.frameId > b.frameId
        end
    )
end

return HeadFrameDataMgr