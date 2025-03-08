local UIFruitUseView = require("UIRoleMain/UIFruitUseView_Generate")
local FruitHeroItemCtr  = require("Common/FruitHeroItemCtr")

function UIFruitUseView:OnAwake(data)
	self.controller = require("UIRoleMain/UIFruitUseCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
	self:InitConfigData()
end

function UIFruitUseView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.FRUIT_USE_SUCC,self,self.OnAddFruitBack)
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name,UIEventNames.ITEM_CHANGE,self,self.InitUIInfo)
end

--点击关闭界面按钮
function UIFruitUseView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIFruitUse)
end

function UIFruitUseView:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)
	self:Init()
end

function UIFruitUseView:Init()
	self:InitUIInfo()
	local userNames = {}
	local headIcons = {}
	local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(1)
	headIcons[1] =  CommonUtil.GetHeroCfgDataByUid(herodata.id).BattleCartoonImg
	userNames[1] = ManagerContainer.DataMgr.UserData:GetUserNickname()
	FruitHeroItemCtr:SetData(self,self["hero1"],herodata,self.cfgData,self.itemCfgData,userNames[1],headIcons[1])
	local partnerDatas = self.controller:GetSlotSortPartnerDatas()
	for i = 1, #partnerDatas do
		headIcons[i + 1] =  CommonUtil.GetHeroCfgDataByUid(partnerDatas[i].id).BattleCartoonImg
		local _partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(partnerDatas[i].configId)
		userNames[i + 1] = string.formatbykey(_partnerData.Name)
		FruitHeroItemCtr:SetData(self,self["hero"..(i + 1)],partnerDatas[i],self.cfgData,self.itemCfgData,userNames[i + 1],headIcons[i + 1])
	end
end

--发送果实请求消息
function UIFruitUseView:SendNetMessage(heroidx,configidx)
	--计时0.5s 不能连点
	if self.istimer then
		return
	end

	if self.delayTimer then
		self.delayTimer:Stop()
	else
		self.delayTimer = Timer.New(function ()
			self.istimer = false
		end, 0.5)  
	end
	self.istimer = true
	self.delayTimer:Start()
	local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(heroidx)
	local configData = self.cfgData
	if herodata.qualityList and herodata.qualityList[configData[configidx][1]] and herodata.qualityList[configData[configidx][1]] == configData[configidx][3] or (heroidx ~= 1 and not herodata.owned) then
		return
	end 
	if self.fruitNums[configidx] == 0 then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam('DscSeasonResult12',self.itemCfgData[configidx]['Name'])
		return
	end
	 ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ADD_QUALITY_POINT_REQ,{hero_id = heroidx,item_id =configData[configidx][1]})
end

--初始化配置表数据
function UIFruitUseView:InitConfigData()
	local cfgdata = GlobalConfig.Instance:GetConfigStrValue(312)
	self.cfgData  =  CommonUtil.DeserializeGlobalStrToNumberTable(cfgdata)
	self.itemCfgData = {}
	for i = 1, #self.cfgData do
		self.itemCfgData[i] = ManagerContainer.CfgMgr:GetItemById(self.cfgData[i][1])
	end
end
--初始化UI显示
function UIFruitUseView:InitUIInfo()
	local primarynum = ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(self.cfgData[1][1])
	local seniornum =ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(self.cfgData[2][1])
	if not self.fruitNums then
		self.fruitNums = {}
	end
	if self.fruitNums[1] == primarynum and self.fruitNums[2] == seniornum then
		--数据未改变 不刷新
		return
	end
	self.fruitNums[1] = primarynum
	self.fruitNums[2] = seniornum
	if primarynum == 0 then
		self.primaryText.text.text = "<color=red>"..primarynum.."</color>"
	else
		self.primaryText.text.text = primarynum
	end
	if seniornum == 0 then
		self.seniorText.text.text = "<color=red>"..seniornum.."</color>"
	else
		self.seniorText.text.text = seniornum
	end
end

function UIFruitUseView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)	
end

--使用果实请求返回消息
function UIFruitUseView:OnAddFruitBack(data)
		self:InitUIInfo()
		local index = self.controller:GetHeroDataIndex(data[1]) + 1
		FruitHeroItemCtr:SetData(self,self["hero"..index],data[2],self.cfgData,self.itemCfgData)
end

function UIFruitUseView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.btnClose.button,self,self.OnClickClose)
	self.uiBase:AddButtonEventListener(self["hero1"].fruit1BtnUse.button,function()
		self:SendNetMessage(1,1)
	 end)

	 self.uiBase:AddButtonEventListener(self["hero1"].fruit2BtnUse.button,function()
		self:SendNetMessage(1,2)
	 end)
	 local partnerDatas = self.controller:GetSlotSortPartnerDatas()
	 for i = 1, #partnerDatas do
		self.uiBase:AddButtonEventListener(self["hero"..(i + 1)].fruit1BtnUse.button,function()
			self:SendNetMessage(partnerDatas[i].id,1)
		 end)

		 self.uiBase:AddButtonEventListener(self["hero"..(i + 1)].fruit2BtnUse.button,function()
			self:SendNetMessage(partnerDatas[i].id,2)
		 end)
	end
end

function UIFruitUseView:OnHide()

end

function UIFruitUseView:OnShow(data)
	self.controller:SetData(data)

end

function UIFruitUseView:OnClose()
end

function UIFruitUseView:OnDispose()
	self.cfgData = nil 
	self.itemCfgData = nil
	if self.delayTimer then
		self.delayTimer:Stop()
	end
	self.delayTimer = nil
	self.controller:OnDispose()
end

return UIFruitUseView

