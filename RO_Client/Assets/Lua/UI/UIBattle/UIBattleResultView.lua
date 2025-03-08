local UIBattleResultView = require("UIBattle/UIBattleResultView_Generate")

function UIBattleResultView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleResultCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleResultView:AddEventListener()
end

function UIBattleResultView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleResultView:Init()
	self.rewardTrans = self.transform:Find('PopWinAnim/Window/BG/ReceiveRes/Rewards/Reward')
	local winNum = self.controller:GetWinNum()
	if winNum <= 0 then
		self.battleLose:SetActive(true)
		self.battleWin:SetActive(false)
	else
		self.battleLose:SetActive(false)
		self.battleWin:SetActive(true)
	end

	local show1 = self:RefreshScoreItems()
	local show2 = self:RefreshRewardItems()
	if not show1 and not show2 then
		self.title:SetActive(false)
		self.receiveRes:SetActive(false)
		if winNum > 0 then
			self.dsc.text.text = string.formatbykey(self.controller:GetLangKey())
			self.dsc:SetActive(true)
		else
			self.dsc:SetActive(false)
		end
	else
		self.title:SetActive(true)
		self.receiveRes:SetActive(true)
		self.dsc:SetActive(false)
	end

	self.AnyBtn.button.interactable = false
	if self.canExitTimer then
		self.canExitTimer.time = self.canExitTimer.duration
	else
		self.canExitTimer = Timer.New(slot(self.OpenAnyBtnClick, self), 1)
	end
	if not self.canExitTimer.running then
		self.canExitTimer:Start()
	end

	if self.exitTimer then
		self.exitTimer.time = self.exitTimer.duration
	else
		self.exitTimer = Timer.New(slot(self.OnClickCancelBtn, self), 10)
	end
	if not self.exitTimer.running then
		self.exitTimer:Start()
	end
end

function UIBattleResultView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleResultView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickCancelBtn)
end

function UIBattleResultView:OnHide()

end

function UIBattleResultView:OnShow(data)
	self.controller:SetData(data)

end

function UIBattleResultView:OnClose()
end

function UIBattleResultView:OnDispose()
	if self.exitTimer then
		self.exitTimer:Stop()
		self.exitTimer = nil
	end
	if self.canExitTimer then
		self.canExitTimer:Stop()
		self.canExitTimer = nil
	end
	self:DisposeRewardItem()
	self.controller:OnDispose()
end

function UIBattleResultView:OnClickCancelBtn()
	self.controller:HandleCallback()
	self:UIClose()
end

function UIBattleResultView:OpenAnyBtnClick()
	self.AnyBtn.button.interactable = true
end

function UIBattleResultView:RefreshScoreItems()
	local scores = self.controller:GetScores()
	if not scores then
		self.score:SetActive(false)
		return false
	end
	self.score:SetActive(true)
	local winNum = self.controller:GetWinNum()
	self.winCount.text.text = tostring(winNum)
	if winNum > 1 then
		self.winNode:SetActive(true)
		if winNum <= 4 then
			self.winBg1:SetActive(true)
			self.winBg2:SetActive(false)
			self.winBg3:SetActive(false)
		elseif winNum <= 9 then
			self.winBg1:SetActive(false)
			self.winBg2:SetActive(true)
			self.winBg3:SetActive(false)
		else
			self.winBg1:SetActive(false)
			self.winBg2:SetActive(false)
			self.winBg3:SetActive(true)
		end
	else
		self.winNode:SetActive(false)
	end
	local oldScore = scores[1]
	local curScore = scores[2]
	self.oldScoreText.text.text = tostring(oldScore)
	self.newScoreText.text.text = tostring(curScore)
	local addScore = curScore - oldScore
	if addScore < 0 then
		self.deltaScoreText.text.text = "(" .. tostring(addScore) .. ")"
	else
		self.deltaScoreText.text.text = "(+" .. tostring(addScore) .. ")"
	end
	return true
end

function UIBattleResultView:RefreshRewardItems()
	local rewards = self.controller:GetRewards()
	if not rewards then
		self:DisposeRewardItem()
		return false
	end
	local rewardItems = self.rewardItems
	if not rewardItems then
		rewardItems = {}
		self.rewardItems = rewardItems
	end
	local len = #rewards
	for i = 1, len do
		local rewardItem = rewardItems[i]
		if not rewardItem then
			rewardItem = {}
			local newGo = UnityEngine.GameObject.Instantiate(self.rewardTrans.gameObject)
			local newTrans = newGo.transform
			newTrans:SetParent(self.rewardTrans.parent)
			newTrans.localPosition = Vector3.zero
			newTrans.localRotation = Quaternion.identity
			newTrans.localScale = Vector3.one
			rewardItem.gameObject = newGo
			rewardItem.transform = newTrans
			rewardItem.iconImg = newTrans:Find('Icon'):GetComponent(Enum.TypeInfo.Image)
			rewardItem.numTxt = newTrans:Find('Text'):GetComponent(Enum.TypeInfo.Text)
			local vipTagTrans = newTrans:Find('VipTag')
			rewardItem.vipTag = vipTagTrans.gameObject
			rewardItem.vipIconImg = vipTagTrans:Find('Icon'):GetComponent(Enum.TypeInfo.Image)
			rewardItem.vipNumTxt = vipTagTrans:Find('Number'):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
			rewardItems[i] = rewardItem
		end
		local reward = rewards[i]
		local cfgId = reward[1]
		local num = reward[2]
		local vipNum = reward[3]
		local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
		rewardItem.iconImg.enabled = false
		rewardItem.iconImg.sprite = nil
		if cfgData then
			CommonUtil.LoadIcon(self, cfgData.MiniIcon, function(sprite)
				if sprite then
					rewardItem.iconImg.sprite = sprite
					rewardItem.iconImg.enabled = true
				end
			end)
		end
		rewardItem.numTxt.text = CommonUtil.FormatNumber(num)
		local vip = false
		if vipNum and vipNum > 0 then
			local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
			if vipLv and vipLv >= 1 then
				local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
				if vipCfg then
					local precent = CommonUtil.GetPreciseDecimal((vipNum * 100) / (num - vipNum), 1)
					if precent > 0 then
						rewardItem.vipNumTxt.text = '+' .. tostring(precent) .. '%'
						rewardItem.vipTag:SetActive(true)
						rewardItem.vipIconImg.sprite = nil
						rewardItem.vipIconImg.enabled = false
						CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
							if sprite then
								rewardItem.vipIconImg.sprite = sprite
								rewardItem.vipIconImg.enabled = true
							end
						end)
						vip = true
					end
				end
			end
		end
		if not vip then
			rewardItem.vipTag:SetActive(false)
			rewardItem.vipIconImg.sprite = nil
			rewardItem.vipIconImg.enabled = false
		end
		rewardItem.gameObject:SetActive(true)
	end

	for i = len + 1, #rewardItems do
		local rewardItem = rewardItems[i]
		if rewardItem and rewardItem.gameObject then
			rewardItem.gameObject:SetActive(false)
		end
	end
	return true
end

function UIBattleResultView:DisposeRewardItem()
	if not self.rewardItems then
		return
	end
	for _, rewardItem in pairs(self.rewardItems) do
		local gameObject = rewardItem.gameObject
		rewardItem.gameObject = nil
		rewardItem.transform = nil
		rewardItem.iconImg = nil
		rewardItem.numTxt = nil
		rewardItem.vipTag = nil
		rewardItem.vipIconImg = nil
		CommonUtil.DestroyGO(gameObject)
	end
	self.rewardItems = nil
end


return UIBattleResultView

