local UIGMView = require("UIGM/UIGMView_Generate")
local OneKeyGM = require("GmCommond/OneKeyGM")

function UIGMView:OnAwake(data)
	self.controller = require("UIGM/UIGMCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGMView:AddEventListener()

end

function UIGMView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGMView:Init()
	self.inputField.inputField.text = 1000
	self:SetDropDown();
end

function UIGMView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGMView:SendMsg(msg)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_GM_COMMAND_REQ, {gm_cmd = msg})
end

function UIGMView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.addGold.button, function()
		self.inputField.inputField.text = "AddRes 1 1000"
	end)

	self.uiBase:AddButtonEventListener(self.addHeroLv.button, function()
		self.inputField.inputField.text = "AddRes 3 1000"
	end)

	self.uiBase:AddButtonEventListener(self.addHeroJobLv.button, function()
		self.inputField.inputField.text = "AddRes 4 1000"
	end)

	self.uiBase:AddButtonEventListener(self.addPartnerExp.button, function()
		self.inputField.inputField.text = "AddRes 5 1000"
	end)

	self.uiBase:AddButtonEventListener(self.addEquip.button, function()
		self.inputField.inputField.text = "AddEquip 1001 1"
	end)
	self.uiBase:AddButtonEventListener(self.addFashion.button, function()
		self.inputField.inputField.text = "addfashion 10001"
	end)

	self.uiBase:AddButtonEventListener(self.send.button, function()
		local cmdStr = self.inputField.inputField.text
		local cmds = string.split(cmdStr, ';')
		for _,cmd in pairs(cmds) do
			if cmd and cmd ~= '' then
				self:SendMsg(cmd)
			end
		end
	end)

	self.uiBase:AddButtonEventListener(self.btnBack.button, function ()
		self:UIClose()
	end)

	self.uiBase:AddButtonEventListener(self.oneKeyGm.button, function ()
		for k,v in pairs(OneKeyGM) do
			self:SendMsg(v)
		end
		CommonUtil.Unrequire("GmCommond.OneKeyGM")
	end)

	self.uiBase:AddButtonEventListener(self.newbieBtn.button, function ()
		ManagerContainer.LuaGameMgr:EnterNewbie()
	end)

	self.uiBase:AddButtonEventListener(self.userNameBtn.button, function ()
		local userName = self.inputField.inputField.text
		if userName == nil or userName == "" then
			return
		end
		UnityEngine.PlayerPrefs.SetString("LoginName",userName)
		ManagerContainer.LuaGameMgr.openId = userName
		--ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoginState.stateId)
		 ManagerContainer.LuaGameMgr:ReLogin()
		-- ManagerContainer.LuaGameMgr:TestPay(1,1,1)
	end)

	self.uiBase:AddButtonEventListener(self.storyBtn.button, function ()
		local storyId = self.inputField.inputField.text
		ManagerContainer.UIStoryMgr:StartStoryByStoryId(tonumber(storyId), true)
	end)

	self.uiBase:AddButtonEventListener(self.forceGuideBtn.button, function ()
		self:UIClose()
		local forceGuideGroupId = self.inputField.inputField.text
		ManagerContainer.ForceGuideMgr:AddForceGuideDontCheck(tonumber(forceGuideGroupId))
	end)

	self.uiBase:AddButtonEventListener(self.friendBtn.button, function ()
		ManagerContainer.LuaUIMgr:OpenRoleMessagePanel('6784311618999240705');
	end)
	self.uiBase:AddButtonEventListener(self.rollEffectBtn.button, function ()
		ManagerContainer.LuaGuildLobbyMgr:SendEnterReq()
	end)
	self.uiBase:AddButtonEventListener(self.hideUIBtn.button, function ()
		if self.ls then
			for i = 0, self.ls.Length - 1 do
				-- if self.ls[i].MLuaTable.uiData.id ~= Enum.UIPageName.UIGM then
					ManagerContainer.LuaUIMgr:Show(self.ls[i].MLuaTable.uiData.id)
				-- end
			end
			self.ls = nil
		else
			self.ls = ManagerContainer.LuaUIMgr:GetCurUIStack()
			for i = 0, self.ls.Length - 1 do
				-- if self.ls[i].MLuaTable.uiData.id ~= Enum.UIPageName.UIGM then
					ManagerContainer.LuaUIMgr:Hide(self.ls[i].MLuaTable.uiData.id)
				-- end
			end
		end
	end)
end



function UIGMView:SetDropDown()
	DropDownHelper.ClearDropDown(self.dropdown.dropdown);
	self._data = self.controller:TidyData();
	if not self._temTable then
		self._temTable = {};
		DropDownHelper.SetStartName(self.dropdown.dropdown, self._data[1].Name);
		for i = 1, #self._data do
			local _singleData = self._data[i];
			DropDownHelper.SetDropDownItems(self.dropdown.dropdown, _singleData.Name);
		end
	end
	DropDownHelper.AddListener(self.dropdown.dropdown, function(_index)
		self:SetInputField(_index);
	end);
	self:SetInputField(0);
end

function UIGMView:SetInputField(_index)
	if not self._data then
		self._data = self.controller:TidyData();
	end

	local _code = self._data[_index + 1].Code;
	_code = _code:gsub("-", " ");
	self.inputField.inputField.text = _code;
end

function UIGMView:OnHide()

end

function UIGMView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIGMView:OnClose()
	DropDownHelper.ClearDropDown(self.dropdown.dropdown);
end

function UIGMView:OnDispose()

end

return UIGMView

