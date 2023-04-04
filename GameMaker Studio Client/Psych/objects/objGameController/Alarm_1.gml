/// @description Game logic proceeding 1
// You can write your code in this editor

//main event for checking the phase and doing the correct action

//show_message("al 1")

switch (phase)
{
	case gamePhase.writingStatements:
	{
		//if soundOn
		//audio_play_sound(sndGameStart,1,false)
						
		upmostY = 321//190 //140//70
		
		scrDestroyOtherButtons()
		
		if !isSpectator
		answerField = instance_create_layer(room_width/2,upmostY,"Instances",objStatementField)
				
		//begin polling for readyState
		requestDataToFetch = dataRequest.readyState
		
		with objSliderKnob
		instance_destroy()
		
		if !isSpectator
		instance_create_layer(room_width/2,room_height - 90,"Top_Instances",objReadyButton) //-80 //-55
		
		if triggerRecovery and ownStatementsWritten
		{
			with objReadyButton
			{
				phase = 1
				canBePressed = false
				scrMakeSendDataRequest()
			}
		}
		break;
	}
	
	case gamePhase.guessingStatements:
	{
		//if we get here, then our answer has already been accepted by the server and we can reset this value
		ownStatementsWritten = false
		
		upmostY = 200//130 //120 //160
		upperVeilLowerY = upmostY - round(sprite_get_height(sprStatementChoice)*0.5) - 5//this will hide the buttons that are scrolled up, used in draw event
		gapY = 61//50
		
		if !triggerRecovery
		selectedGuessId = "-1"
			
		var btnCount = 0;
				
		visibleAnswersWithoutScrolling = 6//4
		
		totalAnswers = ds_list_size(shuffleOrderList)
		
		with objSliderKnob //destroy previous knob
		instance_destroy() 
		
		if totalAnswers >= visibleAnswersWithoutScrolling + 1 
		{
			//create a slider
			instance_create_layer(sliderPosX,sliderPosY,"Instances",objSliderKnob)
			//instance_create_layer(0,0,"Instances_Overlay",objHidingOverlay)	
		}
		
		for (var i = 0; i < ds_list_size(shuffleOrderList); i++) //TODO: Create as many choice buttons as there are players + correct answer - your own answer
		{			
			var currPlayerId = shuffleOrderList[|i]
			
			if shuffleOrderList[|i] = playerId //Omit your own answer
			continue
						
			choiceButton[btnCount] = instance_create_layer(room_width/2,upmostY+btnCount*gapY,"Instances",objStatementChoice)
			choiceButton[btnCount].answerId = currPlayerId
			
			if currPlayerId != "0" 
				choiceButton[btnCount].text = string_lower(answerMap[? currPlayerId])
			else //this is the correct answer that no one wrote
				choiceButton[btnCount].text = string_lower(correctAnswer)
						
			choiceButton[btnCount].choiceIndex = btnCount
			choiceButton[btnCount].maxYMovement = (totalAnswers - visibleAnswersWithoutScrolling-2)*gapY + 15
			
			btnCount += 1;
		}
								
		requestDataToFetch = dataRequest.chosenGuess
		
		break;
		
	}
		
	case gamePhase.preparingToShowResult:
	{
		//show_message("al1: preparing to show result")
		
		with objStatementChoice
		canBeClicked = false
		
		readyForNextRound = false //null this here to make sure it doesn't interfere with the previous phases
	
		//since we already have the scores, update them immediately
		
		//show_message("i: "+string(i))
		pointAddedMap = ds_map_create() //ensure that each point only gets added once
		
		for (var i = 0; i < playerArraySize; i++)
		pointAddedMap[? players[i, playerData.pId]] = false 
		
		for (var i = 0; i < playerArraySize; i++)
		{ 
			if players[i, playerData.isDead]
			continue
			
			var currPlayerId = players[i, playerData.pId]
		}
		
		ds_map_destroy(pointAddedMap)
	
		scrMakeSendDataRequest() //NOTE: We null the statement writing readiness status here, as well as the readyForNextRound
		
		//if !triggerRecovery //I don't think this variable is needed here though, as recovery doesn't touch this phase
		//scrMakeRoomDataStoreRequest("scores")
	
		//play drumroll
		if soundOn
		audio_play_sound(sndWaitingForResult,1,false)
	
		//this will show whether your guess was right and play a sound based on that
		//alarm[2] will be called from there to proceed
		
		if !debugModeOn
		alarm[2] = 120 //10 for testing
		else
		alarm[2] = 10
		
		canProceedToAnswerViewingPhase = false //can't proceed before the local timer has run out
		localResultTimerOn = false //make sure this is not on
		localResultTimerStartTime = -1
		
		break;
	}
		
	case gamePhase.showingResults:
	{
		for (var i = 0; i < playerArraySize; i++) //check the score of other players
		{
			//show_message("null readiness for next round")
			players[i, playerData.isReadyForNextRound] = false //null this
		}
		
		if selectedGuessId = "0"
		{
			//players[ownPlayerIndex,playerData.selectedGuessId] = "-1" //null this so you won't think that everyone 
			//is ready as well
				
			if soundOn
			audio_play_sound(sndCorrectAnswer,1,false)
		}
		else
		{		
			if soundOn
			audio_play_sound(sndIncorrectAnswer,1,false)	
		}
		
		localResultTimerOn = true
		localResultTimerStartTime = current_time
		
		//instance_create_layer(room_width/2,room_height - 90,"Top_Instances",objNextButton)
		
		break
	}
	
	case gamePhase.viewingAnswers:
	{
		//if isSpectator
		//show_message("alarm 1 viewing answers") 
		
		/*var _a = debug_get_callstack();
        for (var i = 0; i < array_length_1d(_a); ++i;)
		{
            show_message(_a[i]);
        }*/
		//show_message(debug_get_callstack())
		
		upmostY = 200//130 //120 //160
		upperVeilLowerY = upmostY - round(sprite_get_height(sprStatementChoice)*0.5) - 5//this will hide the buttons that are scrolled up, used in draw event
		gapY = 61//50
		
		if isHost //the host has the "next button" in this phase, so he has to be able to scroll to see 6th one and the ones after that
		visibleAnswersWithoutScrolling = 5//4
		else
		visibleAnswersWithoutScrolling = 6
		
		//if isHost
		totalAnswers = ds_list_size(finalAnswerIdList)
		//else //debug
		//totalAnswers = 5
		
		var btnCount = 0;
		
		with objSliderKnob //destroy previous knob
		instance_destroy() 
		
		if totalAnswers >= visibleAnswersWithoutScrolling + 1 
			instance_create_layer(sliderPosX,sliderPosY,"Instances",objSliderKnob) //create a slider
		
		//show_message("al 1 viewing answers")
		
		/*for (var i = 0; i < ds_list_size(finalAnswerIdList); i += 1) //check the contents
		{
			show_message("final answer list " +string(i) + ": "+string(finalAnswerIdList[|i]))
		}*/
		
		//show_message("Statement chioce objects: "+ string(instance_number(objStatementChoice)))
		
		for (var i = 0; i < ds_list_size(finalAnswerIdList); i++) //TODO: Create as many choice buttons as there are players + correct answer - your own answer
		{
			//show_message("big loop, i: "+string(i))
			
			//DEBUG 
			if i >= ds_list_size(finalAnswerIdList)
			{
				choiceButton[btnCount] = instance_create_layer(room_width/2,upmostY+btnCount*gapY,"Instances",objStatementChoice)
				choiceButton[btnCount].answerId = string(btnCount)
				choiceButton[btnCount].choiceIndex = btnCount
				
				choiceButton[btnCount].maxYMovement = (totalAnswers - visibleAnswersWithoutScrolling)*gapY + 15 //-1
				choiceButton[btnCount].text = string(btnCount)				
				choiceButton[btnCount].image_index = 1
				
				btnCount += 1
				continue
			}//*/
			
			//show_message("Process " +string(i))
			
			var currPlayerId = finalAnswerIdList[|i]
			
			//if isSpectator
			//show_message("Answer viewing, set next choice button to pId: "+ currPlayerId)
									
			choiceButton[btnCount] = instance_create_layer(room_width/2,upmostY+btnCount*gapY,"Instances",objStatementChoice)
			choiceButton[btnCount].answerId = currPlayerId
			
			if currPlayerId != "0" 
			{
				if is_undefined(answerMap[? currPlayerId])
				choiceButton[btnCount].text = "UNDEFINED, FIX"
				else
				{
					//if answerMap[? currPlayerId] = ""
					//show_message("Generating buttons, no answer for "+currPlayerId)
					//show_message("Setting answer")
					choiceButton[btnCount].text = answerMap[? currPlayerId]			
				}
			}
			else //this is the correct answer that no one wrote
			{
				//show_message("correct answer set")
				choiceButton[btnCount].text = correctAnswer
				choiceButton[btnCount].image_index = 1
			}
			
			if is_undefined(guessCountMap[? currPlayerId])
			choiceButton[btnCount].selectionCount = 0
			else
			choiceButton[btnCount].selectionCount = guessCountMap[? currPlayerId]
			
			choiceButton[btnCount].choiceIndex = btnCount
			choiceButton[btnCount].maxYMovement = (totalAnswers - visibleAnswersWithoutScrolling)*gapY + 15 //-1
			
			btnCount += 1;
		}
		
		with objStatementChoice
		canBePressed = false
		
		if isHost
		instance_create_layer(room_width/2,room_height - 40,"Top_Instances",objNextButton)  //-90 orig.
		
		break
	}
	
	case gamePhase.showingScores:
	{
		//show_message("al 1 showing scores")
		
		requestDataToFetch = dataRequest.readyState //begin requesting ready states
				
		with objSliderKnob
		instance_destroy()
		
		if playerCount > visibleContainerPlayersWithoutScrolling
		instance_create_layer(580,209+30,"Top_Instances",objSliderKnob)
		
		with objStatementChoice
		instance_destroy()
		
		for (var i = 0; i < playerArraySize; i++) //check the score of other players
		{
			players[i,playerData.selectedGuessId] = "-1" // null these for the next round
		}
		yourFakeAnswer = "" //at this point, nullify these so the old statements won't get used in the next games
		
		
 		//if !isHost
		//instance_create_layer(room_width/2,room_height - 90,"Top_Instances",objNextRoundButton)
		//else
		if isHost
		{
			instance_create_layer(room_width/2 + 100,room_height - 90,"Top_Instances",objNextRoundButton)
			instance_create_layer(room_width/2 - 100,room_height - 90,"Top_Instances",objEndGameButton)
		}
			
		if triggerRecovery and readyForNextRound
		{
			with objNextRoundButton
			{
				phase = 1
				canBePressed = false
			}
			with objEndGameButton
			{
				if objNextRoundButton.phase = 1 //can't click this button either if next round has been clicked
				{
					pressed = true
					canBePressed = false 
				}
			}
			scrMakeSendDataRequest()
		}
		
		break
	}
	
	//case gamePhase.roundFinished:
	/*{
		
		break
	}*/
	
}