local ScrollNoticeView = class("ScrollNoticeView")

local moveSpeed = 3
local delay = 2
local pos = Vector2.zero
local timerId

local updateHandle
local contentLength

function ScrollNoticeView:ctor()
    if not updateHandle then
        updateHandle = UpdateBeat:CreateListener(self.Update, self)
    end

    UpdateBeat:AddListener(updateHandle)
end

function ScrollNoticeView:Init(root)
    self.root = root

    self.noticeList = {}

    self.startPos = root.startPoint
    self.endPos = root.endPoint
    self.content = root.content

    pos = self.startPos.rectTransform.anchoredPosition
end

function ScrollNoticeView:InsertGMNotice(notice)
    if not notice.content or notice.content == "" or not notice.content or notice.count == 0 then
        return
    end
    self.root:SetActive(true)
    self:Reset()

    --notice.content = "商城购买商城购买商城购买商城购买商城购买商城购买商城购买商城购买商城购买！！！！！！！！！！！！"
    --notice.speed = moveSpeed
    --notice.count = 4
    --notice.interval = 2

    table.insert(self.noticeList, notice)

    self:StartNextNotice()
end

function ScrollNoticeView:StartNextNotice()
    if not self.data and #self.noticeList > 0 then
        local notice = table.remove(self.noticeList, #self.noticeList)
        self.pause = true
        self.data = notice
        self.content.text.text = self.data.content or ""
        self.content.contentSizeFitter:SetLayoutHorizontal()
        contentLength = self.content.rectTransform.rect.size.x

        self.count = self.data.count or 0
        self.speed = (not self.data.speed or self.data.speed == 0) and moveSpeed or self.data.speed

        timerId = ManagerContainer.LuaTimerMgr:AddTimer(delay, 1, self, self.PlayNotice, nil)
    end
end

function ScrollNoticeView:PlayNotice()
    if self.count == 0 then
        self:Reset()
        return
    end
    if self.data then
        self.pause = false
        pos = self.startPos.rectTransform.anchoredPosition
        self.content.rectTransform.anchoredPosition = pos

        self.count = self.count - 1
    end
end

function ScrollNoticeView:Update()
    if not self.pause and self.data then
        pos.x = pos.x - self.speed
        self.content.rectTransform.anchoredPosition = pos

        local delta = self.endPos.rectTransform.anchoredPosition.x - pos.x
        if delta >= contentLength then
            if self.count > 0 then
                self.pause = true
                timerId = ManagerContainer.LuaTimerMgr:AddTimer(self.data.interval*1000, 1, self, self.PlayNotice, nil)
            else
                --结束
                ManagerContainer.DataMgr.GMNoticeData:NilCurNotice()
                self:Reset()
                --self.root:SetActive(false)
                if #self.noticeList > 0 then
                    self:StartNextNotice()
                else
                    self.root.animator:Play("NoticeClose")
                end
            end
        end
    end
end

function ScrollNoticeView:Reset()
    if timerId then
        ManagerContainer.LuaTimerMgr:RemoveTimer(timerId)
        timerId = nil
    end

    self.data = nil
    self.count = 0
    self.pause = false
    self.content.rectTransform.anchoredPosition = pos
end

function ScrollNoticeView:Dispose()
    self:Reset()

    if updateHandle ~= nil then
        UpdateBeat:RemoveListener(updateHandle)
        updateHandle = nil
    end

    self.root = nil
    self.sartPos = nil
    self.endPos = nil
    self.content = nil
end

return ScrollNoticeView