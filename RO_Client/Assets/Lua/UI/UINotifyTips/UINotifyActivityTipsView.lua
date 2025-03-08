local UINotifyActivityTipsView = require("UINotifyTips/UINotifyActivityTipsView_Generate")
local NotifyItemCtr = require("Common/NotifyItemCtr")
local TaskJumpCtr = require("Common/TaskJumpCtr")

function UINotifyActivityTipsView:OnAwake(data)
	self.controller = require("UINotifyTips/UINotifyActivityTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINotifyActivityTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Open_Activity_Refresh,self,self.OnRefreshActivity);
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Show_Notices,self,self.OnShowNotices);
end

function UINotifyActivityTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINotifyActivityTipsView:Init()
	self.notices = {}
	self.lastShowNotifyData = nil
	self.lastShowItem = nil
	self.currentSelectedType = 1
	self.toggleActivity.toggle.isOn = true
end

function UINotifyActivityTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)

	if not self.timer then
		self.timer = Timer.New(function ()
			self:ShowActivityItems()
		end, 0.1)
		self.timer:Start()
	end
end

function UINotifyActivityTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UINotifyActivityTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.BtnClose.button,self, self.OnBtnCloseClick);
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnBtnCloseClick);
	self.uiBase:AddToggleEventListener(self.toggleActivity.toggle,self, self.OnPageToggleClick,1)
	self.uiBase:AddToggleEventListener(self.toggleNotify.toggle,self, self.OnPageToggleClick,2)
end

function UINotifyActivityTipsView:OnHide()

end

function UINotifyActivityTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UINotifyActivityTipsView:OnClose()
	self:ClearUpdateActivityTimer()
	self.activityScrollList.loopVerticalScrollRect:ClearCells()

	if self.timer and self.timer.running then
		self.timer:Stop()
	end

	self.notices = nil
end

function UINotifyActivityTipsView:OnDispose()

end

function UINotifyActivityTipsView:OpenPageByTab(idx)
	if idx == 1 then
		self:ShowActivityItems()
	elseif idx == 2  then
		self.notices = {}
		self.notifyScrollList.loopVerticalScrollRect:ClearCells()
		self:ClearUpdateActivityTimer()
		self:ShowNotifyItems()
	end
end

function UINotifyActivityTipsView:OnRefreshActivity()
	if self.currentSelectedType == 1 then
		--LogError("add by raul------currentSelectedType == 1---OnRefreshActivity-------")
		self:ShowActivityItems()
	end
end

function UINotifyActivityTipsView:ShowActivityItems()
	self.notifyScrollList:SetActive(false)
	
	local actItems = ManagerContainer.DataMgr.ActsDataMgr:GetActivityItemsByPageId(Enum.UIPageName.UINotifyActivityTips)
	--LogError("add by raul:UINotifyActivityTipsView:ShowActivityItems->#actItems 's number"..#actItems.."---is total actItems Activity Number")
	--LogError("add by raul:UINotifyActivityTipsView:ShowActivityItems->actItems".. Inspect(actItems))
	if actItems == nil or #actItems == 0 then
		self.actEmptyNode:SetActive(true)
		self.activityScrollList:SetActive(false)
		return
	end

	self:ClearUpdateActivityTimer()

	local existLimitedAct = false
	for i = 1, #actItems do
		if actItems[i]:IsLimited() then
			existLimitedAct = true
			--LogError(#actItems.."add by raul---is -total banner Activity Number(---:UINotifyActivityTipsView:ShowActivityItems())")
			break
		end
	end
	if existLimitedAct then
		self.udpateActTimer = ManagerContainer.LuaTimerMgr:AddTimer(60000, 1,self,self.UpdateActivityTime,nil);
	end

	self.actEmptyNode:SetActive(false)
	self.activityScrollList:SetActive(true)

	CommonUtil.LoopGridViewEleCreateNew(self,
		self.activityScrollList.loopVerticalScrollRect,
		self.activityScrollList.content.verticalLayoutGroup,
		actItems,
		0,
		self, self.SetActivityItem);
end

function UINotifyActivityTipsView:UpdateActivityTime()
	self:ShowActivityItems()
end

function UINotifyActivityTipsView:ClearUpdateActivityTimer()
	if self.udpateActTimer~= nil then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self.udpateActTimer)
        self.udpateActTimer = nil
    end
end

function UINotifyActivityTipsView:SetActivityItem(itemLua,idx,itemData)
	itemLua.limitedLblNode:SetActive(itemData:IsLimited())
	itemLua.limitedNode:SetActive(itemData:IsLimited())
	if itemData:IsLimited() then
		local day,hour,minute = ConvertTimeForm(itemData:LeftTime())
		itemLua.leftDay.text.text = tostring(day)
		itemLua.leftHours.text.text = tostring(hour)
		itemLua.leftMins.text.text = tostring(minute)
	end

	if itemData:GetBg() ~= nil then
		CommonUtil.LoadIcon(self, itemData:GetBg(), function (sprite)
			itemLua.bannerImg.image.sprite = sprite
		end, itemLua, 'ActivityBGIdx')
	else
		itemLua.bannerImg.image.sprite = nil
	end

	itemLua.redPoint:SetActive(itemData:HasRedPoint())

	if itemData.pageId ~= nil then
		self.uiBase:AddButtonUniqueEventListener(itemLua.bannerImg.button, self, self.OnClickOpenActivityPage, itemData.pageId,itemData.pageBg, itemData.actId,itemData.type)
	end
end

function UINotifyActivityTipsView:OnClickOpenActivityPage(btn,paramList)
	local pageId = paramList[0]
	local pageBg = paramList[1]
	local actId = paramList[2]
	local Jumptype = paramList[3]

	local data = {pageBg = pageBg, actId = actId}
	--type == 0 任务跳转 有解锁条件判断
	local bIsJump = false
	if Jumptype == 0 then
		bIsJump = TaskJumpCtr:JumpBuyCfgId(pageId)
	else
		bIsJump = true
		ManagerContainer.LuaUIMgr:Open(pageId,data,Enum.UIPageName.UINotifyActivityTips)
	end	
	
	if bIsJump then
		self:OnBtnCloseClick()
	end
	--LogError("add by raul OnClickOpenActivityPage "..Inspect(getmetatable(paramList)))
	--LogError("add by raul OnClickOpenActivityPage:actId"..actId)
end

function UINotifyActivityTipsView:ShowNotifyItems()
	self.actEmptyNode:SetActive(false)
	self.activityScrollList:SetActive(false)
	self.notifyScrollList:SetActive(true)
	--LogError(tostring(ManagerContainer.LuaGameMgr.serverData.id))
	local url = PlatformPack.NOTIFY_URL .. "?serverid=" .. ManagerContainer.LuaGameMgr.serverData.id
	url = url .. '&timesamp=' .. tostring(os.time())
	local platform = ManagerContainer.LuaGameMgr.platform
	if platform and platform ~= '' then
		url = url .. '&platform=' .. tostring(platform)
	end
	local subplatform = ManagerContainer.LuaGameMgr.channelName
	if subplatform and subplatform ~= '' then
		url = url .. '&sub_platform=' .. tostring(subplatform)
	end
	--LogError(ManagerContainer.LuaGameMgr.serverData.id)
	local OnRequestHttpCb = function(noticeInfo)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_Notices,noticeInfo)
	end
	ManagerContainer.LuaGameMgr:RequestHttpServer(url,OnRequestHttpCb)
	
	
