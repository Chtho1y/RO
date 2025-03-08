local UIGetNowPopView = require("UIBag/UIGetNowPopView_Generate")

function UIGetNowPopView:OnAwake(data)
	self.controller = require("UIBag/UIGetNowPopCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIGetNowPopView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIGetNowPopView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIGetNowPopView:Init()
	local data = self.controller:GetData()
	local cfgId = data.cfgId
	local needNum = data.needNum
	local timeTxt = data.timeTxt
	local idx = data.idx
	local itemData = ManagerContainer.CfgMgr:GetItemById(cfgId)
	if itemData then
		local hasNum = CommonUtil.GetOwnResCountByItemId(cfgId)
		self.LeftTimesLbl.text.text = timeTxt
		self.dscTxt.text.text = I18N.T("DscWishaccelerate1")
		local txt = ""
		if hasNum < needNum then
			txt = string.format(Constant.RedColorText,hasNum).."/"..needNum
		else
			txt =  hasNum.."/"..needNum
		end
		self.numcost.text.text = txt
		CommonUtil.LoadIcon(self, itemData.Icon, function (sprite)
			self.icon.image.sprite = sprite
		end)
	end
end

function UIGetNowPopView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIGetNowPopView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.CloseBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnGetNow.button, self, self.OnClickGetNowBtn)
end

function UIGetNowPopView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	if self.uiBase.MSourceUIID > 0 then
		ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
	end
end

function UIGetNowPopView:OnClickGetNowBtn()
	local data = self.controller:GetData()
	local cfgId = data.cfgId
	local needNum = data.needNum
	local timeTxt = data.timeTxt
	local idx = data.idx
	local wishSlotData = ManagerContainer.DataMgr.BagData:GetWishSlotData()
	if not wishSlotData then
		return
	end
	local hasNum = CommonUtil.GetOwnResCountByItemId(cfgId)
	local wishData = wishSlotData[idx]
	if wishData then
		local remainTime = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(wishData.end_time * 1000)
		if remainTime > 0 then
			if hasNum < needNum then
				CommonUtil.ItemNotEnoughHandle(cfgId)
			else
				ManagerContainer.DataMgr.BagData:SendWishAccelerateReq(idx - 1)
			end
		else
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("WishacceleratTime0")
		end
	end
	self:OnClickCloseBtn()
end

function UIGetNowPopView:OnHide()

end

function UIGetNowPopView:OnShow(data)
	self.controller:SetData(data)

end

function UIGetNowPopView:OnClose()
end

function UIGetNowPopView:OnDispose()
	self.controller:OnDispose()
end

return UIGetNowPopView

