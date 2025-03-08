local UIPopGotSingleView = require("UIPOPGot/UIPopGotSingleView_Generate")

--local UIMainCtr = require('UIMain/UIMainCtr')
--local UIBattleCtr = require('UIBattle/UIBattleCtr')
local UIMainCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIMain)
local UIBattleCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIBattle)

local DOTween = DG.Tweening.DOTween

function UIPopGotSingleView:OnAwake(data)
	self.controller = require("UIPOPGot/UIPopGotSingleCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPopGotSingleView:AddEventListener()

end

function UIPopGotSingleView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIPopGotSingleView:Init()
	local rectTransform = self.itemIcon.rectTransform
	self.defaultLocalPos = rectTransform.localPosition
	self.defaultLocalScale = rectTransform.localScale

	self:RefreshView()
end

function UIPopGotSingleView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPopGotSingleView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIPopGotSingleView:OnHide()

end

function UIPopGotSingleView:OnShow(data)
	self.controller:SetData(data)

end

function UIPopGotSingleView:OnClose()
end

function UIPopGotSingleView:OnDispose()
	local rectTransform = self.itemIcon.rectTransform
	rectTransform.localPosition = self.defaultLocalPos
	rectTransform.localScale = self.defaultLocalScale
	local seq = self.doTweenSequence
	if seq then
		seq:Kill()
		seq = nil
	end
	self.controller:OnDispose()
end


function UIPopGotSingleView:RefreshView()
	local storySectionId = self.controller:GetStorySectionId()
	local storySectionData = ManagerContainer.CfgMgr:GetStorySectionById(storySectionId)
    if not storySectionData then return end
	local storySectionType = storySectionData.Type
	local iconPath
	if storySectionType == Enum.StorySectionEventType.UnlockHangBox then
		iconPath = storySectionData.ArtRes
		if storySectionData.Content then
			self.titleText.uILocalizeScript:SetContent(storySectionData.Content[1])
			self.nameText.uILocalizeScript:SetContent(storySectionData.Content[2])
		end
	elseif storySectionType == Enum.StorySectionEventType.UnlockTask then
		iconPath = storySectionData.ArtRes
		if storySectionData.Content then
			self.titleText.uILocalizeScript:SetContent(storySectionData.Content[1])
			self.nameText.uILocalizeScript:SetContent(storySectionData.Content[2])
		end
	elseif storySectionType == Enum.StorySectionEventType.GotItem then
		iconPath = storySectionData.ArtRes
		if storySectionData.Content then
			self.titleText.uILocalizeScript:SetContent(storySectionData.Content[2])
			if storySectionData.Content[3] then
				self.nameText.uILocalizeScript:SetContent(storySectionData.Content[3])
			else
				local itemCfgId = storySectionData.Content[1]
				local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
				if itemCfgData then
					local quality = CommonUtil.GetItemQuality(itemCfgId)
					self.nameText.uILocalizeScript:SetContentAndValuesWithColor(itemCfgData.Name, nil, Constant.ColorTextArray[quality])
				end
			end
        end
	else
		return
	end

	self.icon.image.sprite = nil
	self.icon.image.enabled = false
	CommonUtil.LoadIcon(self, iconPath, function (sprite)
		self.icon.image.sprite = sprite
		self.icon.image.enabled = true
	end, self, 'ItemIconAsyncIdx')

	local seq = self.doTweenSequence
	if seq then
		seq:Kill()
		seq = nil
	end
	seq = DOTween.Sequence()
	self.doTweenSequence = seq

	local rectTransform = self.itemIcon.rectTransform
	rectTransform.localPosition = self.defaultLocalPos
	rectTransform.localScale = self.defaultLocalScale

	local startPos = self.controller:GetStartPos()
	rectTransform.localScale = Vector3.one
	rectTransform.position = startPos

	self.uIAnimator.animator:Play('PopGotSingleIn')

	seq:Append(rectTransform:DOLocalMove(self.defaultLocalPos, 0.5))
	seq:Join(rectTransform:DOScale(self.defaultLocalScale, 0.5))
	seq:AppendCallback(function()
		self.uIAnimator.animator:Play('PopGotSingleTextIn')
	end)
	seq:AppendInterval(3)
	seq:AppendCallback(function()
		self.uIAnimator.animator:Play('PopGotSingleOut')
	end)
	if storySectionType == Enum.StorySectionEventType.UnlockHangBox then
		if UIBattleCtr then
			seq:Append(rectTransform:DOMove(UIBattleCtr:GeAnchoredPosition3DByType(Enum.ItemType.Item), 0.5))
			seq:Join(rectTransform:DOScale(Vector3.one * 0.3, 0.5))
		end
	elseif storySectionType == Enum.StorySectionEventType.UnlockTask then
		if UIMainCtr then
			seq:Append(rectTransform:DOMove(UIMainCtr:GetTaskBtnPosition(), 0.5))
			seq:Join(rectTransform:DOScale(Vector3.one * 0.3, 0.5))
		end
	elseif storySectionType == Enum.StorySectionEventType.GotItem then
		if UIMainCtr then
			seq:Append(rectTransform:DOMove(UIMainCtr:GetGotAnimEndPosByType(Enum.ItemType.Item), 0.5))
			seq:Join(rectTransform:DOScale(Vector3.one * 0.3, 0.5))
		end
	end
	seq:AppendCallback(function()
		rectTransform.localPosition = self.defaultLocalPos
		rectTransform.localScale = self.defaultLocalScale
		self:UIClose()
	end)
end


return UIPopGotSingleView

