/// @description Insert description here
// You can write your code in this editor

//show_message("awake")

//for drawing the crown on top of the player icons
crownXOff = -3
crownYOff = -8

globalvar players, playerArraySize, requestUrl, soundOn, endPointUrl, debugModeOn,
visibleContainerPlayersWithoutScrolling;

visibleContainerPlayersWithoutScrolling = 7

totalCategories = 9
chosenCategory = -1 //only the host can change this

categoryNames[0] = "Word Up!"
categoryNames[1] = "The Plot Thickens"
categoryNames[2] = "Poetry"
categoryNames[3] = "Say my Name"
categoryNames[4] = "Movie Bluff"
categoryNames[5] = "Proverbs"
categoryNames[6] = "Adults Only"
categoryNames[7] = "Is that a fact?"
categoryNames[8] = "It's the Law"

currentCategoryName = ""
currentCategoryId = -1

scoreTextXOff = 7
scoreTextYOff = 2


endPointUrl = //"wss://7qk4zv6xvj.execute-api.ap-south-1.amazonaws.com/Prod"
"wss://prdbsu4a5l.execute-api.ap-south-1.amazonaws.com/dev"

maxPlayers = 20 //15

//the idea is that for every websocket action we take, we expect a reply (except maybe for the heartbeat, which
//gets sent every x secs anyway and thus doesn't need a retry mechanism)

lastInteractTime = 0 //the last time we've interacted with the game.
interactionHeartBeatThreshold = 10*1000 //we must have interacted in the past 10 seconds, or else a heartbeat will not get sent
prevMouseX = -1
prevMouseY = -1
idleDisconnectionWarningTime = 70*1000 //warn the player before the server disconnects him, at ds time - 20 secs
idleDisconnectionTime = 90*1000 //NOTE! This is used only for disconnect messages and not the actual disconnecting! Has to match
//the value on the server
idleDisconnectionWarningShown = false

lastRequestTimes[100] = 2147483647 //this would be enough milliseconds to cover for 24 days, a time no one will keep this game open
lastRequestTimes[101] = 2147483647
//lastRequestTimes[102] = -1//2147483647 //NOT IN USE
lastRequestTimes[103] = 2147483647
lastRequestTimes[104] = 2147483647
lastRequestTimes[105] = 2147483647
//lastRequestTimes[106] = -1//again, skipping 106

lastRequestTimes[200] = 2147483647
lastRequestTimes[201] = 2147483647
lastRequestTimes[202] = 2147483647

//20
getPlayerDataRequestSafetyInterval = 10*1000
requestSafetyInterval = 20*1000 //how many milliseconds to wait before we reinitiate a request that has not yet
//received a reply
webSocketRequests = ds_map_create()

//for every op code, create a ds_list that stores all the requests we've made
webSocketRequests[? 100] = ds_list_create()
webSocketRequests[? 101] = ds_list_create()
webSocketRequests[? 102] = ds_list_create()
webSocketRequests[? 103] = ds_list_create()
webSocketRequests[? 104] = ds_list_create()
webSocketRequests[? 105] = ds_list_create()
//NOTE: 106 / heartbeat skipped
//webSocketRequests[? 107] = ds_list_create()

webSocketRequests[? 200] = ds_list_create()
webSocketRequests[? 201] = ds_list_create()
webSocketRequests[? 202] = ds_list_create()
//ops 300 and 400 can't really be detected, as they are pushed to us and we can't know to await them

players = array_create(maxPlayers)

soundOn = true
debugModeOn = false //false
debugPopUpsOn = false //false
debugNamingOn = false
pressTimer = 0

if debugModeOn
soundOn = false

canProceedToAnswerViewingPhase = false
//canProceedToScoresPhase = false

questionTextSize = 1

isHost = true //true
isSpectator = false
canSendOwnData = true 

//map playerIds to truths and lies
globalvar answerMap, pointMap, scoreIncreasedMap, guessCountMap, psychedPlayerList;
answerMap = ds_map_create()
pointMap = ds_map_create()
//scoreIncreasedMap = ds_map_create()
guessCountMap = ds_map_create() //guess count for each guess Id
psychedPlayerList = ds_list_create()
finalAnswerIdList = ds_list_create() //used to sort the answers in the viewing phase

globalvar viewingRules;
viewingRules = false

enum playerData
{
	pId,
	pName,
	pShortName,
	pImageUrl,
	statementsWritten,
	selectedGuessId,
	totalPoints,
	scoreIncreased,
	isDead,
	isReadyForNextRound
}

enum gamePhase
{
	showingRules, //NOT IN USE
	selectingCategory,
	initializing,
	waitingForPlayers,
	writingStatements,
	
