/// @description Insert description here
// You can write your code in this editor

x = room_width/2 + round(windowWidth*0.5) - 60//*wRatio
y = room_height/2 + round(windowHeight*0.5) - 25//*hRatio

//draw_text(x,y-30,string(60*wRatio)

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	with objGameController
	{
		forcedRulePopUpShown = true // if you press this yourself, there's no need to force it to be shown
	}
	
	if soundOn
	audio_play_sound(sndButton,1,false)
	
	scrOpenRulePopUp()
}