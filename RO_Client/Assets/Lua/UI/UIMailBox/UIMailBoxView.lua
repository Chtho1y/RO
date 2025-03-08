local UIMailBoxView = require("UIMailBox/UIMailBoxView_Generate")
local BitUtil = require("BitUtil")

local curMailItem
local curMailLogicData

local isOneKeyReward = false
function UIMailBoxView:OnAwake(data)
	self.controller = require("UIMailBox/UIMailBoxCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIMailBoxView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REFRESH_MAILS, self, self.RefreshMails)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.READ_MAIL, self, self.ReadMail)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.REWARD_MAIL, self, self.RewardMail)
end

function UIMailBoxView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIMailBoxView:Init()
	if self.controller:IsFirstOpen() then
		self.number.text.text = CommonUtil.StringConcat(0, "/100")
		self.controller:SendMailList()
		self.controller:SetFirstOpen()
	else
		self:RefreshMails(true)
	end
end

function UIMailBoxView:RefreshMails(refreshCount)
	if refreshCount then
		self:RefreshMailCount()
	end
	local count = ManagerContainer.DataMgr.MailData:GetMailTotalCount()
	self.empty:SetActive(count == 0)
	local mailDatas = ManagerContainer.DataMgr.MailData:GetMailDatas()
	CommonUtil.LoopGridViewEleCreateNew(self, self.mailList.loopVerticalScrollRect, self.content.verticalLayoutGroup, mailDatas, 0, nil, function (itemLua, idx)
		CommonUtil.UpdateItemPrefab(self, itemLua, clone(mailDatas[idx + 1]), self, self.OnMailSelected)
	end)
end

function UIMailBoxView:ReadMail()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMail, curMailLogicData)

	--CommonUtil.UpdateItemPrefab(self, curMailItem, curMailLogicData, self, self.OnMailSelected)
end

function UIMailBoxView:RewardMail()
	if isOneKeyReward then
		isOneKeyReward = false
		self:RefreshMails()
		return
	end
	--CommonUtil.UpdateItemPrefab(self, curMailItem, curMailLogicData, self, self.OnMailSelected)
end

function UIMailBoxView:RefreshMailCount()
	local count = ManagerContainer.DataMgr.MailData:GetMailTotalCount()
	self.number.text.text = CommonUtil.StringConcat(count, "/50")
end

function UIMailBoxView:OnMailSelected(button, params)
	curMailItem = params[0]
	curMailLogicData = params[1]

	local readState = BitUtil.ParseMailReadState(curMailLogicData.state) == 1

	if not readState then
		self.controller:SendReadMail(curMailLogicData.id)
	else
		ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIMail, curMailLogicData)
	end
end

function UIMailBoxView:OnDeleteOpenedMails()
	self.controller:SendOneKeyDeleteMail()
end

function UIMailBoxView:OnOneKeyRewardMails()
	isOneKeyReward = true
	self.controller:SendOneKeyRewardMail()
end

function UIMailBoxView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIMailBoxView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, function ()
		ManagerContainer.LuaUIMgr:OpenSourceUI(self)
		--self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.btnDeleteRead.button, self, self.OnDeleteOpenedMails)
	self.uiBase:AddButtonEventListener(self.btnOnekeyReceive.button, self, self.OnOneKeyRewardMails)
end

function UIMailBoxView:OnHide()

end

function UIMailBoxView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIMailBoxView:OnClose()
end

function UIMailBoxView:OnDispose()
	curMailItem = nil
	curMailLogicData = nil
end

return UIMailBoxView

