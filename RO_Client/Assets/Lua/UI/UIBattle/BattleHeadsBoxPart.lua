local BattleHeadsBoxPart = class("BattleHeadsBoxPart")

function BattleHeadsBoxPart:ctor()
end

function BattleHeadsBoxPart:InitGo(host,uiGo)
    self.host = host
	self.viewLua = CommonUtil.BindGridViewItem2Lua(self.host, "BattleHeadsBox", uiGo)
	
    self:InitPanel()
end

function BattleHeadsBoxPart:InitPanel()
	self.buffGoes = {}
	for i =1, 8 do
		local buffGo =  UnityEngine.GameObject.Instantiate(self.viewLua.buffTemp)
		buffGo.transform:SetParent(self.viewLua.buffTemp.transform.parent)
		buffGo.transform.localScale = Vector3.one
		buffGo.transform.localPosition = Vector3.zero
		self.buffGoes[#self.buffGoes+1] = buffGo
	end
end

function BattleHeadsBoxPart:AddEventListener()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Fighter_Life,self,self.RefreshFighterLife);
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Fighter_Sp,self,self.RefreshFighterSp);
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Refresh_Player_Buff,self,self.OnRefreshPlayerBuff);
	ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_Remove_Player_Buff,self,self.OnRemovePlayerBuff);
end

function BattleHeadsBoxPart:RemoveEventListener()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Fighter_Life,self,self.RefreshFighterLife);
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Fighter_Sp,self,self.RefreshFighterSp);
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Refresh_Player_Buff,self,self.OnRefreshPlayerBuff);
	ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_Remove_Player_Buff,self,self.OnRemovePlayerBuff);
end

function BattleHeadsBoxPart:AddUIEventListener()
end

function BattleHeadsBoxPart:GetSlotSortActor(tbActor)
	--伙伴界面排序
	local sortedPartnerDatas =  ManagerContainer.DataMgr.PartnerData:SortPartnerData()
	--根据伙伴界面排序 排序
	local sortedData = {}	
	for j =1, tbActor.Count do--主角第一
		local actor = tbActor[j-1]	
		local UserId = 1		
		if tostring(UserId)==tostring(actor.ID) then	
			table.insert(sortedData,actor)
		end		
	end
	for i=1, #sortedPartnerDatas do	--伙伴排序
		local PartnerData = sortedPartnerDatas[i]		
		for j =1, tbActor.Count do
			local actor = tbActor[j-1]					 
			if tostring(PartnerData.id)==tostring(actor.ID) then
				table.insert(sortedData,actor)			
			end
		 end
	end
	return sortedData
end

function BattleHeadsBoxPart:Show()
	self:HidePlayerNodes()
	self:AddEventListener()
	self.ourMembers = self:GetSlotSortActor(LuaBattleBridge.GetBattleTeamPlayerActors())
	self.actorBuffs = {}
	self.actorHeadMapping = {}	
	for i =1, #self.ourMembers do
		local actor = self.ourMembers[i]
		local go = self:GetHeadGo(i)
		self.actorHeadMapping[tostring(actor.ID)] = go
		self.actorBuffs[tostring(actor.ID)] = {}
		go.headPosItem:SetActive(false)
		self:SetPlayerData(actor.ID,go.headBoxItemNew,actor)
		if i == 1 then
			self:ShowCurrentSelectPlayerData(actor.ID)
		end
	end
    self.viewLua:SetActive(true)
end

function BattleHeadsBoxPart:ShowCurrentSelectPlayerData(uid)
	if self.curSelectedUid ~= uid then
		local preHeadGo = self:GetActorHeadGo(self.curSelectedUid)
		if preHeadGo ~= nil then
			LuaBattleBridge.BeginTweenRecTransformPos(preHeadGo,0.1,Vector3(0,0,0))
		end
		
		self.curSelectedUid = uid
		local headGo = self:GetActorHeadGo(uid)
		local actorData = self:GetActorsById(uid)		
		if actorData ~= nil then
			CommonUtil.LoadIcon(self.host, actorData.ProfessionIcon, function (sprite)
				self.viewLua.playerDetailNode.jobIcon.image.sprite = sprite
			end)

			self.viewLua.playerDetailNode.hpBar.image.fillAmount = headGo.hp.image.fillAmount
			self.viewLua.playerDetailNode.spBar.image.fillAmount = headGo.sp.image.fillAmount
			self.viewLua.playerDetailNode.playerName.text.text = actorData.Name

			CommonUtil.LoadIcon(self.host, actorData.BattleBigIcon, function (sprite)
				self.viewLua.playerDetailNode.heroHalf.image.sprite = sprite
			end)

			local dead = self.viewLua.playerDetailNode.hpBar.image.fillAmount == 0
			CommonUtil.NeedUIGray(self.viewLua.playerDetailNode.heroHalf.image, dead)
			self.viewLua.playerDetailNode.deadNode:SetActive(dead)

			if actorData.HasPet then
				self.viewLua.playerDetailNode.petNode:SetActive(true)
				CommonUtil.LoadIcon(self.host, actorData.PetIcon, function (sprite)
					self.viewLua.playerDetailNode.petNode.petIcon.image.sprite = sprite
				end)
				CommonUtil.NeedUIGray(self.viewLua.playerDetailNode.petNode.petIcon.image, dead)	
			else
				self.viewLua.playerDetailNode.petNode:SetActive(false)
			end
		end
		LuaBattleBridge.BeginTweenRecTransformPos(headGo,0.1,Vector3(0,15,0))
		self:ShowSelectedPlayerBuffInfo(uid)
	end
end

function BattleHeadsBoxPart:GetActorsById(uid)
	if self.ourMembers == nil then
		return nil
	end

	for i=1, #self.ourMembers do
		if self.ourMembers[i].ID == uid then
			return self.ourMembers[i]
		end
	end
	return nil
end

function BattleHeadsBoxPart:ShowSelectedPlayerBuffInfo(actorId)
	local buffs = self:GetActorBuffInfo(actorId)

	for i=1, 8 do 
		self.buffGoes[i]:SetActive(false)
	end

	for i =1 , #buffs do
		if i > 8 then
			return
		end
		self:LoadBuffIcon(self.buffGoes[i],buffs[i].icon,buffs[i].num,buffs[i].desc)
	end
end

function BattleHeadsBoxPart:LoadBuffIcon(buffGo,buffIcon,num,buffDesc)
    if buffGo == nil or buffIcon == nil then
		return
	end

	local img = buffGo.transform:Find("Image"):GetComponent(Enum.TypeInfo.Image)
	if img == nil then
		return
    end
    
    local numTxt = buffGo.transform:Find("num"):GetComponent(Enum.TypeInfo.TextMeshProUGUI)
	if numTxt ~= nil then
		if num > 0 then
			numTxt.text = tostring(num)
		else
			numTxt.text = ""
		end  
	end
	
	local btn = buffGo.transform:GetComponent(Enum.TypeInfo.Button)

	if btn ~= nil then
		self.host.uiBase:AddButtonUniqueEventListener(btn, self, self.OnClickBuff,buffDesc)
	end

	CommonUtil.LoadIcon(self.host, buffIcon, function (sprite)
		if img ~= nil and sprite ~= nil then
			img.sprite = sprite
		end
	end)
	buffGo:SetActive(true)
end

function BattleHeadsBoxPart:OnClickBuff(btn,params)
	ManagerContainer.LuaUIMgr:ShowMinTips(params[0])
end

function BattleHeadsBoxPart:SetPlayerData(uid,playerNode,actorData)
    CommonUtil.SetPlayerHeadAndFrame(self.host,playerNode.headItem,actorData,true, actorData.HeadFrameId)
	self:RefreshFighterLife(uid,actorData.Life,actorData.Life)
	self:RefreshFighterSp(uid,actorData.Sp,actorData.Sp)
	playerNode.deadNode:SetActive(false)
	playerNode:SetActive(true)
	playerNode.headItem.head.button.interactable = true
	self.host.uiBase:AddButtonUniqueEventListener(playerNode.headItem.head.button, self, self.OnClickPlayer, uid)
end

function BattleHeadsBoxPart:OnClickPlayer(btn,param)
	local uid = param[0]
	self:ShowCurrentSelectPlayerData(uid)
end

function BattleHeadsBoxPart:RefreshFighterLife(actorId,life,maxLife)
	local headGo = self:GetActorHeadGo(actorId)
	CommonUtil.SetFighterLife(headGo,life,maxLife)
	if tostring(self.curSelectedUid) == tostring(actorId) then
		self.viewLua.playerDetailNode.hpBar.image.fillAmount = SDataUtil.InvConvert(life) / SDataUtil.InvConvert(maxLife)
		local dead = self.viewLua.playerDetailNode.hpBar.image.fillAmount == 0
		CommonUtil.NeedUIGray(self.viewLua.playerDetailNode.petNode.petIcon.image, dead)
		CommonUtil.NeedUIGray(self.viewLua.playerDetailNode.heroHalf.image, dead)
		self.viewLua.playerDetailNode.deadNode:SetActive(dead)
	end
end

function BattleHeadsBoxPart:RefreshFighterSp(actorId,sp,maxSp)
	local headGo = self:GetActorHeadGo(actorId)
	CommonUtil.SetFighterSp(headGo,sp,maxSp)
	if tostring(self.curSelectedUid) == tostring(actorId) then
		self.viewLua.playerDetailNode.spBar.image.fillAmount = SDataUtil.InvConvert(sp) / SDataUtil.InvConvert(maxSp)
	end
end

function BattleHeadsBoxPart:OnRefreshPlayerBuff(actorId,buffIcon,num)
	local buffs = self:GetActorBuffInfo(actorId)
	if self:HasBuffIcon(buffs,buffIcon) then
		self:RefreshBuffNum(buffs,buffIcon,num)
	else
		local temps =  string.split(buffIcon, '/')
		local buffDesc = ""
		if temps ~= nil and #temps > 0 then
			buffDesc = temps[#temps].."_Desc"
		end
		buffs[#buffs+1] = {icon=buffIcon,num = num,desc = buffDesc}
	end

	if tostring(self.curSelectedUid) == tostring(actorId) then
		self:ShowSelectedPlayerBuffInfo(actorId)
	end
end

function BattleHeadsBoxPart:OnRemovePlayerBuff(actorId,buffIcon)
	local buffs = self:GetActorBuffInfo(actorId)
	if self:HasBuffIcon(buffs,buffIcon) then
		self:RemoveBuffIcon(buffs,buffIcon)

		if tostring(self.curSelectedUid) == tostring(actorId) then
			self:ShowSelectedPlayerBuffInfo(actorId)
		end
	end
end

function BattleHeadsBoxPart:RemoveBuffIcon(buffList,buffIcon)
    if buffList ~= nil then
        for i = 1, #buffList do
            if buffList[i].icon == buffIcon then
                table.remove(buffList, i)
                return
            end
        end
    end
end

function BattleHeadsBoxPart:HasBuffIcon(buffList,buffIcon)
	if buffList == nil then
		return false
	end

	for i = 1, #buffList do
		if buffList[i].icon == buffIcon then
			return true
		end
	end
	return false
end

function BattleHeadsBoxPart:RefreshBuffNum(buffList,buffIcon,num)
	if buffList == nil then
		return
	end

	for i = 1, #buffList do
		if buffList[i].icon == buffIcon then
			buffList[i].num = num
			return
		end
	end
end

function BattleHeadsBoxPart:GetHeadGo(idx)
	if idx == 1 then
		return self.viewLua.playerNode1
	end

	if idx == 2 then
		return self.viewLua.playerNode2
	end

	if idx == 3 then
		return self.viewLua.playerNode3
	end

	if idx == 4 then
		return self.viewLua.playerNode4
	end

	return nil
end

function BattleHeadsBoxPart:GetActorHeadGo(actorId)
	if self.actorHeadMapping == nil then
		return nil
	end

	if actorId == nil then
		return nil
	end
	return self.actorHeadMapping[tostring(actorId)].headBoxItemNew
end

function BattleHeadsBoxPart:GetActorBuffInfo(actorId)
	return self.actorBuffs[tostring(actorId)]
end

function BattleHeadsBoxPart:Hide()
	if self.curSelectedUid ~= nil then
		local headGo = self:GetActorHeadGo(self.curSelectedUid)
		LuaBattleBridge.BeginTweenRecTransformPos(headGo,0.1,Vector3(0,0,0))
		self.curSelectedUid = nil
	end

    self:RemoveEventListener()
	self.viewLua:SetActive(false)
	self:HidePlayerNodes()
	self:Clear()
end

function BattleHeadsBoxPart:HidePlayerNodes()
	for i =1, 4 do
		local go = self:GetHeadGo(i)
		go.headPosItem:SetActive(true)
		go.headBoxItemNew:SetActive(false)
		go.headBoxItemNew.headItem.head.button.interactable = false
	end
end

function BattleHeadsBoxPart:Clear()
	self.actorHeadMapping = nil
	self.ourMembers = nil
end

function BattleHeadsBoxPart:Dispose()
	if self.buffGoes ~= nil then
		for i = 1, #self.buffGoes do
			CommonUtil.DestroyGO(self.buffGoes[i])
        end
        self.buffGoes = nil
	end
	self:Hide()
    self.host = nil
    self.viewLua = nil
end


return BattleHeadsBoxPart