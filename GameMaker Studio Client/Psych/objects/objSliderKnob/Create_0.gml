/// @description Insert description here
// You can write your code in this editor

sliderPosX = x
sliderPosY = y

dragStartY = 0
dragY = 0
dragging = false

canBeDragged = true

if objGameController.phase = gamePhase.selectingCategory
{
	sliderHeight = room_height - sprite_get_height(sprSlider) - 135*2
	y = 135 + round(sprite_height/2)
}
else if objGameController.phase = gamePhase.guessingStatements or objGameController.phase = gamePhase.viewingAnswers
{
	sliderHeight = sprite_get_height(sprResultsContainer)
	x = 880
	y = objGameController.upmostY - sprite_get_height(sprStatementChoice)/2 + round(sprite_height/2)
}
else if objGameController.phase = gamePhase.showingScores
{
	sliderHeight = sprite_get_height(sprResultsContainer) - 135
	y = 145 + 30 + round(sprite_height/2)
}
else //if objGameController.phase <= gamePhase.waitingForPlayers
{
	if objGameController.playerCount <= visibleContainerPlayersWithoutScrolling
	visible = false
	
	sliderHeight = sprite_get_height(sprResultsContainer) - 135
	y = 145 + round(sprite_height/2)
}

initialKnobY = y
knobStartY = y

knobYMoveRange = sliderHeight

knobRatio = 0