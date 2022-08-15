local XFG, G = unpack(select(2, ...))

FriendCollection = ObjectCollection:newChildConstructor()

function FriendCollection:new()
	local _Object = FriendCollection.parent.new(self)
	_Object.__name = 'FriendCollection'
	return _Object
end

function FriendCollection:Initialize()
	if(not self:IsInitialized()) then
		self:ParentInitialize()
		try(function ()
			for i = 1, BNGetNumFriends() do
				self:CheckFriend(i)
			end
			self:IsInitialized(true)
		end).
		catch(function (inErrorMessage)
			XFG:Warn(self:GetObjectName(), 'Failed to initialize: ' .. inErrorMessage)
		end)
	end
	return self:IsInitialized()
end

function FriendCollection:ContainsByFriendIndex(inFriendIndex)
	assert(type(inFriendIndex) == 'number')
	for _, _Friend in self:Iterator() do
		if(_Friend:GetID() == inFriendIndex) then
			return true
		end
	end
	return false
end

function FriendCollection:ContainsByGameID(inGameID)
	assert(type(inGameID) == 'number')
	for _, _Friend in self:Iterator() do
		if(_Friend:GetGameID() == inGameID) then
			return true
		end
	end
	return false
end

function FriendCollection:GetFriendByGameID(inGameID)
	assert(type(inGameID) == 'number')
	for _, _Friend in self:Iterator() do
		if(_Friend:GetGameID() == inGameID) then
			return _Friend
		end
	end
end

function FriendCollection:GetFriendByRealmUnitName(inRealm, inName)
	assert(type(inRealm) == 'table' and inRealm.__name ~= nil and inRealm.__name == 'Realm', 'argument must be Realm object')
	assert(type(inName) == 'string')
	for _, _Friend in self:Iterator() do
		 if(inName == _Friend:GetName()) then
			 local _Target = _Friend:GetTarget()
			 if(inRealm:Equals(_Target:GetRealm())) then
				return _Friend
			 end
		 end
	 end
end

function FriendCollection:RemoveFriend(inKey)
	assert(type(inKey) == 'number')
	if(self:Contains(inKey)) then
		local _Friend = self:GetFriend(inKey)
		if(XFG.Nodes:Contains(_Friend:GetName())) then
			XFG.Nodes:RemoveNode(XFG.Nodes:GetObject(_Friend:GetName()))
		end
		self._FriendsCount = self._FriendsCount - 1
		self._Friends[inKey] = nil		
	end
	return not self:Contains(inKey)
end

function FriendCollection:HasFriends()
    return self:GetCount() > 0
end

local function CanLink(inAccountInfo)
	if(inAccountInfo.isFriend and 
	   inAccountInfo.gameAccountInfo.isOnline and 
	   inAccountInfo.gameAccountInfo.clientProgram == 'WoW') then

	   	-- There's no need to store if they are not logged into realm/faction we care about
		local _Realm = XFG.Realms:GetRealmByID(inAccountInfo.gameAccountInfo.realmID)

		-- When a player is in Torghast, it will list realm as 0, no character name or faction
		-- Bail out before it causes an exception
		if(_Realm == nil or _Realm:GetName() == 'Torghast') then return false end

		-- We don't want to link to neutral faction toons
		if(inAccountInfo.gameAccountInfo.factionName == 'Neutral') then return false end

		local _Faction = XFG.Factions:GetFactionByName(inAccountInfo.gameAccountInfo.factionName)
		if(XFG.Targets:ContainsByRealmFaction(_Realm, _Faction) and (not XFG.Player.Faction:Equals(_Faction) or not XFG.Player.Realm:Equals(_Realm))) then
			return true
		end
	end
	return false
end

