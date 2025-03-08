local UIBattleRewardView = require("UIBattle/UIBattleRewardView_Generate")

function UIBattleRewardView:OnAwake(data)
	self.controller = require("UIBattle/UIBattleRewardCtr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UIBattleRewardView:AddEventListener()

end

function UIBattleRewardView:FillContent(data, uiBase)
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

function UIBattleRewardView:Init()
	self:ShowRewardTime();
	self:RefreshLevelUpTime();
	self:ShowBossCount();
	self:ShowShowReWardPerMinute();
	self:ShowRewardData();

	self.time:SetActive(self.controller:GetData() ~= 1 );
	self.reward120m:SetActive(self.controller:GetData() == 1 );
end

function UIBattleRewardView:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UIBattleRewardView:AddUIEventListener()
	self.uiBase:AddButtonEventListener(self.AnyBtn.button,self, self.OnClickClose)
end

function UIBattleRewardView:OnHide()

end

function UIBattleRewardView:OnShow(data)
	self.controller:SetData(data)
	self:Init()
end

function UIBattleRewardView:OnClose()

end

function UIBattleRewardView:OnDispose()
	if self.ItemScrollView and self.ItemScrollView.loopVerticalScrollRect then
		self.ItemScrollView.loopVerticalScrollRect:ClearCells()
	end
end

function UIBattleRewardView:ShowRewardTime()
	self.bossCount.gameObject:SetActive(false);	--隐藏击败boss数量（策划需求）

	local passedTime = ManagerContainer.LuaBattleMgr.accumIncomeTime;
	local maxTime = ManagerContainer.LuaBattleMgr:MaxInComeTime() * 1000
	if passedTime >=  maxTime then
		passedTime = maxTime
		-- self.RewardTimeSlider.slider.value = 1
		-- --self.MaxNode:SetActive(true)
		-- self.RewardTimeLbl.text.text = "12时"
		-- return
	end

	local _rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)
	local _rewardNum = CommonUtil.GetPreciseDecimal(math.floor(passedTime / _rewardIntervalTime / 1000),0);
	if _rewardNum < 1 then _rewardNum = 1; end	--只要能打开这个界面，那至少显示应该是够领取一次了，所以这个值一定是大于1的。但是有时候计时上会有误差，转换的时候这里做一个保护。
	local _timeS = _rewardNum * _rewardIntervalTime;									--折算成秒

	self.RewardTimeSlider.slider.value = passedTime / maxTime;
	self.RewardTimeLbl.text.text = DateTimeUtil.convertSeconds2TimeStr(_timeS, false);
end

function UIBattleRewardView:ShowBossCount()
	--[[策划暂时不想让显示击杀boss数量，暂时隐藏，将来入股再想让开启再打开就是了
	local count = ManagerContainer.LuaBattleMgr:GetRewardMapCount()
	self.BossCountLbl.text.text = I18N.SetLanguageValue("BossKill", count)]]--
end

function UIBattleRewardView:ShowShowReWardPerMinute()
	self.profit.ExpLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelExp() .. "/" .. I18N.T("m") ;
	self.profit.ZenyLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelZeny() .. "/" ..  I18N.T("m");
	self.profit.ParnterExpLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelParnterExp() .. "/" ..  I18N.T("m");
	self.profit.CruiseLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelCruise() .. "/" ..  I18N.T("m");
	self.profit.GoldLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelGold() .. "/" ..  I18N.T("m");
	self.profit.EvilLbl.text.text = ManagerContainer.LuaBattleMgr:CurLevelEvil() .. "/" ..  I18N.T("m");
end

