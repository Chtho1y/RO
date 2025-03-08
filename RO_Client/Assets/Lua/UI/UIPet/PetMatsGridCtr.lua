local PetMatsGridCtr = class("PetMatsGridCtr")

function PetMatsGridCtr:ctor()
    self.root = nil
end

function PetMatsGridCtr:InitRoot(root, enterType)
    self.enterType = enterType
    self.root = root
    if self.root.SetChildController then
        self.root:SetChildController(self)
    end
end

function PetMatsGridCtr:RefreshShowDataType()
    if self.enterType >= Enum.ItemIEnterType.PetRoot and self.enterType <= Enum.ItemIEnterType.PetQiyueMat then
        self.showDatas = self:RefreshPetDatas()
    elseif self.enterType == Enum.ItemIEnterType.SkillEquip then
        self.showDatas = self:RefreshSkillEquipDatas()
    end
   
    if self.root.SetShowDatas then
        self.root:SetShowDatas(self.showDatas)
    end

    local showDataLength = 0
    if self.showDatas then
        showDataLength = #self.showDatas
        if self.row and self.minColumn then
            local curColumn = Mathf.Ceil(showDataLength / self.row) + 2
            if curColumn < self.minColumn then
                curColumn = self.minColumn
            end
            showDataLength = curColumn * self.row
        end
    end
    self.showDataLength = showDataLength
end

function PetMatsGridCtr:SetGridRowColumn(row, minColumn)
    self.row = row
    self.minColumn = minColumn
end

function PetMatsGridCtr:GetShowDataLength()
    return self.showDataLength or 0
end

function PetMatsGridCtr:GetRealShowDataLength()
    return self.showDatas and #self.showDatas or 0
end

function PetMatsGridCtr:GetShowDatas()
    return self.showDatas
end

function PetMatsGridCtr:GetShowData(itemIndex)
    return self.showDatas and self.showDatas[itemIndex + 1] or nil
end

function PetMatsGridCtr:RefreshPetDatas()
    return self.root:RefreshPetDatas()
end

function PetMatsGridCtr:RefreshSkillEquipDatas()
    return self.root:RefreshSkillEquipDatas()
end

function PetMatsGridCtr:GetPetDataById(id)
    for k,v in pairs(self.showDatas) do
        if v.id == id then
            return v, k
        end
    end
    return nil, nil
end

function PetMatsGridCtr:Dispose()
    if self.showDatas then
        for _,v in pairs(self.showDatas) do
            v.selected = 0
            v.canUse = false
            v.isUsed = false
        end
    end
    self.showDatas = nil
    self.root = nil
end

return PetMatsGridCtr