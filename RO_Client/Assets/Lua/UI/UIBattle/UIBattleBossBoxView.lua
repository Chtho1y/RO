local UIBattleBossBoxView = require("UIBattle/UIBattleBossBoxView_Generate")

local DOTween = DG.Tweening.DOTween

local BoxState = {
	NotOpen = 1,
	Opening = 2,
	Opened = 3,
}

function UIBattleBossBoxView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleBossBoxCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleBossBoxView:AddEventListener()

end

function UIBattleBossBoxView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleBossBoxView:Init()
	self.boxState = BoxState.NotOpen
	self.boxAnim.animator:Play('BossBoxIn')
	local rewardItemList = nil
	if not rewardItemList then
		rewardItemList = ManagerContainer.LuaBattleMgr.rewardItemList
	end
	if rewardItemList == nil then
		LogError('[Wboy] not find rewards, config is error !!!')
	end
	local idx = 1
	local max = Mathf.Min(#rewardItemList, 10)
	for i = 1, max do
		local keyValue = rewardItemList[i]
		local pot = self['pot' .. idx]
		if pot then
			pot:SetActive(true)
			pot.fly:SetActive(false)
			CommonUtil.SetRewardItemData(self, keyValue.key, pot.fly.iconItem, keyValue.value, self.OnClickItem)
		end
		idx = idx + 1
	end
	self.vaildIdx = idx - 1
	local pot = self['pot' .. idx]
	while pot do
		pot:SetActive(false)
		idx = idx + 1
		pot = self['pot' .. idx]
	end
end

function UIBattleBossBoxView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleBossBoxView:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	self.uiBase:AddButtonUniqueEventListener(self.AnyBtn.button, self, self.OnClickBtnAlpha)
end

function UIBattleBossBoxView:OnHide()

end

function UIBattleBossBoxView:OnShow(data)
	self.controller:SetData(data)

end

function UIBattleBossBoxView:OnClose()
	-- 提前移除特效，缩放的时候，特效并未缩放
	if self.fxGoes ~= nil then
        for i =1, #self.fxGoes do
            ManagerContainer.ResMgr:RecycleGO(Constants.EffectPath,self.fxGoes[i].name,self.fxGoes[i].go)
        end
    end
    self.fxGoes = nil
end

function UIBattleBossBoxView:OnDispose()
	local seq = self.doTweenSequence
	if seq then
		seq:Kill()
		seq = nil
	end
	self.controller:OnDispose()
end

function UIBattleBossBoxView:OnPageOutEnd()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BIGMAP_ENTER_NEXTMAP_START)
	self.super.OnPageOutEnd(self)
end

function UIBattleBossBoxView:OnClickItem(btn,params)
	local logicData = params[0]
	local item = {cfgId = logicData.cfgId};
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, item)
	ManagerContainer.LuaUIMgr:OpenTips(item)
end

function UIBattleBossBoxView:OnClickBtnAlpha()
	if self.boxState == BoxState.Opened then
		self:UIClose(self)
	elseif self.boxState == BoxState.NotOpen then
		self.boxState = BoxState.Opening
		self:OpenBox()
	end
end

function UIBattleBossBoxView:OpenBox()
	self.boxAnim.animator:Play('BossBoxOpen')

	local seq = self.doTweenSequence
	if seq then
	seq:Kill()
		seq = nil
	end
	seq = DOTween.Sequence()
	self.doTweenSequence = seq
	local startPos = self.boxAnim.transform.position
	local flyAnim = 0.1
	local delay = 1
	local idx = 1
	local pot = self['pot' .. idx]
	while pot do
		if idx > self.vaildIdx then
			break
		end
		seq:AppendInterval(delay)
		local fly = pot.fly
		seq:AppendCallback(function()
			fly:SetActive(true)
			fly.transform.position = startPos
			fly.animation:Play('ItemIcon')
		end)
		seq:Append(fly.transform:DOLocalMove(Vector3.zero, flyAnim))
		delay = flyAnim
		idx = idx + 1
		pot = self['pot' .. idx]
	end
	seq:AppendCallback(function()
		self.boxState = BoxState.Opened
	end)
	seq:AppendInterval(3)
	seq:AppendCallback(function()
		self:UIClose()
	end)
end

return UIBattleBossBoxView

