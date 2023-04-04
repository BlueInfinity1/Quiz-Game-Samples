/// @description scrDrawPlayerProfileImage(imgHeight, pIndex, drawText, [baseXPos], [baseYPos])
//
//
/// @param 
//PROFILE IMAGE DRAWING

//NOTE: The last two params are only used in the statement phase

//show_message("Player draw script")

var pImgHeight = argument[0]//playerImageSize

var jj = argument[1]

if argument_count >= 3
var drawText = argument[2]
else
var drawText = false

if players[jj, playerData.pId] = hostId
var pText = players[jj, playerData.pShortName] + " (Host)"
else
{
	var pText = players[jj, playerData.pShortName]
	
	if players[jj, playerData.pId] = ownId
	pText += " (You)"
}

//show_message(players[j, playerData.pId]) 
//show_message(players[j, playerData.pShortName])
//var drawCrown = false //by default

//show_message("set positions")

//drawing next to the statement choices
if phase = gamePhase.viewingAnswers
{
	baseXPos = argument[3]
	baseYPos = argument[4]
}
else if phase != gamePhase.showingScores
{
	if players[jj, playerData.pId] = hostId
	{
		baseYPos = hostBaseYPos
	}
	else
	{
		baseYPos = nonHostBaseY + imageRowSpace*nonHostPlayerCount
		nonHostPlayerCount += 1
	}
}
else //in the score viewing phase, we organize the players based on rank, not by j, so handle y positions differently
{
	
	baseYPos = hostBaseYPos + imageRowSpace*scoreListIndex//*(tempRank+sameRankCountPerRank[tempRank])
	
	/*if tempRank = 0
	{
		leadingPlayerShortName = players[j, playerData.pShortName]
		drawCrown = true
	}*/
	
	//show_message("score drawing phase")
}

draw_set_color(defaultTextColor)
			
var tempPlayerId = players[jj, playerData.pId]
var pImg = ds_map_find_value(playerImages,tempPlayerId)

//show_message("img phase")

//NOTE: Testing this with any sprite requires them to have top-left origin
//pImg = sprBackground

if !is_undefined(pImg)
{
	if pImg != sprPlaceholderImage
	{
		if pImgHeight = 25
		{
			var tempSurface = ds_map_find_value(playerImageSurfaces,tempPlayerId)
			var surfaceMap = playerImageSurfaces
		}
		else
		{
			var tempSurface = ds_map_find_value(playerImageSurfaces35p,tempPlayerId)
			var surfaceMap = playerImageSurfaces35p
		}

		if is_undefined(tempSurface)
		tempSurface = -4
		
		//var maxImgHeight = 35
		
		if !surface_exists(tempSurface)
		{
			//NOTE: to avoid having two separate surface maps, we only make the 35p one and then scale
			//accordingly
			tempSurface = surface_create(pImgHeight,pImgHeight)
			ds_map_add(surfaceMap,tempPlayerId,tempSurface)
				
			//NOTE: We create the hostImageSize of this and then resize it smaller depending on the position
			//so that we don't have to create this again if there are host changes
			surface_set_target(tempSurface)
			
			draw_sprite_ext(pImg,0,0,0,pImgHeight/sprite_get_width(pImg),pImgHeight/sprite_get_height(pImg),0,c_white,1)
						
			gpu_set_blendmode(bm_subtract)
	
			if pImgHeight = 25
			var cutMask = sprCutMask25
			else //35*/
			var cutMask = sprCutMask35
	
			draw_sprite(cutMask,0,0,0)
					
			surface_reset_target()
		}
					
		gpu_set_blendmode(bm_normal)
					
		if surface_exists(tempSurface)
		{	
			draw_surface_ext(tempSurface,baseXPos - round(pImgHeight/2),baseYPos - round(pImgHeight/2),
				1,1,0,c_white,1)
				
				//pImgHeight/sprite_get_width(pImg), pImgHeight/sprite_get_height(pImg)
		}
	} 
	else  //this is placeholder image, no need to use surface
	{
		if pImgHeight >= 26 //use the bigger version
		pImg = sprPlaceholderImage35p
		
		draw_sprite_ext(pImg,0,baseXPos - round(pImgHeight/2),baseYPos - round(pImgHeight/2),
			pImgHeight/sprite_get_width(pImg), pImgHeight/sprite_get_height(pImg),0,c_white,1) //

		//write first letter of the player on top of the image
		draw_set_font(fntLetterFont12p)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(c_white)
		draw_text(baseXPos, baseYPos, string_upper(string_char_at(players[jj, playerData.pName],1)))
	}			
}

if drawCrown //only in scoreboard phase
draw_sprite(sprCrown,0,baseXPos-round(pImgHeight/2) + crownXOff,baseYPos-round(pImgHeight/2) + crownYOff)
		
//show_message("img done")
		
if drawText
{
	draw_set_font(fntSmallFont)
	draw_set_color(bgColor)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)

	var splitPTextString = pText	
	draw_text(baseXPos + 35,baseYPos+2, splitPTextString) //+ round(pImgHeight*0.65)
}

//show_message("text done")