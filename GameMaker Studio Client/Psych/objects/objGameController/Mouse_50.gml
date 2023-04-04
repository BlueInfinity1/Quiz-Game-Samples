/// @description Insert description here
// You can write your code in this editor

if debugModeOn
{
	pressTimer += 1
	if pressTimer = 30
	{
		fillTextNum = 10
		with objStatementField
		{
			containerText = objGameController.playerName + " " +string(objGameController.fillTextNum)
			objGameController.fillTextNum += 10
		}
		
		pressTimer = 0
	}
}