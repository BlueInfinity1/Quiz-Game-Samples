/// @description Insert description here
// You can write your code in this editor

//TODO: Display cursor

if activeForWriting
{
	blendColor = c_orange
}
else
blendColor = c_white


draw_sprite_ext(sprite_index,0,x,y,image_xscale,image_yscale,0,blendColor,1)

//draw_sprite(sprStatementChoice,0,x,y-sprite_height*0.5)

draw_set_font(fntStandardFont)
draw_set_color(bgColor)
draw_set_valign(fa_middle)

var baseTextWidth = 260

var maxTextWidth = baseTextWidth//325

if containerText = "" and !activeForWriting
{
	draw_set_halign(fa_center)
	draw_set_color(c_silver)
	
	draw_text_ext(x,y,"Write a fake answer to the above question here!\n\nTry to come up with an answer that you think the others will mistake"+
		" for the correct one!",-1,maxTextWidth) //"Write your fake answer here!"
}
else if activeForWriting
{
	draw_set_halign(fa_center) //left
	
	maxTextWidth = baseTextWidth-7 //330 - cursorStringWidth
	
	lastLineBreakPos = 0
	containerTextToDisplay = string_wordwrap_width(containerText, maxTextWidth,"\n", true)
	
	var singleLineHeight = 25
	
	containerTextWidth = string_width(containerTextToDisplay)//string_width_ext(containerText,-1,maxTextWidth)
	
	containerTextHeight = string_height(containerTextToDisplay)
	//max(singleLineHeight,string_height_ext(containerText,-1,maxTextWidth))
	
	var cursorString = "|"
	//cursorStringWidth = string_width(cursorString)
	
	if cursorTimerVisible //and string_length(containerText) = 0//string_length(containerText) < maxTextLength
	var cursorText = cursorString
	else
	var cursorText = ""
	
	var totalLines = string_count("\n",containerTextToDisplay) + 1
	
	//x- round(sprite_width*0.46)
	
	draw_text(x,y,containerTextToDisplay)// + cursorString)
	
	if totalLines <= 1
	{
		var cursorXOff = round(containerTextWidth*0.5)
		var cursorYOff = 0
	}
	else
	{
		//draw_set_color(c_white)
		var lastLineBreakPos = strLastIndexOf("\n", containerTextToDisplay) //get the last line break pos of the container text
		//draw_text(800,100,"LLBP: "+string(lastLineBreakPos))
		var lastLine = string_copy(containerTextToDisplay,lastLineBreakPos+2,string_length(containerTextToDisplay) - lastLineBreakPos - 1)
		
		//draw_text(300,50,lastLine)
		var cursorXOff = round(string_width(lastLine)*0.5)
		var cursorYOff = singleLineHeight*(totalLines-1)*0.5
	}
	
	draw_set_color(bgColor)
	
	draw_text(x + cursorXOff + 2, y + cursorYOff,cursorText)
	
	//draw_text(x,y-100,string(containerTextWidth) + " " +string(containerTextHeight))
	
	/*if containerTextHeight != prevContainerTextHeight //there has been a line break
	{
		lastCharIndexBeforeLineBreak = string_length(containerText) - 1
	}
	
	if containerTextHeight > singleLineHeight + 1
	{
		currentLine = string_copy(containerText,lastCharIndexBeforeLineBreak,
			string_length(containerText) -lastCharIndexBeforeLineBreak) 
			
		//draw_text(x,y-50,string(currentLine))
		currentLineWidth = string_width(currentLine)
	}
	else
	currentLineWidth = containerTextWidth
	
	currentLineWidth += whiteSpaceCountAtEnd*6 //6 is white space width*/
	
	 //-1,maxTextWidth)
	
	//var bonusWidth = 0
	
	/*if string_char_at(containerText,string_length(containerText)) = " "
	{
		//draw_text(x,y-50,"last char is white space")
		var bonusWidth = string_width(" ")
	}*/
	
	//var newLineString = ""//"\n"
	
	/*draw_text(x,y+50,"a+b: "+string(string_height_ext(containerText+cursorString,-1,maxTextWidth)) + " a: "+string(string_height_ext(containerText,-1,maxTextWidth))
	+" a+c: "+string(string_height_ext(containerText+newLineString,-1,maxTextWidth))) 
	
	draw_text(x,y-50,string(string_width(cursorString)) + " " +string(string_width("  ")))//*/
	
	//var newLineAddition = "" //by default

	/*totalStringWidth = maxTextWidth //by default

	if string_length(containerText) > 0 and string_height_ext(containerText+cursorString,-1,maxTextWidth) > string_height_ext(containerText,-1,maxTextWidth) //the cursor would make the text go to a new line
	{
		if cursorText = "" //add the new line char so that the text doesn't nudge based on whether the cursor is visible or not
		var newLineAddition = newLineString
	}*/

	/*if newLineAddition = newLineString
	draw_text(x,y-100,"add new line")
	else
	draw_text(x,y-100,"NO ADD")*/
	
	//*/
	/*
	if containerTextHeight < singleLineHeight - 1
	lineYOffset = 0
	else if containerTextHeight < singleLineHeight*2 - 1
	lineYOffset = singleLineHeight*0.5
	else //3 lines
	lineYOffset = singleLineHeight*/
	
	
//THIS WAS THE OLD LINE //draw_text_ext(x- round(sprite_width*0.46),y,containerText + cursorString,-1,maxTextWidth) //TODO: Correct position


	//draw_text(x - round(sprite_width*0.46) + currentLineWidth,
	//y + containerTextHeight-singleLineHeight - lineYOffset,cursorText)
	//draw_text(x- round(sprite_width*0.46) + string_width_ext(containerText,-1,330),
		//y + string_height_ext(containerText,-1,330),cursorText)
	prevContainerTextHeight = containerTextHeight
}
else //container has text but is not active for writing
{
	draw_set_halign(fa_center)
	containerTextToDisplay = string_wordwrap_width(containerText, maxTextWidth,"\n", true)
	draw_text(x,y,containerTextToDisplay)//,-1,maxTextWidth)
}


if string_length(containerText) < maxTextLength
draw_set_color(c_white)
else
draw_set_color(lightRed)

draw_set_halign(fa_center)
draw_set_valign(fa_middle)
draw_set_font(fntPluto12p)
draw_text(room_width/2, room_height - 30,string(maxTextLength - string_length(containerText)) + " Characters")
