local UIActivityTurntableView = require("UIActivity/UIActivityTurntableView_Generate")

function UIActivityTurntableView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityTurntableCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)	
end

function UIActivityTurntableView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
end

function UIActivityTurntableView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	self:LoadBg()
end

function UIActivityTurntableView:LoadBg()
	--加载图片
	--local needleimg,titelimg = self.controller:GetActivityData():GetBgTitleImg(1)
	--LogError(self.needle.image.sprite.name)
	--目前只有一个暂时不开启加载
	-- CommonUtil.LoadIcon(self, bgimg, function (sprite)
	--     self.needle.image.sprite = sprite		
	-- end)
	-- CommonUtil.LoadIcon(self, titelimg, function (sprite)
	-- 	self.titleImage.image.sprite = sprite
	-- end)
end

function UIActivityTurntableView:Init()
	self.controller:GetActivityData():OnResetState()
	local bIsStartstate = self.controller:GetActivityData():IsState("StartTurn")
	if bIsStartstate then
		local IsOver = self.controller:GetActivityData():IsReceiverOver() --是否全部领取
		if IsOver then --结束本轮
			self.controller:GetActivityData():SetState("FinishedTrun")
		end
	end
	--指针位置 指向最后一次关闭获取
	local RolTrans = self.needle:GetComponent(Enum.TypeInfo.RolRectTransform)
	if RolTrans then		
		local Angle = self.controller:GetActivityData():GetLastWhellAngle()
		local nCount = self.controller:GetActivityData():GetReceivePrizeInfoCount()
		if nCount <= 0 or nCount >= 8 then
			Angle = 0
		end
		RolTrans:SetAngle(0,0,Angle)
	end
	self.RunTimes = 0
	self:StartTimer() --倒计时刷新
	self:Refresh()
	self:RefreshCostGoldIcon()
end

function UIActivityTurntableView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIActivityTurntableView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnTurnOne.button, self, self.OnClickOnceRun)
	self.uiBase:AddButtonEventListener(self.btnTurnAll.button, self, self.OnClickAllRun)
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickExit)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickExit)

	self.uiBase:AddButtonEventListener(self.scoreInfo.button, self, self.OnClickHelpBtn)

	self.uiBase:AddButtonEventListener(self.btnFinishTurn.button, self, self.OnEndTurn)
	self.uiBase:AddButtonEventListener(self.btnStartTurn.button, self, self.OnBeginTurn)
	self.uiBase:AddButtonEventListener(self.btnRefresh.button, self, self.OnRefreshTurn)


	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TRUNWHELL_EVENT_LOG_ACK, self, self.OnLogPrizeInfoAck)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TRUNWHELL_EVENT_LOG_NTF, self, self.OnAddPrizeInfoNTF)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TRUNWHELL_EVENT_REFRESH_ACK, self, self.OnRefreshAck)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TRUNWHELL_EVENT_OPEN_REWARD_ACK, self, self.OnOpenRewardAck)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TRUNWHELL_EVENT_REWARD_ACK, self, self.OnRewardAck)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.TRUNWHELL_EVENT_CLOSE_REWARD, self, self.OnCloseRewardAck)
	--移动切换item
	local OnSelected = function (idx)    
		self:OnTransSelectedItem(idx)
	end
    --结束转动
    local OnFinished = function (idx)    
		self:OnTranSelectFinished(idx)
	end
	--滚动文字
	local OnChangeText = function (TextObj)
		self:ChangeLogText(TextObj)
	end
	--积分监听
	--ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_OPEN_NTF, self, self.RefreshTime)	
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.RefreshGold)

	local RolTrans = self.needle:GetComponent(Enum.TypeInfo.RolRectTransform)
	if nil ~= RolTrans then
		RolTrans.mSelectAction = OnSelected
		RolTrans.mFinishAction = OnFinished	
	end
  
	self.NextTextIndex = 0
	local TextAuto = self.viewport:GetComponent(Enum.TypeInfo.UiLoopAutoMove)
	if nil ~= TextAuto then		
		TextAuto:SetChangeInfoCb(OnChangeText)
	end
