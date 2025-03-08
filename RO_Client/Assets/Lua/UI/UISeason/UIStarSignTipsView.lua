local UIStarSignTipsView = require("UISeason/UIStarSignTipsView_Generate")
local IconItemCtr = require("Common/IconItemCtr")
local updateHandle
local scrollRect
local animSpeed = {2,1,0.5,0.2}
local RewardList = {}

function UIStarSignTipsView:OnAwake(data)
	self.controller = require("UISeason/UIStarSignTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIStarSignTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.ITEM_CHANGE, self, self.InitCurrency)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.DIAMOND_CHANGED, self, self.InitGold)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.STAR_SIGN_CHANGE, self, self.OnAstroReqBack)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.STAR_SIGN_INIT, self, self.OnStartInfoInit)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.SEASON_EXCHANGE_NTF,self, self.OnStartScoreInit)
end

function UIStarSignTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end
function UIStarSignTipsView:OnStartInfoInit()
	local activeList = ManagerContainer.DataMgr.StarSignData:GetStarActiveListData()
	for i = 1, 12 do
		if activeList and activeList[i] then
			self["sign"..i].animator:Play("StarLightKeep")
		else
			self["sign"..i].animator:Play("StarLightOffKeep")
		end
	end
	for i = 1, 12 do
		self.rewardsBox["item"..i].current:SetActive(false)
	end
	self.btnAstrology.button.interactable = true
	self.btnGetRewards.button.interactable = true
	self.btnUseLucky.toggle.interactable = true
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	CommonUtil.SetTotalChildrenGray(self.btnAstrology,count == 12)
	self.btnAstrology.button.interactable = count ~= 12
	self:InitReward()
end
function UIStarSignTipsView:OnStartScoreInit(delta)
	if delta and delta > 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("CompetitionTip4", delta)
	end
	local curCompetitionData = ManagerContainer.DataMgr.CompetitionData:GetCurCompetitionData()
	self.scoreInfo.num1.text.text =	tostring(curCompetitionData.comParam)
	local delta
	if curCompetitionData.nextComScore > 0 then
		delta = curCompetitionData.nextComScore - curCompetitionData.comParam
		self.scoreInfo.text2.text.text =  I18N.SetLanguageValue("DscSeasonScoreNext")
		self.scoreInfo.num2:SetActive(true)
		self.scoreInfo.text2:SetActive(true)
	else
		if curCompetitionData.lastComScore > 0 then
			self.scoreInfo.text2.text.text = I18N.SetLanguageValue("DscSeasonScoreSecond")
			delta = curCompetitionData.comParam - curCompetitionData.lastComScore
			self.scoreInfo.num2:SetActive(true)
			self.scoreInfo.text2:SetActive(true)
		else
			self.scoreInfo.num2:SetActive(false)
			self.scoreInfo.text2:SetActive(false)
		end
	end
    self.scoreInfo.num2.text.text = delta
end

function UIStarSignTipsView:Init()
	self:InitData()
	self:InitCurrency()
	self:InitGold()
	self:InitReward()
	self:InitRewardList()
	self:OnStartScoreInit()
	ManagerContainer.DataMgr.StarSignData:SendStarInfoReq()
	if not updateHandle then
		updateHandle = UpdateBeat:CreateListener(self.Update, self)
	end
	UpdateBeat:AddListener(updateHandle)
end

function UIStarSignTipsView:InitCurrency()
	local num1 = CommonUtil.GetOwnResCountByItemId(202)
	local num2 = CommonUtil.GetOwnResCountByItemId(201)
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	self.currency1.number.text.text = CommonUtil.FormatNumber(num1)
	self.currency2.number.text.text = CommonUtil.FormatNumber(num2)
	self:RefreshItemNum(count)
end
function UIStarSignTipsView:InitGold()
	local num = CommonUtil.GetOwnResCountByItemId(2)
	self.currency3.number.text.text = CommonUtil.FormatNumber(num)
end
function UIStarSignTipsView:RewardMove()
	if  not self.isMove then
		return
	end
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	if self.currCount > 0 then
		self.rewardsBox["item"..self.currCount].current:SetActive(false)
	end
	self.currCount = count
	self:RefreshItemNum(count)
	if not self:IsCanUseLuck() then
		self.btnUseLucky.toggle.isOn = false
	end
	if count == 0  then
		return
	end
	if count > 3 and count < 11 then
		local pos
		if count == 10 then
			pos = Vector3(-25-160*(count-3),-150,0)
		else
			pos = Vector3(-15-160*(count-3),-150,0)
		end
		self.rewardsBox.content.rectTransform.localPosition = Vector3.MoveTowards(self.rewardsBox.content.rectTransform.localPosition,pos,Time.deltaTime*300)
		if Vector3.Distance(self.rewardsBox.content.rectTransform.localPosition,pos) < 0.1 then
			self.btnAstrology.button.interactable = true
			self.btnGetRewards.button.interactable = true
			self.btnUseLucky.toggle.interactable = true
			self.rewardsBox.content.rectTransform.localPosition = pos
			self.rewardsBox["item"..count].current:SetActive(true)
			self.isMove = false
		end
	else
		self.btnAstrology.button.interactable = true
		self.btnGetRewards.button.interactable = true
		self.btnUseLucky.toggle.interactable = true
		self.isMove = false
		self.rewardsBox["item"..count].current:SetActive(true)
	end
	if count == 12 then
		CommonUtil.SetTotalChildrenGray(self.btnAstrology,true)
		self.btnAstrology.button.interactable = false
	end
end
function UIStarSignTipsView:InitReward(isrefreshPos)
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	self.btnGetRewards.button.interactable = not (count == 0) and not isrefreshPos
	CommonUtil.SetTotalChildrenGray(self.btnGetRewards,count == 0)
	if not self:IsCanUseLuck() then
		self.btnUseLucky.toggle.isOn = false
	end
	self:RefreshItemNum(count)
	if count == 0 then
		self.rewardsBox.content.rectTransform.localPosition = Vector3(0,-150,0)
		return
	end
	if isrefreshPos then
		return
	end
	if self.currCount > 0 then
		self.rewardsBox["item"..self.currCount].current:SetActive(false)
	end
	self.currCount = count
	if count == 1 or count == 2 or count == 3  then
		self.rewardsBox.content.rectTransform.localPosition = Vector3(0,-150,0)
	elseif count == 10 or count == 11 or count == 12 then
		self.rewardsBox.content.rectTransform.localPosition = Vector3(-25-160*7,-150,0)
	else
		self.rewardsBox.content.rectTransform.localPosition = Vector3(-15-160*(count-3),-150,0)
	end
	self.rewardsBox["item"..self.currCount].current:SetActive(true)
	
end

function UIStarSignTipsView:RefreshItemNum(count)
	local CompetitionDevineCfg  = ManagerContainer.CfgMgr:GetCompetitionDevineCfgById(count + 1)
	if CompetitionDevineCfg and CompetitionDevineCfg.ItemPrice then
	local num =  CommonUtil.GetOwnResCountByItemId(CompetitionDevineCfg.ItemPrice[1][1])
	local itemcost = CompetitionDevineCfg.ItemPrice[1][2]
	if num >= itemcost  then
		local cfgData = ManagerContainer.CfgMgr:GetItemById(CompetitionDevineCfg.ItemPrice[1][1])
		CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
			self.btnAstrology.image.image.sprite = sprite
		end)
		self.btnAstrology.num.text.text = itemcost
	else
		if CompetitionDevineCfg.GoldPrice then
			local goldnum = CommonUtil.GetOwnResCountByItemId(CompetitionDevineCfg.GoldPrice[1][1])
			local cfgData = ManagerContainer.CfgMgr:GetItemById(CompetitionDevineCfg.GoldPrice[1][1])
			CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
				self.btnAstrology.image.image.sprite = sprite
			end)
			local goldcost = CompetitionDevineCfg.GoldPrice[1][2]
			if goldnum >= goldcost then
				self.btnAstrology.num.text.text = goldcost
			else
				self.btnAstrology.num.text.text = "<color=red>"..goldcost.."</color>"
			end
		else
			self.btnAstrology.num.text.text = I18N.SetLanguageValue("CannotUseDevinecoinNum")
		end
	end
	local IsCanUseLuck,CompetitionDevineCfg  = self:IsCanUseLuck()
	if not IsCanUseLuck then
		self.btnUseLucky.text.text.text = I18N.SetLanguageValue("CannotUseLuckyCharmNum")
		self.txt.text.text = I18N.SetLanguageValue("CannotUseLuckyCharm")
	else
		self.txt.text.text = I18N.SetLanguageValue("BtnUseLucky")
		local num2 = CommonUtil.GetOwnResCountByItemId(CompetitionDevineCfg.LuckyPrice[1][1])
		local luckycost = CompetitionDevineCfg.LuckyPrice[1][2]
		if num2 >= luckycost then
			self.btnUseLucky.text.text.text = luckycost
		else
			self.btnUseLucky.toggle.isOn = false
			self.btnUseLucky.text.text.text = "<color=red>"..luckycost.."</color>"
		end
	end
	end
