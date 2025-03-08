local UIDojo2DCtr = class("UIDojo2DCtr", require("UICtrBase"))

function UIDojo2DCtr:Init(view)
	self.view = view
end

function UIDojo2DCtr:SetData(data)
	self:InitTeamData()
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojo2DCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojo2DCtr:GetData()
	return self.data
end

function UIDojo2DCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIDojo2DCtr:InitTeamData()
	local mainRoleData = ManagerContainer.DataMgr.UserData:GetMainRoleData()
	self.teamMembers = {}
    self.teamMembers[#self.teamMembers + 1] =
    {
        uid = mainRoleData.id,
        cfgId = ManagerContainer.DataMgr.UserData:GetUserRoleId(),
        mainRole = true,
        owned = true,
        logicData = mainRoleData,
		cfgData = ManagerContainer.CfgMgr:GetRoleDataById(ManagerContainer.DataMgr.UserData:GetUserRoleId())
    }

	local _allPartners= {}
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
	for _,v in pairs(partnerDatas) do
		if v ~= nil then
			_allPartners[#_allPartners + 1] = v
		end
	end
	
	if _allPartners ~= nil then
		self:SortInterestLit(_allPartners)
		for i=1, #_allPartners do
			local partner = _allPartners[i] 
			self.teamMembers[#self.teamMembers + 1] = {
				uid = partner.id,
				cfgId = partner.configId,
                mainRole = false,
                owned = partner.owned,
				logicData = ManagerContainer.DataMgr.UserData:GetHeroData(partner.id),
				cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(partner.configId)
			}
		end
    end
end


function UIDojo2DCtr:SortInterestLit(allPartners)
    if allPartners == nil or #allPartners < 2 then
        return
    end

    table.sort(
        allPartners,
        function(a, b)
            if a.owned and b.owned == false then
                return true
            end

            if a.owned == false and  b.owned then
                return false
            end

            if a.owned and b.owned then
                return a.jobType < b.jobType
            end

            return a.jobType < b.jobType
        end
    )
end

function UIDojo2DCtr:GetTeams()
    return self.teamMembers
end

function UIDojo2DCtr:SendMatch()
	ManagerContainer.DataMgr.ArenaData:SendMatchReq(ManagerContainer.DataMgr.ArenaData:GetTeamActorIds())
end

function UIDojo2DCtr:GetHeroData(uid)
	if self.teamMembers == nil  then
		return nil
	end

	for i=1, #self.teamMembers do
		if self.teamMembers[i].uid == uid then
			return self.teamMembers[i]
		end
	end
	return nil
end

function UIDojo2DCtr:GetHeroIdx(uid)
    if self.teamMembers == nil  then
		return -1
	end

	for i=1, #self.teamMembers do
		if self.teamMembers[i].uid == uid then
			return i
		end
	end
	return -1
end

return UIDojo2DCtr

