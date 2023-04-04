if argument_count = 2
var pArrayCheckLength = argument[1]
else
var pArrayCheckLength = playerArraySize

for (var i = 0; i < pArrayCheckLength; i += 1)
{
	if players[i,playerData.pId] = argument[0]
	return i
}

return -1