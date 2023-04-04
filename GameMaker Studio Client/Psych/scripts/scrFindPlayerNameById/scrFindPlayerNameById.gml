//arg0 - id, arg1 - use short name

//if playerArraySize != array_height_2d(players)
//show_message("playerArraySize momentarily differs from array height: "+string(playerArraySize) + " "+string(array_height_2d(players)))

for (var i = 0; i < /*array_height_2d(players)*/ playerArraySize; i += 1)
{
	if players[i,playerData.pId] = argument0
	{
		if argument1
		return players[i,playerData.pShortName]
		else
		return players[i,playerData.pName]
		
	}
}
return "Anonymous"

//show_message("Could not find player id (name search), RESTART")
//game_restart()