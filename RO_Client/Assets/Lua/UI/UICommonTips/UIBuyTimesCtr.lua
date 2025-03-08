local UIBuyTimesCtr = class("UIBuyTimesCtr", require("UICtrBase"))

function UIBuyTimesCtr:Init(view)
	self.view = view
end

function UIBuyTimesCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIBuyTimesCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end


function UIBuyTimesCtr:GetCostNum()
	if self.data then
		return self.data[1] or 0
	end
	return 0
end

function UIBuyTimesCtr:GetCostNumByGuildDemon(BuyCount)
	local cost = 0
	if self.data and self.data[1] and #self.data[1] > 0 then
		local costs  = self.data[1]
		local maxBuyCount = self:GetChallengeTimesFromGuildDemon()
		local remainCount = self:GetRemainCount()
		local specialCount = maxBuyCount - remainCount
		if specialCount + 1  <= #costs then
			local count = 0
			for i = specialCount + 1, specialCount + BuyCount do
				if costs[i] then
					cost = cost + costs[i][2]
					count = count + 1
				end
			end
			if BuyCount + specialCount > #costs then
				cost = cost + (BuyCount - count) * costs[#costs][2]
			end
		else
			cost = BuyCount * costs[#costs][2]
		end
	end
	return cost 
end

function UIBuyTimesCtr:GetChallengeTimesFromGuildDemon()
	return  self.data and self.data[5] or 0
end

function UIBuyTimesCtr:IsGuildDemon()
	return  self.data and self.data[5]
end

function UIBuyTimesCtr:GetRemainCount()
	if self.data then
		return self.data[2]
	end
	return nil
end

--是否卖完
function UIBuyTimesCtr:IsOver()
	local remainCount = self:GetRemainCount()
	if remainCount < 1 then
		return true
	end	
	return false
end
--是否可以购买
function UIBuyTimesCtr:IsCanBuy(count)
	if self.data then
		local cb = self.data[3]		
		if cb then
			if not self:IsGuildDemon() then
				return cb(self:GetCostNum(),count)		
			else
				return cb(self:GetCostNumByGuildDemon(count))
			end	
		end
	end
	return false
end

function UIBuyTimesCtr:IsCanBuyByGuildDemon(cost)
	if self.data then
		local cb = self.data[3]		
		if cb then
			return cb(cost)			
		end
	end
	return false
end

function UIBuyTimesCtr:HandleCallback(count)
	if self.data then
		local cb = self.data[4]		
		if cb then
			cb(count)			
		end
	end
end

function UIBuyTimesCtr:GetData()
	return self.data
end

function UIBuyTimesCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIBuyTimesCtr