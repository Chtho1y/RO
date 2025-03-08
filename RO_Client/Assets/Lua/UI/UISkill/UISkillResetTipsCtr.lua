local UISkillResetTipsCtr = class("UISkillResetTipsCtr", require("UICtrBase"))

function UISkillResetTipsCtr:Init(view)
	self.view = view
end


---@param data table|nil  {[1] = {[1] = ownerCB, [2] = owner}, [2] = {[1] = ownerCB, [2] = owner}}
function UISkillResetTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISkillResetTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISkillResetTipsCtr:GetData()
	return self.data
end

function UISkillResetTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.costCfgId = nil
	self.constNum = nil
end

function UISkillResetTipsCtr:GetResetCost()
	return CommonUtil.GetResetSkillLvCost()
end

function UISkillResetTipsCtr:GetIsAdvance()
	return self.data and self.data[3] or false
end

function UISkillResetTipsCtr:GetOwnResCountByItemId(itemCfgId)
	return CommonUtil.GetOwnResCountByItemId(itemCfgId)
end

function UISkillResetTipsCtr:CancelCallback()
	if not self.data then return end
	local cancelBtn = self.data[2]
	if not cancelBtn then return end
	local ownerCB = cancelBtn[1]
	local owner = cancelBtn[2]
	if ownerCB then
		if owner then
			ownerCB(owner)
		else
			ownerCB()
		end
	end
end

function UISkillResetTipsCtr:ResetCallback(type)
	if not self.data then return end
	local resetBtn = self.data[1]
	if not resetBtn then return end
	local ownerCB = resetBtn[1]
	local owner = resetBtn[2]
	if ownerCB then
		if owner then
			ownerCB(owner,type)
		else
			ownerCB(type)
		end
	end
end

return UISkillResetTipsCtr

