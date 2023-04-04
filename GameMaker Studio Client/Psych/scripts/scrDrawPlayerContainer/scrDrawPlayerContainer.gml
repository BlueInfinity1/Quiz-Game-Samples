draw_sprite(sprResultsContainer,-1,313,139)
		
nonHostPlayerCount = 0 
imageRowSpace = 37 //100//90 //assuming pImgWidth 60
			
var totalPlayers = playerCount
var playersPerPage = 7
playerNameMaxYMovement = imageRowSpace * (totalPlayers-playersPerPage)
		
if instance_exists(objSliderKnob)
knobRatio = objSliderKnob.knobRatio
else
knobRatio = 0

hostBaseYPos = 159 - playerNameMaxYMovement*knobRatio
		
if hostHasJoined //reserve the top spot in the list for the host
nonHostBaseY = hostBaseYPos + imageRowSpace
else
nonHostBaseY = hostBaseYPos
		
baseXPos = 341

notReadyMarkerRotation += 10

for (i = 0; i < playerArraySize; i++) ///*maxPlayers*/
{	
	/*if i >= playerArraySize //DEBUG
	{
		draw_set_halign(fa_left)
		draw_set_valign(fa_middle)
		draw_set_color(bgColor)
				
		var pImgHeight = playerImageSize
				
		baseYPos = nonHostBaseY + imageRowSpace*nonHostPlayerCount
				
		draw_text(baseXPos + 35,baseYPos+2, "WWWWWWWW...")
		var pImg = sprPlaceholderImage
		draw_sprite_ext(pImg,0,baseXPos - round(pImgHeight/2),baseYPos - round(pImgHeight/2),
				pImgHeight/sprite_get_width(pImg), pImgHeight/sprite_get_height(pImg),0,c_white,1) //
				
		nonHostPlayerCount += 1
				
		continue
	}//*/
			
	if players[i, playerData.isDead] or !is_string(players[i, playerData.pId]) or !is_string(players[i, playerData.pName])//if this is undefined, then we can't do anything here
	continue
			
	scrDrawPlayerProfileImage(25, i, true)
	
	//PHASE-SPECIFIC ADDITIONS HERE
	if phase = gamePhase.waitingForStatements
	{
		if !players[i,playerData.statementsWritten]
			draw_sprite_ext(sprNotReadyMarker,0,baseXPos+210,baseYPos,1,1,notReadyMarkerRotation,c_white,1)
		else
			draw_sprite(sprReadyMarker,0,baseXPos+210,baseYPos)
	}
	else if phase = gamePhase.waitingForGuesses
	{
		if players[i,playerData.selectedGuessId] = "-1"
		draw_sprite_ext(sprNotReadyMarker,0,baseXPos+210,baseYPos,1,1,notReadyMarkerRotation,c_white,1)
		else
		draw_sprite(sprReadyMarker,0,baseXPos+210,baseYPos)
	}
}