end

function UIStarSignTipsView:InitRewardList()
	if RewardList and #RewardList > 0 then
		for i = 1, #RewardList do
			self.rewardsBox["item"..i].num.text.text = i
			IconItemCtr:SetData(self, self.rewardsBox["item"..i].iconSmallItem, RewardList[i], nil, self, self.OnClickItem)
		end
	else
		for i = 2, 13 do
			local data = ManagerContainer.CfgMgr:GetCompetitionDevineCfgById(i)
			local reward = data and data.Rewards and data.Rewards[1]
			local rewardData = {cfgId = reward[1], num = reward[2] }
			table.insert(RewardList,rewardData)
			self.rewardsBox["item"..(i - 1)].num.text.text = (i - 1)
			IconItemCtr:SetData(self, self.rewardsBox["item"..(i - 1)].iconSmallItem, rewardData, nil, self, self.OnClickItem)
		end
	end
end
function UIStarSignTipsView:OnClickItem(btn,params)
	local logicData = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIStarSignTipsView:InitData()
	self.currCount = 0
	self.timer = 3
	self.upOffset = 120
	self.isTurn = false
	self.data = {}
	self.btnGift:SetActive(Constant.OpenPay or false)
	self.scrollBox.arrowAnim.animator:Play("ArrowMove",-1,0)
	self.scrollBox.arrowAnim.animator.speed = 0
	self.fx_uistarsigntipseffect_01.uIParticle:PlayCachedParticalSystem(false)
	self.fx_uistarsigntipseffect_02.uIParticle:PlayCachedParticalSystem(false)
	self.btnAstrology.button.interactable = false
	self.btnGetRewards.button.interactable = false
	self.btnUseLucky.toggle.interactable = false
	self.taggetPos  = nil
	scrollRect = self.scroll.transform
	for i = 1, 12 do
		self.rewardsBox["item"..i].current:SetActive(false)
	end
	self.stopAnim:SetActive(false)
