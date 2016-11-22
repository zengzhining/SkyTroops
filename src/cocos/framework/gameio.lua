local gameio = {}

local fileUtils = cc.FileUtils:getInstance()

--判断文件是否存在
gameio.isExist = function ( fileName )
	return fileUtils:isFileExist(fileName)
end
--plist写入
gameio.writeVectorPlistToFile = function ( tbl, path )
	fileUtils:writeValueVectorToFile(tbl, path)
end

--plist读取
gameio.getVectorPlistFromFile = function ( path )
	local data = fileUtils:getValueVectorFromFile(path)
	return data
end

return gameio

