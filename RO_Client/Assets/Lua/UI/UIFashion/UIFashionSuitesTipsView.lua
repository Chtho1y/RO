local UIFashionSuitesTipsView = require("UIFashion/UIFashionSuitesTipsView_Generate")
local userSex
function UIFashionSuitesTipsView:OnAwake(data)
	self.controller = require("UIFashion/UIFashionSuitesTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIFashionSuitesTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIFashionSuitesTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIFashionSuitesTipsView:Init()
	self.fashionSuitList = {}
	userSex = ManagerContainer.DataMgr.UserData:GetSex()
	self:InitGrid()
end

function UIFashionSuitesTipsView:OnPageInEnd()
	self.super.OnPageInEnd(self)
	self:Refresh()
end

function UIFashionSuitesTipsView:Refresh(resetPos)
	local loopListView = self.suitesScrollView.loopListView
	local length = self.controller:GetShowDataLength()
	if resetPos then
		loopListView:SetListItemCount(length + 1, true)
	else
		loopListView:SetListItemCount(length + 1)
	end
end

function UIFashionSuitesTipsView:InitGrid()
	self.suitesScrollView.loopListView:InitListView(0, function(gridView, itemIndex, row, column)
		return self:GetItemByRowColumn(gridView, itemIndex, row, column)
	end, nil)

	self.controller:RefreshSuites()
end

function UIFashionSuitesTipsView:GetItemByRowColumn(gridView, itemIndex, row, column)
	local item
	if itemIndex == 0 then
		item = gridView:NewListViewItem('Empty')
	else
		local suitId = self.controller:GetShowData(itemIndex)
		local suitCfgData = ManagerContainer.CfgMgr:GetFashionSuitDataById(suitId)
		local suitLv = self.controller:GetSuitLvById(suitId)
		local lv = suitLv > 0 and suitLv or 1
		local height = 360
		if suitCfgData then
			item = gridView:NewListViewItem('FashionSuitesItem')
			local itemlua = CommonUtil.BindGridViewItem2Lua(self, 'FashionSuitesItem', item.gameObject)
			CommonUtil.CloseUIClearAsyncSeqIds(itemlua)

			local fashionIds = suitCfgData.FashionId
			if fashionIds then
				local length = #fashionIds
				local listView = itemlua.goodsList.loopListView
				if listView.ListViewInited then
					listView:Dispose()
				end
				listView:InitListView(0, function(gridView1, itemIndex1, row1, column1)
					local GetItemByRowColumn1 = function (gridView1, itemIndex1, row1, column1)
						local item1
						if itemIndex1 == 0 then
							item1 = gridView1:NewListViewItem('Empty')
						else
							local cfgId = fashionIds[itemIndex1]
							local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(cfgId)
							if not fashionCfgData then
								return item1
							end

							if userSex ~= fashionCfgData.FashionSex and fashionCfgData.FashionSex > 0 then
								return item1
							end

							item1 = gridView1:NewListViewItem('FashionWearItem')
							local itemlua1 = CommonUtil.GetBindGridViewItem2Lua(self, 'FashionWearItem', item1.gameObject)
							if not itemlua1 then
								itemlua1 = CommonUtil.BindGridViewItem2Lua(self, 'FashionWearItem', item1.gameObject)
							else
								CommonUtil.CloseUIClearAsyncSeqIds(itemlua1)
							end
							self:RefreshFashionItem(cfgId, itemlua1)
						end
						return item1
					end
					return GetItemByRowColumn1(gridView1, itemIndex1, row1, column1)
				end, nil)

				if not CommonUtil.EleInTable(listView, self.fashionSuitList) then
					self.fashionSuitList[#self.fashionSuitList + 1] = listView
				end
				listView:SetListItemCount(length + 1, true)
				listView:RefreshAllShownItem()

				itemlua.suitesLv.activity:SetActive(suitLv > 0)
				itemlua.nextCondition:SetActive(suitLv < #suitCfgData.LevelCondition)
				itemlua.nextAttr:SetActive(suitLv < #suitCfgData.LevelCondition)

				if suitLv <= #suitCfgData.LevelCondition then
					if suitLv < #suitCfgData.LevelCondition then
						local condition = suitCfgData.LevelCondition[suitLv + 1]
						local count = 0
						for _,v in pairs(fashionIds) do
							local fashionLogicData = ManagerContainer.DataMgr.FashionData:GetFashionById(v)
							if fashionLogicData then
								if fashionLogicData.lv >= condition then
									count = count + 1
								end
							end
						end
						itemlua.nextCondition.condition.text.text = I18N.SetLanguageValue("SuitNeedLevel", condition)
						itemlua.nextCondition.num.text.text = count.."/"..#fashionIds
					end

					--当前属性
					local curAttrs = suitCfgData.Attribute[lv]
					itemlua.currentAttr:SetActive(suitLv > 0 and curAttrs ~= nil)
					if suitLv == 0 or curAttrs == nil then
						height = height - 30
					end
					if curAttrs then
						local attrCount = 0
						for i = 1, 4 do
							local attrItem = itemlua.currentAttr["attr"..i]
							local attr = curAttrs[i]
							if attrItem then
								attrItem:SetActive(attr ~= nil)
								if attr then
									attrCount = attrCount + 1
									local str = string.split(attr, '-')
									local key = tonumber(str[1])
									local val = tonumber(str[2])
									attrItem.text.text.text = I18N.T("Attr_" .. key)

									val = key > 21 and CommonUtil.GetPreciseDecimal(val*0.0001, 3) or math.floor(val)
									attrItem.num.text.text = CommonUtil.HeroAttrFormatValue(key, val, true)
								end
							end
						end
						if attrCount > 2 then
							height = height + 30
						end
					end

					--下一级属性
					local nextAttrs = suitCfgData.Attribute[lv + 1]
					itemlua.nextAttr:SetActive(nextAttrs ~= nil)
					if nextAttrs == nil then
						height = height - 30
					end
					if suitLv == 0 then
						nextAttrs = suitCfgData.Attribute[lv]
					end
					if nextAttrs then
						local attrCount = 0
						for i = 1, 4 do
							local attrItem = itemlua.nextAttr["attr"..i]
							local attr = nextAttrs[i]
							if attrItem then
								attrItem:SetActive(attr ~= nil)
								if attr then
									attrCount = attrCount + 1
									local str = string.split(attr, '-')
									local key = tonumber(str[1])
									local val = tonumber(str[2])
									attrItem.text.text.text = I18N.T("Attr_" .. key)

									val = key > 21 and CommonUtil.GetPreciseDecimal(val*0.0001, 3) or math.floor(val)
									attrItem.num.text.text = CommonUtil.HeroAttrFormatValue(key, val, true)
								end
							end
						end
						if attrCount > 2 then
							height = height + 30
						end
					end
				end
				itemlua.rectTransform:SetSizeWithCurrentAnchors(UnityEngine.RectTransform.Axis.Vertical, height);
			end

			itemlua.suitesLv.suitesName.text.text = I18N.T(suitCfgData.SuitName)
			itemlua.suitesLv.numlv.text.text = lv
		end
	end
	return item
end

function UIFashionSuitesTipsView:RefreshFashionItem(fashionId, itemlua)
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	if not fashionCfgData then
		return
	end

	itemlua.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
	itemlua.icon.image.sprite = nil
	itemlua.icon.image.enabled = false
	itemlua.icon:SetActive(false)
	itemlua.frame.image.sprite = nil
	itemlua.frame.image.enabled = false
	CommonUtil.LoadIcon(self, fashionCfgData.FashionIcon, function (sprite)
		itemlua.icon.image.sprite = sprite
		itemlua.icon.image.enabled = true
		itemlua.icon:SetActive(true)
	end, itemlua, "FashionWearItemIconAsyncIdx")
	CommonUtil.LoadIcon(self, Constant.Quality_Frame_Icons[fashionCfgData.FashionQuality], function (sprite)
		itemlua.frame.image.sprite = sprite
		itemlua.frame.image.enabled = true
	end, itemlua, "FashionWearItemFrameAsyncIdx")
	itemlua.bg:SetActive(true)
	itemlua.frame:SetActive(true)
	itemlua.selected:SetActive(false)
	itemlua.selected2:SetActive(false)
	itemlua.disable:SetActive(false)
	itemlua.redPoint:SetActive(false)
	itemlua.bg.button.onClick:RemoveAllListeners()
	itemlua.fashionName.text.text = I18N.T(fashionCfgData.FashionName)
	local fashionLogicData = self.controller:GetFashionLogicData(fashionCfgData.FashionId)
	itemlua.num.text.text = "Lv "..(fashionLogicData and fashionLogicData.lv or 1)

	CommonUtil.SetTotalChildrenGray(itemlua.gameObject, fashionLogicData == nil)
end

function UIFashionSuitesTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIFashionSuitesTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button, self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.AnyBtn.button, self, self.OnClickClose)
end

function UIFashionSuitesTipsView:OnClickClose()
	self:UIClose()
end

function UIFashionSuitesTipsView:OnHide()

end

function UIFashionSuitesTipsView:OnShow(data)
	self.controller:SetData(data)

end

function UIFashionSuitesTipsView:OnClose()
	for _,v in pairs(self.fashionSuitList) do
		v:Dispose()
	end
	self.fashionSuitList = nil
	self.suitesScrollView.loopListView:Dispose()
end

function UIFashionSuitesTipsView:OnDispose()
	self.controller:OnDispose()
end

return UIFashionSuitesTipsView