end

function UIActivityTurntableView:OnHide()

end

function UIActivityTurntableView:OnShow(data)
	self.controller:SetData(data)
end

function UIActivityTurntableView:OnClose()
	self:StopTurn()
	self:RemoveTimer()
	self:ClearLeftTimeTimer()
end

function UIActivityTurntableView:OnDispose()
	self.controller:OnDispose()
end
-------------------------------------sever
--请求刷新转盘道具
function UIActivityTurntableView:SendRefreshREQ()	
	local actId = self.controller:GetActivityData():GetActiveId()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITY_WHEEL_REFRESH_REQ,{activity_id = actId})
end

--收到刷新道具
function UIActivityTurntableView:OnRefreshAck(data)
	--LogError("OnRefreshAck" .. Inspect(data))
	if data.error ~= Enum.NetErrorCode.ERROR_OK then 
		self:PopErrorTips('397')
		return 
	end	
	--收起动画
	self:PlayAniRun(self.trunAnim.animator,Enum.TrunWheelAniName.TrunRefresh1)
	self:OnUnSelectedItem()
	self:OnUnPrizeitem()
	--结束动画
	self:Refresh()	
	self:RemoveTimer()
	self.WaitTimerId =  ManagerContainer.LuaTimerMgr:AddTimer(200, 1, self, self.OnRefreshAni, nil)
end

--请求开启本轮
function UIActivityTurntableView:SendOpenRewardREQ()
	local actId = self.controller:GetActivityData():GetActiveId()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITY_WHEEL_OPEN_REWARD_REQ,{activity_id = actId})
end

--收到本轮开始
function UIActivityTurntableView:OnOpenRewardAck(data)
	if data.error ~= Enum.NetErrorCode.ERROR_OK then 
		self:PopErrorTips('397')
		return 
	end	
	self.controller:GetActivityData():SetState("StartTurn")
	self:PlayAniRun(self.trunAnim.animator,Enum.TrunWheelAniName.TrunStart)
	self:RefreshBtn()
	self:OnUnPrizeitem()	
	self:RefreshCostGoldIcon()
end

--请求转动 1 all（获取奖励）
function UIActivityTurntableView:SendRewardREQ(Isall)
	--reward_all false 1次 true 获取所有	
	local actId = self.controller:GetActivityData():GetActiveId()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITY_WHEEL_REWARD_REQ,{activity_id = actId,reward_all = Isall})
end

--收到奖励
function UIActivityTurntableView:OnRewardAck(data)	
	--LogError("OnRewardAck"..Inspect(data))
	if data.error ~= Enum.NetErrorCode.ERROR_OK then 
		self:PopErrorTips('397')
		return 
	end	
	self.RunTimes = #data.reward_list
	if self.RunTimes > 0 then	
		local item = data.reward_list[1]
		if item then			
			local nSelectindex = self.controller:GetActivityData():FindItemIdx(item.item_idx)
			self.controller:GetActivityData():SetStopItem(nSelectindex -1)
		end
		if self.RunTimes > 1 then
			local nSelectindex = self.controller:GetActivityData():GetBigPreizeNextIdx()		
			self.controller:GetActivityData():SetStopItem(nSelectindex -1)
		end
		self.Truning = true
		self:RunTurn(self.RunTimes)
	end
end

--请求关闭本轮转盘
function UIActivityTurntableView:SendCloseRewardREQ()
	self:OnUnReceiveItem()
	local actId = self.controller:GetActivityData():GetActiveId()
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTIVITY_WHEEL_CLOSE_REWARD_REQ,{activity_id = actId})
end

