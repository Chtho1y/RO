local UIFuncMenuCtr = class("UIFuncMenuCtr", require("UICtrBase"))

function UIFuncMenuCtr:Init(view)
	self.view = view
end

---@param data table {menus = {{[1] = langKey, [2] = params, [3] = notClick}}, cb = func, cancelCb = nil, ownerCB = table|nil, alignPos = Vector3, alignment = Enum.Alignment, vaildMin = Vector3, vaildMax = Vector3}
--- menus为功能按钮列表 langKey语言表key, params为点击了回调函数中的数据，notClick为是否不可点击
--- cb函数（可为匿名函数），cancelCb函数（可为匿名函数），ownerCB为函数的拥有者，匿名函数时，则为空
--- alignPos 对齐坐标点（世界坐标点），为空则默认为屏幕中间
--- alignment 对齐方向,为空则默认为居中对齐
--- vaildMin, vaildMax 有效区域 (世界坐标点)， 为空则默认为屏幕安全区域
function UIFuncMenuCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIFuncMenuCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIFuncMenuCtr:GetData()
	return self.data
end

function UIFuncMenuCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIFuncMenuCtr:GetMenus()
	if self.data and self.data.menus and #self.data.menus > 0 then
		return self.data.menus
	end
	return {{'Null'}}
end

function UIFuncMenuCtr:GetAlignPos()
	if self.data and self.data.alignPos then
		return self.data.alignPos
	end
	return nil
end

function UIFuncMenuCtr:GetAlignment()
	if self.data and self.data.alignment then
		return self.data.alignment
	end
	return Enum.Alignment.None
end

function UIFuncMenuCtr:GetVaildMin()
	if self.data and self.data.vaildMin then
		return self.data.vaildMin
	end
	return nil
end

function UIFuncMenuCtr:GetVaildMax()
	if self.data and self.data.vaildMax then
		return self.data.vaildMax
	end
	return nil
end

function UIFuncMenuCtr:ExecuteCancelCallBack()
	if not self.data then return end
	local cancelCb = self.data.cancelCb
	if cancelCb then
		local ownerCB = self.data.ownerCB
		if ownerCB then
			cancelCb(ownerCB)
		else
			cancelCb()
		end
	end
end

function UIFuncMenuCtr:ExecuteCallBack(idx)
	if not self.data then return end
	if not self.data.menus then return end
	local menu = self.data.menus[idx]
	if not menu then return end
	if menu[3] then return end
	local cb = self.data.cb
	if cb then
		local ownerCB = self.data.ownerCB
		if ownerCB then
			cb(ownerCB, menu[2])
		else
			cb(menu[2])
		end
	end
end

return UIFuncMenuCtr

