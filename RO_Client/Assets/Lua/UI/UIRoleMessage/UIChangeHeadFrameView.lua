local UIChangeHeadFrameView = require("UIRoleMessage/UIChangeHeadFrameView_Generate")
local TaskJumpCtr = require("Common/TaskJumpCtr")
local IconItemCtr = require("Common/IconItemCtr")

function UIChangeHeadFrameView:OnAwake(data)
	self.controller = require("UIRoleMessage/UIChangeHeadFrameCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIChangeHeadFrameView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.HEAD_FRAME_CHANGE, self, self.RefreshHeadFrameList);
end

function UIChangeHeadFrameView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIChangeHeadFrameView:Init()
	self.curSelectedFrameData = nil
	self.curSelectedItem = nil
	self:SetHead()
end

function UIChangeHeadFrameView:OnPageInEnd()
	self:RefreshHeadFrameList()
	self.super.OnPageInEnd(self)
end

function UIChangeHeadFrameView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIChangeHeadFrameView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnCloseBtnClick)
	self.uiBase:AddButtonEventListener(self.btnUsed.button, self, self.OnChangeBtnClick)
	self.uiBase:AddButtonEventListener(self.btnGet.button, self, self.OnGetBtnClick)
	self.uiBase:AddButtonEventListener(self.allAtrBtn.button, self, self.OnAllAttrBtnClick)
end

function UIChangeHeadFrameView:OnHide()
end

function UIChangeHeadFrameView:OnShow(data)
	self.controller:SetData(data)
end

function UIChangeHeadFrameView:OnClose()
	ManagerContainer.DataMgr.HeadFrameDataMgr:SaveRedPointData()
end

function UIChangeHeadFrameView:OnDispose()
	self.headFrameList.loopVerticalScrollRect:ClearCells()
	self.curSelectedFrameData = nil
	self.curSelectedItem = nil
	self.controller:OnDispose()
end

function UIChangeHeadFrameView:SetHead()
	local curRoleLv = ManagerContainer.DataMgr.UserData:GetRoleLv()
	local jobIcon = ManagerContainer.DataMgr.UserData:GetJobIcon()
	local headIcon = ManagerContainer.DataMgr.UserData:GetUserHeadIcon()
	local _fakerData = {Level = curRoleLv, ProfessionIcon = jobIcon, HeadIcon = headIcon, IsHero = true};
	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();
	CommonUtil.SetPlayerHeadAndFrame(self, self.headItem, _fakerData,false, _headFrameId, self, self.OnClickHead);
end

function UIChangeHeadFrameView:RefreshHeadFrameList()
	local _headFrameId = ManagerContainer.DataMgr.UserData:GetHeadFrameId();
	self:PreviewHeadFrame(_headFrameId)

	-- self.headFrameList.loopVerticalScrollRect:ClearCells()
	local frameList = ManagerContainer.DataMgr.HeadFrameDataMgr:GetAllHeadFrames()
	CommonUtil.LoopGridViewEleCreateNew(self,self.headFrameList.loopVerticalScrollRect,nil,frameList,0,self,self.SetHeadFrameItem);
end

function UIChangeHeadFrameView:SetHeadFrameItem(itemLua, idx, frameData)
	CommonUtil.LoadIcon(self, frameData.icon, function (sprite)
		itemLua.frameImg.image.sprite = sprite
	end,self,"HeadFrameAsync"..idx)
	
	itemLua.used:SetActive(frameData:IsUsing())
	itemLua.locked:SetActive((frameData:IsGot() or frameData:IsLoss()))
	itemLua.redPoint:SetActive(frameData.redPointState);
	itemLua.limited:SetActive(frameData:GetLeftTime() > 0)
	itemLua.selected:SetActive(self.curSelectedFrameData == frameData)
	if self.curSelectedFrameData == frameData then
		self.curSelectedItem = itemLua
	end
	self.uiBase:AddButtonUniqueEventListener(itemLua.frameImg.button, self, self.OnItemClick, frameData, itemLua)
end

function UIChangeHeadFrameView:OnItemClick(btn, params)
	local frameData = params[0]
	local itemLua = params[1]

	if self.curSelectedItem ~= nil then
		self.curSelectedItem.selected:SetActive(false)
	end

	itemLua.selected:SetActive(true)
	itemLua.redPoint:SetActive(false)
	self.curSelectedItem = itemLua
	frameData:SetRedPointStatus(false)
	self:PreviewHeadFrame(frameData.frameId)
end