--收到关闭本轮
function UIActivityTurntableView:OnCloseRewardAck(data)
	if data.error ~= Enum.NetErrorCode.ERROR_OK then 
		self:PopErrorTips('397')
		return 
	end	
	self:PlayAniRun(self.trunAnim.animator,Enum.TrunWheelAniName.TrunRefresh1)
	self:OnUnSelectedItem()
	self:OnUnPrizeitem()	
	self.controller:GetActivityData():SetState("ReadyTurn")	
	self:Refresh()	
	self:RemoveTimer()
	self.WaitTimerId =  ManagerContainer.LuaTimerMgr:AddTimer(200, 1, self, self.OnRefreshAni, nil)
end
---------------------------------------------------------------------
--添加文字
function UIActivityTurntableView:ChangeLogText(TextObj)
	self.NextTextIndex = self.NextTextIndex + 1
	local strInfo = self.controller:GetActivityData():GetLogData(self.NextTextIndex)
	TextObj.text = strInfo
end
--转动到ITEM
function UIActivityTurntableView:OnTransSelectedItem(idx)	
	local bIsFinishedstate = self.controller:GetActivityData():IsState("RunOnceTrun")
	local bIsAllFinishedstate = self.controller:GetActivityData():IsState("RunAllTrun")
	if bIsFinishedstate or bIsAllFinishedstate then
		self:OnUnSelectedItem()
		self:OnSelectedItem(idx+1)
	end
end

--转动结束
function UIActivityTurntableView:OnTranSelectFinished(idx)	
	local bIsFinishedstate = self.controller:GetActivityData():IsState("RunOnceTrun")
	local bIsAllFinishedstate = self.controller:GetActivityData():IsState("RunAllTrun")
	if bIsFinishedstate or bIsAllFinishedstate then
		self.controller:GetActivityData():ReceivePrizeInfo(idx+1) --标记已领取				
		if not self:IsNil(self:GetPosItem(idx+1)) then
			self:PlayAniRun(self:GetPosItem(idx+1).iconLight.animator,"IconLightShow")
		end

	end
	if bIsAllFinishedstate then --全部获取
		self.RunTimes = self.RunTimes - 1			
		if self.RunTimes < 1 then	--全部显示完毕
			self.Truning = false
			self:RemoveTimer()
			self.FinshedTrunTimeId =  ManagerContainer.LuaTimerMgr:AddTimer(600, 1, self, self.FinshedAllTrun, nil)		
		else
			--继续旋转下一个
			local nStopIndex = self.controller:GetActivityData():GetAutoNextStopItem()				
			self.controller:GetActivityData():SetStopItem(nStopIndex -1)
			self:RunTurn(8)
		end
	elseif bIsFinishedstate then--单次获取获取					
		self.Truning = false
		self:RemoveTimer()
		self.FinshedTrunTimeId =  ManagerContainer.LuaTimerMgr:AddTimer(600, 1, self, self.FinshedOnceTrun, {Index = idx})		
	end		
end

--完成8连抽
function UIActivityTurntableView:FinshedAllTrun()	
	self:OnUnPrizeitem() --关闭高光	
	self:SetReceivedItem(true)	--全部领取设置
	self:PoAllpGet()
	self:OnUnSelectedItem()		 
	self.controller:GetActivityData():SetState("FinishedTrun")
	
	self:RefreshBtn() --刷新按钮	
	
	self:RemoveTimer()
end

--完成1抽
function UIActivityTurntableView:FinshedOnceTrun(Timeid,params)
	local idx = params.Index
	self:OnUnPrizeitem() --关闭高光	
	self:OnReceiveItem(idx+1,true)
	if not self:IsNil(self:GetPosItem(idx+1)) then
		self:GetPosItem(idx+1).needleLight:SetActive(false)	 --转动指针关闭			
	end
	--1.5秒后关闭 显示道具
	self:PopGet(idx+1)--UIPOPGot  弹窗获取到			
	local IsOver = self.controller:GetActivityData():IsReceiverOver() --是否全部领取
	if IsOver then --结束本轮
		self.controller:GetActivityData():SetState("FinishedTrun")
	else
		self.controller:GetActivityData():SetState("StartTurn")
	end		
	
	self:OnUnSelectedItem()	
	self:RefreshBtn() --刷新按钮	
	self:RemoveTimer()
	self:RefreshCostGoldIcon()
