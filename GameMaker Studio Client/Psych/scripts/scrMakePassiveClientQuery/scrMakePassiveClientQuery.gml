with objGameController
{
	var requestId = scrAddWebsocketRequest(105)
	lastRequestTimes[105] = current_time
	
	passivityCheckMessage =
	"{\"action\": \"message\", \"op\": 105, \"requestId\": \"" +requestId+"\",\"roomId\": \""+roomId+"\", \"playerId\": \""+playerId+"\"}"
	
	if debugPopUpsOn
	show_message(passivityCheckMessage)
	
	web_socket_send(0,passivityCheckMessage)
}