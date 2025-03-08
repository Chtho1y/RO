local UIGMCtr = class("UIGMCtr", require("UICtrBase"))

function UIGMCtr:Init(view)
	self.view = view
end

function UIGMCtr:SetData(data)
	self.data = data
	self.asyncIdx = 0
end

function UIGMCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIGMCtr:GetData()
	return self.data
end

function UIGMCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIGMCtr:TidyData()
	if not self._data then
		self._data = {};
		local _data = ManagerContainer.CfgMgr:GetGMCfg();
		for _k, _v in pairs(_data) do
			table.insert(self._data, _v);
		end
		table.sort(self._data, function(a, b)
			return a.SortIndex < b.SortIndex;
		end)
	end

	return self._data;
end

return UIGMCtr