end

function UIActivityTurntableView:RemoveTimer()
	if self.FinshedTrunTimeId ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.FinshedTrunTimeId);
        self.FinshedTrunTimeId = nil
	end
	if self.WaitTimerId ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.WaitTimerId);
        self.WaitTimerId = nil
	end
end

--展示获得道具
function UIActivityTurntableView:PopGet(idx)
	local _rewards = {}
	local Item = self.controller:GetActivityData():GetData(idx)
	if Item then
		table.insert(_rewards,
		{
			cfgId = Item.nItemId,
			num = Item.nItemNum,
		})
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {rewards = _rewards})
end

--展示全部道具
function UIActivityTurntableView:PoAllpGet()
	local _rewards = {}
	for i=1,8 do
		local Item = self.controller:GetActivityData():GetData(i)
		if Item then
			table.insert(_rewards,
			{
				cfgId = Item.nItemId,
				num = Item.nItemNum,
			})
		end
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPOPGot, {rewards = _rewards})
end

--Error弹窗
function UIActivityTurntableView:PopErrorTips(Key)
	if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId=Key}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId=Key})
    end
end

--设置奖项
function UIActivityTurntableView:SetItem(idx,ItemInfo)
	local Item = self:GetPosItem(idx)
	if Item then
		CommonUtil.SetRewardItemData(self,ItemInfo.nItemId,Item.iconItem,ItemInfo.nItemNum, self.OnClickItem)

		self:SetGrandPrizeItem(idx,ItemInfo.bIsGrandPrize)
		self:OnReceiveItem(idx,ItemInfo.hasReceive)
	end
end

--全部领取ITEM
function UIActivityTurntableView:SetReceivedItem(IsShow)	
	for i=1,8 do
		if not self:IsNil(self:GetPosItem(i)) then
			self:GetPosItem(i).received:SetActive(IsShow)
			self:GetPosItem(i).available:SetActive(not IsShow)
		end
	end
end


--设置tips
function UIActivityTurntableView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIActivityTurntableView:StopTurn()
	local RolTrans = self.needle:GetComponent(Enum.TypeInfo.RolRectTransform)
	if RolTrans then		
		RolTrans:Stop()
	end
end
 
--退出
function UIActivityTurntableView:OnClickExit()	
	self:UIClose()
end

--刷新奖励
function UIActivityTurntableView:OnRefreshTurn()
	local IsOver = self.controller:GetActivityData():IsActivityOver()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end

	--是否金币足够刷新
	local bIsCanRefresh = self.controller:GetActivityData():IsRefreshCostGold()
	if bIsCanRefresh then		
		--请求新数据
		self:SendRefreshREQ()
	else
		self:PopErrorTips('SeasonLackGold')
	end	
end

function UIActivityTurntableView:OnRefreshAni()
	self:PlayAniRun(self.trunAnim.animator,Enum.TrunWheelAniName.TrunRefresh2)
	if self.WaitTimerId ~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.WaitTimerId);
        self.WaitTimerId = nil
	end

	local RolTrans = self.needle:GetComponent(Enum.TypeInfo.RolRectTransform)
	if RolTrans then		
		local Angle = self.controller:GetActivityData():GetLastWhellAngle()
		RolTrans:SetAngle(0,0,0)
		self.controller:GetActivityData():SetStopItem(0)
		self:RunTurn(0)
	end	
end

--开始本轮
function UIActivityTurntableView:OnBeginTurn()
	local IsOver = self.controller:GetActivityData():IsActivityOver()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	self:SendOpenRewardREQ()	
end

--结束本轮
function UIActivityTurntableView:OnEndTurn()
	local IsOver = self.controller:GetActivityData():IsActivityOver()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	local SureEvent = function ()	
		self:SendCloseRewardREQ()	
	end
	--二次确认			
	local data = {"TurningCanOver", nil, nil, self, SureEvent}
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)	
end

