/// @description Insert description here
// You can write your code in this editor

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
and !collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),objReadyButton,true,false)
{
	if canBePressed
	{
		with objStatementField //only one active field at a time
		activeForWriting = false

		activeForWriting = true
		cursorTimer = 0
		cursorTimerVisible = true //start with a visible cursor
		keyboard_string = ""

		if soundOn
		audio_play_sound(sndButton,1,false)
	}
}
else if device_mouse_check_button_pressed(0,mb_left) //click outside the box to reset
activeForWriting = false

if activeForWriting
{
	cursorTimer += 1
	
	if cursorTimer = cursorTimerThreshold + 1
	{
		cursorTimer = 1
		cursorTimerVisible = !cursorTimerVisible
	}
	
	if keyboard_check_pressed(vk_enter)
	activeForWriting = false
	else if keyboard_check_pressed(vk_backspace) or forceBackSpace
	{
		cursorTimer = 0
		cursorTimerVisible = true
		
		if containerText != ""
		{
			containerText = string_delete(containerText,string_length(containerText),1)
			
			if whiteSpaceCountAtEnd > 0
			whiteSpaceCountAtEnd -= 1
		}
		
		/*lastWord = ""
		lastWordWidth = 500;
		lastWordStartIndex = string_length(containerNext)
		for (var i = string_length(containerText); i >= 0; i -= 1)
		{
			//go backwards from the end until we find the first white space or line break
			var charToCheck = string_char_at(containerText,i)
			
			if charToCheck = " " or 
			
		}*/
		
	}
	else if (keyboard_check_pressed(vk_anykey) or forceWrite) and string_length(containerText) < maxTextLength
	{
		cursorTimer = 0
		cursorTimerVisible = true
		
		if keyboard_check_pressed(vk_space)
		whiteSpaceCountAtEnd += 1
		else
		whiteSpaceCountAtEnd = 0
		
		containerText += keyboard_string;
		keyboard_string = "";
   }
   
   if keyboard_check_released(vk_anykey)
   keyboard_string = ""
   
   if keyboard_check(vk_backspace)
   {
	   backSpaceTimer += 1
	   if backSpaceTimer >= initialKeyPressDelay
	   {
			if backSpaceTimer mod continuousKeyPressDelay = 0
			forceBackSpace = true
			else
			forceBackSpace = false
	   }
   }
   
   if keyboard_check_released(vk_backspace)
   {
	backSpaceTimer = 0
	forceBackSpace = false
   }
   
   //TODO: Backspace, see	https://www.youtube.com/watch?v=mFhCkGuAvcg&ab_channel=SebHavens
   
   
}