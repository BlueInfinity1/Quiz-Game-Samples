/// @description Insert description here
// You can write your code in this editor

if !canBeClicked
exit

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) and 
collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if soundOn
	audio_play_sound(sndButton,1,false)
	
	with objCategoryCard
	canBeClicked = false
	
	with objSliderKnob
	canBeDragged = false
	
	confirmer = instance_create_layer(room_width/2, room_height/2,"Top_Instances", objCardConfirmer)
	confirmer.categoryName = text
	confirmer.category = category

	closeButton = instance_create_layer(593, 107, "Top_Instances", objCloseButton)
	closeButton.image_xscale = 3
	closeButton.image_yscale = 3
	
	startButton = instance_create_layer(450, 435, "Top_Instances", objPlayButton)
	startButton.image_xscale = 20
	startButton.image_yscale = 7
}