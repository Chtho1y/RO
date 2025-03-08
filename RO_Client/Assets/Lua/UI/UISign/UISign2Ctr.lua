local UISign2Ctr = class("UISign2Ctr", require("UICtrBase"))

function UISign2Ctr:Init(view)
	self.view = view
end

function UISign2Ctr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
end

function UISign2Ctr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UISign2Ctr:GetData()
	return self.data
end

function UISign2Ctr:OnDispose()
	self.data = nil
	self.view = nil
end

--获取要说的话
function UISign2Ctr:GetDialogueString()
	local _sex = ManagerContainer.DataMgr.UserData:GetSex();
	local _dialogues;
	if _sex == Enum.SexType.Woman then
		_dialogues = GlobalConfig.Instance:GetConfigStrValue(148);
	else
		_dialogues = GlobalConfig.Instance:GetConfigStrValue(147);
	end
	local _dialogueList = {}
	local _strs = string.split(_dialogues,';')
	for _, _v in ipairs(_strs) do
		table.insert(_dialogueList, _v);
	end
	local _random = math.random(#_dialogueList);
	return _dialogueList[_random];
end

--获取要说的话的开始和关闭时间
function UISign2Ctr:GetDialogueTimes()
	local _timeStr = GlobalConfig.Instance:GetConfigStrValue(146);
	local _timeStrList = string.split(_timeStr, ';');
	local _itemNumList = {};
	for _i = 1, #_timeStrList do
		table.insert(_itemNumList, tonumber(_timeStrList[_i]) * 1000);
	end
	return _itemNumList;
end

return UISign2Ctr

