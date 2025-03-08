local UIDojoBuyTimesCtr = class("UIDojoBuyTimesCtr", require("UICtrBase"))

function UIDojoBuyTimesCtr:Init(view)
	self.view = view
end

function UIDojoBuyTimesCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UIDojoBuyTimesCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIDojoBuyTimesCtr:GetData()
	return self.data
end

function UIDojoBuyTimesCtr:OnDispose()
	self.data = nil
	self.view = nil
end

function UIDojoBuyTimesCtr:GetCostNum()
	if self.data then
		return self.data[1] or 0
	end
	return 0
end

function UIDojoBuyTimesCtr:GetRemainCount()
	if self.data then
		return self.data[2]
	end
	return nil
end

function UIDojoBuyTimesCtr:HandleCallback()
	if self.data then
		local cb = self.data[3]
		local ownerCb = self.data[4]
		if cb then
			if ownerCb then
				cb(ownerCb)
			else
				cb()
			end
		end
	end
end

return UIDojoBuyTimesCtr

