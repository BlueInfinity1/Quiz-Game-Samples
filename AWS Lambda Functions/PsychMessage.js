const AWS = require('aws-sdk');
const axios = require('axios');
AWS.config.update({region: "ap-south-1"});
const documentClient = new AWS.DynamoDB.DocumentClient({region: "ap-south-1"});

var deletionThreshold = 86400; //How many seconds have to pass after the last heartbeat received from the player, before the database cleans up player data entry
var idleThreshold = 90; //a client who has not sent any data or heartbeats for this many seconds is deemed idle and the game will continue without this player

const questionTable = "PsychQuestions";

//MOCK DEV VARIABLES
const playerTable = "PsychPlayersDev";
const sessionTable = "PsychRoomSessionsDev";

//NOTE: All of the below are mock values
const APPID = "dappcb7dd168bd834343bc21f8b7120ce759";
const APP_SECRET_KEY = "13baa294833e7df54cf714ddd04fcad4b61d2547b54104f826ad4dc15bd9342a"; 
const DEVELOPER_API_URL = "https://mock/"+APPID+"/leaderboard/save/"; //Mock url

var apiGatewayManagementApi;
let totalQuestions = new Array();

exports.handler = async (event) => {
  
  apiGatewayManagementApi = new AWS.ApiGatewayManagementApi(
    {
    apiVersion: '2018-11-29',
    endpoint: event.requestContext.domainName + '/' + event.requestContext.stage
  });
  
  const connId = event.requestContext.connectionId;
  const body = JSON.parse(event.body);
  
  const opCode = body.op;
  const reqId = body.requestId;
  
  const roomId = body.roomId;
  const sessionId = body.sessionId;
  const playerId = body.playerId;
  const playerName = body.playerName;
  const playerImage = body.playerImage;
  const writtenAnswer = body.writtenAnswer;
  const chosenGuess = body.chosenGuess;
  const isReadyForGuessing = body.isReadyForGuessing;
  const isReadyForScores = body.isReadyForScores;
  const isReadyForNextRound = body.isReadyForNextRound;
      
  switch (opCode)
  {    
    //NOTE: Many opCodes have been removed, since this is only a code sample.

    case (100): //store up-to-date player data to the database
    {
      try
      {
        const postData = await storePlayerData(connId, roomId, sessionId, playerId, playerName, playerImage, writtenAnswer, chosenGuess, isReadyForScores, isReadyForGuessing, isReadyForNextRound);
              
        await postDataToClients(roomId, sessionId, postData, 300); //post updated data of this player to all clients in the same room and session
        return sendResponse(200,{op: opCode, requestId: reqId, status: "OK", message: "Player data stored successfully and clients informed"});
      }
      catch (err)
      {
        return sendResponse(500, {op: opCode, requestId: reqId, status: "ERROR", error: "Put and inform operation (100) error: " + err.stack});
      }
    }
    
    case (103): //get info whether our player record exists
    {
      try {
        let pExists;
        const playerData = await getPlayerData(roomId, playerId);
        
        if (playerData.Item != undefined)
        pExists = true;
        else
        pExists = false;
        
        return sendResponse(200,{op: opCode,  requestId: reqId, status: "OK", message: {playerExists: pExists}});
      }
      catch (err) {
        return sendResponse(500,{op: opCode,  requestId: reqId, status: "ERROR", error: "Player existence check (103) error: " + err.stack});
      }
    }
    
    case (104):  //get data about whether the host has started the game
    {
      try {
        const roomPhaseData =  await getRoomPhase(roomId,sessionId);
        
        if (roomPhaseData.Item != undefined)
        {
          let gameStarted = roomPhaseData.Item.roomPhase != "init" ? true : false;          
          return sendResponse(200,{op: opCode,  requestId: reqId, status: "OK", message: gameStarted});
        }
        else
          return sendResponse(200,{op: opCode,  requestId: reqId, status: "OK", message:false});
      }
      catch (err) {
        return sendResponse(500,{op: opCode,  requestId: reqId, status: "ERROR", error: "Host data fetch (104) error: " + err.stack});
      }
    }
    
    case (105): //check whether a player is passive or not
    {
      try {
        
        let isPlayerPassive;
        let pExists;
        const playerData = await getPlayerData(roomId, playerId);
      
        if (playerData.Item == undefined)
        {
          pExists = false;
          isPlayerPassive = true; //if our record doesn't exist, then we've just joined recently, so we are deemed passie in the game phase recovery
        }
        else
        {
          pExists = true;
          
          if (playerData.Item.lastHeartBeatTime != undefined)          
            isPlayerPassive = (getCurrentEpochTime() - idleThreshold > playerData.Item.lastHeartBeatTime);          
          else
            isPlayerPassive = false;
        }
        
        return sendResponse(200,{op: opCode,  requestId: reqId, status: "OK", message: {isPassive: isPlayerPassive, playerExists: pExists}});
      }
      catch (err) {
        return sendResponse(500,{op: opCode,  requestId: reqId, status: "ERROR", error: "Error checking player passivity (105): " + err.stack});
      }
    }
  
    case (106): //store heartbeat, i.e. only update the lastHeartBeatTime of a player
    {
     try {
      const playerData = await getPlayerData(roomId, playerId); //do the existence check in order to prevent removed players from sending heartbeat updates
      
      //The pExists check is a safeguard for situations where we get a delayed heartbeat message but can't accept it. The player should always have sessionId
      //stored. If this is not the case, then it must be that we've received a stray heartbeat and can't accept it.
      let pExists = (playerData.Item.sessionId != undefined); 
      
      if (pExists)
      {
        await updateLastHeartBeatTime(roomId,playerId);
        return sendResponse(200,{op: opCode, requestId: reqId,  status: "OK", message: {isAlive: true}});
      }
      else      
        return sendResponse(200,{op: opCode, requestId: reqId,  status: "OK", message: {isAlive: false}});      
     }
     catch (err) {
       return sendResponse(500,{op: opCode, requestId: reqId, status: "ERROR", error: "Registering heartbeat error (106)" + err.stack});
     }
    }
    
    default:
    {
      return sendResponse(400, {op: opCode, status: "ERROR", error: "No matching op code"}); //bad request
    }
  } //switch
}; //exports.handler

