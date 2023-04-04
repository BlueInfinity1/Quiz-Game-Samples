with objGameController
{
	var requestId = scrAddWebsocketRequest(104)
	lastRequestTimes[104] = current_time

	readyDataGetMessage = 
	"{\"action\": \"message\", \"op\": 104, \"requestId\": \"" +requestId+"\",\"roomId\": \""+roomId+"\",\"sessionId\": \""+sessionId+"\"}"
	
	if debugPopUpsOn
	show_message("host ready req: "+ readyDataGetMessage)
	
	web_socket_send(0,readyDataGetMessage)
	
	//show_message("Get host ready data req")
}