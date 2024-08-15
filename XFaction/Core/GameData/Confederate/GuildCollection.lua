local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'GuildCollection'

XFC.GuildCollection = XFC.ObjectCollection:newChildConstructor()

--#region Constructors
function XFC.GuildCollection:new()
    local object = XFC.GuildCollection.parent.new(self)
	object.__name = ObjectName
	object.names = nil
	object.info = nil
    return object
end

function XFC.GuildCollection:Initialize(inGuildID)
	assert(type(inGuildID) == 'number')
	if(not self:IsInitialized()) then
		self:ParentInitialize()
		self.names = {}
		self.info = XFF.GuildInfo(inGuildID)
		self:Deserialize()
		XF:Info(self:ObjectName(), inGuildID)

		for _, guild in self:Iterator() do
			if(guild:ID() == inGuildID) then
				XF.Player.Guild = guild
				break
			end
		end

		self:IsInitialized(true)
	end
end
--#endregion

--#region Methods
function XFC.GuildCollection:ContainsName(inGuildName)
	return self.names[inGuildName] ~= nil
end

function XFC.GuildCollection:Add(inGuild)
    assert(type(inGuild) == 'table' and inGuild.__name == 'Guild')
	self.parent.Add(self, inGuild)
	self.names[inGuild:Name()] = inGuild
end

function XFC.GuildCollection:Get(inGuildName)
	assert(type(inGuildName) == 'string')
	if(self.names[inGuildName] ~= nil) then
		return self.names[inGuildName]
	end	
	return self.parent.Get(self, inGuildName)
end

function XFC.GuildCollection:Deserialize()
	-- Parse out configuration from guild information so GMs have control
	local xfData = ''
	local compressed = string.match(self.info.description, 'XF:(.-):XF')
	if (compressed ~= nil) then
		xfData = XF.Lib.Deflate:DecompressDeflate(XF.Lib.Deflate:DecodeForPrint(compressed))
	else
		xfData = self.info.description
	end

	if(not string.len(xfData)) then
		error('Failed to find setup in guild information')
	end

	for _, line in ipairs(string.Split(xfData, '\n')) do
		-- Confederate information
		if(string.find(line, 'XFn')) then                    
			local name, initials = line:match('XFn:(.-):(.+)')
			XF.Cache.Confederate.Name = name
			XF.Cache.Confederate.Key = initials
		-- Guild within the confederate
		-- elseif(string.find(line, 'XFg')) then
		-- 	local guild = XFC.Guild:new()
		-- 	guild:Deserialize(line)
		-- 	self:Add(guild)
		-- Local channel for same realm/faction communication
		elseif(string.find(line, 'XFc')) then
			XF.Cache.Channel.Name, XF.Cache.Channel.Password = line:match('XFc:(.-):(.*)')
		elseif(string.find(line, 'XFt')) then
			XFO.Teams:Deserialize(line)
		end
	end



	-- TESTING ONLY
	local guild = XFC.Guild:new()
	guild:Deserialize('XFg:US:2007621:Eternal Kingdom:EKA')
	self:Add(guild)

	local guild2 = XFC.Guild:new()
	guild2:Deserialize('XFg:US:2200861:Alternal Kingdom Two:AK2')
	self:Add(guild2)

	local guild3 = XFC.Guild:new()
	guild3:Deserialize('XFg:US:2074711:Alternal Kingdom:AK1')
	self:Add(guild3)

	local guild4 = XFC.Guild:new()
	guild4:Deserialize('XFg:US:2130491:Alternal Kingdom Three:AK3')
	self:Add(guild4)

	local guild5 = XFC.Guild:new()
	guild5:Deserialize('XFg:US:2086941:Endless Kingdom:ENK')
	self:Add(guild5)

	local guild6 = XFC.Guild:new()
	guild6:Deserialize('XFg:US:397138861:Alternal Kingdom Four:AK4')
	self:Add(guild6)
end
--#endregion