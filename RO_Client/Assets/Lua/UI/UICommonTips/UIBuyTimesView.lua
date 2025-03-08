local UIBuyTimesView = require("UICommonTips/UIBuyTimesView_Generate")

function UIBuyTimesView:OnAwake(data)
	self.controller = require("UICommonTips/UIBuyTimesCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBuyTimesView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIBuyTimesView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()

	self.BuyCount = 1
	self:SetUIData()
end

function UIBuyTimesView:Init()
end

function UIBuyTimesView:RefreshCostGold()
	if not self.controller:IsGuildDemon() then
		local cost = self.controller:GetCostNum()
		self.costText.text.text = tostring(cost * self.BuyCount)	
		if not self.controller:IsCanBuy(self.BuyCount) then
			CommonUtil.SetTextColor(self.costText.text, Constant.RedColorText)
		end
	else
		local cost = self.controller:GetCostNumByGuildDemon(self.BuyCount)
		self.costText.text.text = tostring(cost)	
		if not self.controller:IsCanBuyByGuildDemon(cost) then
			CommonUtil.SetTextColor(self.costText.text, Constant.RedColorText)
		end
	end
end

function UIBuyTimesView:SetUIData()	
	local remainCount = self.controller:GetRemainCount()
	if remainCount then
		self.leftTimesText.text.text = tostring(remainCount)
	end	
	if not self.controller:IsOver() then	
		self:SetSliderMinMax(1,remainCount)
		if remainCount <= 1 then
			self:SetSliderMinMax(0,remainCount)
		end
		self.number.text.text = tostring(self.BuyCount)
		self.slider.slider.value = self.BuyCount		
	else
		self:SetSliderMinMax(0,0)
		self.BuyCount = 0
		self.number.text.text = tostring(self.BuyCount)		
	end
	self:RefreshCostGold()
end

function UIBuyTimesView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
	self.slider.slider.onValueChanged:RemoveAllListeners()
end

function UIBuyTimesView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.buyBtn.button,self, self.OnClickBuy)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)

	self.uiBase:AddButtonEventListener(self.btnMinus.button,self, self.OnReduceClick)
	self.uiBase:AddButtonEventListener(self.btnPlus.button,self, self.OnSumClick)

	self.slider.slider.onValueChanged:RemoveAllListeners()
	self.slider.slider.onValueChanged:AddListener(function(value)
		self:OnValueChangedSlider(value)
	end)
end

function UIBuyTimesView:SetSliderMinMax(Min,Max)
	self.slider.slider.wholeNumbers = true
	self.slider.slider.minValue = Min
	self.slider.slider.maxValue = Max
end

function UIBuyTimesView:OnValueChangedSlider(value)
	local remainCount = self.controller:GetRemainCount()
	if not self.controller:IsOver() then
		if remainCount <= 1 then
			self.slider.slider.value = 1
			self.BuyCount = remainCount			
		else
			self.BuyCount = value			
		end
		self.number.text.text = tostring(self.BuyCount)	
	else
		self.slider.slider.value = 1
		self.BuyCount = 0
		self.number.text.text = tostring(self.BuyCount)	
	end
	self:RefreshCostGold()
end	

function UIBuyTimesView:OnReduceClick()	
	local remainCount = self.controller:GetRemainCount()
	self.BuyCount = self.BuyCount - 1
	if self.BuyCount < 1 then
		self.BuyCount = 1
	end
	if remainCount > 1 then
		self.slider.slider.value = self.BuyCount
	end	
end

function UIBuyTimesView:OnSumClick()	
	local remainCount = self.controller:GetRemainCount()
	self.BuyCount = self.BuyCount + 1
	if self.BuyCount > remainCount then
		self.BuyCount = remainCount
	end
	if remainCount > 1 then		
		self.slider.slider.value = self.BuyCount
	end
end

function UIBuyTimesView:OnClickBuy()
	if self.controller:IsOver() then
		--购买次数达到上限
		CommonUtil.PopErrorTips('312')
	else
		--是否金钱足够购买
		if not self.controller:IsCanBuy(self.BuyCount) then
			CommonUtil.PopErrorTips('313')
		else
			self.controller:HandleCallback(self.BuyCount)
			self:OnClickClose()
		end
	end
end

function UIBuyTimesView:OnClickClose()
	self.delayTimer = FrameTimer.New(function()
		ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
	end, 1)
	self.delayTimer:Start()
end

function UIBuyTimesView:OnHide()

end

function UIBuyTimesView:OnClose()

end
function UIBuyTimesView:OnShow(data)
	self.controller:SetData(data)
end

function UIBuyTimesView:OnDispose()
	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
end

return UIBuyTimesView
