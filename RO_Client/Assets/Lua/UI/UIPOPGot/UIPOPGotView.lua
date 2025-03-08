local UIPOPGotView = require("UIPOPGot/UIPOPGotView_Generate")


function UIPOPGotView:OnAwake(data)
	self.controller = require("UIPOPGot/UIPOPGotCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIPOPGotView:AddEventListener()

end

function UIPOPGotView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	if self.controller:GetTitle() ~= nil then
		self.titleNode.uILocalizeScript:SetContent(self.controller:GetTitle())
	else
		self.titleNode.uILocalizeScript:SetContent("Congratulation")
	end
	
	self:Init()
end

function UIPOPGotView:Init()
	local datas = self.controller:GetRewards()
	self.scrollView.loopVerticalScrollRect:ClearCells()
	self.scrollView.loopVerticalScrollRect:StopMovement()
	self.scrollView.loopVerticalScrollRect.content.anchoredPosition = Vector2.zero
	CommonUtil.LoopGridViewEleCreateNew(self, self.scrollView.loopVerticalScrollRect, nil, datas, 0, self, self.RefreshPopGotItem, nil, nil, 0)
end

function UIPOPGotView:RefreshPopGotItem(itemlua, idx, data)
	CommonUtil.UpdateItemPrefab(self, itemlua, data, Enum.ItemIEnterType.Bag, self, self.ShowItemTips)
end

function UIPOPGotView:ShowItemTips(button, params)
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, params[0])
	ManagerContainer.LuaUIMgr:OpenTips(params[0])
end

function UIPOPGotView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIPOPGotView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

	self.uiBase:AddButtonEventListener(self.AnyBtn.button, function()
		local page = ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIMain)
		if page then	--有UIMain界面就可以飞item到背包，没有UIMain就没有背包，你飞哪去？
			local datas = self.controller:GetRewards()
			local list = {}
			local startPoses = {}
			local content = self.scrollView.loopVerticalScrollRect.content
			local idx
			for i = 0, content.childCount - 1 do
				local transform = content:GetChild(i)
				if transform.gameObject.activeSelf then
					local dataIdx = tonumber(transform.gameObject.name)
					local data = datas[dataIdx + 1]
					if data then
						idx = i + 1
						list[idx] = data
						startPoses[idx] = transform.position
					end
				end
			end
			local data1 = {list = list, startPoses = startPoses, endterType = Enum.ItemIEnterType.PopGot}
			ManagerContainer.LuaUIMgr:POPGotAnimNotice(data1)
		end
		self:UIClose()
	end)
end

function UIPOPGotView:OnHide()

end

function UIPOPGotView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIPOPGotView:OnClose()
	ManagerContainer.PopGotMgr:PageViewKeep(false)
end

function UIPOPGotView:OnDispose()
	self.scrollView.loopVerticalScrollRect:ClearCells()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_CLOSE_POPGOT_PAGE)
end

return UIPOPGotView

