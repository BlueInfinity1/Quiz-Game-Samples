//NOTE: This is called when we're querying info about disconnected players, so we can use 
//the result map

//PARAM: message to display

if argument_count > 0
var displayMsg = argument[0]
else
var displayMsg = "You have been removed from the game for being idle."

allRoundsFinished = false

gamePrepared = false //single game round prepared
initiallyPrepared = false //the first initialization

phase = gamePhase.initializing //also set in scrInitialize()

//nullify all alarms
for (var i = 0; i < 12; i += 1)
alarm[i] = -1

//except alarm[11], which will do the reconnecting loop
alarm[11] = 30

lastRequestTimes[100] = 2147483647 //this would be enough milliseconds to cover for 24 days, a time no one will keep this game open
//show_message(lastRequestTimes[100])
lastRequestTimes[101] = 2147483647
lastRequestTimes[102] = 2147483647
lastRequestTimes[103] = 2147483647
lastRequestTimes[104] = 2147483647
lastRequestTimes[105] = 2147483647
//lastRequestTimes[106] = -1//again, skipping 106
//lastRequestTimes[107] = -1 //this is not in use either

lastRequestTimes[200] = 2147483647
lastRequestTimes[201] = 2147483647
lastRequestTimes[202] = 2147483647

ds_list_clear(webSocketRequests[? 100])
ds_list_clear(webSocketRequests[? 101])
ds_list_clear(webSocketRequests[? 102])
ds_list_clear(webSocketRequests[? 103])
ds_list_clear(webSocketRequests[? 104])
ds_list_clear(webSocketRequests[? 105])

ds_list_clear(webSocketRequests[? 200])
ds_list_clear(webSocketRequests[? 201])
ds_list_clear(webSocketRequests[? 202])

if ds_exists(playerImages,ds_type_list)
ds_list_clear(playerImages)

if ds_exists(imageRequests,ds_type_list)
ds_list_clear(imageRequests)

if ds_exists(imageLoadAttempts,ds_type_list)
ds_list_clear(imageLoadAttempts)

if ds_exists(playerImageSurfaces,ds_type_list)
ds_list_clear(playerImageSurfaces)

if ds_exists(playerImageSurfaces35p,ds_type_list)
ds_list_clear(playerImageSurfaces35p)

scrDestroyOtherButtons()

with objStatementChoice
instance_destroy()

with objStatementField
instance_destroy()

with objPlayButton
instance_destroy()

with objCategoryCard
instance_destroy()

with objSliderKnob
instance_destroy()

with objReadyButton
instance_destroy()

with objStartGameButton
instance_destroy()

with objNextRoundButton
instance_destroy()

with objRematchButton
instance_destroy()

if canDisplayDisconnectMessage
{
	//NOTE: We don't need to distinguish between disconnection cases here: This can only be an idle disconnection
	//since if we received a websocket disconnection, the game is not open anymore... Except if we just have 
	//poor internet, but then we won't even receive the disconnection message
	
	//if lastInteractTime < current_time - idleDisconnectionTime
	//displayMsg += " for being idle."
	//else
	//displayMsg += " " 
	
	scrDisplayNotification(displayMsg,2,90,60)
}

//playerCount = 1
//playerArraySize = 1
scrInitializeCreationVariables()
scrInitialize()

//if isHost
//scrStartCategorySelectionPhase()
