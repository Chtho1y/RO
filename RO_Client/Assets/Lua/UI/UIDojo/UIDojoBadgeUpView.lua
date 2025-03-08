local UIDojoBadgeUpView = require("UIDojo/UIDojoBadgeUpView_Generate")

function UIDojoBadgeUpView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoBadgeUpCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoBadgeUpView:AddEventListener()

end

function UIDojoBadgeUpView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIDojoBadgeUpView:Init()
	local _times = GlobalConfig.Instance:GetConfigStrValue(170);
	local _timeStrs = string.split(_times, ";")
	local _delayChangeTime, _delayCloseTime = tonumber(_timeStrs[1]), tonumber(_timeStrs[2])
	self:SetLastBadge();	--先显示上一个段位的信息
	self._delayChange = ManagerContainer.LuaTimerMgr:AddTimer(_delayChangeTime, 1, self, self.SetCurBadge, nil);
	self._delayClose = ManagerContainer.LuaTimerMgr:AddTimer(_delayCloseTime, 1, self, self.CloseThisPage, nil);
end

function UIDojoBadgeUpView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoBadgeUpView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIDojoBadgeUpView:OnHide()

end

function UIDojoBadgeUpView:OnShow(data)
	self.controller:SetData(data)

end

function UIDojoBadgeUpView:OnClose()
end

function UIDojoBadgeUpView:OnDispose()
	self.controller:OnDispose()

	if self._delayChange ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._delayChange);
		self._delayChange = nil
	end
	if self._delayClose ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._delayClose);
		self._delayClose = nil
	end
end

function UIDojoBadgeUpView:CloseThisPage()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoBadgeUp)
end

--设置当前段位的信息
function UIDojoBadgeUpView:SetCurBadge()
	local _data = self.controller:GetCurArenaLevelData();
	if _data ~= nil then
		self:SetBadge(_data.ArenaLevelName, _data.LevelIcon);
	end
end

--设置上一个段位的信息
function UIDojoBadgeUpView:SetLastBadge()
	local _data = self.controller:GetLastArenaLevelData();
	if _data ~= nil then
		self:SetBadge(_data.ArenaLevelName, _data.LevelIcon);
	end
end

--设置段位的显示，包括段位名和段位对应的icon
function UIDojoBadgeUpView:SetBadge(_badgeName, _badgeIconPath)
	self.textName.text.text = _badgeName;

	CommonUtil.LoadIcon(self, _badgeIconPath, function (sprite)
		self.icon.image.sprite = sprite
	end)
end

return UIDojoBadgeUpView

