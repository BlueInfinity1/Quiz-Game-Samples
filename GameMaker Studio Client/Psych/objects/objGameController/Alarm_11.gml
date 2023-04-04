/// @description Attempt to reconnect
// You can write your code in this editor

if web_socket_status(0) != 1
{
	//show_message(os_is_network_connected())
	if os_is_network_connected()
	{
		lastConnOpenAttemptTime = current_time
		web_socket_open(0,endPointUrl,-1, false);
	}

	alarm[11] = reconnectionTime
}
else
alarm[0] = 1 //kick off with the initial requests
