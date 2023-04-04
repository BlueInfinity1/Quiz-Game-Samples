if phase = gamePhase.waitingForPlayers
{
	if currentCategoryId = -1 //This is the category id that was fetched from the roomData
		scrStartCategorySelectionPhase()
	else
	{
		chosenCategory = currentCategoryId
		instance_create_layer(room_width/2,round(room_height*0.85),"Top_Instances",objStartGameButton)
	}
}
else if phase = gamePhase.viewingAnswers
instance_create_layer(room_width/2,room_height - 40,"Top_Instances",objNextButton)
else if phase = gamePhase.showingScores
{
	instance_create_layer(room_width/2 + 100,room_height - 90,"Top_Instances",objNextRoundButton)
	instance_create_layer(room_width/2 - 100,room_height - 90,"Top_Instances",objEndGameButton)
}