local PbManager = class("PbManager")
local pb = require "pb"
local protoc = require("3rd/lua-protobuf/protoc")

local p
function PbManager:ctor()
    p = protoc.new()

    --pb.option("int64_as_string")

    local list = LuaMgr.Instance:GetPbFiles()
    for i = 0, list.Count - 1 do
        --local content = pb.io.read(pbs[i])
        --local content = LuaMgr.Instance:ReadFile()
         pb.load(list[i])
        --pb.loadfile(list[i])
    end

    self.protoRequestName2Type = {}
    for name, number, type in pb.fields "serverproto.Request" do
        self.protoRequestName2Type[number] = type
        --print(name, number, type)
    end

    self.protoResponseId2Types = {}
    for name, number, type in pb.fields "serverproto.Response" do
        self.protoResponseId2Types[number] = type
        --print(name, number, type)
    end
end

function PbManager:GetEnumValue(enumTypeName, enumName)
    if pb then
        return pb.enum("serverproto." .. tostring(enumTypeName) , enumName)
    end
    return nil
end

function PbManager:EncodePb(id, param)
    local reqType = self.protoRequestName2Type[id]
    local bytes = nil;
    if reqType == nil then
        LogError(id.." net pb isnt exist")
        return bytes
    end
    if param ~= nil then
        bytes = assert(pb.encode(reqType, param))
    end

    if id == 1116 then
        local testData = pb.decode(reqType, bytes)
        --DebugHelper.LogError(tostring(param.t_uid));
        --DebugHelper.LogError(tostring(testData.t_uid));
    end
    
    --print(pb.tohex(bytes))
    return bytes
end

local function CheckUintType(pbType, data)
    for name, number, type1 in pb.fields(pbType) do
        if data[name] ~= nil then
            if type1 == "uint64" then
                if type(data[name]) == "table" then
                    --local list = {}
                    --for _,v in pairs(data[name]) do
                    --    local number = string.gsub(v, "#", "")
                    --    local a = uint64.new(number)
                    --    list[#list + 1] = a
                    --end
                    --data[name] = list
                else
                    --local number = string.gsub(data[name], "#", "")
                    --local a = uint64.new(number)
                    --data[name] = a
                    --LogError(tostring(data[name]))
                end
            elseif type1 == "sint64" then
                --if type(data[name]) == "table" then
                --    local list = {}
                --    for _,v in pairs(data[name]) do
                --        local number = string.gsub(v, "#", "")
                --        local a = int64.new(number)
                --        list[#list + 1] = a
                --    end
                --    data[name] = list
                --else
                --    local number = string.gsub(data[name], "#", "")
                --    local a = int64.new(number)
                --    data[name] = a
                --end
            else
                --CheckUintType(type1, data[name])
            end

            --if string.find(type1, ".serverproto.") ~= nil then
            --    CheckUintType(type1, data[name])
            --elseif type1 == "uint32"then
            --    local bytes = LuaUInt32.FromString(data[name])
            --    data[name] = LuaUInt32.BytesToUInt32(bytes)
            --elseif type1 == "uint64" then
            --    local bytes = LuaUInt64.FromString(data[name])
            --    data[name] = LuaUInt64.BytesToUInt64(bytes)
            --end
        end
    end
end

function PbManager:DecodePb(msgId, msgBody_)
    if self.protoResponseId2Types[msgId] == nil then
        LogError("ERROR...No Register Protocol: " .. msgId)
        return
    end
    
    local repType = self.protoResponseId2Types[msgId]
    local data = assert(pb.decode(repType, msgBody_))
    --CheckUintType(repType, data)
    return data
end

function PbManager:Destroy()
    self.protoRequestName2Type = nil
    self.protoResponseId2Types = nil

    if tolua.getpeer(self) ~= nil then
		tolua.setpeer(self, nil)
    end
end

return PbManager