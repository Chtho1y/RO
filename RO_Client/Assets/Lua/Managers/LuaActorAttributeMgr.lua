local LuaActorAttributeMgr = class('LuaActorAttributeMgr')
local AttributeData = require('ActorAttributeData')

function LuaActorAttributeMgr:ctor()
   self.tbListData = {}
   self.tbSyncActorRef = {}   
   self.listCb = {}
   self:RegisterNetEvents()
   --LogError("LuaActorAttributeMgr:ctor")
end

function LuaActorAttributeMgr:Clear()
    self.tbListData = {}
    self.tbSyncActorRef = {}
    self.listCb = {}
    --LogError("LuaActorAttributeMgr:Clear")
end

function LuaActorAttributeMgr:Destroy()
    self:UnRegisterNetEvents()
    --LogError("LuaActorAttributeMgr:Destroy")
    self.tbListData = {}
    self.tbSyncActorRef = {}
    self.listCb = {}
end

function LuaActorAttributeMgr:RegisterNetEvents()
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTOR_ATTR_GET_ACK, self.OnGetAttrAck, self)
    ManagerContainer.NetManager:NetRegister(ProtoMsgId.SC_ACTOR_ATTR_GET_NTF, self.OnGetAttrNTF, self)
end

function LuaActorAttributeMgr:UnRegisterNetEvents()
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ACTOR_ATTR_GET_ACK)
    ManagerContainer.NetManager:UnRegisterPbIdCallback(ProtoMsgId.SC_ACTOR_ATTR_GET_NTF)   
end

function LuaActorAttributeMgr:GenerateId()
    local i = 1    
    for k,v in pairs(self.listCb) do
        if v.Cb then            
            i = i + 1
        else
            return v.Id
        end        
    end
    return i
end

function LuaActorAttributeMgr:InsertCb(OkCb)
    local Id  = self:GenerateId()
    self.listCb[Id] = {Id = Id, Cb = OkCb}
    return Id
end

function LuaActorAttributeMgr:ClearCb(Key)
    if Key then
        for k,v in pairs(self.listCb) do
            if v and v.Id == Key then            
                v.Cb = nil
            end
        end
    end
end

function LuaActorAttributeMgr:ExecuteSycnCb()
    for k,v in pairs(self.listCb) do
        if v.Cb then            
          v.Cb()          
        end
    end
    self.listCb = {}
end

-----server msg
function LuaActorAttributeMgr:SendAttrReq()   
    local Senddata = 
    {        
        is_all_battle = true,
        actor_list = 
        {
        }
    }
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTOR_ATTR_GET_REQ, Senddata)
end

function LuaActorAttributeMgr:InitData(actor_id,is_hero,attr_list)
    local Data = self:GetOrCreateData(actor_id,is_hero_pet)
    for k,v in pairs(attr_list) do
        Data:SetAttribute( v.key,v.value)
    end
end

function LuaActorAttributeMgr:OnGetAttrAck(data)
    --LogError("OnGetAttrAck"..Inspect(data))
    self:SetAllData(data.actor_attr_list)
    self:SyncActorAttrProcess(false)   
    self:ExecuteSycnCb()
end
 
function LuaActorAttributeMgr:OnGetAttrNTF(Svrdatas)
    --LogError("OnGetAttrNTF"..Inspect(Svrdatas.actor_attr_list))
    self:ClearData()
    self:SetAllData(Svrdatas.actor_attr_list)
    self:SyncActorAttrProcess(true)
end
--------------
function LuaActorAttributeMgr:SetAllData(Svrdatas)
    if nil ~= Svrdatas then
        for k,v in pairs(Svrdatas) do           
            self:SetOrRefreshData(v)
        end
    end
end