function UIActivityTurntableView:StartTimer()
	self:UpdateLeftTime()
	self:ClearLeftTimeTimer()
	self.updateLeftTimeTimer = ManagerContainer.LuaTimerMgr:AddTimer(3000, -1,self,self.UpdateLeftTime,nil);
end

function UIActivityTurntableView:ClearLeftTimeTimer()
	if self.updateLeftTimeTimer~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.updateLeftTimeTimer)
        self.updateLeftTimeTimer = nil
    end
end

function UIActivityTurntableView:UpdateLeftTime()
	local activityItem = self.controller:GetActivityData():GetActiveItem()
	if activityItem then		
		self:RefreshTime(activityItem:LeftTime())
		if activityItem:LeftTime() <= 0 then
			self:ClearLeftTimeTimer()
		end
	end	
end

function UIActivityTurntableView:RefreshTime(leftTime)	
	local day,hour,minute,second = ConvertTimeForm(leftTime)
	local timeStr = ""
	if day > 0 then
		timeStr = day .. "天"..hour .. "时" .. minute .. "分"
	else
		if hour > 0 then
			timeStr = hour .. "时" .. minute .. "分"
		else
			if minute == 0 then
				minute = 1
			end
			timeStr = minute .. "分"
		end
	end
	self.TimeTxt.text.text = timeStr
end

--点击帮助
function UIActivityTurntableView:OnClickHelpBtn()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', "ActivityRoulettelTips"})
end

--转八次
function UIActivityTurntableView:OnClickAllRun()
	local IsOver = self.controller:GetActivityData():IsActivityOver()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	--是否可以转8次 判断
	local costAllInfo = self.controller:GetActivityData():CalNeedAllGold() --多次消耗	
	local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)--当前金币
	local IsCanRun = true
	if costAllInfo.CosGoldmNum >0 then --显示金币
		if Goldcount <= costAllInfo.CosGoldmNum then
			IsCanRun = false
		end
	end	
	if IsCanRun then
		self.controller:GetActivityData():SetState("RunAllTrun")
		self:Refresh()
		self:SendRewardREQ(true)
	else
		self:PopErrorTips('SeasonLackGold')
	end
end

--转一次
function UIActivityTurntableView:OnClickOnceRun()
	local IsOver = self.controller:GetActivityData():IsActivityOver()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end

	--是否可以转1次 判断
	local costInfo = self.controller:GetActivityData():CalNeedGold() --单次消耗	
	local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)	--当前金币
	local IsCanRun = true

	if costInfo.CostItemNum <= 0 then
		if Goldcount < costInfo.CosGoldmNum or Goldcount == 0 then--金币是否够消耗
			IsCanRun = false			
		end	
	elseif costInfo.CosGoldmNum > 0 and costInfo.CostItemNum >0 then
		if IsCanRun then
			--需要补额外金币弹框
			local NeedItem = self.controller:GetActivityData():GoldToItem(costInfo.CosGoldmNum)
			local paramData = {}
			paramData[1] = self.controller:GetActivityData():GetCostItemName()			
			paramData[2] = string.formatbykey('Supplementary', tostring(costInfo.CosGoldmNum), I18N.T("GoldCoin") ,tostring(NeedItem),paramData[1])
			local data = {"CantUseGold", paramData, nil, self, self.SureOpenTipsWnd}
			ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
			IsCanRun = false
			return
		end
	end

	if IsCanRun then
		self.controller:GetActivityData():SetState("RunOnceTrun")
		self:Refresh()
		self:SendRewardREQ(false)
	else
		self:PopErrorTips('SeasonLackGold')
	end
end

