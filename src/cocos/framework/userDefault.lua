local userDefault = {}

local user = cc.UserDefault:getInstance()

function userDefault.getBoolForKey(pKey, defaultValue)
		
end

function userDefault.getIntegerForKey(pKey, defaultVaule)
	return user:getIntegerForKey(pKey, defaultVaule)
end

return userDefault

