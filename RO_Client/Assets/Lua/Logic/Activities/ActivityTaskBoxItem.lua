local ActivityTaskBoxItem = class("ActivityTaskBoxItem")

function ActivityTaskBoxItem:ctor(cfg)
    self.boxId = cfg.Id
    self.score = cfg.Integral
    self.rewards = cfg.Rewards
    self.isGotReward = false
    self.bCanGet = false
end

function ActivityTaskBoxItem:ShowRewards()
    return self.rewards
end

function ActivityTaskBoxItem:SetGoReward(bGot)
    self.isGotReward = bGot
    if self.rewards ~= nil then
        for i = 1, #self.rewards do
            self.rewards[i][3] = self.isGotReward
        end
    end
end

function ActivityTaskBoxItem:IsGotReward()
    return self.isGotReward
end

function ActivityTaskBoxItem:SetCanGet(ok)
    self.bCanGet = ok
end

function ActivityTaskBoxItem:IsCanGet()
    return self.bCanGet
end

return ActivityTaskBoxItem
