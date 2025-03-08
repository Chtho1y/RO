local ExpeditionBuff = class("ExpeditionBuff")

function ExpeditionBuff:ctor(id,ratio,cd,type,extendPara,fun)
    self.buffId = id
    self.buffRatio = ratio
    self.buffCd = cd
    self.buffType = type
    self.extendPara = extendPara
    self.funList = {}
    self:AddFun(fun)
end

function ExpeditionBuff:AddFun(funs)
    if funs == nil then
        return
    end

    for i = 1, #funs do
        local funParam = funs[i]
        local fun = self:FindFunById(funParam[1])
        if fun == nil then
            self.funList[#self.funList+1] = DeepCopy(funParam)
        else
            fun[2] = fun[2] + funParam[2]
        end
    end
end

function ExpeditionBuff:FindFunById(funId)
    if self.funList == nil then
        return nil
    end

    for i = 1, #self.funList do
        if self.funList[i][1] == funId then
            return self.funList[i]
        end
    end

    return nil
end 

function ExpeditionBuff:ConvertFunToStr()
    if self.funList == nil or #self.funList == 0 then
        return ""
    end

    local funListStr = ""
    for i = 1, #self.funList do
        local fun = self.funList[i]
        if #fun > 0 then
            local funStr = ""
            for j = 1, #fun do
                if j == 1 then
                    funStr = tostring(fun[j])
                else
                    funStr = funStr .. ":" .. fun[j]
                end
            end

            if i == 1 then
                funListStr = funStr
            else
                funListStr = funListStr .. ";" .. funStr
            end
        end
    end
    return funListStr
end

return ExpeditionBuff