local CON, E, L, V, P, G = unpack(select(2, ...))
local ObjectName = 'Soulbind'
local LogCategory = 'USoulbind'

Soulbind = {}

function Soulbind:new(inObject)
    local _typeof = type(inObject)
    local _newObject = true

	assert(inObject == nil or 
	      (_typeof == 'table' and inObject.__name ~= nil and inObject.__name == ObjectName),
	      "argument must be nil or " .. ObjectName .. " object")

    if(_typeof == 'table') then
        Object = inObject
        _newObject = false
    else
        Object = {}
    end
    setmetatable(Object, self)
    self.__index = self
    self.__name = ObjectName

    if(_newObject) then
        self._Key = nil
        self._ID = nil
		self._Name = nil
        self._IconID = nil
        self._Initialized = false
    end

    return Object
end

function Soulbind:IsInitialized(inBoolean)
    assert(inBoolean == nil or type(inBoolean) == 'boolean', "argument must be nil or boolean")
    if(inBoolean ~= nil) then
        self._Initialized = inBoolean
    end
    return self._Initialized
end

function Soulbind:Initialize()
    if(self:IsInitialized() == false and self._ID ~= nil) then
        local _SoulbindInfo = C_Soulbinds.GetSoulbindData(self:GetID())
        self:SetName(_SoulbindInfo.name)
        
        if(self:GetName() == 'Kyrian') then
            self:SetIconID(3257748)
        elseif(self:GetName() == 'Venthyr') then
            self:SetIconID(3257751)
        elseif(self:GetName() == 'Night Fae') then
            self:SetIconID(3257750)
        elseif(self:GetName() == 'Necrolord') then
            self:SetIconID(3257749)
        end

        self:IsInitialized(true)
    end
    return self:IsInitialized()
end

function Soulbind:Print()
    CON:SingleLine(LogCategory)
    CON:Debug(LogCategory, ObjectName .. " Object")
    CON:Debug(LogCategory, "  _Key (" .. type(self._Key) .. "): ".. tostring(self._Key))
    CON:Debug(LogCategory, "  _ID (" .. type(self._ID) .. "): ".. tostring(self._ID))
    CON:Debug(LogCategory, "  _Name (" ..type(self._Name) .. "): ".. tostring(self._Name))
    CON:Debug(LogCategory, "  _Initialized (" .. type(self._Initialized) .. "): " .. tostring(self._Initialized))
end

function Soulbind:GetKey()
    return self._Key
end

function Soulbind:SetKey(inKey)
    assert(type(inKey) == 'number')
    self._Key = inKey
    return self:GetKey()
end

function Soulbind:GetName()
    return self._Name
end

function Soulbind:SetName(inName)
    assert(type(inName) == 'string')
    self._Name = inName
    return self:GetName()
end

function Soulbind:GetID()
    return self._ID
end

function Soulbind:SetID(inID)
    assert(type(inID) == 'number')
    self._ID = inID
    return self:GetID()
end

function Soulbind:GetIconID()
    return self._IconID
end

function Soulbind:SetIconID(inIconID)
    assert(type(inIconID) == 'number')
    self._IconID = inIconID
    return self:GetIconID()
end

function Soulbind:Equals(inSoulbind)
    if(inSoulbind == nil) then return false end
    if(type(inSoulbind) ~= 'table' or inSoulbind.__name == nil or inSoulbind.__name ~= 'Soulbind') then return false end
    if(self:GetKey() ~= inSoulbind:GetKey()) then return false end
    return true
end