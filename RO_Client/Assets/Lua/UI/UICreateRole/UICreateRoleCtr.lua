local UICreateRoleCtr = class("UICreateRoleCtr", require("UICtrBase"))

local canSelectHairMap = nil
local canSelectHairColorMap = nil
local canSelectEyeMap = nil
local canSelectHeadwearMap = nil

local selectHairIndex = 1
local selectHairColorIndex = 1
local selectEyeIndex = 1
local selectHeadwearIndex = 1

local sexType = Enum.SexType.Woman

local Clamp = function(value, min, max)
	if value < min then
		return value
	end
	if value > max then
		return max
	end
	return value
end

local TableToColor = function(table)
    if not table then return Color.white end
    local r = Clamp(table[1] or 255, 0, 255)
    local g = Clamp(table[2] or 255, 0, 255)
    local b = Clamp(table[3] or 255, 0, 255)
    return Color(r / 255, g / 255, b / 255, 1)
end

local SortRule = function(a, b)
	if a < b then
		return true
	else
		return false
	end
end

local GetSex = function(key)
	local sex = key
	while sex >= 10 do
		sex = sex * 0.1
	end
	return math.floor(sex)
end

local SortMap = function(map)
	if not map then return end
	for _,v in pairs(map) do
		if v then
			table.sort(v, SortRule)
		end
	end
end

local InitMap = function(cfgData)
	local map = {}
	for key, _ in pairs(cfgData) do
		local sex = GetSex(key)
		local ls = map[sex]
		if not ls then
			ls = {}
			map[sex] = ls
		end
		table.insert(ls, key)
	end
	SortMap(map)
	return map
end

local InitMapNoSex = function(cfgData)
	local map = {}
	for key, _ in pairs(cfgData) do
		table.insert(map, key)
	end
	table.sort(map, SortRule)
	return map
end

function UICreateRoleCtr:Init(view)
	self.view = view

	local hairCfg = ManagerContainer.CfgMgr:GetCreateHairCfg()
	canSelectHairMap = InitMap(hairCfg)
	local hairColorCfg = ManagerContainer.CfgMgr:GetCreateHairColorCfg()
	canSelectHairColorMap = InitMapNoSex(hairColorCfg)
	local eyeCfg = ManagerContainer.CfgMgr:GetCreateEyeCfg()
	canSelectEyeMap = InitMap(eyeCfg)
	local headwearCfg = ManagerContainer.CfgMgr:GetCreateHeadwearCfg()
	canSelectHeadwearMap = InitMapNoSex(headwearCfg)

	-- 默认数据
	sexType = Enum.SexType.Woman
	self:ResetDefaultSelect()
end

function UICreateRoleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UICreateRoleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UICreateRoleCtr:GetData()
	return self.data
end

function UICreateRoleCtr:OnDispose()
	self.data = nil
	self.view = nil
	canSelectHairMap = nil
	canSelectHairColorMap = nil
	canSelectEyeMap = nil
	canSelectHeadwearMap = nil
	selectHairIndex = nil
	selectHairColorIndex = nil
	selectEyeIndex = nil
	selectHeadwearIndex = nil
end

function UICreateRoleCtr:GetSexType()
	return sexType
end

function UICreateRoleCtr:SetSexType(newSexType)
	if sexType == newSexType then return false end
	sexType = newSexType
	self:ResetDefaultSelect()
	return true
end

function UICreateRoleCtr:GetRoleCfgId()
	return CommonUtil.JobIdToRoleId(GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_profession), sexType)
end

function UICreateRoleCtr:ResetDefaultSelect()
	selectHairIndex = 1
	selectHairColorIndex = 1
	selectEyeIndex = 1
	selectHeadwearIndex = 1
end

