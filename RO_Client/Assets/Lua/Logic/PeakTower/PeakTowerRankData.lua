local PeakTowerRankData = class("PeakTowerRankData")

function PeakTowerRankData:ctor(rankData)
    self:RefreshData(rankData)
end

function PeakTowerRankData:RefreshData(rankData)
    self.rank = rankData.rank
    self.briefInfo = ProtocalDataNormal.ParseCommonPlayerBriefInfo(rankData.brief_info)
    self.score = rankData.score
end

return PeakTowerRankData