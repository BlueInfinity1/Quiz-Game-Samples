/// @description Insert description here
// You can write your code in this editor

if (y + sprite_height /*+ 11*/ < objGameController.upmostY)
{
	debugText = "UNCLICKABLE"
	exit
}
else
debugText = ""

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if canBeClicked
	{
		//show_message("Clicked statement choice")
		
		objGameController.selectedGuessId = answerId
		
		//TODO: Move this for when we get the reply back from server?
		objGameController.phase = gamePhase.waitingForGuesses
		
		with objSliderKnob
		instance_destroy()
	
		if playerCount >= visibleContainerPlayersWithoutScrolling
		instance_create_layer(580,209,"Top_Instances",objSliderKnob)
	
		if soundOn
		audio_play_sound(sndButton,1,false)
		
		with objStatementChoice
		instance_destroy()//canBeClicked = false
						
		scrMakeSendDataRequest()
	}
}


