local UIRoleMessageCtr = class("UIRoleMessageCtr", require("UICtrBase"))
local CreateActorSystem = require("CreateActorSystem")

local sortedPartnerDatas
local activationList = {}
local battledPartnerCount = 0

local isOther = false

function UIRoleMessageCtr:Init(view)
	self.view = view
	ManagerContainer = require("ManagerContainer")

	self.createActorSystem = CreateActorSystem:new()
end

function UIRoleMessageCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data	--data._targetTag == 0是玩家自己，除此之外都是其他玩家
	self:GetPlayerData();
end

function UIRoleMessageCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleMessageCtr:GetData()
	return self.data
end

function UIRoleMessageCtr:OnDispose()
	sortedPartnerDatas = nil;
	if self.createActorSystem then
		self.createActorSystem:Dispose()
		self.createActorSystem = nil
	end

	self.data = nil
	self.view = nil
end

---逻辑处理start
--根据玩家选择的不同，获取不同的玩家数据
function UIRoleMessageCtr:GetPlayerData()
	if self.data._targetTag and self.data._targetTag == 0 then	--玩家自己
		self.data._tidyData = self:TidySelfData();
		self:GetRoleSeasonTitle(true, nil, self.data._tidyData);
	else	--别的玩家,别的玩家的数据要等待服务器发送，所以要等到服务器发送了数据之后才能整理，整理完成之后才能通知view，数据已经整理好了
		self.data._targetTag = 1;
		self.data._tidyData = self:TidyOtherData(self.data);

		self:GetRoleSeasonTitle(false, self._userData.paramList, self.data._tidyData);
	end
end

--整理其他玩家的数据
function UIRoleMessageCtr:TidyOtherData(_data)
	isOther = true
	--LogError(Inspect(_data.target_info.role_hero))
	
	if not _data._isCross then
		self.createActorSystem:ParseOtherRoleInfo(_data.target_info);
	else
		self.createActorSystem:ParseFightRoleInfo(_data);
	end
	
	local _userData = self.createActorSystem;
	local _partnerData = self.createActorSystem;	
	local _tidyData = {};
	local _score = _data.target_info and _data.target_info.danScore or 0;
	local _guildName = self.createActorSystem:GetGuildName()
	self:TidyDataByData(_tidyData, _userData, _partnerData, _score, _guildName);
	self:GetHeadPortrait( _userData, _tidyData);
	self._userData = _userData.userData;
	self._partnerData = _partnerData.fellewActorDatas;
	_tidyData._titleId = _data.target_info and _data.target_info.brief.head_id or self._userData.titleId	--其他人的称号Id
	return _tidyData;
end

function UIRoleMessageCtr:IsCrossRole()
	return self.data._isCross
end

function UIRoleMessageCtr:GetPetDataByHeroId(id)
	if isOther then
		return self.createActorSystem:GetHeroPetDataByHeroId(id)
	else
		local heroData = CommonUtil.GetHeroLogicDataByUid(id)
		return ManagerContainer.DataMgr.PetDataMgr:GetPetDataById(heroData.battlePetId)
	end
end

function UIRoleMessageCtr:GetPetActorDataByPetId(id)
	if isOther then
		return self.createActorSystem:GetHeroPetActorDataById(id)
	else
		return ManagerContainer.DataMgr.PetDataMgr:GetPetActorData(id)
	end
end

--整理玩家自己的数据
function UIRoleMessageCtr:TidySelfData()
	isOther = false
	local _tidyData = {};
	local curGuildData = ManagerContainer.DataMgr.GuildDataMgr:GetCurGuildData()
	local _guildName = curGuildData and curGuildData:GetName() or nil
	self:TidyDataByData(_tidyData, ManagerContainer.DataMgr.UserData, ManagerContainer.DataMgr.PartnerData,
			ManagerContainer.DataMgr.ArenaData:GetCurDanScore(), _guildName);
	self:GetHeadPortrait(ManagerContainer.DataMgr.UserData, _tidyData);
	self._userData = ManagerContainer.DataMgr.UserData;
	self._partnerData = ManagerContainer.DataMgr.PartnerData;
	--角色信息页面end
	return _tidyData;
end

function UIRoleMessageCtr:RefreshTitleIconAndName(_titleIcon, _name)
	self.data._tidyData._playerData._titleIcon = _titleIcon;
	self.data._tidyData._playerData._titleName = _name;
