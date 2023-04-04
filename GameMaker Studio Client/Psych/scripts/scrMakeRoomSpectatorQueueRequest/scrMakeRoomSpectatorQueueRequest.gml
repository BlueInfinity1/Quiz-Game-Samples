with objGameController
{
	if isSpectator
	{
		requestId = scrAddWebsocketRequest(202)
		lastRequestTimes[202] = current_time
	
		roomSpectatorQueueMessage =
		"{\"action\": \"message\", \"op\": 202, \"requestId\": \"" +requestId+"\", \"roomId\": \""+roomId+"\",\"sessionId\": \""+sessionId+"\","
		+"\"playerId\": \""+playerId+"\"}"

		//show_message(roomDataStoreMessage)

		web_socket_send(0,roomSpectatorQueueMessage) //trigger the message route
	}
}

