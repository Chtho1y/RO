local RedPointSimpleMgr = class("RedPointSimpleMgr")

local rpTree = {}
local TypeGroup = {}
local SameTargetGroup = {}

local upLimit = 3
local curUpCount = 0
function RedPointSimpleMgr:ctor()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_FILLCONTENT_COMPELETED, self, self.FillContentCompeleted)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self.UICloseCompeleted)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.RED_POINT_MGR_NOTICE, self, self.RPNotify)
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.RED_POINT_UNLOCK_NTF, self, self.UnlockRefreshRP)

    self:InitTree()
end

function RedPointSimpleMgr:InitTree()
    local redPointCfgDatas = ManagerContainer.CfgMgr:GetUIRedPointCfgDatas()
    for k,v in pairs(redPointCfgDatas) do
        if Constant.OpenPay or not v.NoPay then
            if rpTree[v.Id] == nil then
                rpTree[v.Id] = {}
            end
            local treeNode = rpTree[v.Id]
            treeNode.data = v
            treeNode.state = false

            local key = v.UIId..v.FuncEnterPath
            if SameTargetGroup[key] == nil then
                SameTargetGroup[key] = {}
            end
            SameTargetGroup[key][v.Priority] = treeNode

            if v.RPNotifyType and v.RPNotifyType ~= Enum.RPNotifyType.None then
                if TypeGroup[v.RPNotifyType] == nil then
                    TypeGroup[v.RPNotifyType] = {}
                end
                TypeGroup[v.RPNotifyType][v.Id] = treeNode
            end

            treeNode.sameGroup = SameTargetGroup[key]
        end
    end
    for k,v in pairs(redPointCfgDatas) do
        if Constant.OpenPay or not v.NoPay then
            local treeNode = rpTree[v.Id]
            if treeNode and treeNode.data.UpNode then
                if treeNode.upNodes == nil then
                    treeNode.upNodes = {}
                end

                for _,v1 in pairs(treeNode.data.UpNode) do
                    treeNode.upNodes[#treeNode.upNodes + 1]= rpTree[v1]

                    if rpTree[v1].downNodes == nil then
                        rpTree[v1].downNodes = {}
                    end

                    rpTree[v1].downNodes[#rpTree[v1].downNodes + 1] = treeNode
                end
            end
        end
    end
end

function RedPointSimpleMgr:RPNotify(rpType, result, param)
    curUpCount = 0
    if type(result) ~= "boolean" then
        result = result > 0
    end
    local treeNode = TypeGroup[rpType]
    if treeNode then
        for _,v in pairs(treeNode) do
            --local unlockState = true
            --if v.data.FuncLock > 0 then
            --    unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(v.data.FuncLock)
            --end
            --if unlockState then
            if param ~= nil then
                if v.stateGroup == nil then
                    v.stateGroup = {}
                end
                v.stateGroup[param] = result
                local state1 = false
                for _,v1 in pairs(v.stateGroup) do
                    if v1 then
                        state1 = true
                    end
                end
                v.state = state1
            else
                v.state = result
            end
            self:RefreshRedPointDisplayPriority(v, true)
            if v.upNodes then
                for _,v1 in pairs(v.upNodes) do
                    self:RefreshUpNodeState(v1)
                end
            end
            --end
        end
    end
end

function RedPointSimpleMgr:CheckRPStateByType(rpType)
    local treeNode = TypeGroup[rpType]
    local state = false

    if not treeNode then return state end
    for _,v in pairs(treeNode) do
        if v.stateGroup then
            local state1 = false
            for _,v1 in pairs(v.stateGroup) do
                if v1 then
                    state1 = true
                end
            end
            state = state1
        else
            state = v.state
        end
        break
    end
    return state
end

function RedPointSimpleMgr:RefreshUpNodeState(treeNode)
    curUpCount = curUpCount + 1
    if curUpCount > 3 then
        LogError(treeNode.data.Id.." redpoint  recursive error")
        return
    end
    if treeNode.downNodes then
        local state = false
        for _,v in pairs(treeNode.downNodes) do
            if v.state then
                state = true
                break
            end
        end

        treeNode.state = state
        self:RefreshRedPointDisplayPriority(treeNode, true)
    end

    if treeNode.upNodes then
        for _,v1 in pairs(treeNode.upNodes) do
            self:RefreshUpNodeState(v1)
        end
    end
end

function RedPointSimpleMgr:CheckRPState(treeNode)
    if treeNode.stateGroup then
        for _,v1 in pairs(treeNode.stateGroup) do
            if v1 then
                return true
            end
        end
    else
        return treeNode.state
    end
end

function RedPointSimpleMgr:CheckRPLockState(treeNode)
    local unlockState = true
    if treeNode.data.FuncLock > 0 then
        unlockState = ManagerContainer.UIFuncUnlockMgr:GetFuncLockStatusById(treeNode.data.FuncLock)
    end
    return unlockState
end

function RedPointSimpleMgr:RefreshRedPointDisplayPriority(treeNode, needCheckLock)
    if needCheckLock then
        local unlockState = self:CheckRPLockState(treeNode)
        if not unlockState then
            return
        end
    end
    local state = false
    if #treeNode.sameGroup == 0 then
        if treeNode.target == nil then
            return
        end
        local state1 = false
        if treeNode.stateGroup then
            for _,v1 in pairs(treeNode.stateGroup) do
                if v1 then
                    state1 = true
                end
            end
        else
            state1 = treeNode.state
        end
        treeNode.target:SetActive(state1)
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_PAGE_REDPOINT_NTF,treeNode.data.Id,state1)
        return
    end

    local hasDisplay = false
    for i = 1, #treeNode.sameGroup do
        local v = treeNode.sameGroup[i]
        if v then
            local state1 = false
            if not state then
                if v.stateGroup then
                    for _,v1 in pairs(v.stateGroup) do
                        if v1 then
                            state1 = true
                        end
                    end
                else
                    state1 = v.state
                end
                if state1 then
                    state = true
                end
            else
                state1 = v.state
            end

            if v.target then
                if state1 and needCheckLock then
                    local unlockState = self:CheckRPLockState(v)
                    if unlockState and not hasDisplay then
                        hasDisplay = true
                    else
                        state1 = false
                    end
                    v.target:SetActive(state1)
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_PAGE_REDPOINT_NTF,treeNode.data.Id,state1)
                else
                    if state1 and not hasDisplay then
                        hasDisplay = true
                    else
                        state1 = false
                    end
                    v.target:SetActive(state1)
                    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_PAGE_REDPOINT_NTF,treeNode.data.Id,state1)
                end
            end
        end
    end
