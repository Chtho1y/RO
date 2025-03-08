local Entity = class("Entity")

function Entity:ctor(uid, pos, rot)
    self.uid = uid
    self.pos = pos
    self.rot = rot
    self.view = nil
end

function Entity:Dispose()
    self:ExitMap()
    self.uid = nil
    self.pos = nil
    self.rot = nil
    self.view = nil
end

function Entity:StatisticsPreloadAssets(multiTypeAssetLoadSystem)
    if self.view then
        self.view:StatisticsPreloadAssets(multiTypeAssetLoadSystem)
    end
end

function Entity:EnterMap()
    if self.view then self.view:EnterMap() end
end

function Entity:ExitMap()
    self:ExitWorld()
    if self.view then self.view:ExitMap() end
end

function Entity:EnterWorld()
    if self.view then self.view:EnterWorld() end
end

function Entity:ExitWorld()
    if self.view then self.view:ExitWorld() end
end

function Entity:Update(deltaTime)
    if self.view then self.view:Update(deltaTime) end
end


function Entity:SynPosition(pos)
    self.pos = pos
end

function Entity:GetPosition()
    return self.pos
end

function Entity:EnterTriggerArea()
    if self.view then self.view:EnterTriggerArea() end
end

function Entity:ExitTriggerArea()
    if self.view then self.view:ExitTriggerArea() end
end

return Entity