if !gamePrepared //this will kick off the phase system
{
	gameJustOpened = false //if we reach this phase, some time has passed since the game has been opened
			
	ownStatementsWritten = false

	//null these
	for (var i = 0; i < playerArraySize; i++)
	{
		players[i,playerData.selectedGuessId] = "-1"
		pointMap[? players[i,playerData.pId]] = 0
		//scoreIncreasedMap[? players[i,playerData.pId]] = false
		players[i,playerData.statementsWritten] = false
		players[i,playerData.isReadyForNextRound] = false
		players[i,playerData.isDead] = false
	}
			
	//show_message("Prepare game, change phase to writing")
	phase = gamePhase.writingStatements
		
	event_perform(ev_alarm,1)
			
	gamePrepared = true
}