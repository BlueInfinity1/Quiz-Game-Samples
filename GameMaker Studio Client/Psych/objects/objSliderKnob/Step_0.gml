/// @description Insert description here
// You can write your code in this editor

//if objGameController.phase = gamePhase.selectingCategory
//x = room_width/2 + round(windowWidth*0.5) - 70//*wRatio //standard sliderPosX = 830, so it's 900-70, so -70 is the offset


//keep track of the player count to know whether this is needed or not
if objGameController.phase = gamePhase.waitingForStatements or objGameController.phase = gamePhase.showingScores or
objGameController.phase = gamePhase.waitingForPlayers or objGameController.phase = gamePhase.waitingForGuesses
{
	if objGameController.playerCount <= visibleContainerPlayersWithoutScrolling
	visible = false
	else
	visible = true
}

if !canBeDragged or !visible or viewingRules
exit

if device_mouse_check_button_pressed(0, mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	knobStartY = y
	dragStartY = device_mouse_y(0)
	dragging = true
}

if device_mouse_check_button(0,mb_left) and dragging
{
	dragY = device_mouse_y(0) - dragStartY
	y = knobStartY + dragY
}

scrollSpeed = 0.34

if mouse_wheel_down()
y += round(scrollSpeed*knobYMoveRange)
else if mouse_wheel_up()
y -= round(scrollSpeed*knobYMoveRange)

y = clamp(y,initialKnobY,initialKnobY+knobYMoveRange)
knobRatio = (y - initialKnobY)/(knobYMoveRange)
	
if objGameController.phase = gamePhase.selectingCategory
{
	with objCategoryCard
	y = initialY - objSliderKnob.knobRatio*maxYMovement
}
else if objGameController.phase = gamePhase.guessingStatements or objGameController.phase = gamePhase.viewingAnswers
{
	with objStatementChoice
	y = initialY - objSliderKnob.knobRatio*maxYMovement
}

if !device_mouse_check_button(0,mb_left)
dragging = false




