/// @description Insert description here
// You can write your code in this editor

draw_set_alpha(0.7)
draw_set_color(c_black)
draw_rectangle(0,0,room_width,room_height,false)

draw_set_alpha(1)


draw_sprite(sprCategoryConfirmer,0,x,y)

draw_set_color(c_white)
draw_set_halign(fa_center)		
draw_set_font(fntMediumTitleFont)
draw_set_valign(fa_middle)

draw_text_ext(x,y-100,categoryName,-1,212)

draw_set_font(fntSmallFont)
draw_text_ext(x,y+10,"Sample \""+categoryName+"\" with this teaser deck! Write convincing fake answers that the others will mistake for the real one!",-1,212)