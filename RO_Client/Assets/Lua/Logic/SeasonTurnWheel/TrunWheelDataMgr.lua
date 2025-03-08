local TrunWheelDataMgr = class("TrunWheelDataMgr",require("DataBase"))
local TrunWheelData = require("SeasonTurnWheel/TrunWheelData")

function TrunWheelDataMgr:ctor()
   self.tbPrizeInfoList = {}   
   self.nNextStopIndex = 0   --停止位置
   self.nCurState = 1        --当前转盘状态
   self.tbLog = {}
   self.MaxLogNum = 20   
   self.State = 
   {
        ["ReadyTurn"] = 1,        --刷新奖励 开始本轮
        ["StartTurn"] = 2,        --转1次  转8次
        ["RunOnceTrun"]  = 3,      --转1次 结束本轮
        ["RunAllTrun"]  = 4,       --结束本轮
        ["FinishedTrun"] = 5,       --结束本轮
   }
end

function TrunWheelDataMgr:Clear()
    self.refreshNum = 0
end

function TrunWheelDataMgr:RegisterNetEvents()    
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_ACK,self.OnOpenAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_LOG_ACK,self.OnLogPrizeInfoAck, self)
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_LOG_NTF,self.OnAddPrizeInfoNTF, self)
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_REFRESH_ACK,self.OnRefreshAck, self)
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_OPEN_REWARD_ACK,self.OnOpenRewardAck, self)
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_REWARD_ACK,self.OnRewardAck, self)
	ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_DAO_CHANG100_WHEEL_CLOSE_REWARD_ACK,self.OnCloseRewardAck, self)
end

-------------------------------------sever
--收svr到获奖日志
function TrunWheelDataMgr:OnLogPrizeInfoAck(data)
	--LogError("OnLogPrizeLogInfoAck" .. Inspect(data))	
    --添加根据数量获取 下一条
    if data then
        self:SetLogData(data)
    end   
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TRUNWHELL_EVENT_LOG_ACK,data)
end
--添加获奖信息
function TrunWheelDataMgr:OnAddPrizeInfoNTF(data)
    --LogError("OnLogPrizeLogInfoNTF" .. Inspect(data))
    if data then
        self:AddLogData(data)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TRUNWHELL_EVENT_LOG_NTF,data)
end

--收到刷新道具
function TrunWheelDataMgr:OnRefreshAck(data)
	--LogError("OnRefreshAck" .. Inspect(data))
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TRUNWHELL_EVENT_REFRESH_ACK,data)
end
--收到本轮开始
function TrunWheelDataMgr:OnOpenRewardAck(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TRUNWHELL_EVENT_OPEN_REWARD_ACK,data)
end
--收到奖励
function TrunWheelDataMgr:OnRewardAck(data)	
    --LogError("OnRewardAck"..Inspect(data))
    if data.error == Enum.NetErrorCode.ERROR_OK then 
        self:SetReceivePrizeInfo(data)
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TRUNWHELL_EVENT_REWARD_ACK,data)
end

--收到关闭本轮
function TrunWheelDataMgr:OnCloseRewardAck(data)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.TRUNWHELL_EVENT_CLOSE_REWARD,data)    
end

--------------------------------------------

function TrunWheelDataMgr:UnRegisterNetEvents()
    --ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_CLIMBING_TOWER_INFO_ACK)
end

function TrunWheelDataMgr:GetData(nIndex)    
    return self.tbPrizeInfoList[nIndex]
end

function TrunWheelDataMgr:GetAutoNextStopItem()
    local nStopIndex = self:GetNextStopItem() + 2;
    nStopIndex = (nStopIndex + 8) % 8
    if nStopIndex == 0 then
        nStopIndex = 8
    end
    return nStopIndex
end

function TrunWheelDataMgr:SetStopItem(nIndex)
    self.StopIndex = nIndex
end

function TrunWheelDataMgr:GetNextStopItem()    
    return self.StopIndex
end

--设置获取到奖品
function TrunWheelDataMgr:SetReceivePrizeInfo(Info)
    self.reward_list = Info.reward_list
end

--获取大奖下一个索引开始
function TrunWheelDataMgr:GetBigPreizeNextIdx()   
    for i=1, #self.reward_list do
        if self.reward_list[i].reward_type == 4 then
            local nStopIndex = i + 1
            nStopIndex = (nStopIndex + 8) % 8
            if nStopIndex == 0 then
                nStopIndex = 8
            end
            return nStopIndex
        end
    end
