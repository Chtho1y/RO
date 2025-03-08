local UIAntiCheatMsgWndView = require("UICommonTips/UIAntiCheatMsgWndView_Generate")

local NoticeList = {
	["AntiCheatMsg"] = {title = "jiasutishi1", notice = "jiasutishi2" , btnSure = "jiasutishi3"},
	["ErrorQuitBattleTip"] = {title = "Tips", notice = "BattleWatchError", btnSure = "BtnQuit"},
}

function UIAntiCheatMsgWndView:OnAwake(data)
	self.controller = require("UICommonTips/UIAntiCheatMsgWndCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIAntiCheatMsgWndView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
end

function UIAntiCheatMsgWndView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	
	self:Init()
end

function UIAntiCheatMsgWndView:Init()
	local data = self.controller:GetData()
	local strId = data[1]
	self.noticeTitle.uILocalizeScript:SetContent(NoticeList[strId].title)
	self.questionTxt.uILocalizeScript:SetContent(NoticeList[strId].notice)
	self.btnSure.uILocalizeScript:SetContent(NoticeList[strId].btnSure)
end

function UIAntiCheatMsgWndView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIAntiCheatMsgWndView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnRight.button, self, self.OnQuit)
end

function UIAntiCheatMsgWndView:OnHide()

end

function UIAntiCheatMsgWndView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end
function UIAntiCheatMsgWndView:CloseUI()
	self:UIClose()
end
function UIAntiCheatMsgWndView:OnClose()
end

function UIAntiCheatMsgWndView:OnDispose()
	self.controller:OnDispose()
end

function UIAntiCheatMsgWndView:OnQuit()
	local data = self.controller:GetData()
	local sureCb = data[2]
	if sureCb then		
		sureCb()		
	end
	self:CloseUI()	
end

return UIAntiCheatMsgWndView

