 /// @description Game Logic proceeding 2
// You can write your code in this editor

//if isSpectator
//show_message("alarm 2 for spectator")

if phase = gamePhase.preparingToShowResult
{
	phase = gamePhase.showingResults
	event_perform(ev_alarm,1)
}
else if phase = gamePhase.showingResults
{
	//send our score to server to be used for back-up cases if another player joins later on
	//scrMakeSendDataRequest()
}
else
{
	//show_message("alarm 2, perform alarm 1")
	event_perform(ev_alarm,1)
}
/*else if phase = gamePhase.showingScores
{
	
}*/