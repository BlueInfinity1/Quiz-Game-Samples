if (async_load[? "id"]==async_websocket) //The package belongs to us.
{
	//in the following cases, we're unable to handle these
	if showSessionExpiredMessage or showTooManyPlayersMessage or phase <= gamePhase.selectingCategory
	exit
	
	var ev_type, server_no;
	ev_type = async_load[? "event_type"];
	server_no = async_load[? "server_number"];

	switch(ev_type)
	{
		case socket_event_connected: //If we are connected
		//show_message("connected")
		//var data = async_load[? "data"];
		//repliedBackMessage = data;
		//show_message("reply: "+ data)
		//show_message("Successful conn")
		break;
		
		case socket_event_closed:
		{
			//if we lose connection, we'll have to retry
			//web_socket_open(0,endPointUrl,-1, false);
			//event_perform(ev_alarm, 0)
			
			//if 
			if current_time - lastConnOpenAttemptTime >= canDisplayDisconnectMessageThreshold
			{
				canDisplayDisconnectMessage = true
				//show_message("The connection has been open for "+string(canDisplayDisconnectMessageThreshold) + 
				//", and it's now "+string(current_time) + " and last succ conn was at "+string(lastConnOpenAttemptTime))
			}
			else
			canDisplayDisconnectMessage = false

			scrHandlePlayerDisconnection("You have been disconnected.\n\nPlease check your internet connection.")
			
		}
		break;
		
		case socket_event_error: 
		//if we lose connection, we'll have to retry
		//web_socket_open(0,endPointUrl,-1, false);
		//event_perform(ev_alarm, 0)
		if debugPopUpsOn
		show_message("websocket error")		
		break;
		
		case socket_event_message:
				
		var data = async_load[? "data"];
		repliedBackMessage = data;
		
		//show_message("REPLY: "+repliedBackMessage)
		
		//if showTooManyPlayersMessage or showSessionExpiredMessage
		//exit
		
		var resultMap = json_decode(data);
		
		var opCode = resultMap[? "op"]
		var status = resultMap[? "status"]
		var requestId = resultMap[? "requestId"]
		
		//check to see which request we're getting a response to, if any
		if opCode != 106 and opCode < 299 //no need to check heartbeat responses and pushes can't be checked
		{
			var requestIndex = ds_list_find_index(webSocketRequests[? opCode],requestId)
		
			if requestIndex > -0.1
			{
				//if debugPopUpsOn
				//show_message("got a reply to a stored request, removing request, op: "+string(opCode))
			
				ds_list_delete(webSocketRequests[? opCode], requestIndex)
			}
			else //I think it's possible to receive a reply to a request we're not expecting in the case we disconnect (plug off)
			//and come back, and made a safety net request just before the disconnection, and then we receive the reply
			//after the connection has come back. In this case, the request lists have been emptied, so we'll be here
			{
				//if debugPopUpsOn
				//show_message("ERROR: received response to a request that is not listed! op: "+string(opCode))
				
				exit 
			}
		}
		else if opCode >= 300 //We must have sent our own data once to accept data pushes from other players (which initiates
		//the getPlayerData check) [I.e. checkNeedToRecover phase must've been passed] or we must have gotten initial data about others before we can get 301 that makes as do
		//a room check)
		{
			//show_message("Received a push: "+repliedBackMessage)
			if !isSpectator and (opCode = 300 and !canAcceptPlayerDataPushes) or (opCode >= 301 and !initialDataAboutOthersFetched)
			{
				//show_message("Received a push that we're not ready to handle, op: "+string(opCode))
				exit
			}//*/
		}
		
		if debugPopUpsOn //or opCode = 400
		//if opCode = 102 or opCode = 400//and debugPopUpsOn
		show_message("Got reply: "+repliedBackMessage + ", has opCode: "+string(opCode))
		
		if opCode = undefined //if there's no op code in the send
		{
			//show_message("UNDEFINED OP: "+repliedBackMessage + ", has opCode: "+string(opCode))
			//We shouldn't be here ever
		}
		else //if op code is defined, then it's a response to our message
		{
			switch (opCode)
			{
//100			
				case 100:
				if status = "OK"
				{
					//show_message("Got reply: "+repliedBackMessage + ", has opCode: "+string(opCode))
					successfullySentPlayerDataOnce = true 
					
					if isSpectator //if we managed to successfully send data while being a spectator, we join the game
					{
						isSpectator = false	
						scrDisplayNotification("You have joined the game as a player.",2,60,60)
					}
				}
				else if status = "REJECTED" //this can only happen for spectators
				{
					if debugModeOn
					show_message(ds_map_find_value(resultMap,"message"))
					
					isSpectator = true
					canSendOwnData = false
					
					//check for information as a spectator
					scrMakeRoomDataGetRequest()
					scrMakeGetPlayerDataRequest()
				}
				else
				scrMakeSendDataRequest() // try again
				
				break

//101 (get all player data)
				case 101:
				initialDataAboutOthersFetched = true
				if status = "OK"
				{
					var itemList = ds_map_find_value(resultMap,"message")
					scrHandleGetPlayerDataResponse(itemList) //this is so long that we include it here
					
					if triggerRecovery //update these so that we won't be sending wrong values to db
					{
						var ownInd = scrFindPlayerIndexById(playerId)
						
						if !isSpectator and ownInd = -1
						{				
							//show_message("own index not found")
							game_restart()
							exit
						}
						
						if !isSpectator
						{
							selectedGuessId = players[ownInd,playerData.selectedGuessId]
							readyForNextRound = players[ownInd,playerData.isReadyForNextRound]
							ownStatementsWritten = players[ownInd,playerData.statementsWritten]
						}
						
						scrMakeRoomDataGetRequest()
					}

					if ds_exists(resultMap,ds_type_map)
					ds_map_destroy(resultMap)
				}
				else
				scrMakeGetPlayerDataRequest() //try again if this failed
			
				break


//103 (existence query)
				case 103:
				
				if status = "OK"
				{
					var messageMap = ds_map_find_value(resultMap,"message")
					
					if messageMap[? "playerExists"]
					ownPlayerRecordExists = true
					else
					ownPlayerRecordExists = false
					
					scrMakeInitialRequest() //proceed to the next phase
				}
				else
				scrMakeExistenceQuery()
				
				break
//104 (UNUSED)
			
//105
				case 105:
				
				if status = "OK"
				{
					var messageMap = ds_map_find_value(resultMap,"message")
					
					//if debugPopUpsOn
					//show_message(string(messageMap[? "isPassive"]) + " " +string(is_real(messageMap[? "isPassive"])))
					
					
					if messageMap[? "isPassive"] //we're passive, so we must wait until the current round ends
					{
						if !forcedRulePopUpShown
						{
							scrOpenRulePopUp()
							forcedRulePopUpShown = true
						}
						
						//showGameAlreadyStartedMessage = true //MARK
						//alarm[7] = 30//pollingInterval //MARK
						//TODO: instead of polling, read the push (301?)
						//NOTE: But polling needs to be there as a back-up in case we miss the push... And we have
						//no idea when it's going to come
						
						if !isSpectator
						{
							isSpectator = true
							canSendOwnData = false
							//debugPopUpsOn = true
							scrMakeRoomSpectatorQueueRequest()
							scrDisplayNotification("You have joined as a spectator.\n\nThe current round has already started.",2,120,60)
						}
						
						//show_message("Spectator due to passivity and game already started")
						
					}
					else
					{
						/*if checkNeedToRecover
						{
							triggerRecovery = true
							gameJustOpened = false
							gamePrepared = true
							successfullySentPlayerDataOnce = true //this is to stop first send from changing creation time
							
							scrMakeGetPlayerDataRequest()

							checkNeedToRecover = false
							forcedRulePopUpShown = true //bypass the rule pop-up if we've already been in the game
						}*/
					}
					
					if checkNeedToRecover //proceed regardless of whether we're a spectator or not
					{
						triggerRecovery = true
						gameJustOpened = false
						gamePrepared = true
						successfullySentPlayerDataOnce = true //this is to stop first send from changing creation time
							
						scrMakeGetPlayerDataRequest()

						checkNeedToRecover = false
						forcedRulePopUpShown = true //bypass the rule pop-up if we've already been in the game
					}
				}
				else
				scrMakePassiveClientQuery()
				
				break
				
//106 //is heartbeat storing
				case 106:
				{
					if status = "OK"
					{
						var messageMap = ds_map_find_value(resultMap,"message")
						var isAlive = messageMap[? "isAlive"]
						
						if !isAlive //we've been marked dead for being passive for too long, so 
						{
							show_message("We're passive and shouldn't be here")
							game_restart()
							exit
						}
					}
					//no resend, since this loops anyway
					break
				}
				
//200		
				case 200: //room data getting
				
				if status = "ITEM NOT DEFINED"
				{
					//show_message("item not defined")
					//show_message("room-session does not exist, create it")
					
					if isHost
					scrMakeRoomDataStoreRequest("init")
					else //MARK
					scrMakeSendDataRequest() //keep trying again //TODO: read push from (301) //we can't really allow non-host to do this, because
					//nonhosts don't know who the host is
				}
				else if status = "OK"
				{
					var messageMap = ds_map_find_value(resultMap,"message")
					
					roomPlayerCount = messageMap[? "playerCount"]
					
					if roomPlayerCount <= 1 //if we have only one player, we shouldn't be recovering any phase, even if the room phase has not yet been updated
						triggerRecovery = false
					
					if !initiallyPrepared and !ownPlayerRecordExists //if our record doesn't exist, this means that we're a new player trying
					//to join in, so we must check the player count
					{
						//show_message("roomPlayer count before spectator check is "+string(roomPlayerCount))
						
						if !isSpectator and roomPlayerCount > maxPlayers //there are already a max number of players in the room (basically = should be enough)
						{
							if debugPopUpsOn
							show_message("Too many players!")
							
							//showTooManyPlayersMessage = true //MARK
							if !isSpectator
							{
								isSpectator = true
								canSendOwnData = false
								scrMakeRoomSpectatorQueueRequest()
								scrDisplayNotification("You have joined as a spectator.\n\nThe game already has the maximum number ("+string(maxPlayers)
									+") of players.",2,120,60)
							}
							
							//show_message("Spectator due to too many players, roomPlayerCount is " +string(roomPlayerCount))
							//exit //MARK
						}
						else
						showTooManyPlayersMessage = false
					}
					//else: For old players, we've already gotten into the session, so it must mean that we're within the max limit
					
					//if debugPopUpsOn
					//show_message("(200) Session expired: "+ string(ds_map_find_value(messageMap,"sessionExpired")))
					
					if ds_map_find_value(messageMap,"sessionExpired") = 1
					{
						showSessionExpiredMessage = true //executing anything stops here
						phase = gamePhase.initializing
						scrDestroyOtherButtons()
						isSpectator = false //no need to keep track of this anymore
						exit
					}
					else
					showSessionExpiredMessage = false
					
					//show_message("session not expired")
					var roomSessionDataMap = ds_map_find_value(messageMap,"roomSessionData")
					var roomItemMap = ds_map_find_value(roomSessionDataMap,"Item")
					
					//
					
					if !is_undefined(roomItemMap)
					{
						var tempRoomPhase = ds_map_find_value(roomItemMap,"roomPhase") 
									
						shuffleOrderList = roomItemMap[? "shuffleOrder"]
										
						currentQuestion = roomItemMap[? "currentQuestion"]
						correctAnswer = roomItemMap[? "currentAnswer"]
						
						answerList = roomItemMap[? "fakeAnswers"]
						
						cardStack = roomItemMap[? "cardStack"]
						
						//show_message("Room item is not undefined")
						
						if !is_undefined(roomItemMap[? "fakeAnswers"])
						{
							for (var i = 0; i < ds_list_size(roomItemMap[? "fakeAnswers"]); i++)
							{
								var currFakeAnswerItem = answerList[|i]
								answerMap[? currFakeAnswerItem[? "playerId"]] = currFakeAnswerItem[? "answer"]
								
								if currFakeAnswerItem[? "playerId"] = playerId
								yourFakeAnswer = answerMap[? playerId] //players[ownInd,playerData.trueStatement1]	
							}
						}//*/
						
						if !is_undefined(roomItemMap[? "categoryId"])
						{
							currentCategoryId = roomItemMap[? "categoryId"]
							
							if currentCategoryId >= 0
							currentCategoryName = categoryNames[currentCategoryId]
							else
							currentCategoryName = ""
						}
						else
						{
							currentCategoryId = -1
							currentCategoryName = ""
						}
						
						//show_message("Set category id to " +string(currentCategoryId) + " and its name is "+string(currentCategoryName))
						//show_message("got correct answer: "+correctAnswer)
						
						//if we get this, then keep on polling for when players are back at init state
						if showGameAlreadyStartedMessage and tempRoomPhase = "init"
							showGameAlreadyStartedMessage = false
						
						
						if !showTooManyPlayersMessage and !showGameAlreadyStartedMessage and !showSessionExpiredMessage
						{
							//show_message("Check need to rec: "+string(checkNeedToRecover))
							//these are for phase progression
							if !checkNeedToRecover //this is here to prevent the very first room data read from resulting to a phase hop
							{
								//show_message("room phase shift to "+tempRoomPhase)
								
								if isSpectator and (tempRoomPhase = "init" or tempRoomPhase = "scores")
								{
									//roomPlayerCount is sent with the room data
									if roomPlayerCount < maxPlayers
									{
										//show_message("Spectator attempting to send own data, canSendOwnData: "+string(canSendOwnData))
										
										canSendOwnData = true
										scrMakeSendDataRequest()
										
										//isSpectator = false //by default, we are not a spectator, so we can try sending data to the server at this point
										//The server will keep track of the player order and accept only players who can fit, possibly in the order of joining the game	
									}
								}
								
								if tempRoomPhase = "init"
								{
									//guessingStatements originally
									if isSpectator or phase >= gamePhase.writingStatements or triggerRecovery//we're coming back to init phase after game start
									{										
										gotAllDataForNextPhase = false
										phase = gamePhase.initializing
										
										gamePrepared = false
										allRoundsFinished = false
										initialDataAboutOthersFetched = false
										requestDataToFetch = dataRequest.basicInfo //check whether we have new players
										scrInitialize() //init everything to start the round from a clean state	
														
										scrDestroyOtherButtons()		
																
										//event_perform(ev_alarm,1)
										
										scrMakeGetPlayerDataRequest() //check if we have new players, and have the host create the start button for himself
										
										//show_message("own statements written: "+string(ownStatementsWritten))
									}
								}
								else if tempRoomPhase = "writing"
								{
									//the second option is possible if the non-hosts lag behind
									if (isSpectator and phase != gamePhase.writingStatements) or phase = gamePhase.viewingAnswers 
										or phase = gamePhase.showingScores or phase = gamePhase.waitingForPlayers or triggerRecovery //can hop to guessing from these two phases
									{
										scrDestroyOtherButtons()
										
										hostHasEndedGame = false //reset this if this was true before
										
										gotAllDataForNextPhase = false
										
										//show_message("move to write phase, ownStatementsWritten: "+string(ownStatementsWritten))
										
										if !ownStatementsWritten
										{
											//show_message("Move to writing phase from async room data fetch")
											scrPrepareGame()
											phase = gamePhase.writingStatements
											
											event_perform(ev_alarm,1)
										}
										else
										phase = gamePhase.waitingForStatements
										
										
										with objNextRoundButton //might sometimes happen that we get this even though it's the last round 
										instance_destroy()
									}
								}
								else if tempRoomPhase = "guessing"
								{
									//show_message("200: temp room p guessing")
									if (!isSpectator and phase = gamePhase.waitingForStatements) 
										or (isSpectator and phase != gamePhase.guessingStatements)
										or triggerRecovery //can hop to guessing from these two phases
									{
										gotAllDataForNextPhase = false
										
										if !triggerRecovery and phase = gamePhase.waitingForStatements
										{
											for (var i = 0; i < playerArraySize; i ++)
											{
												players[i,playerData.selectedGuessId] = "-1" //null this since we go into a new guess phase
												//scoreIncreasedMap[? players[i, playerData.pId]] = false
												//players[i,playerData.scoreIncreased] = false
											}
										}
										
										scrDestroyOtherButtons()
										
										if selectedGuessId != "-1" //this should probably only happen with "triggerRecovery"
										{								
											phase = gamePhase.waitingForGuesses
											
											if playerCount > visibleContainerPlayersWithoutScrolling
											instance_create_layer(x,y,"Instances",objSliderKnob)
										}
										else
											phase = gamePhase.guessingStatements
										
										
										with objStartGameButton
										instance_destroy()
								
										with objNextRoundButton
										instance_destroy()
								
										with objRematchButton
										instance_destroy() //this should not be happening
								
										with objStatementField
										instance_destroy()
			 
										with objReadyButton
										instance_destroy()
				
										//show_message("al 1 perform, guessing")
										event_perform(ev_alarm,1)
									}
									else if phase = gamePhase.guessingStatements
									{
										//show_message("phase guessing statements")
									}
								}
								else if tempRoomPhase = "answers"
								{
									//if isSpectator
									//show_message("Temp room phase answers")
									
									if (phase <= gamePhase.waitingForGuesses and gotAllDataForNextPhase) or triggerRecovery
										or (isSpectator and phase != gamePhase.viewingAnswers)
									{
										phase = gamePhase.preparingToShowResult
										if triggerRecovery or isSpectator//if we're recovering, jump straight to answers (no result screen)
										{
											scrStartAnswerViewingPhase() //triggers ev_alarm anyway
										}
										else
										{
											//show_message("answers ev perform")
											event_perform(ev_alarm,1)
										}
			
										//with objNextButton
										//instance_destroy()
									}
								}
								else if tempRoomPhase = "scores" //NOTE: We're actually showing the result first before hopping into the scores
								{
									if (phase = gamePhase.viewingAnswers and gotAllDataForNextPhase) or triggerRecovery
										or (isSpectator and phase != gamePhase.showingScores)
									{
										//show_message("Move to scores")
										
										ownStatementsWritten = false //set these in advance
										for (var i = 0; i < playerArraySize; i++)
											players[i, playerData.statementsWritten] = false
										
										gotAllDataForNextPhase = false
										//show_message("switch room phase to scores (from viewing answers)")
										
										if !is_undefined(cardStack)
										{
											//show_message("cardStack size: "+string(ds_list_size(cardStack)))
											
											if ds_list_size(cardStack) = 0
											{
												var displayMsg = "This category has run out of new questions.\n\n"
												
												if isHost
												displayMsg += "Press \"End Game\" if you want to pick a new category."
												else
												displayMsg += "The host has to press \"End Game\" to pick a new category."
												
												scrDisplayNotification(displayMsg,1,120,60)
											}
										}
										
										//if triggerRecovery
										scrStartScoreboardPhase()
										
										scrDestroyOtherButtons()
								
										//show_message("trigger scores")
										event_perform(ev_alarm,1) //trigger the next phase
									}
								}
								
								if triggerRecovery
								{
									scrMakeSendDataRequest() //we need to send data to the server so that it will store the recovering
									//player's new connection id
									triggerRecovery = false
									roomPhaseToRecover = "none"
								}
								
							} //if !checkNeedToRecover
							else //this is done initially, only once
							{
								hostId = ds_map_find_value(roomItemMap,"hostId")
									
								if hostId = playerId
								isHost = true
								else
								isHost = false
								
								if debugPopUpsOn
								show_message("got hostId from 200: "+string(hostId))
								
								if tempRoomPhase != "init"
								scrMakePassiveClientQuery()
								else
								{
									showGameAlreadyStartedMessage = false
									
									//if a room has already been created, get the hostId from the room data.
									//this may override the initial "isHost" parameter if there's been a host switch
									
									//show the rule pop-up if you've started the game and ended up in init screen
									if !forcedRulePopUpShown
									{
										forcedRulePopUpShown = true
										scrOpenRulePopUp()
									}
							
									//The below host line is needed
									/*if isHost and chosenCategory = -1
									{
										//show_message("categ sel")
										//scrStartCategorySelectionPhase()
									}
									else*/ if !initialDataAboutOthersFetched
									scrMakeSendDataRequest()
								}
							}

							ds_map_destroy(roomItemMap)
						
						} //if !showTooManyPlayersMessage and !showGameAlreadyStartedMessage and !showSessionExpiredMessage
						
					} // item Map not undefined
				}
				else
				{
					//show_message("try again")
					scrMakeRoomDataGetRequest()
				}
				
				break
//201
				case 201: //room data storing
				if status = "OK"
				{
					if phase = gamePhase.initializing or phase = gamePhase.waitingForPlayers
					{
						//after storing, get the data
						scrMakeRoomDataGetRequest()
						//scrMakeSendDataRequest() 
					}
				}
				else
				{
					//show_message("room data storing failed")
				
					//since the only time we change this is by host at init phase, this should be enough
				
					if phase <= gamePhase.waitingForPlayers
					var phaseStr = "init"
					/*else if phase <= gamePhase.waitingForStatements
					var phaseStr = "writing"
					else if phase <= gamePhase.showingResults
					var phaseStr = "guessing"
					else
					var phaseStr = "scores"*/
				
					scrMakeRoomDataStoreRequest(phaseStr) //try again
				}
			
			
				break
//300 (data push about other players after someone stores player data)
				case 300:
				if status = "OK" //should always be
				{
					//if debugPopUpsOn
					//if isSpectator
					//show_message("Push data: "+repliedBackMessage + ", has opCode: "+string(opCode))
					
					lastPlayerDataGetTime = current_time
					
					
					if !isSpectator and !heartBeatTimerOn
					{
						//show_message("Start heart beat timer")
						heartBeatTimerStartTime = current_time //initiate heartbeatTimer
						heartBeatTimerOn = true
					}
					
					successfullySentPlayerDataOnce = true 
			
					if !isHost and !hostHasStartedGame
					scrMakeRoomDataGetRequest()//check if new information includes this phase change (host has started the game)
					//scrMakeGameStartedQuery()  //CHANGED
			
					//if !initialDataAboutOthersFetched
					scrMakeGetPlayerDataRequest()
					//TODO: Basically, we should be handling the data updating here, but we can also do "getAllPlayerData"
					//request now that we know something's been updated
					
				}
				else
				{
					if debugPopUpsOn
					show_message("Received an error with 300")
				}
				
				break

//301 (push after someone stores room data)
				case 301:
				if status = "OK" //should always be
				{
					//NOTE: This should not be needed, as only the host uses the storeRoomData and only once, in the game beginning
					
					//scrMakeRoomDataGetRequest()
					//TODO: Basically, we should be handling the data updating here, but we can also do "getRoomData"
					//request now that we know something's been updated
				}
				break
				
//400 (Someone disconnects and this info is pushed into us)
				case 400:
				if status = "OK"
				{
					var messageMap = resultMap[? "message"]
					var disconnectedPlayerId = messageMap[? "disconnectedPlayerId"]
					var disconnectedPlayerName = messageMap[? "disconnectedPlayerName"]
					
					var waitForReconnection = messageMap[? "waitForReconnection"]
					
					if debugPopUpsOn
					show_message("(400) There's been a disconnection: " + disconnectedPlayerId)
					
					//if initial data has not been fetched, ignore these
					if initialDataAboutOthersFetched
					{
						if waitForReconnection
						{
							if disconnectedPlayerId = playerId //it's us who has been disconnected
							var displayMsg = "You have disconnected.\n\nPlease reconnect to be able to continue the game."
							else
							var displayMsg = disconnectedPlayerName + " has disconnected.\n\nWaiting for "+disconnectedPlayerName
								+ " to reconnect."
							
							scrDisplayNotification(displayMsg,2,120,60)
						}
						else
						{
							var pLeftCount = messageMap[? "playersLeft"]
							var newHostId = messageMap[? "newHostId"]
							
							rebuildScoreboard = true //flag for getPlayerData
							
							if disconnectedPlayerId = playerId //it's us who has been disconnected
							scrHandlePlayerDisconnection()
							else //someone else has disconnected
							{
								var displayMsg = disconnectedPlayerName + " has left the game.\n\n"
							
								if !is_undefined(newHostId) //there has been a host change
								{
									if newHostId != ""
									{
										//show_message("New host id received is: "+newHostId)
										
										hostId = newHostId
										
										if hostId = playerId //we've become the new host
										{
											//show_message("Become new host")
											isHost = true
											scrCreateHostButtons()
											displayMsg += "You are now the new host.\n\n"
										}
										else
										{
											displayMsg += scrFindPlayerNameById(newHostId, false)+" has become the new host.\n\n"
										}
									}
								}
							
								if phase >= gamePhase.writingStatements
								{
									if pLeftCount >= 2
									displayMsg += "The game will continue with fewer players."
									else
									{
										displayMsg += "Not enough players to continue, so the game will end."
										scrMakeRoomDataGetRequest()
									}
								}
							
								scrDisplayNotification(displayMsg,2,120,60)
							}
							
							scrMakeGetPlayerDataRequest() //check the updated player data
						}
					}

				}
				else
				{
					if debugPopUpsOn
					show_message("400 not ok")
				}
				
				break

//401 (Someone reconnects)
				case 401:
				if status = "OK"
				{
					var messageMap = resultMap[? "message"]
					var reconnectedPlayerName = messageMap[? "reconnectedPlayerName"]
					
					if !is_undefined(reconnectedPlayerName)
					{
						var reconnectedPlayerId = messageMap[? "reconnectedPlayerId"]
						
						if reconnectedPlayerId != playerId //don't display this notification if it's us who reconnects, as we can see that without messages
						scrDisplayNotification(reconnectedPlayerName + " has reconnected.",2,60,60)
					}
				}
				else
				{
					if debugPopUpsOn
					show_message("401 not ok")
				}
				break
				
//402 (A new player joins in the score phase)
				case 402:
				if status = "OK"
				{
					if phase = gamePhase.showingScores //only display this message during the score phase for now
					{
						rebuildScoreboard = true
						var messageMap = resultMap[? "message"]
						var joiningPlayerName = messageMap[? "joiningPlayerName"]
					
						if !is_undefined(joiningPlayerName)
						{
							var joiningPlayerId = messageMap[? "joiningPlayerId"]
						
							if joiningPlayerId != playerId //don't display this notification if it's us who reconnects, as we can see that without messages
							scrDisplayNotification(joiningPlayerName + " has joined the game.",2,60,60)
						}
					}
				}
				else
				{
					if debugPopUpsOn
					show_message("402 not ok")
				}
				break
				
			} //switch (opCode)
		} //opCode is defined
		

		
		//show_message("reply to opCode "+string(opCode))
		
		//ownConnectionId = resultMap[? "connectionId"]
		
		
		break;//*/
		
		
	} //switch ev_type
	
}