	waitingForStatements,
	guessingStatements,
	waitingForGuesses,
	waitingForResults,
	preparingToShowResult,
	
	showingResults,
	viewingAnswers, 
	showingScores,
	waitingForRematch,
	roundFinished
}

enum dataRequest //determines what data we'll be looking for in the data request
{
	basicInfo,
	hostReady,
	statements,
	chosenGuess,
	readyState
}

textAddition = ""

connTimer = 0

phase = gamePhase.initializing

for (var i = 0; i < maxPlayers; i++)
players[i,playerData.pImageUrl] = "null" //not set

playerImages = ds_map_create()
imageRequests = ds_map_create()
imageLoadAttempts = ds_map_create()
playerImageSurfaces = ds_map_create()
playerImageSurfaces35p = ds_map_create()

notificationTimer = 0
notificationMessage = ""
notificationAlpha = 1
notificationScale = 0

heartBeatCounter = 0 //for debugs

localResultTimerOn = false

if !debugModeOn
localResultTimerDuration = 5*1000 
else
localResultTimerDuration = 1*1000

localResultTimerStartTime = -1



//this will be used to send data at regular intervals to make the server know we're alive
heartBeatTimerOn = false
heartBeatTimerDuration = 30*1000 //60
heartBeatTimerStartTime = -1

rankOrder = ds_list_create()
completeRankOrdersWithNames = ds_list_create()
//completeRankOrdersWithImages = ds_list_create()
sortedScoreList = ds_list_create()

allRoundsFinished = false
yourFakeAnswer = ""

roomId = "111"     //"12323"
sessionId = "1"
//"e1c4e6dd-b5f7-428f-9c8c-21938c3dfc30" <- Use this after the game goes live

//if os_browser = browser_not_a_browser
//randomize() //we randomize here, b ut later set seed if using windows

random_set_seed(0)

playerId = scrGeneratePlayerId() //placeholder "ABC" "FFFFFFFFF"
playerName = scrGeneratePlayerId()//"Eric"
playerCount = 1 //Changed later depending on how much data we fetch from the server
prevPlayerCount = 1
playerArraySize = 1
playerImage = -4

lastPlayerDataGetTime = current_time
dataCheckTimeThreshold = 20*1000//if we haven't gotten any data in this many milliseconds, try get player data as a safety net

canDisplayDisconnectMessage = false
lastConnOpenAttemptTime = current_time
canDisplayDisconnectMessageThreshold = 3*1000 //current ws connection must've been open for at least x secs before we can display the message

reconnectionTime = 3*room_speed //attempt a new connection 

if debugNamingOn
{
	randomize()
	playerId = scrGeneratePlayerId()
	playerName = choose("John", "Steven", "Graham", "Jack", "Emily", "Tina", "Jill", "Helen", "Anna", "Jack")
	roomId = choose("123","456")
	sessionId = choose("1","2")
}


imageLoadMaxAttempts = 3

hostImageSize = 76//76
playerImageSize = 25//60

debugRoundMsg = ""


imageUrl = "null"

if os_browser != browser_not_a_browser
{
	var p_num, p_string, paramKey, paramVal;
	p_num = parameter_count();

	if p_num > 0
	{
		var i;
		for (i = 0; i < p_num; i += 1)
		{
			p_string[i] = parameter_string(i + 1);
			
			//show_message(p_string[i])
			
			//split param into two values
			paramKey = string_copy(p_string[i],1,string_pos("=",p_string[i])-1)
			paramVal = string_copy(p_string[i], string_pos("=",p_string[i]) +1, 
				string_length(p_string[i]) - string_length(paramKey)+1)
			
			//show_message("paramKey: "+string(paramKey) + ", paramVal: "+string(paramVal))
			
			//assuming these are fetched in the order of supplying
			switch (paramKey)
			{
				case "roomId":
				roomId = paramVal
				break
				
				case "sessionId":
				sessionId = paramVal
				break
				
				case "userId":
				playerId = paramVal
				break
				
				case "userName":
				playerName = paramVal
				break
				
				case "userProfilePic":
				{
					imageUrl = paramVal //can be "null" if no image supplied
				}
				break
				
				case "isHost":
					if paramVal = "true" or paramVal = "1"
						isHost = true
					else
					isHost = false
					break
				
			}			
		}
	}
}

playerName = decodeURIString(playerName) //"Geo%20Gambel"

//show_message("pName before decoding: "+playerName + ", after: "+decodeURIString(playerName))

//DEBUG
//imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT2_ofdtFV7VBXo0ie1nNmcSoCIBeHAf4jz2w&usqp=CAU"

