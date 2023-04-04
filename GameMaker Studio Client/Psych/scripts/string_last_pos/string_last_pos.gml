///@description string_last_pos(substr, str);
///@param substr
///@param str

var tempStr = argument1
//var currLastSubStrPos = 0
var subStrLength = string_length(argument0)
var absoluteSubStrPos = 0

var isFirstOccurrence = true

while (true)
{
	if tempStr = ""
	return absoluteSubStrPos
	
	//show_message(tempStr)
	
	var newLastSubStrPos = string_pos(argument0,tempStr)
	
	//show_message("New substring pos: "+string(newLastSubStrPos))
	
	if newLastSubStrPos = 0
		return absoluteSubStrPos
	else
	{
		//show_message("New substring length will be " + string(string_length(tempStr) - newLastSubStrPos - subStrLength+1))
		tempStr = string_copy(tempStr,newLastSubStrPos + subStrLength, string_length(tempStr) - newLastSubStrPos - subStrLength+1)
		absoluteSubStrPos += newLastSubStrPos
		
		if !isFirstOccurrence
			absoluteSubStrPos += subStrLength - 1
		else
			isFirstOccurrence = false
	
		//show_message("New absoluteLastPos: "+string(absoluteSubStrPos))
	
	}
}