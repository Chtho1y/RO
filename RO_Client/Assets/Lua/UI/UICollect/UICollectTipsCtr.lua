local UICollectTipsCtr = class("UICollectTipsCtr", require("UICtrBase"))
local UICollectCtr

local keepSakeExchangeNums
function UICollectTipsCtr:Init(view)
	self.view = view

	local val = GlobalConfig.Instance:GetConfigStrValue(275)
	if val ~= "" and val ~= nil then
		keepSakeExchangeNums = CommonUtil.DeserializeGlobalStrToTable(val)
	end
	self.isAuto = false
	self.canLvUp = false
end

function UICollectTipsCtr:SetData(data)
	UICollectCtr = ManagerContainer.LuaUIMgr:GetViewCtrById(Enum.UIPageName.UICollect)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICollectTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICollectTipsCtr:GetData()
	return self.data
end

function UICollectTipsCtr:GetType()
	return self.data.type
end

function UICollectTipsCtr:GetCfgId()
	return self.data.cfgId
end

function UICollectTipsCtr:GetOffsetCfgId(offset)
	if UICollectCtr then
		local newCfgId = self.data.cfgId
		if self.data.type == Enum.CollectType.Card then
			newCfgId = UICollectCtr:GetCardBookOffsetCfgId(self:GetCfgId(), offset)
		elseif self.data.type == Enum.CollectType.Pet then
			newCfgId = UICollectCtr:GetPetBookOffsetCfgId(self:GetCfgId(), offset)
		elseif self.data.type == Enum.CollectType.KeepSake then
			newCfgId = UICollectCtr:GetKeepSakeBookOffsetCfgId(self:GetCfgId(), offset)
		end
		self.data.cfgId = newCfgId
		if self.view then
			self.view:Init()
		end
	end
end

function UICollectTipsCtr:ResetKeepSakeMaterialCount()
	self.isAuto = false
	self.canLvUp = false

	self.ownedExchangeCount = CommonUtil.GetOwnResCountByItemId(Enum.ItemIds.KeepSakeExchange)

	self.keepSakeOriMats = {}
	self.needMats = {}
	local keepSakeId = self:GetCfgId()
	local lv = ManagerContainer.DataMgr.KeepSakeBookData:GetKeepSakeBookDataById(keepSakeId)
	local cfgData = ManagerContainer.CfgMgr:GetKeepSakeCfgDataById(keepSakeId)
	if not cfgData then
		return
	end

	local curLv = lv or 0
	local nextLv = curLv + 1
	local materials = cfgData["MaterialLevel"..nextLv]
	if materials then
		for i = 1, #materials do
			local material = materials[i]
			self.keepSakeOriMats[material[1]] = ManagerContainer.DataMgr.KeepSakeBookData:GetMaterialById(material[1])
			self.needMats[material[1]] = material[2]
		end
	end

	self.displayMats = clone(self.keepSakeOriMats)
end

local function GetKeepSakeExchange(quality)
	for _,v in pairs(keepSakeExchangeNums) do
		if tonumber(v[1]) == quality then
			return tonumber(v[2])
		end
	end
	return 0
end

function UICollectTipsCtr:AutoAddKeepSakeMaterialCount()
	self.isAuto = true
	self.canLvUp = true
	for k, v in pairs(self.keepSakeOriMats) do
		local cfgData = ManagerContainer.CfgMgr:GetItemById(k)
		local exchangeCount = tonumber(GetKeepSakeExchange(cfgData.Quality))
		if exchangeCount then
			local delta = self.needMats[k] - v
			if self.ownedExchangeCount < delta*exchangeCount then
				local count = math.floor(self.ownedExchangeCount/exchangeCount)
				self.displayMats[k] = self.displayMats[k] + count
				self.ownedExchangeCount = self.ownedExchangeCount - count * exchangeCount
			elseif delta > 0 then
				self.displayMats[k] = self.displayMats[k] + delta
				self.ownedExchangeCount = self.ownedExchangeCount - delta * exchangeCount
			end
		end
	end

	for k,v in pairs(self.displayMats) do
		if v < self.needMats[k] then
			self.canLvUp = false
			break
		end
	end

end

function UICollectTipsCtr:GetDisplayMats(id)
	return self.displayMats[id]
end

function UICollectTipsCtr:GetOwnedKeepSakeExchange()
	return self.ownedExchangeCount
end

function UICollectTipsCtr:SendKeepSakeActivity()
	local id = self:GetCfgId()
	if not self.isAuto and not ManagerContainer.DataMgr.KeepSakeBookData:CanKeepSakeLvUp(id) then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("ItemNotEnoughDefault")
		return
	end
	if self.isAuto and not self.canLvUp then
		ManagerContainer.LuaUIMgr:ErrorNoticeDisplay("MaterialsNotEnoughDefault")
		return
	end
	ManagerContainer.DataMgr.KeepSakeBookData:SendKeepSakeLevelUpReq(id)
end

function UICollectTipsCtr:GetRightCfgId()

end

function UICollectTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UICollectTipsCtr

