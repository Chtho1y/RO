local UIPetExchangeMatsCtr = class("UIPetExchangeMatsCtr", require("UICtrBase"))

function UIPetExchangeMatsCtr:Init(view)
	self.view = view
end

function UIPetExchangeMatsCtr:SetData(data)
	self.asyncIdx = 0
	if data == nil then return end
	self.data = data
    self.tempselectCount = self.data.selectInfo.selectCount
    if self.data.selectInfo and self.data.selectInfo.conditions  then
        self.data.selectInfo.maxNum = self.data.selectInfo.conditions[4]
    end
end
function UIPetExchangeMatsCtr:RefreshShowDataType()
    local showDataLength = 0
    if self.data.list then
        showDataLength = #self.data.list
        if self.row and self.minColumn then
            local curColumn = Mathf.Ceil(showDataLength / self.row) + 4
            if curColumn < self.minColumn then
                curColumn = self.minColumn
            end
            showDataLength = curColumn * self.row
        end
    end
    self.showDataLength = showDataLength
end

function UIPetExchangeMatsCtr:SetGridRowColumn(row, minColumn)
    self.row = row
    self.minColumn = minColumn
end

function UIPetExchangeMatsCtr:Getconditions()
    return self.data.selectInfo.conditions
end

function UIPetExchangeMatsCtr:GetenterType()
    return self.data.selectInfo.enterType
end

function UIPetExchangeMatsCtr:GetIndexInfo()
    return self.data.selectInfo.indexInfo
end

function UIPetExchangeMatsCtr:GetotherSelectList()
    return self.data.selectInfo.otherSelectList
end

function UIPetExchangeMatsCtr:GetSelectList()
    return self.data.selectInfo.selectList
end

function UIPetExchangeMatsCtr:GetSelectCount()
    return self.data.selectInfo.selectCount
end
function UIPetExchangeMatsCtr:GetTempSelectCount()
    return self.tempselectCount
end

function UIPetExchangeMatsCtr:SetCurrSelectCount(count)
   self.data.selectInfo.selectCount = count
end

function UIPetExchangeMatsCtr:executeCallBack()
    if self.data.callback then
        self.data.callback[2](self.data.callback[1],self.data.selectInfo)
    end
end

function UIPetExchangeMatsCtr:GetMaxSelectNum()
    return self.data.selectInfo.conditions and self.data.selectInfo.conditions[4] or 0
end

function UIPetExchangeMatsCtr:GetShowDataLength()
    return self.showDataLength or 0
end

function UIPetExchangeMatsCtr:GetRealShowDataLength()
    return self.data.list and #self.data.list or 0
end

function UIPetExchangeMatsCtr:GetShowDatas()
    return self.data.list
end

function UIPetExchangeMatsCtr:GetShowData(itemIndex)
    return self.data.list and self.data.list[itemIndex + 1] or nil
end

function UIPetExchangeMatsCtr:GetPetDataById(id)
    for k,v in pairs(self.data.list) do
        if v.id == id then
            return v, k
        end
    end
    return nil, nil
end

function UIPetExchangeMatsCtr:GetAsyncIdx()
	self.asyncIdx = self.asyncIdx + 1
	return self.asyncIdx
end

function UIPetExchangeMatsCtr:GetData()
	return self.data
end

function UIPetExchangeMatsCtr:OnDispose()
	self.data = nil
	self.view = nil
end

return UIPetExchangeMatsCtr


