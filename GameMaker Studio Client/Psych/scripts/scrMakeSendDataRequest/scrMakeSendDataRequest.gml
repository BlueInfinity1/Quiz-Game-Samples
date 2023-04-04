///scrMakeSendDataRequest()

//argument0 - "true" or "false" (isReady)
//[/argument1 - "true" or "false" (isReadyForNextRound)]
//"true" or "false" (hasStartedGame) [Only available for hosts]

with objGameController
{
	if !canSendOwnData //spectators can't send their own data. Can only send when the spectator status is lifted
	//when more space is available or a round ends
	exit
	
	//show_message("start send data req")
	
	if isHost
	{
		var hostString = "true"
		
		if hostHasStartedGame
		var hasStartedGameString = "true"
		else
		var hasStartedGameString = "false"
		
		if hostHasEndedGame
		var hasEndedGameString = "true"
		else
		var hasEndedGameString = "false"
		
		//show_message("We're host, so we'll send data with hasStartedGame: " + hasStartedGameString)
		
	}
	else
	{
		var hostString = "false"
		var hasStartedGameString = "false"
		var hasEndedGameString = "false"
	}

	if ownStatementsWritten//argument[0] //this is for being ready with writing statements
	var isReadyString = "true"
	else
	var isReadyString = "false"
	
	if isHost and readyForScores
	var isReadyForScoresString = "true"
	else
	var isReadyForScoresString = "false"
	
	if readyForNextRound
	var isReadyForNextRoundString = "true"
	else
	var isReadyForNextRoundString = "false"
	
	if !successfullySentPlayerDataOnce
	var firstSendString = "true"
	else
	var firstSendString = "false"
	
	if phase = gamePhase.guessingStatements
	{
		if !instance_exists(objReadyButton)
		var chosenGuessString = string(selectedGuessId)
		else
		{
			if !objReadyButton.isReady
			var chosenGuessString = "-1"
			else
			var chosenGuessString = string(selectedGuessId)
		}
	}
	else
	var chosenGuessString = string(selectedGuessId)
	
	
	//show_message("Send with chosenguess string: " +chosenGuessString)
	
	//show_message("Proceed to send player data msg")
	
	//show_message(hasStartedGameString)
	
	
	var requestId = scrAddWebsocketRequest(100)
	lastRequestTimes[100] = current_time
	
	//\"roundNumber\": "+string(guessingTargetIndex)+",
	
	
	playerDataStoreMessage =
	"{\"action\": \"message\", \"op\": 100, \"requestId\": \"" +requestId+"\", \"roomId\": \""+roomId+"\", \"sessionId\": \""+sessionId+"\", "
	+"\"playerId\": \""+playerId+"\", \"playerName\": \""+playerName+"\", \"playerImage\": \""+imageUrl+"\", "
	+"\"chosenGuess\": \""+chosenGuessString+"\", \"writtenAnswer\": \""+yourFakeAnswer+"\", "
	+"\"isHost\": "+hostString+", \"hasStartedGame\":" +hasStartedGameString + ", \"hasEndedGame\":" +hasEndedGameString+", "
	+"\"chosenCategory\": " +string(chosenCategory) + ", "
	+"\"isReadyForScores\": "+isReadyForScoresString+", "
	+"\"isReadyForNextRound\": "+isReadyForNextRoundString+", "
	+"\"isReadyForGuessing\": "+isReadyString+", "
	+"\"isFirstSend\": "+firstSendString
	+"}"
	
	//if debugModeOn and phase = gamePhase.showingScores
	//show_message("Sent data to server: hasEndedGame = "+string(hasEndedGameString))
	
	//show_message("101: Sent the following fakeAnswer to server "+imageUrl)
	
	//if phase = gamePhase.showingScores
	
	//show_message(chosenGuessString)
	//show_message(yourFakeAnswer)
	//show_message("chosenCategory")
	
	/*show_message(hostString)
	show_message(hasStartedGameString)
	show_message(hasEndedGameString)
	show_message(isReadyForScoresString)
	show_message(isReadyString)
	show_message(firstSendString)*/
	
	//show_message("player data store message: ")
	if debugPopUpsOn
	show_message(playerDataStoreMessage)
	
	canAcceptPlayerDataPushes = true
	
	web_socket_send(0,playerDataStoreMessage)
}

	