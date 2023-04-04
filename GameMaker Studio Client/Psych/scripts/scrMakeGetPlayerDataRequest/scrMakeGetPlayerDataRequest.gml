with objGameController
{
	var requestId = scrAddWebsocketRequest(101)
	lastRequestTimes[101] = current_time
	
	getAllPlayersDataMessage =
	"{\"action\": \"message\", \"op\": 101, \"requestId\": \"" +requestId+"\",\"roomId\": \""+roomId+"\",\"sessionId\": \""+sessionId+"\"}"
	
	if debugPopUpsOn
	show_message(getAllPlayersDataMessage)
	
	web_socket_send(0,getAllPlayersDataMessage) //trigger the message route
	
}