/// @description Insert description here
// You can write your code in this editor

//if !checkNeedToRecover and !triggerRecovery
//show_message("This is the first time both recovery vars are false")

if phase <= gamePhase.showingRules
exit

if keyboard_check(vk_anykey) or device_mouse_x(0) != prevMouseX or device_mouse_y(0) != prevMouseY
or device_mouse_check_button(0,mb_left)
{
	lastInteractTime = current_time
	prevMouseX = device_mouse_x(0)
	prevMouseY = device_mouse_y(0)
	idleDisconnectionWarningShown = false //reset this
}

if heartBeatTimerOn
{
	if current_time - heartBeatTimerStartTime >= heartBeatTimerDuration
	{
		//show_message("heart beat")
		scrSendHeartBeat() //the response for this does not need to be grabbed
		heartBeatTimerStartTime = current_time
		heartBeatCounter += 1
	}
}

//if isSpectator and debugPopUpsOn
//show_message("Step, before show message checks")

//no need to do any of the checks if these conditions hold
if showTooManyPlayersMessage or showSessionExpiredMessage or web_socket_status(0) != 1 //ensure that there's a connection for the following
or phase <= gamePhase.selectingCategory or !initialDataAboutOthersFetched
exit

//if isSpectator and debugPopUpsOn
//show_message("Step, before show game started check")

if showGameAlreadyStartedMessage
exit

if !isSpectator and !idleDisconnectionWarningShown and lastInteractTime < current_time - idleDisconnectionWarningTime
{
	scrDisplayNotification("Please interact with the game window!\n\nIf you don't, you will be disconnected.",1,120,60)
	idleDisconnectionWarningShown = true
}


if localResultTimerOn 
{
	if phase = gamePhase.showingResults
	{
		if current_time - localResultTimerStartTime >= localResultTimerDuration
		{
			//gotAllDataForNextPhase = false
			//canProceedToScoresPhase = true
			//show_message("Local timer, Request data")
			//show_message("Start answer viewing")
			
			//need to have all answers listed
			if scrCheckPlayerReadiness()
				scrStartAnswerViewingPhase()
			else
				scrMakeGetPlayerDataRequest()
			//scrMakeRoomDataGetRequest()
			
			localResultTimerOn = false
		}
	}
	else
	localResultTimerOn = false
}

//if isSpectator and debugPopUpsOn
//show_message("Step, before safety nets")

for (var i = 100; i < 105; i += 1)
{	
	if i = 102
	continue
	
	if (i != 101 and current_time - lastRequestTimes[i] >= requestSafetyInterval)
		or (i = 101 and current_time - lastRequestTimes[i] >= getPlayerDataRequestSafetyInterval)
	{
		var reqInit = false //for debug only
		
		//to reinitiate any of these, there must be at least one leftover request
		//ideally, we should be replacing the old requests, but this works for now
		if i = 100 and ds_list_size(webSocketRequests[? i]) > 0
		{
			reqInit = true
			scrMakeSendDataRequest()
		}
		else if i = 101 //NOTE: This is the only one we keep on spamming even if our request list is empty
		{
			scrMakeGetPlayerDataRequest() 
			reqInit = true
		}
		else if i = 103 and ds_list_size(webSocketRequests[? i]) > 0
		{
			reqInit = true
			scrMakeExistenceQuery()
		}
		else if i = 104 and ds_list_size(webSocketRequests[? i]) > 0
		{
			reqInit = true
			scrMakeGameStartedQuery()
		}
		else if i = 105 and ds_list_size(webSocketRequests[? i]) > 0
		{
			reqInit = true
			scrMakePassiveClientQuery()
		}
		//else if i = 107 //I don't think this is in use, the server only uses it internally
		
		if debugPopUpsOn and reqInit
		{
			//if i != 101
			//show_message("we're yet to receive a reply for op "+string(i)+ ", so reinitiate request")
			//else 
			//show_message("op "+string(i)+ ", reinitiate request")//*/
		}
		
	}
}

if current_time - lastRequestTimes[200] >= requestSafetyInterval
{
	if ds_list_size(webSocketRequests[? 200]) > 0
	{
		//if isSpectator and debugPopUpsOn
		//show_message("we're yet to receive a reply for op 200, so reinitiate request")//*/
		
		scrMakeRoomDataGetRequest()
	}
}

if current_time - lastRequestTimes[201] >= requestSafetyInterval
{
	/*if debugPopUpsOn
	show_message("op 201, reinitiate request")*/
	
	//should not be used for anything else than "init", so this should suffice
	//if phase <= gamePhase.waitingForStatements
	var phaseStr = "init"
	/*else if phase <= gamePhase.showingResults
	var phaseStr = "guessing"
	else
	var phaseStr = "scores"*/
				
	scrMakeRoomDataStoreRequest(phaseStr)
}//*/

if current_time - lastRequestTimes[202] >= requestSafetyInterval
{
	if ds_list_size(webSocketRequests[? 202]) > 0
	scrMakeRoomSpectatorQueueRequest()
}


//do the same for 200 and 201 outside the loop
//200 scrMakeRoomDataGetRequest()
//201 scrMakeRoomDataStoreRequest()

if current_time - lastPlayerDataGetTime >= dataCheckTimeThreshold
{
	lastPlayerDataGetTime = current_time
	//show_message("safety net")
	scrMakeGetPlayerDataRequest()
}

