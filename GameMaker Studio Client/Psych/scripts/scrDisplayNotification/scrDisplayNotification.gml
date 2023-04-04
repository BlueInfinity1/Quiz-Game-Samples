///@description scrDisplayNotification(message,moveSpeed,lifeTime,startY)
///@param message
///@param moveSpeed
///@param lifeTime
///@param startY

with objGameController
{
	notificationMessage = argument0
	
	notificationMoveSpeed = argument1
	notificationTimer = argument2
	notificationAlpha = 1
	notificationScale = 0
	notificationY = room_height/2 + 45//+ argument3
	argument3 = 45 //NOT IN USE
	notificationMoveStopTime = notificationTimer - 45
}
