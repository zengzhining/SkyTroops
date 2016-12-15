local userDefault = {}

local user = cc.UserDefault:getInstance()

function userDefault.getBoolForKey(pKey, defaultValue)
		
end

function userDefault.getIntegerForKey(pKey, defaultVaule)
	return user:getIntegerForKey(pKey, defaultVaule)
end

function userDefault.setIntegerForKey(pKey, value)
	return user:setIntegerForKey(pKey, value)
end

return userDefault

