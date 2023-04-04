    //sort the rank order by using the following idea:
//go through the array
//inefficient, but doesn't matter now since the list will always be small
var biggerScoresFound;

ds_list_clear(rankOrder)

ds_list_clear(sortedScoreList)

for (var i = 0; i < playerArraySize; i++)
{
	if players[i, playerData.isDead]
	continue
	
	var p1Id = players[i,playerData.pId]
	
	biggerScoresFound = 0
	for (var j = 0; j < playerArraySize; j++)
	{
		var p2Id = players[j, playerData.pId]

		//make sure we always compare real values, undefined values may occur if someone joins in the middle
		/*if is_undefined(pointMap[? p1Id])
		pointMap[? p1Id] = 0
		
		if is_undefined(pointMap[? p2Id])
		pointMap[? p2Id] = 0*/

		if pointMap[? p2Id] > pointMap[? p1Id]
		biggerScoresFound += 1
	}
	
	//if there are n bigger scores than what we have, then our rank is n+1. This should also take
	//duplicate scores into account
	ds_list_insert(rankOrder,i,biggerScoresFound)//+1)	
	
	ds_list_add(sortedScoreList,pointMap[? p1Id]) //add everyone's scores to a list that we'll sort
	//the sorted list will have its elements match with the order of completeRankOrdersWithNames after sorting
}

ds_list_sort(sortedScoreList,false)

//sort the players alphabetically for each duplicate score
ds_list_clear(completeRankOrdersWithNames)

//form a nested list structure like this
// rank | order within that rank
// 1 - A, B
// 2 -
// 3 - C
// 4 - D and so on

rankString = "" //for debugs

//NOTE: The ds_grid initializes all values to "0", so that's why the names will be stored as
//0Adam and 0Jake, I suppose. But this doesn't affect the alphabetical ordering

for (var currRank = 0; currRank < playerCount; currRank++)
{
	//store these for each row of the grid: pId, pName, score, then sort based on the name
	//note that the scores for each rank entry is the same, but this is just for the ease of using
	//a single grid to get the data
	completeRankOrdersWithNames[|currRank] = ds_grid_create(0,0) 
	//var currPlayerId = players[i,playerData.pId]
	for (var j = 0; j < playerArraySize; j++)
	{
		if players[j, playerData.isDead]
		continue
		
		if rankOrder[|j] = currRank
		{
			var currGridHeight = ds_grid_height(completeRankOrdersWithNames[|currRank])
			ds_grid_resize(completeRankOrdersWithNames[|currRank],2, currGridHeight + 1)
			ds_grid_add(completeRankOrdersWithNames[|currRank],0, currGridHeight,j) //players[j, playerData.pId]
			
			if players[j, playerData.pShortName] != undefined
			ds_grid_add(completeRankOrdersWithNames[|currRank],1, currGridHeight,players[j, playerData.pShortName])
			else
			ds_grid_add(completeRankOrdersWithNames[|currRank],1, currGridHeight,"") //This seems to fix the bug for some reason if this is just defined
			//ds_grid_add(completeRankOrdersWithNames[|currRank],2, currGridHeight-1,pointMap[? players[j, playerData.pId]])
		}
	}
	//alphabetically sort each sublist
	ds_grid_sort(completeRankOrdersWithNames[|currRank],1,true)
	
	/*rankString += "RANK: "+string(currRank) + " - "
	for (var k = 0; k < ds_grid_height(completeRankOrdersWithNames[|currRank]); k++) //DEBUG
	{
		rankString += "PINDEX: "+ (string(ds_grid_get(completeRankOrdersWithNames[|currRank],0,k))+ " NAME: " + string(ds_grid_get(completeRankOrdersWithNames[|currRank],1,k)) + ", ")
		//show_message("Rank "+string(currRank) + " contains " + ds_grid_get(completeRankOrdersWithNames[|currRank],1,k))
	}
	rankString += "\n"//*/
	
}

//show_message(rankString)

