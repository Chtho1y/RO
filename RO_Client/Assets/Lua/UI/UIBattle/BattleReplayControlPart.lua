local BattleReplayControlPart = class("BattleReplayControlPart")

function BattleReplayControlPart:ctor()
end

function BattleReplayControlPart:InitGo(host,uiGo)
    self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BattleReplayControl", uiGo)	
end

function BattleReplayControlPart:AddUIEventListener()
    self.host.uiBase:AddButtonEventListener(self.viewLua.exitBtn.button,self, self.OnClickExitBtn)
end

function BattleReplayControlPart:SetCanvasOrder(order)
    self.viewLua.canvas.sortingOrder = order
end

function BattleReplayControlPart:Show(levelName)
    local battleTime,fightPower = ManagerContainer.LuaBattleMgr:GetCacheRecordInfo()
    self.viewLua.levelName.text.text = levelName
    self.viewLua.passLevelTime.text.text = tostring(battleTime) .. "s"
    self.viewLua.fightPower.text.text = tostring(fightPower)
    self.viewLua:SetActive(true)
end

function BattleReplayControlPart:Hide()
    self.viewLua:SetActive(false)
end

function BattleReplayControlPart:Dispose()
end

function BattleReplayControlPart:OnClickExitBtn()
    LuaBattleBridge.SkipReplay()
end

return BattleReplayControlPart