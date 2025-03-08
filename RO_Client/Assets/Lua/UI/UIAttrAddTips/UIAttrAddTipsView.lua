local UIAttrAddTipsView = require("UIAttrAddTips/UIAttrAddTipsView_Generate")

local specialAttrKey = {
	[1] = "DscCardBlessTips2",
}

local interTime = 500
local durationTime = 2
local upVal = 300

local itemList = {}
local itemluaList = {}
local itemName = "AttrTipItem"

local timerId
function UIAttrAddTipsView:OnAwake(data)
	self.controller = require("UIAttrAddTips/UIAttrAddTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIAttrAddTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ADD_ATTR_DISPLAY, function(data)
		local result = self:AddNewAttrInfo(data)

		if not result then return end
		--ManagerContainer.LuaTimerMgr:ResumeTimer(timerId)

		self:ShowAddTimer()
		--self.uiBase:Show()
	end)
end

function UIAttrAddTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIAttrAddTipsView:Init()
	--timerId = ManagerContainer.LuaTimerMgr:AddTimer(interTime, -1, self, self.ShowAddTimer, nil)

	local result = self:AddNewAttrInfo(self.controller:GetData())

	if not result then return end

	self:ShowAddTimer()
end

function UIAttrAddTipsView:AddNewAttrInfo(data)
	local oldAttrs = data[1]
	local newAttrs = data[2]
	if not oldAttrs or not newAttrs then
		return false
	end

	local hasNewAttr = false
	for _,v in pairs(newAttrs) do
		v = SDataUtil.InvConvert(v)
		if v > 0 then
			hasNewAttr = true
			break
		end
	end

	if not hasNewAttr then
		return false
	end

	itemList[#itemList + 1] = data
	if #itemList > 3 then
		for i = #itemList, 1, - 1 do
			if i <= #itemList - 3 then
				table.remove(itemList, i)
			end
		end
	end
	return true
end

local function IncreaseOrReduceAttr(value)
	return CommonUtil.FormatNumber(value)
end

function UIAttrAddTipsView:ShowAddTimer()
	if #itemList > 0 then
		ManagerContainer.GoPoolMgr:SpawnGo(Enum.PrefabNames.AttrTipItem, function (itemLua)
			table.insert(itemluaList, itemLua)
			local data = itemList[1]
			local oldAttrs = data[1]
			local newAttrs = data[2]
			local specialAttrList = data[3]

			local list = {}
			for k,v in pairs(oldAttrs) do
				local num = SDataUtil.InvConvert(v)
				local num1 = SDataUtil.InvConvert(newAttrs[k])

				if SDataUtil.IsGreater(num1,num) then
					list[#list + 1] = {key = k, old = num, new = num1}
				end
			end
			if #list > 0 and specialAttrList and #specialAttrList > 0 then
				for i = 1, #specialAttrList do
					table.insert(list,i,{key = specialAttrKey[i], old = specialAttrList[i][1], new = specialAttrList[i][2]});
				end
			end
			if #list > 0 then
				itemLua.transform:SetParent(self.transform)
				itemLua.transform.localPosition = Vector3.zero + Vector3.up * 100
				itemLua.transform.localScale = Vector3.one
				CommonUtil.LoopGridViewEleCreate(self, itemLua.loopVerticalScrollRect, itemLua.content.gridLayoutGroup, list, 0, function (itemLua1, idx)
					local data = list[idx + 1]
					if  data and type(data.key) == "string" then
						itemLua1.type.uILocalizeScript:SetContent(data.key)
						itemLua1.number1.text.text = Mathf.Abs(Mathf.Floor(SDataUtil.InvConvert(data.old)))
						itemLua1.number2.text.text = Mathf.Abs(Mathf.Floor(SDataUtil.InvConvert(data.new)))
					else
						itemLua1.type.uILocalizeScript:SetContent("Attr_"..data.key)
						itemLua1.number1.text.text = CommonUtil.HeroAttrFormatValueNoSign(data.key, data.old, true)
						itemLua1.number2.text.text = CommonUtil.HeroAttrFormatValueNoSign(data.key, data.new, true)
					end
					--itemLua1.type.uILocalizeScript:SetContent("Attr_"..data.key)
				end)

				--itemLua.transform:DOLocalMoveY(itemLua.transform.localPosition.y + upVal, durationTime):OnComplete(function ()
				--
				--	CommonUtil.DestroyGO(itemLua.gameObject)
				--	itemLua = nil
				--end)
				itemLua.transform:DOScale(1, durationTime):OnComplete(function ()

					for i = 1, #itemluaList do
						if itemluaList[i] == itemLua then
							table.remove(itemluaList, i)
							break
						end
					end
					itemLua.loopVerticalScrollRect:ClearCells();
					ManagerContainer.GoPoolMgr:RecycleGo(itemLua)

					if #itemList == 0 then
						--self:UIHide()
					end
				end)
			else
				for i = 1, #itemluaList do
					if itemluaList[i] == itemLua then
						table.remove(itemluaList, i)
						break
					end
				end
				itemLua.loopVerticalScrollRect:ClearCells();
				ManagerContainer.GoPoolMgr:RecycleGo(itemLua)
			end
			table.remove(itemList, 1)
		end , itemName)
	end
end

function UIAttrAddTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIAttrAddTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIAttrAddTipsView:OnHide()

end

function UIAttrAddTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIAttrAddTipsView:OnClose()
	--ManagerContainer.LuaTimerMgr:RemoveTimer(timerId)
	for i = 1,#itemluaList do
		local itemlua = itemluaList[i]
		itemlua.loopVerticalScrollRect:ClearCells();
		ManagerContainer.GoPoolMgr:RecycleGo(itemlua)
	end
	itemList = {}
end

function UIAttrAddTipsView:OnDispose()

end

return UIAttrAddTipsView

