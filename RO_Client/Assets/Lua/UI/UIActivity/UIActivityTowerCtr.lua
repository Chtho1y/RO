local UIActivityTowerCtr = class("UIActivityTowerCtr", require("UICtrBase"))

local PetDataCountPerPage = 10
function UIActivityTowerCtr:Init(view)
	self.view = view
end

function UIActivityTowerCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data

	self.curPetPage = 0
	self.minIdx = 0
	self.maxIdx = 9
end

function UIActivityTowerCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIActivityTowerCtr:GetData()
	return self.data
end

function UIActivityTowerCtr:OnDispose()
	self.data = nil
	self.view = nil

	self.shopType = nil
	self.shopSubType = nil
	self.type = nil
	self.idx = nil
end

function UIActivityTowerCtr:InitData()
	self.type = self.data
	self.idx = ManagerContainer.DataMgr.RankActivitiesMgr:GetCurRankActivityIdx(self.type)
	if not self.type or not self.idx then return end

	if self.type == Enum.RankActivitiesType.ClimbingTower then
		self.shopType = Enum.RuneShopType.RushTower
	elseif self.type == Enum.RankActivitiesType.Dojo then
		self.shopType = Enum.RuneShopType.RushArena
	elseif self.type == Enum.RankActivitiesType.MapProgress then
		self.shopType = Enum.RuneShopType.RushMap
	elseif self.type == Enum.RankActivitiesType.Pet then
		self.shopType = Enum.RuneShopType.RushPet
	elseif self.type == Enum.RankActivitiesType.Skill then
		self.shopType = Enum.RuneShopType.RushSkill
	end

	self:RefreshCurShopData(true)
end

function UIActivityTowerCtr:GetType()
	return self.type
end

function UIActivityTowerCtr:GetIdx()
	return self.idx
end

function UIActivityTowerCtr:RefreshCurShopData(forceRefresh)
	ManagerContainer.DataMgr.RuneShopDataMgr:RefreshShopData(self.shopType, self.shopSubType, forceRefresh)
	self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
	if self.curShopData then
		if not self.curShopData:IsValidShow() then
			self.curShopData:RefreshShowGoodsDatas()
		end
		return true
	end
	return false
end

function UIActivityTowerCtr:GetShopType()
	return self.shopType
end

function UIActivityTowerCtr:GetShowGoodsDatas()
    if not self.curShopData then
        self.curShopData = ManagerContainer.DataMgr.RuneShopDataMgr:GetShopData(self.shopType, self.shopSubType)
        if self.curShopData then
            if not self.curShopData:IsValidShow() then
                self.curShopData:RefreshShowGoodsDatas()
            end
        end
    end
	local datas = self.curShopData and self.curShopData:GetShowGoodsDatas() or nil
	if not datas then
		return
	else
		self.curShopData:RefreshShowGoodsDatas()
	end
	--table.sort(datas, ShowDataSort)
	return datas
end

function UIActivityTowerCtr:SendPay(goodsId)
	local errorCode = ManagerContainer.PayMgr:RuneShopPay(self.shopType, self.shopSubType, goodsId)
	local errorCodeKey = ManagerContainer.PayMgr:GetInitPayErrorCodeLangKey(errorCode)
	return errorCodeKey
end

function UIActivityTowerCtr:SendRewardReq(rewardType)
	ManagerContainer.DataMgr.RankActivitiesMgr:SendRewardReq(self.type, rewardType)
end

function UIActivityTowerCtr:SetCurPetPage(idx)
	local maxChange = idx > self.maxIdx
	if maxChange then
		self.maxIdx = idx
		self.minIdx = self.maxIdx - 5
	end
	local minChange = false
	if not maxChange then
		minChange = idx < self.minIdx
		if minChange then
			self.minIdx = idx
			self.maxIdx = self.minIdx + 5
		end
	end

	local newPage = math.floor(idx/PetDataCountPerPage)
	if newPage == self.curPetPage then
		return
	end
	if minChange or maxChange then
		-- LogHRWarning("query pet data  +++++++++++++++++++++++++++++++++++++++++++++++++++++++ "..newPage)
		self.curPetPage = newPage
		ManagerContainer.DataMgr.RankActivitiesMgr:QueryRankActivityData(self.type, newPage)
	end
end

return UIActivityTowerCtr