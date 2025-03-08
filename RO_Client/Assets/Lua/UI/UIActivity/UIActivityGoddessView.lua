local UIActivityGoddessView = require("UIActivity/UIActivityGoddessView_Generate")

function UIActivityGoddessView:OnAwake(data)
	self.controller = require("UIActivity/UIActivityGoddessCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIActivityGoddessView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.EID_Activity_Data_Change,self,self.OnActivityDataChanged)
end

function UIActivityGoddessView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIActivityGoddessView:Init()
	self.controller:InitData()
	self:RefreshBg()
	self.lastLoveLv = nil
	self.lastLoveVal = nil
	self:RefreshTimer()
	self:RefreshLoveGifts()
	self:RefreshOwnerGifts()
	self:OpenGiveGift(nil)
end

function UIActivityGoddessView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIActivityGoddessView:AddUIEventListener()
	self.uiBase:AddButtonUniqueEventListener(self.btnInfo.button, self, self.OnClickInfoBtn)
	self.uiBase:AddButtonUniqueEventListener(self.backBtn.button, self, self.OnClickBackBtn)
	self.uiBase:AddButtonUniqueEventListener(self.giveTipsClickRect.button, self, self.OnClickGiveTipsClickRect)
end

function UIActivityGoddessView:OnHide()

end

function UIActivityGoddessView:OnShow(data)
	self.controller:SetData(data)

end

function UIActivityGoddessView:OnClose()
end

function UIActivityGoddessView:OnDispose()
	self.curGiveGiftIdx = nil
	if self.endTimer then
		if self.endTimer.running then
			self.endTimer:Stop()
		end
		self.endTimer = nil
	end
	self.lastLoveLv = nil
	self.lastLoveVal = nil
	self:DisposeLoveGiftItems()
	self:DisposeOwnerGiftItems()
	self:DisposeGiveGiftItems()
	self.controller:OnDispose()
end

function UIActivityGoddessView:OnActivityDataChanged(activityId)
	local actItem = self.controller:GetActivityData()
	if actItem == nil or actItem.actId ~= activityId then
		return
	end
	self:RefreshTimer()
	self:RefreshLoveGifts()
	self:RefreshOwnerGifts()
	self:RefreshGiveGifts()
end

function UIActivityGoddessView:OnClickBackBtn()
	self:UIClose()
	if self.uiBase.MSourceUIID > 0 then
        ManagerContainer.LuaUIMgr:Open(self.uiBase.MSourceUIID)
    end
end

function UIActivityGoddessView:OnClickInfoBtn()
	local actItem = self.controller:GetActivityData()
	if not actItem then return end
	if not actItem.infoLangKey or actItem.infoLangKey == '' then return end
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIPlayRule, {'PlayExplainTitle', actItem.infoLangKey})
end

function UIActivityGoddessView:OnClickItemBtn(_, params)
	local data = params[0]
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIActivityGoddessView:OnClickOwnerGiftItem(_, params)
	local idx = params[2]
	self:OpenGiveGift(idx)
end

function UIActivityGoddessView:OnClickGiveTipsClickRect()
	self:OpenGiveGift(nil)
end

function UIActivityGoddessView:OnClickGiveGiftItem(_, params)
	local data = params[0]
	local idx = params[2]
	local errorCode = self.controller:SendGiveLikabilityReq(self.curGiveGiftIdx, data.cfgId, idx)
	if errorCode and errorCode ~= 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(errorCode)
	end
end

function UIActivityGoddessView:RefreshBg()
	self.banner.image.enabled = false
	self.banner.image.sprite = nil
	CommonUtil.LoadIcon(self, self.controller:GetBg(), function(sprite)
		if sprite then
			self.banner.image.sprite = sprite
			self.banner.image.enabled = true
		end
	end)
end

function UIActivityGoddessView:RefreshTimer()
	local actItem = self.controller:GetActivityData()
	local remainTime = 0
	if actItem and actItem:IsLimited() then
		remainTime = actItem:LeftTime()
		if remainTime < 0 then
			remainTime = 0
		end
	end
	if remainTime < 60 then
		self.timeTxt.text.text = I18N.SetLanguageValue('ActCloseTime', I18N.T('LessOneMinu'))
		if self.endTimer and self.endTimer.running then
			self.endTimer:Stop()
		end
		return
	else
		self.timeTxt.text.text = I18N.SetLanguageValue('ActCloseTime', DateTimeUtil.convertSeconds2TimeStr1(remainTime, true, false, false))
	end
	local validTime = nil
	if remainTime >= 86400 then
		validTime = remainTime % 3600
		if validTime == 0 then validTime = 3600 end
	elseif remainTime >= 3600 then
		validTime = remainTime % 60
		if validTime == 0 then validTime = 60 end
	else
		validTime = 1
	end
	if not self.endTimer then
		self.endTimer = Timer.New(slot(self.RefreshTimer, self), validTime, -1)
	else
		self.endTimer.duration = validTime
	end
	if not self.endTimer.running then
		self.endTimer:Start()
	end
end

function UIActivityGoddessView:RefreshLoveGifts()
	local actItem = self.controller:GetActivityData()
	if not actItem then
		self.favoring:SetActive(false)
		return
	end
	self.favoring:SetActive(true)
	local curLoveLv = actItem:GetCurLoveLv()
	local curLoveVal = actItem:GetCurLoveVal()
	local actId = self.controller:GetActId()
	local cfgData = ManagerContainer.CfgMgr:GetActivityGoddessLoveCfgByLv(actId, curLoveLv)
	self.favoring.lv.text.text = tostring(curLoveLv)
	if not cfgData or not cfgData.LikeMax or cfgData.LikeMax <= 0 then
		self.favoring.lv.text.text = string.formatbykey('LikeLevelMax')
		self.favoring.slider.num.text.text = '0'
		self.favoring.slider.slider.value = 1
	elseif cfgData.LikeMax <= curLoveVal then
		self.favoring.lv.text.text = string.formatbykey('LikeLevelMax')
		self.favoring.slider.num.text.text = tostring(cfgData.LikeMax)
		self.favoring.slider.slider.value = 1
	else
		self.favoring.lv.text.text = tostring(curLoveLv)
		self.favoring.slider.num.text.text = tostring(curLoveVal)
		self.favoring.slider.slider.value = curLoveVal / cfgData.LikeMax
	end
	if self.lastLoveLv and self.lastLoveVal then
		local upVal = 0
		if self.lastLoveLv == curLoveLv then
			if self.lastLoveVal < curLoveVal then
				upVal = (curLoveVal - self.lastLoveVal)
			end
		elseif self.lastLoveLv < curLoveLv then
			upVal = curLoveVal
			local tempCfgData = ManagerContainer.CfgMgr:GetActivityGoddessLoveCfgByLv(actId, self.lastLoveLv)
			if tempCfgData then
				upVal = upVal + (tempCfgData.LikeMax - self.lastLoveVal)
			end
			for i = self.lastLoveLv + 1, curLoveLv - 1 do
				tempCfgData = ManagerContainer.CfgMgr:GetActivityGoddessLoveCfgByLv(actId, i)
				if tempCfgData then
					upVal = upVal + tempCfgData.LikeMax
				end
			end
		end
		if upVal > 0 then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('LikeUpNum', tostring(upVal))
		end
	end
	self.lastLoveLv = curLoveLv
	self.lastLoveVal = curLoveVal

	local loveGiftItems = self.loveGiftItems
	if not loveGiftItems then
		loveGiftItems = {self.favoring.item}
		self.loveGiftItems = loveGiftItems
	end
	local len1 = #loveGiftItems
	local len2 = 0
	if cfgData and cfgData.Conditionrewards then
		local rectW  = self.favoring.slider.slider.handleRect.parent.rect.width
		local defPos = self.favoring.item.transform.anchoredPosition3D
		len2 = #cfgData.Conditionrewards
		for i = 1, len2 do
			local loveGiftItem = nil
			local trans = nil
			if i <= len1 then
				loveGiftItem = loveGiftItems[i]
				trans = loveGiftItem.transform
			else
				loveGiftItem = UnityEngine.GameObject.Instantiate(self.favoring.item.gameObject)
				trans = loveGiftItem.transform
				trans:SetParent(self.favoring.item.transform.parent)
				trans.localRotation = Quaternion.identity
				trans.localScale = Vector3.one
				if tolua.getpeer(loveGiftItem) == nil then
					tolua.setpeer(loveGiftItem, {})
				end
				local tmp = trans:Find('text/num').gameObject
				if tolua.getpeer(tmp) == nil then
					tolua.setpeer(tmp, {})
				end
				loveGiftItem.num = tmp
				tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
				tmp = trans:Find('IconSmallItem').gameObject
				if tolua.getpeer(tmp) == nil then
					tolua.setpeer(tmp, {})
				end
				loveGiftItem.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
				loveGiftItem.iconSmallItem.prefabName = "IconItem"
				tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
				tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
				loveGiftItems[i] = loveGiftItem
			end
			loveGiftItem:SetActive(true)
			local reward = cfgData.Conditionrewards[i]
			local loveVal = reward[1]
			local posX = rectW
			if cfgData.LikeMax and cfgData.LikeMax > 0 then
				posX = posX * ((loveVal / cfgData.LikeMax) - 0.5)
			end
			trans.anchoredPosition3D = Vector3(posX, defPos.y, defPos.z)
			loveGiftItem.num.text.text = tostring(loveVal)
			if curLoveVal >= loveVal then
				CommonUtil.UpdateItemPrefab(self, loveGiftItem.iconSmallItem, {cfgId = reward[2], num = reward[3]}, Enum.ItemIEnterType.Bag)
				CommonUtil.SetTotalChildrenGray(loveGiftItem.iconSmallItem.gameObject, true)
			else
				CommonUtil.SetTotalChildrenGray(loveGiftItem.iconSmallItem.gameObject, false)
				CommonUtil.UpdateItemPrefab(self, loveGiftItem.iconSmallItem, {cfgId = reward[2], num = reward[3]}, Enum.ItemIEnterType.Bag, self, self.OnClickItemBtn)
			end
		end
	end
	for i = len2 + 1, len1 do
		if loveGiftItems[i] then
			loveGiftItems[i]:SetActive(false)
		end
	end
