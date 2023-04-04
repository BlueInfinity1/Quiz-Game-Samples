/// @description Insert description here
// You can write your code in this editor

with objGameController
scrMakeRoomDataGetRequest() //here we'll check whether the phase has changed
	
with objSliderKnob
instance_destroy()
	
with objGameController
{
	hostHasStartedGame = false
	scrDestroyOtherButtons()
	scrStartCategorySelectionPhase()
}

instance_destroy()

