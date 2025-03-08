local UIChangeServerCtr = class("UIChangeServerCtr", require("UICtrBase"))

local DefaultOnePageNum = 10

function UIChangeServerCtr:Init(view)
	self.view = view
end

---@param data boolean 是否直接重登
function UIChangeServerCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIChangeServerCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIChangeServerCtr:GetData()
	return self.data
end

function UIChangeServerCtr:OnDispose()
	self.validNewInterval = nil
	self.curPageType = nil
	self.curSelectGroupIdx = nil
	self.serverDataMap = nil
	self.serverLastReqMap = nil
	self.data = nil
	self.view = nil
end

function UIChangeServerCtr:InitData()
	-- if self.data then
	-- 	for _, value in pairs(Enum.ChangeServerPageType) do
	-- 		if value == self.data then
	-- 			self.curPageType = value
	-- 			break
	-- 		end
	-- 	end
	-- end
	self.validNewInterval = GlobalConfig.Instance:GetConfigIntValue(303)
	self.curPageType = Enum.ChangeServerPageType.Recommend
	self.curSelectGroupIdx = nil
end

function UIChangeServerCtr:IsOnlyChangeServer()
	return self.data
end

function UIChangeServerCtr:GetCurPageType()
	return self.curPageType
end

function UIChangeServerCtr:SetCurPageType(pageType)
	if self.curPageType == pageType then
		return false
	end
	self.curPageType = pageType
	self.curSelectGroupIdx = nil
	return true
end

function UIChangeServerCtr:CheckCacheData()
	if self.serverDataMap then
		local serverInfo = self.serverDataMap[self.curPageType]
		if serverInfo then
			if self.curPageType == Enum.ChangeServerPageType.Recommend then
				if serverInfo.valid then
					if serverInfo.lastUpdteTime then
						if (Time.realtimeSinceStartup - serverInfo.lastUpdteTime) <= 5 then
							return false
						end
					end
					serverInfo.valid = false
				end
			elseif self.curPageType == Enum.ChangeServerPageType.All then
				if self.curSelectGroupIdx then
					serverInfo = serverInfo[self.curSelectGroupIdx]
					if serverInfo then
						if serverInfo.valid then
							if serverInfo.lastUpdteTime then
								if (Time.realtimeSinceStartup - serverInfo.lastUpdteTime) <= 5 then
									return false
								end
							end
							serverInfo.valid = false
						end
					end
				end
			end
		end
	end
	return true
end

function UIChangeServerCtr:IsCurServer(serverId)
	return ManagerContainer.LuaGameMgr.serverData.id == serverId
end