function UIBattleRewardView:ShowRewardData()
	local zenyCnt = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.Coin)
	local partnerExpCnt = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.ParterExp)
	local expCnt = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.RoleBaseExp)
	local treasureCnt = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.SkillExp)
	local goldCnt = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.Diamond)
	local evilCnt = ManagerContainer.LuaBattleMgr:GetRewardCnt(Enum.ItemType.EvilExp)

	self.ExpLbl.text.text = expCnt .. ""
	self.ParnterExpLbl.text.text = partnerExpCnt .. ""
	self.ZenyLbl.text.text = zenyCnt .. ""
	self.CruiseLbl.text.text = treasureCnt .. ""
	self.GoldLbl.text.text = goldCnt .. ""
	self.EvilLbl.text.text = evilCnt .. ""

	self:RefreshVipView()

	for i = 1, #ManagerContainer.LuaBattleMgr.rewardItemList do
		local item = ManagerContainer.LuaBattleMgr.rewardItemList[i];
		if item.key >= 100 then
			self.itemList[#self.itemList+1] = item
		end
	end

	if #self.itemList == 0 then
		self.None:SetActive(true)
		self.ItemScrollView:SetActive(false)
	else
		self.None:SetActive(false)
		self.ItemScrollView:SetActive(true)
	end

	self:Sort();

	CommonUtil.LoopGridViewEleCreateNew(self,
									self.ItemScrollView.loopVerticalScrollRect,
									self.ItemContent.gridLayoutGroup,self.itemList,0,self,self.OnUpdateItemData)
end

function UIBattleRewardView:Sort()
	if #self.itemList <= 0 then return; end
	table.sort(self.itemList, function (a, b)
		local _aCfg = ManagerContainer.CfgMgr:GetItemById(a.key);
		local _bCfg = ManagerContainer.CfgMgr:GetItemById(b.key);
		if _aCfg ~= nil and _bCfg == nil then
			return true;
		elseif _aCfg == nil and _bCfg ~= nil then
			return false;
		elseif _aCfg ~= nil and _bCfg ~= nil then
			local _aQuality = _aCfg.Quality;
			local _bQuality = _bCfg.Quality;
			if _aQuality ~= nil and _bQuality == nil then
				return true;
			elseif _aQuality == nil and _bQuality ~= nil then
				return false;
			elseif _aQuality ~= nil and _bQuality ~= nil then
				if _aQuality ~= _bQuality then
					return _aQuality > _bQuality;
				else
					return a.key < b.key;
				end
			else
				return a.key < b.key;
			end
		else
			return a.key < b.key;
		end
	end)
end

function UIBattleRewardView:OnUpdateItemData(itemLua,idx)
	local item = self.itemList[idx+1];
	if item~= nil then
		CommonUtil.SetRewardItemData(self,item.key,itemLua,item.value, self.OnClickItem)
	end
end

function UIBattleRewardView:OnClickItem(btn,params)
	--local logicData = params[0]
	--ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIItemTips, item)
	local data = params[0]
	local itemData = ManagerContainer.DataMgr.BagData:GetItemDataByCfgId(data.cfgId)
	data.timeStamp = itemData and itemData.timeStamp or nil
	ManagerContainer.LuaUIMgr:OpenTips(data)
end

function UIBattleRewardView:OnClickClose()
	ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleReward)
end

--刷新升级所需的挂机时间
function UIBattleRewardView:RefreshLevelUpTime()
	local _canLevelUp, _needTime, _toNextLevel = self:GetLevelUpNeedTime();
	self.talkBox1.levelUpTime.gameObject:SetActive(_canLevelUp);
	if _canLevelUp then
		self.talkBox1.levelUpTime.time.text.text = _needTime;
		self.talkBox1.levelUpTime.title.text.text = _toNextLevel;
	end
end

