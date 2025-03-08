local UIFuncUnlockMgr = class("UIFuncUnlockMgr")
local ConditionJudge = require("Common/ConditionJudge")

local lockLevels = {}
local funcBtns = {}
local curOpened = {}

local loggedinLevelId = 10001

local dir = Vector3.zero
function UIFuncUnlockMgr:ctor()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_FILLCONTENT_COMPELETED, self, self.FillContentCompeleted)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self.UICloseCompeleted)

    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_FUNCLOCK_OPEN_NTF, self, self.UINewLevelFuncOpen)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_VIP_FUNCLOCK_OPEN_NTF, self, self.UIFuncOpen)

    self:InitLockLevels()
end

function UIFuncUnlockMgr:InitLockLevels()
    local cfgs = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgAllDatas()
    for _, v in pairs(cfgs) do
        if v.PrePose == 0 then
            local conds = v.UnlockCond
            if conds then
                for i = 1, #conds do
                    local cond = conds[i]
                    if cond then
                        if cond[1] == Enum.TaskType.Level_Battle_Count then
                            if not CommonUtil.EleInTable(cond[2], lockLevels) then
                                lockLevels[#lockLevels + 1] = cond[2]
                            end
                        end
                    end
                end
            end
            -- for _,v1 in pairs(conds) do
            --    local conditionData = ManagerContainer.CfgMgr:GetCondDataById(v1)
            --
            --    local condition = conditionData.Condition
            --    if condition[1] == Enum.TaskType.Base_Level then
            --
            --    elseif condition[1] == Enum.TaskType.Level_Battle_Count then
            --        if not CommonUtil.EleInTable(condition[2], lockLevels) then
            --            lockLevels[#lockLevels + 1]= condition[2]
            --        end
            --    end
            -- end
        end
    end
end

function UIFuncUnlockMgr:SaveNeedDisplayNewFuncStatus(status)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetInt(tostring(uid) .. "NewFunc", status and 1 or 0)
end

function UIFuncUnlockMgr:GetNeedDisplayNewFuncStatus()
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local result = UnityEngine.PlayerPrefs.GetInt(tostring(uid) .. "NewFunc", 0)
    return result == 1
end

function UIFuncUnlockMgr:SaveLockBubbleStatus(id, status)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    UnityEngine.PlayerPrefs.SetInt(tostring(uid) .. "LockBubble" .. id, status and 1 or 0)
end

function UIFuncUnlockMgr:GetLockBubbleStatus(id)
    local uid = ManagerContainer.DataMgr.UserData:GetUserId()
    local result = UnityEngine.PlayerPrefs.GetInt(tostring(uid) .. "LockBubble" .. id, 0)
    return result == 1
end

function UIFuncUnlockMgr:NeedOpenFuncCurLevelStart(levelId)
    return CommonUtil.EleInTable(levelId, lockLevels) and levelId >= loggedinLevelId
end

function UIFuncUnlockMgr:SetLoggedinLevelId(levelId)
    loggedinLevelId = levelId
end

function UIFuncUnlockMgr:FillContentCompeleted(wnd)
    local list = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataByUIId(wnd.uiData.id)
    for _, v in pairs(list) do
        self:InsertFuncController(wnd, v)
    end
end

function UIFuncUnlockMgr:InsertFuncController(wnd, data)
    if data.PrePose > 0 and
        (not CommonUtil.EleInTable(data.PrePose, curOpened) or CommonUtil.EleInTable(data.Id, curOpened)) then
        return
    end

    local target = CommonUtil.ParseUITargetPath(wnd, data.FuncEnterPath)
    if target == nil then
        return
    end

    if type(target) == "table" then
        target = target.gameObject
    end

    local conds = data.UnlockCond
    if not conds then
        return
    end
    local result = self:CheckConditionPassResult(data)
    local isLoggedinLevelId = false
    for _, cond in pairs(conds) do
        if cond[1] == Enum.TaskType.Level_Battle_Count then
            if result and loggedinLevelId == cond[2] and tonumber(cond[2]) ~= 10001 then
                isLoggedinLevelId = true
            end
            if not isLoggedinLevelId and tonumber(cond[2]) <= loggedinLevelId and tonumber(loggedinLevelId) ~= 10001 then
                curOpened[#curOpened + 1] = data.Id
            end
        end
    end

    -- for _,v in pairs(conds) do
    --    local result1, condDsc, type = ConditionJudge:ConditionPassResult(v)
    --    cond = condDsc
    --    if result1 and type == Enum.TaskType.Level_Battle_Count and loggedinLevelId == condDsc then
    --        isLoggedinLevelId = true
    --    end
    --    if not result1 then
    --        result = false
    --    end
    -- end

    local key = "self." .. data.FuncEnterPath
    if funcBtns[wnd.uiData.id] == nil then
        funcBtns[wnd.uiData.id] = {}
    end

    local guideState = self:GetLockBubbleStatus(data.Id)

    if result == true then
        if funcBtns[wnd.uiData.id][key] == nil then
            if not guideState then
                target:SetActive(true)
                return
            elseif isLoggedinLevelId and not guideState then
                target:SetActive(true)
                return
            elseif not isLoggedinLevelId and CommonUtil.EleInTable(data.Id, curOpened) and not guideState then
                target:SetActive(true)
                return
            end
        else
            -- if not guideState then
            --    target:SetActive(true)
            --    local parent = target.transform.parent
            --    local lock = target.transform:Find(target.name.."_lock")
            --    if lock == nil then
            --        lock = parent:Find(target.name.."_lock")
            --    end
            --    if lock then
            --        lock.gameObject:SetActive(false)
            --    end
            --    return
            -- end
        end
    end

    if not data.Special then
        self:NormalLock(wnd, data, target, result, key, guideState, conds)
    else
        self:SpecialLock(wnd, data, target, result, key, guideState, conds)
    end

end

function UIFuncUnlockMgr:NormalLock(wnd, data, target, result, key, guideState, conds)
    local parent = target.transform.parent
    local lock = target.transform:Find(target.name .. "_lock")

    target:SetActive(result or (not result and data.NeedDisplay))
    if result and not guideState then
        local parent = target.transform.parent
        local lock = target.transform:Find(target.name .. "_lock")
        if lock == nil then
            lock = parent:Find(target.name .. "_lock")
        end
        if lock then
            lock.gameObject:SetActive(false)
        end
        return
    end

    local go
    if lock == nil then
        lock = parent:Find(target.name .. "_lock")
    end
    if lock == nil then
        local targetSize = target:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta
        go = UnityEngine.GameObject.New(target.name .. "_lock")
        go.transform:SetParent(target.transform)
        go.transform.localPosition = Vector3.zero
        go.transform.localScale = Vector3.one

        local rectTrans = go:GetOrAddComponent(Enum.TypeInfo.RectTransform)
        rectTrans.sizeDelta = targetSize
    end
    if lock == nil and go ~= nil then
        lock = go.transform
    end

    if funcBtns[wnd.uiData.id][key] == nil then
        funcBtns[wnd.uiData.id][key] = {}
    end
    funcBtns[wnd.uiData.id][key]["target"] = target
    funcBtns[wnd.uiData.id][key]["data"] = data
    funcBtns[wnd.uiData.id][key]["lock"] = lock

    funcBtns[wnd.uiData.id][key]["needGuide"] = data.NeedGuide
    if not result and not guideState then
        self:SaveLockBubbleStatus(data.Id, data.NeedGuide)
    end

    if lock == nil or tolua.isnull(lock) then
        -- LogError(data.Id.."  has no lock target")
        return
    end

    local lockBtn = lock:Find("btn")
    local lockBubble = lock:Find("bubble")
    if lockBtn == nil then
        go = nil
        local targetSize = target:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta
        go = UnityEngine.GameObject.New("btn")
        go.transform:SetParent(lock.transform)
        go.transform.localPosition = Vector3.zero
        go.transform.localScale = Vector3.one
        local rectTrans = go:GetOrAddComponent(Enum.TypeInfo.RectTransform)
        rectTrans.sizeDelta = targetSize

        go:GetOrAddComponent(Enum.TypeInfo.UIRaycastNoDraw).raycastTarget = false
        go:GetOrAddComponent(Enum.TypeInfo.Button)
    end
    if lockBtn == nil and go ~= nil then
        lockBtn = go.transform
    end
    lockBtn.gameObject:SetActive(not result and data.NeedMask)

    if lockBubble == nil then
        go = nil
        local targetSize = target:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta
        go = UnityEngine.GameObject.New("bubble")
        go.transform:SetParent(lock.transform)
        go.transform.localPosition = Vector3.zero
        go.transform.localScale = Vector3.one
        local rectTrans = go:GetOrAddComponent(Enum.TypeInfo.RectTransform)
        rectTrans.sizeDelta = targetSize

        go:GetOrAddComponent(Enum.TypeInfo.UIRaycastNoDraw).raycastTarget = false
        go:GetOrAddComponent(Enum.TypeInfo.Button)
    end
    if lockBubble == nil and go ~= nil then
        lockBubble = go.transform
    end
    lockBubble.gameObject:SetActive(result and funcBtns[wnd.uiData.id][key]["needGuide"])
    local dscText = lockBubble:Find("Talk/bg/Text")
    if dscText ~= nil then
        local text = dscText:GetComponent(Enum.TypeInfo.Text)
        text.text = I18N.T(data.LockDsc)
    end

    lock.gameObject:SetActive((not result or (result and funcBtns[wnd.uiData.id][key]["needGuide"])) and data.NeedLock)
    if not result then
        local button1 = target:GetComponent(Enum.TypeInfo.Button)
        if button1 then
            local image = target:GetComponent(Enum.TypeInfo.Image)
            if image then
                image.raycastTarget = false
            end
        else
            button1 = target:GetComponent(Enum.TypeInfo.Toggle)
            if button1 then
                button1.graphic.raycastTarget = false
            end
        end
        if lockBtn then
            local button = lockBtn:GetComponent(Enum.TypeInfo.Button)
            if button == nil then
                button = lockBtn.gameObject:GetOrAddComponent(Enum.TypeInfo.Button)
            end
            wnd.uiBase:AddButtonUniqueEventListener(button, wnd, function(button, params)
                local result, val, content = self:CheckConditionPassResult(data)
                if not result then
                    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content .. I18N.T(data.FunName) .. I18N.T("Fun"))
                end
            end)
        end
        if lockBubble and funcBtns[wnd.uiData.id][key]["needGuide"] then
            local button = lockBubble:GetComponent(Enum.TypeInfo.Button)
            if button == nil then
                button = lockBubble.gameObject:GetOrAddComponent(Enum.TypeInfo.Button)
            end
            wnd.uiBase:AddButtonUniqueEventListener(button, wnd, function(button, params)
                if target then
                    self:SaveLockBubbleStatus(data.Id, false)
                    funcBtns[wnd.uiData.id][key] = nil

                    target:SetActive(true)

                    lock.gameObject:SetActive(false)

                    curOpened[#curOpened + 1] = data.Id

                    local button1 = target:GetComponent(Enum.TypeInfo.Button)
                    if button1 then
                        button1.onClick:Invoke()
                    else
                        button1 = target:GetComponent(Enum.TypeInfo.Toggle)
                        button1.onValueChanged:Invoke(true)
                    end

                    local nextFuncData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(data.PostPose)
                    if nextFuncData and wnd.uiData.id == nextFuncData.UIId then
                        self:InsertFuncController(wnd, nextFuncData)
                    end
                end
            end)
        end
    else
        if lockBubble and funcBtns[wnd.uiData.id][key]["needGuide"] then
            local button = lockBubble:GetComponent(Enum.TypeInfo.Button)
            if button == nil then
                button = lockBubble.gameObject:GetOrAddComponent(Enum.TypeInfo.Button)
            end
            wnd.uiBase:AddButtonUniqueEventListener(button, wnd, function(button, params)
                if target then
                    self:SaveLockBubbleStatus(data.Id, false)
                    funcBtns[wnd.uiData.id][key] = nil
                    local button1 = target:GetComponent(Enum.TypeInfo.Button)

                    target:SetActive(true)

                    lock.gameObject:SetActive(false)

                    curOpened[#curOpened + 1] = data.Id

                    if button1 then
                        if button1.onClick then
                            button1.onClick:Invoke()
                        elseif button1.onValueChanged then
                            button1.onValueChanged:Invoke(true)
                        end
                    end

                    local nextFuncData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(data.PostPose)
                    if nextFuncData and wnd.uiData.id == nextFuncData.UIId then
                        self:InsertFuncController(wnd, nextFuncData)
                    end
                end
            end)
        end
    end
end

-- 只用于主城的建筑
function UIFuncUnlockMgr:SpecialLock(wnd, data, target, result, key, guideState, conds)

    local function InitTitle(lock, targetButtonField, targetTitle, textContent)
        local title = lock.transform:Find("Title")
        title.transform.position = targetTitle.transform.position
        local titleText = title:Find("Text")
        titleText:GetComponent(Enum.TypeInfo.TextMeshProUGUI).text = textContent

        local rectSize = targetButtonField:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta
        local lockButtonField = lock.transform:Find("TargetBox")
        lockButtonField.transform.position = targetButtonField.transform.position
        lockButtonField:GetComponent(Enum.TypeInfo.RectTransform).sizeDelta = rectSize
    end

    local targetButtonField = target.transform:Find("TargetBox")
    local targetTitle = target.transform:Find("Title")
    local textContent = targetTitle:Find("Text"):GetComponent(Enum.TypeInfo.TextMeshProUGUI).text

    targetTitle.gameObject:SetActive(result or (not result and data.NeedDisplay))

    if result and not guideState then
        local lockBtn = target.transform:Find("LockbtnItem")
        if lockBtn then
            lockBtn.gameObject:SetActive(false)
        end
        local lockBubble = target.transform:Find("LockBubbleItem")
        if lockBubble then
            lockBubble.gameObject:SetActive(false)
        end
        return
    end

    local lockBtn = target.transform:Find("LockbtnItem")
    if not result and data.NeedMask then
        if lockBtn == nil then
            lockBtn = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, "LockbtnItem")
            lockBtn.name = "LockbtnItem"
            lockBtn.transform:SetParent(target.transform)
            lockBtn.transform.localPosition = Vector3.zero
            lockBtn.transform.localScale = Vector3.one

            InitTitle(lockBtn, targetButtonField, targetTitle, textContent)
        end

        local lockButton = lockBtn.gameObject:GetOrAddComponent(Enum.TypeInfo.Button)
        if lockButton then
            wnd.uiBase:AddButtonUniqueEventListener(lockButton, wnd, function(button, params)
                local result, val, content = self:CheckConditionPassResult(data)
                if not result then
                    ManagerContainer.LuaUIMgr:ErrorNoticeDisplay(content .. I18N.T(data.FunName) .. I18N.T("Fun"))
                end
            end)
        end
        lockBtn.gameObject:SetActive(true)
    else
        if lockBtn then
            lockBtn.gameObject:SetActive(false)
        end
    end

    if funcBtns[wnd.uiData.id][key] == nil then
        funcBtns[wnd.uiData.id][key] = {}
    end
    funcBtns[wnd.uiData.id][key]["target"] = target
    funcBtns[wnd.uiData.id][key]["data"] = data
    funcBtns[wnd.uiData.id][key]["lockBtn"] = lockBtn

    funcBtns[wnd.uiData.id][key]["needGuide"] = data.NeedGuide
    if not result and not guideState then
        self:SaveLockBubbleStatus(data.Id, data.NeedGuide)
    end

    local lockBubble = target.transform:Find("LockBubbleItem")
    if result and funcBtns[wnd.uiData.id][key]["needGuide"] then
        if lockBubble == nil then
            lockBubble = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, "LockBubbleItem")
            lockBubble.name = "LockBubbleItem"
            lockBubble.transform:SetParent(target.transform)
            lockBubble.transform.localPosition = Vector3.zero
            lockBubble.transform.localScale = Vector3.one

            local canvas = lockBubble:GetComponent(Enum.TypeInfo.Canvas)
            if canvas then
                canvas.overrideSorting = true
                canvas.sortingOrder = Enum.UISibling[Enum.UIType.MAIN + 1] - 1
            end

            InitTitle(lockBubble, targetButtonField, targetTitle, textContent)

            local light = lockBubble.transform:Find("BtnLightItem")
            light.transform.position = targetTitle.transform.position

            local talk = lockBubble.transform:Find("Talk")
            local vec2 = data.DscPos and Vector2(data.DscPos[1], data.DscPos[2]) or Vector2.zero
            talk:GetComponent(Enum.TypeInfo.RectTransform).anchoredPosition = vec2

            local arrowUp = talk.transform:Find("bg/upArrow")
            local arrowDown = talk.transform:Find("bg/downArrow")
            local arrowLeft = talk.transform:Find("bg/leftArrow")
            local arrowRight = talk.transform:Find("bg/rightArrow")
            arrowUp.gameObject:SetActive(data.ArrowDir == 1)
            arrowDown.gameObject:SetActive(data.ArrowDir == 2)
            arrowLeft.gameObject:SetActive(data.ArrowDir == 3)
            arrowRight.gameObject:SetActive(data.ArrowDir == 4)

            local talkContent = talk.transform:Find("bg/Text")
            talkContent:GetComponent(Enum.TypeInfo.Text).text = I18N.T(data.LockDsc)
        end

        local lockButton = lockBubble.gameObject:GetOrAddComponent(Enum.TypeInfo.Button)
        if lockButton then
            wnd.uiBase:AddButtonUniqueEventListener(lockButton, wnd, function(button, params)
                if target then
                    self:SaveLockBubbleStatus(data.Id, false)

                    target:SetActive(true)

                    local lockBtn = funcBtns[wnd.uiData.id][key]["lockBtn"]
                    if lockBtn then
                        lockBtn.gameObject:SetActive(false)
                    end

                    local lockBubble = funcBtns[wnd.uiData.id][key]["lockBubble"]
                    if lockBubble then
                        lockBubble.gameObject:SetActive(false)
                    end

                    targetTitle.gameObject:SetActive(true)

                    curOpened[#curOpened + 1] = data.Id

                    local button1 = target:GetComponent(Enum.TypeInfo.Button)
                    if button1 then
                        button1.onClick:Invoke()
                    end

                    local nextFuncData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(data.PostPose)
                    if nextFuncData and wnd.uiData.id == nextFuncData.UIId then
                        self:InsertFuncController(wnd, nextFuncData)
                    end

                    funcBtns[wnd.uiData.id][key] = nil
                end
            end)
        end
        lockBubble.gameObject:SetActive(true)
    else
        if lockBubble then
            lockBubble.gameObject:SetActive(false)
        end
    end

    funcBtns[wnd.uiData.id][key]["lockBubble"] = lockBubble
end

function UIFuncUnlockMgr:UICloseCompeleted(wnd)
    if funcBtns[wnd.uiData.id] == nil then
        return
    end

    for k, v in pairs(funcBtns[wnd.uiData.id]) do
        v["target"] = nil
        -- v["data"] = nil
        v["lock"] = nil
        v["lockBtn"] = nil
        v["lockBubble"] = nil
    end
end

---通关关卡后的解锁通知
function UIFuncUnlockMgr:UINewLevelFuncOpen(type)
    self:SaveNeedDisplayNewFuncStatus(true)

    self:UIFuncOpen(type)
end

function UIFuncUnlockMgr:UIFuncOpen(type)
    for k, v in pairs(funcBtns) do
        for k1, v1 in pairs(v) do
            if v1.target and not v1.data.IsOperations then
                local result = self:CheckConditionPassResult(v1.data)
                if result then
                    v1.target:SetActive(true)
                    local button1 = v1.target:GetComponent(Enum.TypeInfo.Button)
                    if button1 then
                        local image = v1.target:GetComponent(Enum.TypeInfo.Image)
                        if image then
                            image.raycastTarget = true
                        end
                    else
                        button1 = v1.target:GetComponent(Enum.TypeInfo.Toggle)
                        if button1 then
                            button1.graphic.raycastTarget = true
                        end
                    end
                    if not v1.data.Special then
                        if v1.lock then
                            local lockBtn = v1.lock:Find("btn")
                            local lockBubble = v1.lock:Find("bubble")
                            if lockBtn then
                                lockBtn.gameObject:SetActive(false)
                            end
                            if lockBubble then
                                lockBubble.gameObject:SetActive(v1["needGuide"])
                            end
                            v1.lock.gameObject:SetActive(v1["needGuide"] and v1.data.NeedLock)
                        end
                    else
                        if v1.lock then
                            local lockBtn = v1.lockBtn
                            local lockBubble = v1.lockBubble
                            if lockBtn then
                                lockBtn.gameObject:SetActive(false)
                            end
                            if lockBubble then
                                lockBubble.gameObject:SetActive(v1["needGuide"])
                            end
                            local targetTitle = v1.target.transform:Find("Title")
                            targetTitle.gameObject:SetActive(not v1["needGuide"])
                        end
                    end
                    if not v1["needGuide"] then
                        curOpened[#curOpened + 1] = v1["data"].Id
                    end
                    v1["target"] = nil
                    -- v1["data"] = nil
                    v1["lock"] = nil
                    v1["lockBtn"] = nil
                    v1["lockBubble"] = nil
                end
            end
        end
    end
end

function UIFuncUnlockMgr:GetTargetFuncLockStatus(wnd, target)
    if funcBtns[wnd.uiData.id] == nil then
        return false
    end

    for k, v in pairs(funcBtns[wnd.uiData.id]) do
        if v["target"] == target then
            return true
        end
    end

    return false
end

-- 获得是否已经解锁
function UIFuncUnlockMgr:GetFuncLockStatusById(id, keepSrcContent)
    local data = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(id)
    if data == nil then
        return true
    end
    if data.PrePose > 0 and CommonUtil.EleInTable(data.PrePose, curOpened) and CommonUtil.EleInTable(data.Id, curOpened) then
        return false
    end

    local result, val, content = self:CheckConditionPassResult(data)
    if not result and content and not keepSrcContent then
        content = content .. I18N.T(data.FunName) .. I18N.T("Fun")
    end
    return result, val, content
end

function UIFuncUnlockMgr:GetNewFuncAndNearFuncByLevelId(levelId)
    self:SaveNeedDisplayNewFuncStatus(false)

    local newFuncs, nearFuncs, forceGuideList = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgNewAndNearLevelId(levelId)
    return newFuncs, nearFuncs, forceGuideList
end

function UIFuncUnlockMgr:CheckConditionPassResult(data)
    local conds = data.UnlockCond
    if not conds then
        return true, 0, ''
    end
    local result, val, content
    if data.LuaCondition and data.LuaCondition ~= "" then
        result = false
        local luaCondition = require("FuncUnlockCondition/" .. data.LuaCondition)
        if luaCondition.CheckCondition then
            result, val, content = luaCondition:CheckCondition(data)
        end
    else
        result = true
        local result1, val1, content1
        for i = 1, #conds do
            local cond = conds[i]
            if cond then
                result1, val1, content1 = ConditionJudge:ConditionPassResult1(cond)
                if not result1 then
                    result = false
                    if content1 and content1 ~= '' then
                        val = val1
                        content = content1
                        break
                    end
                end
            end
        end
    end
    return result, val, content
end

function UIFuncUnlockMgr:Clear()
    -- self:AutoSaveBubbleLockState()
    funcBtns = nil
    lockLevels = nil
    curOpened = nil
end

function UIFuncUnlockMgr:AutoSaveBubbleLockState()
    for _, v in pairs(funcBtns) do
        for _, v1 in pairs(v) do
            self:SaveLockBubbleStatus(v1.data.Id, false)
        end
    end
end

function UIFuncUnlockMgr:Destroy()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_FILLCONTENT_COMPELETED, self,
        self.FillContentCompeleted)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self.UICloseCompeleted)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_FUNCLOCK_OPEN_NTF, self, self.UIFuncOpen)

    self:Clear()

    if tolua.getpeer(self) ~= nil then
        tolua.setpeer(self, nil)
    end
end

return UIFuncUnlockMgr
