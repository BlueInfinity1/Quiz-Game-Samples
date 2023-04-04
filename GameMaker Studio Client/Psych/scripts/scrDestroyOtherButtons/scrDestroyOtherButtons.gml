//precaution script to prevent any button from staying on top of the start game btn

with objStartGameButton
instance_destroy()

with objEndGameButton
instance_destroy()

with objReadyButton
instance_destroy()

//with objRuleGotItButton
//instance_destroy()

with objNextRoundButton
instance_destroy()

with objNextButton
instance_destroy()

with objPlayButton //Though this should never be used as this is in category selection phase
instance_destroy()

with objRematchButton
instance_destroy()

with objStatementChoice
instance_destroy()

with objStatementField
instance_destroy()

with objSliderKnob
instance_destroy()

with objButtonParent
instance_destroy()
