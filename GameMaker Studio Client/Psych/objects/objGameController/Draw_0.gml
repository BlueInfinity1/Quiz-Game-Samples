 /// @description Insert description here
// You can write your code in this editor

//draw_set_color(defaultTextColor)

if showSessionExpiredMessage or showTooManyPlayersMessage or showGameAlreadyStartedMessage
{
	draw_sprite_ext(sprBackground,0,0,0,1,1,0,bgColor,1)
	
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	draw_set_font(fntBigTitleFont)
	draw_text(room_width/2,32,"PSYCH!")

	if showSessionExpiredMessage
	{
		baseText = "Session expired. Please end the current game and start a new one."
		baseTextYPos = room_height*0.5
	}
	else if showTooManyPlayersMessage
	{
		baseText = "This game session already has the maximum number ("+string(maxPlayers)+") of players!"
		baseTextYPos = room_height*0.5
	}
	else if showGameAlreadyStartedMessage
	{
		baseText = "This game round has already started. Please wait until the current game round ends and join the next one."
		baseTextYPos = room_height*0.5
	}
		
	draw_text_ext(round(room_width*0.5), round(baseTextYPos),baseText + textAddition,-1,600)	
	exit
}

for (var i = 0; i < playerArraySize; i += 1)
{
	var currPName = players[i, playerData.pName]
	if currPName != undefined
	{
		if string_length(currPName) <= 8
		players[i, playerData.pShortName] = currPName
		else
		players[i, playerData.pShortName] = string_copy(currPName,1,8) + "..."
	}
}

