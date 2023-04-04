/// @description Insert description here
// You can write your code in this editor

if !canBePressed
exit

if device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if soundOn
	audio_play_sound(sndButton,1,false)

	if isViewingRulesCloseButton
	{
		objGameController.alarm[8] = 2 //stop viewingRules
	
		with objRulePopUp
		instance_destroy()
		
		with objRuleGotItButton
		instance_destroy()
		
		instance_destroy()
	}
	else
	{
		with objCategoryCard
		alarm[0] = 2 //set canBeClicked = true
	
		with objSliderKnob
		canBeDragged = true
	
		with objCardConfirmer
		instance_destroy()
	
		with objPlayButton
		instance_destroy()
	
		instance_destroy()
	}
}