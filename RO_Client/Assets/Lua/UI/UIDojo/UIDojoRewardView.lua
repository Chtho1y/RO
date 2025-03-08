local UIDojoRewardView = require("UIDojo/UIDojoRewardView_Generate")

function UIDojoRewardView:OnAwake(data)
	self.controller = require("UIDojo/UIDojoRewardCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIDojoRewardView:AddEventListener()

end

function UIDojoRewardView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()

	self:SetToggleBtnStatus()
end

function UIDojoRewardView:Init()
	self.danRewardToggle.toggle.interactable = true;
	self.rankRewardToggle.toggle.interactable = true;
end

function UIDojoRewardView:SetToggleBtnStatus()
	self.toggles = {}
	self.toggles[1] = self.danRewardToggle;
	self.toggles[2] = self.rankRewardToggle;
	self.curToggleIdx = 1
	self.toggles[self.curToggleIdx].toggle.isOn = true
	self.toggles[self.curToggleIdx].toggle.interactable = false

	self:ShowDanReward()
end

function UIDojoRewardView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIDojoRewardView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.alpha.button,self, self.OnClickCloseBtn)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickCloseBtn)
	self.uiBase:AddToggleEventListener(self.danRewardToggle.toggle,self,self.OnClickTab,1)
	self.uiBase:AddToggleEventListener(self.rankRewardToggle.toggle,self,self.OnClickTab,2)
end

function UIDojoRewardView:OnHide()
end

function UIDojoRewardView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIDojoRewardView:OnClose()

end

function UIDojoRewardView:OnDispose()
	self.toggles = nil

	self.rewardItemScroll.loopVerticalScrollRect:ClearCells()
	self.curDanItemScroll.loopHorizontalScrollRect:ClearCells()
	self.nextDanItemScroll.loopHorizontalScrollRect:ClearCells()
end

function UIDojoRewardView:OnClickCloseBtn()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UIDojoRewardView:OnClickTab(selectedTog,toggleIdx, result)
	 if self.curToggleIdx == toggleIdx then
		return
	 end

	 self.curToggleIdx = toggleIdx

	 for i =1, #self.toggles do
		if i ~= (toggleIdx) then
			self.toggles[i].toggle.isOn = false
			self.toggles[i].toggle.interactable = true
		end
	end

	 selectedTog.interactable = false
	 
	 if self.curToggleIdx == 2 then
		self:ShowRankReward()
	 elseif self.curToggleIdx == 1 then
		self:ShowDanReward()
	 end
end

function UIDojoRewardView:ShowDanReward()
	self.danRewardNode:SetActive(true)
	self.rewardItemScroll:SetActive(false)

	local arenaData = ManagerContainer.DataMgr.ArenaData

	-- 设置当前赛季数据
	self.curNode:SetActive(true);
	self.curDanName.text.text = arenaData.danName
	CommonUtil.LoadIcon(self, arenaData.danIcon, function (sprite)
			self.curDanIcon.image.sprite = sprite
		end)

	CommonUtil.LoopGridViewEleCreateNew(self,
		self.curDanItemScroll.loopHorizontalScrollRect,
		self.curDanItemContent.gridLayoutGroup,arenaData.danReward,0,self,self.OnUpdateItemData)


	-- 设置下一赛季的数据
	if arenaData.nextDanScore == nil or arenaData.nextDanScore == 0 then
		self.nextNode:SetActive(false)
	else
		self.nextNode:SetActive(true)
		self.nextDanName.text.text = arenaData.nextDanName
		CommonUtil.LoadIcon(self, arenaData.nextDanIcon, function (sprite)
				self.nextDanIcon.image.sprite = sprite
			end)

		CommonUtil.LoopGridViewEleCreateNew(self,
			self.nextDanItemScroll.loopHorizontalScrollRect,
			self.nextDanItemContent.gridLayoutGroup,arenaData.nextDanReward,0,self,self.OnUpdateItemData)
	end
end

function UIDojoRewardView:ShowRankReward()
	self.danRewardNode:SetActive(false)
	self.rewardItemScroll:SetActive(true)

	if self.controller.rankRewardList~= nil then
		CommonUtil.LoopGridViewEleCreateNew(self,
									self.rewardItemScroll.loopVerticalScrollRect,
									nil,self.controller.rankRewardList,0,self,self.OnUpdateRankRewardData)
	end
end

function UIDojoRewardView:OnUpdateRankRewardData(rankItemLua,idx)
	if rankItemLua == nil then
		return
	end

	local rewardItem = self.controller.rankRewardList[idx+1]
	if rewardItem == nil then
		return
	end

	rankItemLua.rank1:SetActive(false)
	rankItemLua.rank2:SetActive(false)
	rankItemLua.rank3:SetActive(false)
	
	if rewardItem.minLevel == rewardItem.maxLevel then
		rankItemLua.rankVal.text.text = tostring(rewardItem.minLevel)
		if rewardItem.minLevel == 1 then
			rankItemLua.rank1:SetActive(true)
		elseif rewardItem.minLevel == 2 then
			rankItemLua.rank2:SetActive(true)
		elseif rewardItem.minLevel == 3 then
			rankItemLua.rank3:SetActive(true)
		end
	else
		rankItemLua.rankVal.text.text = rewardItem.minLevel .. "-" .. rewardItem.maxLevel
	end

	rankItemLua.bg:SetActive(rewardItem.minLevel<=3)
	rankItemLua.danName.text.text = "至尊王者"
	CommonUtil.LoopGridViewEleCreateNew(self,
										rankItemLua.itemScroll.loopHorizontalScrollRect,
										rankItemLua.itemContent.gridLayoutGroup,rewardItem.itemList,0,self,self.OnUpdateItemData)
end

function UIDojoRewardView:OnUpdateItemData(itemLua,idx,item)
	if itemLua~=nil and item~= nil then
		CommonUtil.SetRewardItemData(self,item[1],itemLua,item[2], self.OnClickItem)
	end
end

function UIDojoRewardView:OnClickItem(btn,params)
	local logicData = params[0]
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, item)
	ManagerContainer.LuaUIMgr:OpenTips(logicData)
end

function UIDojoRewardView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleReward)
end

return UIDojoRewardView

