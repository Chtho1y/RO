local UIRoleInfoPopCtr = class("UIRoleInfoPopCtr", require("UICtrBase"))

function UIRoleInfoPopCtr:Init(view)
	self.view = view
end

---@param data table 格式为{title, {{itemId, itemTitle, itemDes, itemIcon}, ...}} title为界面标题, itemId为每一项的唯一Id(用于排序), itemTitle为每一项的小标题, itemDes为每一项的描述, itemIcon为每一项的小图标（可为空）
function UIRoleInfoPopCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIRoleInfoPopCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIRoleInfoPopCtr:GetData()
	return self.data
end

function UIRoleInfoPopCtr:OnDispose()
	self.data = nil
	self.view = nil
	self.titleName = nil
	self.datas = nil
	self.dataLength = nil
end

function UIRoleInfoPopCtr:InitData()
	if self.data then
		self.titleName = self.data[1]
		self.datas = self.data[2]
		if self.datas then
			table.sort(self.datas, function(a, b)
				return a[1] < b[1]
			end)
		end
	else
		self.titleName = ''
		self.datas = nil
	end
	self.dataLength = self.datas and #self.datas or 0
end

function UIRoleInfoPopCtr:GetTitleName()
	return self.titleName
end

function UIRoleInfoPopCtr:GetDataLength()
	return self.dataLength
end

function UIRoleInfoPopCtr:GetDataByIdx(idx)
	return self.datas and self.datas[idx] or nil
end

return UIRoleInfoPopCtr

