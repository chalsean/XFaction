local CON, E, L, V, P, G = unpack(select(2, ...))
local ObjectName = 'ChatFrame'
local LogCategory = 'FChat'
local IconTokenString = '|T%d:16:16:0:0:64:64:4:60:4:60|t'

ChatFrame = {}

function ChatFrame:new(inObject)
    local _typeof = type(inObject)
    local _newObject = true

	assert(inObject == nil or 
	      (_typeof == 'table' and inObject.__name ~= nil and inObject.__name == ObjectName),
	      "argument must be nil, string or " .. ObjectName .. " object")

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
        self._Initialized = false
        self._ElvUI = false     
        self._ElvUIModule = nil 
        self._ChatFrameHandler = nil  
    end

    return Object
end

function ChatFrame:Initialize()
	if(self:IsInitialized() == false) then
		self:SetKey(math.GenerateUID())
        if IsAddOnLoaded('ElvUI') then
            local _Status, _Enabled = pcall(function()
                return ElvUI[1].private.chat.enable
            end)
            if _Status and _Enabled then
                CON:Info(LogCategory, "Using ElvUI chat handler")
                self:IsElvUI(true)
                self._ElvUIModule = ElvUI[1]:GetModule('Chat')
                self._ChatFrameHandler = function(...) self._ElvUIModule:FloatingChatFrame_OnEvent(...) end
            end
        else
            CON:Info(LogCategory, "Using default chat handler")
            self._ChatFrameHandler = ChatFrame_MessageEventHandler
        end

		self:IsInitialized(true)
	end
	return self:IsInitialized()
end

function ChatFrame:IsInitialized(inBoolean)
	assert(inBoolean == nil or type(inBoolean) == 'boolean', "argument must be nil or boolean")
	if(inBoolean ~= nil) then
		self._Initialized = inBoolean
	end
	return self._Initialized
end

function ChatFrame:Print()
	CON:SingleLine(LogCategory)
	CON:Debug(LogCategory, ObjectName .. " Object")
	CON:Debug(LogCategory, "  _Key (" .. type(self._Key) .. "): ".. tostring(self._Key))
	CON:Debug(LogCategory, "  _ElvUI (" .. type(self._ElvUI) .. "): ".. tostring(self._ElvUI))
end

function ChatFrame:GetKey()
    return self._Key
end

function ChatFrame:SetKey(inKey)
    assert(type(inKey) == 'string')
    self._Key = inKey
    return self:GetKey()
end

function ChatFrame:IsElvUI(inBoolean)
    assert(inBoolean == nil or type(inBoolean) == 'boolean', "Usage: IsElvUI([boolean])")
    if(inBoolean ~= nil) then
        self._ElvUI = inBoolean
    end
    return self._ElvUI
end

function ChatFrame:DisplayChat(inEvent, inText, inSenderName, inFaction, inFlags, inLineID, inSenderGUID)
    local _FrameTable
    -- There are multiple chat windows, each registers for certain types of messages to display
    -- Thus GUILD can be on multiple chat windows and we need to display on all
    for i = 1, NUM_CHAT_WINDOWS do
        _FrameTable = { GetChatWindowMessages(i) }
        local v
        for _, _Name in ipairs(_FrameTable) do
            if _Name == 'GUILD' then
                local _Frame = 'ChatFrame' .. i
                if _G[_Frame] then
                    local _SenderName = ''
                    local _SenderGUID = ''
                    if(inEvent == 'GUILD') then
                        _SenderName = format('%s %s', format(IconTokenString, inFaction:GetIconID()), inSenderName)
                        _SenderGUID = inSenderGUID
                    elseif(inEvent == 'ONLINE') then
                        local _SenderName = format('%s %s', format(IconTokenString, inFaction:GetIconID()), inSenderName)
                        inText = _SenderName .. " has come online."
                        inText = format("|cffFFFF00%s|r", inText)
                    elseif(inEvent == 'OFFLINE') then
                        local _SenderName = format('%s %s', format(IconTokenString, inFaction:GetIconID()), inSenderName)
                        inText = _SenderName .. " has gone offline."
                        inText = format("|cffFFFF00%s|r", inText)
                    end
                    self._ChatFrameHandler(_G[_Frame], 'CHAT_MSG_GUILD', inText, _SenderName, 'Common', '', '', inFlags, 0, 0, '', 0, inLineID, _SenderGUID)
                end
                break
            end
        end
    end
end