# my_project1
# DevOps File Manager 

A simlple bash script for file management, system monitoring, and backup operations with a user-friendly menu interface.
using interactive minu with user to make it easy and helpful.
The goal of the script is to provide a **menu Devops tool** that can:

-Manage files and directroies

-backup and restore

-show system information

-Log user actions 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


### File Operations
- ✅ Create files and directories
- ✅ Copy files and directories with confirmation
- ✅ Move files and directories safely
- ✅ Rename files and directories
- ✅ Delete files and directories with protection
- ✅ List directory contents with details

- ### Search Functionality
- ✅ Search by name pattern
- ✅ Filter by file type (file/directory)
- ✅ Search by size
- ✅ Filter by modification date

### System Management
- ✅ Change file permissions (chmod)
- ✅ Change file ownership (chown)
- ✅ System information display
- ✅ CPU usage monitoring
- ✅ Memory usage tracking
- ✅ Disk usage analysis

### Backup & Reporting
- ✅ Create tar.gz backups
- ✅ Restore from backups
- ✅ Generate system reports
- ✅ Comprehensive logging

### Menu Options

1) Create new files or directories
2) Copy files/directories with overwrite protection
3) Move files/directories to new location
4) Rename files/directories
5) Delete files/directories with confirmation
6) List contents with detailed information
7) file search with filters
8) Change Permission	Modify file permissions (chmod)
9) Change Owner	Change file ownership (chown)
10)	Backup	Create
11)	Restore Backup	Restore from backup files
12) System Information	Display OS and hardware info
13) CPU Usage	Show CPU utilization
14) Memory Usage	Display memory statistics
15) Disk Usage	Show disk space usage
16) Make Report	Generate comprehensive system report
17) Exit	Exit the application
----------------------------------------------------------------------------------------------------------------------------------------------------------
## Global Variables

log_file="dev.log"       
                 
								 #Defines the log where all actions will be writen.

report_dir="reports"     

                 #folder to store reports.

backup_dir="backup"     

                 #folder to store backups.

mkdir -p "&report_dir" "$backup_dir"      

                          #create a directory if they not exist and **(-p)** option to aviods errors.
													
----------------------------------------------------------------------------------------------------------------------------------------------------------

## log() Function

log(){
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$message" >> "$log_file"
}

# Logging system for tracking all operations

**Components**

    local message: Creates local variable scoped to function

    date '+%Y-%m-%d %H:%M:%S': Formats timestamp (Year-Month-Day Hour:Minute:Second)

    $*: All arguments passed to the function

    >> "$log_file": Appends to log file without overwriting

		

---------------------------------------------------------------------------------------------------------------------------------------------------------


 ## Create Files/Directories

create_new(){
    read -p "Enter the name of file or directory to Create: " name
    if [ -z "$name" ]; then        
    if [ -e "$name" ]; then     
    touch "$name"                      
    mkdir -p "$name"            
}

**Validation Checks**:

    [ -z "$name" ]: Empty string check

    [ -e "$name" ]: Existence check

**Creation Commands**:

    touch: Creates empty file

    mkdir -p: Creates directory (with parent directories if needed)

		

---------------------------------------------------------------------------------------------------------------------------------------------------------

		

## Copy Operations


cp -r "$src" "$dst"

**Flags**:

    -r: Recursive (copies directories and contents)

    -v: Verbose (shows files being copied)




move_it() & rename_it() - Move/Rename
bash

mv "$old_name" "$new_name"



**Dual Purpose**:

    Move: When paths are different directories

    Rename: When paths are same directory

		

---------------------------------------------------------------------------------------------------------------------------------------------------------

## Delete Operations


rm -r -i "$d_name"

**Safety Features**:

    -r: Recursive deletion (directories)

    -i: Interactive confirmation prompt

    -f: Force delete (use cautiously)



---------------------------------------------------------------------------------------------------------------------------------------------------------

## Directory Listing

ls -lah "$dir_name"

**Flags**:

    -l: Long format (permissions, owner, size, date)

    -a: All files (including hidden)

    -h: Human-readable sizes (KB, MB, GB)



		
---------------------------------------------------------------------------------------------------------------------------------------------------------


## Search Functionality

 ## Search

find . -name "$Pattern" -type f -size "$Size" -mtime "$Days"

**Find Command Options**:

    .: Start search from current directory

    -name: Pattern matching for filenames

    -type f/d: File or directory type

    -size +1M: Files larger than 1MB

    -mtime -7: Modified in last 7 days
		-----------------------------------------------------------------------------------------------------------------------------------------------------

## System Management

  ## Permission Management


chmod "$mode" "$p"

**Common Permission Values**:

    755: rwxr-xr-x (executable)

    644: rw-r--r-- (read-only)

    777: rwxrwxrwx (full access)
		
		#use number to change the permissions of the files (user -groupe -other )
		
		
		
		--------------------------------------------------------------------------------------------------------------------------------------------------------

## Ownership Management

chown "$owner" "$g"


 ---------------------------------------------------------------------------------------------------------------------------------------------------------

##  Backup System
 ## Create Backups

tar -czf "backup_${ts}.tar.gz" "$b"

**Tar Flags**:

    -c: Create new archive

    -z: Compress with gzip

    -f: Specify filename

    -x: Extract (for restore)

		
---------------------------------------------------------------------------------------------------------------------------------------------------------


## Timestamp Generation:

ts=$(date +%Y%m%d_%H%M%S)    



---------------------------------------------------------------------------------------------------------------------------------------------------------

 ## Restore Operations

tar -xzf "$R"

---------------------------------------------------------------------------------------------------------------------------------------------------------
                                                            
																														## System Monitoring
## System Information

cat /etc/os-release      # OS distribution info
uname -r                 # Kernel version
hostname                 # System hostname
uptime -p               # System uptime
date                    # Current date/time


---------------------------------------------------------------------------------------------------------------------------------------------------------

## CPU Monitoring


top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}'

**Command**:

    top -bn1: Single batch mode output

    grep "Cpu(s)": Filter CPU line

    awk: Calculate total CPU usage (user + system)


		---------------------------------------------------------------------------------------------------------------------------------------------------------
		
## RAM Monitoring


free -h

**Output**:

Total/used/free memory in human-readable format

_________________________________________________________________________________________________________________________________________________________


## Storage Monitoring


df -h

**Output**:  

Filesystem usage with mount points

_________________________________________________________________________________________________________________________________________________________
                                                             
																														 ## Report Generation
## System Reports

{
    system_info
    cpu_info
    memory_usage
    disk_usage
} > "$report_file"

**Features**:

    Combines all system info into one file

    Automatic timestamp in filename

    Saved in reports/ directory
_________________________________________________________________________________________________________________________________________________________

## Main Menu System
## User Interface

main_menu(){
    while true; do 
        # Display menu
        case "$ch" in 
            1) create_new ;;
            2) copy_it ;;
            # ... other options
            17) break ;;
        esac
    done
}

**Control Flow**:

    while true: Infinite loop until exit

    case...esac: Switch statement for menu options

    break: Exit loop when user chooses option 17

## Error Handling & Validation
Input Validation


if [ -z "$name" ]; then
    echo "Error: name can't be empty"
    return 1
fi

if [ -e "$name" ]; then
    echo "Error: $name already exists"
    return 1
fi

## Existence Checks


if [[ -e "$src" ]]; then    # File/directory exists
if [[ -d "$dir_name" ]]; then # Is a directory
if [[ -f "$R" ]]; then      # Is a regular file

## Complete Command Reference


-File Operations

-Command	Purpose	Flags

-touch	Create file	

-mkdir	Create directory	-p (parents)

-cp	Copy	-r (recursive)

-mv	Move/Rename	

-rm	Delete	-r (recursive), -i (interactive)

-ls	List	-lah (detailed)

-System Commands

-Command	Purpose	Output

-chmod	Change permissions	Octal or symbolic

-chown	Change ownership	User:Group

-tar	Archive	-czf (create), -xzf (extract)

-find	Search	Name, type, size, time filters

## Monitoring Commands

-Command	Purpose	Useful Flags

-top	Process monitoring	-bn1 (batch mode)

-free	Memory usage	-h (human-readable)

-df	Disk usage	-h (human-readable)

-uname	System info	-r (kernel)
_________________________________________________________________________________________________________________________________________________________

## Emaples
	
# Create a script file
touch deployment_script.sh
chmod 755 deployment_script.sh

# Create directory structure
mkdir -p project/{src,doc,backup}

 ## Backup Strategy

# Daily backup with timestamp
tar -czf "backup_$(date +%Y%m%d_%H%M%S).tar.gz" /important/data

# Restore when needed
tar -xzf backup_20231215_143022.tar.gz

## System Monitoring

_________________________________________________________________________________________________________________________________________________________


## Log Analysis Commands
View Logs

# Tail last 10 entries
tail -10 devo.log

# Search for errors
grep "Error" devo.log

# Count operations by type
awk '{print $4}' devo.log | sort | uniq -c

## Monitor in Real-time

# Watch log file changes
tail -f devo.log

# Monitor with timestamp
tail -f devo.log | while read line; do
    echo "[$(date '+%H:%M:%S')] $line"
done











