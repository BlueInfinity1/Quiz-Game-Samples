/// @description Room data poll
// You can write your code in this editor

//NOTE: This is the only poll we can do while we have "game already started message"
if showTooManyPlayersMessage or showSessionExpiredMessage or web_socket_status(0) != 1
exit

//poll for room data if the room item does not exist
scrMakeRoomDataGetRequest()

//this is a safeguard so that we won't get stuck
if phase <= gamePhase.waitingForPlayers
alarm[7] = pollingInterval
else
alarm[7] = -1

