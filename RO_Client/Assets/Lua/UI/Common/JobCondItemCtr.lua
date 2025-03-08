local JobCondItemCtr = {}

function JobCondItemCtr:SetData(wnd, itemlua, logicData, enterType)
    local condId = logicData.condId
    local tasks = logicData.tasks
    local condData = ManagerContainer.CfgMgr:GetCondDataById(condId)
    local conditions = condData.Condition[1]
    itemlua.cond.text.text = CommonUtil.TaskDescParse(conditions)
    local process = 0
    if tasks == nil then
        process = 0
    else
        for k,v in pairs(tasks.progress) do
            process = process + v.value
        end
    end

    itemlua.num.text.text = CommonUtil.StringConcat('(',process,'/', conditions[#conditions],')')

    itemlua.completed:SetActive(tasks ~= nil and tasks.state > Enum.TaskStateType.NoCompeleted)
end

return JobCondItemCtr