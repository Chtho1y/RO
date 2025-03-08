local UISummonShowCtr = class("UISummonShowCtr", require("UICtrBase"))

function UISummonShowCtr:Init(view)
	self.view = view
end

function UISummonShowCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UISummonShowCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISummonShowCtr:GetData()
	return self.data
end

function UISummonShowCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.curShowIdx = nil
	self.showDatas = nil
end

function UISummonShowCtr:InitData()
	self.curShowIdx = 1
	local summonData = ManagerContainer.DataMgr.SummonDataMgr:GetSummonData()
	local showDatas = {}
	local summonCfgData = ManagerContainer.CfgMgr:GetSummonCfgById(summonData.summonType)
	if summonCfgData and summonCfgData.ShowItemType and #summonCfgData.ShowItemType > 0 then
		if summonData then
			if summonData.rewards then
				for i = 1, #summonData.rewards do
					local reward = summonData.rewards[i]
					if reward then
						local itemCfgData = ManagerContainer.CfgMgr:GetItemById(reward.cfgId)
						if CommonUtil.EleInTable(itemCfgData.ResType, summonCfgData.ShowItemType) then
							showDatas[#showDatas + 1] = reward
						end
					end
				end
			end
		end
	end
	if  #showDatas <= 0 then
		self.showDatas = {{cfgId = 1, num = 0}}
	else
		self.showDatas = showDatas
	end
end

function UISummonShowCtr:GetShowData()
	return self.showDatas[self.curShowIdx]
end

function UISummonShowCtr:ChangeNextData()
	self.curShowIdx = self.curShowIdx + 1
end

function UISummonShowCtr:CheckMustShow()
	for i = self.curShowIdx + 1, #self.showDatas do
		local showData = self.showDatas[i]
		if showData then
			local itemCfgData = ManagerContainer.CfgMgr:GetItemById(showData.cfgId)
			if itemCfgData and itemCfgData.Quality >= 4 then
				self.curShowIdx = i
				return true
			end
		end
	end
	return false
end

function UISummonShowCtr:GetCurMustShowComplete()
	local showData = self:GetShowData()
	if showData then
		local itemCfgData = ManagerContainer.CfgMgr:GetItemById(showData.cfgId)
		if itemCfgData and itemCfgData.Quality >= 4 then
			return true
		end
	end
	return false
end


return UISummonShowCtr

