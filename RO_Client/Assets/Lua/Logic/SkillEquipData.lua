local SkillEquipData = class("SkillEquipData", require("DataBase"))

function SkillEquipData:ctor()
    self.data = {}
end

function SkillEquipData:InitData(skillEquipList)

    -- ---假数据测试
    -- skillEquipList = {}
    -- skillEquipList.skill_equip_list = {}
    -- for i = 1, 10 do
    --     local data = {id = i, config_id = 14199 + i, star_level = 0}
    --     skillEquipList.skill_equip_list[#skillEquipList.skill_equip_list + 1] = data
    -- end
    -- ---
    -- LogHRWarning(Inspect(skillEquipList))
    self.data.skillEquips = {}
    self.data.skillEquipMaps = {}

    if not skillEquipList or not skillEquipList.skill_equip_list then return end

    for i = 1, #skillEquipList.skill_equip_list do
        local data = ProtocalDataNormal.ParseSkillEquipData(skillEquipList.skill_equip_list[i]) 
        self.data.skillEquips[#self.data.skillEquips + 1] = data
        self.data.skillEquipMaps[data.id] = data
    end
end

function SkillEquipData:GetSkillEquips()
    return self.data.skillEquips
end 

function SkillEquipData:GetSkillEquipDataByUid(id)
    return self.data.skillEquipMaps[id]
end

function SkillEquipData:GetSkillEquipDatasFilterJobData(jobData)
    local list = {}
    for i = 1, #self.data.skillEquips do
        local data = self.data.skillEquips[i]
        if data.jobType == jobData.JobType and data.jobBranch == jobData.JobBranch and data.jobStage == jobData.JobStage then
            list[#list + 1] = data
        end
    end
    return list
end

function SkillEquipData:SkillEquipDataCanLvUp(data)
    if not data or data.id == 0 then return false end

    local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(data.cfgId)
    if not cfgData then
        return false
    end

    local cost = cfgData.Condition[data.starLv + 1]
    if not cost then return false end

    local costId = cost[1][1]
    local list = {}
    for i = 1, #self.data.skillEquips do
        local data = self.data.skillEquips[i]
        if data.cfgId == costId then
            list[#list + 1] = data
        end
    end

    if #list == 0 then
        return false
    end
    if cost[2] then
        local ownRes = CommonUtil.GetOwnResCountByItemId(cost[2][1])
        if ownRes < cost[2][2] then
            return false
        end
    end
    return true
end

function SkillEquipData:SkillEquipSlotCanLvUp(id)
    local heroData = CommonUtil.GetHeroLogicDataByUid(id)
    if not heroData then return false end

    local skillEquipSlot = heroData.skillEquipSlot
    local slotList = skillEquipSlot.slotList
    if not slotList then return false end

    local curSkillEquipData = slotList[1]
    if not curSkillEquipData then return false end

    local cost = ManagerContainer.CfgMgr:GetArtifactExpCfgCostByLv(curSkillEquipData.slotLv)
    local lack = false
	if cost then
		for i = 1, #cost do
			local cst = cost[i]
			if cst then
				local cfgData = ManagerContainer.CfgMgr:GetItemById(cst[1])
				if cfgData then
					local ownNum = CommonUtil.GetOwnResCountByItemId(cst[1])
					if ownNum < cst[2] then
                        return false
					end
				end
			end
		end
	end
    return true
end 

function SkillEquipData:RefreshSkillEquipData(data)
    -- LogHRWarning(Inspect(data))
    local addEquips = {}
    for i = 1, #data.skill_equip_change_list do
        local id = data.skill_equip_change_list[i].skill_equip_data.id
        local data1 = self.data.skillEquipMaps[id]
        if not data1 then
            if data.skill_equip_change_list[i].add then
                data1 = ProtocalDataNormal.ParseSkillEquipData(data.skill_equip_change_list[i].skill_equip_data)
                self.data.skillEquipMaps[data1.id] = data1
                self.data.skillEquips[#self.data.skillEquips + 1] = data1
                addEquips[#addEquips + 1] = {data1.cfgId, 1, data1.starLv} 
            end
        else
            if not data.skill_equip_change_list[i].add then
                self.data.skillEquipMaps[id] = nil
                local result, idx = CommonUtil.EleInTable(data1, self.data.skillEquips)
                if idx then
                    table.remove(self.data.skillEquips, idx)
                end
            else
                data1.starLv = data.skill_equip_change_list[i].skill_equip_data.star_level
            end
        end
    end
    if next(addEquips) ~= nil then
        if not data.ignore then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SKILL_EQUIP_ADD_LIST, addEquips)
        end
    end
end

function SkillEquipData:SendSkillEquipStarUpReq(heroId, skillEquipId, costIds)
    self.heroId = heroId
    self.skillEquipId = skillEquipId
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_LEVEL_UP_REQ, {hero_id = heroId, skill_equip_id = skillEquipId, select_cost = costIds})
end

function SkillEquipData:SCSkillEquipLvUpAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_LV_UP_REFRESH)
    ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleSkillEquipRPById(self.heroId)
end

function SkillEquipData:SendSkillEquipUpReq(heroId, slotIdx, skillEquipId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_UP_REQ, {hero_id = heroId, slot_index = slotIdx - 1, skill_equip_id = skillEquipId})
end

function SkillEquipData:SCSkillEquipUpAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_SLOT_REFRESH)
end

function SkillEquipData:SendSkillEquipDownReq(heroId, slotIdx)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_DOWN_REQ, {hero_id = heroId, slot_index = slotIdx - 1})
end

function SkillEquipData:SCSkillEquipDownAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_SLOT_REFRESH)   
end