end

function UIStarSignTipsView:Update()
	if self.isTurn then
		self.timer = self.timer - Time.deltaTime
		if self.timer > 2 then
			scrollRect:Translate(Vector3.down*Time.deltaTime*8)
		 elseif self.timer > 1 then
			self.scrollBox.arrowAnim.animator.speed = animSpeed[2]
			scrollRect:Translate(Vector3.down*Time.deltaTime*6)
		elseif self.timer > 0 then
			self.fx_uistarsigntipseffect_02.uIParticle:PlayCachedParticalSystem(false)
			self.scrollBox.arrowAnim.animator.speed = animSpeed[3]
			scrollRect:Translate(Vector3.down*Time.deltaTime*3)
		else
			self.scrollBox.arrowAnim.animator.speed = animSpeed[4]
			scrollRect:Translate(Vector3.down*Time.deltaTime*1.5)
			if Vector3.Distance(scrollRect.localPosition,self.targetPos) < 15 then
				self:OnTurnStop()
			end
		end
		if scrollRect.localPosition.y <= -720  then
			scrollRect.localPosition = Vector3.New(0,720,0)
		end
	end
	self:RewardMove()
end

function UIStarSignTipsView:OnClickClose()
	if self.isTurn then
		self:OnTurnStop(true)
	end
	self:UIClose()