function UICreateRoleCtr:SetSelectHairIndex(index)
	local ls = self:GetCanSelectHairMap()
	index = Clamp(index, 1, #ls)
	if index == selectHairIndex then return false end
	selectHairIndex = index
	return true
end

function UICreateRoleCtr:GetSelectHairIndex()
	return selectHairIndex
end

function UICreateRoleCtr:GetCanSelectHairMap()
	return canSelectHairMap[sexType]
end

function UICreateRoleCtr:SetSelectHairColorIndex(index)
	local ls = self:GetCanSelectHairColorMap()
	index = Clamp(index, 1, #ls)
	if index == selectHairColorIndex then return false end
	selectHairColorIndex = index
	return true
end

function UICreateRoleCtr:GetSelectHairColorIndex()
	return selectHairColorIndex
end

function UICreateRoleCtr:GetCanSelectHairColorMap()
	return canSelectHairColorMap
end

function UICreateRoleCtr:GetCanSelectHairColors()
	local ls = {}
	for i = 1, 7 do
		local createHairColorCfg = ManagerContainer.CfgMgr:GetCreateHairColorById(canSelectHairColorMap[i])
		if createHairColorCfg then
			ls[i] = TableToColor(createHairColorCfg.HairColour)
		else
			ls[i] = Color.white
		end
	end
	return ls
end

function UICreateRoleCtr:GetSelectHairColor()
	local hairColor = canSelectHairColorMap[selectHairColorIndex]
	local createHairColorCfg = ManagerContainer.CfgMgr:GetCreateHairColorById(hairColor)
	if createHairColorCfg then
		return TableToColor(createHairColorCfg.HairColour)
	else
		return Color.white
	end
end

function UICreateRoleCtr:SetSelectEyeIndex(index)
	local ls = self:GetCanSelectEyeMap()
	index = Clamp(index, 1, #ls)
	if index == selectEyeIndex then return false end
	selectEyeIndex = index
	return true
end

function UICreateRoleCtr:GetSelectEyeIndex()
	return selectEyeIndex
end

function UICreateRoleCtr:GetCanSelectEyeMap()
	return canSelectEyeMap[sexType]
end

function UICreateRoleCtr:SetSelectHeadwearsIndex(index)
	local ls = self:GetCanSelectHeadwearMap()
	index = Clamp(index, 1, #ls)
	if index == selectHeadwearIndex then return false end
	selectHeadwearIndex = index
	return true
end

function UICreateRoleCtr:GetSelectHeadwearsIndex()
	return selectHeadwearIndex
end

function UICreateRoleCtr:GetCanSelectHeadwearMap()
	return canSelectHeadwearMap
end

function UICreateRoleCtr:GetViewData()
	local viewData 			= {}
	viewData.eye 			= canSelectEyeMap[sexType][selectEyeIndex]
	viewData.hairColor 		= canSelectHairColorMap[selectHairColorIndex]
	viewData.hair 			= canSelectHairMap[sexType][selectHairIndex]
	local fashionData   	= {}
	viewData.fashionData 	= fashionData

	local id 				= canSelectHeadwearMap[selectHeadwearIndex]
	local headwearCfg		= ManagerContainer.CfgMgr:GetCreateHeadwearById(id)
	local fashionId			= headwearCfg.HeadwearAvatar
	local fashionCfg 		= ManagerContainer.CfgMgr:GetFashionById(fashionId)
	fashionData[fashionCfg.FashionLocation] = fashionId
	return viewData
end

function UICreateRoleCtr:OnCreateClick()
	local roleCfgId 		= self:GetRoleCfgId()
	local eye 				= canSelectEyeMap[sexType][selectEyeIndex]
	local hair 				= canSelectHairColorMap[selectHairColorIndex]
	local hair_avatar 		= canSelectHairMap[sexType][selectHairIndex]
	local id 				= canSelectHeadwearMap[selectHeadwearIndex]
	local headwearCfg		= ManagerContainer.CfgMgr:GetCreateHeadwearById(id)
	local head				= headwearCfg.HeadwearAvatar
	local country 			= GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_country)
	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_CREATE_ROLE_REQ, {open_id = self.data.userName, job_id = GlobalConfig.Instance:GetConfigIntValue(GlobalConfig.c_default_profession), sex = sexType, country = country, eye = eye, hair = hair, hair_avatar = hair_avatar, head = head })
end

-- function UICreateRoleCtr:CreateNickName()
-- 	ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_NAME_REQ, { name = self.data.userName })
-- end

return UICreateRoleCtr

