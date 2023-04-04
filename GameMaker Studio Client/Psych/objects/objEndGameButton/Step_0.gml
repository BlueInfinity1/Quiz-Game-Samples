/// @description Insert description here
// You can write your code in this editor

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if !canBePressed
	exit

	if soundOn
	audio_play_sound(sndButton,1,false)

	//canStartGame = true

	with objNextRoundButton
	{
		canBePressed = false
		phase = 1
	}

	canBePressed = false
	pressed = true

	with objGameController
	{
		readyForScores = false
		hostHasEndedGame = true
		ownStatementsWritten = false
		//show_message("Make send data request")
		chosenCategory = -1
	}
	scrMakeSendDataRequest()
	
	//with objGameController
	//show_message("player data store message: "+ playerDataStoreMessage)

	//wait a bit to give others time to get the request
	alarm[0] = 15

	//send a message that the host is ready, others will poll this status
}