//NOTE: This has now been updated to use shuffleOrder that is fetched from the server
//DOES NOT REALLY SHUFFLE ANYMORE

//argument0 - ds_list to shuffle

var originalList = argument0
var listSize = ds_list_size(originalList)



var newList = ds_list_create()

for (var i = 0; i < listSize; i += 1)
{
	newList[| i] = originalList[| (shuffleOrderList[|i]-1)]  //TODO: Check that this is correct
}

return newList