--提示 道具不足金币转换确定
function UIActivityTurntableView:SureOpenTipsWnd()
	local costInfo = self.controller:GetActivityData():CalNeedGold() --单次消耗	
	local Goldcount = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)	--当前金币
	local IsCanRun = true

	if Goldcount < costInfo.CosGoldmNum and Goldcount ~= 0 then--金币是否够消耗
		IsCanRun = false
	end

	if IsCanRun then
		self.controller:GetActivityData():SetState("RunOnceTrun")
		self:Refresh()
		self:SendRewardREQ(false)
	else
		self:PopErrorTips('SeasonLackGold')
	end
end

function UIActivityTurntableView:RunTurn(Count)
	if self:IsNil(self.needle) then
		return
	end
	local RolTrans = self.needle:GetComponent(Enum.TypeInfo.RolRectTransform)
	if nil ~= RolTrans then
		self:StopTurn()		
		local nNextStopIndex = 	self.controller:GetActivityData():GetNextStopItem()		
		if nNextStopIndex then
			RolTrans:SetStopIndex(nNextStopIndex)
		else
			RolTrans:SetStopIndex(0)
		end		
		RolTrans:ClearNewRangeSpeed()
		if Count == 1 then--转一次设置
			RolTrans:AddNewRangeSpeed(0, 500,0, 1)
			RolTrans:AddNewRangeSpeed(500, 2400, 1, 2)
			RolTrans:AddNewRangeSpeed(2400, 500,2, 3)
			RolTrans:AddNewRangeSpeed(500, 0,3, 4)
			self:RefreshBtn()
			--停止选中奖项特效
			self:OnUnPrizeitem()	
		elseif Count > 1 then--转八次设置	
			local Speed = 1.8
			RolTrans:AddNewRangeSpeed(0, 2400*Speed, 0, 0.3 * 1/Speed)
			RolTrans:AddNewRangeSpeed(2400*Speed, 600*Speed, 0.3* 1/Speed, 0.8*1/Speed)
			RolTrans:AddNewRangeSpeed(600*Speed, 0, 0.8*1/Speed, 1.0*1/Speed)
		elseif Count == 0 then
			--空转一圈			
			local fSpped = 1.3
			RolTrans:AddNewRangeSpeed(360 * fSpped, 360 * fSpped,0, 1/fSpped)
		end
		RolTrans:Run(Count)			
	end
end

--刷新奖品
function UIActivityTurntableView:Refresh()
	for i = 1,8 do
		local ItemInfo = self.controller:GetActivityData():GetData(i)
		if ItemInfo then
			self:SetItem(i,ItemInfo)
		end
	end
	self:OnUnSelectedItem()
	self:OnUnPrizeitem()
    self:RefreshBtn()    
	self:RefreshGold()
end

--刷新金币(金币改变时 注册通知)
function UIActivityTurntableView:RefreshGold()	
	local CostItemId = self.controller:GetActivityData():GetCostItemId()
	local count = CommonUtil.GetOwnResCountByItemId(CostItemId)
    self.currency1.number.text.text = count > 0 and count or "0"
	count = CommonUtil.GetOwnResCountByItemId(Enum.ItemType.Diamond)
	self.currency2.number.text.text = CommonUtil.FormatNumber(count)
end

function UIActivityTurntableView:ShowOnceGoldItem(Once,IsGold)
	if Once then		
		self.btnTurnOne.content.imageGold:SetActive(IsGold)
		self.btnTurnOne.content.imageItem:SetActive(not IsGold)
	else
		self.btnTurnAll.content.imageGold:SetActive(IsGold)
		self.btnTurnAll.content.imageItem:SetActive(not IsGold)
	end
end

