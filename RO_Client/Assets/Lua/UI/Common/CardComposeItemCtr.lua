local CardComposeItemCtr = {}
local CardIconBigItemCtr = require("Common/CardIconBigItemCtr")

function CardComposeItemCtr:SetData(wnd, item, logicData, onClickOwner, onClickCB)
    local task = logicData.task
    local cfgId = task.cfgId
    local isAdd = task.isAdd
    local needShow = task.needShow
    local isCurIdx = logicData.isCurIdx

    local data = {cfgId = cfgId}
    CardIconBigItemCtr:SetData(wnd, item.cardIconBigItem, data, Enum.ItemIEnterType.CardRecreate)

    --DG.Tweening.DOTween.Kill(item.transform)
    item.animator:Play("CardMoveKeep")
    if isCurIdx and needShow then
        if item.oldTask and item.oldTask.cfgId ~= task.cfgId then
            if item.oldTask.isAnimationing then
                item.oldTask.isAnimationing = false
                if onClickOwner and onClickCB then
                    onClickCB(onClickOwner, item.oldTask, item)
                end
            end
        end

        local animationName = isAdd and "CardMoveIn" or "CardMoveOut"
        item.animator:Play(animationName)
        task.isAnimationing = true
        item.oldTask = task
        item.transform:DOScale(1, 0.25):OnComplete(function ()
            task.isAnimationing = false
            item.oldTask = nil
            if onClickOwner and onClickCB then
                onClickCB(onClickOwner, task, item)
            end
        end)
    else
        logicData.task.isAnimationing = false
    end
end

return CardComposeItemCtr