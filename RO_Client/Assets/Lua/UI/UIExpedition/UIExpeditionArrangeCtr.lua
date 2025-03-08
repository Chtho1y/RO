local UIExpeditionArrangeCtr = class("UIExpeditionArrangeCtr", require("UICtrBase"))

function UIExpeditionArrangeCtr:Init(view)
	self.view = view
end

function UIExpeditionArrangeCtr:SetData(data)
	self:InitTeamData()
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIExpeditionArrangeCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIExpeditionArrangeCtr:GetData()
	return self.data
end

function UIExpeditionArrangeCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIExpeditionArrangeCtr:InitTeamData()
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

	_allPartners= {}
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

function UIExpeditionArrangeCtr:SortInterestLit(allPartners)
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

function UIExpeditionArrangeCtr:GetTeams()
    return self.teamMembers
end

function UIExpeditionArrangeCtr:GetHeroData(uid)
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

function UIExpeditionArrangeCtr:GetHeroIdx(uid)
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

return UIExpeditionArrangeCtr