function UIChangeHeadFrameView:PreviewHeadFrame(headFrameId)
	local frameData = ManagerContainer.DataMgr.HeadFrameDataMgr:GetHeadFrameById(headFrameId)
	if frameData ~= nil then
		self:SetFrameDataInfo(frameData)
        CommonUtil.LoadIcon(self, frameData.icon, function (sprite)
            self.headItem.frame.image.sprite = sprite
		end)
		
		if frameData:IsUsing() or frameData:IsActivated() then
			self.btnUsed:SetActive(true)
			self.btnGet:SetActive(false)
			self.usingTip:SetActive(false)
			self.limitedNode:SetActive(true)
		elseif frameData:IsGot() then
			self.btnUsed:SetActive(false)
			self.btnGet:SetActive(true)
			self.usingTip:SetActive(false)
			self.limitedNode:SetActive(false)
		else
			self.limitedNode:SetActive(false)
			self.btnUsed:SetActive(false)
			self.btnGet:SetActive(true)
			self.usingTip:SetActive(false)
		end
		self.frameNode:SetActive(true)
	else
		self.frameNode:SetActive(false)
		self.btnUsed:SetActive(false)
		self.btnGet:SetActive(false)
		self.usingTip:SetActive(false)
	end
	self.curSelectedFrameData = frameData
end

function UIChangeHeadFrameView:OnClickHead()
	-- ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(I18N.T("ChatError1"))	--这是你自己
end

function UIChangeHeadFrameView:SetFrameDataInfo(frameData)
	-- LogError("click frameId:" .. frameData.frameId)
	self:HideAllAttrGo()
	self.headFrameName.text.text = frameData.name
	self.headFrameDesc.text.text = frameData.desc
	self.leftTimeTxt.text.text =  self:CalcTimeStr(frameData:GetLeftTime())
	
	local attrs = frameData:GetAttrs()
	if attrs ~= nil then
		for i =1, #attrs do
			local attr = attrs[i]
			local attrLua = self:GetAttrItemGo(i)
			if attrLua ~= nil and attr ~= nil then
				attrLua.nameText.text.text = I18N.T("Attr_"..attr[1])
				attrLua.numberText.text.text = CommonUtil.HeroAttrFormatValueNoSign(attr[1], attr[2])
				attrLua:SetActive(true)
			end
		end
		self.attrNone:SetActive(#attrs == 0)
	else
		self.attrNone:SetActive(true)
	end
end

function UIChangeHeadFrameView:HideAllAttrGo()
	for idx = 1, 3 do
		local go = self:GetAttrItemGo(idx)
		if go ~= nil then
			go:SetActive(false)
		end
	end
end

function UIChangeHeadFrameView:GetAttrItemGo(idx)
	if idx == 1 then
		return self.attrBox.attrItem1
	elseif idx == 2 then
		return self.attrBox.attrItem2
	elseif idx == 3 then
		return self.attrBox.attrItem3
	end
	return nil
end

function UIChangeHeadFrameView:CalcTimeStr(_timeSecond)
	local _timeStr = I18N.T("Forever");	--永久
	if _timeSecond >= 0 then
		_timeStr = tostring(_timeSecond);
		local _timeNumber = tonumber(_timeStr)
		if _timeSecond >= 60 and _timeSecond < Constant.OneDaySeconds then
			_timeStr = DateTimeUtil.convertSeconds2TimeStr1(_timeNumber, true, false, false);
		elseif _timeSecond >= Constant.OneDaySeconds then
			_timeStr = DateTimeUtil.convertSeconds2TimeStr1(_timeNumber, false, false, false);
		else
			_timeStr = "1" .. I18N.T("MINS");
		end
	end
	return _timeStr;
end

function UIChangeHeadFrameView:OnChangeBtnClick()
	if self.curSelectedFrameData == nil then
		return
	end

	if self.curSelectedFrameData:IsUsing() then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("已使用")
		return
	end

	ManagerContainer.DataMgr.HeadFrameDataMgr:SendChangeHeadFrameReq(self.curSelectedFrameData.frameId)
end

function UIChangeHeadFrameView:OnGetBtnClick()
	if self.curSelectedFrameData == nil then
		return
	end

	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(self.curSelectedFrameData.tips)
end

function UIChangeHeadFrameView:OnAllAttrBtnClick()
	local allFrames = ManagerContainer.DataMgr.HeadFrameDataMgr:GetAllHeadFrames()
	local attrList = {}
	for i = 7, 16 do
		if i ~= 8 then
			attrList[i] = 0
		end
	end

	if allFrames ~= nil then
		for i=1, #allFrames do
			local frame = allFrames[i]
			if frame:IsOwned() then
				local attrs = frame:GetAttrs()
				if attrs ~= nil then
					for j = 1, #attrs do
						if attrList[attrs[j][1]] == nil then
							attrList[attrs[j][1]] = attrs[j][2]
						else
							attrList[attrs[j][1]] =  attrList[attrs[j][1]] + attrs[j][2]
						end
					end
				end
			end
		end
	end

	local baseAttrs = {}
	for key, value in pairs(attrList) do
		table.insert(baseAttrs, {key, value})
	end

	table.sort(baseAttrs, function(a, b)
		return a[1] < b[1]
	end)

	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIFashionTotal,{title="HeadFrameTotalProperty", attrs=baseAttrs})
end

function UIChangeHeadFrameView:OnCloseBtnClick()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIChangeHeadFrame);
end

return UIChangeHeadFrameView

