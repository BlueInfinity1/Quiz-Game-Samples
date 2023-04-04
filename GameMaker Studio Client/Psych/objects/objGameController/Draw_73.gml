 /// @description Insert description here
// You can write your code in this editor

//if drawNewSprite
//draw_sprite(newSprite,0,200,200)

if isSpectator
{
	draw_set_color(c_white)
	draw_set_halign(fa_left)
	draw_set_valign(fa_middle)
	draw_set_font(fntPluto12p)
	draw_text(room_width/2 - round(windowWidth*0.5) + 20, room_height/2 - round(windowHeight*0.5) + 20,"SPECTATING")
}

if phase >= gamePhase.writingStatements and phase <= gamePhase.viewingAnswers 
and phase != gamePhase.preparingToShowResult and phase != gamePhase.showingResults
{
	var counterXPos = room_width/2 + round(windowWidth*0.5) - 60
	var counterYPos = room_height/2 - round(windowHeight*0.5) + 30
	draw_sprite(sprScoreCounter,0, counterXPos, counterYPos)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fntPluto12p)
	
	if pointMap[? playerId] != undefined
	draw_text(counterXPos + scoreTextXOff, counterYPos + scoreTextYOff, string(pointMap[? playerId]))
	else
	draw_text(counterXPos + scoreTextXOff, counterYPos + scoreTextYOff, "0")
}


if notificationTimer > 0
{
	notificationTimer -= 1
	
	if notificationScale < 0.99 //the beginning
	{
		notificationScale += 0.2
		notificationXScale = notificationScale
		notificationYScale = notificationScale
	}
	
	//hold the notification still after this note
	if notificationTimer >= notificationMoveStopTime
	notificationY -= notificationMoveSpeed
		
	if notificationTimer < 6//11
	{
		//notificationAlpha -= 0.1
		notificationYScale -= 0.2
		
		if notificationYScale < 0.01 
		notificationYScale = 0
	}
	
	
	draw_set_font(fntMediumTitleFont)
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_alpha(notificationAlpha)
	
	notificationMessage = string_wordwrap_width(notificationMessage,600,"\n",true)
	
	draw_text_colour_outline(round(room_width/2),notificationY,notificationMessage,bgColor,bgColor,1,c_white,c_white,
	1,2,10,notificationXScale,notificationYScale,0)
	//draw_text_ext_transformed(round(room_width/2),notificationY,notificationMessage,-1,600,notificationScale,notificationScale,0)
	
	draw_set_alpha(1)
}

/*if phase >= gamePhase.guessingStatements
{
	draw_set_halign(fa_left)
	draw_set_color(c_white)
	for (var i = 0; i < playerArraySize; i += 1)
	{
		if players[i, playerData.isDead]
		continue
		
		draw_text(10,20 + 20*i,string(players[i, playerData.pId]) + " "+string(players[i, playerData.selectedGuessId]))
	}
}*/


if debugModeOn and phase >= gamePhase.selectingCategory
{
	draw_set_color(defaultTextColor)
	draw_set_font(fntStandardFont)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	//if playerImage > 0
	//draw_sprite_ext(playerImage,-1,60,60,playerImageSize/sprite_get_width(playerImage), playerImageSize/sprite_get_height(playerImage),
	//0,defaultTextColor,1)
	//else
	//draw_text(30,30,"Img not loaded")

	if gamePrepared
	{
		var playerChoiceString =  " chosenAnswer: "+string(selectedGuessId)//+string(players[ownPlayerIndex,playerData.selectedGuessIndex])
		var ownStatementsWrittenInfo = " sw: "+string(ownStatementsWritten)
		var readyNextString = " rn: "+string(readyForNextRound)
	}
	else
	{
		var playerChoiceString = "No chosen answer"
		var ownStatementsWrittenInfo = " sw: - "
		var readyNextString = " rn: -"
	}

	draw_set_halign(fa_left)
	draw_set_color(c_white)
	draw_set_font(fntStandardFont)
	
	for (var i = 100; i < 106; i += 1)
	{
		if i = 102 //102 not in use
		continue

		if ds_exists(webSocketRequests[? i],ds_type_list)
		draw_text_ext(20,50+20*(i-100),string(ds_list_size(webSocketRequests[? i])) + " - "+string(lastRequestTimes[i]),-1,800)
	}
	
	for (var i = 200; i < 202; i+= 1)
	{
		if ds_exists(webSocketRequests[? i],ds_type_list)
		draw_text_ext(20,190+20*(i-200),string(ds_list_size(webSocketRequests[? i])) + " - "+string(lastRequestTimes[i]),-1,800)
	}
	//"pImgUrl: "+imageUrl+
	draw_text_ext(20,550,"lit: "+string(lastInteractTime) + " pCount: "+string(playerCount) + " pArrSize: "+string(playerArraySize)+ " ws: " + string(web_socket_status(0))+ //" getDataReq: " +string(getPlayerDataRequest) + 
	+ "\nng btn: "+string(instance_number(objNextRoundButton))
	+ " indat: "+string(initialDataAboutOthersFetched)
	//+"\nhostStart: "+string(hostHasStartedGame)
	/*" reqType: "+string(requestDataToFetch) + " gPhase: "+ string(phase) + "\nfA: "+yourFakeAnswer+*/
	+" al11: "+string(alarm[11]) + " rfs: "+string(readyForScores)
	+"\nal6: "+string(alarm[6]) +" hostId: "+string(hostId) //+ playerChoiceString + ownStatementsWrittenInfo
	+ " dP: "+string(debugPopUpsOn) + " dM: "+string(debugModeOn)
	+"\ntrigRec: "+string(triggerRecovery) + " cR: " + string(checkNeedToRecover)
	//+ "\ndc query: "+string(disconnectionQueryRequest) +  "ph: "+string(phase) + //
	+ " oInd: "+string(ownPlayerIndex) + " isHost: "+string(isHost) //+ "sId: "+string(sessionId) //+ " n1: "+nrCond1 + " n2: "+nrCond2 + " n3: "+nrCond3
	,-1,850) /*+"\nTooManyplayers: " +string(showTooManyPlayersMessage)*/

	/*for (var i = 0; i < playerCount; i += 1)
	{
		draw_text(750,50+i*20,string(imageLoaded[i]))
	}*/

	draw_text(750,20,"ID:" + string(ownId) + "\nN: " +string(ownName))//*/
}
else if debugModeOn //other phase
draw_text(40,room_height - 40, "DEBUG MODE")