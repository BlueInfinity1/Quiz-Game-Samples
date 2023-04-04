//Create 3 Server variables that we'll use later on.
var servers = new Array();
var debugMode = true;
var asyncID = "6164";

function debugOutput(message) {
	if (debugMode==true){
	GMS_API.debug_msg( "[GM Web Sockets] : " + message );
	}
}

function web_socket_debug_mode(argument) {

	//Converting GML boolean to JS boolean
	if (argument>0.5) {
		debugMode = true;
	}

}


function web_socket_status(serverNo) {
	switch(servers[serverNo].readyState)
	{
		case 0:
		//debugOutput("Connection ID " + serverNo.toString() + " is connecting...");
		return 0;
		break;

		case 1:
		//debugOutput("Connection ID " + serverNo.toString() + " is OPEN and ready to communicate.");
		return 1;
		break;

		case 2:
		//debugOutput("Connection ID " + serverNo.toString() + " is closing the connection...");
		return 2;
		break;

		case 3:
		//debugOutput("Connection ID " + serverNo.toString() + " is closed!");
		return 3;
		break;


	}
}

//Check Websocket Compability
function web_socket_is_supported() {

	if (supportsWebSockets = 'WebSocket' in window || 'MozWebSocket' in window) {
		//debugOutput("Websockets are supported in this browser.")
		return "true";
	}
	else {
		//debugOutput("Websockets are NOT supported in this browser!")
		return "false";
	}

}

function web_socket_open(serverNo, address, protocols, jsonOptimize) {
	var string_protocol = true;
	if (protocols>0){
		var a = new Array();
		var protocolLength = GMS_API.ds_list_size(protocol);
	        for (var i = 0; i < protocolLength; i++) {
	        	var proto = GMS_API.ds_list_find_value(protocol, i);
	        	a[i] = proto;

	        	servers[serverNo] = new WebSocket(address,a);

	        }
    	}
        else {
        	servers[serverNo] = new WebSocket(address);
        }
		
		if (jsonOptimize>0.5) {
	        	string_protocol = false;
	    }

	servers[serverNo].onmessage = function (event) { 
		var map = {};
		
		map["id"] = asyncID;
		map["event_type"] = "websocket_message";
		map["connection_number"] = serverNo;
		if (string_protocol==true) {
			map["json_format"] = false;
			map["data"] = event.data;
			//map["all"] = event;
		} else {
			map["json_format"] = true;
			map["data"] = JSON.stringify(event.data);
			//map["all"] = event;
		}
		GMS_API.send_async_event_social(map);
		//debugOutput("Message received. The Data received is : " + event.data);
	}

	servers[serverNo].onopen = function (event) { 
		var map = {};
		map["event_type"] = "websocket_connected";
		map["connection_number"] = serverNo;
		GMS_API.send_async_event_social(map);
		//debugOutput("The Connection " + serverNo.toString() + " has connected to the server.");

	}

	servers[serverNo].onclose = function (event) { 
		var map = {};
		map["id"] = asyncID;
		map["event_type"] = "websocket_closed";
		map["connection_number"] = serverNo;
		GMS_API.send_async_event_social(map);
		//debugOutput("The Connection " + serverNo.toString() + " is closed!");

	}

	servers[serverNo].onerror = function (event) { 
		var map = {};
		map["id"] = asyncID;
		map["event_type"] = "websocket_error";
		map["connection_number"] = serverNo;
		GMS_API.send_async_event_social(map);
		//debugOutput("An error happened in the Connection No " + serverNo.toString() + "!");

	}

}	


function web_socket_send(serverNo, data) {
	servers[serverNo].send(data);
}

function web_socket_close(serverNo) {

	servers[serverNo].close();
}