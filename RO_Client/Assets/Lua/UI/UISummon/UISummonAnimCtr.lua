local UISummonAnimCtr = class("UISummonAnimCtr", require("UICtrBase"))

function UISummonAnimCtr:Init(view)
	self.view = view
end

function UISummonAnimCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISummonAnimCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISummonAnimCtr:GetData()
	return self.data
end

function UISummonAnimCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UISummonAnimCtr:HasNeedShowItem()
	local summonData = ManagerContainer.DataMgr.SummonDataMgr:GetSummonData()
	if summonData then
		local summonCfgData = ManagerContainer.CfgMgr:GetSummonCfgById(summonData.summonType)
		if summonCfgData and summonCfgData.ShowItemType and #summonCfgData.ShowItemType > 0 then
			if summonData then
				if summonData.rewards then
					for i = 1, #summonData.rewards do
						local reward = summonData.rewards[i]
						if reward then
							local itemCfgData = ManagerContainer.CfgMgr:GetItemById(reward.cfgId)
							if CommonUtil.EleInTable(itemCfgData.ResType, summonCfgData.ShowItemType) then
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

return UISummonAnimCtr

