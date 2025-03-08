local UINoticeTipsView = require("UICommonTips/UINoticeTipsView_Generate")

local NoticeList = {
	["ChangeJob"] = {title = "ChangeJobTitle", notice = "ChangeJobDscTxt", notice1 = "ChangeJobQuestionTxt", btnSure = "BtnTransfer"},
	["ChangeJob1"] = {title = "ChangeJobTitle", notice = "ChangeJobDscTxt_1", notice1 = "ChangeJobQuestionTxt", btnSure = "BtnTransfer"},
	["Gashapon"] = {title = "TitleGashapon", notice = "DscRecoverEgg", notice1 = "DscRecoverEgg_1", btnSure = "BtnEggRecover"},
	["TreasureSpeedUp"] = {title = "SlotBoxSpeedUpTitle", notice = "SlotBoxSpeedUpTips", notice1 = "SlotBoxSpeedUpTips1", btnSure = "SlotBoxSpeedUpTitle"},
	["ChangeFashionSure"] = {title = "FashionTitle", notice = "FashionSaveTips1", notice1 = "FashionSaveTips2", btnSure = "BtnSave"},
	["ComposeFashionSure"] = {title = "FashionComposeSure", notice = "FashionComposeSure1", notice1 = "FashionComposeSure2", btnSure = "BtnMake"},
	["DecomposeFashionSure"] = {title = "FashionTitle", notice = "FashionDecompose1", notice1 = "FashionDecompose2", btnSure = "BtnDecompose"},
	["PartnerActive"] = {title = "RecruitPartnerConfirm2", notice = "RecruitPartnerConfirm1", notice1 = "RecruitPartnerConfirm3", btnSure = "RecruitPartnerConfirm2"},
	["PartnerActive1"] = {title = "RecruitTips1", notice = "RecruitTips2", notice1 = "RecruitTips3", btnSure = "RecruitTips5", btnCancle = "RecruitTips4"},
	["LoginTips1"] = {title = "GameLogin08", notice = "GameLogin01", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips2"] = {title = "GameLogin08", notice = "GameLogin02", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips3"] = {title = "GameLogin08", notice = "GameLogin03", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips4"] = {title = "GameLogin08", notice = "GameLogin04", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips5"] = {title = "GameLogin08", notice = "GameLogin10", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips6"] = {title = "GameLogin08", notice = "GameLogin09", btnSure = "GameLogin15", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips7"] = {title = "GameLogin08", notice = "GameLogin12", btnSure = "GameLogin15", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips8"] = {title = "GameLogin08", notice = "GameLogin13", btnSure = "GameLogin15", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips9"] = {title = "GameLogin08", notice = "GameLogin23", btnSure = "GameLogin15", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips10"] = {title = "GameLogin08", notice = "ClosureAccount", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips11"] = {title = "GameLogin08", notice = "ClosureAccount1", btnSure = "GameLogin07", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips12"] = {title = "GameLogin08", notice = "GameLogin24", btnSure = "GameLogin15", btnCancle = "GameLogin06", hideClose=true},
	["LoginTips13"] = {title = "GameLogin08", notice = "GameLogin25", btnSure = "GameLogin15", btnCancle = "GameLogin06", hideClose=true},
	["SwitchServerTips"] = {title = "Tips", notice = "ChangeServer", notice1 = "FashionDecompose2", btnSure = "BtnConfirm"},
	["UnfollowPlayer"] = {title = "Tips", notice = "RemoveFollow", notice1 = "FashionDecompose2", btnSure = "BtnConfirm"},
	["NotifyTips"] = {title = "Tips", notice = "QuitGameConfirm", notice1 = "FashionDecompose2", btnSure = "BtnQuit"},
	["SkillExpBattleTips"] = {title = "ChallengeTitle", notice = "ChallengeNotice1", notice1 = "ChallengeNotice1", btnSure = "BtnChallenge"},
	["EvilRefreshRefreshCD"] = {title = "EvilRefreshRefreshTitle", notice = "EvilRefreshRefreshNotice1", notice1 = "", btnSure = "BtnRefreshRefresh"},
	["EvilRefreshSlotCD"] = {title = "EvilRefreshSlotTitle", notice = "EvilRefreshSlotNotice1", notice1 = "EvilRefreshSlotNotice2", btnSure = "BtnRefreshSlot"},
	["EvilOverFlowTips"] = {title = "Tips", notice = "UISkillExpBattleInfo_3", notice1 = "", btnSure = "BtnRefreshSlot"},
	['GuildDismiss'] = {title = "Tips", notice = "GuildTips_010", notice1 = "", btnSure = "BtnConfirm"},
	['GuildExit'] = {title = "Tips", notice = "GuildTips_006", notice1 = "", btnSure = "BtnConfirm"},
	['GuildUpPresident'] = {title = "Tips", notice = "GuildTips_015", notice1 = "", btnSure = "BtnConfirm"},
	['GuildUpVicePresident'] = {title = "Tips", notice = "GuildTips_017", notice1 = "", btnSure = "BtnConfirm"},
	['GuildDownMember'] = {title = "Tips", notice = "GuildTips_019", notice1 = "", btnSure = "BtnConfirm"},
	['GuildKickout'] = {title = "Tips", notice = "GuildTips_021", notice1 = "", btnSure = "BtnConfirm"},
	['GuildSettingSure'] = {title = "Tips", notice = "GuildTips_013", notice1 = "", btnSure = "BtnConfirm"},
	['ShopRefreshSure'] = {title = "ShopRefreshTips", notice = "ShopRefreshTips1", notice1 = "ShopRefreshTips2", btnSure = "BtnConfirm"},
	['ConvertHeadFrame'] = {title = "ConvertHeadFrameTitle", notice = "ConvertHeadFrameNotice", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify1"] = {title = "Tips", notice = "Petcompound_006", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify2"] = {title = "Tips", notice = "Petcompound_004", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify3"] = {title = "Tips", notice = "Petcompound_005", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify4"] = {title = "Tips", notice = "Petadvance_003", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify5"] = {title = "Tips", notice = "Petcompound_003", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify6"] = {title = "Tips", notice = "Petfight_005", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify7"] = {title = "Tips", notice = "Petcompound_008", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify8"] = {title = "Tips", notice = "Petcompound_009", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify9"] = {title = "Tips", notice = "Petadvance_006", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify10"] = {title = "Tips", notice = "Petcompound_010", notice1 = "", btnSure = "BtnConfirm"},
	["PetCostNotify11"] = {title = "Tips", notice = "Petcompound_011", notice1 = "", btnSure = "BtnConfirm"},
	["PetExchangetips"] = {title = "Tips", notice = "PetExchangetips", notice1 = "", btnSure = "BtnConfirm"},
	["PetExchangetips2"] = {title = "Tips", notice = "PetExchangetips2", notice1 = "", btnSure = "BtnConfirm"},	
	["EnterExpeditionMapTip"] = {title = "Tips", notice = "ExpeditionChallenge", notice1 = "", btnSure = "BtnConfirm"},
	["ExpeditionCallHelp"] = {title = "Tips", notice = "ExpeditionCallHelpContent", notice1 = "", btnSure = "BtnConfirm"},
	["SummonNoItemTip"] = {title = "Tips", notice = "InsufficientQuantity", notice1 = "Areyousure", btnSure = "BtnConfirm"},
	["SummonNoDiamondTip"] = {title = "Tips", notice = "InsufficientGold", notice1 = "GoTo", btnSure = "BtnGoto"},
	["NoDiamondTip"] = {title = "Tips", notice = "InsufficientGold", notice1 = "GoTo", btnSure = "BtnGoto"},
	['HundredDojoChallengeNumTip'] = {title = "HundredDojoTips1", notice = "HundredDojoTips2", notice1 = "HundredDojoTips3", btnSure = "BtnConfirm"},
	["QuitBattleTip"] = {title = "Tips", notice = "ExitFight", notice1 = "ExitFight2", btnSure = "BtnQuit"},
	["LoginActivityTip"] = {title = "Tips", notice = "FortnightOnlineReplace", notice1 = "", btnSure = "BtnConfirm"},
	["ErrorQuitBattleTip"] = {title = "Tips", notice = "BattleWatchError", notice1 = "", btnSure = "BtnQuit"},

	["GuildWarAutoChangllengeTip"] = {title = "Tips", notice = "GuildWarCount2", notice1 = "GuildWarCount3", btnSure = "BtnConfirm"},
	["GuildWarAutoRebornTip"] = {title = "Tips", notice = "GuildWardebuff2", notice1 = "GuildWardebuff3", btnSure = "BtnConfirm"},
	["GuildWarBuyRebornTip"] = {title = "Tips", notice = "GuildWardebuff1", notice1 = "GuildWardebuff3", btnSure = "BtnConfirm"},
	["GuildWarBuyBuffTip"] = {title = "Tips", notice = "GuildWarBuff1", notice1 = "", btnSure = "BtnConfirm"},

	--平阶转职
	["ChangeJob2"] = {title = "ChangeJobTitle", notice = "ChangeJobDscTxt_2", notice1 = "ChangeJobQuestionTxt", btnSure = "BtnTransfer"},
	["ChangeJob3"] = {title = "ChangeJobTitle", notice = "ChangeJobDscTxt_3", notice1 = "ChangeJobQuestionTxt", btnSure = "BtnTransfer"},
	["SureChangeServerTip"] = {title = "Tips", notice = "ServerSwitchingTips", notice1 = "", btnSure = "BtnConfirm"},
	--集字
	["ActivityCollectTip"] = {title = "Tips", notice = "SetsWordActivity03", notice1 = "", btnSure = "BtnConfirm"},
	--道具不足 金币转换
	["CantUseGold"] = {title = "Tips", notice = "InsufficientQuantity", notice1 = "", btnSure = "BtnConfirm"},
	--是否可以结束本轮二次确认
	["TurningCanOver"] = {title = "Tips", notice = "WheelEndConfirm", notice1 = "", btnSure = "BtnConfirm"},
	["OnLineUseGold"] = {title = "Tips", notice = "OnlineRewards", notice1 = "", btnSure = "BtnConfirm"},

	--卡片一键合成提示
	["CardForgeMvpTip"] = {title = "Tips", notice = "CardCompositionTips", notice1 = "", btnSure = "BtnConfirm"},
	--占星奖励二次确认
	["StarSignTip"] = {title = "ReceiveAward", notice = "GetStarSignReward", notice1 = "IsGetReward", btnSure = "BtnConfirm"},

	["VoyageUpAirShipTip1"] = {title = "UpgradeShipTitle", notice = "UpgradeShipTips", notice1 = "UpgradeShipDesc", btnSure = "BtnConfirm"},
	["VoyageUpAirShipTip2"] = {title = "UpgradeShipTitle", notice = "TopShipTips", notice1 = "UpgradeShipDesc", btnSure = "BtnConfirm"},
	["VoyageUpAirShipTip3"] = {title = "TitleVoyageLv", notice = "DscVoyageLv", notice1 = "DscVoyageCount", btnSure = "BtnConfirm"},

	--神器提示
	["SkillEquipDecomposeTip1"] = {title = "Tips", notice = "ArtifactSmeltButtonTips2", notice1 = "", btnSure = "BtnConfirm"},
	["SkillEquipDecomposeTip2"] = {title = "Tips", notice = "ArtifactSmeltButtonTips3", notice1 = "", btnSure = "BtnConfirm"},
	["TitleDecomposeTips"] = {title = "Tips", notice = "TitleDecomposeTips", notice1 = "", btnSure = "BtnConfirm"},

	["PeakTowerBuyTips"] = {title = "Tips", notice = "NoticeBuyRoad", notice1 = "", btnSure = "BtnConfirm"},

	["SkillEquipReforgeTips"] = {title = "Tips", notice = "ArtifactReforgeTips01", notice1 = "ArtifactReforgeTips02", btnSure = "BtnConfirm"},
	["SkillEquipTransTips"] = {title = "Tips", notice = "ArtifactTransTips01", notice1 = "ArtifactTransTips02", btnSure = "BtnConfirm"},

	--宠物契约
	["PetQiyueUnlock"] = {title = "Tips", notice = "PetContractUnlockConsumption", notice1 = "", btnSure = "BtnConfirm", needCost = true},
	["PetQiyueRemoveAll"] = {title = "Tips", notice = "PetContractTips", notice1 = "", btnSure = "BtnConfirm"},
	--许愿槽位空间解锁提示
	["WishSlotUnlockTips"] = {title = "WishunlockTitle", notice = "DscWishunlock1", notice1 = "DscWishunlock2", btnSure = "BtnConfirm"},
	["CardTransTips"] = {title = "Tips", notice = "TransCardTips01", notice1 = "TransCardTips02", btnSure = "BtnConfirm"},
	["ShareVideoTips"] = {title = "ShareTitle", notice = "ShareContent", notice1 = "", btnSure = "BtnConfirm"},
}

function UINoticeTipsView:OnAwake(data)
	self.controller = require("UICommonTips/UINoticeTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UINoticeTipsView:AddEventListener()

end

function UINoticeTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UINoticeTipsView:Init()
	local data = self.controller:GetData()
	local idx = data[1]
	local params = data[2]
	local params1 = data[7]
	local cost = data[8]

	self.noticeTitle.uILocalizeScript:SetContent(NoticeList[idx].title)
    self.questionTxt.uILocalizeScript:SetContentAndValues(NoticeList[idx].notice1, params1)
	self.dscBox.dscTxt.uILocalizeScript:SetContentAndValues(NoticeList[idx].notice, params)
	self.btnSure.uILocalizeScript:SetContent(NoticeList[idx].btnSure)
	if NoticeList[idx].btnCancle then
		self.btnCancleText.uILocalizeScript:SetContent(NoticeList[idx].btnCancle)
	else
		self.btnCancleText.uILocalizeScript:SetContent("BtnCancle")
	end

	if NoticeList[idx].hideCancel then
		self.btnClose:SetActive(false)
		self.btnCancle:SetActive(false)
	else
		if NoticeList[idx].hideClose then
			self.btnClose:SetActive(false)
		else
			self.btnClose:SetActive(true)
		end
		self.btnCancle:SetActive(true)
	end

	if NoticeList[idx].needCost then
		self.btnClose:SetActive(false)
		self.btnCancle:SetActive(false)
		self.btnRight:SetActive(false)

		self.btnOpen:SetActive(true)
		if cost then
			local costId = cost[1]
			local count = cost[2]
			local costNum = cost[3]

			local cfgData = ManagerContainer.CfgMgr:GetItemById(costId)
			if cfgData then
				CommonUtil.LoadIcon(self, cfgData.Icon, function (sprite)
					self.btnOpen.icon.image.sprite = sprite
				end)
				if count < costNum then
					count = string.format(Constant.RedColorText, count)
				end
				self.btnOpen.num.text.text = string.format("%s/%s", count, costNum)
			end
		end
	else
		self.btnRight:SetActive(true)
		self.btnOpen:SetActive(false)
	end

	self.questionTxt:SetActive(NoticeList[idx].notice1~=nil and NoticeList[idx].notice1~="")
end

function UINoticeTipsView:OnBtnSureClick()
	local data = self.controller:GetData()
	local logicData = data[3]
	local sureOwner = data[4]
	local sureCb = data[5]

	if not self:InvokeCallbackMethod(sureOwner, sureCb, logicData) then
		self:CloseUI()
	end
end

function UINoticeTipsView:OnBtnCancelClick()
	local data = self.controller:GetData()
	local logicData = data[3]
	local owner = data[4]
	local cancelCb = data[6]

	if not self:InvokeCallbackMethod(owner, cancelCb, logicData) then
		self:CloseUI()
	end
end

function UINoticeTipsView:InvokeCallbackMethod(owner, ownerCB, logicData)
	if ownerCB then
		if owner then
			return ownerCB(owner, logicData)
		else
			return ownerCB(logicData)
		end
	end
	return false
end

function UINoticeTipsView:OnBtnCloseClick()
	local data = self.controller:GetData()
	local idx = data[1]
	if NoticeList[idx].hideClose then
		return
	end
	self:CloseUI()
end

function UINoticeTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UINoticeTipsView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnBtnCloseClick)
	self.uiBase:AddButtonEventListener(self.btnCancle.button, self, self.OnBtnCancelClick)
	self.uiBase:AddButtonEventListener(self.btnOpen.button, self, self.OnBtnSureClick)

	self.uiBase:AddButtonEventListener(self.btnRight.button, self, self.OnBtnSureClick)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnBtnCloseClick)
end

function UINoticeTipsView:CloseUI()
	self:UIClose()
end

function UINoticeTipsView:OnHide()

end

function UINoticeTipsView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UINoticeTipsView:OnClose()
end

function UINoticeTipsView:OnDispose()

end

return UINoticeTipsView

