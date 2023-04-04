var itemList = argument0

//show_message("HANDLE: item list not defined: "+string(is_undefined(itemList)))

if itemList != undefined
{
	var playerItemCount = ds_list_size(itemList)
						
	playerArraySize = playerItemCount
	
	prevPlayerCount = playerCount
	showTooManyPlayersMessage = false //by default
							
	var currentPlayerMap;
	
	//hostHasJoined = false // by default
	
	var alivePlayerCount = 0
	
	for (var i = 0; i < playerItemCount; i++) //only read the first players, even if we have more
	{
		//show_message("i: "+string(alivePlayerCount) + ", alivePlayerCount: "+string(alivePlayerCount))
		
		if alivePlayerCount = maxPlayers //we've already read a max number of players, so get out of here
		//but then again, we should not be here, as the system should only allow [maxPlayers] number of alive players
		//at a time
		break
		
		
		
		currentPlayerMap = ds_list_find_value(itemList,i)
		//show_message("currentPlayerMap is")
		//show_message(currentPlayerMap)
		if currentPlayerMap != undefined 
		{			
			alivePlayerCount += 1
			
			//if we're past the phases where more players can join in, do not read new player data (we presume that new players
			//have a round number of -1
			if !(phase = gamePhase.showingRules or phase = gamePhase.initializing or phase = gamePhase.waitingForPlayers 
			or phase = gamePhase.writingStatements or phase = gamePhase.waitingForStatements) and
				ds_map_find_value(currentPlayerMap,"roundNumber") = "-1" and !triggerRecovery //in the recovery phase, we will have to read our own data
			continue
								
			initialDataAboutOthersFetched = true
			
			players[i, playerData.isDead] = false //if we're able to get this data, this player can't be passive,
			//since passive clients are not returned by 101
			
			var currPlayerId = ds_map_find_value(currentPlayerMap,"playerId")
			
			players[i, playerData.pId] = currPlayerId
			players[i, playerData.pName] = decodeURIString(ds_map_find_value(currentPlayerMap,"playerName"))
			pointMap [? currPlayerId] = currentPlayerMap[? "points"]
			
			if is_undefined(pointMap[? currPlayerId])
			pointMap[? currPlayerId] = 0 
			
			/*var tempIsHost = currentPlayerMap[? "isHost"]
			
			if hostId = "" and tempIsHost 
				hostId = players[i, playerData.pId]
				
			if tempIsHost
			hostHasJoined = true*/
			
			
			
			if triggerRecovery //if we need to trigger recovery, then get every possible data about this player
			{
				//show_message("trigger recovery, we're fetching all data for " +string(i))//"+string(requestDataToFetch))
				//players[i, playerData.totalPoints] 
				pointMap [? currPlayerId] = currentPlayerMap[? "points"]
				
				if is_undefined(pointMap [? currPlayerId])
				pointMap[? currPlayerId] = 0
				//players[i, playerData.scoreIncreased] 
				//scoreIncreasedMap[? currPlayerId] = currentPlayerMap[? "scoreIncreased"]
				
				//answerMap[? currPlayerId] = ds_map_find_value(currentPlayerMap,"answer")
				//answers gotten from the room now
				
				//show_message("Read the answer map in recovery:")
				//show_message(answerMap[? currPlayerId])
				//players[i, playerData.trueStatement1] = ds_map_find_value(currentPlayerMap,"truth1")
				//players[i, playerData.trueStatement2] = ds_map_find_value(currentPlayerMap,"truth2")
				//players[i, playerData.falseStatement] = ds_map_find_value(currentPlayerMap,"lie")
				players[i, playerData.selectedGuessId] = ds_map_find_value(currentPlayerMap,"chosenGuess")
				
				if currentPlayerMap[? "isReadyForGuessing"]
				players[i, playerData.statementsWritten] = true
				else
				players[i, playerData.statementsWritten] = false
				
				if currentPlayerMap[? "isReadyForNextRound"]
				players[i, playerData.isReadyForNextRound] = true
				else
				players[i, playerData.isReadyForNextRound] = false
				
				if players[i, playerData.pId] = playerId
				{
					readyForNextRound = players[i, playerData.isReadyForNextRound]
					selectedGuessId = players[i, playerData.selectedGuessId]
					ownStatementsWritten = players[i, playerData.statementsWritten]
				}
				
			}
			
			var tempPlayerId = players[i, playerData.pId]
			
			//show_message("imageRequest for "+tempPlayerId+ " is undefined: " 
				//+ string(is_undefined(ds_map_find_value(imageRequests,tempPlayerId))))
				
			if is_undefined(ds_map_find_value(imageRequests,tempPlayerId))
			{
				players[i, playerData.pImageUrl] = ds_map_find_value(currentPlayerMap,"playerImage")
				
				//show_message("pImageUrl is undefined"+string(players[i, playerData.pImageUrl] = undefined))
				//show_message("pImageUrl is null"+string(players[i, playerData.pImageUrl] = "null"))
					
				if players[i, playerData.pImageUrl] = undefined
				players[i, playerData.pImageUrl] = "null"
						
				if players[i, playerData.pImageUrl] = "null"
				{
					ds_map_add(playerImages,tempPlayerId,sprPlaceholderImage)
					//show_message("Use default iamge")
				}
				//load the image and make it a separate sprite if we haven't started the load already
				else if is_undefined(ds_map_find_value(playerImages, tempPlayerId)) 
				{
					//var imageName = string_replace(currPlayerImageUrl,"letsdive.io/avatar/","")
					//show_message("Make image request for player " +string(i) + " with url "+ string(players[i, playerData.pImageUrl]))
					scrMakeImageRequest(tempPlayerId,players[i, playerData.pImageUrl])
				}
			}
								
								
			//switch (requestDataToFetch)
			{
				//case dataRequest.basicInfo: //UNUSED
					//break
				
				//case dataRequest.chosenGuess:
					//show_message("data fetch: chosen guess")
					
					players[i, playerData.selectedGuessId] = ds_map_find_value(currentPlayerMap,"chosenGuess")
					
					//break
									
				//case dataRequest.readyState:
									
					if ds_map_find_value(currentPlayerMap,"isReadyForGuessing") = 1
					isWritingReadyBoolean = true
					else
						isWritingReadyBoolean = false
				
				
					if phase = gamePhase.writingStatements or phase = gamePhase.waitingForStatements
					{
						//show_message("Get ready state for writing statements: "+string(isReadyBoolean))
						players[i, playerData.statementsWritten] = isWritingReadyBoolean
						//no need to check round number here
						
						if isWritingReadyBoolean //also fetch the statements at the same time
						{
							//answerMap[? currPlayerId] = ds_map_find_value(currentPlayerMap,"answer")
						}
					}
					else if phase = gamePhase.showingScores or phase = gamePhase.waitingForRematch
					{		
						if ds_map_find_value(currentPlayerMap,"isReadyForNextRound") = 1
							isReadyBoolean = true
						else
							isReadyBoolean = false
							
						players[i, playerData.isReadyForNextRound] = isReadyBoolean
					}
					//break
			} //switch (requestDataToFetch)	
			ds_map_destroy(currentPlayerMap)
		} //if currentPlayerMap is not undefined
	} //for
	ds_list_destroy(itemList)
} //itemList != undefined

