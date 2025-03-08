local UIClimbingTowerBattleFailedView = require("UIClimbingTower/UIClimbingTowerBattleFailedView_Generate")

function UIClimbingTowerBattleFailedView:OnAwake(data)
	self.controller = require("UIClimbingTower/UIClimbingTowerBattleFailedCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIClimbingTowerBattleFailedView:AddEventListener()

end

function UIClimbingTowerBattleFailedView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIClimbingTowerBattleFailedView:Init()
	for i = 1, 3 do
		local go = self:GetTipsGo(i)
		if go ~= nil then
			go:SetActive(false)
		end
	end

	local fromPageId = self.controller:GetData()
	local tips = nil
	if fromPageId == Enum.UIPageName.UISkillExpBattle then
		tips = ManagerContainer.BattleFailedTipsMgr:CheckShowTips(3,2)
		self.reopenBtn:SetActive(true)
	elseif fromPageId == Enum.UIPageName.UIClimbingTower then
		local type = ManagerContainer.DataMgr.PeakTowerDataMgr:GetCurUITowerType()
		if type == Enum.UnlimitTowerType.PeakTower then
			tips = ManagerContainer.BattleFailedTipsMgr:CheckShowTips(3,2)
			self.reopenBtn:SetActive(false)
		else
			tips = ManagerContainer.BattleFailedTipsMgr:CheckShowTips(3,2)
			self.reopenBtn:SetActive(true)
		end
	elseif fromPageId == Enum.UIPageName.UIBattle then
		tips = ManagerContainer.BattleFailedTipsMgr:CheckShowTips(3,1)
		self.reopenBtn:SetActive(false)
	end
	
	if tips ~= nil then
		for i = 1, #tips do
			local tip = tips[i]
			local node = self:GetTipsGo(i)
			self:SetTipData(node,tip)
		end
	end
end

function UIClimbingTowerBattleFailedView:SetTipData(node,tip)
	if node == nil then
		return
	end

	if tip.TipsIcon ~= nil and tip.TipsIcon ~= "" then
		CommonUtil.LoadIcon(self, tip.TipsIcon, function (sprite)
			node.tipsIcon.image.sprite = sprite
		end)
	end	
	
	node.tipsContent.text.text = tip.Content
	if tip.GotoPageIds ~= nil and #tip.GotoPageIds > 0 then
		node.btnGo:SetActive(true)
		self.uiBase:AddButtonUniqueEventListener(node.btnGo.button, self, self.OnClickJump, tip.GotoPageIds,tip.params,tip.LoadPageCondition)
	else
		node.btnGo:SetActive(false)
	end
	node:SetActive(true)
end

function UIClimbingTowerBattleFailedView:OnClickJump(btn,params)
	local fromPageId = self.controller:GetData()
	if  fromPageId == Enum.UIPageName.UISkillExpBattle then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,nil)
	elseif fromPageId == Enum.UIPageName.UIClimbingTower then
		local type = ManagerContainer.DataMgr.PeakTowerDataMgr:GetCurUITowerType()
		if type == Enum.UnlimitTowerType.PeakTower then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_PVPCIMBINGBATTLE,nil)
		else
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,nil)
		end
	end

	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)

	local allPageIds = params[0]
	local extendParams = params[1]
	local loadPageConds = params[2]
	local pageIds = nil
	if extendParams == nil or extendParams == 1 then
		pageIds = allPageIds[1]
	else
		pageIds = allPageIds[2]
	end

	if pageIds ~= nil then
		if type(pageIds) == "table" then
			for i=1, #pageIds do
				local parentId  = 0
				if i > 1 then
					parentId = pageIds[i-1]
				end
				if self:CheckPageCanOpen(pageIds[i],loadPageConds) then
					self:OpenGoPage(parentId,pageIds[i],extendParams)
				end
			end
		else
			if self:CheckPageCanOpen(pageIds,loadPageConds) then
				self:OpenGoPage(nil,pageIds,extendParams)
			end
		end
	end
end

function UIClimbingTowerBattleFailedView:CheckPageCanOpen(pageId,loadPageConds)
	if loadPageConds == nil then
		return true
	end

	for i=1, #loadPageConds do
		local conds  = loadPageConds[i]
		if conds[1] == pageId then
			return conds[2] > 0
		end
	end
	return true
end

function UIClimbingTowerBattleFailedView:OpenGoPage(parentPageId,pageID,params)
	local uiData = ManagerContainer.CfgMgr:GetUIData(pageID)
	
	if uiData.type == 0 then
		if not ManagerContainer.LuaUIMgr:HasOpenPage(pageID) then
			if not ManagerContainer.LuaUIMgr:HasOpenPage(Enum.UIPageName.UIMain) then
				ManagerContainer.LuaUIMgr:Back2NormalBattleMain(uiData.mainViewType)
			else
				ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UIMAINVIEW_CHANGE_NOTICE, uiData.mainViewType, params)
			end
			ManagerContainer.LuaUIMgr:Open(pageID,params)
		end
	else
		if pageID == Enum.UIPageName.UISkillSettings then
			params = {params}
		end
		ManagerContainer.LuaUIMgr:Open(pageID,params,parentPageId)
	end
end

function UIClimbingTowerBattleFailedView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)
end

function UIClimbingTowerBattleFailedView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.reopenBtn.button,self, self.OnClickReopen)
end

function UIClimbingTowerBattleFailedView:OnHide()

end

function UIClimbingTowerBattleFailedView:OnShow(data)
	self.controller:SetData(data)

end

function UIClimbingTowerBattleFailedView:OnClose()
end

function UIClimbingTowerBattleFailedView:OnDispose()
	self.controller:OnDispose()
end

function UIClimbingTowerBattleFailedView:OnClickClose()
	local fromPageId = self.controller:GetData()
	if fromPageId == Enum.UIPageName.UISkillExpBattle then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,fromPageId)
	elseif fromPageId == Enum.UIPageName.UIClimbingTower then
		local type = ManagerContainer.DataMgr.PeakTowerDataMgr:GetCurUITowerType()
		if type == Enum.UnlimitTowerType.PeakTower then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_PVPCIMBINGBATTLE,fromPageId)
		else
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,fromPageId)
		end
	elseif fromPageId == Enum.UIPageName.UIBattle then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER, true)
	end
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UIClimbingTowerBattleFailedView:OnClickReopen()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,nil)
	self.controller:ReEnterBattle()
end

function UIClimbingTowerBattleFailedView:GetTipsGo(idx)
	if idx == 1 then
		return self.tips1
	elseif idx == 2 then
		return self.tips2
	elseif idx == 3 then
		return self.tips3
	end

	return nil
end

return UIClimbingTowerBattleFailedView

