/// @description Insert description here
// You can write your code in this editor

draw_sprite(sprite_index,category,x,y)

//if collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
//draw_rectangle(x-20,y-20,x+20,y+20,false)

draw_set_color(c_white)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_font(fntMediumTitleFont)

if drawText
draw_text_ext(x + sprite_get_width(sprCategoryCard)*0.5,y + sprite_get_height(sprCategoryCard)*0.5,text,-1,160)

