local UIVipExpTipsCtr = class("UIVipExpTipsCtr", require("UICtrBase"))

function UIVipExpTipsCtr:Init(view)
	self.view = view
end

---@param data table  {1,2,3} 1:为目标Vip等级，2:为加Vip经验之前的总经验，3:为加Vip经验之后的总经验
function UIVipExpTipsCtr:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIVipExpTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVipExpTipsCtr:GetData()
	return self.data
end

function UIVipExpTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.curLv = nil
	self.lastExp = nil
	self.curExp = nil
end

function UIVipExpTipsCtr:InitData()
	if self.data then
		self.curLv = self.data[1] or 1
		self.lastExp = self.data[2] or 0
		self.curExp = self.data[3] or 0
	else
		self:RefreshNextChange()
	end
end

function UIVipExpTipsCtr:RefreshNextChange()
	local data = ManagerContainer.VipChangeMgr:GetNextChangeExp()
	if data then
		self.curLv = data[1] or 1
		self.lastExp = data[2] or 0
		self.curExp = data[3] or 0
		return true
	else
		self.curLv = 1
		self.lastExp = 0
		self.curExp = 0
		return false
	end
end

function UIVipExpTipsCtr:GetInfo()
	return self.curLv, self.lastExp, self.curExp
end

return UIVipExpTipsCtr

