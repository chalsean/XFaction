local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'Confederate'

XFC.Confederate = XFC.Factory:newChildConstructor()

--#region Constructors
function XFC.Confederate:new()
    local object = XFC.Confederate.parent.new(self)
	object.__name = ObjectName
    object.onlineCount = 0
	object.guildInfo = nil
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

        XF:Info(self:ObjectName(), 'Initialized confederate %s <%s>', self:Name(), self:Key())

        -- This is the local guild roster scan for those not running the addon
        XFO.Events:Add({
            name = 'Roster', 
            event = 'GUILD_ROSTER_UPDATE', 
            callback = XFO.Confederate.LocalRoster, 
            instance = true,
            groupDelta = XF.Settings.LocalGuild.ScanTimer
        })
        
        XFO.Timers:Add({
            name = 'Offline',
            delta = XF.Settings.Confederate.UnitScan, 
            callback = XFO.Confederate.CallbackOffline, 
            repeater = true, 
            instance = true
        })    
        
        -- On initial login, the roster returned is incomplete, you have to force Blizz to do a guild roster refresh
        XFF.GuildQueryServer()

        self:IsInitialized(true)
	end
	return self:IsInitialized()
end
--#endregion

--#region Properties
function XFC.Confederate:Initials()
    return self:Key()
end

function XFC.Confederate:OnlineCount()
    return self.onlineCount
end
--#endregion

--#region Methods
function XFC.Confederate:Add(inUnit)
    assert(type(inUnit) == 'table' and inUnit.__name == 'Unit')
    
    if(self:Contains(inUnit:Key())) then
        local oldData = self:Get(inUnit:Key())        
        if(oldData:IsOffline() and inUnit:IsOnline()) then
            self.onlineCount = self.onlineCount + 1
        end
        self.parent.Add(self, inUnit)
        self:Push(oldData)
    else
        self.parent.Add(self, inUnit)
        if(inUnit:IsOnline()) then
            self.onlineCount = self.onlineCount + 1
        end
    end
    
    if(inUnit:IsPlayer()) then
        XF.Player.Unit = inUnit
    end

    XFO.DTGuild:RefreshBroker()
end

function XFC.Confederate:Get(inKey, inRealmID, inFactionID)
    assert(type(inKey) == 'string')
    assert(type(inRealmID) == 'number' or inRealmID == nil)
    assert(type(inFactionID) == 'number' or inFactionID == nil)

    if(inRealmID == nil) then
        return self.parent.Get(self, inKey)
    end

    local realm = XFO.Realms:Get(inRealmID)
    local faction = XFO.Factions:Get(inFactionID)

    for _, unit in self:Iterator() do
        if(XF:ObjectsEquals(realm, unit:Guild():Realm()) and XF:ObjectsEquals(faction, unit:Race():Faction()) and unit:Name() == inKey) then
            return unit
        end
    end
end

