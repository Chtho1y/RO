local UIIdolSupportTipsCtr = class("UIIdolSupportTipsCtr", require("UICtrBase"))

function UIIdolSupportTipsCtr:Init(view)
	self.view = view
end

function UIIdolSupportTipsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
	self.cb = data[3]
	self.cbwnd = data[2]
	self.cfgId = data[1]
	self.logicData = data[4]
	self.maxNum = data[5]
	self.selectNum = data[5]
end

function UIIdolSupportTipsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIIdolSupportTipsCtr:GetData()
	return self.data
end

function UIIdolSupportTipsCtr:GetCfgId()
	return self.cfgId or 0
end

function UIIdolSupportTipsCtr:GetselectNum()
	return self.selectNum  or 0
end

function UIIdolSupportTipsCtr:GetmaxNum()
	return self.maxNum  or 0
end

function UIIdolSupportTipsCtr:SetselectNum(num)
	self.selectNum = num
end

function UIIdolSupportTipsCtr:GetLogicData()
	return self.logicData or nil
end

function UIIdolSupportTipsCtr:CallBack()
	if self.cb and self.cbwnd then
		self.cb(self.cbwnd,{self.selectNum,self.logicData.uid})
	end
end

function UIIdolSupportTipsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIIdolSupportTipsCtr

