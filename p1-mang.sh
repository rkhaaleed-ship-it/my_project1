#!/bin/bash

log_file="devo.log"
report_dir="reports"
backup_dir="backup"
mkdir -p "$report_dir" "$backup_dir"

log(){ #login memory
    local message="[$(date '+%Y-%m-%d %H:%M:%S')] $*"
    echo "$message" >> "$log_file"
}

display_header(){    #display header
    clear 
    echo "-------------------------"
    echo "  DevOps project "
    echo "--------------------------"	
}

pause(){ 
    read -p "Press Enter to continue...."
}

create_new(){    
    read -p "Enter the name of file or directory to Create: " name
    if [ -z "$name" ]; then 
        echo "Error: name can't be empty"
        return 
    fi
    if [ -e "$name" ]; then 
        echo "Error: $name already exists"
        return 
    fi

    read -p "Is it File or directory (f/d)?: " type
    
    case "$type" in 
        f) touch "$name" && echo "File created: $name" && log "created file $name";;
        d) mkdir -p "$name" && echo "Directory created: $name" && log "created dir $name" ;;
        *) echo "Invalid choice"
    esac
}

copy_it(){  
    read -p "Source path for file or directory: " src
    read -p "Destination path for file or directory: " dst 
    if [[ -e "$src" ]]; then
        read -p "Are you sure to copy $src to $dst? (y/n): " ans
        if [[ "$ans" == "y" ]]; then
            cp -r "$src" "$dst" && echo "Copied $src to $dst"
            log "copy $src to $dst"
        else
            echo "Canceled"
        fi
    else 
        echo "Source file or directory does not exist"
    fi
}

move_it(){ 
    read -p "What is the source path for move: " msrc
    read -p "What is the destination path for move: " mdst
    if [[ -e "$msrc" ]]; then
        read -p "Are you sure to move $msrc to $mdst? (y/n): " ans
        if [[ "$ans" == "y" ]]; then
            mv -v "$msrc" "$mdst" && echo "Moved $msrc to $mdst"
            log "moved $msrc to $mdst"
        else 
            echo "Canceled"
        fi
    else
        echo "Source file does not exist" 
    fi
}

rename_it(){
    read -rp "Enter current name: " old_name
    read -rp "Enter new name: " new_name
    if [[ -e "$old_name" ]]; then 
        read -p "Are you sure to rename $old_name to $new_name? (y/n): " ans
        if [[ "$ans" == "y" ]]; then
            mv "$old_name" "$new_name" && echo "Renamed $old_name to $new_name"
            log "rename $old_name to $new_name"
        else 
            echo "Canceled"
        fi
    else
        echo "File or directory not found"
    fi 
}

delete_it(){ 
    read -rp "Enter file name you want to delete: " d_name
    if [[ -e "$d_name" ]]; then
        read -p "Are you sure to delete $d_name? (y/n): " ans
        if [[ "$ans" == "y" ]]; then
            rm -r -i "$d_name" && echo "File $d_name Deleted"
            log "Deleted $d_name"
        else 
            echo "Canceled"
        fi
    else
        echo "File or directory not found"
    fi 
}

list_dir(){
    read -rp "Enter the name of the Directory to list: " dir_name
    dir_name=${dir_name:-"."}
    if [[ -d "$dir_name" ]]; then
        ls -lah "$dir_name"
    else 
        echo "Error: directory not found"
    fi
}

search_file(){
    echo "Search: "
    read -p "Name: " Pattern
    read -p "Type (file=f, dir=d): " Type
    read -p "Size: " Size
    read -p "Modified in last N days: " Days
    cmd=(find .)
    [[ -n "$Pattern" ]] && cmd+=(-name "$Pattern")
    [[ "$Type" == "f" ]] && cmd+=(-type f)
    [[ "$Type" == "d" ]] && cmd+=(-type d)
    [[ -n "$Size" ]] && cmd+=(-size "$Size")
    [[ -n "$Days" ]] && cmd+=(-mtime "$Days")
    echo "Search command: ${cmd[*]}"
    "${cmd[@]}"
}

change_permission(){
    read -p "Enter file or directory name: " p
    read -p "Enter chmod permission: " mode
    chmod "$mode" "$p" && echo "Permission changed"
    log "changed permission $p to $mode"
}

change_owner(){
    read -p "Enter file or directory name: " g
    read -p "Enter new owner name: " owner
    chown "$owner" "$g" && echo "Owner changed"
    log "changed owner $g to $owner"
}

backup_it(){
    read -p "Enter file or directory name: " b
    if [[ -e "$b" ]]; then
        ts=$(date +%Y%m%d_%H%M%S)
        tar -czf "backup_${ts}.tar.gz" "$b"
        echo "Backup created: backup_${ts}.tar.gz"
        log "Backup created for $b"
    else
        echo "File or directory not found"
    fi
}

restore_backup(){
    read -p "Enter backup name you want to restore (.tar.gz): " R
    if [[ -f "$R" ]]; then 
        tar -xzf "$R"
        echo "Backup restored."
        log "restored backup $R"
    else
        echo "Backup file not found"
    fi
}

system_info(){
    echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo "Kernel: $(uname -r)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Date: $(date)"
    echo ""
}

cpu_info(){
    echo "CPU usage: "
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4 "%"}'
    echo ""
}

memory_usage(){
    echo "Memory usage: "
    free -h
    echo ""
}

disk_usage(){
    echo "Disk usage: "
    df -h
    echo ""
}

generate_report(){
    local ts=$(date +%Y%m%d_%H%M%S)
    local report_file="$report_dir/system_report_${ts}.txt"

    {
        system_info
        echo ""
        cpu_info
        echo ""
        memory_usage
        echo ""
        disk_usage
        echo ""
    } > "$report_file"

    echo "Report saved in $report_file"
    log "Generate report file $report_file"
}

main_menu(){ #the menu to choose
    while true; do 
        echo "=== DevOps Tool Menu ==="
        echo "1- Create file or Directory"
        echo "2- Copy file or Directory"
        echo "3- Move file or Directory"
        echo "4- Rename file or Directory"
        echo "5- Delete file or Directory"
        echo "6- List Directory"
        echo "7- Search"
        echo "8- Change permission"
        echo "9- Change owner"
        echo "10- Backup"
        echo "11- Restore Backup"
        echo "12- System information"
        echo "13- CPU usage"
        echo "14- Memory usage"
        echo "15- Disk Usage"
        echo "16- Make report"
        echo "17- Exit"
        read -rp "Enter your choice: " ch

        case "$ch" in 
            1) create_new ;;
            2) copy_it ;;
            3) move_it ;;
            4) rename_it ;;
            5) delete_it ;;
            6) list_dir ;;
            7) search_file ;;
            8) change_permission ;;
            9) change_owner ;;
            10) backup_it ;;
            11) restore_backup ;;
            12) system_info ;;
            13) cpu_info ;;
            14) memory_usage ;;
            15) disk_usage ;;
            16) generate_report ;;
            17) echo "Goodbye!"; break ;;
            *) echo "Invalid choice, try again:" ;;
        esac
        echo
        pause
    done
}

log "Tool started"
main_menu
log "Tool ended"
