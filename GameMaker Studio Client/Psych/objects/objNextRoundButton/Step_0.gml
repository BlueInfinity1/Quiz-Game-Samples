/// @description Insert description here
// You can write your code in this editor

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if !canBePressed
	exit

	canBePressed = false
	phase = 1
	
	with objEndGameButton
	{
		pressed = true //make it so that this button is greyed out and can't be pressed
		canBePressed = false
	}
	
	//show_message("Next round btn step, can be pressed")

	if soundOn
	audio_play_sound(sndButton,1,false)

	with objGameController
	{
		readyForScores = false
		readyForNextRound = true
		
		//show_message("Proceed to send data")
		scrMakeSendDataRequest()
		//sendDataRequest = http_get(requestUrl+"?op=100&roomId="+roomId+"&playerId="+playerId+"&playerName="+playerName+"&isReady=true")
		//alarm[4] = pollingInterval //begin checking the ready states of others
	
	}

	
	//sprite_index = sprWaitingButton
}