//
async function postScores(sessionId, playerData)
{
  let scorecardBody = new Array();
  
  //Go through playerData.Items and pick the player's id and points
  for (const item of playerData.Items)
  {
    scorecardBody.push(
      {
  			"userid":item.playerId,
  			"score": item.points
  		}
  	);
  }
  
  try
  {
    let response = await axios.post(DEVELOPER_API_URL, {
      sessionid: sessionId,
      scores: scorecardBody
    }, {
        headers: {
          'X-APP-ACCESS-SECRET': 'Token ' + APP_SECRET_KEY
        }
      }
    );
  }
  catch (e)
  {
    console.log("Could not post scores: "+e);
  }
}

async function makeSmallPlayerUpdates(roomSessionPlayerData,updateExpression,expressionAttributes)
{
  for (const item of roomSessionPlayerData.Items)
  {
    let playerUpdateParams = {
      TableName: playerTable,
      Key: {
        roomId: item.roomId,
        playerId: item.playerId
      },
      UpdateExpression: updateExpression,
      ExpressionAttributeValues: expressionAttributes
    };
    try {
      await documentClient.update(playerUpdateParams).promise();
    }
    catch (err) {
      console.log("Error updating the player readiness states: "+ err);
    }
  }
}

async function makeSmallSinglePlayerUpdates(roomId,playerId,updateExpression,expressionAttributes)
{
  let playerUpdateParams = {
      TableName: playerTable,
      Key: {
        roomId: roomId,
        playerId: playerId
      },
      UpdateExpression: updateExpression,
      ExpressionAttributeValues: expressionAttributes
    };
    
  try {
    await documentClient.update(playerUpdateParams).promise();
  }
  catch (err) {
    console.log("Error updating single player attributes: " + err);
  }
}

