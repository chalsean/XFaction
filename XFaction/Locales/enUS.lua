local L = LibStub('AceLocale-3.0'):NewLocale('XFaction', 'enUS', true, false)

--=========================================================================
-- Generic One Word Translations
--=========================================================================
L['NAME'] = 'Name'
L['RACE'] = 'Race'
L['LEVEL'] = 'Level'
L['REALM'] = 'Realm'
L['GUILD'] = 'Guild'
L['TEAM'] = 'Team'
L['RANK'] = 'Rank'
L['ZONE'] = 'Zone'
L['NOTE'] = 'Note'
L['CLASS'] = 'Class'
L['COVENANT'] = 'Covenant'
L['CONFEDERATE'] = 'Confederate'
L['MOTD'] = 'MOTD'
L['FACTION'] = 'Faction'
L['PROFESSION'] = 'Profession'
L['SPEC'] = 'Spec'
L['ENABLE'] = 'Enable'
L['CHAT'] = 'Chat'
L['ACHIEVEMENT'] = 'Achievement'
L['DATATEXT'] = 'DataText'
L['SUPPORT'] = 'Support'
L['RESOURCES'] = 'Resources'
L['DISCORD'] = 'Discord'
L['GITHUB'] = 'GitHub'
L['DEV'] = 'Development'
L['DESCRIPTION'] = 'Description'
L['GENERAL'] = 'General'
L['DISCLAIMER'] = 'Disclaimer'
L['TRANSLATIONS'] = 'Translations'
L['FAQ'] = 'FAQ'
L['CHANNEL'] = 'Channel'
L['INDEX'] = 'Index'
L['DUNGEON'] = 'Mythic+'
L['ACHIEVEMENT_EARNED'] = 'has earned the achievement'
L['CHAT_LOGOUT'] = 'has gone offline.'
L['EXPLORE'] = 'Explore'
L['VERSION'] = 'Version'
L['MAIN'] = 'Main'
L['LABEL'] = 'Label'
L['LINKS'] = 'Links'
L['PM'] = 'Project Manager'
L['FACTION'] = 'Faction'
L['USAGE'] = 'Usage'
L['EVENT'] = 'Event'
L['FRIEND'] = 'Friend'
L['LINK'] = 'Link'
L['PLAYER'] = 'Player'
L['PROFESSION'] = 'Profession'
L['SOULBIND'] = 'Soulbind'
L['SPEC'] = 'Spec'
L['TARGET'] = 'Target'
L['TEAM'] = 'Team'
L['TIMER'] = 'Timer'
L['ITEMLEVEL'] = 'iLvl'
L['CENTER'] = 'Center'
L['LEFT'] = 'Left'
L['RIGHT'] = 'Right'
L['ALIGNMENT'] = 'Justification'
L['ORDER'] = 'Order'
L['RAID'] = 'Raid'
L['PVP'] = 'PvP'
L['NODE'] = 'Node'
L['ROSTER'] = 'Roster'
L['DEBUG'] = 'Debug'
L['CONTINENT'] = 'Continent'
L['ZONE'] = 'Zone'
--=========================================================================
-- General (tab) Specific
--=========================================================================
L['GENERAL_DESCRIPTION'] = 'Enable roster visibility and communication between guilds of a confederation, including guilds on other realms and of a different faction.'
L['GENERAL_DISCLAIMER'] = 'This addon is in beta stage and currently only Eternal Kingdom (EK) is being supported:'
L['GENERAL_WHAT'] = 'What is included'
L['GENERAL_GUILD_CHAT'] = '1. Merged guild chat across guilds/realms/factions in the confederate'
L['GENERAL_GUILD_CHAT_ACHIEVEMENT'] = '2. Personal achievements forwarded to confederate members in other guilds'
L['GENERAL_SYSTEM_MESSAGES'] = 'System Messages'
L['GENERAL_SYSTEM_LOGIN'] = '1. Receive notification when player using the addon comes online/offline in the confederate'
L['GENERAL_DATA_BROKERS'] = 'Data Brokers'
L['GENERAL_DTGUILD'] = '1. Guild (X): Full roster visibility in the confederate'
L['GENERAL_DTLINKS'] = '2. Links (X): Visibility of the active BNet links in the confederate used by the addon'
L['GENERAL_DTSOULBIND'] = '3. Soulbind (X): View and change your active soulbind'
L['GENERAL_DTTOKEN'] = '4. WoW Token (X): View current market price of WoW tokens'
--=========================================================================
-- Channel Specific
--=========================================================================
L['CHANNEL_LAST'] = 'Addon Channel Last'
L['CHANNEL_LAST_TOOLTIP'] = 'XFaction will ensure its channel is always last in the channel list'
L['CHANNEL_COLOR'] = 'Color Channels By Name'
L['CHANNEL_COLOR_TOOLTIP'] = 'Switches from Blizzard default of coloring by # to ID'
--=========================================================================
-- Chat Specific
--=========================================================================
L['CHAT_CCOLOR'] = 'Customize Color'
L['CHAT_CCOLOR_TOOLTIP'] = 'Customize XFaction chat colors.'
L['CHAT_GUILD'] = 'Guild Chat'
L['CHAT_GUILD_TOOLTIP'] = 'See cross realm/faction guild chat'
L['CHAT_FACTION'] = 'Show Faction'
L['CHAT_FACTION_TOOLTIP'] = 'Show the faction icon for the sender'
L['CHAT_FCOLOR'] = 'Factionize Color'
L['CHAT_FCOLOR_TOOLTIP'] = 'Render XFaction chat in faction colors.'
L['CHAT_GUILD_NAME'] = 'Show Guild Name'
L['CHAT_GUILD_NAME_TOOLTIP'] = 'Show the guild short name for the sender'
L['CHAT_MAIN'] = 'Show Main Name'
L['CHAT_MAIN_TOOLTIP'] = 'Show the senders main name if it is an alt'
L['CHAT_FONT_COLOR'] = 'Font Color'
L['CHAT_FONT_ACOLOR'] = 'Alliance Color'
L['CHAT_FONT_HCOLOR'] = 'Horde Color'
L['CHAT_OFFICER'] = 'Officer Chat'
L['CHAT_OFFICER_TOOLTIP'] = 'See cross realm/faction officer chat'
L['CHAT_ACHIEVEMENT_TOOLTIP'] = 'See cross realm/faction individual achievements'
L['CHAT_ONLINE'] = 'Online/Offline'
L['CHAT_ONLINE_TOOLTIP'] = 'Show message for players logging in/out on other realms/faction'
L['CHAT_ONLINE_SOUND'] = 'Play Sound'
L['CHAT_ONLINE_SOUND_TOOLTIP'] = 'Play sound when any confederate member comes online'
L['CHAT_LOGIN'] = 'has come online.'
L['CHAT_LOGOUT'] = 'has gone offline.'
L['CHAT_NO_PLAYER_FOUND'] = 'No player named '
--=========================================================================
-- Nameplates Specific
--=========================================================================
L['NAMEPLATES'] = 'Nameplates'
L['ELVUI'] = 'ElvUI'
L['NAMEPLATE_ELVUI_DESCRIPTION'] = 'Add more oUF tags that can be used in ElvUI UnitFrames'
L['NAMEPLATE_ELVUI_CONFEDERATE'] = 'Name of the confederate'
L['NAMEPLATE_ELVUI_CONFEDERATE_BRACKETS'] = 'Name of the confederate in <brackets>'
L['NAMEPLATE_ELVUI_MAIN_NAME'] = "Name of the player's main toon"
L['NAMEPLATE_ELVUI_MAIN_NAME_PARENTHESIS'] = "Name of the player's main toon in (parenthesis)"
L['NAMEPLATE_ELVUI_TEAM'] = "Name of the player's raid team"
L['NAMEPLATE_ELVUI_TEAM_PARENTHESIS'] = "Name of the player's raid team in (parenthesis)"
L['NAMEPLATE_ELVUI_CONFEDERATE_TEAM'] = "Combination of the confederate name and name of the player's raid team"
L['NAMEPLATE_ELVUI_CONFEDERATE_TEAM_BRACKETS'] = "Combination of the confederate name and name of the player's raid team in <brackets>"
--=========================================================================
-- DataText Specific
--=========================================================================
L['DT_HEADER_CONFEDERATE'] = 'Confederate: |cffffffff%s|r'
L['DT_HEADER_GUILD'] = 'Guild: |cffffffff%s|r'
L['DT_CONFIG_BROKER'] = 'Show Broker Fields'
L['DT_CONFIG_LABEL_TOOLTIP'] = 'Show broker label'
L['DT_CONFIG_FACTION_TOOLTIP'] = 'Show faction counts in broker label'
-------------------------
-- DTGuild (X)
-------------------------
-- Broker name
L['DTGUILD_NAME'] = 'Guild (X)'
-- Config
L['DTGUILD_BROKER_HEADER'] = 'Broker Settings'
L['DTGUILD_SELECT_COLUMN'] = 'Select Column'
L['DTGUILD_SELECT_COLUMN_TOOLTIP'] = 'Select column from list to make adjustments to'
L['DTGUILD_CONFIG_SORT'] = 'Default Sort Column'
L['DTGUILD_CONFIG_SIZE'] = 'Window Size'
L['DTGUILD_CONFIG_HEADER'] = 'Header Settings'
L['DTGUILD_CONFIG_CONFEDERATE_TOOLTIP'] = 'Show name of the confederate'
L['DTGUILD_CONFIG_CONFEDERATE_DISABLED'] = 'Must have at least five columns enabled'
L['DTGUILD_CONFIG_GUILD_TOOLTIP'] = 'Show name of the current guild'
L['DTGUILD_CONFIG_MOTD_TOOLTIP'] = 'Show guild message-of-the-day'
L['DTGUILD_CONFIG_COLUMN_HEADER'] = 'Column Settings'
L['DTGUILD_CONFIG_COLUMN_ENABLE_MAIN'] = 'Append Main To Name'
L['DTGUILD_CONFIG_COLUMN_ACHIEVEMENT_TOOLTIP'] = 'Show player total achievement points'
L['DTGUILD_CONFIG_COLUMN_ACHIEVEMENT_ORDER_TOOLTIP'] = 'Column number the achievement points will be displayed in'
L['DTGUILD_CONFIG_COLUMN_ACHIEVEMENT_ALIGNMENT_TOOLTIP'] = 'Achievement points text justification'
L['DTGUILD_CONFIG_COLUMN_COVENANT_TOOLTIP'] = 'Show player covenant icon'
L['DTGUILD_CONFIG_COLUMN_COVENANT_ORDER_TOOLTIP'] = 'Column number the covenant icon will be displayed in'
L['DTGUILD_CONFIG_COLUMN_COVENANT_ALIGNMENT_TOOLTIP'] = 'Covenant icon alignment within the column'
L['DTGUILD_CONFIG_COLUMN_DUNGEON_TOOLTIP'] = 'Show player mythic+ score'
L['DTGUILD_CONFIG_COLUMN_DUNGEON_ORDER_TOOLTIP'] = 'Column number the mythic+ rating will be displayed in'
L['DTGUILD_CONFIG_COLUMN_DUNGEON_ALIGNMENT_TOOLTIP'] = 'Mythic+ rating text justification'
L['DTGUILD_CONFIG_COLUMN_FACTION_TOOLTIP'] = 'Show player faction icon'
L['DTGUILD_CONFIG_COLUMN_FACTION_ORDER_TOOLTIP'] = 'Column number the faction icon will be displayed in'
L['DTGUILD_CONFIG_COLUMN_FACTION_ALIGNMENT_TOOLTIP'] = 'Faction icon alignment within the column'
L['DTGUILD_CONFIG_COLUMN_GUILD_TOOLTIP'] = 'Show player guild name'
L['DTGUILD_CONFIG_COLUMN_GUILD_ORDER_TOOLTIP'] = 'Column number the guild name will be displayed in'
L['DTGUILD_CONFIG_COLUMN_GUILD_ALIGNMENT_TOOLTIP'] = 'Guild name text justification'
L['DTGUILD_CONFIG_COLUMN_ITEMLEVEL_TOOLTIP'] = 'Show player max item level'
L['DTGUILD_CONFIG_COLUMN_ITEMLEVEL_ORDER_TOOLTIP'] = 'Column number the max item level will be displayed in'
L['DTGUILD_CONFIG_COLUMN_ITEMLEVEL_ALIGNMENT_TOOLTIP'] = 'Item level text justification'
L['DTGUILD_CONFIG_COLUMN_LEVEL_TOOLTIP'] = 'Show player level'
L['DTGUILD_CONFIG_COLUMN_LEVEL_ORDER_TOOLTIP'] = 'Column number the players level will be displayed in'
L['DTGUILD_CONFIG_COLUMN_LEVEL_ALIGNMENT_TOOLTIP'] = 'Player level text justification'
L['DTGUILD_CONFIG_COLUMN_MAIN_TOOLTIP'] = 'Show player main name if on alt'
L['DTGUILD_CONFIG_COLUMN_NAME_ORDER_TOOLTIP'] = 'Column number the player name will be displayed in'
L['DTGUILD_CONFIG_COLUMN_NAME_ALIGNMENT_TOOLTIP'] = 'Player name text justification'
L['DTGUILD_CONFIG_COLUMN_NOTE_TOOLTIP'] = 'Show player note'
L['DTGUILD_CONFIG_COLUMN_NOTE_ORDER_TOOLTIP'] = 'Column number the player note will be displayed in'
L['DTGUILD_CONFIG_COLUMN_NOTE_ALIGNMENT_TOOLTIP'] = 'Player note text justification'
L['DTGUILD_CONFIG_COLUMN_PROFESSION_TOOLTIP'] = 'Show player profession icons'
L['DTGUILD_CONFIG_COLUMN_PROFESSION_ORDER_TOOLTIP'] = 'Column number the profession icons will be displayed in'
L['DTGUILD_CONFIG_COLUMN_PROFESSION_ALIGNMENT_TOOLTIP'] = 'Profession icons alignment within the column'
L['DTGUILD_CONFIG_COLUMN_PVP_TOOLTIP'] = 'Show player highest PvP score'
L['DTGUILD_CONFIG_COLUMN_PVP_ORDER_TOOLTIP'] = 'Column number the PvP score will be displayed in'
L['DTGUILD_CONFIG_COLUMN_PVP_ALIGNMENT_TOOLTIP'] = 'PvP score text justification'
L['DTGUILD_CONFIG_COLUMN_RACE_TOOLTIP'] = 'Show player race'
L['DTGUILD_CONFIG_COLUMN_RACE_ORDER_TOOLTIP'] = 'Column number the player race will be displayed in'
L['DTGUILD_CONFIG_COLUMN_RACE_ALIGNMENT_TOOLTIP'] = 'Player race text justification'
L['DTGUILD_CONFIG_COLUMN_RAID_TOOLTIP'] = 'Show player highest raid progress'
L['DTGUILD_CONFIG_COLUMN_RAID_ORDER_TOOLTIP'] = 'Column number the player raid progress will be displayed in'
L['DTGUILD_CONFIG_COLUMN_RAID_ALIGNMENT_TOOLTIP'] = 'Player raid progress text justification'
L['DTGUILD_CONFIG_COLUMN_RANK_TOOLTIP'] = 'Show player rank'
L['DTGUILD_CONFIG_COLUMN_RANK_ORDER_TOOLTIP'] = 'Column number the player rank will be displayed in'
L['DTGUILD_CONFIG_COLUMN_RANK_ALIGNMENT_TOOLTIP'] = 'Player rank text justification'
L['DTGUILD_CONFIG_COLUMN_REALM_TOOLTIP'] = 'Show player realm name'
L['DTGUILD_CONFIG_COLUMN_REALM_ORDER_TOOLTIP'] = 'Column number the player realm name will be displayed in'
L['DTGUILD_CONFIG_COLUMN_REALM_ALIGNMENT_TOOLTIP'] = 'Player realm name text justification'
L['DTGUILD_CONFIG_COLUMN_SPEC_TOOLTIP'] = 'Show player spec icon'
L['DTGUILD_CONFIG_COLUMN_SPEC_ORDER_TOOLTIP'] = 'Column number the spec icon will be displayed in'
L['DTGUILD_CONFIG_COLUMN_SPEC_ALIGNMENT_TOOLTIP'] = 'Spec icon alignment within the column'
L['DTGUILD_CONFIG_COLUMN_TEAM_TOOLTIP'] = 'Show player team name'
L['DTGUILD_CONFIG_COLUMN_TEAM_ORDER_TOOLTIP'] = 'Column number the player team name will be displayed in'
L['DTGUILD_CONFIG_COLUMN_TEAM_ALIGNMENT_TOOLTIP'] = 'Player team name text justification'
L['DTGUILD_CONFIG_COLUMN_VERSION_TOOLTIP'] = 'Show player XFaction version'
L['DTGUILD_CONFIG_COLUMN_VERSION_ORDER_TOOLTIP'] = 'Column number the player XFaction version will be displayed in'
L['DTGUILD_CONFIG_COLUMN_VERSION_ALIGNMENT_TOOLTIP'] = 'Player XFaction version text justification'
L['DTGUILD_CONFIG_COLUMN_ZONE_TOOLTIP'] = 'Show player current zone'
L['DTGUILD_CONFIG_COLUMN_ZONE_ORDER_TOOLTIP'] = 'Column number the player zone will be displayed in'
L['DTGUILD_CONFIG_COLUMN_ZONE_ALIGNMENT_TOOLTIP'] = 'Player zone text justification'
L['DTGUILD_CONFIG_SORT_TOOLTIP'] = 'Select the default sort column'
L['DTGUILD_CONFIG_SIZE_TOOLTIP'] = 'Select the maximum height of the window before it starts scrolling'
--=========================================================================
-- Confederate Specific
--=========================================================================
L['CONFEDERATE_CONFIG_BUILDER'] = 'Config Builder'
L['CONFEDERATE_GENERATE'] = 'Generate'
L['CONFEDERATE_LOAD'] = 'Load'
-------------------------
-- DTLinks (X)
-------------------------
-- Broker name
L['DTLINKS_NAME'] = 'Links (X)'
-- Header
L['DTLINKS_HEADER_LINKS'] = 'Active BNet Links: |cffffffff%d|r'
-------------------------
-- DTSoulbind (X)
-------------------------
-- Broker name
L['DTSOULBIND_NAME'] = 'Soulbind (X)'
-- Broker text
L['DTSOULBIND_NO_COVENANT'] = 'No Covenant'
L['DTSOULBIND_NO_SOULBIND'] = '%s No Soulbind'
-- Header
L['DTSOULBIND_ACTIVE'] = '|cffFFFFFF%s: |cff00FF00Active|r'
L['DTSOULBIND_INACTIVE'] = '|cffFFFFFF%s: |cffFF0000Inactive|r'
-- Config
L['DTSOULBIND_CONFIG_CONDUIT'] = 'Show Conduits'
L['DTSOULBIND_CONFIG_CONDUIT_TOOLTIP'] = 'Show active conduit icons'
-- Footer
L['DTSOULBIND_LEFT_CLICK'] = '|cffFFFFFFLeft Click:|r Open Soulbind Frame'
L['DTSOULBIND_RIGHT_CLICK'] = '|cffFFFFFFRight Click:|r Change Soulbind'
-------------------------
-- DTToken (X)
-------------------------
-- Broker name
L['DTTOKEN_NAME'] = 'WoW Token (X)'
-------------------------
-- DTMetrics
-------------------------
L['DTMETRICS_NAME'] = 'Metrics (X)'
L['DTMETRICS_HEADER'] = 'Metrics Since: |cffffffff%02d:%02d|r (Server)'
L['DTMETRICS_RATE'] = 'Average Rate'
L['DTMETRICS_RATE_TOOLTIP'] = '1 is average per second, 60 is average per minute, etc.'
L['DTMETRICS_HEADER_METRIC'] = 'Metric'
L['DTMETRICS_HEADER_TOTAL'] = 'Total'
L['DTMETRICS_HEADER_AVERAGE'] = 'Average'
L['DTMETRICS_MESSAGES'] = 'Total Received'
L['DTMETRICS_BNET_FORWARD'] = 'BNet Forward'
L['DTMETRICS_BNET_SEND'] = 'BNet Send'
L['DTMETRICS_BNET_RECEIVE'] = 'BNet Receive'
L['DTMETRICS_CHANNEL_RECEIVE'] = 'Local Receive'
L['DTMETRICS_CHANNEL_SEND'] = 'Local Send'
L['DTMETRICS_CHANNEL_FORWARD'] = 'Local Forward'
L['DTMETRICS_ERROR'] = 'Error'
L['DTMETRICS_WARNING'] = 'Warning'
L['DTMETRICS_CONFIG_TOTAL'] = 'Total Messages'
L['DTMETRICS_CONFIG_TOTAL_TOOLTIP'] = 'Display the total # of messages received'
L['DTMETRICS_CONFIG_AVERAGE'] = 'Average Messages'
L['DTMETRICS_CONFIG_AVERAGE_TOOLTIP'] = 'Display the average # of messages received'
L['DTMETRICS_CONFIG_ERROR'] = 'Total Errors'
L['DTMETRICS_CONFIG_ERROR_TOOLTIP'] = 'Display the total # of errors encountered'
L['DTMETRICS_CONFIG_WARNING'] = 'Total Warnings'
L['DTMETRICS_CONFIG_WARNING_TOOLTIP'] = 'Display the total # of warnings encountered'
--=========================================================================
-- Support Specific
--=========================================================================
L['SUPPORT_UAT'] = 'User Acceptance Testing'
L['DEBUG_PRINT'] = 'Click any button to ad-hoc print that datacollection to _DebugLog'
L['DEBUG_ROSTER_TOOLTIP'] = 'Whether all confederate members send roster information'
L['NEW_VERSION'] = '%s: A newer version is available, please consider updating'