end

--获取不同玩家的赛季信息
function UIRoleMessageCtr:GetRoleSeasonTitle(_isSelf, _paramList, _tidyData)
	local _titleIcon = "";
	if _isSelf then
		_tidyData._playerData._titleName, _titleIcon, _tidyData._playerData._titleIcon = I18N.T("None") --ManagerContainer.DataMgr.CompetitionData:GetCurSeasonTitle();	--称号;
	else
		_tidyData._playerData._titleName, _titleIcon, _tidyData._playerData._titleIcon = I18N.T("None") --self:GetCurSeasonTitle(_paramList);	--称号;
	end
end

--获取赛季信息
function UIRoleMessageCtr:GetCurSeasonTitle(_paramList)
	local title = I18N.T("None")
	local titleIcon = nil;
	local competitionTitleIcon = nil;
	title, titleIcon, competitionTitleIcon = CommonUtil.GetCurSeasonTitle(_paramList);
	return title, titleIcon, competitionTitleIcon
end

--获取玩家头像图片
function UIRoleMessageCtr:GetHeadPortrait(_userData, _tidyData)
	_tidyData._playerData._headIcon = _userData:GetUserHeadIcon();	--头像图片
	_tidyData._playerData._headIconId = _headPortraitId;
end


--根据传进来的信息整理不同的数据
function UIRoleMessageCtr:TidyDataByData(_tidyData, _userData, _partnerData, _danScore, _guildName)
	--玩家页面数据start
	_tidyData._playerData = {};
	_tidyData._playerData._baseLevel = _userData:GetRoleLv();	--base等级
	_tidyData._playerData._nickName = _userData:GetUserNickname();	--玩家昵称
	_tidyData._playerData._jobId = _userData:GetJobCfgId();		--职业Id
	_tidyData._playerData._headFrameId = _userData:GetHeadFrameId();	--头像框id
	if self.data._targetTag and self.data._targetTag == 0 then	
		_tidyData._playerData._vipLv = _userData:GetVipLv()--自己的vip 	
	else
		_tidyData._playerData._vipLv = _userData.userData.vipLv	--其他人的vip
	end	
	local _jobCfg = ManagerContainer.CfgMgr:GetJobDataById(_userData:GetJobCfgId());
	_tidyData._playerData._leaderJobIcon = _jobCfg.JobIcon;
	_tidyData._playerData._leaderIsMagic = false;	--默认主角是物攻型角色
	if _jobCfg then
		if _jobCfg.AtkRate > 0 then	--物攻系数大于零，说明主角是物攻型角色
			_tidyData._playerData._leaderIsMagic = false;
		elseif _jobCfg.MatkRate > 0 then	--魔攻系数大于零，说明主角是魔攻型角色
			_tidyData._playerData._leaderIsMagic = true;
		else
			LogError("主角的JobId是：" .. tostring(_jobCfg.Id) .. " 数据的魔攻系数和物攻系数都为0.这两个参数至少有一个不能是零。")
		end
	else
		LogError("没有找到主角的JOb数据，主角的JobId是：" .. tostring(_userData:GetJobCfgId()) .. "请检查JobCfg表");
	end
	--_tidyData._playerData._jobLevel = _userData:GetJobLv();		--职业等级
	_tidyData._playerData._totalPower = _userData:GetTotalFightPower();	--先获取主角的战力
	local _heroData = _userData:GetPlayerActorParam();	
	_tidyData._playerData._baseAttack = SDataUtil.InvConvert(_heroData.BaseAttack);	--一级物攻属性
	_tidyData._playerData._baseMagicAttack = SDataUtil.InvConvert(_heroData.BaseMagicAttack)	--一级魔攻属性
	_tidyData._playerData._allianceName = (_guildName and _guildName ~= '') and _guildName or string.formatbykey('None');	--TODO:工会模块尚未开发
	_tidyData._playerData._allianceIcon = "";	--TODO:工会模块尚未开发
	_tidyData._playerData._dun = _danScore;	--赛季积分，段位和段位图标啥的还得自己算
	_tidyData._playerData._id = _userData:GetId();	--id，这个更类似于index
	_tidyData._playerData._skills = _userData:GetSkillData(_tidyData._playerData._id);	--主角的技能数据
	_tidyData._playerData._slots = _userData:GetCurSlotInfos(_tidyData._playerData._id);	--主角的装备信息
	--找到主角的模型用的start
	_tidyData._playerData._roleId = _userData:GetUserRoleId();
	_tidyData._playerData._viewData = _userData:GetViewData();
	_tidyData._playerData._extGoesShowData = _userData:GetMainRoleData().extGoesShowData
	--找到主角模型用的end
	--战力
	_tidyData._playerData._powers = {};
	_tidyData._playerData._powers[1] = SDataUtil.InvConvert(_userData:GetHeroData().fightPower or 0);
	_tidyData._playerData.petFightPower = {}
	_tidyData._playerData.petFightPower[1] = SDataUtil.InvConvert(_userData:GetHeroData().petFightPower or 0);
	--玩家页面数据end
	--角色信息页面start
	_tidyData._roleData = {};
	_tidyData._roleData._partnerDatas = _partnerData:GetPartnerDatas();	--队友
	_tidyData._roleData._activationList = self:RefreshPartnersLists(_tidyData._roleData._partnerDatas);	--获取所有的招募队友
	_tidyData._roleData._sortPartner = self:GetSortedPartnerDatas(_tidyData._roleData._partnerDatas);
	_tidyData._roleData._partnerSkill = {};
	_tidyData._roleData._partnerBaseAttack = {};
	_tidyData._roleData._partnerBaseMagicAttack = {};

	for k, v in ipairs(_tidyData._roleData._sortPartner) do	
		--LogError(Inspect(v))
		local _logicId = k + 1;
		_tidyData._roleData._partnerSkill[k] = _userData:GetSkillData(v.id);	--技能
		_tidyData._playerData._powers[_logicId] = SDataUtil.InvConvert(v.fightPower);	--战力
		_tidyData._playerData.petFightPower[_logicId] = SDataUtil.InvConvert(v.petFightPower or 0);
		--记录初始物攻和初始魔攻
		local _partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(v.configId);
		_tidyData._roleData._partnerBaseAttack[k] = _partnerData.Atk;
		_tidyData._roleData._partnerBaseMagicAttack[k] = _partnerData.Matk;
	end
	--获取所有角色的所有属性
	_tidyData._roleData._Attr = {
		["leader"] = {};
		["partner"] = {};
	};
	if self.data._targetTag and self.data._targetTag == 0 then	
		_tidyData._roleData._Attr.leader = _userData:GetAllAttrs();
	else
		_tidyData._roleData._Attr.leader = _userData:GetAllFinalAttr();
	end
	--获取所有角色的基础属性
	_tidyData._roleData._baseAttr = {
		["leader"] = {};
		["partner"] = {};
	};
	--通过判断对象的一级基础魔攻和物攻的值来判断他是物攻型还是魔攻型从而决定显示魔攻值还是物攻值
	local _JudgeAttack = function(_attrs, _baseAttack,  _baseMagicAttack, _isLeader, _leaderIsMagic)
		local _attackIndex, _magicAttackIndex = -1, -1;
		for i = #_attrs, 1, -1 do
			if _attrs[i].key == Enum.HeroAttrType.Attack then
				_attackIndex = i;
			end
			if _attrs[i].key == Enum.HeroAttrType.MagicAttack then
				_magicAttackIndex = i;
			end
		end
		local _removeIndex = -1;
		if not _isLeader then
			if _baseAttack == 0 or _baseAttack == nil then
				_removeIndex = _attackIndex;
			elseif _baseMagicAttack == 0 or _baseMagicAttack == nil then
				_removeIndex = _magicAttackIndex;
			else --进到这里就是策划配错了，这里默认将魔攻去掉，不显示,先确保游戏正常进行
				_removeIndex = _magicAttackIndex;
			end
		else
			if _leaderIsMagic then
				_removeIndex = _attackIndex;
			else
				_removeIndex = _magicAttackIndex;
			end
		end

		if _removeIndex ~= -1 then
			table.remove(_attrs, _removeIndex)
		end
	end


	local _attrKeys = self:GetBaseAttrKeys();
	for i = 1, #_attrKeys do
		local _value = SDataUtil.InvConvert(_heroData:GetFinalAttr(_attrKeys[i])) or 0;
		if not ((_attrKeys[i] == Enum.HeroAttrType.Attack or _attrKeys[i] == Enum.HeroAttrType.MagicAttack) and _value == 0) then
			table.insert(_tidyData._roleData._baseAttr.leader, {
				["key"] = _attrKeys[i],
				["value"] = math.floor(_value);
			})
		end
	end
	_JudgeAttack(_tidyData._roleData._baseAttr.leader, _tidyData._playerData._baseAttack, _tidyData._playerData._baseMagicAttack, true, _tidyData._playerData._leaderIsMagic);
	for i = 1, #_tidyData._roleData._sortPartner do
		local _attrs = {};
		for j = 1, #_attrKeys do
			local PartnerData = _tidyData._roleData._sortPartner[i]			
			local _value = SDataUtil.InvConvert(_tidyData._roleData._sortPartner[i].attrs[_attrKeys[j]] or 0);
			if nil == self.data._targetTag or self.data._targetTag ~= 0 then	
				local PartnerActorData =_userData:FindFellowActorDataByData(PartnerData)
				if nil ~= PartnerActorData then
					_value = SDataUtil.InvConvert(PartnerActorData:GetFinalAttr(_attrKeys[j]) or 0);
				end
			end		
			if not ((_attrKeys[j] == Enum.HeroAttrType.Attack or _attrKeys[j] == Enum.HeroAttrType.MagicAttack) and _value == 0) then
				table.insert(_attrs, {
					["key"] = _attrKeys[j],
					["value"] = math.floor(_value);
				})
			end
		end
		_JudgeAttack(_attrs, _tidyData._roleData._partnerBaseAttack[i], _tidyData._roleData._partnerBaseMagicAttack[i], false, nil);
		_tidyData._roleData._baseAttr.partner[i] = _attrs;

	end
	--获取所有角色的详细属性
	_tidyData._roleData._detailAttr = {
		["leader"] = {};
		["partner"] = {};
	};
	local _attrKeys = self:GetDetailAttrKeys();
	for i = 1, #_attrKeys do
		local _value = SDataUtil.InvConvert(_heroData:GetFinalAttr(_attrKeys[i])) or 0;
		table.insert(_tidyData._roleData._detailAttr.leader, {
			["key"] = _attrKeys[i],
			["value"] = math.floor(_value);
		})
	end
	for i = 1, #_tidyData._roleData._sortPartner do
		local _attrs = {};
		for j = 1, #_attrKeys do
			local PartnerData = _tidyData._roleData._sortPartner[i]				
			local _value = SDataUtil.InvConvert(_tidyData._roleData._sortPartner[i].attrs[_attrKeys[j]] or 0);
			if nil == self.data._targetTag or self.data._targetTag ~= 0 then	
				local PartnerActorData =_userData:FindFellowActorDataByData(PartnerData)	
				if nil ~= PartnerActorData then
					_value = SDataUtil.InvConvert(PartnerActorData:GetFinalAttr(_attrKeys[j]) or 0);
				end	
			end			
			table.insert(_attrs, {
				["key"] = _attrKeys[j],
				["value"] = math.floor(_value);
			})
		end
		_tidyData._roleData._detailAttr.partner[i] = _attrs;

		
		local partnerData = _tidyData._roleData._sortPartner[i]
		local tbFinalattrs = partnerData.attrs
		if self.data._targetTag and self.data._targetTag ~= 0 then	
			local PartnerActorData =_userData:FindFellowActorDataByData(partnerData)
			for k,v in pairs(partnerData.attrs) do
				if nil ~= PartnerActorData then
					local _value = SDataUtil.InvConvert(PartnerActorData:GetFinalAttr(k) or 0);
					tbFinalattrs[k] = _value
				end
			end			
		end			
		_tidyData._roleData._Attr.partner[i] = tbFinalattrs
	end
end

--详细属性的key
function UIRoleMessageCtr:GetDetailAttrKeys()
	local _detailAttrKeys = {};
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Life);	--生命，血量
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Sp);	--蓝量
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Attack);	--攻击
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Defense);	--物防
	table.insert(_detailAttrKeys, Enum.HeroAttrType.MagicAttack);	--魔攻
	table.insert(_detailAttrKeys, Enum.HeroAttrType.MagicDefense);	--魔抗
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Hit);	--命中
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Dodge);	--闪避
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Crit);	--暴击
	table.insert(_detailAttrKeys, Enum.HeroAttrType.Ten);	--忽视物防
	table.insert(_detailAttrKeys, Enum.HeroAttrType.AttackSpeed);	--攻速
	table.insert(_detailAttrKeys, Enum.HeroAttrType.CastAcceleration);	--忽视魔防
	return _detailAttrKeys;
end
--基础属性的key
function UIRoleMessageCtr:GetBaseAttrKeys()
	local _baseAttrKeys = {};
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Life);	--生命，血量
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Sp);	--蓝量
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Attack);	--攻击
	table.insert(_baseAttrKeys, Enum.HeroAttrType.MagicAttack);	--攻击
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Defense);	--物防
	table.insert(_baseAttrKeys, Enum.HeroAttrType.MagicDefense);	--魔抗
	table.insert(_baseAttrKeys, Enum.HeroAttrType.AttackSpeed);	--攻速
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Hit);	--命中
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Dodge);	--闪避
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Crit);	--暴击
	table.insert(_baseAttrKeys, Enum.HeroAttrType.Ten);	--韧性
	return _baseAttrKeys;
