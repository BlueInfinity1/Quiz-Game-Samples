/// @description Insert description here
// You can write your code in this editor

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if !canBePressed
	exit

	if soundOn
	audio_play_sound(sndButton,1,false)

	phase = 1 //change the button image_blend
	canBePressed = false

	with objGameController
	{
		if phase = gamePhase.showingResults
		{
			gotAllDataForNextPhase = false
			canProceedToAnswerViewingPhase = true
			scrMakeGetPlayerDataRequest() //request up-to-date answer data to get the guess counts right
			
			with objNextButton
			canBePressed = false
			
		}	
		else if phase = gamePhase.viewingAnswers
		{			
			//TODO: Send data to server as host
			readyForScores = true //<- Make sure to write this string and init variable
			//gotAllDataForNextPhase = false
			
			//show_message("send data")
			
			scrMakeSendDataRequest()
			
			alarm[3] = 15 //move to scoreboard phase
			
			
		}
	}
	//show_message("Destroy this button")
}