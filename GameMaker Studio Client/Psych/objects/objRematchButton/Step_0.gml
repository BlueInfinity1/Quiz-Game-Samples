/// @description Insert description here
// You can write your code in this editor

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{

	if !canBePressed
	exit

	if soundOn
	audio_play_sound(sndButton,1,false)

	//with objEndGameButton
	//instance_destroy()

	canBePressed = false
	
	phase = 1
	//sprite_index = sprWaitingButton

	with objGameController
	{
		hostHasStartedGame = false
		requestDataToFetch = dataRequest.readyState
		readyForNextRound = true
		//ownStatementsWritten = false
		scrMakeSendDataRequest()
	
		//sendDataRequest = http_get(requestUrl+"?op=100&roomId="+roomId+"&playerId="+playerId+"&playerName="+playerName+"&isReady=true")
		//phase = gamePhase.waitingForRematch
	}
	//instance_destroy()
}