end

function UINotifyActivityTipsView:OnShowNotices(noticeInfo)
	if not self.notices then return end

	local noticesJson
	local ok, errors = RO_XPCALL(function()  noticesJson = JSON:decode(noticeInfo) end, debug.traceback)
        if  ok then
			
			for k,p in pairs(noticesJson) do
				
				local notice = self:ParseNotice(p)
				if notice ~= nil then
					if notice.top == 1 then
						table.insert(self.notices, 1, notice)
					else
						self.notices[#self.notices+1] = notice
					end
					
				end
			end

		else
			local notice = {}
			notice.NoticeTitle = "";
			notice.LimitedTimeLabel = "";
			notice.NoticeBeginTime = "";
			notice.NoticeEndTime = "";
			notice.NoticeTxt = string.formatbykey("NoticeAnomaly");
			notice._showing =  true
			self.notices[#self.notices+1] = notice

			LogError("[Notice].."..errors)
		end
	self:SetListData()
end

function UINotifyActivityTipsView:ParseNotice(noticeJson)
	 if noticeJson == nil then
	 	return nil
	 end

	local notice = {};
	
	notice.NoticeTitle = noticeJson.title;
	notice.LimitedTimeLabel = noticeJson.timeLabel;
	notice.NoticeBeginTime = noticeJson.beginTime;
	notice.NoticeEndTime = noticeJson.endTime;
	notice.NoticeTxt = noticeJson.text;
	notice.top = noticeJson.top
	if noticeJson.top == 1 then 
		notice._showing =  true
	end
	
	return notice
end

function UINotifyActivityTipsView:SetListData()
	if self.notices ~= nil and #self.notices > 0 then
		--self.notices[1]._showing = true
		CommonUtil.LoopGridViewEleCreateNew(self,
				self.notifyScrollList.loopVerticalScrollRect,
				self.notifyScrollList.content.verticalLayoutGroup,
				self.notices,
				0,
				self, self.SetNoticeItem);

		self.notifyScrollList.loopVerticalScrollRect.velocity = Vector2.zero;
		local _position = self.notifyScrollList.content.transform.localPosition;
		_position.y = 0;
		self.notifyScrollList.content.transform.localPosition = _position;
	end
end

function UINotifyActivityTipsView:SetNoticeItem(itemLua, idx,itemData)
	if itemData._showing then
		self.lastShowItem  = itemLua
		self.lastShowNotifyData = itemData
	end
	NotifyItemCtr:SetData(self, itemLua, itemData, self.OnOpenNoticeCallback,self.OnHideNoticeCallback);
end

function UINotifyActivityTipsView:OnOpenNoticeCallback(_item,itemData)
	local hideTitle = ""
	if self.lastShowNotifyData ~= nil then
		self.lastShowNotifyData._showing = false;
		hideTitle = self.lastShowNotifyData.NoticeTitle
	end
	self.lastShowNotifyData = itemData
	
	local oldItem = self.lastShowItem
	self.lastShowItem = _item

	return oldItem,hideTitle;
end

function UINotifyActivityTipsView:OnHideNoticeCallback(itemData)
	self.lastShowItem = nil
end

function UINotifyActivityTipsView:OnBtnCloseClick()
	self:UIClose()
end

--Toggle事件,_params是1代表的是精彩活动，是2代表的是游戏公告
function UINotifyActivityTipsView:OnPageToggleClick(_toggle, _params)
	if _toggle.isOn then
		if self.currentSelectedType == _params then
			return
		end 

		self.currentSelectedType = _params
		self:OpenPageByTab(self.currentSelectedType)	
		--LogError(self.currentSelectedType.."add by raul---page1--精彩活动---page2--游戏公告")
	end
end

return UINotifyActivityTipsView

