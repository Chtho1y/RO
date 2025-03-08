local UIIdolSupportTipsView = require("UISeason/UIIdolSupportTipsView_Generate")
local UIIdolRankItemCtr = require("Common/UIIdolRankItemCtr")

function UIIdolSupportTipsView:OnAwake(data)
	self.controller = require("UISeason/UIIdolSupportTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIIdolSupportTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIIdolSupportTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIIdolSupportTipsView:Init()
	UIIdolRankItemCtr:SetData(self,self.idolRank,self.controller:GetLogicData(),nil,self, self.OnClickSupportBtn)
	local selectNum = self.controller:GetselectNum()
	local maxNum = self.controller:GetmaxNum()
	if selectNum <= 0 then
		self.box.numBox.num.text.text = string.format("<color=red>1</color>")
		self.btnSupport.number.text.text = string.format("<color=red>1</color>")
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnMinus,true)
		self.box.numBox.btnMinus.button.interactable = false
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnPlus,true)
		self.box.numBox.btnPlus.button.interactable = false
	else
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnMinus,selectNum <= 1)
		self.box.numBox.btnMinus.button.interactable = not (selectNum <= 1)
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnPlus,selectNum == maxNum)
		self.box.numBox.btnPlus.button.interactable = not (selectNum == maxNum)
		self.box.numBox.num.text.text = selectNum
		self.btnSupport.number.text.text = selectNum
	end
	self.box.numBox.slider.slider.maxValue = maxNum == 0 and 1 or maxNum
	self.box.numBox.slider.slider.value = maxNum == 0 and 1 or maxNum
end

function UIIdolSupportTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIIdolSupportTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.btnSupport.button, self, self.OnClickSupportBtn)
	self.uiBase:AddButtonEventListener(self.box.numBox.btnMinus.button, self, self.OnClickMinusBtn)
	self.uiBase:AddButtonEventListener(self.box.numBox.btnPlus.button, self, self.OnClickPlusBtn)
	self.box.numBox.slider.slider.onValueChanged:AddListener(function(value)
		self:OnValueChangedSlider(value)
	end)
end

function UIIdolSupportTipsView:OnClickCloseBtn()
	self:UIClose()
end

function UIIdolSupportTipsView:OnClickMinusBtn()
	local selectNum = self.controller:GetselectNum()
	selectNum = selectNum - 1
	if selectNum <= 0 then
		selectNum = 1
	end
	self.box.numBox.slider.slider.value = selectNum
end

function UIIdolSupportTipsView:OnValueChangedSlider(value)
	local selectNum = self.controller:GetselectNum()
	local maxNum = self.controller:GetmaxNum()
	selectNum = value
	if value <= 0 then
		selectNum = 1
	end
	self.box.numBox.slider.slider.value = selectNum
	self.controller:SetselectNum(selectNum)
	local cfgNum = CommonUtil.GetOwnResCountByItemId(238)
	if cfgNum <= 0 then
		self.box.numBox.num.text.text = string.format("<color=red>1</color>")
		self.btnSupport.number.text.text = string.format("<color=red>1</color>")
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnMinus,true)
		self.box.numBox.btnMinus.button.interactable = false
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnPlus,true)
		self.box.numBox.btnPlus.button.interactable = false
	else
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnMinus,selectNum <= 1)
		self.box.numBox.btnMinus.button.interactable = not (selectNum <= 1)
		CommonUtil.SetTotalChildrenGray(self.box.numBox.btnPlus,selectNum == maxNum)
		self.box.numBox.btnPlus.button.interactable = not (selectNum == maxNum)
		self.box.numBox.num.text.text = selectNum
		self.btnSupport.number.text.text = selectNum
	end
end

function UIIdolSupportTipsView:OnClickOtherHeadBtn(button,params)
	local uid = params[0]
	local selfUid = ManagerContainer.DataMgr.UserData:GetUserId()
	if selfUid == uid then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ChatError1")
		return
	end
	ManagerContainer.LuaUIMgr:OpenRoleMessagePanel(uid)
end

function UIIdolSupportTipsView:OnClickPlusBtn()
	local selectNum = self.controller:GetselectNum()
	local maxNum = self.controller:GetmaxNum()
	selectNum = selectNum + 1
	if selectNum >= maxNum then
		selectNum = maxNum
	end
	self.box.numBox.slider.slider.value = selectNum
end

function UIIdolSupportTipsView:OnClickSupportBtn()
	local cfgNum = CommonUtil.GetOwnResCountByItemId(238)
	if cfgNum <= 0 then
		CommonUtil.ItemNotEnoughHandle(self.controller:GetCfgId(), self.uiData.id)
	else
		self.controller:CallBack()
		self:UIClose()
	end
end


function UIIdolSupportTipsView:OnHide()

end

function UIIdolSupportTipsView:OnShow(data)
	
end

function UIIdolSupportTipsView:OnClose()
end

function UIIdolSupportTipsView:OnDispose()
	self.controller:OnDispose()
	self.box.numBox.slider.slider.onValueChanged:RemoveAllListeners()
end

return UIIdolSupportTipsView

