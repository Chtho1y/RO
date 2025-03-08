local UIFightPowerTipsView = require("UIFightPowerTips/UIFightPowerTipsView_Generate")

local duration = 0.8
local interTime = 0.03
local speed = 0

local timerId

local curNum, endNum, deltaNum
local unitWidth = 60
local times

local refresh

function UIFightPowerTipsView:OnAwake(data)
	self.controller = require("UIFightPowerTips/UIFightPowerTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFightPowerTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FIGHTPOWER_REFRESH_TIPS, function(data)
		self.uiBase:Show()
		self.controller:SetData(data)
		self:Init()
	end)
end

function UIFightPowerTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFightPowerTipsView:ChangeTextRectWidth(layout, num)
	local len = string.len(num)
	layout.preferredWidth = len * unitWidth
end

function UIFightPowerTipsView:Init()
	refresh = true
	self.gameObject:SetActive(false)
	self.gameObject:SetActive(true)

	local data = self.controller:GetData()
	local startNum = data.startNum
	endNum = data.endNum
	deltaNum = endNum - startNum
	times = 1
	--self.fightPowerAdd.text.text = "+"..deltaNum
	--self.fightPower.rollingNumberText:RollingNumberOver(startNum, endNum)
	--self.fightPower.rollingNumberText:Change(startNum, endNum)

	speed = math.ceil(deltaNum *interTime / duration)

	if timerId ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(timerId)
		timerId = nil
	end

	timerId = ManagerContainer.LuaTimerMgr:AddTimer(interTime * 1000, -1, self, self.ShowDelta, nil)

	curNum = startNum
	self.deltaNum.text.text = curNum

	local str = "+"..deltaNum
	self.addNum.text.text = str
	self:ChangeTextRectWidth(self.deltaNum.layoutElement, curNum)
	self:ChangeTextRectWidth(self.addNum.layoutElement, str)
end

function UIFightPowerTipsView:ShowDelta()
	times = times + 1
	curNum = curNum + speed
	curNum = math.min(endNum, curNum)
	self.deltaNum.text.text = curNum
	self:ChangeTextRectWidth(self.deltaNum.layoutElement, curNum)
	if curNum >= endNum then
		ManagerContainer.LuaTimerMgr:RemoveTimer(timerId)
		timerId = nil
		refresh = false
		self.transform:DOScale(1, 0.5):SetAutoKill():OnComplete(function ()
			if not refresh then
				self:UIClose()
			end
		end)
	end
end

function UIFightPowerTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFightPowerTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	--self.fightPower.rollingNumberText.OnComplete = function()
	--	self:UIHide(self)
	--end
end

function UIFightPowerTipsView:OnHide()

end

function UIFightPowerTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIFightPowerTipsView:OnClose()
	if timerId ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(timerId)
		timerId = nil
	end

	DG.Tweening.DOTween.Kill(self.transform)
end

function UIFightPowerTipsView:OnDispose()

end

return UIFightPowerTipsView

