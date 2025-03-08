local UIFashionGotView = require("UIFashion/UIFashionGotView_Generate")

function UIFashionGotView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionGotCtr")
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionGotView:AddEventListener()

end

function UIFashionGotView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionGotView:Init()
	local cfgId = self.controller:GetCfgId()

	self.icon.image.sprite = nil
	self.frame.image.sprite = nil
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgId)
	CommonUtil.LoadIcon(self, fashionCfgData.FashionIcon, function (sprite)
        self.icon.image.sprite = sprite
	end, self, 'IconAsyncIdx')
	CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[fashionCfgData.FashionQuality], function (sprite)
        self.frame.image.sprite = sprite
    end, self, 'FrameAsyncIdx')

	self.nameTxt.text.text = I18N.SetLanguageValue(fashionCfgData.FashionName)

	local fashionLogicData = self.controller:GetFashionLogicData(fashionCfgData.FashionId)
	if fashionLogicData then
		local attrs = fashionLogicData.attrs
		for i = 1, 5 do
			local propertyItem = self['property' .. i]
			if propertyItem then
				local fashionAttr = attrs[i]
				if fashionAttr then
					local jobType = fashionAttr.jobType
					local attrId = fashionAttr.attrId
					local attrValue = fashionAttr.value
					local jobName = self.controller:GetJobTypeName(jobType)
					propertyItem.attrName.text.text = jobName..I18N.SetLanguageValue(CommonUtil.HeroAttrFormatName(attrId, attrValue))
					propertyItem.number.text.text = "+"..attrValue
					propertyItem:SetActive(true)
				else
					propertyItem:SetActive(false)
				end
			end
		end
	else
		for i = 1, 5 do
			local propertyItem = self['property' .. i]
			if propertyItem then
				propertyItem:SetActive(i <= fashionCfgData.AttrNum)
				if i <= fashionCfgData.AttrNum then
					propertyItem.attrName.text.text = I18N.T("RandomAttr1")
					propertyItem.number.text.text = I18N.T("RandomAttr2")
				end
			end
		end
	end
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	if not fashionCfgData.FashionUseJob or IsTableHasValue(fashionCfgData.FashionUseJob, jobCfgId) then
		CommonUtil.SetTotalChildrenGray(self.equipBtn, false)
	else
		CommonUtil.SetTotalChildrenGray(self.equipBtn, true)
	end
end

function UIFashionGotView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionGotView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonUniqueEventListener(self.alpha.button, self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.equipBtn.button, self, self.OnClickEquipBtn)
end

function UIFashionGotView:OnHide()

end

function UIFashionGotView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIFashionGotView:OnClose()
	ManagerContainer.PopGotMgr:PageViewKeep(false)
end

function UIFashionGotView:OnDispose()

end

function UIFashionGotView:OnClickCloseBtn()
	self:UIClose()
end

function UIFashionGotView:OnClickEquipBtn()
	local cfgId = self.controller:GetCfgId()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgId)
	local jobCfgId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
	if not fashionCfgData.FashionUseJob or IsTableHasValue(fashionCfgData.FashionUseJob, jobCfgId) then
		self.controller:SendEquip()
		self:UIClose()
	else
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay('WeaponfashionTip_3')
	end
end

return UIFashionGotView

