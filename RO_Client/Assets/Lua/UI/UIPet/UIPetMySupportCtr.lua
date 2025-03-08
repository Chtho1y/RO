local UIPetMySupportCtr = class("UIPetMySupportCtr", require("UICtrBase"))

function UIPetMySupportCtr:Init(view)
	self.view = view
end

function UIPetMySupportCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPetMySupportCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetMySupportCtr:GetData()
	return self.data
end

function UIPetMySupportCtr:RefreshShowDatas()
	self.showDatas = ManagerContainer.DataMgr.PetDataMgr:GetMySupportPets()
	CommonUtil.ArraySortListSelections(self.showDatas, {Enum.TableSortRule.Down, Enum.TableSortRule.Up}, {"id", "cd"})
	self.supportCount = 0
	for i = 1, Constant.MyPetSupportLimit do
		if self.showDatas[i] and self.showDatas[i].id > 0 then
			self.supportCount = self.supportCount + 1
		end
	end
end

function UIPetMySupportCtr:GetShowDatas()
	return self.showDatas
end

function UIPetMySupportCtr:GetMySupportCount()
	return self.supportCount
end

function UIPetMySupportCtr:GetShowDataLength()
	return self.showDatas and #self.showDatas or 0
end

function UIPetMySupportCtr:GetShowDataByIdx(idx)
	return self.showDatas and self.showDatas[idx + 1] or nil
end

function UIPetMySupportCtr:AddSupportData(id, idx)
	local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
	for _,v in pairs(self.showDatas) do
		if v.id == 0 and curTime > v.cd then
			v.id = id
			return
		end
	end
end

function UIPetMySupportCtr:RemoveShowDataById(id)
	for i = 1, #self.showDatas do
		if self.showDatas[i].id == id then
			self.showDatas[i].id = 0
			return
		end
	end
end

function UIPetMySupportCtr:SendMySupport()
	local list = {}
	for _,v in pairs(self.showDatas) do
		list[v.idx] = v.id
	end
	ManagerContainer.DataMgr.PetDataMgr:SendMySupport(list)
end

function UIPetMySupportCtr:SupportSlotIsInCD(idx)
	local endTime = self.showDatas[idx] and self.showDatas[idx].cd or 0
	if endTime > 0 then
		local curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime()
		if curTime > endTime then
			return false
		else
			local remainS = ManagerContainer.LuaTimerMgr:GetRemainSecondsWithUInt64(endTime, false)
			if remainS > 0 then
				local time = DateTimeUtil.convertSeconds2TimeStr1(remainS, true, true)
				return true, time
			end
		end
	end
	return false
end

function UIPetMySupportCtr:OnDispose()
	self.showDatas = nil

	self.data = nil
	self.view = nil
end

return UIPetMySupportCtr

