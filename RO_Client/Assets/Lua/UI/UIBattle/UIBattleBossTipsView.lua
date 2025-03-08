local UIBattleBossTipsView = require("UIBattle/UIBattleBossTipsView_Generate")

function UIBattleBossTipsView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleBossTipsCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleBossTipsView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UIBattleBossTipsView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
	self.TxtRectTrans.rectTransform.anchoredPosition = Vector2.zero
end

function UIBattleBossTipsView:Init()
	self.skillItemList = {}
	self.skillItemList[#self.skillItemList+1] = self.skillTemplate
	
	self.attrItemList = {}
	self:SetBossData()
end

function UIBattleBossTipsView:SetBossData()
	if self.controller:GetData() == nil then
		return
	end
	local bossActor = self.controller:GetData()

	local bossCfg = ManagerContainer.CfgMgr:GetNpcCfgById(bossActor.BaseId)
	if bossCfg == nil then
		return
	end

	self.bossLevel.text.text = tostring(bossActor.ShowLevel)
	self.bossName.text.text = bossCfg.Name
	self.bossDesc.text.text = bossCfg.Desc

	local natureCfg = ManagerContainer.CfgMgr:GetNatureDataById(bossCfg.NatureId)
	if natureCfg ~= nil then
		self.natureName.text.text = natureCfg.Name
		CommonUtil.LoadIcon(self, natureCfg.Icon, function (sprite)
			self.natureImg.image.sprite = sprite
		end)
	end

	if bossCfg.Icon ~= nil and bossCfg.Icon ~= "" then
		CommonUtil.LoadIcon(self, bossCfg.Icon, function (sprite)
			self.bossImg.image.sprite = sprite
			self.bossImg.image:SetNativeSize()
			if bossCfg.IconOffset~= nil then
				local offset = Vector2(bossCfg.IconOffset[1],bossCfg.IconOffset[2])
				self.bossImg.rectTransform.anchoredPosition = offset
			end	
		end)
	end

	if bossCfg.BgImg ~= nil and bossCfg.BgImg ~= "" then
		CommonUtil.LoadIcon(self, bossCfg.BgImg, function (sprite)
			self.bgImg.image.sprite = sprite
		end)
	end
	
	--筛除重复技能
	local tbSkill ={}
	if bossCfg.SkillIds ~= nil and #bossCfg.SkillIds > 0 then
		for i =1, #bossCfg.SkillIds do 			
			local skillid = bossCfg.SkillIds[i][1] 
			local tbIndex = self:GetIndexBySkillId(skillid,bossCfg.SkillIds)
			if nil ~= tbIndex and #tbIndex >= 1 and i == tbIndex[1] then			
				table.insert(tbSkill,bossCfg.SkillIds[i]) 			
			end
		end	
	end	
	--添加被动技能
	if bossCfg.PassiveSkills ~= nil and #bossCfg.PassiveSkills > 0 then
		for i =1, #bossCfg.PassiveSkills do 
			table.insert(tbSkill,bossCfg.PassiveSkills[i]) 			
		end
	end
	if tbSkill ~= nil and #tbSkill > 0 then
		for i =1, #tbSkill do 
			local skillItemLua = self:GetSkillItemLua(i)
			self:SetSkillData(skillItemLua,tbSkill[i][1],tbSkill[i][2])
		end
	else
		self.skillTemplate:SetActive(false)
	end

	local cursor  = 1
	for i = 7, 16 do
		if i ~= 8 and i ~= 10 then
			local val = bossActor:GetAttr(i)
			local attrGo = self:GetAttrGo(cursor)
			if i == 9 then				
				local valMagicAttack = bossActor:GetAttr(i+1)--魔攻
				if SDataUtil.InvConvert(val) < SDataUtil.InvConvert(valMagicAttack) then									
					self:SetAttrData(attrGo,i+1,valMagicAttack)	
				else
					self:SetAttrData(attrGo,i,val)			
				end
			else 
				self:SetAttrData(attrGo,i,val)	
			end
			cursor = cursor + 1
		end
	end
end

--获取相同ID的索引
function UIBattleBossTipsView:GetIndexBySkillId(skillid,tbSkills)
	local tbIndex = {}
	if tbSkills ~= nil and #tbSkills > 0 then
		for i =1, #tbSkills do 			
			if tbSkills[i][1] == skillid then
				table.insert(tbIndex,i) 
			end
		end
	end
	return tbIndex
end

function UIBattleBossTipsView:GetAttrGo(idx)
	if idx <= #self.attrItemList then
		return self.attrItemList[idx]
	end

	local attrGo = UnityEngine.GameObject.Instantiate(self.attrTemp.gameObject)
	attrGo.name = "atrr" .. idx
	attrGo.transform:SetParent(self.atrrList.transform)
	attrGo.transform.localScale = Vector3(1,1,1)
	local rectTrans = attrGo:GetComponent(Enum.TypeInfo.RectTransform)
	rectTrans.anchoredPosition3D = Vector3(0,0,0)
	attrGo:SetActive(true)
	self.attrItemList[#self.attrItemList+1] = attrGo
	return attrGo
end

function UIBattleBossTipsView:SetAttrData(attrGo,attrId,attrVal)
	if attrGo == nil then
		return
	end

	local lbl = attrGo.transform:Find("Lbl")
	if lbl ~= nil then
		local txt = lbl:GetComponent(Enum.TypeInfo.Text)
		if txt ~= nil then
			txt.text = I18N.T("Attr_"..attrId)
		end
	end

	local val = attrGo.transform:Find("Val")
	if val ~= nil then
		local txt = val:GetComponent(Enum.TypeInfo.Text)
		if txt ~= nil then
			txt.text = CommonUtil.GetPreciseDecimal(SDataUtil.InvConvert(attrVal),0)
		end
	end
end

function UIBattleBossTipsView:GetSkillItemLua(idx)
	if idx <= #self.skillItemList then
		return self.skillItemList[idx]
	end

	local skillNode = UnityEngine.GameObject.Instantiate(self.skillTemplate.gameObject)
	local skillLua = CommonUtil.BindGridViewItem2Lua(self, "SkillItem", skillNode)
	skillLua.prefabName = "SkillItem"
	skillNode.name = "SkillItem"
	skillLua.transform:SetParent(self.skillList.transform)
	skillLua.transform.localScale = Vector3(1,1,1)
	skillLua.rectTransform.anchoredPosition3D = Vector3(0,0,0)
	skillLua:SetActive(true)

	self.skillItemList[#self.skillItemList+1] = skillLua
	return skillLua
end

function UIBattleBossTipsView:SetSkillData(skillLua,skillId,skillLv)
	if skillLua == nil then
		return
	end

	local skillCfg = ManagerContainer.CfgMgr:GetSkillCfgById(skillId)
	if skillCfg == nil then
		return
	end

	skillLua.num.text.text = I18N.T("Lv.") .. skillLv
	if skillCfg.Icon ~= nil and skillCfg.Icon ~= "" then
		CommonUtil.LoadIcon(self, skillCfg.Icon, function (sprite)
			skillLua.icon.image.sprite = sprite
		end)
	end

	skillLua:SetActive(true)
	self.uiBase:AddButtonUniqueEventListener(skillLua.icon.button, self, self.OnClickSkill, skillId,skillLv)
end

function UIBattleBossTipsView:OnClickSkill(btn,params)
	local skillId = params[0]
	local skillLv = params[1]
	local data = { tipsType = Enum.UITipsType.Skill, cfgId = skillId, num = skillLv }
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIBattleBossTipsView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleBossTipsView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
	self.uiBase:AddButtonEventListener(self.closeBtn.button,self, self.OnClickClose)
end

function UIBattleBossTipsView:OnHide()

end

function UIBattleBossTipsView:OnShow(data)
	self.controller:SetData(data)
	self.TxtRectTrans.rectTransform.anchoredPosition = Vector2.zero
end

function UIBattleBossTipsView:OnClose()
	self:ClearGoes()
end

function UIBattleBossTipsView:OnDispose()
	self.controller:OnDispose()
end

function UIBattleBossTipsView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(self.uiBase.PageId)
end

function UIBattleBossTipsView:ClearGoes()
	for i = 1, #self.attrItemList do
		CommonUtil.DestroyGO(self.attrItemList[i])
	end
	self.attrItemList = nil

	for i = 2, #self.skillItemList do
		CommonUtil.DestroyGO(self.skillItemList[i].gameObject)
	end
	self.skillItemList = nil

	CommonUtil.ClearGridViewItem(self,"SkillItem")
end

return UIBattleBossTipsView