--设置金币格式
function UIActivityTurntableView:RefreshCostGoldIcon()

	local costInfo = self.controller:GetActivityData():CalNeedGold() --单次消耗
	local costAllInfo = self.controller:GetActivityData():CalNeedAllGold() --多次消耗
	
	if costInfo.CostItemNum == 0 then--单次道具0
		local costGold = self.controller:GetActivityData():GetUseGoldTrun(true)
		self.btnTurnOne.num.text.text = tostring(costGold)
		self:ShowOnceGoldItem(true,true)
	else		
		local costItem = self.controller:GetActivityData():GetUseItemTrun(true)
		self.btnTurnOne.num.text.text = tostring(costItem)
		self:ShowOnceGoldItem(true,false)
	end

	if costAllInfo.CostItemNum >0 then --显示道具
		local costItem = self.controller:GetActivityData():GetUseItemTrun(false)
		self.btnTurnAll.num.text.text = tostring(costItem)
		self:ShowOnceGoldItem(false,false)
	end
	if costAllInfo.CosGoldmNum >0 then --显示金币
		local costGold = self.controller:GetActivityData():GetUseGoldTrun(false)
		self.btnTurnAll.num.text.text = tostring(costGold)
		self:ShowOnceGoldItem(false,true)
	end

end

--设置刷新次数
function UIActivityTurntableView:RefreshCountBtn()
	local CostRefreshGold = self.controller:GetActivityData():GetRefreshCostGold()	
	if nil == CostRefreshGold then
		self.btnRefresh.num.text.text = "-/-"
	elseif CostRefreshGold == 0 then
		self.btnRefresh.num.text.text = I18N.T("Free")	
	else
		self.btnRefresh.num.text.text = tostring(CostRefreshGold)
	end	
end

--刷新按钮
function UIActivityTurntableView:RefreshBtn()
	self:HideAllBtn()
	self:RefreshCountBtn()
	--self:RefreshCostGoldIcon()
	self:RefreshGold()
	local bIsRedaystate = self.controller:GetActivityData():IsState("ReadyTurn")
	if bIsRedaystate then
		self.btnStartTurn:SetActive(true)
		local nCount = self.controller:GetActivityData():GetOverRefreshCount()
		self.refreshBox:SetActive(true)
		self.btnRefresh:SetActive(true)		
		
		self.refreshBox.text.text.text = I18N.SetLanguageValue("RestRefreshTimes",tostring(nCount))	
		if nCount > 0 then
			self.btnRefresh.button.interactable = true
		else
			self.btnRefresh.button.interactable = false
		end		
	end

	local bIsStartstate = self.controller:GetActivityData():IsState("StartTurn")
	if bIsStartstate then
		self.btnTurnOne:SetActive(true)
		local IsOver =self.controller:GetActivityData():IsReceiverOver()
		if IsOver or self.Truning then			
			self.btnTurnOne.button.interactable = false
		else
			self.btnTurnOne.button.interactable = true
		end
		--次数是否够
		local nCount = self.controller:GetActivityData():GetReceivePrizeInfoCount()
		if nCount and nCount < 1 then			
			self.btnTurnAll:SetActive(true)
			if self.Truning then
				self.btnTurnAll.button.interactable = false
			else
				self.btnTurnAll.button.interactable = true
			end
		else
			self.btnFinishTurn:SetActive(true)
					
			local nOverCount = self.controller:GetActivityData():GetOverTrunCount()			
			if nOverCount > 0 then
				self.finishBox:SetActive(true)	
					
				self.finishBox.text.text.text =I18N.SetLanguageValue("NTimesFinishTurn",tostring(nOverCount))
			end
			if self.Truning or nOverCount > 0 then							
				self.btnFinishTurn.button.interactable = false
			else
				self.btnFinishTurn.button.interactable = true	
			end		
		end
	end

	local bIsFinishedstate = self.controller:GetActivityData():IsState("FinishedTrun")
	if bIsFinishedstate then
		self.btnFinishTurn:SetActive(true)
		if self.Truning then
			self.btnFinishTurn.button.interactable = false
		else
			self.btnFinishTurn.button.interactable = true	
		end			
	end

	local bIsRunstate = self.controller:GetActivityData():IsState("RunOnceTrun")
	if bIsRunstate then
		self.btnTurnOne:SetActive(true)	--置灰
		self.btnTurnOne.button.interactable = false;
		self.btnFinishTurn:SetActive(true) --置灰
		self.btnFinishTurn.button.interactable = false;
	end

	local bIsRunstate = self.controller:GetActivityData():IsState("RunAllTrun")
	if bIsRunstate then
		self.btnFinishTurn:SetActive(true) --置灰
		self.btnFinishTurn.button.interactable = false;
	end
