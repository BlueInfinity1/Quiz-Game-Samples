/// @description Host ready data poll
// You can write your code in this editor

//poll for the ready state of host

if showTooManyPlayersMessage or showSessionExpiredMessage or showGameAlreadyStartedMessage or web_socket_status(0) != 1
exit

//this is a safeguard so that we won't get stuck
if phase <= gamePhase.waitingForPlayers
{
	scrMakeGameStartedQuery() //we don't need this data if we're past the init phase
	alarm[6] = pollingInterval
}
else
alarm[6] = -1