end

function TrunWheelDataMgr:ReceivePrizeInfo(nIndex)   
    self.tbPrizeInfoList[nIndex].hasReceive = true
end

--是否全部领取完毕
function TrunWheelDataMgr:IsReceiverOver()
    if self:GetReceivePrizeInfoCount() >= 8 then
        return true
    end
    return false
end

function TrunWheelDataMgr:SetState(strState)
    self.nCurState = self.State[strState]
end

function TrunWheelDataMgr:IsState(strState)
    return self.nCurState == self.State[strState]
end

function TrunWheelDataMgr:GetCurState()
    return self.nCurState
end


--获取本轮领奖次数
function TrunWheelDataMgr:GetReceivePrizeInfoCount()
    --return self.wheel_num
    local nCount = 0
    for i=1, #self.tbPrizeInfoList do
        if self.tbPrizeInfoList[i].hasReceive then
            nCount = nCount +1
        end
    end
    return nCount
end

function TrunWheelDataMgr:GetRefreshCount()
    return self.refreshNum
end

function TrunWheelDataMgr:FindItemIdx(nIdx)
    for i=1,#self.tbPrizeInfoList do
        if self.tbPrizeInfoList[i].nIndex == nIdx then
            return i
        end
    end
    return 0
end

function TrunWheelDataMgr:OnResetState()
    if not self.IsOpen then                         
        self:SetState("ReadyTurn")                  --准备阶段
    else
        self:SetState("StartTurn")                  --开始阶段
    end       
end

function TrunWheelDataMgr:GetLastWhellAngle()
    if self.wheel_idx <= 0 then
        return 0
    end
    local nIndex = self:FindItemIdx(self.wheel_idx)    
    local Angle = 360 / 8 * (nIndex-1)
    return -Angle
end

function TrunWheelDataMgr:OnDataChangeNtf(data)   
    if ManagerContainer.NetManager:IsErrorData(data) then
        return
    end

    local wheeldata = data
    if data then	        
        if data.ntf_data then
            wheeldata = data.ntf_data
        end
    end

    if wheeldata then		
        self.itemlist = wheeldata.wheel_reward_item_list	    --奖励物品
		self.IsOpen = wheeldata.wheel_open					--是否开启本轮,false表示关闭
		self.refreshNum = wheeldata.wheel_refresh_num		--每轮的第几次刷新
		self.templateidx = wheeldata.template_idx			--模板id
        self.wheel_num = wheeldata.wheel_num				    --抽取次数
        self.wheel_idx = wheeldata.wheel_idx                --指针停止位置
        --self:OnResetState()
        if self.itemlist then
            self.tbPrizeInfoList = {}            
            for i = 1, #self.itemlist do                
                local item = self.itemlist[i]
                if item then
                    local TrunWheelInfo = TrunWheelData:new()
                    TrunWheelInfo.nIndex = item.item_idx
                    TrunWheelInfo.nItemId = item.item_id
                    TrunWheelInfo.nItemNum = item.item_num
                    TrunWheelInfo.bIsGrandPrize = item.reward_type == 4
                    TrunWheelInfo.hasReceive =  item.has_reward
                    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(TrunWheelInfo.nItemId)
                    if not itemCfgData then
                        LogError(tostring(TrunWheelInfo.nItemId) .. " 道具ID不存在")
                    else
                        TrunWheelInfo.strItemIcon = itemCfgData.Icon                        
                        self.tbPrizeInfoList[#self.tbPrizeInfoList+1] = TrunWheelInfo 
                    end
                end
            end
        end      
    end   
end

--请求打开界面
function TrunWheelDataMgr:SendOpenREQ()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_DAO_CHANG100_WHEEL_REQ)
end

--收到打开界面
function TrunWheelDataMgr:OnOpenAck(data)
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UITurnWheelTips)
end

function TrunWheelDataMgr:GetLogCount()
    return #self.tbLog
end

