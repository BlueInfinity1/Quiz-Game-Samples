/// @description player data request polling
// You can write your code in this editor

if showTooManyPlayersMessage or showSessionExpiredMessage or showGameAlreadyStartedMessage or web_socket_status(0) != 1
exit

scrMakeGetPlayerDataRequest()