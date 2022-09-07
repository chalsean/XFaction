local XFG, G = unpack(select(2, ...))
local ObjectName = 'Initialize'

function XFG:Init()
	-- Monitor other addons loading
	XFG.RaidIO = RaidIOCollection:new(); XFG.RaidIO:Initialize()
	XFG.Events = EventCollection:new(); XFG.Events:Initialize()
	XFG.Handlers.AddonEvent = AddonEvent:new(); XFG.Handlers.AddonEvent:Initialize() 

	-- Log XFaction version
	XFG.Versions = VersionCollection:new(); XFG.Versions:Initialize()
	XFG.Version = XFG.Versions:GetCurrent()
	XFG:Info(ObjectName, 'XFaction version [%s]', XFG.Version:GetKey())

	-- Initialize anything not dependent upon guild information
	XFG.Confederate = Confederate:new()

	XFG.Hooks = HookCollection:new(); XFG.Hooks:Initialize()
	XFG.Timers = TimerCollection:new(); XFG.Timers:Initialize()
	XFG.Frames.Chat = ChatFrame:new(); XFG.Frames.Chat:Initialize()
	XFG.Frames.System = SystemFrame:new(); XFG.Frames.System:Initialize()
	XFG.Metrics = MetricCollection:new(); XFG.Metrics:Initialize()
	XFG.Media = MediaCollection:new(); XFG.Media:Initialize()

	XFG.Factions = FactionCollection:new(); XFG.Factions:Initialize()
	XFG.Realms = RealmCollection:new(); XFG.Realms:Initialize()
	XFG.Continents = ContinentCollection:new(); XFG.Continents:Initialize()
	XFG.Zones = ZoneCollection:new(); XFG.Zones:Initialize()

	XFG.Player.GUID = UnitGUID('player')
	XFG.Player.Faction = XFG.Factions:GetByName(UnitFactionGroup('player'))
	XFG.Player.InInstance = IsInInstance()

	-- A significant portion of start up is delayed due to guild information not being available yet
	XFG.Handlers.TimerEvent = TimerEvent:new(); XFG.Handlers.TimerEvent:Initialize()

	-- These will execute "in-parallel" with remainder of setup as they are not time critical nor is anything dependent upon them
	XFG.DataText.Token = DTToken:new(); XFG.DataText.Token:Initialize()
	XFG.Expansions = ExpansionCollection:new(); XFG.Expansions:Initialize()
	XFG.WoW = XFG.Expansions:GetCurrent()
	XFG:Info(ObjectName, 'WoW client version [%s:%s]', XFG.WoW:GetName(), XFG.WoW:GetVersion():GetKey())
end

do
	XFG.Init()
end