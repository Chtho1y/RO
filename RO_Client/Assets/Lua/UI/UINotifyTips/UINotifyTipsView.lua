local UINotifyTipsView = require("UINotifyTips/UINotifyTipsView_Generate")
local NotifyItemCtr = require("Common/NotifyItemCtr")

function UINotifyTipsView:OnAwake(data)
	self.controller = require("UINotifyTips/UINotifyTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINotifyTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Show_Notices,self,self.OnShowNotices);
end

function UINotifyTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINotifyTipsView:Init()
	self.notices = {}
	self.lastShowNotifyData = nil
	self.lastShowItem = nil
	if not ManagerContainer.LuaGameMgr.serverData.id  then
		LogError('[xyh]..公告面板没有serverid')
		return
	end
	--LogError('serverId:'..tostring(ManagerContainer.LuaGameMgr.serverData.id))
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
	local OnRequestHttpCb = function(noticeInfo)
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Show_Notices,noticeInfo)
	end
	ManagerContainer.LuaGameMgr:RequestHttpServer(url,OnRequestHttpCb)
end

function UINotifyTipsView:OnShowNotices(noticeInfo)

	local noticesJson
	self.notices={}
	local ok, errors = RO_XPCALL(function()  noticesJson = JSON:decode(noticeInfo) end, debug.traceback)
        if  ok then
			for k,p in pairs(noticesJson) do
				local notice = self:ParseNotice(p)
				if notice ~= nil then
					if notice.top == 1 then
						table.insert(self.notices, 1 , notice)
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

function UINotifyTipsView:SetListData()
	self.scrollViewNotify.loopVerticalScrollRect:ClearCells()
	if self.notices ~= nil and #self.notices > 0 then
		self.notices[1]._showing = true
		CommonUtil.LoopGridViewEleCreateNew(self,
					self.scrollViewNotify.loopVerticalScrollRect,
					self.scrollViewNotify.content.verticalLayoutGroup,
					self.notices,
					0,
					self, self.SetNoticeItem);

		self.scrollViewNotify.loopVerticalScrollRect.velocity = Vector2.zero;
		local _position = self.scrollViewNotify.content.transform.localPosition;
		_position.y = 0;
		self.scrollViewNotify.content.transform.localPosition = _position;
	end
end

function UINotifyTipsView:SetNoticeItem(itemLua, idx, itemData)
	if itemData._showing then
		self.lastShowItem  = itemLua
		self.lastShowNotifyData = itemData
	end
	NotifyItemCtr:SetData(self, itemLua, itemData, self.OnOpenNoticeCallback,self.OnHideNoticeCallback);
end

function UINotifyTipsView:OnOpenNoticeCallback(_item,itemData)
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

function UINotifyTipsView:OnHideNoticeCallback(itemData)
	self.lastShowItem = nil
end

function UINotifyTipsView:ParseNotice(noticeJson)
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

function UINotifyTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UINotifyTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.BtnClose.button, self, self.OnCloseBtnClick)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnCloseBtnClick);
end

function UINotifyTipsView:OnHide()
end

function UINotifyTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UINotifyTipsView:OnClose()
end

function UINotifyTipsView:OnDispose()
	self.scrollViewNotify.loopVerticalScrollRect:ClearCells()
end

--关闭按钮
function UINotifyTipsView:OnCloseBtnClick()
	self:UIClose()
end

return UINotifyTipsView

