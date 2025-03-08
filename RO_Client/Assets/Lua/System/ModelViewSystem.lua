local ModelViewSystem = class("ModelViewSystem")
local MultiTypeAssetLoadSystem = require("MultiTypeAssetLoadSystem")

local AnimatorType = typeof(UnityEngine.Animator)

local _dialogueName = "Dialogue/Dialogue";   --冒泡对话的预设物的名字
local _goPosition = Vector3.zero    --实例化出来的模型的默认位置

function ModelViewSystem:ctor()
    self.modelPath = nil
    self.modelName = nil
    self.acPath = nil
    self.acName = nil

    self.loadModelPath = nil
    self.loadModelName = nil
    self.loadAcPath = nil
    self.loadAcName = nil

    self.modelGo = nil
    self._dialogueData = nil;
    self._dialogueGo = nil;
    self:RemoveTimers();

    self.ownercb = nil
    self.cb = nil
    self.loadSystem = MultiTypeAssetLoadSystem:new()
    self.loadSystem:SetCompleteCB(self, self.PreloadedAssets)
end

function ModelViewSystem:Dispose()
    self:RemoveTimers()

    self:Recycle()
    self.loadSystem:Dispose()
    self.loadSystem = nil

    --目前是不重复利用的，释放就删除
    CommonUtil.DestroyGOImmediate(self.modelGo);
    CommonUtil.DestroyGOImmediate(self._dialogueGo);
end

function ModelViewSystem:Recycle()
    --self:CancelCreate()
    if not tolua.isnull(self.modelGo) then
        local go = self.modelGo
        self.modelGo = nil
        local animator = go:GetComponent(AnimatorType)
        animator.runtimeAnimatorController = nil
        ManagerContainer.ResMgr:RecycleGO(self.loadModelPath, self.loadModelName, go)
    end
end

--[[
_dialogueData = {
    _textStr = ""    --要说的话
    _showStartTime = 0000,   --显示的开始时间
    _showEndTime = 0000,     --显示的结束时间
    _dialogueParent = "path",    --冒泡对话的父级节点的查路径
}
]]--
function ModelViewSystem:RefreshView(modelPath, modelName, acPath, acName, _dialogueData, _position, createdOwner, createdCB)
    if _position then
        _goPosition = _position;
    end
    self:CancelCreate()
    if self.modelPath ~= modelPath then
        self.loadModelPath = modelPath
        self.loadModelName = modelName
        self:Recycle()
    else
        if self.modelName ~= modelName then
            self.loadModelPath = modelPath
            self.loadModelName = modelName
            self:Recycle()
        end
    end

    if self.acPath ~= acPath then
        self.loadAcPath = acPath
        self.loadAcName = acName
    else
        if self.acName ~= acName then
            self.loadAcPath = acPath
            self.loadAcName = acName
        end
    end

    if _dialogueData then
        self._dialogueData = _dialogueData;
    end

    self.ownercb = createdOwner;
    self.cb = createdCB;

    if self.loadModelPath
            or self.loadModelName
            or self.loadAcPath
            or self.loadAcName
            or self._dialogueData then
        self:RefreshLoadSystem()
        self:BeginCreate()
    end
end

function ModelViewSystem:RefreshLoadSystem()
    self.loadSystem:RemoveLoadAllAsset()
    self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, self.loadModelPath, self.loadModelName)
    self.loadSystem:AddLoadAsset(Enum.ResourceType.AnimatorController, self.loadAcPath, self.loadAcName)
    self.loadSystem:AddLoadAsset(Enum.ResourceType.GameObject, Constants.ModelPath, _dialogueName)
end

function ModelViewSystem:PreloadedAssets()
    self:Create()
end

function ModelViewSystem:BeginCreate()
    self.loadSystem:Begin()
end

function ModelViewSystem:CancelCreate()
    self.loadModelPath = nil
    self.loadModelName = nil
    self.loadAcPath = nil
    self.loadAcName = nil
    self.ownercb = nil
    self.cb = nil

    self.loadSystem:Cancel()
end

function ModelViewSystem:Create()
    local newGo = nil
    if self.loadModelPath and self.loadModelName then
        newGo = ManagerContainer.ResMgr:GetGoFromPool(self.loadModelPath, self.loadModelName)
        self.modelPath = self.loadModelPath
        self.modelName = self.loadModelName
    end
    if self.loadAcPath and self.loadAcName then
        self.acPath = self.loadAcPath
        self.acName = self.loadAcName
        local go = newGo or self.modelGo
        if go then
            local animatorController = ManagerContainer.ResMgr:GetAsset(self.loadAcPath, self.loadAcName)
            local animator = go:GetComponent(Enum.TypeInfo.Animator)
            if not animator then
                animator = go:AddComponent(Enum.TypeInfo.Animator)
            end
            animator.runtimeAnimatorController = animatorController
        end
    end

    if newGo then
        self.modelGo = newGo
        self:SetGoPosition(_goPosition);

        self:SetDialogue();

        if self.ownercb and self.cb then
            self.cb(self.ownercb, newGo, true)
        end
    else
        if self.ownercb and self.cb then
            self.cb(self.ownercb, self.modelGo, true)
        end
    end

    self.ownercb = nil
    self.cb = nil
end

--冒泡对话
function ModelViewSystem:SetDialogue()
    if self._dialogueData then
        if not self._dialogueGo then
            local _newGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.ModelPath, _dialogueName);
            if not _newGo then
                LogError("冒泡预设的路径或者名字不对，请检查");
            else
                self._dialogueGo = _newGo;
            end
        end
        self._dialogueGo.gameObject:SetActive(false);
        local _scaleStr = GlobalConfig.Instance:GetConfigStrValue(164)
        local _scale = string.split(_scaleStr, ";")
        self._dialogueGo.transform.localScale = Vector3.New(tonumber(_scale[1]), tonumber(_scale[2]), tonumber(_scale[3]));
        local _parent = self.modelGo.transform:Find(self._dialogueData._dialogueParent);
        if not _parent then _parent = self.modelGo; end
        self._dialogueGo.transform:SetParent(_parent.transform);
        self:RemoveTimers();
        local _showDialogueText = function()
            self._dialogueGo.transform.localPosition = Vector3.zero;
            self._dialogueGo.transform:Find("Dialogue/Dialog/Text"):GetComponent("Text").text = self._dialogueData._textStr;
            self._dialogueGo.gameObject:SetActive(true);
        end
        self._dialogueStartTimer =  ManagerContainer.LuaTimerMgr:AddTimer(self._dialogueData._showStartTime, 1, self, _showDialogueText, nil);
        local _endDialogueText = function()
            --if not ManagerContainer.DataMgr.SignData:GetKeepDialogue() then
                self._dialogueGo.gameObject:SetActive(false);
            --end
        end
        self._dialogueEndTimer =  ManagerContainer.LuaTimerMgr:AddTimer(self._dialogueData._showEndTime, 1, self, _endDialogueText, nil);
    end
end

function ModelViewSystem:GetGameObject()
    return self.modelGo
end

function ModelViewSystem:RemoveTimers()
    if self._dialogueStartTimer then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self._dialogueStartTimer);
        self._dialogueStartTimer = nil;
    end
    if self._dialogueEndTimer then
        ManagerContainer.LuaTimerMgr:RemoveTimer(self._dialogueEndTimer);
        self._dialogueEndTimer = nil;
    end
end

function ModelViewSystem:SetGoPosition(_position)
    if _position then
        self.modelGo.transform.position = _position;
    end
end

return ModelViewSystem