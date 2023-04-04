with objGameController
{
	viewingRules = true
	instance_create_layer(room_width,room_height,"PopUp_Instances", objRulePopUp)
	instance_create_layer(room_width/2,room_height - 100,"PopUp_Buttons", objRuleGotItButton)
	ruleCloseButton = instance_create_layer(740, 52, "PopUp_Buttons", objCloseButton)
	ruleCloseButton.image_xscale = 3
	ruleCloseButton.image_yscale = 3
	ruleCloseButton.isViewingRulesCloseButton = true
}