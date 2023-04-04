gameJustOpened = true
checkNeedToRecover = true
triggerRecovery = false //used in op 101 if we need to also recover game phase
canAcceptPlayerDataPushes = false //whether we can perform the logic that takes place when we receive op 300.
//used to prevent handling stray requests after disconnections


initialDataAboutOthersFetched = false

showTooManyPlayersMessage = false
showGameAlreadyStartedMessage = false
showSessionExpiredMessage = false

gamePrepared = false //single game round prepared
initiallyPrepared = false //the first initialization

gotAllDataForNextPhase = false

hostId = ""
hostHasJoined = true //always true
//hostName = ""

shuffleOrderList = ds_list_create()
