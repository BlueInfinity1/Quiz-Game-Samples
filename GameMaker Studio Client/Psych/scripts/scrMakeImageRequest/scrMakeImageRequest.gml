/*if (string_lower(http_get_request_crossorigin()) != "use-credentials")
{
	
	//show_message("use creds set, previously: "+ http_get_request_crossorigin())
}*/

//show_message("image request for " +argument0+ " made")

//http_set_request_crossorigin("use-credentials")
ds_map_replace(imageRequests,argument0,sprite_add(argument1,1,false,false,0,0))
//http_get_file(argument1,imageFilePath+"player"+string(argument0)+".png")
//if this doesn't work, try double backslash \\

//show_message("image Request map now contains: "+string(imageRequests[? argument0]))