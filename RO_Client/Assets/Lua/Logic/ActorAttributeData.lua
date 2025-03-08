local ActorAttributeData = class("ActorAttributeData",require("DataBase"))

-- Enum EnActorAttribute
-- {
-- }

function ActorAttributeData:ctor()
    self.tbAttribut = {}
    self.actor_id = 0
    self.is_hero_pet = false
end

function ActorAttributeData:Clear()
    self.tbAttribut = {}
    self.actor_id = 0
    self.is_hero_pet = false
end

function ActorAttributeData:Destroy()
    self.tbAttribut = nil
end

function ActorAttributeData:SetAttribute(Key,value)
    local IsFinde = false
    for i=1,#self.tbAttribut do
        if tostring(self.tbAttribut[i].AttrKey) == tostring(Key) then
            self.tbAttribut[i].AttrValue = value
            IsFinde = true
        end
    end
    if not IsFinde then
        table.insert(self.tbAttribut,{AttrKey = Key,AttrValue = value})
    end  
end

function ActorAttributeData:GetAttribute(Key)
    for i=1,#self.tbAttribut do
        if self.tbAttribut[i].AttrKey == Key then
            return self.tbAttribut[i].AttrValue
        end
    end
    return nil
end

function ActorAttributeData:GetAllAttributeKey()
    local tbKeys = {}
    for i=1,#self.tbAttribut do
        table.insert(tbKeys,self.tbAttribut[i].AttrKey)
    end
    return tbKeys
end

return ActorAttributeData