end

function RedPointSimpleMgr:FillContentCompeleted(wnd)
    local list = ManagerContainer.CfgMgr:GetUIRedPointCfgDataByUIId(wnd.uiData.id)
    for k,v in pairs(list) do
        if Constant.OpenPay or not v.NoPay then
            local treeNode = rpTree[v.Id]
            if treeNode then
                local data = treeNode.data
                local target = CommonUtil.ParseUITargetPath(wnd, data.FuncEnterPath)
                if target then
                    local redPointGo = target.transform:Find("redPoint"..data.Id)
                    if not redPointGo then
                        redPointGo = ManagerContainer.ResMgr:GetGoFromPool(Constants.UICommonPath, Enum.RPPrefab[data.RPType])
                    else
                        redPointGo = redPointGo.gameObject
                    end
                    if redPointGo then
                        redPointGo.name = "redPoint"..data.Id
                        redPointGo.transform:SetParent(target.transform)
                        local rectTrans = redPointGo:GetComponent(Enum.TypeInfo.RectTransform)
                        rectTrans.anchoredPosition3D = Vector3(data.Position[1], data.Position[2], 0)
                        redPointGo.transform.localScale = Vector3.one
                        treeNode.target = redPointGo

                        if data.UIId == Enum.UIPageName.UIPrivateChatBtn then
                            redPointGo.transform:SetAsFirstSibling()
                        end

                        redPointGo:SetActive(false)
                        self:RefreshRedPointDisplayPriority(treeNode, true)
                    end
                end
            end
        end
    end
end

function RedPointSimpleMgr:UICloseCompeleted(wnd)
    local list = ManagerContainer.CfgMgr:GetUIRedPointCfgDataByUIId(wnd.uiData.id)
    for k,v in pairs(list) do
        if Constant.OpenPay or not v.NoPay then
            local treeNode = rpTree[v.Id]
            if treeNode then
                ManagerContainer.ResMgr:RecycleGO(Constants.UICommonPath, Enum.RPPrefab[treeNode.data.RPType], treeNode.target)
                treeNode.target = nil
            end
        end
    end
end

function RedPointSimpleMgr:UnlockRefreshRP(ids)
    local treeNode
    for k,v in pairs(ids) do
        local funcCfgData = ManagerContainer.CfgMgr:GetUIFuncUnLockCfgDataById(v)
        if funcCfgData.RefreshRP ~= nil then
            for _,v1 in pairs(funcCfgData.RefreshRP) do
                treeNode = rpTree[v1]
                if treeNode then
                    self:RefreshRedPointDisplayPriority(treeNode, true)
                end
            end
        end
    end
end

function RedPointSimpleMgr:CheckRPStateById(id)
    if not rpTree[id] then return false end
    return rpTree[id].state
end

function RedPointSimpleMgr:Destroy()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_FILLCONTENT_COMPELETED, self, self.FillContentCompeleted)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.UI_CLOSE_COMPELETED, self, self.UICloseCompeleted)
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.RED_POINT_MGR_NOTICE, self, self.RPNotify)

    rpTree = nil
    TypeGroup = nil
    SameTargetGroup = nil
end

return RedPointSimpleMgr