function SkillEquipData:SendSkillEquipSlotLevelUpReq(heroId, slotIdx)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_SLOT_LEVEL_UP_REQ, {hero_id = heroId, slot_index = slotIdx - 1})
end

function SkillEquipData:SCSkillEquipSlotLvUpAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_SLOT_LVUP_REFRESH)
end

function SkillEquipData:SCSkillEquipSlotNtf(slotData)
    -- LogHRWarning(Inspect(slotData))
    local heroId = slotData.hero_id
    local heroData = CommonUtil.GetHeroLogicDataByUid(heroId)
    if not heroData then return end

    local skillEquipSlot = heroData.skillEquipSlot
    local slotList = skillEquipSlot.slotList
    local isUpOrDown = false
    local lvUp = false
    for i = 1, #slotData.slot.slot_list do
        local data = slotList[i]
        if not data then
            isUpOrDown = true
            data = {}
            slotList[i] = data
        end
        local data1 = slotData.slot.slot_list[i]
        if data.id ~= data1.skill_equip_id then
            isUpOrDown = true
        end
        data.id = data1.skill_equip_id
        data.cfgId = data1.skill_equip_config_id
        if data1.slot_level > (data and data.slotLv or 0) or data1.skill_equip_star_level >  (data and data.starLv or 0) then
            lvUp = true
        end
        data.starLv = data1.skill_equip_star_level
        data.slotLv = data1.slot_level
        data.slotAttrs = {}
        for _,v1 in pairs(data1.slot_attrs) do
            data.slotAttrs[v1.key] = v1.value
        end
        local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(data.cfgId)
        data.maxStarLv = cfgData and cfgData.ArtifactMaxLevel or 0
        data.quality = cfgData and cfgData.Quality or 0
        data.jobType = cfgData and cfgData.JobType or 0
        data.jobBranch = cfgData and cfgData.JobBranch or 0
        data.jobStage = cfgData and cfgData.JobStage or 0
    end

    CommonUtil.UpdateHeroExtGoShowData(heroData)
    if isUpOrDown or lvUp then
        ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleSkillEquipRP()
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_RP_REFRESH)
    end
     --刷新伙伴角色形象
     ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.PARTNER_EQUIP_REFRESH,heroId)
end

function SkillEquipData:SendSkillEquipDecomposeReq(ids)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_DECOMPOSE_REQ, {skill_equip_id = ids})
end

function SkillEquipData:SCSkillEquipDecomposeAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    CommonUtil.ACKShowRewardList(data.item_list)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_DECOMPOSE_REFRESH)
    ManagerContainer.RedPointMgr.HeroRPCtr:RefreshRoleSkillEquipRP()
end

function SkillEquipData:SCSkillEquipReforgeAck(data)
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    local data1 = self:GetSkillEquipDataByUid(data.new_id)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_REFORGE_SUCCESS, data1)
end

function SkillEquipData:SendSkillEquipReforgeReq(id)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_REMADE_REQ, {skill_equip_id = id})
end

function SkillEquipData:SCSkillEquipPoolAck(data)
    -- LogHRWarning(Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    if not self.randomPoolStruct then
        self.randomPoolStruct = {}
    end
    self.randomPoolStruct.curId = data.cur_id
    self.randomPoolStruct.poolIdList = data.pool_id_list
    self.randomPoolStruct.nextPool = data.next_pool
    self.randomPoolStruct.nextBegin = data.next_begin
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_POOL_REFRESH)
end

function SkillEquipData:SendSkillEquipPoolReq()
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_POOL_REQ, {})
end

function SkillEquipData:SCSkillEquipShiftAck(data)
    -- LogHRWarning("SCSkillEquipShiftAck   "..Inspect(data))
    if data.error ~= Enum.NetErrorCode.ERROR_OK then return end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.SKILL_EQUIP_SHIFT_REFRESH)
end

function SkillEquipData:SendSkillEquipShiftReq(srcId, dstId)
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_SKILL_EQUIP_SHIFT_REQ, {src_id = srcId, dst_id = dstId})
end

function SkillEquipData:GetCurRandomPool()
    return self.randomPoolStruct
end

function SkillEquipData:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_LEVEL_UP_ACK, self.SCSkillEquipLvUpAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_UP_ACK, self.SCSkillEquipUpAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_DOWN_ACK, self.SCSkillEquipDownAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_CHANGE_NTF, self.RefreshSkillEquipData, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_SLOT_LEVEL_UP_ACK, self.SCSkillEquipSlotLvUpAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_SLOT_DATA_NTF, self.SCSkillEquipSlotNtf, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_DECOMPOSE_ACK, self.SCSkillEquipDecomposeAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_REMADE_ACK, self.SCSkillEquipReforgeAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_POOL_ACK, self.SCSkillEquipPoolAck, self)

    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_SKILL_EQUIP_SHIFT_ACK, self.SCSkillEquipShiftAck, self)
end

function SkillEquipData:Clear()
    self.data = {}
    self.randomPoolStruct = nil
end

function SkillEquipData:Destroy()
    if self.Clear then
        self:Clear()
    end

    self:UnRegisterNetEvents()
end

function SkillEquipData:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_LEVEL_UP_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_UP_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_DOWN_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_CHANGE_NTF)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_SLOT_LEVEL_UP_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_SLOT_DATA_NTF)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_DECOMPOSE_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_REMADE_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_POOL_ACK)

    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_SKILL_EQUIP_SHIFT_ACK)
end

return SkillEquipData