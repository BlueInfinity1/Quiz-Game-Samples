with objGameController
{
	var requestId = scrAddWebsocketRequest(103)
	lastRequestTimes[103] = current_time
	
	existenceCheckMessage =
	"{\"action\": \"message\", \"op\": 103, \"requestId\": \"" +requestId+"\",\"roomId\": \""+roomId+"\", \"playerId\": \""+playerId+"\"}"
		
	//if debugPopUpsOn
	//show_message("check existence: "+existenceCheckMessage)
		
	web_socket_send(0,existenceCheckMessage) //trigger the message route
}
