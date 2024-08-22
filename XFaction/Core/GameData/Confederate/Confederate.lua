local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'Confederate'

XFC.Confederate = XFC.Factory:newChildConstructor()

--#region Constructors
function XFC.Confederate:new()
    local object = XFC.Confederate.parent.new(self)
	object.__name = ObjectName
    object.onlineCount = 0
    return object
end

function XFC.Confederate:NewObject()
    return XFC.Unit:new()
end

function XFC.Confederate:Initialize()
	if(not self:IsInitialized()) then
        self:ParentInitialize()
        self:Name(XF.Cache.Confederate.Name)
        self:Key(XF.Cache.Confederate.Key)

        XFO.Events:Add({
            name = 'Roster', 
            event = 'GUILD_ROSTER_UPDATE', 
            callback = XFO.Confederate.CallbackLocalGuild, 
            instance = true,
            groupDelta = XF.Settings.LocalGuild.ScanTimer
        })
        
        -- This here because there isnt a good place for it
        -- Will move somewhere else in the future
        XFO.Events:Add({
            name = 'Level', 
            event = 'PLAYER_LEVEL_CHANGED', 
            callback = XFO.Confederate.CallbackPlayerChanged
        })
        -- XFO.Events:Add({
        --     name = 'Guild',
        --     event = 'PLAYER_GUILD_UPDATE',
        --     callback = XFO.Confederate.CallbackGuildChanged
        -- })

        XFO.Timers:Add({
            name = 'Heartbeat', 
            delta = XF.Settings.Player.Heartbeat, 
            callback = XFO.Confederate.CallbackHeartbeat, 
            repeater = true, 
            instance = true
        })

        XFO.Timers:Add({
            name = 'Disconnected', 
            delta = XF.Settings.Player.Heartbeat, 
            callback = XFO.Confederate.CallbackDisconnected, 
            repeater = true, 
            instance = true
        })

        XF:Info(self:ObjectName(), 'Initialized confederate %s <%s>', self:Name(), self:Key())
        self:IsInitialized(true)
	end
	return self:IsInitialized()
end
--#endregion

--#region Properties
function XFC.Confederate:OnlineCount(inCount)
    assert(type(inCount) == 'number' or inCount == nil)
    if(inCount ~= nil) then
        self.onlineCount = self.onlineCount + inCount
        XFO.DTGuild:RefreshBroker()
    end
    return self.onlineCount
end
--#endregion

--#region Methods
function XFC.Confederate:Add(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name == 'Unit')

    if(self:Contains(inUnit:Key())) then
        local oldData = self:Get(inUnit:Key())
        self.parent.Add(self, inUnit)
        if(oldData:IsOffline() and inUnit:IsOnline()) then
            self:OnlineCount(1)
        elseif(oldData:IsOnline() and inUnit:IsOffline()) then
            self:OnlineCount(-1)
        end
        self:Push(oldData)
    else
        self.parent.Add(self, inUnit)
        if(inUnit:IsOnline()) then
            self:OnlineCount(1)
        end
    end
    
    if(inUnit:IsPlayer()) then
        XF.Player.Unit = inUnit
    end
end

function XFC.Confederate:Remove(inKey)
    assert(type(inKey) == 'string')
    if(self:Contains(inKey)) then
        local unit = self:Get(inKey)
        self.parent.Remove(self, inKey)
        if(unit:IsOnline()) then
            self:OnlineCount(-1)
        end
        unit:Target():Remove(inKey)
        self:Push(unit)
    end
end

function XFC.Confederate:GetInitials()
    return self:Key()
end

