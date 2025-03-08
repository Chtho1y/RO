module("CommonUtil", package.seeall);

function GetMetatableLua(obj)
    return getmetatable(obj)
end

function StringConcat(...)
    local list = {...}
    local result = ""
    for i = 1, #list do
        result = result .. tostring(list[i])
    end
    return result
end

function BindGridViewItem2LuaStatic(name, go)
    if go == nil or tolua.isnull(go) then
        return nil
    end

    local lua = require("GridViewItem/"..name.."_Generate"):new()
    if lua ~= nil then
        lua.gameObject = go
        lua:InitGenerate(go.transform)
    else
        lua = go
    end
    return lua
end

function BindGridViewItem2Lua(wndOwner, name, go)
    if wndOwner.gridItemList == nil then
        wndOwner.gridItemList = {}
    end
    if wndOwner.gridItemList[name] == nil then
        wndOwner.gridItemList[name] = {}
    end
    if go == nil or tolua.isnull(go) then
        return nil
    end
    local lua = wndOwner.gridItemList[name][go]
    if not lua then
        lua = require("GridViewItem/"..name.."_Generate"):new()
        wndOwner.gridItemList[name][go] = lua
        lua.gameObject = go
        lua:InitGenerate(go.transform)
    end
    return lua
end

function GetBindGridViewItem2Lua(wndOwner, name, go)
    if wndOwner.gridItemList == nil then
        return nil
    end
    if wndOwner.gridItemList[name] == nil then
        return nil
    end
    return wndOwner.gridItemList[name][go]
end

function ClearBindGridViewItem2Lua(wndOwner, name, go)
    if wndOwner.gridItemList == nil then
        return
    end
    if wndOwner.gridItemList[name] == nil then
        return
    end
    local itemLua = wndOwner.gridItemList[name][go]
    if not itemLua then return end
    if itemLua.uIEffectCfg then
        itemLua.uIEffectCfg:Clean()
    end
    itemLua:GenerateDestroy()
    itemLua.uiParticle = nil
    itemLua.gameObject = nil
    itemLua.transform = nil
    wndOwner.gridItemList[name][go] = nil
end

function ClearGridViewItem(wndOwner, name)
    if wndOwner.gridItemList == nil then
        return
    end
    if wndOwner.gridItemList[name] == nil then
        return
    end
    for k,v in pairs(wndOwner.gridItemList[name]) do
        if v.uIEffectCfg then
            v.uIEffectCfg:Clean()
        end
        v:GenerateDestroy()
        v.uiParticle = nil
        v.gameObject = nil
        v.transform = nil
    end
    wndOwner.gridItemList[name] = nil
end

function SetCanvasGroupStatus(go, status)
    --local canvasGroup = go:GetOrAddComponent(Enum.TypeInfo.CanvasGroup)
    --canvasGroup.alpha = status and 1 or 0
    --canvasGroup.interactable = status and true or false
    --canvasGroup.blocksRaycasts = status and true or false
    go:SetActive(status)
end

function LoopGridViewEleCreate(wndOwner, loopScrollRect, gridLayoutGroup, list, interTime, updateCB, needWhole, svRectTransform)
    LoopGridViewEleCreateNew(wndOwner, loopScrollRect, gridLayoutGroup, list, interTime, nil,updateCB, needWhole, svRectTransform)
end

