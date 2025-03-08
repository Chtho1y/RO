local UIExpeditionWinView = require("UIExpedition/UIExpeditionWinView_Generate")

function UIExpeditionWinView:OnAwake(data)
	self.controller = require("UIExpedition/UIExpeditionWinCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIExpeditionWinView:AddEventListener()
end

function UIExpeditionWinView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIExpeditionWinView:Init()
	self:ShowBuffList()
end

function UIExpeditionWinView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIExpeditionWinView:AddUIEventListener()
end

function UIExpeditionWinView:OnHide()

end

function UIExpeditionWinView:OnShow(data)
	self.controller:SetData(data)

end

function UIExpeditionWinView:OnClose()
end

function UIExpeditionWinView:OnClickClose()
	if self.controller:InBattling() then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,Enum.UIPageName.UIExpedition,true)
	end
	self:UIClose()
end

function UIExpeditionWinView:OnDispose()
	self.controller:OnDispose()
end

function UIExpeditionWinView:ShowBuffList()
	local buffs = self.controller:GetBuffs()
	if buffs == nil or #buffs == 0 then
		self.rewardNode:SetActive(false)
		self.winTipsNode:SetActive(true)
		self.scoreReward:SetActive(true)
		self:RefreshScore()		
		self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	else
		self.winTipsNode:SetActive(false)
		self.rewardNode:SetActive(true)
		self.scoreReward:SetActive(false)
		for i = 1, 3 do
			local buffNode = self:GetBuffNode(i)
			buffNode:SetActive(false)
		end

		for i = 1, #buffs do
			local buffNode = self:GetBuffNode(i)
			self:SetBuffData(buffNode,buffs[i])
		end
		local name,score = ManagerContainer.DataMgr.ExpeditionDataMgr:GetLastMonsterNameScore()
		if name and score then
			ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam("Expeditionmonster", name, tostring(score))
		end
	end
end

function UIExpeditionWinView:GetBuffNode(idx)
	if idx == 1 then
		return self.buff1
	elseif idx == 2 then
		return self.buff2
	elseif idx == 3 then
		return self.buff3
	end
end

function UIExpeditionWinView:RefreshScore()
	--是否新纪录
	local IsNewRecord = ManagerContainer.DataMgr.ExpeditionDataMgr:IsNewRecord()
	self.newRecord:SetActive(IsNewRecord)
	local CurMaxScore = ManagerContainer.DataMgr.ExpeditionDataMgr:GetCurScore()
	self.scoreNumber.text.text = tostring(CurMaxScore)
end

function UIExpeditionWinView:SetBuffData(buffNode,buffData)
	buffNode.buffCard.buffName.text.text = buffData.Name
	CommonUtil.LoadIcon(self, buffData.Icon, function (sprite)
		buffNode.buffCard.buffIcon.image.sprite = sprite
	end)
	buffNode.buffCard.buffDesc.text.text = buffData.Desc
	buffNode:SetActive(true)
	self.uiBase:AddButtonEventListener(buffNode.selectNode.button,self, self.OnClickUseBuff,buffData.Id)
end

function UIExpeditionWinView:OnClickUseBuff(btn,params)
	local buffId = params[0]
	ManagerContainer.DataMgr.ExpeditionDataMgr:SendSelectBuffReq(buffId)
	if self.controller:InBattling() then
		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHUT_TIMEBATTLE,Enum.UIPageName.UIExpedition,true)
	end
	self:UIClose()
end

return UIExpeditionWinView