/*updateRoomPhase handles updating the game state whenever new data is provided from the players, e.g. when they have submitted an answer for a question or clicked a button to signal that they are ready.
The rough idea is that we have states "init", "writing", "guessing", "answers", "scores" and "resetting", which are used to determine which player variables we should observe to proceed to the next phase.
For example, we can't proceed from "writing" to the "guessing" phase before all players have written their answers, so we must observe the "isReadyForGuessing" flag for each player. The client will
send a trigger to activate this flag once the player has pressed the "Submit" button in the question writing phase.
*/
async function updateRoomPhase(roomId, sessionId)
{
  try {
    let roomSessionPlayerData = await getAllPlayerData(roomId,sessionId);      
    const roomSessionData = await getRoomSessionData(roomId,sessionId);
    let currentRoomPhase = roomSessionData.Item.roomPhase;      
    let roomSessionPlayerCount = roomSessionPlayerData.Count;

    let phaseToUpdateTo = null;
    let updateExpression;
    let expressionAttributes;
    
    if (roomSessionPlayerCount <= 1) //if we have 0 or 1 players, we can't advance the room phase
    {
      phaseToUpdateTo = "init"; //go back to beginning of the game, since the game can't continue
      currentRoomPhase = "resetting";
    
      //for all the remaining players, nullify all the trigger variables which are used to progress the game state, since the game will start over
      await makeSmallPlayerUpdates(roomSessionPlayerData,"set chosenGuess = :cg, points = :pt, scoreIncreased = :sci, isReadyForGuessing = :ir, isReadyForNextRound = :isrn, hasStartedGame = :hs, hasEndedGame = :he",
            {":cg": "-1", ":pt": 0, ":sci": false, ":isrn": false, ":ir": false , ":hs": false, ":he": false});
    }
    
    switch (currentRoomPhase)
    {
      //In this phase, we wait for the host to press the "Start Game" button
      case ("init"):
      {
        const hostData = await getPlayerData(roomId, roomSessionData.Item.hostId);
        
        if (hostData.Item != undefined) //host data may be undefined if someone else joins before the host
        {
          let currentRoomCategory = roomSessionData.Item.categoryId;
          
          if (currentRoomCategory == -1 && hostData.Item.chosenCategory != -1)
          {
            phaseToUpdateTo = "init";
            expressionAttributes = {":cat": hostData.Item.chosenCategory};
            updateExpression = "set categoryId = :cat";
          }
          else if (hostData.Item.hasStartedGame)
          {
            const playerIds = new Array();
            roomSessionPlayerData.Items.forEach((item) => {playerIds.push(item.playerId)});
            let nextQuestionData = await getNextQuestionData(hostData.Item.chosenCategory);
                                    
            //outside the switch, update the room phase with this update expression and attributes
            phaseToUpdateTo = "writing";
            expressionAttributes = {":rP": phaseToUpdateTo, ":rn": 0, ":spl": playerIds, ":cq": nextQuestionData.question, ":ca": nextQuestionData.answer, ":cat": hostData.Item.chosenCategory};
            updateExpression = "set roomPhase = :rP, roundNumber = :rn, startingPlayerList = :spl, currentQuestion = :cq, currentAnswer = :ca, categoryId = :cat";
            
            //initialize the control variables for each player record before starting the round
            await makeSmallPlayerUpdates(roomSessionPlayerData,"set chosenGuess = :cg, answer = :ans, points = :pt, scoreIncreased = :sci, hasStartedGame = :hs",
              {":cg": "-1", ":ans": "", ":sci": false, ":hs": false, ":pt": 0});
          }
        }
        break; 
      }
      
      //To proceed from this phase, we must wait that all players have written and submitted their answers
      case ("writing"):
      {
        let statementsWrittenCount = 0;
        roomSessionPlayerData.Items.forEach((item) => {
          if (item.isReadyForGuessing)
          statementsWrittenCount++;
        });
                
        if (statementsWrittenCount == roomSessionPlayerCount) //all players are ready
        {
          let arrayToBeShuffled = new Array(); //will have 1 answer per player + 1 correct answer
          let fakeAnswers = new Array();
          
          //We will use two arrays: arrayToBeShuffled will determine the order in which the answers will be displayed to the players. The id of no player can be "0", since this is reserved to be the 
          //marker of the correct answer. fakeAnswers stores the actual written answers and the id of the player who wrote it. These will be used together in the client to display the questions.
          arrayToBeShuffled.push("0");
          
          roomSessionPlayerData.Items.forEach((item) => {
            arrayToBeShuffled.push(item.playerId);
            fakeAnswers.push({playerId: item.playerId, answer: item.answer}); //put everyone's fake answer to the room data
          });
          
          phaseToUpdateTo = "guessing";
          updateExpression = "set roomPhase = :rP, shuffleOrder = :sO, fakeAnswers = :fA";
          expressionAttributes = {":rP": phaseToUpdateTo, ":sO": shuffle(arrayToBeShuffled),":fA": fakeAnswers};
          
          //Starting guessing phase, all player guesses which may have been left over from the previous round will be nullified
          await makeSmallPlayerUpdates(roomSessionPlayerData,"set chosenGuess = :cg, scoreIncreased = :sci, hasStartedGame = :hs", {":cg": "-1", ":sci": false, ":hs": false});                      
          await makeSmallSinglePlayerUpdates(roomId, roomSessionData.Item.hostId,"set isReadyForScores = :rs", {":rs": false});
        }
        break;
      }
      
      //In this phase, all players must have selected their guess before we can proceed
      case ("guessing"):
      {
        let guessChosenCount = 0;
        
        roomSessionPlayerData.Items.forEach((item) => {        
          if (item.chosenGuess != "-1")
          guessChosenCount++;
        });
                        
        if (guessChosenCount == roomSessionPlayerCount) //all players of the session have made their guesses
        {
          phaseToUpdateTo = "answers";
          updateExpression = "set roomPhase = :rP";
          expressionAttributes = {":rP": phaseToUpdateTo};
                    
          let scoreAdditions = new Array();
          
          //for each player, we calculate the score for this round
          for (const item of roomSessionPlayerData.Items)          
            scoreAdditions[item.playerId] = 0;          
          
          for (const item of roomSessionPlayerData.Items)
          {
            if (item.chosenGuess == "0") //the player chose the correct answer, so increase the score
              scoreAdditions[item.playerId] += 10;
            else //chose wrong guess, so increase score of whoever wrote the answer and was able to fool this player
            {
              console.log(item.playerId + " guessed the answer of " + item.chosenGuess + ", giving +10 points to the latter");
              scoreAdditions[item.chosenGuess] += 10;
            }
          }
          
          //update the scores
          for (const item of roomSessionPlayerData.Items)
          {            
            const scoreUpdateParams = {
              TableName: playerTable,
              Key: {
                roomId: item.roomId,
                playerId: item.playerId
              },
              UpdateExpression: "set points = :pts, scoreIncreased = :sci",
              ExpressionAttributeValues: {":pts": item.points+scoreAdditions[item.playerId], ":sci": true}
            };
              
            await documentClient.update(scoreUpdateParams).promise();
          }
          await postScores(sessionId,roomSessionPlayerData);
        }
        break;
      }
            
      //NOTE: Cases "answers" and "scores" have been left out, as this is just a sample

      case ("resetting"):
      {
        expressionAttributes = {":rP": phaseToUpdateTo, ":rn": 0, ":cat": -1};
        updateExpression = "set roomPhase = :rP, roundNumber = :rn, categoryId = :cat";
        break;
      }
      
    } //switch
    
    if (phaseToUpdateTo != null) //phase has changed
    {      
      const roomPhaseUpdateParams = {
        TableName: sessionTable,
          Key: {
            roomId: roomId,
            sessionId: sessionId
          },
          UpdateExpression: updateExpression,
          ExpressionAttributeValues: expressionAttributes
      };
            
      await documentClient.update(roomPhaseUpdateParams).promise();      
      return true; //room changed
    }
    else
    return false;
    
  }
  catch (err)
  {    
    throw err;
  }
}

