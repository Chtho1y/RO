local TrunWheelData = class("TrunWheelData")

function TrunWheelData:ctor()
    self.nIndex = 0
    self.nItemId = 0
    self.strItemIcon = ""
    self.nItemNum = 1
    self.bIsGrandPrize = false                  --是否大奖
    self.hasReceive = false                     --是否领取
end

return TrunWheelData