local UIGuildDemonRewardCtr = class("UIGuildDemonRewardCtr", require("UICtrBase"))

function UIGuildDemonRewardCtr:Init(view)
	self.view = view
end

function UIGuildDemonRewardCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIGuildDemonRewardCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGuildDemonRewardCtr:GetData()
	return self.data
end

function UIGuildDemonRewardCtr:GetShowId()
	return self.data and self.data.showId or 0
end

function UIGuildDemonRewardCtr:GetShowData()
	if not self.data then
		return nil
	end
	local demonData = ManagerContainer.CfgMgr:GetGuildDemonCfgCfgById(self.data.BossId)
	if not demonData then
		return {}
	end
	local awards = {}
	for i = #demonData.DamageReward, 1, -1 do
		local reviewAwards = {}
		local award = demonData.ReviewAwards[i]
		if type(award) == "number" then
			table.insert(reviewAwards,award)
		else
			if award and #award > 0 then
				for i = 1, #award do
					table.insert(reviewAwards,award[i])
				end
			end
		end
		table.insert(awards,{rewardItemId = demonData.DamageReward[i][1],reviewAwards = reviewAwards})
	end
	return awards
end

function UIGuildDemonRewardCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIGuildDemonRewardCtr

