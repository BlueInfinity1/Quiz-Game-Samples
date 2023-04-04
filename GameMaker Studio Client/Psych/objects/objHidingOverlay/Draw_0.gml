/// @description Insert description here
// You can write your code in this editor
//draw the overlay to hide other questions

//draw_text(10,10,"draw")

/*if objGameController.phase = gamePhase.guessingStatements
{	
	//gpu_set_blendmode(bm_add)
	
	draw_set_alpha(1)
	
	//upper
	draw_sprite_part(sprBackground,0,0,0,room_width-100,
		objGameController.upmostY - round(objStatementChoice.sprite_height*0.5) + 10,0,0)
	//lower
	var lowerCoverHeight = room_height - (objGameController.upmostY + objGameController.gapY*(objGameController.visibleAnswersWithoutScrolling) + 15)
	
	draw_sprite_part(sprBackground,0,0,room_height - lowerCoverHeight,
		room_width,lowerCoverHeight,
		0,room_height - lowerCoverHeight)
		
	//gpu_set_blendmode(bm_normal)
}