playerCount = alivePlayerCount	//NOTE: There shouldn't be a need to do this

if phase = gamePhase.showingScores and (rebuildScoreboard or playerCount != prevPlayerCount)
{
	//show_message("Rebuild scores")
	scrRecheckScoreboard() //if we've got new players who just joined or left, rebuild the scoreboard
	rebuildScoreboard = false
}

//it's still possible to update ownPlayerIndex during the start phase, but not before that, or if we need to recover
if phase <= gamePhase.waitingForStatements or triggerRecovery //ownPlayerIndex = -1 //if this hasn't been set yet, set it now
{	
	for (var i = 0; i < playerCount; i += 1) //check whether we're in the list of newly fetched ACTIVE PLAYERS
	{
		if players[i,playerData.pId] = ownId
		{
			ownPlayerIndex = i
			break
		}	
	}
}	

//This can happen if we are disconnected due to passivity

//show_message("Handle: before exits")

//NOTE: This will restart the game if our id is not found. The restart should happen in the script itself, not here
if !isSpectator and scrFindPlayerIndexById(playerId, playerCount) = -1
{
	//show_message("Own data not found, restart game")
	game_restart()
	exit
}

//if this happens, someone must've disconnected			
/*if phase >= gamePhase.writingStatements and playerCount < prevPlayerCount
{
	var displayMsg = ""
	var mustExit = false
						
	if playerCount = 1
	{
		var displayMsg = "A player has disconnected. Only one player left, so the game will be restarted."
		canDisplayDisconnectMessage = false //we don't want to display an overlapping message
		scrHandlePlayerDisconnection()
		canDisplayDisconnectMessage = true 
		mustExit = true //don't continue the game
	}
	else if playerCount < prevPlayerCount
	{
		//show_message("Cont with fewer players, prev: "+string(prevPlayerCount) + ", curr: "+string(playerCount))
		var displayMsg = "A player has disconnected. The game will continue with fewer players."
		
		scrMakeSendDataRequest() //if someone has left, we'll have to check whether the room phase should be updated
		//this is done by sending our own data to the server so that the server can trigger the update script
		
		if phase = gamePhase.showingScores
		scrSortRankOrder()
		
	}
	
	scrDisplayNotification(displayMsg,2,60,60)
	
	if mustExit
	exit	
}*/
				
