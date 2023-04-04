with objGameController
{	
	if isSpectator //normally these buttons get destroyed when we click them, but the spectator can't do that
	{
		with objStatementChoice
		instance_destroy()
	}
	
	phase = gamePhase.viewingAnswers
	
	//scrGenerateFinalAnswerList()
	
	//if isSpectator
	//show_message("start answer viewing (script)")
	
	//generate final answer list
	ds_list_clear(finalAnswerIdList)
	ds_list_add(finalAnswerIdList,"0") //insert the correct answer first
	
	ds_map_clear(guessCountMap)
	ds_list_clear(psychedPlayerList)
	
	//show_message("Build list")
	
	for (var i = 0; i < playerArraySize; i += 1)
	{
		if players[i, playerData.isDead]
		{
			//show_message("generating answer list, player " + string(i) + " is dead")
			continue
		}
		
		//add to the list if this player has not been added yet
		if ds_list_find_index(finalAnswerIdList, players[i, playerData.pId]) = -1
		{
			ds_list_add(finalAnswerIdList, players[i, playerData.pId])
			//if isSpectator
			//show_message("Constructing final answer id list, add "+ players[i, playerData.pId])
		}
	}
	
	//show_message("count guesses")
	//count the guesses each answer received
	for (var i = 0; i < playerArraySize; i += 1)
	{
		if players[i, playerData.isDead]
		continue
		
		var currSelectedGuessId = players[i, playerData.selectedGuessId]
		
		if (is_undefined(guessCountMap[? currSelectedGuessId]))
		guessCountMap[? currSelectedGuessId] = 0
		
		guessCountMap[? currSelectedGuessId] += 1
		
		//if isSpectator
		//show_message(players[i, playerData.pId] + " guessed "+ currSelectedGuessId)
		
		if currSelectedGuessId = playerId
		ds_list_add(psychedPlayerList,players[i, playerData.pShortName])
	}
	
	//show_message("al 1 perform (script)")
	event_perform(ev_alarm,1)
	
}