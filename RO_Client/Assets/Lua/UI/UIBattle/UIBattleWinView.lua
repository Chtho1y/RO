local UIBattleWinView = require("UIBattle/UIBattleWinView_Generate")
--local UIMainCtr = require("UIMain/UIMainCtr")
local UIMainCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UIMain)

local BigMapView = require("UIBigMap/BigMapView")

function UIBattleWinView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleWinCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleWinView:AddEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name, UIEventNames.BIGMAP_SELF_RANK_CHANGED, self, self.OnSelfRankChanged)
end

function UIBattleWinView:FillContent(data, uiBase)
	self.itemList = {}
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UIBattleWinView:Init()
	if not self.bigMapView then
		self.bigMapView = BigMapView:new(self)
	end
	local curMapId, curLevelId = self.controller:GetCurMapAndLevel()
	self.bigMapView:InitData(curMapId, curLevelId, curMapId, Enum.BigMapEnterType.NextLevel)
	self:ShowRewardData()
end

function UIBattleWinView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleWinView:AddUIEventListener()
	-- self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIBattleWinView:OnHide()

end

function UIBattleWinView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIBattleWinView:OnClose()
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BATTLE_WIN_CLOSE)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.NEW_LEVEL_INCREASE_NTF)
end

function UIBattleWinView:OnDispose()
	if self.bigMapView then
		self.bigMapView:Dispose()
		self.bigMapView = nil
	end
	self.controller:OnDispose()
end

function UIBattleWinView:OnPageInEnd()
	if self.bigMapView then
		self.bigMapView:OnPageInEnd()
	end
	self.super.OnPageInEnd(self)
end

function UIBattleWinView:OnSelfRankChanged()
	if self.bigMapView then
		self.bigMapView:RefreshSelfRank()
	end
end

function UIBattleWinView:BigMapViewComplete(hasFollow)
	self:DropToBox(not hasFollow)
	self:DropItems(not hasFollow)
	self:UIClose()
	if not hasFollow then
		local curLevel = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId()
		local levelData = ManagerContainer.CfgMgr:GetLevelDataById(curLevel)
		if levelData == nil then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER, true)
			ManagerContainer.LuaBattleMgr:StartAutoChallenge()
			return
		end

		if levelData.ForceGuideGroup > 0 then
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GOT_ANIM_TYPE_END_NOTIFY, Enum.ItemIEnterType.BattleWin)
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_TRIGGER, Enum.ForceGuideTriggerEnum.BattleWin)
		else
			ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_OVER, true)
			ManagerContainer.LuaBattleMgr:StartAutoChallenge()
			return
		end
	end
	ManagerContainer.LuaBattleMgr:StopAutoChallenge(true)
	
end

function UIBattleWinView:ShowRewardData()
	local levelCfgData = self.controller:GetLevelCfgData()
	if not levelCfgData then
		self.expBase.text.text.text = '0'
		self.zeny.text.text.text = '0'
		self.expParter.text.text.text = '0'
		self.expJob.text.text.text = '0'
		self.coin.text.text.text = '0'
		self.drop.text.text.text = '0'
		return
	end
	self.expBase.text.text.text = tostring(levelCfgData.BaseExp)
	self.zeny.text.text.text = tostring(levelCfgData.Zeny)
	self.expParter.text.text.text = tostring(levelCfgData.Parter)
	self.expJob.text.text.text = tostring(levelCfgData.JobExp)
	self.coin.text.text.text = tostring(levelCfgData.Gold)
	local num = 0
	local rewardList = ManagerContainer.LuaBattleMgr.rewardItemList
	for i = 1,#rewardList do
		if rewardList[i].key >= 100 and rewardList[i].value > 0 then
			num = num + 1
		end
	end
	self.drop.text.text.text = tostring(num)
end

-- function UIBattleWinView:OnClickClose()
-- 	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.BATTLE_WIN_CLOSE)
-- 	self:DropItems(true)

-- 	if not ManagerContainer.LuaBattleMgr:IsNewMap() then
-- 		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.NEW_LEVEL_INCREASE_NTF)
-- 		if ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(29) then
-- 			self:DropToBox(false)
-- 		end

-- 		ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.UI_FORCE_GUIDE_TRIGGER, Enum.ForceGuideTriggerEnum.BattleWin)
-- 	end
-- end

function UIBattleWinView:DropItems(isDrop)
	if not isDrop then return end
	if not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(35) then
		return
	end
	--local zeny = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.Coin)
	-- local jobExp = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.RoleJobExp)
	-- local exp = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.RoleBaseExp)
	local levelCfgData = self.controller:GetLevelCfgData()
	if not levelCfgData then
		return
	end
	local zeny = levelCfgData.Zeny
	local jobExp = levelCfgData.JobExp
	local exp = levelCfgData.BaseExp

	local createZeny = false;
	local createExp=false;
	local createJobExp = false;

	local startPos = Vector3.New(0, 0, 0)
	local zenyPos = UIMainCtr:GeAnchoredPosition3DByType(Enum.ItemType.Coin)
	local expPos = UIMainCtr:GeAnchoredPosition3DByType(Enum.ItemType.RoleBaseExp)
	local jobExpPos = UIMainCtr:GeAnchoredPosition3DByType(Enum.ItemType.RoleJobExp)

	if zeny ~= nil and zeny > 0 then
		createZeny = true
	end

	if jobExp~= nil and jobExp > 0 then
		createJobExp = true
	end

	if exp ~= nil and exp > 0 then
		createExp = true
	end

	local itemIcons = {};
	--for i =1, #ManagerContainer.LuaBattleMgr.rewardItemList do
	--	local item = ManagerContainer.LuaBattleMgr.rewardItemList[i];
	--	if item.key >= 100 then
	--		local itemCfg = ManagerContainer.CfgMgr:GetItemById(item.key)
	--		if itemCfg~= nil then
	--			itemIcons[#itemIcons+1] = itemCfg.Icon
	--		end
	--	end
	--end

	if zenyPos == nil or expPos == nil or jobExpPos == nil then
		LogError("Bhy: zenyPos = " .. tostring(zenyPos) .. " expPos = " .. tostring(expPos) .. " jobExpPos = " .. tostring(jobExpPos))
		return
	end
	
	LuaBattleBridge.GenerateDropItems(startPos,createZeny,zenyPos,createExp,expPos,false,Vector3.zero,createJobExp,jobExpPos,0.30,0.25,unpack(itemIcons));
end

function UIBattleWinView:DropToBox(isDrop)
	ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.GOT_ANIM_TYPE_END_NOTIFY, Enum.ItemIEnterType.BattleWin)
	if not isDrop then
		return
	end
	if not ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(35) then
		return
	end

	local startPos = Vector3.New(0, 0, 0)
	local boxPos = UIMainCtr:GetGotAnimEndPosByType(Enum.ItemType.Item)

	local data = {}
	local startPoses = {}
	local endPoses = {}
	local rewardList = ManagerContainer.LuaBattleMgr.rewardItemList
	for i = 1,#rewardList do
		if rewardList[i].key >= 100
				and rewardList[i].value > 0 then
			data[#data + 1] = {cfgId = rewardList[i].key, num = rewardList[i].value}
			startPoses[#startPoses + 1] = startPos
			endPoses[#endPoses + 1] = boxPos
		end
	end

	local data1 = {list = data, startPoses = startPoses, endPoses = endPoses, needOffset = true, enterType = Enum.ItemIEnterType.BattleWin}
	ManagerContainer.LuaUIMgr:POPGotAnimNotice(data1)
end

return UIBattleWinView