end

function UIActivityGoddessView:DisposeLoveGiftItems()
	local loveGiftItems = self.loveGiftItems
	if not loveGiftItems then
		return
	end
	for _, loveGiftItem in pairs(loveGiftItems) do
		if loveGiftItem and loveGiftItem ~= self.favoring.item then
			local go = loveGiftItem.gameObject
			if loveGiftItem.iconSmallItem.GenerateDestroy ~= nil then
				loveGiftItem.iconSmallItem:GenerateDestroy()
			end
			if tolua.getpeer(loveGiftItem.iconSmallItem) ~= nil then
				tolua.setpeer(loveGiftItem.iconSmallItem, nil)
			end
			if tolua.getpeer(loveGiftItem.num) ~= nil then
				tolua.setpeer(loveGiftItem.num, nil)
			end
			if tolua.getpeer(loveGiftItem) ~= nil then
				tolua.setpeer(loveGiftItem, nil)
			end
			CommonUtil.DestroyGO(go)
		end
	end
	self.loveGiftItems = nil
end

function UIActivityGoddessView:RefreshOwnerGifts()
	local actItem = self.controller:GetActivityData()
	if not actItem then
		self.owenGift:SetActive(false)
		return
	end
	self.owenGift:SetActive(true)
	local ownerGiftItems = self.ownerGiftItems
	if not ownerGiftItems then
		ownerGiftItems = {self.owenGift.item}
		self.ownerGiftItems = ownerGiftItems
	end
	local actId = self.controller:GetActId()
	local cfgDatas = ManagerContainer.CfgMgr:GetActivityGoddessGiftCfgByActId(actId)
	local len1 = #ownerGiftItems
	local len2 = 0
	if cfgDatas then
		len2 = #cfgDatas
		for i = 1, len2 do
			local ownerGiftItem = nil
			local trans = nil
			if i <= len1 then
				ownerGiftItem = ownerGiftItems[i]
				trans = ownerGiftItem.transform
			else
				ownerGiftItem = UnityEngine.GameObject.Instantiate(self.owenGift.item.gameObject)
				trans = ownerGiftItem.transform
				trans:SetParent(self.owenGift.transform)
				trans.localPosition = Vector3.zero
				trans.localRotation = Quaternion.identity
				trans.localScale = Vector3.one
				if tolua.getpeer(ownerGiftItem) == nil then
					tolua.setpeer(ownerGiftItem, {})
				end
				local tmp = trans:Find('Num/num').gameObject
				if tolua.getpeer(tmp) == nil then
					tolua.setpeer(tmp, {})
				end
				ownerGiftItem.num = tmp
				tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
				tmp = trans:Find('IconItem').gameObject
				if tolua.getpeer(tmp) == nil then
					tolua.setpeer(tmp, {})
				end
				ownerGiftItem.iconItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
				ownerGiftItem.iconItem.prefabName = "IconItem"
				tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
				tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
				ownerGiftItems[i] = ownerGiftItem
			end
			ownerGiftItem:SetActive(true)
			local cfgData = cfgDatas[i]
			ownerGiftItem.num.text.text = CommonUtil.FormatNumber(CommonUtil.GetOwnResCountByItemId(cfgData.Classitemid))
			CommonUtil.UpdateItemPrefab(self, ownerGiftItem.iconItem, {cfgId = cfgData.Classitemid}, Enum.ItemIEnterType.Bag, self, self.OnClickOwnerGiftItem, i)
		end
	end
	for i = len2 + 1, len1 do
		if ownerGiftItems[i] then
			ownerGiftItems[i]:SetActive(false)
		end
	end
