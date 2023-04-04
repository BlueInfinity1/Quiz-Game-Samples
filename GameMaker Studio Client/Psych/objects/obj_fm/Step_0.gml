//variables for not scaling, but repositioning stuff
globalvar windowWidth, windowHeight, wRatio, hRatio;

windowWidth = min(display_get_width(),room_width)
windowHeight = min(display_get_height(),room_height)
wRatio = windowWidth/room_width
hRatio = windowHeight/room_height

//fm_step();

//steps += 1


	
//desktop POSITIONING
if (!fm_mobile()) {
	window_center()
	
    /*var base_w = fm_game_width();
    var base_h = fm_game_height();
    //var max_w = display_get_width();
    //var max_h = display_get_height();
    /*var rescale = min(max_w / base_w,max_h / base_h);
    
    if (rescale > global.desktop_scale) rescale = global.desktop_scale;
    
    var out_w = floor(base_w * rescale);
    var out_h = floor(base_h * rescale);
    fm_set_size(out_w, out_h);*/
    /*window_set_position(
        (display_get_width() - base_w) div 2, //out_w
        (display_get_height() - base_h) div 2); //out_h*/
}//*/

/* */
/*  */


//OWN EDIT: Go through the tap room regardless of whether we're on mobile or desktop,
//and this is done in "TapRoom"
// audio init
/*if (room == global.RM_AUDIO) {
   //if (fm_mobile()) {
      if (mouse_check_button_released(mb_left)) {
         //sound_init();
         
         //OWN: We will always enable sound in the beginning
         /*if (mouse_x > room_width / 2) {
            sound_toggle(false);
         }
         room_goto_next();
      }
   //}
   // skip audio room on desktop
   /*else {
      sound_init();
      room_goto_next();
   }
}*/

