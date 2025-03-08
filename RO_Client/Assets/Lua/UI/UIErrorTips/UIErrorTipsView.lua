local UIErrorTipsView = require("UIErrorTips/UIErrorTipsView_Generate")

local interTime = 500
local durationTime = 2.5
local errorList = {}
local errorItemName = "InfoItem"

local timerId
local erroring = false
function UIErrorTipsView:OnAwake(data)
	self.controller = require("UIErrorTips/UIErrorTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIErrorTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ERROR_DESC_DISPLAY, function(data)
		local result = self:AddNewErrorInfo(data.errorId,data.params)
		if result and not erroring then
			self:ShowErrorTimer()
			return
		end
		if result and timerId ~= nil then
			ManagerContainer.LuaTimerMgr:ResumeTimer(timerId)
		end
	end)
end

function UIErrorTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIErrorTipsView:Init()
	local data = self.controller:GetData()
	local result = self:AddNewErrorInfo(data.errorId,data.params)
	if result then
		self:ShowErrorTimer()
	end
	timerId = ManagerContainer.LuaTimerMgr:AddTimer(interTime, -1, self, self.ShowErrorTimer, nil)
end

function UIErrorTipsView:ShowErrorTimer()
	if #errorList > 0 then
		erroring = true
		ManagerContainer.GoPoolMgr:SpawnPrefabGo(errorItemName, function (itemLua)
			local message = errorList[1]
			if message then
				itemLua.text.text.text = message
				itemLua.transform:SetParent(self.transform)
				itemLua.transform.localPosition = Vector3.zero
				itemLua.transform.localScale = Vector3.one
				itemLua.transform:DOScale(1, durationTime):OnComplete(function ()
					if #errorList == 0 then
						erroring = false
						if timerId then
							ManagerContainer.LuaTimerMgr:PauseTimer(timerId)
						end
					end
					ManagerContainer.GoPoolMgr:RecycleGo(itemLua)
				end)
				table.remove(errorList, 1)
			else
				ManagerContainer.GoPoolMgr:RecycleGo(itemLua)
			end
		end)
	end
end

function UIErrorTipsView:AddNewErrorInfo(id,params)
	-- local message = id
	local message = 0
	if params ~= nil then
		message = I18N.SetLanguageValue(id,unpack(params))
	else
		message = I18N.T(id)
	end
	if tonumber(message) == id or message == "" then return false end

	errorList[#errorList + 1] = message
	if #errorList > 3 then
		for i = #errorList - 3, 1, - 1 do
			table.remove(errorList, i)
		end
	end
	return true
end

function UIErrorTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIErrorTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIErrorTipsView:OnHide()

end

function UIErrorTipsView:OnShow(data)

end

function UIErrorTipsView:OnClose()
end

function UIErrorTipsView:OnDispose()
	if timerId ~= nil then
		ManagerContainer.LuaTimerMgr:RemoveTimer(timerId)
		timerId = nil
	end


end

return UIErrorTipsView