end

function UIActivityGoddessView:DisposeOwnerGiftItems()
	local ownerGiftItems = self.ownerGiftItems
	if not ownerGiftItems then
		return
	end
	for _, ownerGiftItem in pairs(ownerGiftItems) do
		if ownerGiftItem and ownerGiftItem ~= self.owenGift.item then
			local go = ownerGiftItem.gameObject
			if ownerGiftItem.iconItem.GenerateDestroy ~= nil then
				ownerGiftItem.iconItem:GenerateDestroy()
			end
			if tolua.getpeer(ownerGiftItem.iconItem) ~= nil then
				tolua.setpeer(ownerGiftItem.iconItem, nil)
			end
			if tolua.getpeer(ownerGiftItem.num) ~= nil then
				tolua.setpeer(ownerGiftItem.num, nil)
			end
			if tolua.getpeer(ownerGiftItem) ~= nil then
				tolua.setpeer(ownerGiftItem, nil)
			end
			CommonUtil.DestroyGO(go)
		end
	end
	self.ownerGiftItems = nil
end

function UIActivityGoddessView:OpenGiveGift(idx)
	local actItem = self.controller:GetActivityData()
	if not actItem then
		return
	end
	if self.curGiveGiftIdx == idx then
		return
	end
	self.curGiveGiftIdx = idx
	if not idx then
		self.giveTipsClickRect:SetActive(false)
		self.giveTips:SetActive(false)
		return
	end
	self.giveTipsClickRect:SetActive(true)
	self.giveTips:SetActive(true)
	self:RefreshGiveGifts()
end