function XFC.Confederate:Backup()
    try(function ()
        if(self:IsInitialized()) then
            for unitKey, unit in self:Iterator() do
                if(unit:IsRunningAddon() and not unit:IsPlayer()) then
                    XF.Cache.Backup.Confederate[unitKey] = {}
                    XF.Cache.Backup.Confederate[unitKey] = unit:Serialize()
                end
            end
        end
    end).
    catch(function (err)
        XF.Cache.Errors[#XF.Cache.Errors + 1] = 'Failed to create confederate backup before reload: ' .. err
    end)
end

function XFC.Confederate:Restore()
    if(XF.Cache.Backup.Confederate == nil) then XF.Cache.Backup.Confederate = {} end
    for _, data in pairs (XF.Cache.Backup.Confederate) do
        local unit = nil
        try(function ()
            unit = self:Pop()
            unit:Deserialize(data)
            self:Add(unit)
            XF:Info(self:ObjectName(), '  Restored %s unit information from backup', unit:UnitName())
        end).
        catch(function (err)
            XF:Warn(self:ObjectName(), err)
            self:Push(unit)
        end)
    end
    XF.Cache.Backup.Confederate = {}
end

function XFC.Confederate:Login(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name == 'Unit')
    if(not self:Contains(inUnit:Key()) or self:Get(inUnit:Key()):IsOffline()) then
        XF:Info(self:ObjectName(), 'Guild member login: %s', inUnit:UnitName())
        XFO.SystemFrame:DisplayLogin(inUnit)
    end
    self:Add(inUnit)
end

function XFC.Confederate:Logout(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name == 'Unit' or type(inUnit) == 'string')

    if(type(inUnit) == 'string') then
        if(not self:Contains(inUnit)) then
            return
        end
        inUnit = self:Get(inUnit)
    end
    
    XF:Info(self:ObjectName(), 'Guild member logout: %s', inUnit:UnitName())
    XFO.SystemFrame:DisplayLogout(inUnit:UnitName())

    self:OfflineUnit(inUnit)
end

function XFC.Confederate:OfflineUnit(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name == 'Unit')
    inUnit:Target():Remove(inUnit:Key())

    if(inUnit:IsSameGuild()) then
        self:Add(inUnit)
    else
        self:Remove(inUnit:Key())
        self:Push(inUnit)
    end

    XFO.DTLinks:RefreshBroker()
end

-- The event doesn't tell you what has changed, only that something has changed. So you have to scan the whole roster
function XFC.Confederate:CallbackLocalGuild()
    local self = XFO.Confederate
    XF:Trace(self:ObjectName(), 'Scanning local guild roster')
    for _, memberID in pairs (XFF.GuildMembers(XF.Player.Guild:ID())) do
        local unit = self:Pop()
        try(function ()
            unit:Initialize(memberID)
            if(unit:IsInitialized()) then
                if(self:Contains(unit:Key())) then
                    local oldData = self:Get(unit:Key())
                    if(oldData:IsOnline() and unit:IsOffline()) then
                        XF:Debug(self:ObjectName(), 'Detected guild logout: %s', oldData:UnitName())
                        self:Logout(unit)
                    elseif(unit:IsOnline()) then
                        if(oldData:IsOffline()) then
                            self:Login(unit)
                        elseif(not oldData:IsRunningAddon()) then
                            self:Add(unit)
                        else
                            -- Every logic branch should either add, remove or push, otherwise there will be a memory leak
                            self:Push(unit)
                        end
                    else
                        self:Push(unit)
                    end
                -- First time scan (i.e. login) do not notify
                else
                    self:Add(unit)
                end
            -- If it didnt initialize properly then we dont really know their status, so do nothing
            else
                self:Push(unit)
            end
        end).
        catch(function (err)
            XF:Warn(self:ObjectName(), err)
        end)
    end
end

function XFC.Confederate:ProcessMessage(inMessage)
    assert(type(inMessage) == 'table' and inMessage.__name == 'Message')

    if(inMessage:IsLogoutMessage()) then
        if(not inMessage:FromUnit():IsSameGuild()) then
            XF:Debug(self:ObjectName(), 'Detected message logout: %s', inMessage:FromUnit():UnitName())
            self:Logout(inMessage:FromUnit())
        end
        return
    end

    if(inMessage:IsLoginMessage()) then
        self:Login(inMessage:FromUnit())        
    else
        self:Add(inMessage:FromUnit())
    end
end

function XFC.Confederate:CallbackPlayerChanged(inEvent) 
    local self = XFO.Confederate
    try(function ()
        XF.Player.Unit:Initialize(XF.Player.Unit:ID())
        XFO.Mailbox:SendDataMessage()
    end).
    catch(function (err)
        XF:Warn(self:ObjectName(), err)
    end)
end

-- function XFC.Confederate:CallbackGuildChanged(inEvent, inUnitID) 
--     local self = XFO.Confederate
--     XF:Debug(self:ObjectName(), 'Guild update event fired [%s]', inUnitID)
--     try(function ()
--         -- Player just joined a guild
--         if(XFF.PlayerIsInGuild()) then
--             XF:Debug(self:ObjectName(), 'Player is in a guild')
--             if(XFO.Timers:Contains('LoginGuild')) then
--                 XFO.Timers:Get('LoginGuild'):Start()
--             else
--                 XFO.Timers:Add({
--                     name = 'LoginGuild', 
--                     delta = 1, 
--                     callback = XF.CallbackLoginGuild, 
--                     repeater = true, 
--                     instance = true,
--                     ttl = XF.Settings.LocalGuild.LoginTTL,
--                     start = true
--                 })
--             end
--         -- Player just left a guild
--         elseif(not XFF.PlayerIsInGuild()) then
--             XF:Debug(self:ObjectName(), 'Player is not in a guild')
--             XF:Stop()
--         end
--     end).
--     catch(function (err)
--         XF:Warn(self:ObjectName(), err)
--     end)
-- end

function XFC.Confederate:CallbackHeartbeat() 
    local self = XFO.Confederate
    try(function ()
        XFO.Mailbox:SendDataMessage()
    end).
    catch(function (err)
        XF:Warn(self:ObjectName(), err)
    end)
end

function XFC.Confederate:CallbackDisconnected()
    local self = XFO.Confederate
    try(function()
        local window = XFF.TimeCurrent() - XF.Settings.Confederate.UnitStale
        for _, unit in self:Iterator() do
            if(not unit:IsPlayer() and unit:IsOnline() and unit:TimeStamp() < window) then
                self:OfflineUnit(unit)
            end
        end
    end).
    catch(function(err)
        XF:Warn(self:ObjectName(), err)
    end)
end
--#endregion