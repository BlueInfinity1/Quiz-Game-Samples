/// @description Insert description here
// You can write your code in this editor

//DEBUG
if device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if !canBePressed
	exit

	if soundOn
	audio_play_sound(sndButton,1,false)

	canBePressed = false
	
	objGameController.alarm[8] = 2 //stop viewingRules
	
	with objRulePopUp
	instance_destroy()

	with objGameController.ruleCloseButton
	instance_destroy()
		
	
	
	instance_destroy()
}