end

--隐藏所有按钮
function UIActivityTurntableView:HideAllBtn()
	self.btnTurnOne:SetActive(false)
	self.btnTurnAll:SetActive(false)
	self.btnFinishTurn:SetActive(false)	
	self.btnStartTurn:SetActive(false)
	self.btnRefresh:SetActive(false)
	self.refreshBox:SetActive(false)
	self.finishBox:SetActive(false)
end

--隐藏所有选中
function UIActivityTurntableView:OnUnSelectedItem()
	for i= 1,8 do
		if not self:IsNil(self:GetPosItem(i)) then
			self:GetPosItem(i).needleLight:SetActive(false)
		end
	end	
end

--选中道具
function UIActivityTurntableView:OnSelectedItem(nIndex)
	if not self:IsNil(self:GetPosItem(nIndex)) then
		self:GetPosItem(nIndex).needleLight:SetActive(true)	
	end
end

--设置大奖
function UIActivityTurntableView:SetGrandPrizeItem(nIndex,bIsGrandPrize)
	if not self:IsNil(self:GetPosItem(nIndex)) then
		self:GetPosItem(nIndex).bonusBg:SetActive(bIsGrandPrize)	--大奖底板
		self:GetPosItem(nIndex).bonusLabel:SetActive(bIsGrandPrize)	--大奖条
	end
end

--隐藏所有领取
function UIActivityTurntableView:OnUnReceiveItem()
	for i= 1,8 do
		if not self:IsNil(self:GetPosItem(i)) then
			self:GetPosItem(i).received:SetActive(false)
		end
	end	
end

--显示获得领取
function UIActivityTurntableView:OnReceiveItem(nIndex,IsShow)	
	if not self:IsNil(self:GetPosItem(nIndex)) then
		self:GetPosItem(nIndex).received:SetActive(IsShow)
		self:GetPosItem(nIndex).available:SetActive(not IsShow)
	end
end

--关闭大奖特效
function UIActivityTurntableView:OnUnPrizeitem()
	for i=1,8 do		
		if not self:IsNil(self:GetPosItem(i)) then
			self:PlayAniRun(self:GetPosItem(i).iconLight.animator,"IconLightHide")
		end
	end	
end

--设置icon
function UIActivityTurntableView:SetIcon(nIndex,strIcon)
	--self:GetPosItem(nIndex).iconItem.icon.image.sprite = nil
	CommonUtil.LoadIcon(self, strIcon, function (sprite)
		if not self:IsNil(self:GetPosItem(nIndex)) then
			self:GetPosItem(nIndex).iconItem.icon.image.sprite = sprite
		end
	end,self:GetPosItem(nIndex).iconItem, 'IconIcon')	
end

--设置数量
function UIActivityTurntableView:SetNum(nIndex,nItemNum)
	if not self:IsNil(self:GetPosItem(nIndex)) then	
		self:GetPosItem(nIndex).iconItem.num.text.text = tostring(nItemNum)
	end
end

--getPos
function UIActivityTurntableView:GetPosItem(nIndex)
	if 1 == nIndex then
		return self.pos1
	elseif 2 == nIndex then
		return self.pos2
	elseif 3 == nIndex then
		return self.pos3
	elseif 4 == nIndex then
		return self.pos4
	elseif 5 == nIndex then
		return self.pos5
	elseif 6 == nIndex then
		return self.pos6
	elseif 7 == nIndex then
		return self.pos7
	elseif 8 == nIndex then
		return self.pos8
	end
	return nil
end

function UIActivityTurntableView:PlayAniRun(Animator,AniName)
	if Animator then
		Animator:Play(AniName)
	end	
end

function UIActivityTurntableView:IsNil(obj)
	if nil ~= obj then
		return false
	end
	return true
end

return UIActivityTurntableView

