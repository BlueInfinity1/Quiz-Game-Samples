//THIS WILL BE USED IF A PLAYER JOINS IN THE SCOREBOARD PHASE

with objGameController
{
	scrStartScoreboardPhase()

	with objSliderKnob
	instance_destroy()
		
	if playerCount > visibleContainerPlayersWithoutScrolling
	instance_create_layer(580,209+30,"Top_Instances",objSliderKnob)
}//*/