switch (phase)
{	
	case gamePhase.selectingCategory: //only for the host
	{
		draw_set_color(c_white)
		draw_set_halign(fa_center)		
		draw_set_font(fntBigTitleFont)
		draw_set_valign(fa_middle)
		
		var maxYMove = 200
		
		//if debugModeOn and !instance_exists(objSliderKnob)
		//show_message("no knob, shouldn't happen")
		
		draw_text(room_width/2,32 - objSliderKnob.knobRatio*maxYMove,"PSYCH!")
		
		draw_set_font(fntStandardFont)
		draw_text(room_width/2,90 - objSliderKnob.knobRatio*maxYMove,"Please select a question category.")
		
	
		break
	}
	
	case gamePhase.initializing:
	{
		draw_sprite_ext(sprBackground,0,0,0,1,1,0,bgColor,1)
		//draw_set_color(c_black)
		//draw_set_alpha(0.7)
		//draw_rectangle(0,0,room_width,room_height,false)
		
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fntBigTitleFont)
		draw_text(room_width/2,32,"PSYCH!")
		
		if !showTooManyPlayersMessage and !showGameAlreadyStartedMessage and !showSessionExpiredMessage
		{
			if !initiallyPrepared
			baseText = "Please wait while the game is being prepared."	
			else
			baseText = "Please wait while the next game is being prepared."	
			
			connTimer += 1
	
			draw_sprite_ext(sprRefreshIcon,-1,room_width/2,round(room_height*0.65),1,1,-connTimer*10,c_white,1)
			baseTextYPos = room_height*0.35
		}
		
		draw_text_ext(round(room_width*0.5), round(baseTextYPos),baseText + textAddition,-1,600)	
		//scrDrawOutlinedText(round(room_width*0.5), round(baseTextYPos),baseText + textAddition,c_white,c_black,1,-1,600)
		
		break
	}
	
	case gamePhase.waitingForPlayers:
	{
		draw_sprite_ext(sprBackground,0,0,0,1,1,0,bgColor,1)
		
		
		var containerTopY = 139
		var containerHeight = 266
		scrDrawPlayerContainer()
		
		//STUFF ON OVERLAYS
		
		draw_sprite_part_ext(sprBackground,0,0,0,room_width,containerTopY,0,0,1,1,bgColor,1) //upper overlay hiding the scrolls
		draw_sprite_part_ext(sprBackground,0,0,containerTopY+containerHeight,room_width,
			room_height - (containerTopY+containerHeight),0, containerTopY+containerHeight,1,1,bgColor,1) //lower
		
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fntBigTitleFont)
		draw_text(room_width/2,32,"PSYCH!")
				
		draw_set_color(defaultTextColor)
		draw_set_font(fntStandardFont)	
		draw_set_valign(fa_middle)//fa_middle)
		draw_set_halign(fa_center)
		
		if isHost
		{
			if playerCount <= 1
			var promptText = "Press \"Start game\" button to begin once 2 or more players have joined."
			else
			var promptText = "Press \"Start game\" button to begin."
		}
		else
		{
			if currentCategoryId = -1
			var promptText = "Please wait for the host ("+scrFindPlayerNameById(hostId, true)+") to select a question category."
			else if playerCount <= 1
			var promptText = "Please wait until 2 or more players have joined and the host has started the game."
			else 
			var promptText = "Please wait until the host ("+scrFindPlayerNameById(hostId, true)+") has started the game."
		}
		
		draw_text_ext(room_width/2,100,promptText,-1,450)
		
		draw_set_font(fntStandardFont)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_color(c_white)
		draw_text(room_width/2,270+180,"Players: "+string(playerCount) + " / "+string(maxPlayers)) //270
		//scrDrawOutlinedText(room_width/2,350+130,"Players: "+string(playerCount) + " / "+string(maxPlayers),c_white,c_black,1,-1,900)
		//*/
		break
	}
	
	
	case gamePhase.writingStatements:
	{		
		/*draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fntBigTitleFont)
		draw_text(room_width/2,32,currentCategoryName)//categoryName)*/
		
		scrDrawTitleText(currentCategoryName)
		
		//var promptText = "Write an answer to the following question that you think the others will mistake"+
		//" for the correct one!"
			
		var containerY = 122
			
		draw_sprite(sprQuestionContainer,0,room_width/2,containerY)
			
		if string_length(currentQuestion) <= 130
		draw_set_font(fntSmallFont)
		else if string_length(currentQuestion) <= 150
		draw_set_font(fntPluto10p) //1 pt smaller than smallFont, which is 11
		else
		draw_set_font(fntPluto8p) //the smallest possible
		
		draw_set_color(bgColor)
		//currentQuestion
		draw_text_ext_transformed(room_width/2, containerY,currentQuestion ,-1,400/questionTextSize,questionTextSize,questionTextSize,0)
		
		if isSpectator
		{
			draw_set_font(fntMediumTitleFont)
			draw_set_color(c_white)
			draw_text_ext(room_width/2, room_height/2, "The players are now writing their answers.",-1,450)
		}
		
		break
	}
	
	case gamePhase.waitingForStatements:
	{
		var containerTopY = 139
		var containerHeight = 266
		scrDrawPlayerContainer()
		
		//STUFF ON OVERLAYS
		
		draw_set_color(bgColor)
		draw_rectangle(0,0,room_width,containerTopY,false) //upper overlay hiding the scrolls
		draw_rectangle(0,containerTopY+containerHeight,room_width,room_height,false) //lower
		
		/*draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fntBigTitleFont)
		draw_text(room_width/2,32,currentCategoryName)//categoryName)*/
		scrDrawTitleText(currentCategoryName)
		
		
		var promptText = "Please wait for the others to finish writing their answers."
		
		draw_set_font(fntStandardFont)
		draw_text(room_width/2,270+180,promptText)
		
		break;
	} //case: phase = waitingForStatements
		

	case gamePhase.guessingStatements:
	{
		//STUFF ON OVERLAYS
		
		if is_undefined(upperVeilLowerY) //this may be undefined for the very first frame of this phase before it's set in alarm 1
		upperVeilLowerY = 200
		
		draw_set_color(bgColor)
		//var lowerCoverHeight = room_height - (objGameController.upmostY + objGameController.gapY*(objGameController.visibleAnswersWithoutScrolling) + 15)
 		draw_rectangle(0,0,room_width,upperVeilLowerY,false) //upper overlay hiding the scrolls
		
		//draw_text(300,300,upperVeilLowerY)
		//draw_rectangle(0,room_height - lowerCoverHeight,room_width,room_height,false) //lower
		draw_sprite(sprGradient,0,0,room_height - sprite_get_height(sprGradient))
		
		/*draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fntBigTitleFont)
		draw_text(room_width/2,32,currentCategoryName)//categoryName)*/
		
		scrDrawTitleText(currentCategoryName) 
		
		if !isSpectator
		topText = "Try to pick the correct answer!\n\n"
		else
		topText = "The players are now picking their answers from the following:\n\n"
		
		//+ string(players[guessingTargetIndex,playerData.pName])+ "?"
		var topTextMaxWidth = 750
	
		draw_set_font(fntSmallFont)
		draw_set_color(c_white)
		draw_set_valign(fa_top)
		draw_set_halign(fa_center)
		
		var containerY = 102
		
		draw_text_ext(room_width/2, containerY+40,topText,-1,topTextMaxWidth)
		
		draw_sprite(sprQuestionContainer,0,room_width/2,containerY)
			
		draw_set_valign(fa_middle)
		
		if string_length(currentQuestion) <= 130
		draw_set_font(fntSmallFont)
		else if string_length(currentQuestion) <= 150
		draw_set_font(fntPluto10p) //1 pt smaller than smallFont, which is 11
		else
		draw_set_font(fntPluto8p) //the smallest possible
		
		draw_set_color(bgColor)
		//currentQuestion
		draw_text_ext_transformed(room_width/2, containerY,currentQuestion ,-1,400/questionTextSize,questionTextSize,questionTextSize,0)
				
		break;
	}
	
	case gamePhase.waitingForGuesses:
	{
		var containerTopY = 139
		var containerHeight = 266
		scrDrawPlayerContainer()
		
		//OVERLAY
		
		draw_set_color(bgColor)
		draw_rectangle(0,0,room_width,containerTopY,false) //upper overlay hiding the scrolls
		draw_rectangle(0,containerTopY+containerHeight,room_width,room_height,false) //lower
		
		scrDrawTitleText(currentCategoryName)
		
		
		var promptText = "Please wait for the others to finish picking their answers."
		
		draw_set_font(fntStandardFont)
		draw_text(room_width/2,270+180,promptText)

		var containerY = 102
			
		draw_sprite(sprQuestionContainer,0,room_width/2,containerY)
			
		if string_length(currentQuestion) <= 130
		draw_set_font(fntSmallFont)
		else if string_length(currentQuestion) <= 150
		draw_set_font(fntPluto10p) //1 pt smaller than smallFont, which is 11
		else
		draw_set_font(fntPluto8p) //the smallest possible
		
		draw_set_color(bgColor)
		//currentQuestion
		draw_text_ext_transformed(room_width/2, containerY,currentQuestion ,-1,400/questionTextSize,questionTextSize,questionTextSize,0)
		
		break
	}
		
	case gamePhase.preparingToShowResult:
	{
		scrDrawTitleText(currentCategoryName)
		
		draw_set_font(fntBigTitleFont)
		draw_set_valign(fa_top)
		draw_set_halign(fa_center)
		draw_set_color(defaultTextColor)
		var displayText;
			
		displayText = "Let's see if your answer was correct..."
			
		draw_text_ext(room_width/2, room_height/2,displayText,-1,450)
			
		break
	}
	
	
	case gamePhase.showingResults:
	{
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		
		if selectedGuessId = 0
		{
			var resultText = "YOU'RE CORRECT! GOOD FOR YOU!"
			var textY = room_height/2
			draw_set_color(c_white)
			draw_sprite(sprPartyWin,0,0,0)
			draw_set_font(fntPlutoBoldBig)
			cardSprite = sprCorrectRectangle
		}
		else
		{
			var resultText = scrFindPlayerNameById(selectedGuessId,true)+"\ngot you!"
			var textY = room_height/2 + 100
			cardSprite = sprPsychCard
			draw_set_font(fntPlutoBoldBig)
			draw_set_color(c_black)
		}
		
		draw_sprite(cardSprite,0,room_width/2,321)
		draw_text_ext_transformed(room_width/2, textY, resultText,-1,260,1,1,0)
		
		scrDrawTitleText(currentCategoryName)
		
		break
	}
	
	case gamePhase.viewingAnswers:
	{
		/*if is_undefined(upperVeilLowerY) //this may be undefined for the very first frame of this phase before it's set in alarm 1
		upperVeilLowerY = 200*/
		
		draw_set_color(bgColor)
		draw_rectangle(0,0,room_width,upperVeilLowerY,false) //upper overlay hiding the scrolls
		//draw_rectangle(0,containerTopY+containerHeight,room_width,room_height,false) //lower	
		draw_sprite(sprGradient,0,0,room_height - sprite_get_height(sprGradient))
		
		if !isHost
		{
			draw_set_font(fntPluto12p)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_set_color(c_white)
			draw_text(room_width/2,room_height - 40,"Please wait for the host ("+scrFindPlayerNameById(hostId, true)+") to continue the game.")
		}
		//show_message("Before cat")
		
		//show_message("draw title")
		
		scrDrawTitleText(currentCategoryName)
		
		//show_message("undef guesscount map " +string(is_undefined(guessCountMap[? playerId])))
		
		if is_undefined(guessCountMap[? playerId]) //if this is not defined, then it means no one selected your answer
		{
			var psychedPlayers = 0
		}
		else
		{
			//show_message("Set to map value")
			var psychedPlayers = guessCountMap[? playerId]
		}
		
		//show_message("Pass")
		
		if !isSpectator
		{
			if psychedPlayers = 0
			var psychText = "You didn't psych anybody"
			else if psychedPlayers = 1
			var psychText = "You psyched 1 person!"
			else
			var psychText = "You psyched " +string(psychedPlayers) + " people!"
		
			//show_message("psych text: "+psychText)
		
			if psychedPlayers = 0
			var textY = 100
			else
			var textY = 80
		
			draw_set_font(fntStandardFont)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_set_color(c_white)
			draw_text_ext(room_width/2, textY,psychText, -1,420) //220 //draw full line
		
			var psychedPlayerString = ""
		
			//show_message("Psyched player list is undefined: "+string(is_undefined(psychedPlayerList)))
		
			for (var i = 0; i < ds_list_size(psychedPlayerList); i++)
			{
				psychedPlayerString += psychedPlayerList[|i]
			
				if i <= ds_list_size(psychedPlayerList) - 2
				psychedPlayerString += ", "
				//psychedPlayerString += "WWWWWWWW..., "
			}
			var spacePerLine = 750
		
			//draw_text(800,200,string(string_width(psychedPlayerString)))
		
			if string_width(psychedPlayerString) >= 2*spacePerLine
			draw_set_font(fntPluto10p)
			else if string_width(psychedPlayerString) >= 1*spacePerLine
			draw_set_font(fntPluto12p)
		
			draw_set_valign(fa_top)
			draw_text_ext(room_width/2, textY+25,psychedPlayerString, -1,spacePerLine)
		}
		
		break
	}
		
	case gamePhase.showingScores:
	{
		//show_message("DRAW: show scores")
		//Order based on rank
		var containerTopY = 169
		var containerHeight = 266
		draw_sprite(sprResultsContainer,-1,313,containerTopY) //139
		
		imageRowSpace = 37 //100//90 //assuming pImgWidth 60
			
		var totalPlayers = playerCount
		var playersPerPage = visibleContainerPlayersWithoutScrolling
		playerNameMaxYMovement = imageRowSpace * (totalPlayers-playersPerPage)
		
		if instance_exists(objSliderKnob)
		knobRatio = objSliderKnob.knobRatio
		else
		knobRatio = 0
		
		hostBaseYPos = 159+30 - playerNameMaxYMovement*knobRatio
		
		baseXPos = 341
		
		draw_set_color(c_white)
		
		scoreListIndex = 0
		
		leadingPlayerShortName = ""
		
		gameTied = false
		
		drawCrown = true //draw crowns for the first rank players
		firstRankDrawn = false
		
		for (var i = 0; i < ds_list_size(completeRankOrdersWithNames); i++)
		{
			//show_message("Draw with rank i "+
			
			var currRankPlayerGrid = completeRankOrdersWithNames[|i]
			
			if !firstRankDrawn and ds_grid_height(completeRankOrdersWithNames[|i]) >= 2 //if first rank spot contains more than 2 people, it's a tie
				gameTied = true
			
			for (var j = 0; j < ds_grid_height(currRankPlayerGrid); j++)
			{
				firstRankDrawn = true //if this loop gets executed once, we're done with the first rank
				
				var currPlayerIndex = currRankPlayerGrid[# 0, j]
				if leadingPlayerShortName = "" //assigning the leading name to whoever is found first in the list
					leadingPlayerShortName = players[currPlayerIndex, playerData.pShortName]//currRankPlayerGrid[# 1, j]
				
				scrDrawPlayerProfileImage(25, currPlayerIndex, true)
				
				//safeguard
				if !is_real(pointMap[? players[currPlayerIndex,playerData.pId]]) //= "null" or players[i,playerData.totalPoints] = undefined)
				var ptValue = "0" // at least make the bug more unnoticeable
				else
					var ptValue = string(pointMap[? players[currPlayerIndex,playerData.pId]])
						
				var baseYPos = hostBaseYPos + imageRowSpace*scoreListIndex
			
				if string_length(ptValue) <= 2
				draw_set_font(fntPlutoBoldBig)
				else
				draw_set_font(fntPlutoBoldMedium)
			
				draw_set_halign(fa_center)
				draw_set_valign(fa_middle)
				draw_text(baseXPos+210,baseYPos+5, ptValue)
				//draw_set_color(bgColor)
				
				scoreListIndex += 1
			}

						
			if firstRankDrawn //no crowns for the next ranks
			drawCrown = false 
		}//*/
				
		//OVERLAY

		draw_set_color(bgColor)
		draw_rectangle(0,0,room_width,containerTopY,false) //upper overlay hiding the scrolls
		draw_rectangle(0,containerTopY+containerHeight,room_width,room_height,false) //lower
			
		scrDrawTitleText(currentCategoryName)
		
		if !isHost
		{
			draw_set_font(fntPluto12p)
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_set_color(c_white)
			draw_text(room_width/2,room_height - 90,"Please wait for the host ("+scrFindPlayerNameById(hostId, true)+") to start the next round.")
		}
		
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		draw_set_font(fntPlutoBoldMedium)
		draw_set_color(c_white)
		draw_text(room_width/2,90, "LEADERBOARD")
		
		draw_set_font(fntPluto12p)
		
		if !gameTied //leadingPlayerShortName != "" //sameRankCountPerRank[0] = 1
		draw_text(room_width/2,130,leadingPlayerShortName + " is leading!")
		else
		draw_text(room_width/2,130,"There's a tie for the top spot!")
		
		break
	}
		
} //switch


