#make a list of subsystems
$theSubsystemListPath = Get-ChildItem -Path "/System/Library/Preferences/Logging/Subsystems"
$theFileStoragePath = "/Users/jwelch/Desktop/securityLogs/"
$subsystemList = [System.Collections.Generic.List[string]]::new()
foreach ($item in $theSubsystemListPath) {                                                  
	$subsystemList.Add($item.Name.Substring(0, ($item.Name.Length - 6)))
}

#iterate through the list and get each subsystemlog
foreach ($item in $subsystemList) {
	#build the predicate string
	$predicateString = "/usr/bin/log show --style json --last 5m --predicate `'subsystem == `"" + $item + "`"`'"
	#build the filename & destination path for the files
	$theFileName = $item.Split(".")[-1].Trim() + ".tsv"
	$theDestination = $theFileStoragePath + $theFileName
	
	#write out the header to the filename
	write-output "Subsystem`tCategory`tProcess`tSender`tUID`tPID`tMessage" > $theDestination
	
	#build the predicate string
	$thePredicateString = "/usr/bin/log show --style json --last 5m --predicate `'subsystem == `"" + $item + "`"`'"

	#run the log command
	$theSubsystemLog = Invoke-Expression -Command $thePredicateString

	#initial return is an array, convert to string because required for ConvertFrom-Json
	$theSubsystemLogString = $theSubsystemLog|Out-String

	#convert string to a JSON object
	$subsystemLogJson = ConvertFrom-Json -InputObject $theSubsystemLogString

	#there's multiple items in the JSON object, so we have to iterate through that to get what we want.
	foreach ($jsonItem in $subsystemLogJson) {
		#get just the things we want
		$subsystem = $jsonItem.subsystem
		$category = $jsonItem.category
		$process = $jsonItem.processImagePath.Split("/")[-1].Trim()
		$sender = $jsonItem.senderImagePath.Split("/")[-1].Trim()
		$eventMessage = $jsonItem.eventMessage
		$userID = $jsonItem.userID
		$myPid = $jsonItem.processID

		#append those to the current file
		write-output "$subsystem`t$category`t$process`t$sender`t$userID`t$myPid`t$eventMessage" >> $theDestination
	}
}