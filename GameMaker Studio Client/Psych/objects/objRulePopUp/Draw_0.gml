/// @description Insert description here
// You can write your code in this editor

draw_set_alpha(0.7)
draw_set_color(c_black)
draw_rectangle(0,0,room_width,room_height,false)

draw_set_alpha(1)

draw_sprite_ext(sprRulePopUpBg,0,room_width/2,room_height/2,xScale,yScale,0,c_white,1)

//scrDrawTitleText("Psych!")
		
draw_sprite(sprGameRulesText,0,room_width/2,102)
		
draw_set_color(c_white)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_font(fntPluto12p)
		
var textColX = 362 - 80
var iconColX = textColX - 25 - 54
		
var columnWidth = 240 + 160
//var rowSpace = 35
//var iconYPos = 120
//var textYOff = 70
		
draw_sprite(sprRulesCards,0,iconColX,140)
draw_sprite(sprRulesCards,1,iconColX,240)
draw_sprite(sprRulesCards,2,iconColX,340)
		
draw_text_ext(textColX, 140,"You will be presented a question for which you need to come up with a fake answer. Try to come up with something that the others would mistake for the actual correct answer!",-1,columnWidth)
draw_text_ext(textColX, 240,"Everyone's answers will be listed and everyone gets to pick an answer they think is the real answer to the question.",-1,columnWidth)
draw_text_ext(textColX, 340,"The correct answer and everyone's picks will be revealed, and you score points selecting the real answer, as well as getting others to pick the fake answer you wrote.",-1,columnWidth)