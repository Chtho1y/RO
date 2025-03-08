local UIPlayRuleCtr = class("UIPlayRuleCtr", require("UICtrBase"))

function UIPlayRuleCtr:Init(view)
	self.view = view
end

---@param data table  {[1] = languageKey, [2] = languageKey}
function UIPlayRuleCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIPlayRuleCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPlayRuleCtr:GetData()
	return self.data
end

function UIPlayRuleCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIPlayRuleCtr:GetTitleStr()
	local key = self.data and self.data[1] or ''
	return string.formatbykey(key)
end

function UIPlayRuleCtr:GetContentStr()
	local key = self.data and self.data[2] or ''
	return string.formatbykey(key)
end

function UIPlayRuleCtr:IsCopy()
	return self.data and self.data[3] or false
end

return UIPlayRuleCtr

