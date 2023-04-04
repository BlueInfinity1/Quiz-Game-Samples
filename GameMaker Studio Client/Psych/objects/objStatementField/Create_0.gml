/// @description Insert description here
// You can write your code in this editor



containerText = ""
containerTextWidth = 0
containerTextHeight = 24 //at least single line height
prevContainerTextHeight = 0

whiteSpaceCountAtEnd = 0

activeForWriting = false
maxTextLength = 100 //3 rows or so
labelImage = 0 //truth

forceWrite = false

cursorTimer = 0
cursorTimerVisible = true
cursorTimerThreshold = 15 //blink every now and then

initialKeyPressDelay = 10 //how long to wait before the key duplicate letters/backspace appear
continuousKeyPressDelay = 2 //letters will appear faster when held down
backSpaceTimer = 0
forceBackSpace = false

canBePressed = true

//image_yscale = 1.2