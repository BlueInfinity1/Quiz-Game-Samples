var allReady = true //by default
			
//show_message("Check readiness")
			
for (var i = 0; i < playerArraySize; i++)
{
	if players[i,playerData.isDead]
	{
		continue //if our statements are being guessed, we're ready
	}
	
	if (phase = gamePhase.waitingForStatements and !players[i, playerData.statementsWritten])
	or (phase = gamePhase.waitingForGuesses and players[i, playerData.selectedGuessId] = "-1") //the guessingTarget can't break this
	or (phase = gamePhase.showingResults and !answerMap[? playerData.pId] = "") //no non-empty answers
	{
		/*if phase = gamePhase.waitingForGuesses
		show_message("For player " +players[i, playerData.pId] + ", selected guess id is "
			+players[i, playerData.selectedGuessId] + ", so not ready") //*/
		allReady = false
	}

}

return allReady