end
--获取主角的数据（角色界面的头像相关）
function UIRoleMessageCtr:GetLeaderHeadData()
	local _outPut = {};
	local _data = self.data._tidyData;
	_outPut._id = 1;
	_outPut._isLeader = true;	--是否是主角，这个值决定是否显示主角角标
	_outPut._isBattle = false;	--是否上阵，这个不用管的，不管是true还是false都显示不出来，会被主角的图标掩盖
	_outPut._get = true;		--是否招募到了，这个值决定显示灰色还是亮色
	_outPut._configId = _data._playerData._id;
	_outPut._leaderJobIcon = _data._playerData._leaderJobIcon;	--主角的jonicon
	_outPut._jobCfgId = _data._playerData._jobId;
	_outPut._jobData = ManagerContainer.CfgMgr:GetJobDataById(_data._playerData._jobId)
	_outPut._jobICon = ManagerContainer.CfgMgr:GetJobDataById(_data._playerData._jobId).JobIcon;	--主角的jobIcon
	_outPut._headIcon = _data._playerData._headIcon;	--头像
	_outPut._baseLevel = _data._playerData._baseLevel;	--base等级
	_outPut._strengthLevel = 100;	--和自己没有突破，所以直接是最高的突破等级
	_outPut._name = _data._playerData._nickName;	--玩家昵称
	_outPut._power = _data._playerData._powers[1] or 0;	--战力
	_outPut._slots = _data._playerData._slots	--主角装备信息
	_outPut._skills = _data._playerData._skills;	--主角的技能数据
	_outPut._roleId = _data._playerData._roleId;
	_outPut._viewData = _data._playerData._viewData;
	_outPut._baseAttr = _data._roleData._baseAttr.leader;	--主角的基础属性
	_outPut._detailAttr = _data._roleData._detailAttr.leader;	--主角的详细属性
	_outPut._headFrameId = _data._playerData._headFrameId;
	_outPut._extGoesShowData = _data._playerData._extGoesShowData;

	if nil ~= _data._playerData.petFightPower[1] then--战力		
		if type(_data._playerData.petFightPower[1]) ~= "number" then
			_outPut.petFightPower = SInt.InvConvert(_data._playerData.petFightPower[1])
		else
			_outPut.petFightPower = _data._playerData.petFightPower[1]
		end
	else
		_outPut.petFightPower = 0
	end

--[[
	local twoAttrAddDic = {};
	local dic = ManagerContainer.LuaActorDataMgr:GetRoleIncreaseSecondAttrVal(
			_outPut._detailAttr[Enum.HeroAttrType.STR],
			_outPut._detailAttr[Enum.HeroAttrType.AGI],
			_outPut._detailAttr[Enum.HeroAttrType.INT],
			_outPut._detailAttr[Enum.HeroAttrType.VIT],
			_outPut._detailAttr[Enum.HeroAttrType.DEX],
			_outPut._detailAttr[Enum.HeroAttrType.LUK]
	)
	local iter = dic:GetEnumerator()

	while iter:MoveNext() do
		twoAttrAddDic[iter.Current.Key] = math.floor(iter.Current.Value)
	end
]]--
	_outPut.addList = {}
	for k,v in pairs(_data._roleData._Attr.leader) do
		if k >= Enum.HeroAttrType.Life and k <= Enum.HeroAttrType.CastAcceleration then
			--baseList[#baseList + 1] = {k, v, twoAttrAddDic[k] or 0}
		else
			if #_data._roleData._Attr.leader > 0 then
				if k >= Enum.HeroAttrType.RealHurt then
					-- if v > 0 then
					if SDataUtil.IsGreater(v,0) then
						_outPut.addList[#_outPut.addList + 1] = {k, v, 0}
					end
				end
			end
		end
	end

	return _outPut;
end
--获取队友的数据
function UIRoleMessageCtr:GetPartnerData(_id)
	local _sortIndex = _id - 1;
	local _outPut = {};
	local _data = self.data._tidyData._roleData._sortPartner[_sortIndex];
	local _partnerData = ManagerContainer.CfgMgr:GetPartnerDataById(_data.configId);
	_outPut.sortIndex = _sortIndex
	_outPut._jobData = ManagerContainer.CfgMgr:GetPartnerDataById(_data.configId);
	_outPut._jobCfgId = _data.configId;
	_outPut._id = _data.id;
	_outPut._isLeader = false;	--不是主角
	_outPut._isBattle = _data.isBattle;	--是否上阵
	_outPut._get = _data.owned;	--是否招募
	_outPut._configId = _data.configId;
	_outPut._jobICon = _partnerData.JobIcon;	--jobIcon
	_outPut._headIcon = _partnerData.HeadId;	--头像图片
	_outPut._baseLevel = _data.baseLevel;	--base等级
	_outPut._strengthLevel = _data.strengthLevel;	--突破等级
	_outPut._name = I18N.SetLanguageValue(_partnerData.Name);	--名字
	_outPut._power = self.data._tidyData._playerData._powers[_id] or 0;	--战力
	_outPut._slots = _data.slot.slot_list;
	_outPut._headFrameId = -1;
	_outPut._extGoesShowData = _data.extGoesShowData

	--LogError(tostring(self.data._tidyData._playerData.petFightPower[_id]))
	if nil ~= self.data._tidyData._playerData.petFightPower[_id] then--战力		
		if type(self.data._tidyData._playerData.petFightPower[_id]) ~= "number" then
			_outPut.petFightPower = SInt.InvConvert(self.data._tidyData._playerData.petFightPower[_id])
		else
			_outPut.petFightPower = self.data._tidyData._playerData.petFightPower[_id]
		end
	else
		_outPut.petFightPower = 0
	end

	local _indexId = _id - 1;	--传过来的_id是加了主角的顺序，主角是1队友是从2开始的，但是下边的这些数据没有存储主角的数据，所以1的位置就开始存放队友的数据了
	_outPut._skills = self.data._tidyData._roleData._partnerSkill[_indexId]	--队友的技能
	_outPut._baseAttr = self.data._tidyData._roleData._baseAttr.partner[_indexId];	--队友的基础属性
	_outPut._detailAttr = self.data._tidyData._roleData._detailAttr.partner[_indexId];	--队友的详细属性
--[[
	local twoAttrAddDic = {};
	local dic = ManagerContainer.LuaActorDataMgr:GetRoleIncreaseSecondAttrVal(
			_outPut._detailAttr[Enum.HeroAttrType.STR],
			_outPut._detailAttr[Enum.HeroAttrType.AGI],
			_outPut._detailAttr[Enum.HeroAttrType.INT],
			_outPut._detailAttr[Enum.HeroAttrType.VIT],
			_outPut._detailAttr[Enum.HeroAttrType.DEX],
			_outPut._detailAttr[Enum.HeroAttrType.LUK]
	)
	local iter = dic:GetEnumerator()

	while iter:MoveNext() do
		twoAttrAddDic[iter.Current.Key] = math.floor(iter.Current.Value)
	end
]]--
	_outPut.addList = {}
	local _partnerAttrs = self.data._tidyData._roleData._Attr.partner[_indexId]
	for k,v in pairs(_partnerAttrs) do
		if k >= Enum.HeroAttrType.Life and k <= Enum.HeroAttrType.CastAcceleration then
			--baseList[#baseList + 1] = {k, v, twoAttrAddDic[k] or 0}
		else
			if #_partnerAttrs > 0 then
				if k >= Enum.HeroAttrType.RealHurt then
					-- if v > 0 then
					if SDataUtil.IsGreater(v,0) then
						_outPut.addList[#_outPut.addList + 1] = {k, v, 0}
					end
				end
			end
		end
	end

	return _outPut;
end
--判断是否招募
function UIRoleMessageCtr:JudgeGet(_id)
	for k, v in pairs(self.data._tidyData_roleData._activationList) do
		if _id == v.id then
			return true;
		end
	end
	return false;
end
--判断是否是招募的队友
local function IsActivationPartner(partnerId, activationList)
	for _,v in pairs(activationList) do
		if v.configId == partnerId then
			return v
		end
	end
	return nil
end
--获取所有的招募到的队友
function UIRoleMessageCtr:RefreshPartnersLists(_partnerDatas)
	activationList = {}
	battledPartnerCount = 0
	local activationPartners = _partnerDatas
	local partnerDatas = ManagerContainer.CfgMgr:GetAllPartnerDatas()
	for k,v in pairs(partnerDatas) do
		local data = IsActivationPartner(k, activationPartners)

		if data ~= nil and data.owned and data.isBattle then
			activationList[#activationList + 1] = {id = v.ParterId, NatureId = v.NatureId, baseLevel = data.base_level, strenthLevel = data.strength_level}
			battledPartnerCount = battledPartnerCount + 1
		end
	end
	CommonUtil.ArraySortSelections(activationList, Enum.TableSortRule.Down, "status", "baseLevel")

	return activationList
end

--设置当前的队友的uid
function UIRoleMessageCtr:SetCurPartnerUid(_uid)
	self._uid = _uid;
end
--获取当前队友的uid
function UIRoleMessageCtr:GetCurPartnerUid()
	return self._uid and self._uid or 0;
end
--判断是否是主角
function UIRoleMessageCtr:JudgeIsLeader()
	return self._uid == 1;
end

---排序start
function UIRoleMessageCtr:GetSortedPartnerDatas(_data)
	if sortedPartnerDatas == nil then
		self:GetSlotSortPartnerDatas(_data)
	end
	return sortedPartnerDatas
end
function UIRoleMessageCtr:GetSlotSortPartnerDatas(_data)
	local partnerDatas = _data
	sortedPartnerDatas = {}
	for _,v in pairs(partnerDatas) do
		sortedPartnerDatas[#sortedPartnerDatas + 1] = v
	end
	table.sort(sortedPartnerDatas, function (a, b)
		if a.owned and b.owned then
			return a.post < b.post
		else
			if a.owned and not b.owned then
				return true
			elseif not a.owned and b.owned then
				return false
			else
				return a.post < b.post
			end
		end
	end)
end
---排序end
---逻辑处理end

function UIRoleMessageCtr:GetPetFightPowerByHeroId(id)
	if isOther then
		return self.createActorSystem:GetHeroPetFightPowerByHeroId(id)
	else
		return ManagerContainer.DataMgr.UserData:GetHeroPetFightPowerByHeroId(id)
	end
end

function UIRoleMessageCtr:GetCardBlessData(id)
	if isOther then
		local data1, slot = self.createActorSystem:RefreshEquipedCardSuitData(id)
		if not data1 then
			return
		end
		local data = {curLv = data1[1], count = data1[2], totalCount = data1[3], state = data1[4], slot = slot}
		return data
	else
		local curLv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(id)
		local count,totalCount = ManagerContainer.DataMgr.CardData:GetCardSuitCountById(id)
		local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(id)
		local slot = ManagerContainer.DataMgr.UserData:GetSlotInfoById(id)
		local data = {curLv = curLv, count = count, totalCount = totalCount, state = state, slot = slot}
		return data
	end
end


function UIRoleMessageCtr:GetSkillEquipData(id)
	if isOther then
		return self.createActorSystem:GetHeroSkillEquipDataByHeroId(id)
	else
		local heroData = CommonUtil.GetHeroLogicDataByUid(id)
		local skillEquipSlot = heroData.skillEquipSlot
		local skillEquipData = skillEquipSlot.slotList[1]
		return skillEquipData
	end
end

return UIRoleMessageCtr

