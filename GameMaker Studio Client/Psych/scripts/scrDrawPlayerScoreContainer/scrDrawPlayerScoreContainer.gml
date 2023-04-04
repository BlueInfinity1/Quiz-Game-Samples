/*draw_sprite(sprResultsContainer,-1,313,139)
				
var nonHostPlayerCount = 0 
var imageRowSpace = 37 //100//90 //assuming pImgWidth 60
		
		
var totalPlayers = maxPlayers //playerCount
var playersPerPage = 7
playerNameMaxYMovement = imageRowSpace * (totalPlayers-playersPerPage)
		
var hostBaseYPos = 159 - playerNameMaxYMovement*objSliderKnob.knobRatio
		
if hostHasJoined //reserve the top spot in the list for the host
var nonHostBaseY = hostBaseYPos + imageRowSpace
else
var nonHostBaseY = hostBaseYPos
		
var baseXPos = 341

notReadyMarkerRotation += 10

for (var i = 0; i < maxPlayers; i++) //playerArraySize
{	
	if i >= playerArraySize
	{
		draw_set_halign(fa_left)
		draw_set_valign(fa_middle)
		draw_set_color(bgColor)
				
		var pImgHeight = playerImageSize
				
		baseYPos = nonHostBaseY + imageRowSpace*nonHostPlayerCount
				
		draw_text(baseXPos + 35,baseYPos+2, "PLACEHOLDER")
		var pImg = sprPlaceholderImage
		draw_sprite_ext(pImg,0,baseXPos - round(pImgHeight/2),baseYPos - round(pImgHeight/2),
				pImgHeight/sprite_get_width(pImg), pImgHeight/sprite_get_height(pImg),0,c_white,1) //
				
		nonHostPlayerCount += 1
				
		continue
	}
			
	if players[i, playerData.isDead] or !is_string(players[i, playerData.pId]) or !is_string(players[i, playerData.pName])//if this is undefined, then we can't do anything here
	continue
			
	//PROFILE IMAGE DRAWING
			
	var pImgHeight = playerImageSize
			
	if players[i, playerData.pId] = hostId
	{
		var baseYPos = hostBaseYPos
		var pText = players[i, playerData.pShortName] + " (Host)"
	}
	else
	{
		var baseYPos = nonHostBaseY + imageRowSpace*nonHostPlayerCount
		nonHostPlayerCount += 1
		var pText = players[i, playerData.pShortName]
	}
			
	draw_set_color(defaultTextColor)
			
	var tempPlayerId = players[i, playerData.pId]
	var pImg = ds_map_find_value(playerImages,tempPlayerId)
			
	if !is_undefined(pImg)
	{
		if pImg != sprPlaceholderImage
		{
			var tempSurface = ds_map_find_value(playerImageSurfaces,tempPlayerId)
					
			if is_undefined(tempSurface)
			tempSurface = -4
					
			if !surface_exists(tempSurface)
			{
				tempSurface = surface_create(hostImageSize,hostImageSize)
				ds_map_add(playerImageSurfaces,tempPlayerId,tempSurface)
				
				//NOTE: We create the hostImageSize of this and then resize it smaller depending on the position
				//so that we don't have to create this again if there are host changes
				surface_set_target(tempSurface)
				draw_sprite_ext(pImg,0,0,0,hostImageSize/sprite_get_width(pImg), hostImageSize/sprite_get_height(pImg),0,c_white,1)
						
				gpu_set_blendmode(bm_subtract)
	
				draw_sprite(sprCutMask25,0,0,0)
					
				surface_reset_target()
			}
					
			gpu_set_blendmode(bm_normal)
					
			if surface_exists(tempSurface)
			{	
				draw_surface_ext(tempSurface,baseXPos - round(pImgHeight/2),baseYPos - round(pImgHeight/2),
					pImgHeight/hostImageSize,pImgHeight/hostImageSize,0,c_white,1)
					//pImgHeight/sprite_get_width(pImg), pImgHeight/sprite_get_height(pImg)
			}
		} 
		else  //this is placeholder image, no need to use surface
		{
			draw_sprite_ext(pImg,0,baseXPos - round(pImgHeight/2),baseYPos - round(pImgHeight/2),
				pImgHeight/sprite_get_width(pImg), pImgHeight/sprite_get_height(pImg),0,c_white,1) //

			//write first letter of the player on top of the image
			draw_set_font(fntLetterFont12p)
			draw_set_halign(fa_center)
			draw_set_valign(fa_middle)
			draw_set_color(c_white)
			draw_text(baseXPos, baseYPos, string_upper(string_char_at(players[i, playerData.pName],1)))
		}
				
	}
	draw_set_font(fntSmallFont)
	draw_set_color(bgColor)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
		
	var splitPTextString = pText
			
	draw_text(baseXPos + 35,baseYPos+2, splitPTextString) //+ round(pImgHeight*0.65)
	
	
}