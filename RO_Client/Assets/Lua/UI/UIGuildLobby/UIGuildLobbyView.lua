local UIGuildLobbyView = require("UIGuildLobby/UIGuildLobbyView_Generate")

function UIGuildLobbyView:OnAwake(data)
	self.controller = require("UIGuildLobby/UIGuildLobbyCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGuildLobbyView:AddEventListener()

end

function UIGuildLobbyView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGuildLobbyView:Init()
end

function UIGuildLobbyView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.joystick.uIJoystick.onDragEvent:RemoveAllListeners()
end

function UIGuildLobbyView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.joystick.uIJoystick.onDragEvent:AddListener(function(dir, state)
		ManagerContainer.LuaGuildLobbyMgr:OnJoystickDrag(dir, state)
	end)

	self.uiBase:AddButtonUniqueEventListener(self.btnExit.button, self, self.OnClickExitBtn)
end

function UIGuildLobbyView:OnHide()

end

function UIGuildLobbyView:OnShow(data)
	self.controller:SetData(data)

end

function UIGuildLobbyView:OnClose()
end

function UIGuildLobbyView:OnDispose()
	self.controller:OnDispose()
end


function UIGuildLobbyView:OnClickExitBtn()
	ManagerContainer.LuaGameMgr:OpenLoading(Enum.UIPageName.UILoading)
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.LoadingState.stateId, SceneType.NormalBattleScene)
end

return UIGuildLobbyView

