/// @description Insert description here
// You can write your code in this editor

//show_message("async image load: "+string(async_load[? "id"]))

for (var i = 0; i < playerArraySize; i += 1)
{
	var tempPlayerId = players[i, playerData.pId]
	
	//show_message("async load temp player id" + tempPlayerId)
	
	if ds_map_find_value(async_load, "id") == ds_map_find_value(imageRequests,tempPlayerId)
	{			
		if ds_map_find_value(async_load, "status") >= 0
		{
			//show_message("load successful, add sprite for player "+string(i))

			//players[i, playerData.pImage] = sprPlaceholderImage //sprite_add(imageFilePath + "player"+string(i)+".png",1,false,false,0,0) //jpg
			//show_message(players[i, playerData.pImage])
			
			ds_map_add(playerImages, tempPlayerId, ds_map_find_value(imageRequests,tempPlayerId))
			
			if i = ownPlayerIndex
			playerImage = ds_map_find_value(imageRequests,tempPlayerId) //is this ever used though?	
		}
		else
		{
			//show_message("reload image for player index " + string(i) + ", reload url: "+players[i, playerData.pImageUrl])

			var loadMapValue = ds_map_find_value(imageLoadAttempts,tempPlayerId)
			
			if is_undefined(loadMapValue)
			loadMapValue = 0
			
			//show_message("Load attempts: "+string(loadMapValue))
			
			if loadMapValue < imageLoadMaxAttempts
			{
				//show_message("attempt reloading")
				scrMakeImageRequest(tempPlayerId,players[i, playerData.pImageUrl])
				ds_map_replace(imageLoadAttempts,tempPlayerId,loadMapValue+1)
			}
			else
			{
				//show_message("Out of attempts, use placeholder img")
				ds_map_add(playerImages, tempPlayerId, sprPlaceholderImage)
			}
			//else
			//players[i, playerData.pImage] = sprPlaceholderImage
		}
	} //ds_map_find_value
}