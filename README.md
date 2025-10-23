# Get-ULSDump  


##What it does  
  
This script, it may or may not ever be a module, is a way to get a dump of all the subsystems in the macOS ULS, grab a log of the last 5 minutes of each as json output, then dump the:

- Subsystem name  
- Category  
- Process  
- Sender  
- Event Message  
- UID for event message  
- PID for event message  

into a series of TSV files, one per subsystem. This allows you to import it into the whatever of choice to do data dumps. Obvs you could trivially modify this to do JSON files instead of TSVs.  

Note the destination directory is hardcoded to /Users/$myUserName/Desktop/securityLogs/, you may wish to change that for your own needs. 

  ## Why  

I find myself having to figure out what to extract as log files from the macOS ULS, and there's not a great list of things out there. So I built this for myself, and realized it may be useful as a starting point for others.

It's fairly thoroughly commented, so you should be able to figure out what's going on.  
