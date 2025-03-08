local UIChangeHeadView = require("UIRoleMessage/UIChangeHeadView_Generate")

function UIChangeHeadView:OnAwake(data)
	self.controller = require("UIRoleMessage/UIChangeHeadCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChangeHeadView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.USER_HEADPROTRAIT_CHANGED, self, self.OnChangeHeadEvent)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.USER_HEADPROTRAIT_DATA_CHANGED, self, self.OnHeadDataChanged)
end

function UIChangeHeadView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChangeHeadView:Init()
	self.conditionTxts = { self.conditionTxt }
	--self:RefreshHeadIcon()
	self:OpenChangeHead()
end

function UIChangeHeadView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIChangeHeadView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseChangeHead)
	--self.uiBase:AddButtonEventListener(self.alpha.button, self, self.OnClickCloseChangeHead)
	self.uiBase:AddButtonEventListener(self.unlockBtn.button, self, self.OnClickChangeHeadUnlock)
	self.uiBase:AddButtonEventListener(self.usedBtn.button, self, self.OnClickChangeHeadUse)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickCloseChangeHead)
end

function UIChangeHeadView:OnHide()

end

function UIChangeHeadView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIChangeHeadView:OnClose()
end

function UIChangeHeadView:OnDispose()
	self.changeList.loopVerticalScrollRect:ClearCells()

	if self.conditionTxts then
		for _, value in pairs(self.conditionTxts) do
			-- self.changeHead.conditionTxt其它地方有释放，这里可处理，也可不处理，目前不处理
			if value ~= self.conditionTxt then
				if tolua.getpeer(value) then
					tolua.setpeer(value, nil)
				end
			end
		end
	end

end

----Custom start----
function UIChangeHeadView:OnChangeHeadEvent()
	--self:RefreshHeadIcon()
	self.controller:RefreshHeadPortraitsSort()
	self:RefreshGridView()
	self:RefreshContent()
end

function UIChangeHeadView:OnHeadDataChanged()
	self:RefreshContent();
end

function UIChangeHeadView:OnHeadDataEvent(isInit)
	self.controller:RefreshHeadPortraitsSort()
	if isInit then
		self:OpenChangeHead()
	else
		self:RefreshChangeHead()
	end
end

function UIChangeHeadView:OpenChangeHead()
	--[[
	if not ManagerContainer.DataMgr.HeadProtraitData:IsVaild() then
		ManagerContainer.DataMgr.HeadProtraitData:SendGetHeadInfo()
		return
	end
]]--
	-- 获得可换头像列表
	local datas = self.controller:GetHeadPortraits()
	self.curSelectHeadId = ManagerContainer.DataMgr.UserData:GetUserHeadPortraitId() or datas[1].cfgId
	self:RefreshContent()
	CommonUtil.LoopGridViewEleCreate(self,
			self.changeList.loopVerticalScrollRect,
			self.content.gridLayoutGroup,
			datas,
			0,
			function(itemlua, idx)
				local data = datas[idx + 1]
				data.selected = (self.curSelectHeadId == data.cfgId)
				CommonUtil.UpdateItemPrefab(self, itemlua, data, nil, self, self.OnClickHeadItem)
			end)
end
--[[
function UIChangeHeadView:RefreshHeadData(isInit)
	if isInit then
		self:OpenChangeHead()
	else
		self:RefreshChangeHead()
	end
end
]]--
function UIChangeHeadView:RefreshChangeHead()
	self:RefreshGridView()
	self:RefreshContent()
end

function UIChangeHeadView:OnClickHeadItem(btn, params)
	local cfgData = params[0]
	self.curSelectHeadId = cfgData.cfgId
	self:RefreshChangeHead()
end

function UIChangeHeadView:RefreshGridView()
	self.changeList.loopVerticalScrollRect:RefreshCells()
end

function UIChangeHeadView:RefreshContent()
	local HeadProtraitData = ManagerContainer.DataMgr.HeadProtraitData
	local state = HeadProtraitData:GetState(self.curSelectHeadId)
	local canUnlock = (state == Enum.TaskStateType.CompletedAndNoReceive)
	local unlocked = (state == Enum.TaskStateType.Received)
	local used = (ManagerContainer.DataMgr.UserData:GetUserHeadPortraitId() == self.curSelectHeadId)
	self.usedBtn.gameObject:SetActive(unlocked);
	self.unlockBtn.gameObject:SetActive(not unlocked);
	if unlocked then
		self.unlockConditions:SetActive(false)
		self.usedBtn.button.interactable = (not used);
		if used then
			self.text.text.text = I18N.T("BtnUsing");	--使用中
		else
			self.text.text.text = I18N.T("BtnChange");	--更换
		end
	else
		self.unlockConditions:SetActive(true)
		self.unlockBtn.button.interactable = canUnlock;
		local cfgData = ManagerContainer.CfgMgr:GetHeadPortraitDataById(self.curSelectHeadId)
		local conditions = nil
		local conditionId = nil
		if cfgData then
			conditionId = cfgData.UnlockCondition
			local unlockCondCfgData = ManagerContainer.CfgMgr:GetCondDataById(cfgData.UnlockCondition)
			if unlockCondCfgData then
				local condition = unlockCondCfgData.Condition
				if type(condition[1]) == 'table' then
					conditions = condition
				else
					conditions = {condition}
				end
			end
		end
		local count = #self.conditionTxts
		local vaildNum = conditions and #conditions or 0
		for i = 1, vaildNum do
			local txt = self.conditionTxts[i]
			if not txt then
				txt = UnityEngine.GameObject.Instantiate(self.conditionTxt)
				txt.transform.parent = self.conditionTxt.transform.parent
				txt.transform.localPosition = Vector3.zero
				txt.transform.localRotation = Quaternion.identity
				txt.transform.localScale = Vector3.one
				if tolua.getpeer(txt) == nil then
					tolua.setpeer(txt, {})
				end
				txt.text = txt:GetComponent(Enum.TypeInfo.Text)
				self.conditionTxts[i] = txt
			end
			local condition = conditions[i]
			local max = condition[3]
			local str
			local progress = HeadProtraitData:GetProgress(self.curSelectHeadId, conditionId, condition[1])
			if progress >= max or canUnlock then
				str = '    <color=#009900>(' .. progress .. '/' .. max .. ')</color>'
			else
				str = '    <color=#990000>(' .. progress .. '/' .. max .. ')</color>'
			end
			txt.text.text = CommonUtil.TaskDescParse(condition) .. str
			txt:SetActive(true)
		end
		-- 隐藏多余显示
		for i = vaildNum + 1, count do
			local txt = self.conditionTxts[i]
			if txt then
				txt:SetActive(false)
			end
		end
	end
end

function UIChangeHeadView:OnClickCloseChangeHead()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChangeHead);
end

function UIChangeHeadView:OnClickChangeHeadUnlock()
	local errorCode = self.controller:GetActiveHeadProtraitError(self.curSelectHeadId)
	if errorCode == 0 then
		ManagerContainer.DataMgr.HeadProtraitData:SendActiveHead(self.curSelectHeadId)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIChangeHeadView:OnClickChangeHeadUse()
	local errorCode = self.controller:GetSetHeadProtraitError(self.curSelectHeadId)
	if errorCode == 0 then
		ManagerContainer.DataMgr.HeadProtraitData:SendSetHead(self.curSelectHeadId)
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end


return UIChangeHeadView