function FriendCollection:CheckFriend(inKey)
	try(function ()
		local _AccountInfo = C_BattleNet.GetFriendAccountInfo(inKey)
		if(_AccountInfo == nil) then
			error('Received nil for friend [%d]', inKey)
		end

		-- Did they go offline?
		if(self:Contains(_AccountInfo.bnetAccountID)) then
			if(CanLink(_AccountInfo) == false) then
				local _Friend = XFG.Friends:GetObject(_AccountInfo.bnetAccountID)
				self:RemoveObject(_Friend:GetKey())
				XFG:Info(self:GetObjectName(), 'Friend went offline or to unsupported guild [%s:%d:%d:%d]', _Friend:GetTag(), _Friend:GetAccountID(), _Friend:GetID(), _Friend:GetGameID())
				return true
			end

		-- Did they come online on a supported realm/faction?
		elseif(CanLink(_AccountInfo)) then
			local _Realm = XFG.Realms:GetRealmByID(_AccountInfo.gameAccountInfo.realmID)
			local _Faction = XFG.Factions:GetFactionByName(_AccountInfo.gameAccountInfo.factionName)
			local _Target = XFG.Targets:GetTargetByRealmFaction(_Realm, _Faction)
			local _NewFriend = Friend:new()
			_NewFriend:SetKey(_AccountInfo.bnetAccountID)
			_NewFriend:SetID(inKey)
			_NewFriend:SetAccountID(_AccountInfo.bnetAccountID)
			_NewFriend:SetGameID(_AccountInfo.gameAccountInfo.gameAccountID)
			_NewFriend:SetAccountName(_AccountInfo.accountName)
			_NewFriend:SetTag(_AccountInfo.battleTag)
			_NewFriend:SetName(_AccountInfo.gameAccountInfo.characterName)
			_NewFriend:SetTarget(_Target)
			self:AddObject(_NewFriend)
			XFG:Info(self:GetObjectName(), 'Friend logged into supported guild [%s:%d:%d:%d]', _NewFriend:GetTag(), _NewFriend:GetAccountID(), _NewFriend:GetID(), _NewFriend:GetGameID())
			-- Ping them to see if they're running the addon
			if(XFG.Initialized) then 
				XFG.BNet:PingFriend(_NewFriend) 
			end
			return true
		end
	end).
	catch(function (inErrorMessage)
	    XFG:Warn(self:GetObjectName(), 'Failed to check friend: ' .. inErrorMessage)
	end)
	return false
end

function FriendCollection:CheckFriends()
	try(function ()
		local _LinksChanged = false
		for i = 1, BNGetNumFriends() do
			local _Changed = self:CheckFriend(i)
			if(_Changed) then
				_LinksChanged = true
			end
		end
		if(_LinksChanged) then
			XFG.DataText.Links:RefreshBroker()
		end
	end).
	catch(function (inErrorMessage)
		XFG:Warn(self:GetObjectName(), 'Failed to update BNet friends: ' .. inErrorMessage)
	end)
end

function FriendCollection:CreateBackup()
	try(function ()
	    XFG.DB.Backup.Friends = {}
	    for _, _Friend in self:Iterator() do
			if(_Friend:IsRunningAddon()) then
				table.insert(XFG.DB.Backup.Friends, _Friend:GetKey())
			end
		end
	end).
	catch(function (inErrorMessage)
		table.insert(XFG.DB.Errors, 'Failed to create friend backup before reload: ' .. inErrorMessage)
	end)
end

function FriendCollection:RestoreBackup()
	if(XFG.DB.Backup == nil or XFG.DB.Backup.Friends == nil) then return end		
	for _, _Key in pairs (XFG.DB.Backup.Friends) do
		try(function ()	
			if(XFG.Friends:Contains(_Key)) then
				local _Friend = XFG.Friends:GetObject(_Key)
				_Friend:IsRunningAddon(true)
				XFG:Info(self:GetObjectName(), "  Restored %s friend information from backup", _Friend:GetTag())
			end
		end).
		catch(function (inErrorMessage)
			XFG:Warn(self:GetObjectName(), 'Failed to restore friend list: ' .. inErrorMessage)
		end)
	end
end