--计算升级需要的挂机时间,返回值第一个是bool类型，表示是否不能再升级，第二个是升级到下一个等级需要的时间,第三个是升级到**等级
function UIBattleRewardView:GetLevelUpNeedTime()
	local _baseLv = ManagerContainer.DataMgr.UserData:GetRoleLv();
	local _nextBaseLv = _baseLv + 1;
	local _roleAttrData = ManagerContainer.CfgMgr:GetRoleExpData(_baseLv);
	local _roleAttrNextData = ManagerContainer.CfgMgr:GetRoleExpData(_nextBaseLv);
	if not _roleAttrData or not _roleAttrNextData then	--没有该等级说明出bug了，没有改等级的下一等级，说明满级了，不可能再升级
	 return false , "";
	 end
	local _curLevel = ManagerContainer.LuaBattleMgr:GetCurLevelUniqueId();
	local _levelData = ManagerContainer.CfgMgr:GetLevelDataById(_curLevel);
	if not _levelData then
		LogError("没有找到对应当前等级的level表数据。当前等级是：" .. tostring(_curLevel))
		return false, "";
	end

	local _roleExp = ManagerContainer.DataMgr.UserData:GetRoleExp();
	local _curBaseMaxExp = ManagerContainer.DataMgr.UserData:GetHeroCurBaseMaxExp();
	local _rewardIntervalTime = GlobalConfig.Instance:GetConfigIntValue(47)

	local _needExp = _curBaseMaxExp - _roleExp;
	local _exp = _levelData.BaseExpOl or 0;
	local _expPerSecond = _exp / _rewardIntervalTime;
	local _needSeconds = _needExp / _expPerSecond;
	local _time = "";
	if _needSeconds >= 60 and _needSeconds < Constant.OneDaySeconds then
		_time = DateTimeUtil.convertSeconds2TimeStr1(_needSeconds, true, false, false);
	elseif _needSeconds >= Constant.OneDaySeconds then
		_time = DateTimeUtil.convertSeconds2TimeStr1(_needSeconds, false, false, false);
	else
		_time = "1" .. I18N.T("MINS");
	end
	local _toNextLevel = I18N.SetLanguageValue("LevelUpTime", _nextBaseLv)
	return true, _time, _toNextLevel;
end

function UIBattleRewardView:RefreshVipView()
	local vipLv = nil
	if self.controller:GetData() ~= 1  then
		vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
	end
	if vipLv and vipLv >= 1 then
		local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
		if vipCfg then
			self:RefreshVipItemView(self.ExpVipTag, vipCfg.BaseExpUp)
			self:RefreshVipItemView(self.ParnterExpVipTag, vipCfg.PartnerExpUp)
			self:RefreshVipItemView(self.ZenyVipTag, vipCfg.SilverUp)
			self:RefreshVipItemView(self.CruiseVipTag, vipCfg.SkillExpUp)
			self:RefreshVipIconView(self.ExpVipTag.icon.image, nil)
			self:RefreshVipIconView(self.ParnterExpVipTag.icon.image, nil)
			self:RefreshVipIconView(self.ZenyVipTag.icon.image, nil)
			self:RefreshVipIconView(self.CruiseVipTag.icon.image, nil)
			CommonUtil.LoadIcon(self, vipCfg.SmallIcon, function(sprite)
				if sprite then
					self:RefreshVipIconView(self.ExpVipTag.icon.image, sprite)
					self:RefreshVipIconView(self.ParnterExpVipTag.icon.image, sprite)
					self:RefreshVipIconView(self.ZenyVipTag.icon.image, sprite)
					self:RefreshVipIconView(self.CruiseVipTag.icon.image, sprite)
				end
			end)
			return
		end
	end
	self:RefreshVipItemView(self.ExpVipTag, nil)
	self:RefreshVipItemView(self.ParnterExpVipTag, nil)
	self:RefreshVipItemView(self.ZenyVipTag, nil)
	self:RefreshVipItemView(self.CruiseVipTag, nil)
	self:RefreshVipIconView(self.ExpVipTag.icon.image, nil)
	self:RefreshVipIconView(self.ParnterExpVipTag.icon.image, nil)
	self:RefreshVipIconView(self.ZenyVipTag.icon.image, nil)
	self:RefreshVipIconView(self.CruiseVipTag.icon.image, nil)
end

function UIBattleRewardView:RefreshVipItemView(vipTag, value)
	if value and value > 0 then
		vipTag:SetActive(true)
		vipTag.number.text.text = '+' .. CommonUtil.GetPreciseDecimal(value * 0.01, 2) .. '%'
	else
		vipTag:SetActive(false)
	end
end

function UIBattleRewardView:RefreshVipIconView(image, sprite)
	image.sprite = sprite
	image.enabled = (sprite ~= nil)
end

return UIBattleRewardView