async function postDataToClients(roomId, sessionId, postData, op)
{
  //Once we've updated records, inform all clients about the updated data
  //get all connectionIds for the given session
  const connectionIdList = await getPlayerConnectionIds(roomId, sessionId);
    
  //use API Gateway management system to post data to the clients
  const postCalls = connectionIdList.Items.map(async ({ connectionId, roomId, playerId }) => {
    try {
      await apiGatewayManagementApi.postToConnection({ ConnectionId: connectionId, Data: JSON.stringify({op: op, status: "OK", message: postData}) }).promise();
    } 
    catch (e) {
      if (e.statusCode === 410) {
        console.log(`A stale connection found: ${connectionId}, for player ${roomId} / ${playerId}`);
      } else {
        throw e;
      }
    }
  });

  try {
    await Promise.all(postCalls);
  } 
  catch (err) {    
    throw err;
  }
}

async function updateLastHeartBeatTime(roomId,playerId)
{
   const params = {
      TableName: playerTable,
      Key: {
          "roomId": roomId,
          "playerId": playerId
      },
      UpdateExpression: "set lastHeartBeatTime = :ts, deletionTime = :dt",
      ExpressionAttributeValues:{
        ":ts": getCurrentEpochTime(),
        ":dt": getCurrentEpochTime() + deletionThreshold
      },
      ReturnValues: "NONE"
  };
  
  try {
    return documentClient.update(params).promise();
  }
  catch (err) {
    throw err;
  }
}