end
function UIStarSignTipsView:OnClickGiftShop()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.LimitTime}, self.uiData.id)
	self:UIClose()
end
function UIStarSignTipsView:OnClickRewardsList()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIStarRewardsTips,RewardList)
end
function UIStarSignTipsView:OnClickPlayRule()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'StarSignTitle', "StarSignDescText"})
end
function UIStarSignTipsView:OnClickGetRewards()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	if count == 0 then		
		return
	end
	local idx = 	RewardList[count] and 	RewardList[count].cfgId
	local cfgdata = ManagerContainer.CfgMgr:GetItemById(idx)
	local param 
	if RewardList[count].num > 1 then
		param = cfgdata.Name.." X "..RewardList[count].num
	else
		param = cfgdata.Name
	end
	ManagerContainer.LuaUIMgr:ShowMessageBox("StarSignTip",{param},nil, self, self.OnSureGetReward)
end
function UIStarSignTipsView:OnSureGetReward()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	self.btnAstrology.button.interactable = true
	CommonUtil.SetTotalChildrenGray(self.btnAstrology,false)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_STAR_CLOSE_REWARD_REQ)
end
function UIStarSignTipsView:OnClickSkip()
	self:OnTurnStop()
end

function UIStarSignTipsView:OnTurnStop(isPlayAnim)
	local target = ManagerContainer.DataMgr.StarSignData:GetStarTargetData()
	scrollRect.localPosition = Vector3.New(0,-720+120*target,0)
	self.isTurn = false
	self.timer = 3
	self.btnSkip:SetActive(false)
	self.scrollBox.arrowAnim.animator.speed = 0
	if not isPlayAnim then
		self.stopAnim:SetActive(true)
	end
	self.fx_uistarsigntipseffect_01.uIParticle:PlayCachedParticalSystem(false)
	self.fx_uistarsigntipseffect_02.uIParticle:PlayCachedParticalSystem(false)
	self.scrollBox.arrowAnim.animator:Play("ArrowMove",-1,0)
	local activeList = ManagerContainer.DataMgr.StarSignData:GetStarActiveListData()
	if not ManagerContainer.DataMgr.StarSignData:GetStarActiveLightData() then
		self["sign"..target].animator:Play("StarLightOff")
	else
		self["sign"..target].animator:Play("StarLightShow")
	end
	self.isMove = true
end

function UIStarSignTipsView:OnClickAstrology()
	local IsOver = ManagerContainer.DataMgr.CompetitionData:IsOveerCurSeason()
	if IsOver then
		self:PopErrorTips('LabelOver')
		return
	end
	if self:IsCanAugur() and not self.isTurn then
		self.btnAstrology.button.interactable = false
		self.btnGetRewards.button.interactable = false
		self.btnUseLucky.toggle.interactable = false
		if self.btnUseLucky.toggle.isOn then
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_STAR_DIVINE_REQ,{use_ticket = true})
		else
			ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_COMPETITION_STAR_DIVINE_REQ,{use_ticket = false})
		end
	end
end

function UIStarSignTipsView:IsCanAugur()
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	local CompetitionDevineCfg  = ManagerContainer.CfgMgr:GetCompetitionDevineCfgById(count + 1)
	if CompetitionDevineCfg and CompetitionDevineCfg.ItemPrice then
		if self:IsCanCost(CompetitionDevineCfg.ItemPrice[1]) then
			return true
		else
			if CompetitionDevineCfg.GoldPrice and self:IsCanCost(CompetitionDevineCfg.GoldPrice[1]) then
				return true
			else
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(CompetitionDevineCfg.GoldPrice[1][1]))
				return false
			end
		end
	end
	return false
