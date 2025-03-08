local MainBottomView = class("MainBottomView")

local showAni = "BottomShow"
local closeAni = "BottomClose"

function MainBottomView:ctor()
    self.root = nil
    self.state = true
    self.animator = nil
    self.mCanvas = nil
    self.lastSortingOrder = 0
    self.defaultSortingOrder = 0
end

function MainBottomView:Init(root, canvas, animator, sortingOrder)
    self.root = root
    self.mCanvas = canvas
    self.animator = animator
    self.defaultSortingOrder = sortingOrder
    self.lastSortingOrder = self.defaultSortingOrder
end

function MainBottomView:Change(state, order)
    if self.mCanvas == nil then return end

    if state then
        if ManagerContainer.LuaUIMgr:NeedMainHideBottom() then
            return
        end
    end

    if state then
        self.lastSortingOrder = self.mCanvas.sortingOrder
        self.mCanvas.sortingOrder = math.max(1000, (order or 1000) + 1)
    else
        self.mCanvas.sortingOrder = self.lastSortingOrder
    end

    if self.state ~= state then
        self.state = state
        self.animator:Play(state and showAni or closeAni)
    end
end
function MainBottomView:Resume()
    if self.mCanvas == nil then return end

    self.mCanvas.sortingOrder = self.defaultSortingOrder
    self.state = false
    self.animator:Play(closeAni)
end

function MainBottomView:Dispose()
    self.animator = nil
    self.mCanvas = nil

    self.root = nil
end

return MainBottomView