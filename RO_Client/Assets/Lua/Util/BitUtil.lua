local BitUtil = class("BitUtil")

function BitUtil.ParseMailReadState(state)
    return Bit.band (1, state)
end

function BitUtil.ParseMailRewardState(state)
    return Bit.band (1, Bit.rshift (state, 1))
end

function BitUtil.RshiftNumBandOne(num, pos)
    return Bit.band (1, Bit.rshift (num, pos))
end

return BitUtil