function LuaActorAttributeMgr:SetOrRefreshData(Svrdata)
    if nil== Svrdata.attr_list then
        return
    end

    local Data = self:GetOrCreateData(Svrdata.actor_id,Svrdata.is_hero_pet)

    local test = {}
    for k,v in pairs(Svrdata.attr_list) do
        test[#test+1] = {key = v.key,value = v.value}
    end
    table.sort(
        test,
        function(Attr1, Attr2)
            return Attr1.key < Attr2.key
        end
    )
    --LogError(Inspect(test))
    --LogError("Pre"..Inspect(Data))
    for k,v in pairs(Svrdata.attr_list) do
        Data:SetAttribute( v.key,v.value)     
    end    
    --LogError("Finish"..Inspect(Data))
end

function LuaActorAttributeMgr:GetOrCreateData(Actorid,IsHero)
    local Data = self:TryGetData(Actorid,IsHero)
    if nil == Data then       
        Data = AttributeData:new()  
        Data.is_hero_pet  = IsHero 
        Data.actor_id  = Actorid  
        --LogError("Insert    "..tostring(Actorid))
        table.insert(self.tbListData,Data)       
    end
    return Data
end

function LuaActorAttributeMgr:ClearData()
    self.tbListData = {}
end

function LuaActorAttributeMgr:TryGetData(Actorid,IsHero)
    if #self.tbListData <= 0 then
        return nil
    else
        for i=1,#self.tbListData do
            local Data = self.tbListData[i]               
            if tostring(Data.actor_id) == tostring(Actorid) and Data.is_hero_pet == IsHero then
                --LogError("Reurn ok")
                return Data
            end
        end
    end
    return nil
end

--请求角色属性
function LuaActorAttributeMgr:OnCheckActorCb(NeedGetActor)
    local Senddata = 
    {        
        is_all_battle = false,
        actor_list = {}
    }
    for i=1,#NeedGetActor do
        local IsHero = NeedGetActor[i].IsHero
        local Id = NeedGetActor[i].Id
        table.insert( Senddata.actor_list,{is_hero_pet = IsHero,actor_id = Id,attr_list = {}})
    end
    -- LogError("Send...OnCheckActorCb.."..Inspect(Senddata))
    ManagerContainer.NetManager:SendMessage(ProtoMsgId.CS_ACTOR_ATTR_GET_REQ, Senddata)
end

function LuaActorAttributeMgr:SyncServerActorDataByArray(ActorDatas,Okcb)
    local NeedReqData = {}    
    if nil == ActorDatas then
        return
    end
    for i = 0, ActorDatas.Length-1 do
        local pActor = ActorDatas[i]
        table.insert(self.tbSyncActorRef,pActor)
        local Id = pActor:GetuId()
        local PetId = pActor.PetId
        local AtrrSvr = self:TryGetData(Id,not pActor.IsPet)
        if nil == AtrrSvr then
            table.insert(NeedReqData,{Id = Id,IsHero = not pActor.IsPet})
        end
        if nil ~= PetId and PetId ~= 0 then
            local pActorPet = ManagerContainer.LuaActorDataMgr:GetPetDataById(PetId)
            if nil ~= pActorPet then
                table.insert(self.tbSyncActorRef,pActorPet)
                local AtrrPetSvr = self:TryGetData(PetId - Enum.ActorUidField.Pet,false)
                if nil == AtrrPetSvr then
                    table.insert(NeedReqData,{Id = PetId - Enum.ActorUidField.Pet,IsHero = false})
                end
            end
        end
    end
    if #NeedReqData > 0 then 
        --LogError("不存在")
        local Cbid = 0
        if nil ~= Okcb then
            Cbid = self:InsertCb(Okcb)
        end       
        self:OnCheckActorCb(NeedReqData)--需要请求数据 
        return Cbid
    else
       -- LogError("已存在")
        self:SyncActorAttrProcess(false)
        if nil ~= Okcb then                   
            Okcb()--无需请求数据
        end
    end   
end

function LuaActorAttributeMgr:SyncServerActorDataByTb(ActorDatas,Okcb)    
    local NeedReqData = {}    
    if nil == ActorDatas then
        return
    end
    for i = 1, #ActorDatas do
        local pActor = ActorDatas[i]
        table.insert(self.tbSyncActorRef,pActor)
        local Id = pActor:GetuId()
        local PetId = pActor.PetId
        local AtrrOnline = self:TryGetData(Id,not pActor.IsPet)
        if nil == AtrrOnline then                  
            table.insert(NeedReqData,{Id = Id,IsHero = not pActor.IsPet})
        end
        if nil ~= PetId and PetId ~= 0 then            
            local pActorPet = ManagerContainer.LuaActorDataMgr:GetPetDataById(PetId)
            if nil ~= pActorPet then
                table.insert(self.tbSyncActorRef,pActorPet)
                local AtrrOnline = self:TryGetData(PetId - Enum.ActorUidField.Pet,false)
                if nil == AtrrOnline then
                    table.insert(NeedReqData,{Id = PetId - Enum.ActorUidField.Pet,IsHero = false})
                end
            end
        end
    end
    if #NeedReqData > 0 then 
        --LogError("不存在 服务器获取")
        local Cbid = 0
        if nil ~= Okcb then
            Cbid = self:InsertCb(Okcb)
        end       
        self:OnCheckActorCb(NeedReqData)--需要请求数据  
        return Cbid              
    else
        --LogError("存在 刷新")
        self:SyncActorAttrProcess(false)
        if nil ~= Okcb then                   
            Okcb()--无需请求数据
        end
    end   
end


function LuaActorAttributeMgr:SyncServerActorData(ActorData,Okcb)
    local NeedReqData = {}    
    if nil == ActorData then
        return
    end

    local pActor = ActorData    
    local Id = pActor:GetuId()
    if pActor.IsPet then
        local AtrrPetSvr = self:TryGetData(Id - Enum.ActorUidField.Pet,false)
        if nil == AtrrPetSvr then
            table.insert(NeedReqData,{Id = Id - Enum.ActorUidField.Pet,IsHero = false})
            table.insert(self.tbSyncActorRef,pActor)
        end
    else
        local AtrrSvr = self:TryGetData(Id,true)
        if nil == AtrrSvr then
            table.insert(NeedReqData,{Id = Id,IsHero = true})
            table.insert(self.tbSyncActorRef,pActor)
        end    
    end

    if #NeedReqData > 0 then 
        --LogError("不存在")
        local Cbid = 0
        if nil ~= Okcb then
            Cbid = self:InsertCb(Okcb)
        end               
        self:OnCheckActorCb(NeedReqData)--需要请求数据   
        return Cbid                    
    else
        --LogError("已存在")
        self:SyncActorAttrProcess(false)
        if nil ~= Okcb then                   
            Okcb()--无需请求数据
        end
    end   
end

function LuaActorAttributeMgr:SetServerActorToLocalActor(ActorData)
    if nil ~= self.tbListData then
        for i=1,#self.tbListData do
            local Data = self.tbListData[i]
            local ActorId = Data.actor_id 
            local IsHero = Data.is_hero_pet  
            if not IsHero then
                ActorId = ActorId + Enum.ActorUidField.Pet
            end
            if nil ~= ActorData then
                if tostring(ActorData:GetuId()) == tostring(ActorId) then                   
                    local tbKeys = Data:GetAllAttributeKey()                   
                    ActorData:ResetServerSecondAttr()
                    --LogError("set Actor "..tostring(ActorId).."  "..Inspect(tbKeys))                    
                    for j=1,#tbKeys do         
                        local Key =tbKeys[j]
                        --LogError("set"..tostring(Key))                                    
                        local value = Data:GetAttribute(Key)                                                
                        ActorData:SetServerSecondAttr(Key,value)   
                        --LogError("set Key".. tostring(Key).. "set value " .. tostring(value))                     
                    end
                    return true
                end
            end
        end
    end       
    return false
end

--同步服务器战斗属性
function LuaActorAttributeMgr:SyncActorAttrProcess(IsNotyfy)         
    if #self.tbSyncActorRef > 0 then--主动请求同步的
        local tbNewSyncActor = {}   
        for i=1, #self.tbSyncActorRef do
            local IsFinished = self:SetServerActorToLocalActor(self.tbSyncActorRef[i])
            if not IsFinished and nil ~= self.tbSyncActorRef[i] then
                table.insert(tbNewSyncActor,self.tbSyncActorRef[i])
            end
        end
        self.tbSyncActorRef = tbNewSyncActor
    end
    
    local TbLastAttriDiffrent = {}--修改前的属性    
    local TbAddAttriDiffrent = {}--记录同步前后的增加属性
    if IsNotyfy then--服务器通知的
        --同步 LuaActorDataMgr 里属性
        if nil ~= self.tbListData then
            for i=1,#self.tbListData do
                local Data = self.tbListData[i]
                local ActorId = Data.actor_id 
                local IsHero = Data.is_hero_pet
                local ActorData = nil
                if IsHero then
                    ActorData = ManagerContainer.LuaActorDataMgr:GetActorsById(ActorId)                
                else   
                    ActorId = ActorId + Enum.ActorUidField.Pet               
                    ActorData = ManagerContainer.LuaActorDataMgr:GetPetDataById(ActorId)
                end
                if nil ~= ActorData then                   
                    local tbKeys = Data:GetAllAttributeKey()
                    local OldData = AttributeData:new()  
                    local DiffrenceData = AttributeData:new()  
                    OldData.is_hero_pet  = Data.is_hero_pet 
                    OldData.actor_id  = Data.actor_id 
                    DiffrenceData.is_hero_pet  = Data.is_hero_pet 
                    DiffrenceData.actor_id  = Data.actor_id 
                     --save old
                    for j=1,#tbKeys do    
                        local Key = tbKeys[j] 
                        local value = SDataUtil.InvConvert(ActorData:GetFinalAttr(Key)or 0);
                        OldData:SetAttribute(Key,value)
                        table.insert( TbLastAttriDiffrent,OldData )
                    end
                    --cal Diffrence
                    for j=1,#tbKeys do         
                        local Key = tbKeys[j]
                        local value = Data:GetAttribute(Key)
                        local oldvalue = OldData:GetAttribute(Key)
                        if Key >= 7 and Key <= 21 then--记录2级属性变化
                            if value > oldvalue then
                                DiffrenceData:SetAttribute(Key,value - oldvalue)                                
                            end
                        end
                    end
                    table.insert( TbAddAttriDiffrent,DiffrenceData )
                    --set new
                    ActorData:ResetServerSecondAttr()                   
                    for j=1,#tbKeys do         
                        local Key = tbKeys[j]                      
                        local value = Data:GetAttribute(Key)
                        ActorData:SetServerSecondAttr(Key,value)                       
                    end          
                end
            end
        end
    end    
    -- LogError("New"..Inspect(self.tbListData))
    -- LogError("Old"..Inspect(TbLastAttriDiffrent))
    -- LogError("Dif"..Inspect(TbAddAttriDiffrent))
     --暂时不用  使用原有OLDATTR 赋值
    -- if #TbAddAttriDiffrent > 0 then-- 通知显示变更差
    --     for i=1,#TbAddAttriDiffrent do
    --         local Data = TbAddAttriDiffrent[i]
    --         local IsHero  = Data.is_hero_pet 
    --         local ActorId  = Data.actor_id 
    --         local tbKeys = Data:GetAllAttributeKey()
    --         for j=1,#tbKeys do         
    --             local Key = tbKeys[j]                      
    --             local value = Data:GetAttribute(Key)
    --             --LogError("Dif Key=".. tostring(Key).." Value = "..tostring(value))
    --         end     
    --     end
    -- end

    --保存修改前属性
    ManagerContainer.DataMgr.UserData:SaveLastTotalAttr()
    ManagerContainer.DataMgr.PartnerData:SaveLastTotalAttr()
  
    --之后 改变(下面推送刷新 改为监听)
    --刷新UserData .Attr
    ManagerContainer.DataMgr.UserData:RefreshAddPointAttr()
    ManagerContainer.DataMgr.PartnerData:InitPartnerPointAttr()
    --刷新UI界面属性
    if IsNotyfy then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.ACTOR_SERVER_CHANGE_ATTRS,TbAddAttriDiffrent)
    end
end

function LuaActorAttributeMgr:SyncServerActorDataToLocal()
    local teams = ManagerContainer.DataMgr.UserData:GetTeamData(true)
    local ourActors = System.Array.CreateInstance(Enum.TypeInfo.ActorData, #teams)
    for i = 1 , #teams do
        local actor = ManagerContainer.LuaActorDataMgr:GetActorsById(teams[i].uid,teams[i].id)        
        ourActors[i-1] = actor
    end
    self:SyncServerActorDataByArray(ourActors)
end

function LuaActorAttributeMgr:GetSvrSencondAttrValueById(id,Key)
    if nil ~= self.tbListData then
        for i=1,#self.tbListData do
            local Data = self.tbListData[i]
            local ActorId = Data.actor_id
            if tostring(id) == tostring(ActorId) then
                local tbKeys = Data:GetAllAttributeKey()                                      
                for j=1,#tbKeys do         
                    local AtrrKey =tbKeys[j]    
                    if tostring(AtrrKey) == tostring(Key) then                                
                        local value = Data:GetAttribute(AtrrKey)                                                
                        return value                   
                    end
                end
            end
        end
    end
end

return LuaActorAttributeMgr