if triggerRecovery and !checkNeedToRecover
exit

//show_message("Handle: AFTER exits")		

if isSpectator
{
	//show_message("spectator room data request")
	if phase = gamePhase.initializing
	phase = gamePhase.waitingForPlayers
	
	scrMakeRoomDataGetRequest()
}
else if phase = gamePhase.initializing //once we have some player data, we're initialized
{
	//show_message("after data fetch: init")
	
	if !showTooManyPlayersMessage
	{	
		phase = gamePhase.waitingForPlayers
			
		//LOGIC
		if !isHost and hostId != ""
		scrMakeRoomDataGetRequest()
		//scrMakeGameStartedQuery() //CHANGED
			
		initiallyPrepared = true
		
		scrDestroyOtherButtons() //safety measure
		
		//create a slider bar
		instance_create_layer(580,209,"Top_Instances",objSliderKnob)
		
		
			
		//show_message("create the start game button, isHost: "+string(isHost))
			
		if isHost
		{
			if currentCategoryId = -1 //This is the category id that was fetched from the roomData
				scrStartCategorySelectionPhase()
			else
			{
				chosenCategory = currentCategoryId
				instance_create_layer(room_width/2,round(room_height*0.85),"Top_Instances",objStartGameButton)
			}
		}
	}
			
}
else if phase = gamePhase.waitingForPlayers
{
	if instance_exists(objStartGameButton) //if we're the host, update start Game button status
	{
		with objStartGameButton
		{
			if playerArraySize >= 2
			canStartGame = true
			else
			canStartGame = false
		}
	}
}
else if phase = gamePhase.waitingForStatements
{
	if scrCheckPlayerReadiness() //we ensure that everything is ready
	{
		gotAllDataForNextPhase = true
		scrMakeRoomDataGetRequest() //get room data to check gamePhase
	}

}
else if phase = gamePhase.waitingForGuesses//guessingStatements
{
	//show_message("Handle 101 response, waiting for guesses")
	if scrCheckPlayerReadiness()
	{
		gotAllDataForNextPhase = true
		scrMakeRoomDataGetRequest() //get room data to check gamePhase
	}
}
else if phase = gamePhase.showingResults
{
	/*if scrCheckPlayerReadiness()
	{
		show_message("Showing results, start answer view")
		gotAllDataForNextPhase = true //not really used I think
		scrDestroyOtherButtons()
		scrStartAnswerViewingPhase()
	}*/
}
else if phase = gamePhase.viewingAnswers
{
	//show_message("Handle player data: data: " +string(gotAllDataForNextPhase))
	//if canProceedToScoresPhase
	{
		gotAllDataForNextPhase = true
		scrMakeRoomDataGetRequest() //get room data to check gamePhase
	}
}
else if phase = gamePhase.showingScores 
{
	//if scrCheckPlayerReadiness()
	{
		gotAllDataForNextPhase = true
		scrMakeRoomDataGetRequest() //get room data to check gamePhase
	}
}	