/// @description Insert description here
// You can write your code in this editor

if !viewingRules and device_mouse_check_button_pressed(0,mb_left) 
and collision_point(device_mouse_x(0)-2*windowGetXScroll(),device_mouse_y(0)-2*windowGetYScroll(),id,true,false)
{
	if !canBePressed
	exit

	if soundOn
	audio_play_sound(sndButton,1,false)

	with objGameController
	{
		if phase = gamePhase.writingStatements
		{
			if !objReadyButton.isReady
			{
				if string_length(answerField.containerText) >= 2
				{
					objReadyButton.isReady = true
					objReadyButton.canBePressed = false 
				
					yourFakeAnswer = answerField.containerText
					
					//show_message("Set your fake answer: "+yourFakeAnswer)
					
					//scrCheckPlayerReadiness
					ownStatementsWritten = true
					selectedGuessId = "-1" //null this to make sure that it does not affect the next rounds
					scrMakeSendDataRequest()
			
					for (var i = 0; i < playerArraySize; i++)
					{
						if players[i, playerData.pId] = playerId //set own variable to true
						players[i, playerData.statementsWritten] = true
					}
					
					//show_message("All ready!")
					phase = gamePhase.waitingForStatements
					
					if playerCount > visibleContainerPlayersWithoutScrolling
					{
						//create a slider
						instance_create_layer(580,209,"Top_Instances",objSliderKnob)
					}
			
					with objStatementField
					{
						instance_destroy()
					}
					
					with objReadyButton
					instance_destroy()
				}
				else
					scrDisplayNotification("Please write your fake answer first!",2,30,0)
			
			}
		
		}
	}
}