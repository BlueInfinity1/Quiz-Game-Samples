/// @description Insert description here
// You can write your code in this editor

//exit

if debugModeOn
{
	fillTextNum = 10
	with objStatementField
	{
		containerText = objGameController.playerName + " " +string(objGameController.fillTextNum)
		objGameController.fillTextNum += 10
	}
}