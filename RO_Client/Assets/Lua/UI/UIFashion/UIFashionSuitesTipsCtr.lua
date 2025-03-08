local UIFashionSuitesTipsCtr = class("UIFashionSuitesTipsCtr", require("UICtrBase"))

function UIFashionSuitesTipsCtr:Init(view)
	self.view = view
end

function UIFashionSuitesTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFashionSuitesTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFashionSuitesTipsCtr:GetData()
	return self.data
end

function UIFashionSuitesTipsCtr:RefreshSuites()
	self.showDatas = {}
	local fashionId = self:GetData()
	local fashionCfgData = ManagerContainer.CfgMgr:GetFashionById(fashionId)
	if not fashionCfgData then
		return
	end

	local userSex = ManagerContainer.DataMgr.UserData:GetSex()
	local ids = {}
	if fashionCfgData.SuitId then
		for _,v in pairs(fashionCfgData.SuitId) do
			local suitCfgData = ManagerContainer.CfgMgr:GetFashionSuitDataById(v)
			if suitCfgData and (suitCfgData.SuitSex == 0 or suitCfgData.SuitSex == userSex) then
				ids[#ids + 1] = v
			end
		end
	end
	self.showDatas = ids
end

function UIFashionSuitesTipsCtr:GetShowDataLength()
	return #self.showDatas or 0
end

function UIFashionSuitesTipsCtr:GetShowData(idx)
	return self.showDatas[idx]
end

function UIFashionSuitesTipsCtr:GetFashionLogicData(cfgId)
	return ManagerContainer.DataMgr.FashionData:GetFashionById(cfgId)
end

function UIFashionSuitesTipsCtr:GetSuitLvById(cfgId)
	return ManagerContainer.DataMgr.FashionData:GetFashionSuitLvById(cfgId)
end

function UIFashionSuitesTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIFashionSuitesTipsCtr

