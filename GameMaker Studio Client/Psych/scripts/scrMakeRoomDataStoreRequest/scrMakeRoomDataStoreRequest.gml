with objGameController
{
	//NOTE: This will only be done if the room item is not defined, so we assume that this call will be sent
	//by the original host. That's why we can use playerId here
	{
		requestId = scrAddWebsocketRequest(201)
		lastRequestTimes[201] = current_time
	
		roomDataStoreMessage =
		"{\"action\": \"message\", \"op\": 201, \"requestId\": \"" +requestId+"\", \"roomId\": \""+roomId+"\",\"sessionId\": \""+sessionId+"\","
		+"\"playerId\": \""+playerId+"\", \"roomPhase\": \""+argument0+"\"}"


		//show_message(roomDataStoreMessage)

		web_socket_send(0,roomDataStoreMessage) //trigger the message route
	}
}