function TrunWheelDataMgr:GetLogData(nCount)
    if #self.tbLog > self.MaxLogNum then --保留最后最大条数
        local nDelCount = #self.tbLog - self.MaxLogNum
        for i = 1,nDelCount do
            table.remove(self.tbLog,1)
        end
    end
    local nIndex = (#self.tbLog  + nCount) % #self.tbLog
    if nIndex == 0 then
        nIndex = #self.tbLog
    end
    return self.tbLog[nIndex]
end

function TrunWheelDataMgr:AddLogData(data)  
    if nil == data.log_list then
        return
    end
    for i = 1, #data.log_list do                
        local itemlist = data.log_list[i].item_list
        if itemlist then
            for j = 1, #itemlist do  
                local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemlist[j].key)
                if not itemCfgData then
                    LogError(tostring(itemlist[j].key) .. " 道具ID不存在")
                else                     
                    local strName = data.log_list[i].nick_name   
                    local nickName = CommonUtil.GetVaildNickName(strName) 
                    local Info = string.formatbykey('PrizeWheelBroad', nickName,itemCfgData.Name.." x "..tostring(itemlist[j].value))                     
                    self.tbLog[#self.tbLog+1] = Info
                end
            end
        end
    end
end

function TrunWheelDataMgr:SetLogData(data)   
    self.tbLog = {}
    self:AddLogData(data)
end

--获取刷新所需金币
function TrunWheelDataMgr:GetRefreshCostGold()
    local refreshNum = self:GetRefreshCount() + 1
    local CostGold = self:GetRefreshPrizeWheelGold(1,refreshNum)
    return CostGold
end

--金币是否可以刷新
function TrunWheelDataMgr:IsRefreshCostGold()
    local refreshNum = self:GetRefreshCount() + 1
    local CostGold = self:GetRefreshPrizeWheelGold(1,refreshNum)
    local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
    if Goldcount >= CostGold then
        return true
    end
    return false     
end

--获取单次抽奖道具
function TrunWheelDataMgr:GetUseItemTrun(Once)
    if self:IsReceiverOver() then
        return 0
    end
    local nWheelCount = self:GetReceivePrizeInfoCount()+1 
    local CostGold = self:GetPrizeWheelItem(1,nWheelCount)
    if not Once then   
        CostGold = self:GetAllPrizeWheelItem(1)
    end      
    return CostGold
end

--获取单次抽奖金币
function TrunWheelDataMgr:GetUseGoldTrun(Once)
    if self:IsReceiverOver() then
        return 0
    end
    local nWheelCount = self:GetReceivePrizeInfoCount()+1 
    local CostGold = self:GetPrizeWheelGold(1,nWheelCount)    --单次消耗金币 
    if not Once then   
        CostGold = self:GetAllPrizeWheelGold(1)
    end    
    return CostGold
end

--是否可以用道具抽奖
function TrunWheelDataMgr:IsCanUseItemTrun(Once)
    if self:IsReceiverOver() then
        return false
    end
    local nWheelCount = self:GetReceivePrizeInfoCount()+1
    local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.LootingPrizeItem)
    local CostGold = self:GetPrizeWheelItem(1,nWheelCount)
    if not Once then   
        CostGold = self:GetAllPrizeWheelItem(1)
    end     
    if tonumber(Goldcount) >= tonumber(CostGold) then
       return true
    end
    return false
end

--是否可以用金币抽奖
function TrunWheelDataMgr:IsCanUseGoldTrun(Once)
    if self:IsReceiverOver() then
        return false
    end
    local nWheelCount = self:GetReceivePrizeInfoCount()+1
    local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
    local CostGold = self:GetPrizeWheelGold(1,nWheelCount)    --单次消耗金币 
    if not Once then   
        CostGold = self:GetAllPrizeWheelGold(1)
    end
    if tonumber(Goldcount) >= CostGold then
        return true
    end
    return false
end

--本轮剩余刷新次数
function TrunWheelDataMgr:GetOverRefreshCount()
    local refreshNum = self:GetRefreshCount()
    local refreshAllNum = self:GetRefreshPrizeWheelGoldCount(1)    --总刷新次数
    local CostNum = refreshAllNum - refreshNum 
    if  CostNum < 0 then
        CostNum = 0
    end
    return CostNum
end

--金币转钱
function TrunWheelDataMgr:GoldToItem(goldNum)
    local ratio = self:GetChangeItemToGoldNum(1)
    return goldNum / ratio
end

