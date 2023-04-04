/// @description Insert description here
// You can write your code in this editor
draw_set_font(fntBigTitleFont)
draw_set_halign(fa_center)
draw_set_valign(fa_middle)

if phase = 0
{
	sprite_index = sprButtonGreen
	draw_sprite(sprite_index,0,x,y)
	//scrDrawOutlinedText(x,y-3,"Play again",c_white,buttonDarkGreen,outlineW,-1,500)
	draw_text_colour_outline(x,y-3,"Play again",c_white,c_white,1,buttonDarkGreen,buttonDarkGreen,1,3,10,1,1,0)
}
//imgIndex = 0
else
{
	sprite_index = sprButtonGrey
	draw_sprite(sprite_index,0,x,y)
	//scrDrawOutlinedText(x,y-3,"Waiting...",c_white,buttonDarkGrey,outlineW,-1,500)
	draw_text_colour_outline(x,y-3,"Waiting...",c_white,c_white,1,buttonDarkGrey,buttonDarkGrey,1,3,20,1,1,0)
}