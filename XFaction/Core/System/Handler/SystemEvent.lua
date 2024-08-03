local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'SystemEvent'

SystemEvent = XFC.Object:newChildConstructor()

--#region Constructors
function SystemEvent:new()
    local object = SystemEvent.parent.new(self)
    object.__name = ObjectName
    return object
end
--#endregion

--#region Initializers
function SystemEvent:Initialize()
	if(not self:IsInitialized()) then
        self:ParentInitialize()     
        -- Log any messages encountered during last logout
        for _, message in ipairs(XF.Config.Logout) do
            XF:Debug(ObjectName, '* Previous Logout: %s', message)
        end
        XF.Config.Logout = {}
        XFO.Hooks:Add({name = 'ReloadUI', 
                       original = 'ReloadUI', 
                       callback = XF.Handlers.SystemEvent.CallbackReloadUI,
                       pre = true})
        XFO.Events:Add({name = 'Logout',
                        event = 'PLAYER_LOGOUT',
                        callback = XF.Handlers.SystemEvent.CallbackLogout,
                        instance = true})
        -- Not sure this is necessary but don't feel like taking the risk of removing it
        XFO.Events:Add({name = 'LoadScreen', 
                        event = 'PLAYER_ENTERING_WORLD', 
                        callback = XF.Handlers.SystemEvent.CallbackLogin, 
                        instance = true})
		self:IsInitialized(true)
        XF.Config.Logout[#XF.Config.Logout + 1] = XF.Player.Unit:UnitName()
	end
end
--#endregion

--#region Callbacks
function SystemEvent:CallbackLogout()
    if(not XF.Cache.UIReload) then
        local message = nil
        try(function ()
            XF.Config.Logout[#XF.Config.Logout + 1] = 'Logout started'
            message = XF.Mailbox.Chat:Pop()
            message:Initialize()
            message:Type(XF.Enum.Network.BROADCAST)
            message:Subject(XF.Enum.Message.LOGOUT)
            if(XF.Player.Unit:IsAlt() and XF.Player.Unit:HasMainName()) then
                message:SetMainName(XF.Player.Unit:GetMainName())
            end
            message:SetGuild(XF.Player.Guild)
            message:UnitName(XF.Player.Unit:Name())
            message:Data(' ')
            XF.Config.Logout[#XF.Config.Logout + 1] = 'Logout sending message'
            XF.Mailbox.Chat:Send(message)
            XF.Config.Logout[#XF.Config.Logout + 1] = 'Logout message sent'
        end).
        catch(function (inErrorMessage)
            XF:Error(ObjectName, inErrorMessage)
            XF.Config.Logout[#XF.Config.Logout + 1] = 'Failed to send logout message: ' .. inErrorMessage
        end)
    end
end

function SystemEvent:CallbackReloadUI()
    try(function ()
        XFO.Confederate:Backup()
        XFO.Friends:Backup()
        XFO.Links:Backup()
        XFO.Orders:Backup()
    end).
    catch(function (err)
        XF:Error(ObjectName, err)
        XF.Config.Logout[#XF.Config.Errors + 1] = 'Failed to perform backups: ' .. err
    end).
    finally(function ()
        XF.Cache.UIReload = true
        _G.XFCacheDB = XF.Cache
    end)
end

function SystemEvent:CallbackLogin()
    if(XFO.Channels:HasLocalChannel()) then
        XFO.Channels:SetLast(XFO.Channels:LocalChannel():Key())
    end
end
--#endregion