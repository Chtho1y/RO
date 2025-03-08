
table.unpack = table.unpack or unpack
function clone(object, setMetaTable)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        if not setMetaTable then
            return new_table
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

local objectCount = 0
local function getObjectCount()
    objectCount = objectCount + 1
    return objectCount
end

local create
create = function(c, obj, ...)
    if c.supers then
        for k,v in pairs(c.supers) do
            create(v, obj, ...)
        end
    elseif c.super then
        create(c.super, obj, ...)
    end

    if c.ctor then
        c.ctor(obj, ...)
    end
end

function class(classname, ...)
    local supers = {...}
    local super = supers[1]

    local superType = type(super)
    local cls = {}
    cls.__cname = classname
    
    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if superType == "function" or (super and super.__ctype == 1) then
        -- inherited from native C++ Object

        cls.__ctype = 1

        if superType == "table" then
            -- copy fields from super
            -- setmetatable(cls, super)
            for k,v in pairs(super) do cls[k] = v end
            cls.__create = super.__create
            cls.super    = super
        else
            cls.__create = super
        end

        function cls:new(o, ...)
            local instance = cls.__create(o, ...)
            tolua.setpeer(instance, {})
            -- instance.instUUId = getObjectCount()
            -- copy fields from class to native object
            for k,v in pairs(cls) do instance[k] = v end
            if tag then
                create(cls, instance, ...)
            else
                create(cls, instance, o, ...)
            end
            return instance
        end

    else
        -- inherited from Lua Object
        cls.super = super
        cls.supers = supers
        cls.__index = cls
        cls.__ctype = 2 -- lua

        if #supers == 1 then
            setmetatable(cls, super)
        else
            LuaExtend(cls, table.unpack(supers))
        end
     
        function cls:new(o, ...)
            local instance = setmetatable({}, cls)
            create(cls, instance, o, ...)
            -- -- instance.instUUId = getObjectCount()
            -- if iskindof(instance, "LuaMono") then
            --     instance:InitGameObject(o)
            --     create(cls, instance, ...)
            -- else
            --     create(cls, instance, o, ...)
            -- end
            return instance
        end
    end

    function cls:getClassName()
        return self.__cname
    end

    return cls
end

function instanceOf(cls)
    if cls and type(cls) == 'table' and cls.__cname then
        return cls.__cname
    end
    return NONE_CLASS
end

function iskindof(obj, className)
    local t = type(obj)

    if t == "table" then
        -- local mt = getmetatable(obj)
        -- while mt and mt.__index do
        local mt = obj
        if mt.__cname == className then
            return true
        elseif mt.supers then
            for k,v in pairs(mt.supers) do
                if iskindof(v, className) then
                    return true
                end
            end
        else
            return iskindof(obj.super, className)
        end
        return false

    elseif t == "userdata" then
        return false
    else
        return false
    end
end

function LuaExtend(src, ...)
    local meta = getmetatable(src)
    local parents = {...}

    setmetatable(src, {
        __index = function (tb, key)
            local v = rawget(tb, key)
            if not v and meta then
                local find = meta[key]
                if find then
                    return find
                end
            end

            for k,v in pairs(parents) do
                local find = v[key]
                if find then
                    return find
                end
            end
        end
    })
end

function addmetatable(src, super)
    local meta = getmetatable(src)

    setmetatable(src, {
        __index = function (tb, key)
            local v = rawget(tb, key)
            if not v and meta then
                local find = meta[key]
                if find then
                    return find
                end
            end

            find = super[key]
            if find then
                return find
            end
        end
    })
end