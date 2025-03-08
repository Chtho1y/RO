local ChatUnLock = class("ChatUnLock")
local ConditionJudge = require("Common/ConditionJudge")
function ChatUnLock:CheckCondition(data)
    local conds = data.UnlockCond
    local result, val, content
    local result1, val1, content1
    for i = 1, #conds do
        local cond = conds[i]
        if cond then
            result1, val1, content1 = ConditionJudge:ConditionPassResult1(cond)
            if result1 then
                result = true
                break
            else
                if not content and not val and  content1 and content1 ~= '' then
                    val = val1
                    content = content1
                end
            end
        end
    end
    return result, val, content
end
return ChatUnLock