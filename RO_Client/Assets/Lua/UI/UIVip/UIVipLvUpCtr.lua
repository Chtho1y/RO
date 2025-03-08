local UIVipLvUp = class("UIVipLvUp", require("UICtrBase"))

function UIVipLvUp:Init(view)
	self.view = view
end

---@param data table  {1,2} 1:为上一Vip等级，2:为目标Vip等级
function UIVipLvUp:SetData(data)
	self.asyncIdx = 0
	self.data = data
	self:InitData()
end

function UIVipLvUp:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIVipLvUp:GetData()
	return self.data
end

function UIVipLvUp:OnDispose()
	self.data = nil
	self.view = nil
	self.lastLv = nil
	self.curLv = nil
end

function UIVipLvUp:InitData()
	if self.data then
		self.lastLv = self.data[1] or 0
		self.curLv = self.data[2] or 0
	else
		self:RefreshNextChange()
	end
end

function UIVipLvUp:RefreshNextChange()
	local data = ManagerContainer.VipChangeMgr:GetNextChangeLv()
	if data then
		self.lastLv = data[1] or 0
		self.curLv = data[2] or 0
		return true
	else
		self.lastLv = 0
		self.curLv = 0
		return false
	end
end

function UIVipLvUp:GetInfo()
	return self.lastLv, self.curLv
end


return UIVipLvUp