function UIActivityGoddessView:RefreshGiveGifts()
	if not self.curGiveGiftIdx then
		return
	end
	local actId = self.controller:GetActId()
	local cfgDatas = ManagerContainer.CfgMgr:GetActivityGoddessGiftCfgByActId(actId)
	if not cfgDatas then
		self:OpenGiveGift(nil)
		return
	end
	local cfgData = cfgDatas[self.curGiveGiftIdx]
	if not cfgDatas then
		self:OpenGiveGift(nil)
		return
	end
	local giveGiftItems = self.giveGiftItems
	if not giveGiftItems then
		giveGiftItems = {self.giveTips.item}
		self.giveGiftItems = giveGiftItems
	end
	local len1 = #giveGiftItems
	local len2 = 0
	local giveGifts = cfgData.Classcostaddlike
	if giveGifts then
		local cfgId = cfgData.Classitemid
		local ownerNum = CommonUtil.GetOwnResCountByItemId(cfgId)
		local data = {cfgId = cfgId}
		len2 = #giveGifts
		for i = 1, len2 do
			local giveGiftItem = nil
			local trans = nil
			if i <= len1 then
				giveGiftItem = giveGiftItems[i]
				trans = giveGiftItem.transform
			else
				giveGiftItem = UnityEngine.GameObject.Instantiate(self.giveTips.item.gameObject)
				trans = giveGiftItem.transform
				trans:SetParent(self.giveTips.transform)
				trans.localPosition = Vector3.zero
				trans.localRotation = Quaternion.identity
				trans.localScale = Vector3.one
				if tolua.getpeer(giveGiftItem) == nil then
					tolua.setpeer(giveGiftItem, {})
				end
				local tmp = trans:Find('text/num').gameObject
				if tolua.getpeer(tmp) == nil then
					tolua.setpeer(tmp, {})
				end
				giveGiftItem.num = tmp
				tmp.text = tmp:GetComponent(Enum.TypeInfo.Text)
				tmp = trans:Find('IconSmallItem').gameObject
				if tolua.getpeer(tmp) == nil then
					tolua.setpeer(tmp, {})
				end
				giveGiftItem.iconSmallItem = CommonUtil.BindGridViewItem2LuaStatic("IconItem", tmp)
				giveGiftItem.iconSmallItem.prefabName = "IconItem"
				tmp.rectTransform = tmp:GetComponent(Enum.TypeInfo.RectTransform)
				tmp.layoutElement = tmp:GetComponent(Enum.TypeInfo.LayoutElement)
				giveGiftItems[i] = giveGiftItem
			end
			giveGiftItem:SetActive(true)
			local giveGift = giveGifts[i]
			if ownerNum < giveGift[1] then
				giveGiftItem.num.text.text = string.format(Constant.RedColorText, '+' .. tostring(giveGift[2]))
				CommonUtil.UpdateItemPrefab(self, giveGiftItem.iconSmallItem, {cfgId = cfgId, num = giveGift[1]}, Enum.ItemIEnterType.Bag)
				CommonUtil.SetTotalChildrenGray(giveGiftItem.iconSmallItem.gameObject, true)
			else
				giveGiftItem.num.text.text = '+' .. tostring(giveGift[2])
				CommonUtil.SetTotalChildrenGray(giveGiftItem.iconSmallItem.gameObject, false)
				CommonUtil.UpdateItemPrefab(self, giveGiftItem.iconSmallItem, {cfgId = cfgId, num = giveGift[1]}, Enum.ItemIEnterType.Bag, self, self.OnClickGiveGiftItem, i)
			end
		end
	end
	for i = len2 + 1, len1 do
		if giveGiftItems[i] then
			giveGiftItems[i]:SetActive(false)
		end
	end
	local transform = self.giveTips.transform
	ManagerContainer.LuaUIMgr:ForceRebuildLayoutImmediate(transform)
	local posX = 0
	local arrowPos = nil
	local item = self.ownerGiftItems[self.curGiveGiftIdx]
	if item then
		arrowPos = item.transform.position
		posX = self.giveTipsOffsetRect.transform.parent:InverseTransformPoint(arrowPos).x
		local halfW = transform.rect.width * 0.5
		local rect = self.giveTipsOffsetRect.transform.rect
		if rect.xMin > (posX - halfW) then
			posX = (rect.xMin + halfW)
		end
		if rect.xMax < (posX + halfW) then
			posX = (rect.xMax - halfW)
		end
	else
		arrowPos = Vector3.zero
	end
	local pos = transform.anchoredPosition3D
	transform.anchoredPosition3D = Vector3(posX, pos.y, pos.z)
	transform = self.giveTips.arrow.transform
	local oldPos = transform.position
	oldPos.x = arrowPos.x
	transform.position = oldPos
end

function UIActivityGoddessView:DisposeGiveGiftItems()
	local giveGiftItems = self.giveGiftItems
	if not giveGiftItems then
		return
	end
	for _, giveGiftItem in pairs(giveGiftItems) do
		if giveGiftItem and giveGiftItem ~= self.giveTips.item then
			local go = giveGiftItem.gameObject
			if giveGiftItem.iconSmallItem.GenerateDestroy ~= nil then
				giveGiftItem.iconSmallItem:GenerateDestroy()
			end
			if tolua.getpeer(giveGiftItem.iconSmallItem) ~= nil then
				tolua.setpeer(giveGiftItem.iconSmallItem, nil)
			end
			if tolua.getpeer(giveGiftItem.num) ~= nil then
				tolua.setpeer(giveGiftItem.num, nil)
			end
			if tolua.getpeer(giveGiftItem) ~= nil then
				tolua.setpeer(giveGiftItem, nil)
			end
			CommonUtil.DestroyGO(go)
		end
	end
	self.giveGiftItems = nil
end

return UIActivityGoddessView

