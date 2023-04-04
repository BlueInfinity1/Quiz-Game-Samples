/// @description Insert description here
// You can write your code in this editor

draw_set_font(fntBigTitleFont)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

if phase = 0
image_blend = c_white
else
image_blend = c_gray

draw_self()
