with objGameController
{
	scrDestroyOtherButtons()
	
	if !heartBeatTimerOn //start this if it's not on already to signal that we're alive
	{
		heartBeatTimerStartTime = current_time //initiate heartbeatTimer
		heartBeatTimerOn = true
	}
	
	phase = gamePhase.selectingCategory
	
	//show_message("creating the knob")
	instance_create_layer(room_width - 10, room_height + sprite_get_height(sprSlider),"Instances",objSliderKnob)
	
	for (var i = 0; i < totalCategories; i++)
	{
		var cardXPos = 68+195*(i mod 4)
		var cardYPos = 135+215*(i div 4)
			
		var card = instance_create_layer(cardXPos,cardYPos,"Instances",objCategoryCard)
			
		card.category = i
			
		if i = 0
		card.text = "Word Up!"
		else if i = 1
		{
			card.text = "The Plot Thickens"
			card.drawText = true
		}
		else if i = 2
		card.text = "Poetry"
		else if i = 3
		card.text = "Say My Name"
		else if i = 4
		card.text = "Movie Bluff"
		else if i = 5 
		{
			card.text = "Proverbs"
			card.drawText = true
		}
		else if i = 6
		{
			card.text = "Adults Only"
			card.drawText = true
		}
		else if i = 7 //write the title to the card
		{
			card.text = "Is That a Fact?"
			card.drawText = true
		}
		else if i = 8
		card.text = "It's the Law"
	}
}