function LoopGridViewEleCreateNew(wndOwner, loopScrollRect, gridLayoutGroup, list, interTime, luaTbl,updateCB, needWhole, svRectTransform,movePos)
    if loopScrollRect == nil then return end

    if needWhole then
        loopScrollRect.totalCount = math.ceil(#list / loopScrollRect.contentConstraintCount)
        local elm = loopScrollRect.Cell:GetComponent(Enum.TypeInfo.LayoutElement)
        local height = loopScrollRect.totalCount * elm.preferredHeight
        local oriSize = svRectTransform.sizeDelta
        oriSize.y = height
        svRectTransform.sizeDelta = oriSize
    end

    local function getRefreshCount()
        local count = loopScrollRect.totalCount * loopScrollRect.contentConstraintCount
        return count >= #list and #list or count
    end

    local gridViewItem = loopScrollRect.Cell:GetComponent(Enum.TypeInfo.UIGridViewMark)
    local name = gridViewItem and gridViewItem.GridItemName or loopScrollRect.Cell.name

    local needInter = interTime > 0
    local refreshCount = getRefreshCount()
    
    --处理gird生成
    local OnUpdate = function (owner, go, idx)
        go.name = idx
        local itemLua = CommonUtil.BindGridViewItem2Lua(wndOwner, name, go)
        itemLua.prefabName = name
        if needInter then
            CommonUtil.SetCanvasGroupStatus(itemLua.gameObject, false)
            ManagerContainer.LuaTimerMgr:AddTimer(interTime * idx, 1, false, function(sequence, param)
                CommonUtil.SetCanvasGroupStatus(itemLua.gameObject, true)
            end, nil)

            if idx == refreshCount - 1 then
                needInter = false
            end
        end

        if luaTbl~= nil then
            updateCB(luaTbl,itemLua, idx,list[idx+1])
        else
            updateCB(itemLua, idx,list[idx+1])
        end
    end
	loopScrollRect:SetUpdateCellCallback(wndOwner, OnUpdate);

    if loopScrollRect.content.childCount > 0 then
        --loopScrollRect:ClearCells();
    end
    loopScrollRect.totalCount = #list;
    if movePos == nil then
        loopScrollRect:MoveTo(0);
        loopScrollRect:RefreshCells()
    else
        -- loopScrollRect:MoveTo(movePos)
        loopScrollRect:SetItemStartIdx(movePos)
    end
end

function LoopGridViewEleCreateWithList(wndOwner, loopScrollRect, gridLayoutGroup, list, interTime, luaTbl,updateCB, needWhole, svRectTransform,movePos)
    if loopScrollRect == nil then return end

    if needWhole then
        loopScrollRect.totalCount = math.ceil(list.Count / loopScrollRect.contentConstraintCount)
        local elm = loopScrollRect.Cell:GetComponent(Enum.TypeInfo.LayoutElement)
        local height = loopScrollRect.totalCount * elm.preferredHeight
        local oriSize = svRectTransform.sizeDelta
        oriSize.y = height
        svRectTransform.sizeDelta = oriSize
    end

    local function getRefreshCount()
        local count = loopScrollRect.totalCount * loopScrollRect.contentConstraintCount
        return count >= list.Count and list.Count or count
    end

    local gridViewItem = loopScrollRect.Cell:GetComponent(Enum.TypeInfo.UIGridViewMark)
    local name = gridViewItem and gridViewItem.GridItemName or loopScrollRect.Cell.name

    local needInter = interTime > 0
    local refreshCount = getRefreshCount()
    
    --处理gird生成
    local OnUpdate = function (owner, go, idx)
        go.name = idx
        local itemLua = CommonUtil.BindGridViewItem2Lua(wndOwner, name, go)
        itemLua.prefabName = name
        if needInter then
            CommonUtil.SetCanvasGroupStatus(itemLua.gameObject, false)
            ManagerContainer.LuaTimerMgr:AddTimer(interTime * idx, 1, false, function(sequence, param)
                CommonUtil.SetCanvasGroupStatus(itemLua.gameObject, true)
            end, nil)

            if idx == refreshCount - 1 then
                needInter = false
            end
        end

        if luaTbl~= nil then
            updateCB(luaTbl,itemLua, idx)
        else
            updateCB(itemLua, idx)
        end
    end
	loopScrollRect:SetUpdateCellCallback(wndOwner, OnUpdate);

    if loopScrollRect.content.childCount > 0 then
        --loopScrollRect:ClearCells();
    end
    loopScrollRect.totalCount = list.Count;
    if movePos == nil then
        loopScrollRect:MoveTo(0);
        loopScrollRect:RefreshCells()
    else
        -- loopScrollRect:MoveTo(movePos)
        loopScrollRect:SetItemStartIdx(movePos)
    end
end

function LoopGridViewEleCreateNoItem(wndOwner, loopScrollRect, list, interTime, luaTbl, updateCB,movePos)
    if loopScrollRect == nil then return end

    local function getRefreshCount()
        local count = loopScrollRect.totalCount * loopScrollRect.contentConstraintCount
        return count >= #list and #list or count
    end

    local needInter = interTime > 0
    local refreshCount = getRefreshCount()

    --处理gird生成
    local OnUpdate = function (owner, go, idx)
        go.name = idx
        if needInter then
            CommonUtil.SetCanvasGroupStatus(go, false)
            ManagerContainer.LuaTimerMgr:AddTimer(interTime * idx, 1, false, function(sequence, param)
                CommonUtil.SetCanvasGroupStatus(go, true)
            end, nil)

            if idx == refreshCount - 1 then
                needInter = false
            end
        end

        if luaTbl~= nil then
            updateCB(luaTbl, go, idx,list[idx+1])
        else
            updateCB(go, idx,list[idx+1])
        end
    end
    loopScrollRect:SetUpdateCellCallback(wndOwner, OnUpdate);

    if loopScrollRect.content.childCount > 0 then
        --loopScrollRect:ClearCells();
    end
    loopScrollRect.totalCount = #list;
    if movePos == nil then
        loopScrollRect:MoveTo(0);
        loopScrollRect:RefreshCells()
    else
        -- loopScrollRect:MoveTo(movePos)
        loopScrollRect:SetItemStartIdx(movePos)
    end
end

function ArrayFilterEquipWeapon(datas, jobType)
    local newDatas = {}
    for i = 1, #datas do
        local equipData = ManagerContainer.CfgMgr:GetEquipById(datas[i].cfgId)
        if CommonUtil.EleInTable(jobType, equipData.JobType) then
            newDatas[#newDatas + 1] = datas[i]
        end
    end
    return newDatas
end

function ArrayFilterSelections(array, filterType, keys, values)

    local function FilterCheck(element)
        if filterType == Enum.FilterType.AND then
            local result = {}
            for i = 1,#keys do
                result[i] = false
                if element[keys[i]] == nil then
                    result[i] = true
                else
                    if type(values[i]) == "table" then
                        if not next(values[i]) then
                            result[i] = true
                        end
                    else
                        if values[i] == nil then
                            result[i] = true
                        end
                    end

                    if not result[i] then
                        if type(element[keys[i]]) == "table" then
                            if type(values[i]) == "table" then
                                local result1 = false
                                for _,v in pairs(values[i]) do
                                    if CommonUtil.EleInTable(v, element[keys[i]]) then
                                        result1 = true
                                    end
                                end
                                result[i] = result1
                            else
                                if CommonUtil.EleInTable(values[i], element[keys[i]]) then
                                    result[i] = true
                                end
                            end
                        else
                            if type(values[i]) == "table" then
                                local result1 = false
                                for _,v in pairs(values[i]) do
                                    if element[keys[i]] == v then
                                        result1 = true
                                    end
                                end
                                result[i] = result1
                            else
                                if element[keys[i]] == values[i] then
                                    result[i] = true
                                end
                            end
                        end
                    end
                end
            end
            local endResult = true
            for _,v in pairs(result) do
                if not v then
                    endResult = false
                    break
                end
            end
            return endResult
        else
            local result = false
            for i = 1,#keys do
                if element[keys[i]] == nil then
                    result = true
                    break
                end
                if type(values[i]) == "table" then
                    if not next(values[i]) then
                        result = true
                        break
                    end
                else
                    if values[i] == nil then
                        result = true
                        break
                    end
                end

                if type(element[keys[i]]) == "table" then
                    if type(values[i]) == "table" then
                        local result1 = false
                        for _,v in pairs(values[i]) do
                            if CommonUtil.EleInTable(v, element[keys[i]]) then
                                result1 = true
                                break
                            end
                        end
                        if result1 then
                            result = true
                            break
                        end
                    else
                        if CommonUtil.EleInTable(values[i], element[keys[i]]) then
                            result = true
                            break
                        end
                    end
                else
                    if type(values[i]) == "table" then
                        local result1 = false
                        for _,v in pairs(values[i]) do
                            if element[keys[i]] == v then
                                result1 = true
                                break
                            end
                        end
                        if result1 then
                            result = true
                            break
                        end
                    else
                        if element[keys[i]] == values[i] then
                            result = true
                            break
                        end
                    end
                end
            end
            return result
        end
    end
    local list = {}
    if array == nil then
        return list
    end
    for _,v in pairs(array) do
        if FilterCheck(v) then
            list[#list + 1] = v
        end
    end

    return list
end

function ArraySortSelections(array, upOrDown, ...)
    if array == nil then
        return nil
    end
    local sorts = {...}
    local function boolean2Number(value)
        if type(value) == "boolean" then
            return value and 1 or 0
        end
        return value
    end
    local function UpSort(a, b)
        if #sorts == 1 then
            return a[sorts[1]] < b[sorts[1]]
        else
            local index = 1
            while index <= #sorts do
                if index > 1 then
                    if a[sorts[index - 1]] == b[sorts[index - 1]] then
                        if a[sorts[index]] ~= b[sorts[index]] then
                            return boolean2Number(a[sorts[index]]) < boolean2Number(b[sorts[index]])
                        end
                    else 
                        return boolean2Number(a[sorts[index - 1]]) < boolean2Number(b[sorts[index - 1]])
                    end
                end
                index = index + 1
            end
        end
    end
    local function DownSort(a, b)
        if #sorts == 1 then
            return a[sorts[1]] > b[sorts[1]]
        else
            local index = 1
            while index <= #sorts do
                if index > 1 then
                    if a[sorts[index - 1]] == b[sorts[index - 1]] then
                        if a[sorts[index]] ~= b[sorts[index]] then
                            return boolean2Number(a[sorts[index]]) > boolean2Number(b[sorts[index]])
                        end
                    else
                        return boolean2Number(a[sorts[index - 1]]) > boolean2Number(b[sorts[index - 1]])
                    end
                end
                index = index + 1
            end
        end
    end
    
    table.sort( array, upOrDown and UpSort or DownSort)
end

function ArraySortListSelections(array, keys, vals)
    if array == nil then
        return nil
    end
    if keys == nil or type(keys) ~= "table" then
        return nil
    end
    if vals == nil or type(vals) ~= "table" then
        return nil
    end

    local function boolean2Number(value)
        if type(value) == "boolean" then
            return value and 1 or 0
        end
        return value
    end
    local function Sort(a, b)
        if #vals == 1 then
            local sortType = keys[1] or Enum.TableSortRule.Down
            return sortType == Enum.TableSortRule.Down and boolean2Number(a[vals[1]]) > boolean2Number(b[vals[1]]) or boolean2Number(a[vals[1]]) < boolean2Number(b[vals[1]])
        else
            local index = 1
            while index <= #vals do
                if index > 1 then
                    if a[vals[index - 1]] == b[vals[index - 1]] then
                        if a[vals[index]] ~= b[vals[index]] then
                            local sortType = keys[index] or Enum.TableSortRule.Down
                            local result = (sortType == Enum.TableSortRule.Down and {boolean2Number(a[vals[index]]) > boolean2Number(b[vals[index]])} or {boolean2Number(a[vals[index]]) < boolean2Number(b[vals[index]])})[1]
                            return result
                        end
                    else
                        local sortType = keys[index - 1] or Enum.TableSortRule.Down
                        local result = (sortType == Enum.TableSortRule.Down and {boolean2Number(a[vals[index - 1]]) > boolean2Number(b[vals[index - 1]])} or {boolean2Number(a[vals[index - 1]]) < boolean2Number(b[vals[index - 1]])})[1]
                        return result
                    end
                end
                index = index + 1
            end
        end
    end

    table.sort( array, Sort)
end

--传入 wndlua, 页签按钮 parent , 页签点击事件
function CreateToggleMouduleOnlyBtns(wndRoot, toggleData, togglesRoot, defaultIndex, onToggleClick, cbOwner, needGetHide, dontTrigger)
    if toggleData == nil then
        toggleData = {}
    end

    --toggleData.toggleDefaultIndex = defaultIndex

	local function ToggleClick(index)
        --toggleData.toggleDefaultIndex = index
		onToggleClick(cbOwner or wndRoot, index)
	end

	local function ToggleClick1(index)
        toggleData.toggleDefaultIndex = index

		for j = 1,#toggleData.toggleList do
			toggleData.toggleList[j].isOn = j == index

            local on = toggleData.toggleList[j].transform:Find("On")
            if on ~= nil then
                on.gameObject:SetActive(j == index)
            end
            local off = toggleData.toggleList[j].transform:Find("Off")
            if off ~= nil then
                off.gameObject:SetActive(j ~= index)
            end
		end
	end

	local toggleGroup = togglesRoot:GetComponent('ToggleGroup')
	if toggleData.toggleList == nil then
		if toggleGroup ~= nil then
			--存在 togglegroup 组件
			toggleData.toggleList = {}

            local trans = togglesRoot.transform
            local toggles = togglesRoot:GetComponentsInChildren(Enum.TypeInfo.Toggle, needGetHide or false)
			for i = 1, toggles.Length do
				local toggle = toggles[i - 1]
                if toggle ~= nil then
                    toggleData.toggleList[#toggleData.toggleList + 1] = toggle

                    wndRoot.uiBase:AddToggleUniqueEventListener(toggle, nil, function (owner, toggle, params,result)
                        if not result then return end
                        if toggleData.toggleDefaultIndex == i then return end

                        ToggleClick1(i)
                        ToggleClick(i)
                    end)
                end
			end
		end
	end
    --if #toggleData.toggleList > 0 then
    --    toggleData.toggleList[toggleData.toggleDefaultIndex].isOn = true
    --
    --    local on = toggleData.toggleList[toggleData.toggleDefaultIndex].transform:Find("On")
    --    if on ~= nil then
    --        on.gameObject:SetActive(true)
    --    end
    --end

    if not dontTrigger then
        ToggleClick1(defaultIndex)
        ToggleClick(defaultIndex)
    end
end

function SetGOLayer(go, layerName)
    if tolua.isnull(go) then return end

    local layer = LayerMask.NameToLayer(layerName)
    local list = go:GetComponentsInChildren(Enum.TypeInfo.Transform)
    for i = 1, list.Length do
        list[i - 1].gameObject.layer = layer
    end
end

function CreateModels(wnd, num, ids, callback, param)
    local initIds = System.Array.CreateInstance(Enum.TypeInfo.Int32, num)
    for i = 1, #ids do
        initIds[i - 1] = ids[i]
    end
    ManagerContainer.LuaModelMgr:CreateModel(initIds, wnd, callback, param)
end

function DestroyGO(go)
    if tolua.isnull(go) then return end

    UnityEngine.GameObject.Destroy(go)
end

function DestroyGOImmediate(go)
    if tolua.isnull(go) then return end
    UnityEngine.GameObject.DestroyImmediate(go);
end

function Table2List(table, list)
    if list == nil then
        return nil
    end

    list:Clear()
    for _,v in pairs(table) do
        list:Add(v)
    end

    return list
end

function List2Table(list)
    local table = {}
    list:ForEach(function(v) table[#table + 1] = v end)
    return table 
end

function LoadIcon(wnd, name, cb, itemLua, key)
    local seqId
    if itemLua and key then
        if itemLua.AsyncSeqIds == nil then
            itemLua.AsyncSeqIds = {}
        end
        seqId = itemLua.AsyncSeqIds[key]
        if seqId then
            ManagerContainer.ResMgr:UnloadAssetBySeqId(seqId)
        end
    end
    if name == "" or name == nil then
        return -1
    end
    seqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.SingleSprite, Constants.IconDir, {name}, nil, cb)
    if not ManagerContainer.ResMgr:SeqIdEquals(seqId, 0) then
        if itemLua and key then
            itemLua.AsyncSeqIds[key] = seqId
        end
        if wnd then
            if wnd.AsyncSeqIds == nil then
                wnd.AsyncSeqIds = {}
            end
            wnd.AsyncSeqIds[#wnd.AsyncSeqIds + 1] = seqId
        end
    end
    return seqId
end

function CloseUIClearAsyncSeqIds(wnd)
    if wnd.AsyncSeqIds then
        for _,v in pairs(wnd.AsyncSeqIds) do
            ManagerContainer.ResMgr:UnloadAssetBySeqId(v)
        end
        wnd.AsyncSeqIds = nil
    end
end

function LoadTexture(wnd, name, cb)
    if name == "" or name == nil then
        return -1
    end
    local seqId = ManagerContainer.ResMgr:LuaLoadAssets(Enum.ResourceType.Texture2D, Constants.IconDir, {name}, nil, cb)
    if not ManagerContainer.ResMgr:SeqIdEquals(seqId, 0) then
        if wnd then
            if wnd.AsyncSeqIds == nil then
                wnd.AsyncSeqIds = {}
            end
            wnd.AsyncSeqIds[#wnd.AsyncSeqIds + 1] = seqId
        end
    end
    return seqId
end

function GetIconsTotalPath(name)
    return CommonUtil.StringConcat(Constants.IconDir, "/",name)
end

function TableClone(org)
    local function copy(org, res)
        for k,v in pairs(org) do
            if type(v) ~= "table" then
                res[k] = v;
            else
                res[k] = {};
                copy(v, res[k])
            end
        end
    end

    if not org then return end

    local res = {}
    copy(org, res)
    return res
end


function FormatNumber(number,isReturnW)
    if number == nil or (type(number) ~= "number" and type(number) ~= "userdata") then
       LogError("参数数值类型错误  ")
    else
        if type(number) == "userdata" and number.name() == "int64" then
            number = #number
        end
        number = math.floor(number)
        local num_length, num_str = string.len(number), tostring(number)
        local total_length = 4
        local function handler_dot(curNum, curUnit)
            local tmp_decimal_str = ""
            local integer_num, dot_num = math.modf(curNum/curUnit)
            local offset = total_length - string.len(integer_num)
            local decimal_num = curNum/curUnit
            if decimal_num ~= 0 and string.find(tostring(decimal_num), "%.") then
                tmp_decimal_str = tmp_decimal_str .. string.sub(tostring(decimal_num), string.find(tostring(decimal_num), "%."), string.find(tostring(decimal_num), "%.") + offset)
                local first_str = string.sub(tostring(tmp_decimal_str), 2, 2)
                local second_str= string.sub(tostring(tmp_decimal_str), 3, 3)
                if second_str ~= "0" and second_str ~= "" then
                    --tmp_decimal_str = tmp_decimal_str .. string.sub(tostring(decimal_num), 2, string.find(tostring(decimal_num), ".") + 3)
                else
                    if first_str ~= "" and first_str ~= "0" then
                        tmp_decimal_str = "." .. first_str
                    else
                        tmp_decimal_str = integer_num == 0 and "0" or ".0"
                    end
                end
            end
            return tostring(integer_num) .. tmp_decimal_str
        end

        if num_length < 5 then
           return num_str
        elseif num_length >= 5 and num_length < 9 or isReturnW then--万
           return handler_dot(number, 10^4) .. "w"
        elseif num_length >= 9 and not isReturnW then--亿
           return handler_dot(number, 10^8) .. "e"
        end
    end
end

function FormatPercentNumber(number)
    if number == nil or type(number) ~= "number" then
        LogError("参数数值类型错误")
    else
        local integer_num, dot_num = math.modf(number*100)
        local decimal_num = number*100
        local tmp_decimal_str = ""
        if decimal_num ~= 0 and string.find(tostring(decimal_num), "%.") then
            tmp_decimal_str = tmp_decimal_str .. string.sub(tostring(decimal_num), string.find(tostring(decimal_num), "%."), string.find(tostring(decimal_num), "%.") + 2)
            local first_str = string.sub(tostring(tmp_decimal_str), 2, 2)
            local second_str= string.sub(tostring(tmp_decimal_str), 3, 3)
            if second_str ~= "0" and second_str ~= "" then
                --tmp_decimal_str = tmp_decimal_str .. string.sub(tostring(decimal_num), 2, string.find(tostring(decimal_num), ".") + 3)
            else
                if first_str ~= "" and first_str ~= "0" then
                    tmp_decimal_str = "." .. first_str
                else
                    tmp_decimal_str = ""
                end
            end
        end
        return tostring(integer_num) .. tmp_decimal_str
    end
end

function IsConditionOutColor(text, out, value)
    if out then
        text.text = string.format(Constant.RedColorText, value)
        --text.color = Color.New(Constant.RedColor[1], Constant.RedColor[2], Constant.RedColor[3], 1)
    else
        text.text = value
    end
end

function SetTextColor(text, colorText)
    if colorText == nil then return end

    text.text = string.format(colorText, text.text)
end

function SetGraphicColor(graphic, colors)
    graphic.color = Color.New(colors[1], colors[2], colors[3], colors[4] ~= nil and colors[4] or 1)
end

function NeedUIGray(uiObj, status)
    if uiObj.material == nil then return end

    if status then
        uiObj.material = ManagerContainer.ResMgr:GetGrayMat()
    else
        uiObj.material = nil
    end
end

function SetTotalChildrenGray(uiObj, status)
    local children = uiObj:GetComponentsInChildren(Enum.TypeInfo.Graphic, true)
    for i = 0, children.Length - 1 do
        if not children[i].gameObject:GetComponent(Enum.TypeInfo.UIParticle) then
            if status then
                children[i].material = ManagerContainer.ResMgr:GetGrayMat()
            else
                children[i].material = nil
            end
        end
    end
end

function SetUITableNilInPackage(id)
    --LogError("nil   ".. name)
    local uiData = ManagerContainer.CfgMgr:GetUIData(id)
    if uiData == nil then
        return
    end
    local luaPath = nil
    if uiData.lua_path and uiData.lua_path ~= '' then
        luaPath = string.gsub(uiData.lua_path, "/", ".")
    end
    local path = string.gsub(uiData.res_path, "/", ".")
    local viewGePath = CommonUtil.StringConcat(path, "View_Generate")
    local viewPath = nil
    if luaPath then
        viewPath = CommonUtil.StringConcat(luaPath, "View")
        --local ctrPath = CommonUtil.StringConcat(name, '.', name, "Ctr")
    else
        viewPath = CommonUtil.StringConcat(path, "View")
    end
    CommonUtil.Unrequire(viewPath)
    CommonUtil.Unrequire(viewGePath)
    --CommonUtil.Unrequire(ctrPath)
end


function SetUIGridItemTableNilInPackage(name)
    local itemPath = CommonUtil.StringConcat("GridViewItem.", name, "_Generate")
    CommonUtil.Unrequire(itemPath)
end

function Unrequire(name)
    --LogError(name)
    --LogError(package.loaded[name])
    package.loaded[name] = nil
    _G[name] = nil
    --LogError(package.loaded[name])
end

---谨慎使用 该接口会把对象放入 lua对象池
function BatchCreateItems(wndOwner, itemlua, parent, data, ...)
    if wndOwner.batchItemList == nil then
        wndOwner.batchItemList = {}
    end
    local prefabName = itemlua.prefabName
    if wndOwner.batchItemList[prefabName] == nil then
        wndOwner.batchItemList[prefabName] = {}
    end
    local batchItemList = wndOwner.batchItemList[prefabName]

    -- GameObject 的缓存池
    local stack = batchItemList.stack
    if stack == nil then
        stack = {}
        batchItemList.stack = stack
    end

    local go = itemlua.gameObject
    go.transform:SetParent(parent)
    go.transform.localPosition = Vector3.zero
    go.transform.localRotation = Quaternion.identity
    go.transform.localScale = Vector3.one
    go:SetActive(true)

    local luaCtr = require("Common/".. itemlua.prefabName .. "Ctr")
    if luaCtr then
        luaCtr:SetData(wndOwner, itemlua, data, ...)
    end

    stack[go] = itemlua
end

function BatchCreateItems1(wndOwner, itemlua, parent)
    if wndOwner.batchItemList == nil then
        wndOwner.batchItemList = {}
    end
    local prefabName = itemlua.prefabName
    if wndOwner.batchItemList[prefabName] == nil then
        wndOwner.batchItemList[prefabName] = {}
    end
    local batchItemList = wndOwner.batchItemList[prefabName]

    -- GameObject 的缓存池
    local stack = batchItemList.stack
    if stack == nil then
        stack = {}
        batchItemList.stack = stack
    end

    local go = itemlua.gameObject
    go.transform:SetParent(parent)
    go.transform.localPosition = Vector3.zero
    go.transform.localRotation = Quaternion.identity
    go.transform.localScale = Vector3.one
    go:SetActive(true)

    stack[go] = itemlua
end

function AddBatchItemsByItemlua(wndOwner, itemlua)
    if wndOwner.batchItemList == nil then
        wndOwner.batchItemList = {}
    end
    local prefabName = itemlua.prefabName
    if wndOwner.batchItemList[prefabName] == nil then
        wndOwner.batchItemList[prefabName] = {}
    end
    local batchItemList = wndOwner.batchItemList[prefabName]

    -- GameObject 的缓存池
    local stack = batchItemList.stack
    if stack == nil then
        stack = {}
        batchItemList.stack = stack
    end
    stack[itemlua.gameObject] = itemlua
end

function RecycleFromBatchItemsByPrefabName(wndOwner, prefabName)
    if wndOwner.batchItemList ~= nil and wndOwner.batchItemList[prefabName] ~= nil then
        local batchItemList = wndOwner.batchItemList[prefabName]
        local stack = batchItemList.stack
        if stack ~= nil then
            for k, v in pairs(stack) do
                DG.Tweening.DOTween.Kill(k.transform)
                ManagerContainer.GoPoolMgr:RecycleGo(v)
                stack[k] = nil
            end
        end
    end
end

function GetBatchItemByGo(wndOwner, prefabName, go)
    if wndOwner.batchItemList ~= nil and wndOwner.batchItemList[prefabName] ~= nil then
        local batchItemList = wndOwner.batchItemList[prefabName]
        local stack = batchItemList.stack
        if stack ~= nil then
            return stack[go]
        end
    end
    return nil
end

function RecycleFromBatchItems(wndOwner, itemlua)
    local prefabName = itemlua.oriName ~= "" and itemlua.oriName or itemlua.prefabName
    if wndOwner.batchItemList ~= nil and wndOwner.batchItemList[prefabName] ~= nil then
        local batchItemList = wndOwner.batchItemList[prefabName]
        local stack = batchItemList.stack
        if stack ~= nil then
            if stack[itemlua.gameObject] then
                stack[itemlua.gameObject] = nil
            end
        end
    end

    DG.Tweening.DOTween.Kill(itemlua.transform)
    ManagerContainer.GoPoolMgr:RecycleGo(itemlua)
end

function HideAllChildren(parent)
    if parent.childCount == 0 then return end

    for i = 0, parent.childCount - 1 do
        local child = parent:GetChild(i)
        child.gameObject:SetActive(false)
    end
end

---谨慎使用 该接口会把对象放入 lua对象池
function BatchCreateItemsLoopWithMould(wnd, mould, parent, data, idx, ...)
    if parent.childCount < idx then
        local params = {...}
        ManagerContainer.GoPoolMgr:SpawnGoNewLua(mould, function (itemlua)
            CommonUtil.BatchCreateItems(wnd, itemlua, parent, data, unpack(params))
        end)
    else
        local child = parent:GetChild(idx - 1)
        child.gameObject:SetActive(true)
        if wnd.batchItemList == nil then
            wnd.batchItemList = {}
        end
        if wnd.batchItemList[mould.prefabName] == nil then
            wnd.batchItemList[mould.prefabName] = {}
        end
        local batchItemList = wnd.batchItemList[mould.prefabName]

        -- GameObject 的缓存池
        local stack = batchItemList.stack
        if stack == nil then
            stack = {}
            batchItemList.stack = stack
        end

        local go = child.gameObject
        local itemlua1 = stack[go]
        local luaCtr = require("Common/".. itemlua1.prefabName .. "Ctr")
        if luaCtr then
            luaCtr:SetData(wnd, itemlua1, data, ...)
        end
    end
end

function BatchCreateItemsLoopSpawnItem(wnd, type, parent, data, idx, ...)
    if parent.childCount < idx then
        local params = {...}
        ManagerContainer.GoPoolMgr:SpawnItemGo(type, function (itemlua)
            CommonUtil.BatchCreateItems(wnd, itemlua, parent, data, unpack(params))
        end)
    else
        local prefabName = GetResTypePrefabName(type)
        local child = parent:GetChild(idx - 1)
        child.gameObject:SetActive(true)
        if wnd.batchItemList == nil then
            wnd.batchItemList = {}
        end
        if wnd.batchItemList[prefabName] == nil then
            wnd.batchItemList[prefabName] = {}
        end
        local batchItemList = wnd.batchItemList[prefabName]

        -- GameObject 的缓存池
        local stack = batchItemList.stack
        if stack == nil then
            stack = {}
            batchItemList.stack = stack
        end

        local go = child.gameObject
        local itemlua1 = stack[go]
        local luaCtr = require("Common/".. itemlua1.prefabName .. "Ctr")
        if luaCtr then
            luaCtr:SetData(wnd, itemlua1, data, ...)
        end
    end
end


function BatchCreateItemsLoopSpawnPrefabNew(wnd, list, prefabName, parent,...)
    local idx = 0
    for _,v in pairs(list) do
        idx = idx + 1
        CommonUtil.BatchCreateItemsLoopSpawnPrefab(wnd, prefabName, parent, v, idx, ...)
    end

    if parent.childCount > idx then
        for i = idx + 1, parent.childCount do
            local child = parent:GetChild(i - 1)
            child.gameObject:SetActive(false)
        end
    end
end

function BatchCreateItemsLoopSpawnPrefabNew1(wnd, list, prefabName, luaName, parent,...)
    local idx = 0
    for _,v in pairs(list) do
        idx = idx + 1
        if parent.childCount < idx then
            local params = {...}
            ManagerContainer.GoPoolMgr:SpawnPrefabGo(prefabName, function (itemlua)
                CommonUtil.BatchCreateItems(wnd, itemlua, parent, v, unpack(params))
            end)
        else
            luaName = luaName or prefabName
            local child = parent:GetChild(idx - 1)
            child.gameObject:SetActive(true)
            if wnd.batchItemList == nil then
                wnd.batchItemList = {}
            end
            if wnd.batchItemList[luaName] == nil then
                wnd.batchItemList[luaName] = {}
            end
            local batchItemList = wnd.batchItemList[luaName]

            -- GameObject 的缓存池
            local stack = batchItemList.stack
            if stack == nil then
                stack = {}
                batchItemList.stack = stack
            end

            local go = child.gameObject
            local itemlua1 = stack[go]
            local luaCtr = require("Common/".. luaName .. "Ctr")
            if luaCtr then
                luaCtr:SetData(wnd, itemlua1, v, ...)
            end
        end
    end

    if parent.childCount > idx then
        for i = idx + 1, parent.childCount do
            local child = parent:GetChild(i - 1)
            child.gameObject:SetActive(false)
        end
    end
end

function BatchCreateItemsLoopSpawnPrefab(wnd, prefabName, parent, data, idx, ...)
    if parent.childCount < idx then
        local params = {...}
        ManagerContainer.GoPoolMgr:SpawnPrefabGo(prefabName, function (itemlua)
            CommonUtil.BatchCreateItems(wnd, itemlua, parent, data, unpack(params))
        end)
    else
        local prefabName = prefabName
        local child = parent:GetChild(idx - 1)
        child.gameObject:SetActive(true)
        if wnd.batchItemList == nil then
            wnd.batchItemList = {}
        end
        if wnd.batchItemList[prefabName] == nil then
            wnd.batchItemList[prefabName] = {}
        end
        local batchItemList = wnd.batchItemList[prefabName]

        -- GameObject 的缓存池
        local stack = batchItemList.stack
        if stack == nil then
            stack = {}
            batchItemList.stack = stack
        end

        local go = child.gameObject
        local itemlua1 = stack[go]
        local luaCtr = require("Common/".. itemlua1.prefabName .. "Ctr")
        if luaCtr then
            luaCtr:SetData(wnd, itemlua1, data, ...)
        end
    end
end

function BatchDisposeItems(owner)
    if owner.batchItemList ~= nil then
        for k,v in pairs(owner.batchItemList) do
            for k1,v1 in pairs(v.stack) do
                ManagerContainer.GoPoolMgr:RecycleGo(v1)
                v1 = nil
            end
            v = nil
        end
    end

    owner.batchItemList = nil
end

function DisposeBatchGridChildsItem(owner, parent, name)
    if owner.batchItemList ~= nil and parent ~= nil then
        local list = owner.batchItemList[name]
        if list == nil then return end

        local gos = {}
        for i = 1, parent.childCount do
            local child = parent:GetChild(i - 1)
            gos[i] = child.gameObject
        end

        for _,v in pairs(gos) do
            local itemlua = list.stack[v]
            if itemlua ~= nil then
                ManagerContainer.GoPoolMgr:RecycleGo(itemlua)
                itemlua = nil
            end
        end
    end
end

function UpdateItemPrefab(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
    local name = itemlua:getClassName()
    name = string.sub(name, 1, #name - 4)
    local luaCtr = require("Common/" .. name .. "Ctr")
    return luaCtr:SetData(wnd, itemlua, logicData, enterType, onClickOwner, onClickCB, params)
end

function EleInTable(ele, table)
    if table == nil then return false end

    for k,v in pairs(table) do
        if v == ele then
            return true, k
        end
    end
    return false
end

--- 英雄属性数值转化到用于显示的字符串
function HeroAttrFormatValue(attrId, attrValue, need10000Percent)
    local val = SDataUtil.InvConvert(attrValue)
    if attrId > 21 then
        val = CommonUtil.Floor3PointNum(attrId, val)
        return (SDataUtil.IsGreater(val, 0) and '+' or (SDataUtil.IsLess(val, 0) and '-'or '')) .. Mathf.Abs((need10000Percent and val*10000 or val) / 100) .. "%"
    else
        val = Mathf.Floor(val)
        return (SDataUtil.IsGreater(val, 0) and '+' or (SDataUtil.IsLess(val, 0) and '-'or '')) .. tostring(val)
    end
end

function HeroAttrFormatValueNoSign(attrId, attrValue, need10000Percent)
    local val = SDataUtil.InvConvert(attrValue)
    if  attrId > 21 then
        val = CommonUtil.Floor3PointNum(attrId, val)
        return Mathf.Abs((need10000Percent and val*10000 or val) / 100) .. "%"
    else
        val = Mathf.Floor(val)
        return Mathf.Abs(val)
    end
end

--- 英雄属性转化语言表Key
function HeroAttrFormatName(attrId, attrValue)
    local name = "Attr_" .. attrId
    if attrId == 54 or attrId == 55
        or attrId == 59 or attrId == 60 then
            name = name .. (SDataUtil.IsGreater(attrValue, 0)  and '_0' or '_1')
    end
    return name
end

--- 英雄属性值转化为实际运算的值
function HeroAttrCalcValue(attrId, attrValue)
    if attrId < Enum.HeroAttrType.STR_Percent then
        return attrValue
    else
        -- return attrValue * 0.0001
        return SDataUtil.Multiply(attrValue,0.0001)
    end
end

--实例化对象
function Instantiate(_original, _parent, _localScaleRate)
    local _go = UnityEngine.GameObject.Instantiate(_original);
    if _parent then
        local _scale = Vector3.one;
        if _localScaleRate then
            _scale = _scale * _localScaleRate;
        end
        _go.transform:SetParent(_parent);
        _go.transform.localPosition = Vector3.zero;
        _go.transform.localScale = _scale;
        _go.transform.localRotation = Quaternion.identity;
    end
    return _go;
end

--Error弹窗
function PopErrorTips(Key)
	if not ManagerContainer.LuaUIMgr:GetPage(Enum.UIPageName.UIErrorTips) then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIErrorTips, {errorId=Key}, nil, nil, nil, Enum.UISibling[Enum.UIType.Top + 1] + 11)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ERROR_DESC_DISPLAY, {errorId=Key})
    end
end

-- 获得装备的品质
function GetEquipItemQuality(itemCfgId)
    local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(itemCfgId)
    local divide = Constant.Quality_Equip_Divide[equipCfgData.EquipLevel]
    return divide[1], divide[2]
end

-- 获得道具的品质
function GetItemQuality(itemCfgId)
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(itemCfgId)
    if itemCfgData.ResType == Enum.ItemType.Equip then
        return GetEquipItemQuality(itemCfgId)
    else
        return itemCfgData.Quality, 0
    end
end

function GetDeltaAttrs(roleId, curAttrs, oneAttrList)
    local dic = ManagerContainer.LuaActorDataMgr:GetIncreaseSecondAttrVal(
            roleId,
            oneAttrList[Enum.HeroAttrType.STR] + curAttrs[Enum.HeroAttrType.STR],
            oneAttrList[Enum.HeroAttrType.AGI] + curAttrs[Enum.HeroAttrType.AGI],
            oneAttrList[Enum.HeroAttrType.INT] + curAttrs[Enum.HeroAttrType.INT],
            oneAttrList[Enum.HeroAttrType.VIT] + curAttrs[Enum.HeroAttrType.VIT],
            oneAttrList[Enum.HeroAttrType.DEX] + curAttrs[Enum.HeroAttrType.DEX],
            oneAttrList[Enum.HeroAttrType.LUK] + curAttrs[Enum.HeroAttrType.LUK]
    )
    local iter = dic:GetEnumerator()

    local newAttrs = {}
    while iter:MoveNext() do
        newAttrs[iter.Current.Key] = math.floor(iter.Current.Value)
    end
    return newAttrs
end
--获取主角或伙伴当前的MVP卡牌祝福变化数据表
function GetCurCardLv(idx)
    local lastLv = ManagerContainer.DataMgr.CardData:GetCardSuitLastLvById(idx)
    local curlv = ManagerContainer.DataMgr.CardData:GetCardSuitLvById(idx)
    local state = ManagerContainer.DataMgr.CardData:GetCardSuitStateById(idx)
	if not state then
		curlv = curlv - 1
	end
    if curlv > lastLv then
        return {lastLv,curlv}
    end
    return nil
end

function AttrNoticeDisplay(slotIndex)

    local oldAttr, newAttr
    

    if slotIndex == 1 then
        oldAttr = ManagerContainer.DataMgr.UserData:GetLastTotalAtttrs()
        newAttr = ManagerContainer.DataMgr.UserData:GetHeroData().attrs
    else
        oldAttr = ManagerContainer.DataMgr.PartnerData:GetLastTotalAttrs(slotIndex)
        local list = ManagerContainer.DataMgr.PartnerData:GetPartnerDataBySlotIndex(slotIndex)
        newAttr = list == nil and nil or list.attrs
    end

    local specialAttr = nil
    local temp = CommonUtil.GetCurCardLv(slotIndex)
    if temp then
        specialAttr = {{temp[1],temp[2]}}
    end

    if oldAttr == nil or newAttr == nil then return end

    local increase = false
    local deltaEquipAttr = {}
    for _,v in pairs(Enum.HeroAttrType) do
        if v >= Enum.HeroAttrType.Life then
            deltaEquipAttr[v] =  SDataUtil.Sub((newAttr[v] or 0),(oldAttr[v] or 0))
            if SDataUtil.IsGreater(deltaEquipAttr[v], 0) then
                increase = true
            end
        end
    end

    if increase then
        ManagerContainer.LuaUIMgr:AttrNoticeDisplay1({oldAttr, newAttr,specialAttr})
    end
end

function GetOwnResCountByItemId(id)
    local count = 0
    local itemCfgData = ManagerContainer.CfgMgr:GetItemById(id)

    if itemCfgData == nil then
        LogError(tostring(id) .. " isnt exist in ItemCfg")
        return 0
    end

    if itemCfgData.ResType <= Enum.ItemType.ParterExp or
            itemCfgData.ResType == Enum.ItemType.SkillExp or
            itemCfgData.ResType == Enum.ItemType.AdvanceSkillExp or
            itemCfgData.ResType == Enum.ItemType.Parter then
        count = ManagerContainer.DataMgr.UserData:GetCurrency(id)
    elseif itemCfgData.ResType == Enum.ItemType.PetExp or
            itemCfgData.ResType == Enum.ItemType.HeroSpirit or
            itemCfgData.ResType == Enum.ItemType.PetStone or
            itemCfgData.ResType == Enum.ItemType.GuildStone or
            itemCfgData.ResType == Enum.ItemType.HundredDojoStone or
            itemCfgData.ResType == Enum.ItemType.GuildWarStone or
            itemCfgData.ResType == Enum.ItemType.PetCrystal or
            itemCfgData.ResType == Enum.ItemType.RecruitStone then
        count = ManagerContainer.DataMgr.UserData:GetResById(id)
    elseif itemCfgData.ResType == Enum.ItemType.Gift or
            itemCfgData.ResType == Enum.ItemType.Income or
            itemCfgData.ResType == Enum.ItemType.Item then
        count = ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(id)
    elseif itemCfgData.ResType == Enum.ItemType.Equip then
        count = ManagerContainer.DataMgr.EquipData:GetEquipCountById(id)
    elseif itemCfgData.ResType == Enum.ItemType.ParterChip then
        count = ManagerContainer.DataMgr.ChipData:GetChipCountById(id)
    elseif itemCfgData.ResType == Enum.ItemType.Card then
        count = ManagerContainer.DataMgr.CardData:GetCardCountById(id)
    elseif itemCfgData.ResType == Enum.ItemType.Pet then
        count = ManagerContainer.DataMgr.PetDataMgr:GetPetCountById(id)
    elseif itemCfgData.ResType == Enum.ItemType.Cangpin then
        count = ManagerContainer.DataMgr.KeepSakeBookData:GetMaterialById(id)
    else
        count = ManagerContainer.DataMgr.BagData:GetItemCountByCfgId(id)
    end
    return count
end

function DeserializeCfgItemList(data)
    if data == nil then return nil end
    local list = {}
    for k,v in pairs(data) do
        if type(v) == "table" then
            list[#list + 1] = v
        else
            list = {data}
            return list
        end
    end
    return list
end

--- 职业ID转换角色ID
---@param jobId integer
---@param sex integer
---@return integer
function JobIdToRoleId(jobId, sex)
    if not jobId or not sex then
        return 100001
    end
    return jobId * 10 + sex
end

--- 角色ID转换职业ID
---@param roleId integer
---@return integer integer
function RoleIdToJobId(roleId)
    if not roleId then
        return 10000, 1
    end
    return Mathf.Round(roleId * 0.1), roleId % 10
end

--- 已弃用
function GetAsyncIdx(wnd, itemLua, name)
    local asyncIdx = itemLua[name]
    -- if asyncIdx then
    --     ManagerContainer.ResMgr:ClearUIAsyncLoadReqsByIdx(wnd.uiData.id, asyncIdx)
    -- else
    --     asyncIdx = wnd.controller:GetAsyncIdx()
    --     itemLua[name] = asyncIdx
    -- end
    return asyncIdx
end

function LocalUIPos2ScreenPos(worldPos)
    return CameraMgr.Instance.UICamera:WorldToScreenPoint(worldPos);
end

function ConvertUIPos2ScreenPos(worldPos)
    local tempPos =  CameraMgr.Instance.UICamera:WorldToViewportPoint(worldPos);
    local finalPos = Vector3.New((tempPos.x - 0.5) * ManagerContainer.LuaUIMgr.SCREEN_WIDTH, (tempPos.y - 0.5) * ManagerContainer.LuaUIMgr.SCREEN_HEIGHT, 0);
    return finalPos;
end

function IsScreenUIMoveLimit(screenPos, size)
    if screenPos.x > UnityEngine.Screen.width - size.x/2
            or screenPos.x < size.x/2
            or screenPos.y > UnityEngine.Screen.height - size.y/2
            or screenPos.y < size.y/2
    then
        return false
    end
    return true
end

function ConvertScreenPos2UIPos(screenPos)
    local tempPos = CameraMgr.Instance.UICamera:ScreenToViewportPoint(screenPos)
    return Vector3.New((tempPos.x - 0.5) * ManagerContainer.LuaUIMgr.SCREEN_WIDTH, (tempPos.y - 0.5) * ManagerContainer.LuaUIMgr.SCREEN_HEIGHT, 0);
end

function SetRepeatButtonEvent(owner, addBtn, addCB, reduceBtn, reduceCB)
    if addBtn.repeatButton == nil or reduceBtn.repeatButton == nil then
        LogError("请检查 按钮上的 repeatbutton 组件是否存在或是是否导出到lua")
        return
    end

    addBtn.repeatButton:AddRepeatClickEventListener(owner, addCB)
    reduceBtn.repeatButton:AddRepeatClickEventListener(owner, reduceCB)
end

function TableToVector3(table, defaultValue)
    if not table then
        return defaultValue or Vector3.zero
    end
    local x = table[1] or 0
	local y = table[2] or 0
	local z = table[3] or 0
    return Vector3.New(x, y, z)
end

function TableToVector2(table, defaultValue)
    if not table then
        return defaultValue or Vector2.zero
    end
    local x = table[1] or 0
	local y = table[2] or 0
    return Vector2.New(x, y)
end

function TableToQuaternion(table, defaultValue)
    if not table then
        return defaultValue or Quaternion.identity
    end
    local x = table[1] or 0
    local y = table[2] or 0
    local z = table[3] or 0
    return Quaternion.Euler(x, y, z)
end

function TableToGridPos(table)
    if not table then return 0,0 end
    local x = table[1] or 0
    local y = table[2] or 0
    return x, y
end

function TableIsEmpty(table)
    return (_G.next(table) == nil)
end

function GetTableCount(table)
    local count = 0
    for k,v in pairs(table) do
        count = count + 1
    end
    return count
end

function GetItemTypeName(itemType)
    if itemType == Enum.ItemType.Coin then
        return I18N.T("Coin")
    end

    if itemType == Enum.ItemType.Diamond then
        return I18N.T("Diamond")
    end

    if itemType == Enum.ItemType.RoleBaseExp then
        return I18N.T("Exp")
    end

    if itemType == Enum.ItemType.RoleJobExp then
        return I18N.T("JobExp")
    end

    if itemType == Enum.ItemType.ParterExp then
        return I18N.T("ParterExp")
    end

    return ""
end

function GetVaildNickName(nickName)
    if not nickName or nickName == '' or nickName == 'NickName' then
        return I18N.T('NewGamePlayer')
    end
    return nickName
end

function GetShortVaildNickName(nickName)
    nickName = CommonUtil.GetVaildNickName(nickName)
    local totalLength = GetActualStringLength(nickName)
    if totalLength > 4 then
        nickName = Utf8StrSub(nickName, 1, 4).."..."
    end

    return nickName
end

--根据当前的段位积分获取当前所属段位的信息
function GetCurDunData(_danScore)
    local levelDatas = ManagerContainer.CfgMgr:GetArenaLevelDatas()
    local nextKey = -1
    local levelCfg = nil
    for key=10001, 20000 do
        levelCfg = levelDatas[key]
        if levelCfg~= nil then
            if _danScore <= levelCfg.ArenaLevelScore then
                nextKey = key+1
                break;
            end
        end
    end
    return levelCfg, nextKey
end

function SetRewardItemData(pageTbl,itemId,itemLua,cnt,onClickCB)
    if pageTbl == nil or itemLua == nil or itemId == nil then
        return
    end

    local IconItemCtr = require("Common/IconItemCtr")

    local data = {cfgId = itemId, num = cnt}
    IconItemCtr:SetData(pageTbl, itemLua, data, Enum.ItemIEnterType.Bag, pageTbl, onClickCB)
end

function SetRewardItemDataNew(pageTbl,itemId,itemLua,cnt,fromType, onClickCB)
    if pageTbl == nil or itemLua == nil or itemId == nil then
        return
    end

    local IconItemCtr = require("Common/IconItemCtr")

    local data = {cfgId = itemId, num = cnt, cornerType = fromType}
    IconItemCtr:SetData(pageTbl, itemLua, data, Enum.ItemIEnterType.Bag, pageTbl, onClickCB)
end

function TaskDescParse(cond)
    local desc = ""
    if cond[1] == Enum.TaskType.Level_Battle_Count then
        local levelId = cond[2]
        local levelData = ManagerContainer.CfgMgr:GetLevelDataById(levelId)
        desc = ManagerContainer.CfgMgr:GetLanguageValueByKey("Condition_"..cond[1], I18N.T(levelData.Name))
    elseif cond[1] == Enum.TaskType.Hero_Id_Level then
        desc = ManagerContainer.CfgMgr:GetLanguageValueByKey("Condition_"..cond[1], cond[#cond])
    else
        desc = ManagerContainer.CfgMgr:GetLanguageValueByKey("Condition_"..cond[1], cond[2], cond[3])
    end

    return desc
end


function GetResTypePrefabName(itemType)
    local prefabName = ""
    if itemType == Enum.ItemType.Equip then
        prefabName = Enum.PrefabNames.EquipItem
    elseif itemType == Enum.ItemType.Coin or
            itemType == Enum.ItemType.Diamond or
            itemType == Enum.ItemType.RoleBaseExp or
            itemType == Enum.ItemType.RoleJobExp or
            itemType == Enum.ItemType.ParterExp or
            itemType == Enum.ItemType.FashionPaper or
            itemType == Enum.ItemType.SkillExp or
            itemType == Enum.ItemType.Gift or
            itemType == Enum.ItemType.SkillBook or
            itemType == Enum.ItemType.PetExp or
            itemType == Enum.ItemType.PetStone or
            itemType == Enum.ItemType.Income or
            itemType == Enum.ItemType.SkillEquipSlotMat or
            itemType == Enum.ItemType.SkillEquip or
            itemType == Enum.ItemType.Item then
        prefabName = Enum.PrefabNames.ItemItem
    elseif itemType == Enum.ItemType.ParterChip then
        prefabName = Enum.PrefabNames.ChipItem
    elseif itemType == Enum.ItemType.Card then
        prefabName = Enum.PrefabNames.CardIconItem
    elseif itemType == Enum.ItemType.Parter then
        prefabName = Enum.PrefabNames.ParterItem
    elseif itemType == Enum.PrefabNames.IconSmallItem then
        prefabName = Enum.PrefabNames.IconSmallItem
    else
        LogError("通用Item不支持该类型，仔细看看 " .. itemType)
        return nil
    end
    return prefabName
end

function GetMinRefineLevel(slots)
    if slots == nil then return 0 end

    local minLv = 100
    for i = 1, #slots do
        if slots[i].level < minLv then
            minLv = slots[i].level
        end
    end
    if minLv == 100 then
        return 0
    end
    if minLv >= 5 then
        return minLv
    end
    return 0
end

function GetSuitNum(slots, slotType)
    if slots == nil then return 0 end
    if slots[slotType].equip_id == 0 then return 0 end

    local equipData = ManagerContainer.CfgMgr:GetEquipById(slots[slotType].equip_id)
    local suitNum = 0
    if equipData.Suit == 0 then
        return suitNum
    end

    local suitId = ManagerContainer.CfgMgr:GetEquipSuitById(equipData.Suit)

    for i = 1, #slots do
        if slots[i].equip_id > 0 then
            local equipData1 = ManagerContainer.CfgMgr:GetEquipById(slots[i].equip_id)
            local suitId1 = ManagerContainer.CfgMgr:GetEquipSuitById(equipData1.Suit)
            if suitId == suitId1 or equipData1.EquipLevel > equipData.EquipLevel then
                suitNum = suitNum + 1
            end
        end
    end

    return suitNum
end

function GetAllHeroLogicDatas()
    local heroList = {}
    local userData = ManagerContainer.DataMgr.UserData:GetHeroData()
    heroList[#heroList + 1] = userData

    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    for _,v in pairs(partnerDatas) do
        heroList[#heroList + 1] = v
    end

    return heroList
end

function GetHeroLogicDataByUid(uid)
    if uid == 1 then
        return ManagerContainer.DataMgr.UserData:GetHeroData()
    else
        return ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(uid)
    end
end

function GetHeroActorDataByUid(uid)
    if uid == 1 then
        local userRoleId = ManagerContainer.DataMgr.UserData:GetUserRoleId()
        return ManagerContainer.LuaActorDataMgr:GetHeroActorData(userRoleId)
    else
        local partnerData = CommonUtil.GetHeroLogicDataByUid(uid)
        return ManagerContainer.LuaActorDataMgr:GetFellowActorData(uid,partnerData.configId)
    end
end

function GetHeroCfgDataByUid(uid)
    if uid == 1 then
        local roleId = ManagerContainer.DataMgr.UserData:GetUserRoleId()
        return ManagerContainer.CfgMgr:GetRoleDataById(roleId)
    else
        local heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(uid)
        return ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
    end
end

function GetHeroJobCfgDataByUid(uid)
    if uid == 1 then
        local jobId = ManagerContainer.DataMgr.UserData:GetJobCfgId()
        return ManagerContainer.CfgMgr:GetJobDataById(jobId)
    else
        local heroData = ManagerContainer.DataMgr.PartnerData:GetPartnerDataByUniqueId(uid)
        return ManagerContainer.CfgMgr:GetPartnerDataById(heroData.configId)
    end
end

function GetHeroLogicDataByPostId(PostId)
    if PostId == 1 then
        return ManagerContainer.DataMgr.UserData:GetHeroData()
    else
        local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
        for _,v in pairs(partnerDatas) do
            local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(v.configId)
            if cfgData.PostId == PostId - 1 then
                return v
            end
        end
        return nil
    end
end

function GetHeroJobAndNameByUid(uid, configId)
    local name = ""
    if uid == 1 then
        local cfgData = ManagerContainer.CfgMgr:GetJobDataById(configId)
        if cfgData == nil then
            return ""
        end
        local nickName = ManagerContainer.DataMgr.UserData:GetUserNickname()
        name = I18N.T(cfgData.JobName) .. nickName
    else
        local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(configId)
        if cfgData == nil then
            return ""
        end
        name = I18N.T(cfgData.JobName) .. I18N.T(cfgData.Name)
    end

    return name
end

function GetHeroSplitJobAndNameByUid(uid, configId)
    local jobName = ""
    local roleName = ""
    if uid == 1 then
        local cfgData = ManagerContainer.CfgMgr:GetJobDataById(configId)
        if cfgData == nil then
            return ""
        end
        roleName = ManagerContainer.DataMgr.UserData:GetUserNickname()
        jobName = I18N.T(cfgData.JobName)
    else
        local cfgData = ManagerContainer.CfgMgr:GetPartnerDataById(configId)
        if cfgData == nil then
            return ""
        end
        jobName = I18N.T(cfgData.JobName)
        roleName = I18N.T(cfgData.Name)
    end

    return jobName, roleName
end

--- 获得技能的CfgId
---@param skillId integer 技能Id
---@param skillSlotLv integer 技能槽位等级
---@return integer 技能的CfgId
function GetSkillCfgIdByIdAndLv(skillId, skillLv)
    return skillId * 1000 + skillLv
end

--- 获得技能槽位的CfgId
---@param skillId integer 技能槽位的顺序ID
---@param skillSlotLv integer 技能槽位等级
---@return integer 技能槽位的CfgId
function GetSkillSlotCfgIdByIdxAndLv(skillSlotIdx, skillSlotLv)
    return skillSlotIdx * 1000 + skillSlotLv
end

--- 获得技能升级效果的CfgId
---@param skillId integer 技能Id
---@param skillLv integer 技能等级
---@return integer 技能升级效果的CfgId
function GetSkillUpEffectCfgIdByIdAndLv(skillId, skillLv)
    return skillId * 1000 + skillLv
end

--- 找到下一个解锁的技能 （最终解释权归 李慧勇）
---@param heroId integer 英雄Id
function FindNextUnlockSkill(heroId)
    local heroLv = ManagerContainer.DataMgr.UserData:GetHeroLv(heroId)
    local jobCfgId = ManagerContainer.DataMgr.UserData:GetHeroJobCfgId(heroId)
    local skillTreeLs = nil
    if ManagerContainer.DataMgr.UserData:IsLeaderHero(heroId) then
        local job = ManagerContainer.CfgMgr:GetJobDataById(jobCfgId)
        skillTreeLs = ManagerContainer.CfgMgr:GetSkillTreeByFeature(job.JobType, job.JobBranch, job.JobStage)
    else
        local job = ManagerContainer.CfgMgr:GetPartnerDataById(jobCfgId)
        skillTreeLs = ManagerContainer.CfgMgr:GetParterSkillTreeByFeature(job.JobType, job.ParterId)
    end
    local nextLv = nil
    local skillType = nil
    local skillId = nil
    local skillTreeCfgData = nil
    if skillTreeLs then
        for i = 1, #skillTreeLs do
            skillTreeCfgData = skillTreeLs[i]
            local needLevel = skillTreeCfgData.OpenLevel
            if needLevel > heroLv then
                if not nextLv or nextLv > needLevel then
                    nextLv = needLevel
                    skillType = skillTreeCfgData.SkillType
                    skillId = skillTreeCfgData.SkillId
                end
            end
        end
    end
    return nextLv, skillType, skillId
end

function GetResetSkillLvCost()
    local costCfgId = 2
    local costNum = 0
    local vipLv = ManagerContainer.DataMgr.UserData:GetVipLv()
    local vipCfg = ManagerContainer.CfgMgr:GetVipCfgById(vipLv)
    if vipCfg and vipCfg.SkillReset >= 1 then
        return costCfgId, costNum
    end
    local cfg = GlobalConfig.Instance:GetConfigStrValue(182)
    if cfg and cfg ~= '' then
        local itemCfgs = string.split(cfg, ';')
        if itemCfgs then
            local resetCount = ManagerContainer.DataMgr.UserData:GetSkillResetCount()
            if resetCount < 0 then
                resetCount = 1
            else
                resetCount = resetCount + 1
            end
            local index = 0
            for _,v in pairs(itemCfgs) do
                if v and v ~= '' then
                    local itemCfg = string.split(v, ':')
                    if itemCfg and #itemCfg >= 2 then
                        if index < resetCount then
                            costCfgId = itemCfg[1] and tonumber(itemCfg[1]) or 1
                            costNum = itemCfg[2] and tonumber(itemCfg[2]) or 0
                        end
                        index = index + 1
                    end
                end
            end
        end
    end
    return costCfgId, costNum
end

function GetHeroIdBySlotSkillLowerLv(isBattle)
    local heroData = ManagerContainer.DataMgr.UserData:GetHeroData()
    local lowerLv = nil
    local lowerId = nil
    local lv
    local validSlotNum = 0
    if heroData and heroData.skillData then
        validSlotNum = heroData.skillData:GetUnlockSlotNum()
        for i = 1, validSlotNum do
            local skillId = heroData.skillData:GetSlotSkillId(i)
            if CommonUtil.CheckSkillCanLvUp(heroData, skillId) == 0 then
                lv = heroData.skillData:GetSkillLv(skillId)
                if not lowerLv or lowerLv > lv then
                    lowerLv = lv
                    lowerId = heroData.id
                end
            end
        end
    end
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    if partnerDatas then
        for _,v in pairs(partnerDatas) do
            if v and v.skillData then
                if not isBattle or v.isBattle then
                    validSlotNum = v.skillData:GetUnlockSlotNum()
                    for i = 1, validSlotNum do
                        local skillId = v.skillData:GetSlotSkillId(i)
                        if CommonUtil.CheckSkillCanLvUp(v, skillId) == 0 then
                            lv = v.skillData:GetSkillLv(skillId)
                            if not lowerLv or lowerLv > lv then
                                lowerLv = lv
                                lowerId = v.id
                            elseif lowerLv == lv then
                                if lowerId and lowerId > v.id then
                                    lowerId = v.id
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if not lowerId then
        return 0
    end
    return lowerId
end

function GetAllSlotSkillCanUpNum(isBattle)
    local num = 0
    local validSlotNum = 0
    local heroData = ManagerContainer.DataMgr.UserData:GetHeroData()
    if heroData and heroData.skillData then
        validSlotNum = heroData.skillData:GetUnlockSlotNum()
        for i = 1, validSlotNum do
            if CommonUtil.CheckSkillCanLvUp(heroData, heroData.skillData:GetSlotSkillId(i)) == 0 then
                num = num + 1
            end
        end
    end
    local partnerDatas = ManagerContainer.DataMgr.PartnerData:GetPartnerDatas()
    if partnerDatas then
        for _,v in pairs(partnerDatas) do
            if v and v.skillData then
                if not isBattle or v.isBattle then
                    validSlotNum = v.skillData:GetUnlockSlotNum()
                    for i = 1, validSlotNum do
                        if CommonUtil.CheckSkillCanLvUp(v, v.skillData:GetSlotSkillId(i)) == 0 then
                            num = num + 1
                        end
                    end
                end
            end
        end
    end
    return num
end

function HasSkillCanUp(heroId, isBattle)
    local heroData = ManagerContainer.DataMgr.UserData:GetHeroData(heroId)
    if heroData and heroData.skillData then
        if not isBattle or heroData.isBattle then
            local unlockSkillMap = heroData.skillData:GetUnlockSkillMap()
            if unlockSkillMap then
                for skillId, _ in pairs(unlockSkillMap) do
                    if CommonUtil.CheckSkillCanLvUp(heroData, skillId) == 0 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

--- 检查技能是否能升级
---@param heroId integer 英雄Id
---@param skillId integer 技能Id
---@return integer 0:能升级;其它查看Error_Code文件
function CheckSkillCanLvUp(heroData, skillId)
    if not heroData then
        return 133
    end
    local skillTreeCfgData = nil
    if ManagerContainer.DataMgr.UserData:IsLeaderHero(heroData.id) then
		skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
	else
		skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
	end
    if not skillTreeCfgData then
        return 133
    end
    local skillData = heroData.skillData
    if not skillData then
        return 133
    end
    if not skillData:GetIsUnlock(skillId) then
        return 134
    end
    local curLv = skillData:GetSkillLv(skillId)
    if curLv >= skillTreeCfgData.MaxLv then
        return 137
    end
    local upgradeLevel =  ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeLevelById(skillTreeCfgData.OpenLevel) --skillTreeCfgData.UpGradeLevel
    if not upgradeLevel or not upgradeLevel[curLv] then
        return 141
    end
    if (heroData.baseLevel < upgradeLevel[curLv]) then return 141 end
    local upgradeCost =  ManagerContainer.CfgMgr:GetSkillDemandCfgUpGradeCostById(skillTreeCfgData.OpenLevel) --skillTreeCfgData.UpGradeCost
    if not upgradeCost or not upgradeCost[curLv] or #(upgradeCost[curLv]) < 2 then
        return 139
    end
    local itemCfgId = upgradeCost[curLv][1]
    local itemNum = upgradeCost[curLv][2]
	if CommonUtil.GetOwnResCountByItemId(itemCfgId) < itemNum then
		return 139, itemCfgId
	end
    return 0
end

function GetDanCfg(danScore)
    if danScore == nil then
        return nil
    end
    
    local levelDatas = ManagerContainer.CfgMgr:GetArenaLevelDatas()
    for key=10001, 20000 do
        local levelCfg = levelDatas[key]
        if levelCfg~= nil then
            if danScore <= levelCfg.ArenaLevelScore then
                return levelCfg
            end
        end  
    end

    return nil
end

function GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    
    n = n or 0;
    n = math.floor(n)
    local fmt = '%.' .. n .. 'f'
    local nRet = tonumber(string.format(fmt, nNum))

    return nRet;
end

function GetPreciseDecimalFloor(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    n = n or 0;
    n = math.floor(n)
    if n < 0 then
        n = 0;
    end
    local nDecimal = 10 ^ n
    local nTemp = math.floor(nNum * nDecimal);
    local nRet = nTemp / nDecimal;
    return nRet;
end

--- 由服务器传输的浮点的价格容易出现后缀很多的问题，
--- 比如0.1传到lua变成0.100000001490116
function GetValidPayPrice(price)
    return CommonUtil.GetPreciseDecimalFloor(price + 0.0005, 3)
end

function ParseKeyValue2Map(item_list)
    local data = {}
    for _,v in pairs(item_list) do
        data[v.key] = v.value
    end
    return data
end

function ParseUITargetPath(wnd, resPath)
    if resPath == "" then
        return
    end
    resPath = resPath:gsub(" ", "")
    local path = resPath:split('.')
    local target = wnd
    local index = 1
    while index <= #path do
        local ok, err = pcall(function() return target[path[index]] end)
        if not ok then
            LogError(wnd.uiData.id.."  找不到资源对象  "..resPath)
            return
        else
            target = target[path[index]]
            if target == nil then
                LogError(wnd.uiData.id.."  找不到资源对象  "..resPath)
                return
            end
            index = index + 1
        end

    end

    return target
end

function GetEquipForgeTypeByCfgId(cfgId)
    local equipCfgData = ManagerContainer.CfgMgr:GetEquipById(cfgId)
    if equipCfgData.Type == Enum.SlotEquipType.Head then
        return Enum.ForgeType.Head
    elseif equipCfgData.Type == Enum.SlotEquipType.Body then
        return Enum.ForgeType.Body
    elseif equipCfgData.Type == Enum.SlotEquipType.Wrap then
        return Enum.ForgeType.Wrap
    elseif equipCfgData.Type == Enum.SlotEquipType.Shoes then
        return Enum.ForgeType.Shoes
    elseif equipCfgData.Type == Enum.SlotEquipType.Jew then
        return Enum.ForgeType.Jew
    elseif equipCfgData.Type == Enum.SlotEquipType.Weapon then
        if CommonUtil.EleInTable(Enum.JobWeaponMap.Sword, equipCfgData.JobType) then
            return Enum.ForgeType.Sword
        elseif CommonUtil.EleInTable(Enum.JobWeaponMap.Katar, equipCfgData.JobType) then
            return Enum.ForgeType.Katar
        elseif CommonUtil.EleInTable(Enum.JobWeaponMap.Bow, equipCfgData.JobType) then
            return Enum.ForgeType.Bow
        elseif CommonUtil.EleInTable(Enum.JobWeaponMap.Staff, equipCfgData.JobType) then
            return Enum.ForgeType.Staff
        elseif CommonUtil.EleInTable(Enum.JobWeaponMap.Priest, equipCfgData.JobType) then
            return Enum.ForgeType.Priest
        end
    end
    return nil
end

function GetFashionAttrMap(fashionMap)
    -- 时装有效属性
    local vaildMap = {}
    local vaildAttrStr = GlobalConfig.Instance:GetConfigStrValue(125)
	if vaildAttrStr then
		local vaildAttrArr = string.split(vaildAttrStr, ';')
        for i = 1, #vaildAttrArr do
            local attrId = tonumber(vaildAttrArr[i])
            if attrId then
                vaildMap[attrId] = 0
            end
		end
    end
	if fashionMap then
		for _,v in pairs(fashionMap) do
			if v and v.cfgId then
				local fashionData = ManagerContainer.CfgMgr:GetFashionById(v.cfgId)
				local fashionAttr = fashionData.FashionAttr
				-- 一条属性的时候
                if type(fashionAttr[1]) == 'number' then
                    local attrId = fashionAttr[1]
					if vaildMap[attrId] ~= nil then
						vaildMap[attrId] = vaildMap[attrId] + fashionAttr[2]
					end
				else
                    for _,v1 in pairs(fashionAttr) do
                        local attrId = v1[1]
						if vaildMap[attrId] ~= nil then
							vaildMap[attrId] = vaildMap[attrId]+ v1[2]
						end
					end
				end
			end
		end
	end
	return vaildMap
end

function checkNums( nums )
	local n = nums
	if n >= 0 then
		return n
	else
		n = 0 - n
		n = 0xffffffff - n + 1
	end
	return n
end
 
function And(num1,num2)
	local tmp1 = checkNums(num1)
	local tmp2 = checkNums(num2)
	local ret = 0
	local count = 0
	repeat
		local s1 = tmp1 % 2
		local s2 = tmp2 % 2
		if s1 == s2 and s1 == 1 then
			ret = ret + 2^count
		end
		tmp1 = math.modf(tmp1/2)
		tmp2 = math.modf(tmp2/2)
		count = count + 1
	until(tmp1 == 0 and tmp2 == 0)
	return ret
end
 
function Or(num1,num2)
	local tmp1 = checkNums(num1)
	local tmp2 = checkNums(num2)
	local ret = 0
	local count = 0
	repeat
		local s1 = tmp1 % 2
		local s2 = tmp2 % 2
		if s1 == s2 and s1 == 0 then
 
		else
			ret = ret + 2^count
		end
		tmp1 = math.modf(tmp1/2)
		tmp2 = math.modf(tmp2/2)
		count = count + 1
	until(tmp1 == 0 and tmp2 == 0)
	return ret
end
 
 
function Xor(num1,num2)
	local tmp1 = checkNums(num1)
	local tmp2 = checkNums(num2)
	local ret = 0
	local count = 0
	repeat
		local s1 = tmp1 % 2
		local s2 = tmp2 % 2
		if s1 ~= s2 then
			ret = ret + 2^count
		end
		tmp1 = math.modf(tmp1/2)
		tmp2 = math.modf(tmp2/2)
		count = count + 1
	until(tmp1 == 0 and tmp2 == 0)
	return ret
end

function Clamp(min, max, val)
    val = math.min(max, val)
    val = math.max(min, val)
    return val
end

function Get2Powers(...)
    local state = 0
    for _,v in pairs({...}) do
        state = state + 2^v
    end
    return state
end

function ResetAnimator(animator, name)
    animator:Play(name or "Idle");
    animator:Update(0);
end

function DeserializeGlobalStrToTable(val)
    local table = string.split(val, ';')
    local table1 = {}
    for _, value in pairs(table) do
        if value then
            if string.find(value, ':') then
                local info = string.split(value, ':')
                table1[#table1 + 1] = info
            else
                table1[#table1 + 1] = value
            end
        end
    end
    return table1
end

function DeserializeGlobalStrToNumberTable(val)
    local table = string.split(val, ';')
    local table1 = {}
    for _, value in pairs(table) do
        if value then
            if string.find(value, ':') then
                local info = string.split(value, ':')
                for i = 1, #info do
                    info[i] = tonumber(info[i])
                end
                table1[#table1 + 1] = info
            else
                table1[#table1 + 1] = tonumber(value)
            end
        end
    end
    return table1
end

--获取今天某个时间点的时间戳,比如你想获取今天五点的时间戳，可以传入数据:GetTodayTimeStamp(5)
function GetTodayTimeStamp(_h, _m, _s)
    local _curTime = ManagerContainer.LuaTimerMgr:CurLuaServerTime() / 1000;
    local _oneDaySeconds = ManagerContainer.LuaTimerMgr.OneDaySeconds
    _zeroOClockSeconds = #_curTime - math.fmod((#_curTime + 8 * 3600), _oneDaySeconds);
    _h = _h or 0;
    _m = _m or 0;
    _s = _s or 0;
    local _second = CommonUtil.GetSomeDayTimeStamp(_curTime, _h, _m, _s);
    return _second;
end

--获取某个时间戳所在天的某个时间点的时间戳,传参就是获得_stamp所在的天的_h时_m分_s秒的时间戳，注意：_stamp传入的是秒，不是毫秒
function GetSomeDayTimeStamp(_stamp, _h, _m, _s)
    _stamp = tonumber(tostring(_stamp));
    local _zeroOClockSeconds = 0;
    _zeroOClockSeconds = _stamp - math.fmod((_stamp + 8 * 3600), Constant.OneDaySeconds);
    _h = _h or 0;
    _m = _m or 0;
    _s = _s or 0;
    local _second = _zeroOClockSeconds + (_h or 0) * 3600 + (_m or 0) * 60 + _s or 0;
    return _second;
end

function GetHeadFrameDataById(_id)
    if _id and _id > 0 then
        local _data = ManagerContainer.CfgMgr:GetHeadFrameById(_id);
        if _data then
            return _data;
        else
            LogError("Can not find head frame data by id : " .. tostring(_id))
        end
    end
    return nil;
end

--返回的bool值表示是否找到了对应的数据，如果时false则表明返回的是默认头像框
function GetHeadFrameName(_id)
    if _id and _id > 0 then
        local _data = ManagerContainer.CfgMgr:GetHeadFrameById(_id)
        if _data then
            return _data.HeadFrameIcon, true
        else
            LogError("Can not find head frame data by id : " .. tostring(_id))
        end
    end
    return "", false
end

function SetPlayerHeadAndFrame(pageTbl,headNode,actorData,smallFrame, headFrame, onClickOwner, onClickCB, logicData, replaceParams)
    if headNode == nil  or actorData == nil then
        return
    end

    headNode.levelText:SetActive(actorData.Level ~= nil)
    if actorData.Level then
        headNode.levelText.text.text = tostring(actorData.Level)
    end

    if actorData.ProfessionIcon ~= nil and actorData.ProfessionIcon ~= "" then
        CommonUtil.LoadIcon(pageTbl, actorData.ProfessionIcon, function (sprite)
            headNode.jobIcon.image.sprite = sprite
        end,headNode, "PlayerJobIdx")
        headNode.jobIcon:SetActive(true)
    else
        headNode.jobIcon:SetActive(false)
    end

    CommonUtil.LoadIcon(pageTbl, actorData.HeadIcon, function (sprite)
        headNode.head.image.sprite = sprite
    end,headNode, "PlayerHeadIdx")

    if actorData.IsHero then
        headNode.frame:SetActive(true)
        headNode.headFrame:SetActive(false)

        local headFramePath = CommonUtil.GetHeadFrameName(headFrame);
        CommonUtil.LoadIcon(pageTbl, headFramePath, function (sprite)
            headNode.frame.image.sprite = sprite
        end,headNode, "PlayerHeadFrameIdx")
    else
        local frameIcon = Constant.Quality_White_Head_Frame_Icon
        if actorData.StrengthLevel == 100 then
            frameIcon = Constant.Quality_HeadFrame_Lead_Icon
        elseif actorData.StrengthLevel > 0 then
            frameIcon = Constant.Quality_HeadFrame_Icons[math.min(actorData.StrengthLevel, #Constant.Quality_HeadFrame_Icons)]
        end
        if replaceParams ~= nil and replaceParams.StrengthLevel ~= nil then
            frameIcon = Constant.Quality_White_Head_Frame_Icon
            if replaceParams.StrengthLevel == 100 then
                frameIcon = Constant.Quality_HeadFrame_Lead_Icon
            elseif replaceParams.StrengthLevel > 0 then
                frameIcon = Constant.Quality_HeadFrame_Icons[math.min(replaceParams.StrengthLevel, #Constant.Quality_HeadFrame_Icons)]
            end
        end
        --取消s资源
        --if smallFrame then
        --    frameIcon = frameIcon .."_s"
        --end
        headNode.frame:SetActive(false)
        headNode.headFrame:SetActive(true)
        CommonUtil.LoadIcon(pageTbl, frameIcon, function (sprite)
            headNode.headFrame.image.sprite = sprite
            end,headNode, "PlayerHeadFrameIdx")
    end

    if onClickOwner and onClickCB then
        headNode.head.button.interactable = true
        onClickOwner.uiBase:AddButtonUniqueEventListener(headNode.head.button, onClickOwner, onClickCB, logicData)
    else
        headNode.head.button.interactable = false
    end
end

function SetActorItemData(pageTbl,actorLua,actorData,bEnemy,UpdateSkillCDTimer)
    if actorLua == nil or actorData == nil then
		return
    end
    
    if actorLua.bgFriend ~= nil  then
        actorLua.bgFriend:SetActive(not bEnemy)
    end
    if actorLua.bgEnemy ~= nil then
        actorLua.bgEnemy:SetActive(bEnemy)
    end

    if actorLua.actorName~= nil  then
        actorLua.actorName.text.text = actorData.Name
    end

    if actorLua.hp~= nil then 
        actorLua.hp.image.fillAmount = 1
    end

    if actorLua.sp~= nil then
        actorLua.sp.image.fillAmount = 1
    end

    if actorLua.headItem~= nil then
        if actorLua.headItem.level~= nil then
            actorLua.headItem.level.text.text = "Lv."..tostring(actorData.Level)
        end

        if actorLua.headItem.jobIcon~= nil then
            if actorData.ProfessionIcon ~= nil and actorData.ProfessionIcon ~= "" then
                CommonUtil.LoadIcon(pageTbl, actorData.ProfessionIcon, function (sprite)
                    actorLua.headItem.jobIcon.image.sprite = sprite
                    end)
                actorLua.headItem.jobIcon:SetActive(true)
            else
                actorLua.headItem.jobIcon:SetActive(false)
            end
        end

        if actorLua.headItem.head ~= nil then
            CommonUtil.LoadIcon(pageTbl, actorData.HeadIcon, function (sprite)
                actorLua.headItem.head.image.sprite = sprite
                end)
        end
              
        if actorLua.headItem.headFrame~= nil then          
            -- 突破等级
            local frameIcon = Constant.Quality_White_Head_Frame_Icon
            if actorData.StrengthLevel == 100 then
                frameIcon = Constant.Quality_HeadFrame_Lead_Icon
            else
                frameIcon = Constant.Quality_HeadFrame_Icons[math.min(actorData.StrengthLevel, #Constant.Quality_HeadFrame_Icons)]
            end
            CommonUtil.LoadIcon(pageTbl, frameIcon, function (sprite)
                actorLua.headItem.headFrame.image.sprite = sprite
                end)

            if actorData.StrengthLevel == 100 then
                actorLua.headItem.headFrame.image.rectTransform.offsetMax = Vector2(0,22)
            else
                actorLua.headItem.headFrame.image.rectTransform.offsetMax = Vector2(0,0)
            end
        end
    end

    SetCurSkillInfo(actorLua.skillNode,actorData.CastSkillParam,pageTbl,UpdateSkillCDTimer)
    
    if actorLua.deadNode ~= nil then
        actorLua.deadNode:SetActive(false)
    end
end

function SetCurSkillInfo(skillNode,skillInfo,pageTbl,UpdateSkillCDTimer)
    if skillNode == nil or skillInfo == nil then
		return nil
	end

	CommonUtil.LoadIcon(pageTbl, skillInfo.skillIcon, function (sprite)
		skillNode.skillIcon.image.sprite = sprite
		end)

	skillNode.forbidNode:SetActive(skillInfo.IsForbidden)
	skillNode.extraNode:SetActive(skillInfo.IsEnhance)

	if skillInfo.IsCasting then
		skillNode.releaseNode:SetActive(true)
		skillNode.keepNode:SetActive(true)
		skillNode.skillProgress:SetActive(false)
		skillNode.waitNode:SetActive(false)
		skillNode.skillCD:SetActive(false)

		if skillInfo.teamSide == 0 then
			local timerHander = pageTbl.skillCDTimers[skillInfo.actorId]
			if timerHander ~= nil and timerHander ~= -1 then
				ManagerContainer.LuaTimerMgr:RemoveTimer(timerHander)
				pageTbl.skillCDTimers[skillInfo.actorId] = -1
			end
		else
			local timerHander = pageTbl.enemySkillCDTimers[skillInfo.actorId]
			if timerHander ~= nil and timerHander ~= -1 then
				ManagerContainer.LuaTimerMgr:RemoveTimer(timerHander)
				pageTbl.enemySkillCDTimers[skillInfo.actorId] = -1
			end
		end
		
	else
        if skillInfo.cdTime > 0 then
			UpdateSkillCD(skillNode,skillInfo.cdTime,skillInfo.cdTime)
			local cnt = skillInfo.cdTime*1000 / 100
			
			if skillInfo.teamSide == 0 then
				local timerHander = pageTbl.skillCDTimers[skillInfo.actorId]
				if timerHander ~= nil and timerHander ~= -1 then
					ManagerContainer.LuaTimerMgr:RemoveTimer(timerHander)
					pageTbl.skillCDTimers[skillInfo.actorId] = -1
                end

                if UpdateSkillCDTimer ~= nil then
                    timerHander = ManagerContainer.LuaTimerMgr:AddTimer(100, cnt, pageTbl, UpdateSkillCDTimer, {skillParam = skillInfo,totalTime = skillInfo.cdTime})
                    pageTbl.skillCDTimers[skillInfo.actorId] = timerHander
                end
			else
				local timerHander = pageTbl.enemySkillCDTimers[skillInfo.actorId]
				if timerHander ~= nil and timerHander ~= -1 then
					ManagerContainer.LuaTimerMgr:RemoveTimer(timerHander)
					pageTbl.enemySkillCDTimers[skillInfo.actorId] = -1
                end

                if UpdateSkillCDTimer ~= nil then
                    timerHander = ManagerContainer.LuaTimerMgr:AddTimer(100, cnt, pageTbl, UpdateSkillCDTimer, {skillParam = skillInfo,totalTime = skillInfo.cdTime})
                    pageTbl.enemySkillCDTimers[skillInfo.actorId] = timerHander
                end
			end		
		else
			skillNode.skillProgress.image.fillAmount = 0
			skillNode.skillCD.text.text = ""
			skillNode.waitNode:SetActive(true)
		end
		skillNode.releaseNode:SetActive(false)
		skillNode.keepNode:SetActive(false)
		skillNode.skillProgress:SetActive(true)
		skillNode.skillCD:SetActive(true)
	end
end

function UpdateSkillCD(skillNode,leftTime,totalTime)
    if skillNode == nil then
		return
	end

	local time = CommonUtil.GetPreciseDecimal(leftTime,1)
	if time > 0 then
		skillNode.skillProgress.image.fillAmount = time / totalTime
		skillNode.skillCD.text.text = tostring(time)
	else
		skillNode.skillProgress.image.fillAmount = 0
		skillNode.skillCD.text.text = ""
	end
	skillNode.waitNode:SetActive(time == 0)
end

function SetFighterLife(actorLua,life,maxLife)
    if actorLua == nil then
        return
    end

    if maxLife == nil or maxLife == 0 then
        return
    end

    if actorLua ~= nil then
		actorLua.hp.image.fillAmount = SDataUtil.InvConvert(life) / SDataUtil.InvConvert(maxLife)
		actorLua.deadNode:SetActive(SDataUtil.InvConvert(life) == 0)
	end
end

function SetFighterSp(actorLua,sp,maxSp)
    if actorLua == nil then
        return
    end

    if maxSp == nil or maxSp == 0 then
        return
    end

    if actorLua ~= nil then
		actorLua.sp.image.fillAmount = SDataUtil.InvConvert(sp)/ SDataUtil.InvConvert(maxSp)
	end
end

function SetFighterSkill(actorLua,skillParam,pageTbl,UpdateSkillCDTimer)
    if actorLua ~= nil then
		SetCurSkillInfo(actorLua.skillNode,skillParam,pageTbl,UpdateSkillCDTimer)
		if skillParam.IsCasting then
			actorLua.animator:Play("SkillRelease");
		elseif skillParam.IsForbidden then
			actorLua.animator:Play("SkillForbidden");
		else
			actorLua.animator:Play("SkillWait");
		end
	end
end

function SetCommonSkillItem(owner, skillItem, skillIdOrCfgData, skillLv, onClickCb, ...)
    if not skillItem then
        return
    end
    local skillCfgData
    if type(skillIdOrCfgData) == "table" then
        skillCfgData = skillIdOrCfgData
    else
        skillCfgData = skillIdOrCfgData and ManagerContainer.CfgMgr:GetSkillCfgById(skillIdOrCfgData) or nil
    end
    if skillCfgData then
        skillItem.icon.image.sprite = nil
        CommonUtil.LoadIcon(owner, skillCfgData.Icon, function (sprite)
            skillItem.icon.image.sprite = sprite
        end, skillItem, 'SkillIcon')
        if onClickCb then
            skillItem.icon.button.enabled = true
            owner.uiBase:AddButtonUniqueEventListener(skillItem.icon.button, owner, onClickCb, ...)
        else
            skillItem.icon.button.enabled = false
        end
        skillItem.num.text.text = (I18N.SetLanguageValue('Lv') .. tostring(skillLv))
        if skillCfgData.SpcSkillDec then
            skillItem.extTagTxt.text.text = string.formatbykey('LabelSkillGai')
            skillItem.extTag:SetActive(true)
        else
            skillItem.extTag:SetActive(false)
        end
    else
        skillItem.extTag:SetActive(false)
    end
end

function GetPlayerHeadIcon(briefInfo)
    if briefInfo == nil then
        return nil
    end

    local jobId = briefInfo.config_id 
    local sex = briefInfo.gender or 1
    local roleCfg    = ManagerContainer.CfgMgr:GetRoleDataById(CommonUtil.JobIdToRoleId(jobId,sex))
    return (roleCfg and roleCfg.HeadId or '')
end

--根据年月日判断今天是星期几,基姆拉尔森计算公式
function CalculateWeekDay(_y, _m, _d)
    local _mModf = 3 * math.modf((_m + 1) / 5);
    local _yModf = math.modf(_y / 4) + math.modf(_y / 100) + math.modf(_y / 400);
    local _YMD = _yModf + _mModf + 2 * _m + _d;
    local _weekDay = math.fmod(_YMD, 7);
    if _weekDay == 0 then
        return Enum.WeekDay.Sun;
    elseif _weekDay == 1 then
        return Enum.WeekDay.Mon;
    elseif _weekDay == 2 then
        return Enum.WeekDay.Tue;
    elseif _weekDay == 3 then
        return Enum.WeekDay.Wed;
    elseif _weekDay == 4 then
        return Enum.WeekDay.Thu;
    elseif _weekDay == 5 then
        return Enum.WeekDay.Fri;
    elseif _weekDay == 6 then
        return Enum.WeekDay.Sat;
    end
    return _weekDay;
end

--将时间转换成时分秒，规则是大于一天显示几天几小时，小于一天显示小时:分钟:秒
function FormatTimeDMS(_time)
    local _outPut, _outTime;
    if _time > 0 then
        _outTime = false;
        local _hours = _time / 60 / 60;
        if _hours > 24 then
            local _dayCount = math.floor(_hours / 24);
            local _hourCount = math.floor(_hours - _dayCount * 24);
            _outPut = tostring(_dayCount) .. I18N.T("D") .. tostring(_hourCount) .. I18N.T("H");	--XX天XX小時
        else
            local _itemStr = tostring(_time);
            _outPut = ManagerContainer.LuaTimerMgr:ParseSeconds2Time(tonumber(_itemStr));
        end
    else
        _outTime = true;
        _outPut = "00:00:00";
    end
    return _outPut, _outTime;
end

--number 保留3位小数 四舍五入
function Floor3PointNum(attrId, num)
    if attrId > 21 then
        return math.floor(SDataUtil.InvConvert(num) * 1000 + 0.5)* 0.001
    else
        return math.floor(SDataUtil.InvConvert(num))
    end
end

function ACKShowRewardList(reward_list)
    if reward_list == nil then return end

    local data = {}
    for _,v in pairs(reward_list) do
        data[v.key] = v.value
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD, data)
end

function ACKSpecialShowRewardList(reward_list)
    if reward_list == nil then return end

    local data = {}
    for _,v in pairs(reward_list) do
        data[#data + 1] = {v.key, v.value, v.vip}
    end
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_EQUIP_AND_ITEM_ADD_LIST, data)
end

function GetCurSeasonTitle(paramList)
    if nil == paramList then
        LogError("Nil ParamList");
        return;
    end
    local title = I18N.T("None")
    local titleIcon = nil;
    local competitionTitleIcon

    local selectionCompetitionDatas = ManagerContainer.CfgMgr:GetAllSelectionCompetitionDatas()
    local recruit = paramList[1]
    if recruit == 0 then
        recruit = 10
    end

    local curRecruitCfgData = ManagerContainer.CfgMgr:GetCompetitionDataById(recruit)
    if curRecruitCfgData then
        title = I18N.T(curRecruitCfgData.CompetitionTitle[1])
        competitionTitleIcon = curRecruitCfgData.CompetitionTitleIcon[1]
    end

    local rank = paramList[2]
    if rank == nil then
        return title, nil, competitionTitleIcon
    else
        if rank == 0 then
            rank = 100000
        end
        local curSelectionCfgData, idx = ManagerContainer.CfgMgr:GetCompetitionDatasByRank(selectionCompetitionDatas, recruit, rank)

        if curSelectionCfgData then
            title = title ..I18N.T(curSelectionCfgData.CompetitionTitle[idx])
            --competitionTitleIcon = curSelectionCfgData.CompetitionTitleIcon[idx]
        end

        return title, nil, competitionTitleIcon
    end
end
--local bit = require "bit"
--local bit_rshift = bit.rshift
--local bit_lshift = bit.lshift
--local bit_bor = bit.bor




function GetOnlineStatus(onlineStatus, offlineTime)
    if onlineStatus or (offlineTime == 0) then
        return string.formatbykey("FriendsOnline")
    else
        return CommonUtil.GetOfflineTimeStr(offlineTime)
    end
end


function GetOfflineTimeStr(offlineTime)
    local time = (ManagerContainer.LuaTimerMgr:CurLuaServerTime() - offlineTime) / 1000
    if time < 3600 then
        return string.formatbykey("FriendsOffline")
    elseif time < 86400 then
        local hours = math.floor(#time/3600)
        return string.formatbykey("FriendsOfflineHour",hours)
    elseif  time < 259200 then
        return string.formatbykey("FriendsOfflineDay",1)
    else
        return string.formatbykey("FriendsOfflineDay",3)
    end
end

function GetGuildPostStr(post)
	if post == Enum.GuildPostType.President then
		return string.formatbykey('GuildInfo_009')
	elseif post == Enum.GuildPostType.VicePresident then
		return string.formatbykey('GuildInfo_010')
	else
		return ''
	end
end

function ResLackErrorNotice(resId, resCost, dontNotice)
    local ownedCount = CommonUtil.GetOwnResCountByItemId(resId)
    if ownedCount < resCost then
        if not dontNotice then
            CommonUtil.ItemNotEnoughHandle(resId)
        end

        return true
    end
    return false
end

function ItemNotEnoughHandle(cfgId, id)
    if Constant.OpenPay then
        if cfgId then
            local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
            if cfgData then
                if cfgData.ResType == Enum.ItemType.Diamond then
                    local data = {"NoDiamondTip", nil, id, nil, CommonUtil.ItemNotEnoughSkipRuneShop}
                    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UINoticeTips, data)
                    return
                end
            end
        end
    end
    ManagerContainer.LuaUIMgr:ErrorNoticeDisplayWithParam(CommonUtil.GetItemNotEnoughInfo(cfgId))
end

function ItemNotEnoughSkipRuneShop(id)
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIRuneShop, {Enum.RuneShopType.Gifts, Enum.RuneShopSubType.Gold}, id)
end

function GetItemNotEnoughInfo(cfgId)
    if cfgId then
        local cfgData = ManagerContainer.CfgMgr:GetItemById(cfgId)
        if cfgData then
            local itemName = tostring(cfgData.Name)
            if cfgData.SourceFun and #cfgData.SourceFun > 0 then
                local sourceFunStr = nil
                for i = 1, #cfgData.SourceFun do
                    if sourceFunStr then
                        sourceFunStr = sourceFunStr .. ' , ' .. string.formatbykey('SourceFunColor', string.formatbykey('SourceFun' ..  tostring(cfgData.SourceFun[i])))
                    else
                        sourceFunStr = string.formatbykey('SourceFunColor', string.formatbykey('SourceFun' ..  tostring(cfgData.SourceFun[i])))
                    end
                end
                if sourceFunStr then
                    return 'ItemNotEnoughSource', itemName, sourceFunStr
                end
            end
            return 'ItemNotEnough', itemName
        end
    end
    return 'ItemNotEnoughDefault'
end

function TableToColor(table)
    if not table then return Color.white end
    return Color(table[1] or 0, table[2] or 0, table[3] or 0, table[4] or 1)
end
function GetSkillTreeCfgData(heroId,skillId)
    local skillTreeCfgData
    if ManagerContainer.DataMgr.UserData:IsLeaderHero(heroId) then
		skillTreeCfgData = ManagerContainer.CfgMgr:GetSkillTreeCfgById(skillId)
	else
		skillTreeCfgData = ManagerContainer.CfgMgr:GetParterSkillTreeCfgById(skillId)
    end
    return skillTreeCfgData
end

function CheckSkillCanAvance(heroId, skillId)
    local skillTreeCfgData = CommonUtil.GetSkillTreeCfgData(heroId,skillId)
    if not skillTreeCfgData then
        return 133
    end
	local herodata = ManagerContainer.DataMgr.UserData:GetHeroData(heroId)
	local jobdata  = ManagerContainer.CfgMgr:GetJobDataById(herodata.configId)
	if  jobdata and jobdata.JobStage < skillTreeCfgData.SkillBranch then
		return 200 --该角色尚未满足转职需求
	end
	local jobBranch  = jobdata and jobdata.JobBranch or 0
	local nextSkilldata
	if skillTreeCfgData.SuperSkill then
		if #skillTreeCfgData.SuperSkill > 1 and jobBranch ~= 0 then
			nextSkilldata = CommonUtil.GetSkillTreeCfgData(heroId,skillTreeCfgData.SuperSkill[jobBranch][2])
		else
			nextSkilldata = CommonUtil.GetSkillTreeCfgData(heroId,skillTreeCfgData.SuperSkill[1][2])
		end
	end
	local openLevel = nextSkilldata and nextSkilldata.OpenLevel or 0
    local openNeedCost = nextSkilldata.OpenNeedCost
	if openLevel > 0 then
		if (ManagerContainer.DataMgr.UserData:GetHeroLv(heroId) < openLevel) then return 141 end --角色等级不足
	end
	if openNeedCost then
		local openNeedCosts = nil
		if type(openNeedCost[1]) == 'number' then
			if #openNeedCost > 1 then
				openNeedCosts = {openNeedCost}
			end
		else
			openNeedCosts = openNeedCost
		end
		if openNeedCosts then
			for i = 1, #openNeedCosts do
				local itemCfgId = openNeedCosts[i][1]
				local itemNum = openNeedCosts[i][2]
				if CommonUtil.GetOwnResCountByItemId(itemCfgId) < itemNum then
					return 139, itemCfgId
				end
			end
		end
	end
    return 0
end

function GetPetSkillStarIconAndColor(petSkillList,skillLv)
    local count = 0
    if petSkillList then
        for _,v in pairs(petSkillList) do
            count = count + v.level
        end
    elseif skillLv then
        count = skillLv  
    else
        return
    end
    local idx = math.floor((math.max(count - 1, 0)) / 10) + 1
    local num = count % 10
    local num1 = num == 0 and 10 or num
    return Constant.Pet_Star_Icons[idx], string.format(Constant.Pet_Star_Text_Color[idx], num1), count
end

function ReplaceBattleSkillBySkillEquip(heroData, battleSkills)
    --神器技能替换
    local skillEquipSlot = heroData.skillEquipSlot
    if skillEquipSlot then
        local skillEquipSLotList = skillEquipSlot.slotList
        if skillEquipSLotList then
            for i = 1, #skillEquipSLotList do
                local skillEquipData = skillEquipSLotList[i]
                if skillEquipData.starLv > 0 then
                    local cfgData = ManagerContainer.CfgMgr:GetArtifactCfgDataByCfgId(skillEquipData.cfgId)
                    if cfgData then
                        for j = skillEquipData.starLv, 1, -1 do
                            local skills = cfgData.ArtifacFuncId[j]
                            if type(battleSkills) == "table" then
                                for _,v in pairs(battleSkills) do                          
                                    if v.skillId == skills[2] or v.skillId == skills[3] then                              
                                        v.skillId = skills[4]
                                    end
                                end
                            else
                                for i = 1, battleSkills.Length do
                                    local params = battleSkills[i - 1]
                                    if params.skillId == skills[2] or params.skillId == skills[3] then                                   
                                        params.skillId = skills[4]
                                        battleSkills[i - 1] = params
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return battleSkills
end

function UpdateHeroExtGoShowData(heroData)
    if not heroData then return end

    if not heroData.extGoesShowData then
        heroData.extGoesShowData = {}
    end
    if heroData.skillEquipSlot and heroData.skillEquipSlot.slotList then
        local curSkillEquipData = heroData.skillEquipSlot.slotList[1]
        if curSkillEquipData then
            heroData.extGoesShowData[Enum.HeroExtGoesShowType.God_Art] = curSkillEquipData.cfgId
        end
    end

    if heroData.strengthLevel then
        heroData.extGoesShowData[Enum.HeroExtGoesShowType.Strength_Halo] = heroData.strengthLevel
    end
end

function UpdatePetExtGoShowData(petData, heroData)
    if not petData or not heroData then return end

    if not petData.extGoesShowData then
        petData.extGoesShowData = {}
    end

    if heroData.battlePetId > 0 and heroData.petQiyueData and heroData.petQiyueData.slotList then
        local slotList = heroData.petQiyueData.slotList
        if #slotList > 0 then
            local data1 = petData.extGoesShowData[Enum.HeroExtGoesShowType.Pet_Qiyue]
            if not data1 then
                data1 = {}
            end
            data1.sumNum = 0
            data1.battlePetId = petData.cfgId
            data1.count = 0
            data1.cfgIds = {}

            for i = 1, #slotList do
                local data = slotList[i]
                if data.petId > 0 then
                    data1.cfgIds[#data1.cfgIds + 1] = data.petCfgId
                    data1.sumNum = data1.sumNum + data.petCfgId
                    data1.count = data1.count + 1
                end
            end
            petData.extGoesShowData[Enum.HeroExtGoesShowType.Pet_Qiyue] = data1
        end
    end
end
