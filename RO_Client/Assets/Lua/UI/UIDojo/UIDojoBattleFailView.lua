local UIDojoBattleFailView = require("UIDojo/UIDojoBattleFailView_Generate")

function UIDojoBattleFailView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoBattleFailCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoBattleFailView:AddEventListener()

end

function UIDojoBattleFailView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIDojoBattleFailView:Init()
	self:SetData()
end

function UIDojoBattleFailView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoBattleFailView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIDojoBattleFailView:OnHide()

end

function UIDojoBattleFailView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoBattleFailView:OnClose()
end

function UIDojoBattleFailView:OnDispose()
	if self._timer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._timer)
		self._timer = nil
	end

	if self._delayOpenButton ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._delayOpenButton);
		self._delayOpenButton = nil
	end
end

function UIDojoBattleFailView:OnClickClose()
	self:DownSecondEnd();
end

function UIDojoBattleFailView:SetData()
	local data = self.controller:GetData()
	local oldScore = 0
	local curScore = 0
	if data ~= nil then
		oldScore = data[1]
		curScore = data[2]
	end

	self.ZenyLbl.text.text = tostring(ManagerContainer.DataMgr.ArenaData.zeny)
	self.CruiseLbl.text.text = tostring(ManagerContainer.DataMgr.ArenaData.cruise)
	self.oldScoreText.text.text = tostring(oldScore)
	self.newScoreText.text.text = tostring(curScore)
	self.deltaScoreText.text.text = "(+" .. tostring(curScore - oldScore) .. ")"
	self:DownSecondStart();

	self:RefreshVipView(ManagerContainer.DataMgr.ArenaData.cruise)

	self:SetButtonState(false)
	local _delayTime = GlobalConfig.Instance:GetConfigIntValue(173) or 1000;
	self._delayOpenButton = ManagerContainer.LuaTimerMgr:AddTimer(_delayTime, 1, self, self.SetButtonCanClick, nil);
end

function UIDojoBattleFailView:DownSecondStart()
	local _second = GlobalConfig.Instance:GetConfigIntValue(150);
	self._timer = ManagerContainer.LuaTimerMgr:AddTimer(_second, 1, self, self.DownSecondEnd, nil)
end

function UIDojoBattleFailView:DownSecondEnd()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoExit)
end

function UIDojoBattleFailView:SetButtonCanClick()
	self:SetButtonState(true)
end

--设置按钮的状态
function UIDojoBattleFailView:SetButtonState(_state)
	self.AnyBtn.button.interactable = _state;
end

function UIDojoBattleFailView:RefreshVipView(cruise)
	if cruise and cruise > 0 then
		local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
		if vipLv and vipLv >= 1 then
			local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
			if vipCfg then
				if vipCfg.PvpReward and vipCfg.PvpReward > 0 then
					local precent = CommonUtil.GetPreciseDecimal((vipCfg.PvpReward * 100) / (cruise - vipCfg.PvpReward), 1)
					if precent > 0 then
						self.CruiseVipTag.number.text.text = '+' .. tostring(precent) .. '%'
						self.CruiseVipTag:SetActive(true)
						self.CruiseVipTag.icon.image.sprite = nil
						self.CruiseVipTag.icon.image.enabled = false
						CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
							if sprite then
								self.CruiseVipTag.icon.image.sprite = sprite
								self.CruiseVipTag.icon.image.enabled = true
							end
						end)
						return
					end
				end
			end
		end
	end
	self.CruiseVipTag:SetActive(false)
	self.CruiseVipTag.icon.image.sprite = nil
	self.CruiseVipTag.icon.image.enabled = false
end

return UIDojoBattleFailView