--获取抽一次 差价金币
function TrunWheelDataMgr:CalNeedGold()
    local Info = {}
    Info.CostItemNum = -1
    Info.CosGoldmNum = -1
    local ratio = self:GetChangeItemToGoldNum(1)
    if self:IsReceiverOver() then       
        return Info
    end
    --当前道具
    local Itemcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.LootingPrizeItem)    
    --当前需要花费道具
     local NeeddItem = self:GetUseItemTrun(true)      
    --计算花费
     if Itemcount >= NeeddItem then        
        Info.CostItemNum = NeeddItem
        Info.CosGoldmNum = 0
        return Info
     else--不足
        local costItem = NeeddItem - Itemcount
        local costgold = costItem * ratio       
        Info.CostItemNum = Itemcount
        Info.CosGoldmNum = costgold
        return Info
     end
end

--获取抽多次 是否可以使用道具(多次 不转换 道具不足用金币)
function TrunWheelDataMgr:CalNeedAllGold()
    local Info = {}
    Info.CostItemNum = -1
    Info.CosGoldmNum = -1
    local ratio = self:GetChangeItemToGoldNum(1)
    if self:IsReceiverOver() then   --本轮结束       
        return Info
    end
    --当前道具
    local Itemcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.LootingPrizeItem)
    --当前金币
    local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
    --当前需要花费道具
     local NeeddItem = self:GetUseItemTrun(false)  
     local NeddGold = self:GetUseGoldTrun(false)
    --计算花费
     if Itemcount >= NeeddItem then
        Info.CostItemNum = NeeddItem
        Info.CosGoldmNum = 0  
        return Info
     else   --不足
        Info.CostItemNum = 0
        Info.CosGoldmNum = NeddGold
        return Info
     end
end

--结束回合 剩余数
function TrunWheelDataMgr:GetOverTrunCount()    
    local nCount = self:GetReceivePrizeInfoCount()
    local MaxCount = self:GetMaxOverWheelCount(1)
    local costCount = MaxCount - nCount
    if costCount < 0 then
        costCount = 0
    end
    return costCount
end

--获取道具币名字
function TrunWheelDataMgr:GetCostItemName()
    local nWheelCount = self:GetReceivePrizeInfoCount()+1 
    local CostItemId = self:GetPrizeWheelItemGoldId(1,nWheelCount)
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(CostItemId)
    if itemCfgData then
        return itemCfgData.Name
    end
    return ""
end


---------------转盘抽奖表------ID 数据都取第1行
--抽奖单次消耗金币
function TrunWheelDataMgr:GetPrizeWheelGold(id,nCount)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.RewardOneGold[nCount]
end
--抽奖单次消耗道具
function TrunWheelDataMgr:GetPrizeWheelItem(id,nCount)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    if Cfg.RewardOneItem[nCount] then
        return Cfg.RewardOneItem[nCount][2]
    end
end
--抽奖全部消耗金币
function TrunWheelDataMgr:GetAllPrizeWheelGold(id)   
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)   
    return Cfg.RewardAdllGold
end
--抽奖全部消耗道具
function TrunWheelDataMgr:GetAllPrizeWheelItem(id)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.RewardAllItem[1][2]
end
--获取道具币ID
function TrunWheelDataMgr:GetPrizeWheelItemGoldId(id,nCount)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.RewardOneItem[nCount][1]
end
--刷新金币
function TrunWheelDataMgr:GetRefreshPrizeWheelGold(id,nCount)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.RefreshPrice[nCount]
end
--刷新次数
function TrunWheelDataMgr:GetRefreshPrizeWheelGoldCount(id)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return #Cfg.RefreshPrice
end
--抽一次送积分
function TrunWheelDataMgr:GetPrizeWheelPoint(id,nCount)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.RewardOnePoint[nCount]
end
--抽全部送积分
function TrunWheelDataMgr:GetAllPrizeWheelPoint(id)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.RewardAllPoint
end
--最大可结束本轮次数
function TrunWheelDataMgr:GetMaxOverWheelCount(id)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.NoRewardNum
end
--金币转道具数量
function TrunWheelDataMgr:GetChangeItemToGoldNum(id)
    local Cfg = ManagerContainer.CfgMgr:GetCompetitionPrizeWheelCfgById(id)
    return Cfg.ItemPrice    
end
--------------

return TrunWheelDataMgr