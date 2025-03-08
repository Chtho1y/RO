local UISign2View = require("UISign/UISign2View_Generate")
local ModelViewSystem = require("ModelViewSystem")
local PreviewSystem = require("PreviewSystem")

local _modelViewSystem;
local previewSystem = nil;
local _modelPath = Constants.ModelPath;
local _modelName = nil;
--[[
local _acPath = "";
local _acName = "";]]--

function UISign2View:OnAwake(data)
	self.controller = require("UISign/UISign2Ctr"):new()
	self.controller:Init(self)
	self.controller:SetData(data)
end

function UISign2View:AddEventListener()

end

function UISign2View:FillContent(data, uiBase)
	self.uiBase = uiBase
	local gameObject = self.uiBase:GetRoot()
	if gameObject ~= nil then
		self.gameObject = gameObject
		self.transform = gameObject.transform
	end
	self:InitGenerate(self.transform, data)

	self:Init()
end

function UISign2View:Init()
	ManagerContainer.LuaUIMgr:CloseInputMask()

	if not _modelName then
		_modelName = GlobalConfig.Instance:GetConfigStrValue(160)
	end

	self:InitModel();
end

function UISign2View:RemoveEventListener()
	ManagerContainer.LuaEventMgr:Unregister(self.uiData.name)

end

function UISign2View:AddUIEventListener()
	ManagerContainer.LuaEventMgr:RegisterUIEvent(self.uiData.name)

end

function UISign2View:OnHide()

end

function UISign2View:OnShow(data)
	self.controller:SetData(data)

end

function UISign2View:OnClose()
	if previewSystem then
		previewSystem:Dispose()
	end
	previewSystem = nil

	if _modelViewSystem then
		_modelViewSystem:Dispose()
	end
	_modelViewSystem = nil

	

	if self._closeTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(self._closeTimer);
		self._closeTimer = nil;
	end
end

function UISign2View:OnDispose()
	self.controller:OnDispose()
end

function UISign2View:InitModel()
	if not _modelViewSystem then
		_modelViewSystem = ModelViewSystem:new();
	end

	local _dialogueString = self.controller:GetDialogueString();
	local _nickName = ManagerContainer.DataMgr.UserData:GetUserNickname();
	local _string = I18N.SetLanguageValue(_dialogueString, _nickName);
	local _times = self.controller:GetDialogueTimes();


	if not previewSystem then
		previewSystem = PreviewSystem:new("Sign", 1024, 1024)

		local _posStr = GlobalConfig.Instance:GetConfigStrValue(162)
		local _pos = string.split(_posStr, ";")


		local _eulStr = GlobalConfig.Instance:GetConfigStrValue(163)
		local _eul = string.split(_eulStr, ";")

		local _posReal = Vector3.zero;
		local _eulReal = Quaternion.Euler(0, 0, 0);
		if #_pos == 3 then
			_posReal = Vector3(tonumber(_pos[1]), tonumber(_pos[2]), tonumber(_pos[3]));
		end
		if #_eul == 3 then
			_eulReal = Quaternion.Euler(tonumber(_eul[1]), tonumber(_eul[2]), tonumber(_eul[3]));
		end

		previewSystem:SetView(_posReal, _eulReal);
	end

	local _dialogueData = {
		_textStr = _string,    --要说的话
		_showStartTime = _times[1],   --显示的开始时间
		_showEndTime = _times[2],     --显示的结束时间
		_dialogueParent = GlobalConfig.Instance:GetConfigStrValue(161),    --冒泡对话的父级节点的路径
	}

	_modelViewSystem:RefreshView(_modelPath, _modelName, nil, nil, _dialogueData, nil, self, self.LoadModelCB);
	local _data = self.controller:GetData();
	if _data ~= true then
		self._closeTimer = ManagerContainer.LuaTimerMgr:AddTimer(_times[3], 1, self, self.OpenSignInFun, nil);
	end
end

function UISign2View:OpenSignInFun()
	--ManagerContainer.DataMgr.SignData:OpenSign(Enum.UIPageName.UIBattle);
	self:UIClose()
	ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UISignDaily)
end

--load 模型
function UISign2View:LoadModelCB(model)
	if model then
		if previewSystem then
			previewSystem:UpdateGo(model)
		end
		model:SetActive(true)
	end

	self.rawImage.rawImage.texture = previewSystem:GetRenderTexture()
end

return UISign2View

