/// @description Start the data fetching
// 0 - connecting, 1 - open, 2 - closing, 3 - closed

if web_socket_status(0) = 1 //we need to have the websocket open to send initial data
{
	//show_message("connected, make existence query")
	
	//THE BELOW ARE JUST DEBUGS
	//scrMakeGetPlayerDataRequest()
	//scrMakeSendDataRequest()
	
	scrMakeExistenceQuery()
}
else
alarm[0] = 5 //try again shortly