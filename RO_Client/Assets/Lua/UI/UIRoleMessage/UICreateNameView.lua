local UICreateNameView = require("UIRoleMessage/UICreateNameView_Generate")
local NickNameCtr = require("Common/NickNameCtr")

function UICreateNameView:OnAwake(data)
	self.controller = require("UIRoleMessage/UICreateNameCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UICreateNameView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.NICK_NAME_CREATED, self, self.RefreshName)
end

function UICreateNameView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UICreateNameView:Init()
	self:RefreshName(true)
end

function UICreateNameView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UICreateNameView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseChangeName)
	self.uiBase:AddButtonEventListener(self.changeBtn.button, self, self.OnClickChangeName)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseChangeName)
end

function UICreateNameView:OnHide()

end

function UICreateNameView:OnShow(data)
	self.controller:SetData(data)

end

function UICreateNameView:OnClose()
end

function UICreateNameView:OnDispose()
	self.controller:OnDispose()
end

function UICreateNameView:RefreshName(_isFirst)
	self.inputField.inputField.text = "";
	local _nickName = ManagerContainer.DataMgr.UserData:GetUserNickname();
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AFTER_REFRESH_NAME, _nickName);
	if not _isFirst then	--不是首次开启，证明已经改变了名字，给玩家个提示
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("NameSuccess"));	--登记成功
		self:OnClickCloseChangeName();
	end
end

function UICreateNameView:OnClickCloseChangeName()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UICreateName);
end

function UICreateNameView:OnClickChangeName()
	local newName = self.inputField.inputField.text
	local errorCode = NickNameCtr:GetChangeNameError(newName, true);
	if errorCode == 0 then
		if SDKMgr.Instance:CheckName(newName) then
			NickNameCtr:SendChangeName(newName)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShieldTips02")
		end
	--elseif errorCode == 1 then	--忽略了改名卡的判断了
		--ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("NameModifyError"))	--没有改名卡
	elseif errorCode == 2 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("NameModifyError1"))	--名字重复无法修改
	elseif errorCode == 3 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("NameModifyError1"));	--不能用“新玩家”这个名字
	elseif errorCode == 4 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("InputEmpty"));	--你输入的是空的
	elseif errorCode == 5 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("UserNameRule"));	--名字里有非法字符
	elseif errorCode == 6 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("330"));	--名字长度最大6个汉字
	end
end

return UICreateNameView

