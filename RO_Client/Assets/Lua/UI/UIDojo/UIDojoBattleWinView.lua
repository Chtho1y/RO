local UIDojoBattleWinView = require("UIDojo/UIDojoBattleWinView_Generate")

function UIDojoBattleWinView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoBattleWinCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoBattleWinView:AddEventListener()

end

function UIDojoBattleWinView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIDojoBattleWinView:Init()
	self:SetData()
end

function UIDojoBattleWinView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoBattleWinView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIDojoBattleWinView:OnHide()

end

function UIDojoBattleWinView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoBattleWinView:OnClose()
end

function UIDojoBattleWinView:OnDispose()
	if self._timer ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._timer)
		self._timer = nil
	end

	if self._delayOpenButton ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._delayOpenButton);
		self._delayOpenButton = nil
	end
end

function UIDojoBattleWinView:OnClickClose()
	self:DownSecondEnd();
end

function UIDojoBattleWinView:SetData()
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

	self:RefreshVipView(ManagerContainer.DataMgr.ArenaData.cruise)

	local winCnt = ManagerContainer.DataMgr.ArenaData.winStreakCount
	self.winCount.text.text = tostring(winCnt)
	self.winNode:SetActive(winCnt > 1)
	if winCnt <= 4 then
		self.winBg1:SetActive(true)
		self.winBg2:SetActive(false)
		self.winBg3:SetActive(false)
	elseif winCnt <= 9 then
		self.winBg1:SetActive(false)
		self.winBg2:SetActive(true)
		self.winBg3:SetActive(false)
	else
		self.winBg1:SetActive(false)
		self.winBg2:SetActive(false)
		self.winBg3:SetActive(true)
	end
	self:DownSecondStart();

	self:SetButtonState(false)
	local _delayTime = GlobalConfig.Instance:GetConfigIntValue(173) or 1000;
	self._delayOpenButton = ManagerContainer.LuaTimerMgr:AddTimer(_delayTime, 1, self, self.SetButtonCanClick, nil);
end

function UIDojoBattleWinView:DownSecondStart()
	local _second = GlobalConfig.Instance:GetConfigIntValue(150);
	self._timer = ManagerContainer.LuaTimerMgr:AddTimer(_second, 1, self, self.DownSecondEnd, nil)
end

function UIDojoBattleWinView:DownSecondEnd()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoExit)
end

function UIDojoBattleWinView:SetButtonCanClick()
	self:SetButtonState(true)
end

--设置按钮的状态
function UIDojoBattleWinView:SetButtonState(_state)
	self.AnyBtn.button.interactable = _state;
end

function UIDojoBattleWinView:RefreshVipView(cruise)
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

return UIDojoBattleWinView

