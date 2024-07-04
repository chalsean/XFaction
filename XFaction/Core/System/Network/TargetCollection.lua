local XF, G = unpack(select(2, ...))
local XFC, XFO, XFF = XF.Class, XF.Object, XF.Function
local ObjectName = 'TargetCollection'

XFC.TargetCollection = XFC.ObjectCollection:newChildConstructor()

--#region Constructors
function XFC.TargetCollection:new()
	local object = XFC.TargetCollection.parent.new(self)
	object.__name = ObjectName
    return object
end

function XFC.TargetCollection:Initialize()
	if(not self:IsInitialized()) then
		self:ParentInitialize()
		for _, guild in XFO.Guilds:Iterator() do
			local target = XFC.Target:new()
			target:Guild(guild)
			target:Key(guild:Key())
			target:Name(guild:Name())
			self:Add(target)
			XF:Info(self:ObjectName(), 'Initializing target [%s]', target:Key())
		end
		self:IsInitialized(true)
	end
	return self:IsInitialized()
end
--#endregion