function UIChangeServerCtr:UpdateServerData(serverJson, pageType, pageId)
	if not pageType then
		return false
	end
	if serverJson then
		if not self.serverDataMap then
			self.serverDataMap = {}
		end
		if pageType == Enum.ChangeServerPageType.Recommend then
			local serverInfo = self.serverDataMap[pageType]
			if not serverInfo then
				serverInfo = {}
				self.serverDataMap[pageType] = serverInfo
			end
			local ServerList = serverJson
			serverInfo.ServerList = ServerList
			local ServerMap = serverInfo.ServerMap
			if not ServerMap then
				ServerMap = {}
				serverInfo.ServerMap = ServerMap
			end
			serverInfo.lastUpdteTime = Time.realtimeSinceStartup
			serverInfo.valid = true
			local serverData = ManagerContainer.LuaGameMgr.serverData
			local serverId = serverData.id
			local serverIp = serverData.ip
			local hasSelfServer = false
			for _, value in pairs(ServerList) do
				if value.ServerId then
					ServerMap[value.ServerId] = value
					if value.ServerId == serverId then
						hasSelfServer = true
						if value.Ip ~= serverIp then
							LogError('Recommend Server and Current Server is not match !!!')
							LogError('recommend server : ' .. Inspect(value))
							LogError('current server : id : ' .. tostring(serverId) .. ' ip : ' .. tostring(serverIp))
						end
					end
				end
			end
			if not hasSelfServer then
				if serverId and serverId > 0 then
					local userData = ManagerContainer.DataMgr.UserData
					if userData and userData:IsInitedOver() then
						local curServerData = {
							ServerId = serverId,
							ServerName = serverData.name,
							HeadFrameId = userData:GetHeadFrameId(),
							Level = userData:GetRoleLv(),
							Gender = userData:GetSex(),
							NickName = userData:GetUserNickname(),
							RecordTime = ManagerContainer.LuaTimerMgr:GetTimeSecond(),
							JobCfgId = userData:GetHeroJobCfgId(),
							Ip = serverIp,
							Port = serverData.ports,
							State = serverData.state,
							New = false,
							STime = os.date('%Y-%m-%d %H:%M:%S', os.time())
						}
						ServerMap[serverId] = curServerData
						ServerList[#ServerList + 1] = curServerData
					end
				end
			end
			table.sort(ServerList, function(a, b)
				if a.ServerId == serverId then
					return true
				end
				if b.ServerId == serverId then
					return false
				end
				local hasRoleA = (a.Gender and a.Gender > 0 and a.JobCfgId and a.JobCfgId > 0 and a.Level and a.Level > 0)
				local hasRoleB = (b.Gender and b.Gender > 0 and b.JobCfgId and b.JobCfgId > 0 and b.Level and b.Level > 0)
				if hasRoleA == hasRoleB then
					if a.New == b.New then
						return a.ServerId > b.ServerId
					else
						return (not a.New)
					end
				else
					return hasRoleA
				end
			end)
		elseif pageType == Enum.ChangeServerPageType.All then
			local serverInfos = self.serverDataMap[pageType]
			if not serverInfos then
				serverInfos = {}
				serverInfos.OnePageNum = DefaultOnePageNum
				self.serverDataMap[pageType] = serverInfos
			end
			if serverJson.Page and serverJson.Page > 0 and serverInfos.OnePageNum ~= serverJson.Page then
				serverInfos.OnePageNum = serverJson.Page
				if serverInfos.ServerNum then
					serverInfos.ServerGroupNum = Mathf.Ceil(serverInfos.ServerNum / serverInfos.OnePageNum) + 1
				end
			end
			if serverJson.MaxServerId and serverJson.MaxServerId > 0 and serverInfos.ServerNum ~= serverJson.MaxServerId then
				serverInfos.ServerNum = serverJson.MaxServerId
				if serverInfos.OnePageNum then
					serverInfos.ServerGroupNum = Mathf.Ceil(serverInfos.ServerNum / serverInfos.OnePageNum) + 1
				else
					serverInfos.ServerGroupNum = Mathf.Ceil(serverInfos.ServerNum / DefaultOnePageNum) + 1
				end
			end
			local serverGroupNum = 0
			if serverInfos.ServerGroupNum then
				serverGroupNum = serverInfos.ServerGroupNum
			end
			if not pageId or pageId <= 0 then
				pageId = 1
			else
				pageId = serverGroupNum - pageId
			end
			if not self.curSelectGroupIdx then
				self.curSelectGroupIdx = pageId
			end
			if serverJson.ServerList then
				table.sort(serverJson.ServerList, function(a, b)
					return a.ServerId > b.ServerId
				end)
				local serverInfo = serverInfos[pageId]
				if not serverInfo then
					serverInfo = {}
					serverInfos[pageId] = serverInfo
				end
				serverInfo.ServerList = serverJson.ServerList
				serverInfo.lastUpdteTime = Time.realtimeSinceStartup
				serverInfo.valid = true
			end
		end
	end
end

function UIChangeServerCtr:GetCurSelectServerGroupIdx()
	if self.curSelectGroupIdx then
		if self.serverDataMap then
			local serverInfos = self.serverDataMap[self.curPageType]
			if serverInfos then
				if serverInfos.ServerGroupNum then
					return serverInfos.ServerGroupNum - self.curSelectGroupIdx
				end
			end
		end
	end
	return nil
end

function UIChangeServerCtr:SetCurSelectGroupIdx(groupIdx)
	if self.curSelectGroupIdx == groupIdx then
		return false
	end
	self.curSelectGroupIdx = groupIdx
	return true
end

function UIChangeServerCtr:IsCurSelectGroup(groupIdx)
	return (self.curSelectGroupIdx == groupIdx)
end

function UIChangeServerCtr:GetServerItemDataLength()
	if self.serverDataMap then
		local serverInfo = self.serverDataMap[self.curPageType]
		if serverInfo then
			if self.curPageType == Enum.ChangeServerPageType.Recommend then
				if serverInfo.valid and serverInfo.ServerList then
					return #serverInfo.ServerList
				end
			elseif self.curPageType == Enum.ChangeServerPageType.All then
				if self.curSelectGroupIdx then
					serverInfo = serverInfo[self.curSelectGroupIdx]
					if serverInfo and serverInfo.valid and serverInfo.ServerList then
						return #serverInfo.ServerList
					end
				end
			end
		end
	end
	return 0
end

function UIChangeServerCtr:GetServerItemDataByItemIdx(itemIdx)
	if self.serverDataMap then
		local serverInfo = self.serverDataMap[self.curPageType]
		if serverInfo then
			if self.curPageType == Enum.ChangeServerPageType.Recommend then
				if serverInfo.valid and serverInfo.ServerList then
					local serverData = serverInfo.ServerList[itemIdx + 1]
					return serverData, serverData
				end
			elseif self.curPageType == Enum.ChangeServerPageType.All then
				if self.curSelectGroupIdx then
					serverInfo = serverInfo[self.curSelectGroupIdx]
					if serverInfo and serverInfo.valid and serverInfo.ServerList then
						local serverData = serverInfo.ServerList[itemIdx + 1]
						if serverData then
							serverInfo = self.serverDataMap[Enum.ChangeServerPageType.Recommend]
							if serverInfo then
								if serverInfo.ServerMap[serverData.ServerId] then
									return serverData, serverInfo.ServerMap[serverData.ServerId]
								end
							end
							return serverData, serverData
						end
					end
				end
			end
		end
	end
	return nil, nil
end

function UIChangeServerCtr:GetServerGroupItemDataLength()
	if self.serverDataMap then
		local serverInfos = self.serverDataMap[self.curPageType]
		if serverInfos then
			if self.curPageType == Enum.ChangeServerPageType.All then
				if serverInfos.ServerGroupNum then
					return serverInfos.ServerGroupNum + 1
				end
			end
		end
	end
	return 0
end

function UIChangeServerCtr:GetServerGroupItemDataByItemIdx(itemIdx)
	if self.curPageType ~= Enum.ChangeServerPageType.All then
		return nil, nil
	end
	if self.serverDataMap then
		local serverInfos = self.serverDataMap[self.curPageType]
		if serverInfos then
			local serverGroupNum = 0
			if serverInfos.ServerGroupNum then
				serverGroupNum = serverInfos.ServerGroupNum
			end
			if itemIdx > 0 then
				if itemIdx < serverGroupNum then
					local onePageNum = serverInfos.OnePageNum
					if not onePageNum or onePageNum <= 0 then
						onePageNum = DefaultOnePageNum
					end
					local startId = (serverGroupNum - itemIdx - 1) * onePageNum + 1
					local endId = (serverGroupNum - itemIdx) * onePageNum
					return startId, endId
				end
			end
		end
	end
	return nil, nil
end

function UIChangeServerCtr:IsValidNew(time)
	return self.validNewInterval >= time
end

return UIChangeServerCtr

