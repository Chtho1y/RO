--[[
    基于LRU算法的数据表
]]

local LRUMap = class("LRUMap")

function LRUMap:ctor(maxLength)
    self.nodeMap = {}   -- 通过key获得Node
    self.firstNode = nil
    self.lastNode = nil
    self.length = 0
    self.maxLength = maxLength or 10
end

function LRUMap:Get(key)
    local node = self.nodeMap[key]
    if not node then
        return nil
    end
    self:UpdateNode(node)
    return node.value or node.key
end

function LRUMap:Set(key, value)
    local node = self.nodeMap[key]
    if not node then
        return
    end
    node.value = value
    self:UpdateNode(node)
end

function LRUMap:Add(key, value)
    local node = self.nodeMap[key]
    if node then
        node.value = value
        self:UpdateNode(node)
    else
        while(self.length >= self.maxLength) do
            self:RemoveNode(self.firstNode)
        end
        node = { prev = nil, key = key, value = value, next = nil }
        self.nodeMap[key] = node
        self:AddNode(node)
    end
end

function LRUMap:Remove(key)
    local node = self.nodeMap[key]
    if node then
        self.nodeMap[key] = nil
        self:RemoveNode(node)
        return true
    end
    return false
end

function LRUMap:Clear()
    for key, node in pairs(self.nodeMap) do
        self:Remove(key)
    end
    self.nodeMap = {}
    self.firstNode = nil
    self.lastNode = nil
    self.length = 0
end

LRUMap.__tostring = function(self)
    local str = "{\n"
    local node = self.firstNode
    while node do
        local key = node.key
        local value = node.value
        if value then
            str = str .. key .. "=" .. Inspect(value) .. ",\n"
        else
            str = str .. Inspect(key) .. ",\n"
        end
        node = node.next
    end
    str = str .. "}"
    return str
end


---------------------------- 内部调用，理论上不在外部调用 Start -----------------------

-- 增加节点
function LRUMap:AddNode(node)
    self.length = self.length + 1
    self:AddNodeToLast(node)
end

-- 删除节点
function LRUMap:RemoveNode(node)
    self:ExtractNode(node)
    node.key = nil
    node.value = nil
    node = nil
    self.length = self.length - 1
end

-- 更新节点
-- 节点被访问，则需要把节点更新到末尾
function LRUMap:UpdateNode(node)
    if self.lastNode == node then
        return
    end
    self:ExtractNode(node)
    self:AddNodeToLast(node)
end

function LRUMap:AddNodeToLast(node)
    if self.lastNode then
        self.lastNode.next = node
        node.prev = self.lastNode
        self.lastNode = node
    else
        self.firstNode = node
        self.lastNode = node
    end
end

-- 把节点从队列中提取出来
function LRUMap:ExtractNode(node)
    local prev = node.prev
    local next = node.next
    if prev then
        prev.next = next
    end
    if next then
        next.prev = prev
    end
    node.prev = nil
    node.next = nil
    if self.firstNode == node then
        self.firstNode = next
    end
    if self.lastNode == node then
        self.lastNode = prev
    end
end

---------------------------- 内部调用，理论上不在外部调用 End   -----------------------


return LRUMap