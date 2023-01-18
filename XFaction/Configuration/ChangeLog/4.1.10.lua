local XFG, G = unpack(select(2, ...))
local ObjectName = 'Config.ChangeLog'

XFG.ChangeLog['4.1.10'] = {
    Improvements = {
        order = 1,
        type = 'group',
        name = XFG.Lib.Locale['IMPROVEMENTS'],
        guiInline = true,
        args = {
            One = {
                order = 1,
                type = 'description',
                fontSize = 'medium',
                name = 'Bug fix for caching getting into a funky state.',
            },
            Two = {
                order = 2,
                type = 'description',
                fontSize = 'medium',
                name = 'Bug fix for team/name parsing in player notes.',
            },
        }
    },			
}