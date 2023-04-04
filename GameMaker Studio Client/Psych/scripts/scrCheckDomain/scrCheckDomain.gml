/*if true
exit //*/
//{

//show_message("Domain check")

if url_get_domain() = "127.0.0.1" or os_browser = browser_not_a_browser //THE LAST IS FOR DEBUG
exit//*/

var isValidSite = false //by default

for (var k = 0; k < totalDomainCount; k += 1) //go through all whitelisted domains
{
	urlAsString = ""
	
	for (var i = 0; i < currentUrlLength[k]+1; i += 1)
	{
	    if i != 0 and i != 2 and i != 7 and i != 19 //those could be mistaken for level numbers
	    {
	        for (var j = 0; j < decryptedStringLengthPerArrayPosition; j += 1)
	        {
	            urlAsString += scrDecrypt(encryptedArray[i,k])
	            //e.g. string(encryptedArray[i] = ...
	        }
	    }
	    else if i = 2 //use a specific variable instead of encryptedArray[], e.g. encryptedSecondLetter = 410
	    {
	        for (var j = 0; j < decryptedStringLengthPerArrayPosition; j += 1)
	        {
	            urlAsString += scrDecrypt(encryptedSecondLetter[k])
	        }
	    }
	    else if i = 7
	    {
	        for (var j = 0; j < decryptedStringLengthPerArrayPosition; j += 1)
	        {
	            urlAsString += scrDecrypt(encryptedSeventhLetter[k])
	        }
	    }
	    else if i = 19
	    {
	        for (var j = 0; j < decryptedStringLengthPerArrayPosition; j += 1)
	        {
	            urlAsString += scrDecrypt(encryptedNineteenthLetter[k])
	        }
	    }
	} //i loop

	//urlAsString = string_copy(urlAsString,5,currentUrlLength-4)

	//show_message(urlAsString)
	//show_message(url_get_domain())

	if string_count(urlAsString,url_get_domain()) >= 1
	{
		isValidSite = true
		//show_message("valid site")
		break
	}

	//show_message("Domain check, current url: "+string(url_get_domain()) + ", decrypted url: "+string(urlAsString))
} // for k = 0 to totalDomainCount - 1 

if !isValidSite//!fm_sitelock_valid(urlAsString)
{
    //show_message("Domain check fail")
    //analytics_event_ext("Domain Check: " +url_get_domain(),"Domain Check Not Successful", 0)
    
    scrHaltGame() //or something else than room_goto(rm_init)
}
//else
//analytics_event_ext("Domain Check: " + urlAsString,"Domain Check Successful", 1)

//}