async function getPlayerData(roomId,playerId)
{
    const params = {
        TableName: playerTable,
        Key: {
            roomId: roomId,
            playerId: playerId
        }
    };
    
    try {
      return documentClient.get(params).promise();
    }
    catch (err) {
      throw err;
    }
}

async function getAllPlayerData(roomId, sessionId, returnOnlyActives = true)
{
  let params;
  
  if (returnOnlyActives)
  {
    params = { //scan params
      TableName: playerTable,
      FilterExpression: "roomId = :thisRoomId AND sessionId = :thisSessionId AND lastHeartBeatTime > :idleLimit", //must be active players
      ExpressionAttributeValues : {
          ':thisRoomId' : roomId,
          ':thisSessionId': sessionId,
          ':idleLimit': getCurrentEpochTime() - idleThreshold
      }
    }; 
  }
  else //can also return passive players
  {
    console.log("Return all players, passives included");
  
    params = {
      TableName: playerTable,
      ConsistentRead: true,
      FilterExpression: 'roomId = :thisRoomId AND sessionId = :thisSessionId',
      ExpressionAttributeValues : {
          ':thisRoomId' : roomId,
          ':thisSessionId': sessionId,
      }
    };
  }
  
  try {
    //NOTE: We must scan to get strongly consistent reads, despite the fact that it's slow. However, this shouldn't be a problem since the player table will never grow too big
    return documentClient.scan(params).promise(); 
  }
  catch (err) {
    throw err;
  }
}
    
async function getRoomSessionData(roomId, sessionId)
{
  const params = {
      TableName: sessionTable,
      Key: {
          "roomId": roomId,
          "sessionId": sessionId
      }
  };
  try {
    return documentClient.get(params).promise();
  }
  catch (err) {
    console.log("Error getting data about a single room session: "+err);
    throw err;
  }
}

async function getRoomPhase(roomId, sessionId)
{
    const params = {
        TableName: sessionTable,
        Key: {
            roomId: roomId,
            sessionId: sessionId,
        },
        AttributesToGet: ["roomPhase"]
    };
    
    try {
      return documentClient.get(params).promise();
    }
    catch (err) {
      console.log("Error getting roomPhase data: "+err);
      throw err;
    }
}

async function getPlayerConnectionIds(roomId, sessionId)
{
  const params = {
        TableName: playerTable,
        IndexName: "roomId-sessionId-index",
        KeyConditionExpression: 'roomId = :thisRoomId AND sessionId = :thisSessionId',
        ExpressionAttributeValues: {
            ':thisRoomId' : roomId,
            ':thisSessionId': sessionId
        },
        ProjectionExpression: "playerId, roomId, connectionId"
    };
    try
    {
      return documentClient.query(params).promise();
    }
    catch (err)
    {
      console.log("Error getting all player connections: "+err);
      throw err;
    }
}

// Create a response
function sendResponse(statusCode, message) {
  return {
    "statusCode": statusCode,
    "body": JSON.stringify(message)
  };
}

//HELPER FUNCTIONS
function sortByTimeStamp(a, b, ascending = true) 
{
  if (a.creationTime < b.creationTime)   
    return -1;
  else 
    return 1;
}

function getCurrentEpochTime()
{
    var d = new Date();
    return Math.floor( d / 1000 );
}

function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    let j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

async function getNextQuestionData(categoryId)
{
  //questions per each category
  for (let i = 0; i < 9; i++)
  {
    if (i != 2)
    totalQuestions[i] = 100;
    else
    totalQuestions[i] = 67; //67 questions in Poetry, which is the category with index 2
  }
  
  //Pulling the question data randomly from the correct category
  //NOTE: Math.random is somewhat limited pseudo-random number generator, but it's good enough for our purposes
  let randomQuestionId = 1 + Math.floor(Math.random()*totalQuestions[categoryId]);
  let questionData;
  
  const params = {
        TableName: questionTable,
        Key: {
            categoryId: categoryId,
            questionId: randomQuestionId
        }
    };
    
  try {
    questionData = await documentClient.get(params).promise();
  }
  catch (err) {
    throw err;
  }
  
  return {question: questionData.Item.question, answer: questionData.Item.answer};
}
