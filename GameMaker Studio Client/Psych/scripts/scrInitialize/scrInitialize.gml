successfullySentPlayerDataOnce = false

roomPhaseToRecover = "none"

selectedGuessId = "-1"
ownStatementsWritten = false
readyForNextRound = false
readyForScores = false //only set true for host

initialDataAboutOthersFetched = false

ownPlayerIndex = -1 //not determined yet

hostHasStartedGame = false //the meaning of this variable depends on whether you're the host or not
hostHasEndedGame = false

currentQuestion = ""
correctAnswer = ""
yourFakeAnswer = ""

requestDataToFetch = dataRequest.basicInfo
phase = gamePhase.initializing

rebuildScoreboard = false //may need to recheck scores if 