//"https://sb-content-file.s3-ap-northeast-1.amazonaws.com/smallbridge_favicon.png"
//"https://st2.depositphotos.com/3910205/9614/i/950/depositphotos_96141134-stock-photo-flower-rose-closeup-isolated-on.jpg"
//"null"

//show_message("imageUrl is "+imageUrl)

//randomize()
//roomId = scrGeneratePlayerId()

//show_message("roomId "+roomId)

//if playerId = "9E84C16" //
//debugPopUpsOn = true //*/

//ownConnectionId = ""
ownName = playerName
ownId = playerId

sliderPosX = 830
sliderPosY = 220

//OP codes: 100 - send own data, 101 - get player data

scrInitializeCreationVariables() //as a script since this will also be used with disconnections

notReadyMarkerRotation = 0

pollingInterval = room_speed*2 //poll the server for updates every 2 secs when needed
//NOTE: The interval depends on the game phase
web_socket_open(0,endPointUrl,-1, false);
alarm[0] = 5//move to waiting that we have a connection*/
scrInitialize()

instance_create_layer(room_width - 60, room_height - 25, "Top_Instances",objRuleButton)
forcedRulePopUpShown = false

//RANK ORDER DEBUG TESTING

/*players[0, playerData.pId] = "1"
players[1, playerData.pId] = "2"
players[2, playerData.pId] = "3"
players[3, playerData.pId] = "4"
players[4, playerData.pId] = "5"
players[5, playerData.pId] = "6"
players[6, playerData.pId] = "7"
players[7, playerData.pId] = "8"

players[0, playerData.pShortName] = "Y"
players[1, playerData.pShortName] = "T"
players[2, playerData.pShortName] = "P"
players[3, playerData.pShortName] = "A"
players[4, playerData.pShortName] = "G"
players[5, playerData.pShortName] = "B"
players[6, playerData.pShortName] = "Z"
players[7, playerData.pShortName] = "er"

rankOrder[|0] = 3
rankOrder[|1] = 1
rankOrder[|2] = 0
rankOrder[|3] = 2
rankOrder[|4] = 3
rankOrder[|5] = 1
rankOrder[|6] = 0
rankOrder[|7] = 0

rankString = ""
playerCount = 8
playerArraySize = 8
for (var currRank = 0; currRank < playerCount; currRank++)
{
	//store these for each row of the grid: pId, pName, score, then sort based on the name
	//note that the scores for each rank entry is the same, but this is just for the easy of using
	//a single grid to get the data
	completeRankOrdersWithNames[|currRank] = ds_grid_create(0,0) 
	//var currPlayerId = players[i,playerData.pId]
	for (var j = 0; j < playerArraySize; j++)
	{
		if rankOrder[|j] = currRank
		{
			var currGridHeight = ds_grid_height(completeRankOrdersWithNames[|currRank])
			ds_grid_resize(completeRankOrdersWithNames[|currRank],2, currGridHeight + 1)
			//show_message(ds_grid_width(completeRankOrdersWithNames[|currRank]))
			//show_message(ds_grid_height(completeRankOrdersWithNames[|currRank]))
			
			ds_grid_add(completeRankOrdersWithNames[|currRank],0, currGridHeight,players[j, playerData.pId])
			ds_grid_add(completeRankOrdersWithNames[|currRank],1, currGridHeight,players[j, playerData.pShortName])
			
			//ds_grid_add(completeRankOrdersWithNames[|currRank],0,0,"A")
			//show_message(ds_grid_get(completeRankOrdersWithNames[|currRank],0,0))
			//show_message(currGridHeight)
			//"Added to rank "+string(currRank) + ": "+
			//show_message("Added to rank "+string(currRank) + ": "+ds_grid_get(completeRankOrdersWithNames[|currRank],1,currGridHeight))
			//ds_grid_add(completeRankOrdersWithNames[|currRank],2, currGridHeight-1,pointMap[? players[j, playerData.pId]])
		}
	}
	//alphabetically sort each sublist
	ds_grid_sort(completeRankOrdersWithNames[|currRank],1,true)

	rankString += string(currRank) + " - "
	for (var k = 0; k < ds_grid_height(completeRankOrdersWithNames[|currRank]); k++) //DEBUG
	{
		rankString += (string(ds_grid_get(completeRankOrdersWithNames[|currRank],0,k))+ "-" + string(ds_grid_get(completeRankOrdersWithNames[|currRank],1,k)) + ", ")
		//show_message("Rank "+string(currRank) + " contains " + ds_grid_get(completeRankOrdersWithNames[|currRank],1,k))
	}
	rankString += "\n"
	
} //DEBUG

show_message(rankString)
exit//*/