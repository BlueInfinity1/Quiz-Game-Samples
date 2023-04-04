/// @description Insert description here
// You can write your code in this editor
//gpu_set_blendmode(bm_add)

var answerTextY = y + 1
draw_set_valign(fa_middle)
draw_set_halign(fa_center)
draw_set_color(c_white)

if objGameController.phase <= gamePhase.waitingForGuesses
{
	if objGameController.selectedGuessId = answerId
	image_blend = c_gray //c_orange
	else
	image_blend = c_white
}
else if objGameController.phase = gamePhase.viewingAnswers
{
	//show_message("statement choice view answer phase")
	//Draw the player icons. IDEA: use with objGameController scrPlayerDraw(), but I'm not sure whether
	//this applies the depths correctly? Should work!
	if image_index = 0 
	{
		draw_set_font(fntStandardFont)
		draw_set_valign(fa_middle)
		draw_set_halign(fa_right)
		draw_set_color(c_white)
		
		draw_text(x - round(sprite_width/2) + pImgOffsetX, y + pImgOffsetY, scrFindPlayerNameById(answerId,true))
		
		/*objGameController.tempAnswerId = answerId
		objGameController.tempChoiceObject = id
		
		with objGameController
		{
			//draw_sprite(sprPlaceholderImage35p,0,x - round(sprite_width/2) - 50, y - 18)
			scrDrawPlayerProfileImage(35, scrFindPlayerIndexById(tempAnswerId),false, 
				tempChoiceObject.x - round(tempChoiceObject.sprite_width/2) + tempChoiceObject.pImgOffsetX, 
				tempChoiceObject.y + tempChoiceObject.pImgOffsetY)
		}*/
	}
	draw_set_halign(fa_center)
	
	draw_set_font(fntPlutoBoldBig)
	draw_text(x + round(sprite_width/2) + 50,y-5,selectionCount)
	draw_set_font(fntPluto10p)
	draw_text(x + round(sprite_width/2) + 50,y+12,"TIMES")
}

var xScale = 1//0.9

draw_sprite_ext(sprite_index,image_index,x,y,xScale,1/*0.65*/,0,image_blend,1) //changed image_yscale

draw_set_font(fntStandardFont)
draw_set_color(c_white)

var maxTextWidth = 490 //650*0.9 //650

//text = //"Grandma's Dead: Breaking Bad News with Baby AnimalsGrandma's Dead: Breaking Bad News with Baby Anima"

textWidth = string_width(text)

if image_index = 1 //this is the correct answer
{
	if textWidth >= maxTextWidth*2
	draw_set_font(fntPluto10p)
	else
	draw_set_font(fntPluto12p)
	
	draw_text(x,y - 12,"The Real Answer")
	answerTextY = y + 12
}

if textWidth >= maxTextWidth*2
draw_set_font(fntPluto10p)
else if textWidth >= maxTextWidth
draw_set_font(fntPluto12p)
else
draw_set_font(fntStandardFont)
	

textToDisplay = string_wordwrap_width(text, maxTextWidth,"\n", true)

draw_text(x,answerTextY,textToDisplay)//-1,) //left align position: round(sprite_width*0.46)

