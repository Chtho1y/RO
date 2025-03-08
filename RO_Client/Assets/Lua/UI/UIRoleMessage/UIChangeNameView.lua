local UIChangeNameView = require("UIRoleMessage/UIChangeNameView_Generate")
local NickNameCtr = require("Common/NickNameCtr")

function UIChangeNameView:OnAwake(data)
	self.controller = require("UIRoleMessage/UIChangeNameCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChangeNameView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.NICK_NAME_CREATED, self, self.RefreshName)
end

function UIChangeNameView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChangeNameView:Init()
	self:RefreshName(true)
end

function UIChangeNameView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChangeNameView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseChangeName)
	--self.uiBase:AddButtonEventListener(self.alpha.button, self, self.OnClickCloseChangeName)
	self.uiBase:AddButtonEventListener(self.changeBtn.button, self, self.OnClickChangeName)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseChangeName)
end

function UIChangeNameView:OnHide()

end

function UIChangeNameView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIChangeNameView:OnClose()
end

function UIChangeNameView:OnDispose()

end

----Custom start----

function UIChangeNameView:OnClickCloseChangeName()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChangeName);
end

function UIChangeNameView:OnClickChangeName()
	local newName = self.inputField.inputField.text
	local errorCode = NickNameCtr:GetChangeNameError(newName)
	if errorCode == 0 then
		if SDKMgr.Instance:CheckName(newName) then
			NickNameCtr:SendChangeName(newName)
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ShieldTips02")
		end
	elseif errorCode == 1 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("NameModifyError"))	--没有改名卡
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

function UIChangeNameView:RefreshName(_isFirst)
	self.inputField.inputField.text = "";
	local _nickName = ManagerContainer.DataMgr.UserData:GetUserNickname();
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.AFTER_REFRESH_NAME, _nickName);
	if not _isFirst then	--不是首次开启，证明已经改变了名字，给玩家个提示
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("ChangeNameSuccess"));	--改名成功
		self:OnClickCloseChangeName();
	end

	self.desTxt.text.text = I18N.T("NameModifyCard") .. "X1";	--改名卡
	local _enoughCard = NickNameCtr:JudgeCard();
	if _enoughCard then
		CommonUtil.SetTextColor(self.desTxt.text, Constant.RedColorText);
	end
end
----Custom end----

return UIChangeNameView

