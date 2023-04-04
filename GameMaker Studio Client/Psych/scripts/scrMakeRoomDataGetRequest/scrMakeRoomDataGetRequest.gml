with objGameController
{
	var requestId = scrAddWebsocketRequest(200)
	lastRequestTimes[200] = current_time
	
	roomDataGetMessage = 
	"{\"action\": \"message\", \"op\": 200, \"requestId\": \"" +requestId+"\",\"roomId\": \""+roomId+"\",\"sessionId\": \""+sessionId+"\"}"
	
	if debugPopUpsOn
	show_message(roomDataGetMessage)
	
	web_socket_send(0,roomDataGetMessage)
}