end

function UIStarSignTipsView:IsCanCost(CostPrice)
	if CostPrice then
		local num = CommonUtil.GetOwnResCountByItemId(CostPrice[1])
		if num >= CostPrice[2] then
			return true
		else
			return false
		end
	end
	return false
end


function UIStarSignTipsView:OnAstroReqBack()
	self:InitReward(true)
	self.isTurn = true
	self.timer = 3
	self.target = ManagerContainer.DataMgr.StarSignData:GetStarTargetData()
	self.targetPos =  Vector3.New(0,-720+120*self.target,0)
	self.isSetTarget = false
	self.scrollBox.arrowAnim.animator.speed = animSpeed[1]
	self.fx_uistarsigntipseffect_01.uIParticle:PlayCachedParticalSystem(true)
	self.fx_uistarsigntipseffect_02.uIParticle:PlayCachedParticalSystem(true)
	self.stopAnim:SetActive(false)
	self.btnSkip:SetActive(true)
end

function UIStarSignTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end
function UIStarSignTipsView:PopErrorTips(key)
	ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(key)
end

function UIStarSignTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button,self,self.OnClickClose)				--点击关闭界面
	self.uiBase:AddButtonEventListener(self.btnGift.button,self,self.OnClickGiftShop)			--点击跳转占星商店
	self.uiBase:AddButtonEventListener(self.btnRewardsList.button,self,self.OnClickRewardsList)	--点击奖励列表
	self.uiBase:AddButtonEventListener(self.btnGetRewards.button,self,self.OnClickGetRewards)	--点击获取奖励
	self.uiBase:AddButtonEventListener(self.btnSkip.button,self,self.OnClickSkip)			--点击跳过动画
	self.uiBase:AddButtonEventListener(self.btnPlayRule.button,self,self.OnClickPlayRule)	--点击活动规则
	self.uiBase:AddButtonEventListener(self.btnAstrology.button,self,self.OnClickAstrology) --点击占星按钮
	self.btnUseLucky.toggle.onValueChanged:AddListener(function (isOn)
		if isOn == false then
			return
		end
		local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
		local IsCanUseLuck,CompetitionDevineCfg  = self:IsCanUseLuck()
		if IsCanUseLuck then
			local cfgId = CompetitionDevineCfg.LuckyPrice[1][1]
			local num = CommonUtil.GetOwnResCountByItemId(cfgId)
			if num >= CompetitionDevineCfg.LuckyPrice[1][2] then
				self.btnUseLucky.toggle.isOn = true
			else
				self.btnUseLucky.toggle.isOn = false	
				ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(cfgId))		
			end
		elseif  count == 12 then
			self.btnUseLucky.toggle.isOn = false
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("StarRewardMax") 
		else
			self.btnUseLucky.toggle.isOn = false
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("CannotUseLuckyCharm") 
			return
		end
	end)
end

function UIStarSignTipsView:IsCanUseLuck()
	local count = ManagerContainer.DataMgr.StarSignData:GetStarActiveCount()
	local CompetitionDevineCfg  = ManagerContainer.CfgMgr:GetCompetitionDevineCfgById(count + 1)
	return  CompetitionDevineCfg and CompetitionDevineCfg.LuckyPrice ~= nil,CompetitionDevineCfg
end

function UIStarSignTipsView:OnHide()

end

function UIStarSignTipsView:OnShow(data)
	ManagerContainer.DataMgr.StarSignData:SetData(data)

end

function UIStarSignTipsView:OnClose()
	if updateHandle ~= nil then
		UpdateBeat:RemoveListener(updateHandle)
		updateHandle = nil
	end
	self.btnUseLucky.toggle.onValueChanged:RemoveAllListeners()
	scrollRect = nil
end

function UIStarSignTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIStarSignTipsView

