/// @description Insert description here
// You can write your code in this editor

if !canBePressed
exit

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if soundOn
	audio_play_sound(sndButton,1,false)

	objGameController.chosenCategory = objCardConfirmer.category
	
	with objGameController
	{
		scrMakeSendDataRequest() //send chosen category to server
		instance_create_layer(room_width/2,round(room_height*0.85),"Top_Instances",objStartGameButton)
		phase = gamePhase.waitingForPlayers //gamePhase.initializing
	}
	
	with objSliderKnob
	instance_destroy()
	
	with objCardConfirmer
	instance_destroy()
	
	with objCloseButton
	{
		if !isViewingRulesCloseButton
		instance_destroy()
	}
	
	with objCategoryCard
	instance_destroy()
	
	instance_destroy()
	
}