function XFC.Confederate:Backup()
    try(function ()
        if(self:IsInitialized()) then
            for unitKey, unit in self:Iterator() do
                if(unit:IsOnline() and unit:IsRunningAddon() and not unit:IsPlayer()) then
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
        local unit = self:Pop()
        unit:Deserialize(data)
        unit:IsRunningAddon(true)
        self:Add(unit)
        XF:Info(self:ObjectName(), '  Restored %s unit information from backup', unit:UnitName())
    end
    XF.Cache.Backup.Confederate = {}
end

function XFC.Confederate:CallbackOffline()
    local self = XFO.Confederate
    try(function()
        local ttl = XFF.TimeGetCurrent() - XF.Settings.Confederate.UnitStale
        for _, unit in self:Iterator() do
            if(not unit:IsPlayer() and unit:IsOnline() and unit:TimeStamp() < ttl) then
                XF:Info(self:ObjectName(), 'Removing ghost guild member: ' .. unit:UnitName())
                self:UnitOffline(unit:Key())
            end
        end
    end).
    catch(function(err)
        XF:Warn(self:ObjectName(), err)
    end).
    finally(function()
        XFO.Timers:Get('Offline'):LastRan(XFF.TimeGetCurrent())
    end)
end

function XFC.Confederate:UnitOffline(inKey)
    assert(type(inKey) == 'string')
    try(function()
        if(self:Contains(inKey)) then

            local unit = self:Get(inKey)
            XFO.Links:RemoveAll(unit)

            if(unit:IsSameGuild()) then
                unit:Presence(Enum.ClubMemberPresence.Offline)
                self.onlineCount = self.onlineCount - 1
            else
                self:Remove(inKey)
                self:Push(unit)
            end

            XFO.DTGuild:RefreshBroker()
        end
    end).
    catch(function(err)
        XF:Warn(self:ObjectName(), err)
    end)
end

-- The event doesn't tell you what has changed, only that something has changed. So you have to scan the whole roster
function XFC.Confederate:LocalRoster()
    local self = XFO.Confederate -- Callback
    XF:Trace(self:ObjectName(), 'Scanning local guild roster')
    for _, memberID in pairs (XFF.GuildGetMembers(XF.Player.Guild:ID(), XF.Player.Guild:StreamID())) do
        local unit = nil
        try(function ()
            -- Every logic branch should either add, remove or push, otherwise there will be a memory leak
            unit = self:Pop()
            unit:Initialize(memberID)
            if(unit:IsInitialized()) then
                if(self:Contains(unit:Key())) then
                    local old = self:Get(unit:Key())
                    old:TimeStamp(XFF.TimeGetCurrent())
                    if(old:IsOnline() and unit:IsOffline()) then
                        XF:Info(self:ObjectName(), 'Guild member logout via scan: %s', unit:UnitName())
                        XFO.SystemFrame:DisplayLogout(unit:Name())
                        self:UnitOffline(old:Key())
                        self:Push(unit)
                    elseif(unit:IsOnline()) then
                        if(old:IsOffline()) then
                            XF:Info(self:ObjectName(), 'Guild member login via scan: %s', unit:UnitName())
                            XFO.SystemFrame:DisplayLogin(unit)
                            self:Add(unit)
                        elseif(not old:IsRunningAddon()) then
                            self:Add(unit)
                        else
                            -- Other player is online and running addon, they will have more info than we get from a scan like spec                            
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
            self:Push(unit)
        end)
    end
end

function XFC.Confederate:LegacyProcessMessage(inMessage)
    if(inMessage:IsLogout()) then
        if(not XF.Player.Guild:Equals(inMessage:Guild())) then                
            if(self:Contains(inMessage:From())) then
                local unit = self:Get(inMessage:From())
                XF:Info(self:ObjectName(), 'Guild member logout via message: %s', unit:UnitName())
                XFO.SystemFrame:DisplayLogout(unit:Name())
                self:UnitOffline(inMessage:From())                
            end
        end
    else
        local unitData = inMessage:Data()
        if(inMessage:IsLogin() and (not self:Contains(unitData:Key()) or self:Get(unitData:Key()):IsOffline())) then
            XFO.SystemFrame:DisplayLogin(unitData)
            XF:Info(self:ObjectName(), 'Guild member login via message: %s', unitData:UnitName())
        else
            XF:Info(self:ObjectName(), 'Updated unit [%s] information based on message received', unitData:UnitName())
        end
        XFO.Confederate:Add(unitData)
    end
end

function XFC.Confederate:ProcessMessage(inMessage)
    assert(type(inMessage) == 'table' and inMessage.__name == 'Message')
    if(inMessage:IsLegacy()) then
        self:LegacyProcessMessage(inMessage)
        return
    end

    if(inMessage:IsLogout()) then
        -- Guild scan will handle local guild logout notifications
        if(not inMessage:FromUnit():IsSameGuild()) then
            XFO.SystemFrame:DisplayLogout(inMessage:FromUnit():Name())
            XF:Info(self:ObjectName(), 'Guild member logout via message: %s', inMessage:FromUnit():UnitName())
            self:UnitOffline(inMessage:FromUnit():GUID())
        end
    else
        if(inMessage:IsLogin() and (not self:Contains(inMessage:FromUnit():Key()) or self:Get(inMessage:FromUnit():Key()):IsOffline())) then
            XFO.SystemFrame:DisplayLogin(inMessage:FromUnit())
            XF:Info(self:ObjectName(), 'Guild member login via message: %s', inMessage:FromUnit():UnitName())
        else
            XF:Info(self:ObjectName(), 'Updated unit [%s] information based on message received', inMessage:FromUnit():UnitName())
        end
        XFO.Confederate:Add(inMessage:FromUnit())
    end
end

-- Doesnt really belong here but cant find a good home
function XFC.Confederate:CallbackHeartbeat()
    local self = XFO.Confederate
	try(function ()
		if(XF.Initialized and XF.Player.LastBroadcast < XFF.TimeGetCurrent() - XF.Settings.Player.Heartbeat) then
			XF:Debug(self:ObjectName(), 'Sending heartbeat')
			XFO.Mailbox:SendDataMessage(XF.Player.Unit)
		end
	end).
	catch(function (err)
		XF:Warn(self:ObjectName(), err)
	end).
	finally(function ()
		XFO.Timers:Get('Heartbeat'):LastRan(XFF.TimeGetCurrent())
	end)
end
--#endregion