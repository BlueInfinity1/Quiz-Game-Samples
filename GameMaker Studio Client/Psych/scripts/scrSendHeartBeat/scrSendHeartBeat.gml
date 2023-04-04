with objGameController
{
	if !isSpectator and lastInteractTime > current_time - interactionHeartBeatThreshold
	{
		heartBeatMessage = 
		"{\"action\": \"message\", \"op\": 106, \"roomId\": \""+roomId+"\",\"playerId\": \""+playerId+"\"}"
		//getRoomHostRequest = http_get(requestUrl+"?op=200&roomId="+roomId+"&sessionId="+sessionId)
		//show_message("get room host")
	
		//if debugPopUpsOn
		//show_message("Heart beat send")
	
		//NOTE: No storing request
	
		web_socket_send(0,heartBeatMessage)
	}
}

//http_get(requestUrl+"?op=106&roomId="+roomId+"&sessionId="+sessionId+"&playerId="+playerId)