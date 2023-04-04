// config
//global.RM_AUDIO = InitRoom;

//show_message("fm create")
global.RM_FLIP = InitRoom;

global.desktop_scale = 1.0; // desktop scale multiplier; 0.75 = 75% original resolution 
global.force_xratio = true; // reduce portrait-mode pillarboxing
//global.sitelock_enabled = false; // protect your game from theft (configure below)

// init
//fm_start();
//fm_scale();
//application_surface_enable(false); //*/

device_mouse_dbclick_enable(false);

//room_set_width(MainRoom, display_get_width())
//room_set_height(MainRoom, display_get_height())
//window_set_size(display_get_width(),display_get_height())

//room_goto(MainRoom)

// sitelock
/*var valid = false;

if (global.sitelock_enabled) {
   var valid_domains = ds_list_create();
   
   ds_list_add(valid_domains,"127.0.0.1"); // localhost (recommended)
   ds_list_add(valid_domains,"example.com");
   // whitelist domains here...
   // whitelist domains here...
   // whitelist domains here...
   
   var site = url_get_domain();
   
   for (var i = 0; i < ds_list_size(valid_domains); i++) {
      if (string_count(ds_list_find_value(valid_domains,i),site) > 0) {
         valid = true;
         break;
      }
   }
   
   ds_list_destroy(valid_domains);
   
   // sitelock triggered
   if (!valid) {
      show_message("This game is hosted on an invalid domain: " + site);
   }
}
else valid = true;*/

// next room
//if (valid) room_goto(global.RM_AUDIO);

//room_goto(global.RM_AUDIO);

/* */
/*  */
