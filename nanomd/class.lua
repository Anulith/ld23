function class()
	local cls = {}
	cls.__index = cls
	return setmetatable(cls, {__call = function (c, ...)
		instance = setmetatable({}, cls)
		if cls.__init then
			cls.__init(instance, ...)
		end
		return instance
	end})
end
