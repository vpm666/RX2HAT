#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath $0))
RESULTS_DIR="$SCRIPT_DIR/RX2HAT"

banner() {
clear
printf "\e[0m\n"
printf "\e[1;31m
  ██████╗ ██╗  ██╗██████╗ ██╗  ██╗ █████╗ ████████╗
  ██╔══██╗╚██╗██╔╝╚════██╗██║  ██║██╔══██╗╚══██╔══╝
  ██████╔╝ ╚███╔╝  █████╔╝███████║███████║   ██║   
  ██╔══██╗ ██╔██╗ ██╔═══╝ ██╔══██║██╔══██║   ██║   
  ██║  ██║██╔╝ ██╗███████╗██║  ██║██║  ██║   ██║   
  ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
\e[0m"
printf "\e[1;34m       Hacking Tool v3.0 - By vpm666\e[0m\n"
printf "\e[1;31m       RX2HAT RELEASED BY RH4X TECH TEAM\e[0m\n"
}

initialize() {
    if [ ! -d "$RESULTS_DIR" ]; then
        mkdir -p "$RESULTS_DIR"
    fi
}

scan_single() {
    printf "\n\e[1;33m[*] Starting Stealth Scan...\e[0m\n"
    nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip | tee /dev/tty
    
    printf "\n\e[1;33m[*] Running Vulnerability Analysis...\e[0m\n"
    nmap --script vulners $target_ip | tee /dev/tty
    
    save_results_prompt
}

scan_full() {
    printf "\n\e[1;31m[!] WARNING: This scan is VERY aggressive and noisy!\e[0m\n"
    printf "\e[1;33m[*] Running FULL Offensive Scan...\e[0m\n"
    nmap -T4 -A -v -Pn -p- -sS -sV -O --script=vuln,exploit,brute $target_ip | tee /dev/tty
    
    printf "\n\e[1;33m[*] Running Advanced Exploit Checks...\e[0m\n"
    nmap --script exploit $target_ip | tee /dev/tty
    
    save_results_prompt
}

save_results_prompt() {
    read -p $'\n\e[1;33m[*] Do you want to save the results? (y/n): \e[0m' save_choice
    if [[ $save_choice == "y" || $save_choice == "Y" ]]; then
        find_next_available_file
        printf "\e[1;33m[*] Saving results to $result_file\e[0m\n"
        # Re-run the scan and save to file (we could optimize this by saving the previous output)
        case $scan_option in
            1) 
                nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip > "$result_file"
                nmap --script vulners $target_ip >> "$result_file"
                ;;
            2) 
                nmap -T4 -A -v -Pn -p- -sS -sV -O --script=vuln,exploit,brute $target_ip > "$result_file"
                nmap --script exploit $target_ip >> "$result_file"
                ;;
            3) nmap --script vuln $target_ip > "$result_file" ;;
            4) nmap -O $target_ip > "$result_file" ;;
            5) 
                nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip > "$result_file"
                nmap --script vulners $target_ip >> "$result_file"
                nmap -T4 -A -v -Pn -p- -sS -sV -O --script=vuln,exploit,brute $target_ip >> "$result_file"
                nmap --script exploit $target_ip >> "$result_file"
                ;;
        esac
    fi
}

find_next_available_file() {
    counter=1
    while true; do
        result_file="$RESULTS_DIR/scan${counter}.txt"
        if [ ! -f "$result_file" ]; then
            break
        fi
        ((counter++))
    done
}

show_results() {
    clear
    printf "\e[1;33m\n[*] SCAN RESULTS FOR: $target_ip\e[0m\n"
    printf "\e[1;33m---------------------------------------\e[0m\n"

    printf "\n\e[1;33m[*] LIVE SCAN RESULTS:\e[0m\n"
    case $scan_option in
        1) 
            printf "\e[1;33m[*] Stealth Scan Results:\e[0m\n"
            nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip | tee /dev/tty
            printf "\n\e[1;33m[*] Vulnerability Analysis:\e[0m\n"
            nmap --script vulners $target_ip | tee /dev/tty
            ;;
        2) 
            printf "\e[1;33m[*] Full Offensive Scan Results:\e[0m\n"
            nmap -T4 -A -v -Pn -p- -sS -sV -O --script=vuln,exploit,brute $target_ip | tee /dev/tty
            printf "\n\e[1;33m[*] Advanced Exploit Checks:\e[0m\n"
            nmap --script exploit $target_ip | tee /dev/tty
            ;;
        3) 
            printf "\e[1;33m[*] Vulnerability Scan Results:\e[0m\n"
            nmap --script vuln $target_ip | tee /dev/tty
            ;;
        4) 
            printf "\e[1;33m[*] OS Detection Results:\e[0m\n"
            nmap -O $target_ip | tee /dev/tty
            ;;
        5) 
            printf "\e[1;33m[*] All-in-One Scan Results:\e[0m\n"
            nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip | tee /dev/tty
            printf "\n\e[1;33m[*] Vulnerability Analysis:\e[0m\n"
            nmap --script vulners $target_ip | tee /dev/tty
            printf "\n\e[1;33m[*] Full Offensive Scan Results:\e[0m\n"
            nmap -T4 -A -v -Pn -p- -sS -sV -O --script=vuln,exploit,brute $target_ip | tee /dev/tty
            printf "\n\e[1;33m[*] Advanced Exploit Checks:\e[0m\n"
            nmap --script exploit $target_ip | tee /dev/tty
            ;;
    esac

    printf "\n\e[1;31m[!] WARNING: Unauthorized hacking is illegal. Use responsibly.\e[0m\n"
    printf "\e[1;33m[*] You can save these results from the menu option 4\e[0m\n"
    
    printf "\n\e[0m"
    read -p $'  \e[1;31mPRESS ENTER TO CONTINUE...\e[0m'
    scan_menu
}

view_txt_files() {
    clear
    banner
    printf "\n\e[1;33m[*] TXT FILES IN RX2HAT DIRECTORY:\e[0m\n"
    printf "\e[1;33m---------------------------------------\e[0m\n"
    
    if [ -d "$RESULTS_DIR" ]; then
        files=($(ls -1v "$RESULTS_DIR"/*.txt 2>/dev/null))
        if [ ${#files[@]} -eq 0 ]; then
            printf "\e[1;31mNo scan files found in RX2HAT directory.\e[0m\n"
        else
            printf "\e[1;32mAvailable scan files:\e[0m\n"
            for i in "${!files[@]}"; do
                printf "\e[1;33m[$((i+1))] ${files[$i]}\e[0m\n"
            done
            
            printf "\n\e[1;33mSelect a file to view (1-${#files[@]}) or 0 to return:\e[0m "
            read file_choice
            if [[ $file_choice -ge 1 && $file_choice -le ${#files[@]} ]]; then
                clear
                printf "\e[1;33m[*] CONTENTS OF ${files[$((file_choice-1))]}:\e[0m\n"
                printf "\e[1;33m---------------------------------------\e[0m\n"
                cat "${files[$((file_choice-1))]}"
                printf "\n\e[1;33m---------------------------------------\e[0m\n"
                read -p $'  \e[1;31mPRESS ENTER TO CONTINUE...\e[0m'
                view_txt_files
            fi
        fi
    else
        printf "\e[1;31mRX2HAT directory does not exist.\e[0m\n"
    fi
    
    read -p $'  \e[1;31mPRESS ENTER TO CONTINUE...\e[0m'
    main_menu
}

scan_menu() {
clear
banner
printf "\n\e[1;33mTARGET IP: \e[1;32m$target_ip\e[0m\n"
printf "\e[1;33m---------------------------------------\e[0m\n"
printf "\e[1;31m  [1]\e[0m\e[1;33m Stealth Scan (Silent)\e[0m\n"
printf "\e[1;31m  [2]\e[0m\e[1;33m Full Offensive Scan (Noisy)\e[0m\n"
printf "\e[1;31m  [3]\e[0m\e[1;33m Vulnerability Scan Only\e[0m\n"
printf "\e[1;31m  [4]\e[0m\e[1;33m OS Detection\e[0m\n"
printf "\e[1;31m  [5]\e[0m\e[1;33m ALL IN ONE (Full Recon)\e[0m\n"
printf "\e[1;31m  [6]\e[0m\e[1;33m View TXT Files\e[0m\n"
printf "\e[1;31m  [0]\e[0m\e[1;33m Back to Main Menu\e[0m\n"
printf "\e[1;33m---------------------------------------\e[0m\n"
read -p $'  \e[1;31mSELECT>\e[0m\e[1;96m ' scan_option

case $scan_option in
    1|2|3|4|5) show_results ;;
    6) view_txt_files ;;
    0) main_menu ;;
    *) 
        printf " \e[1;91m[!] Invalid option\e[0m\n"
        sleep 1
        scan_menu
        ;;
esac
}

main_menu() {
clear
banner
printf "\n\e[1;33mSELECT TARGET OPTION:\e[0m\n"
printf "\e[1;33m---------------------------------------\e[0m\n"
printf "\e[1;31m  [1]\e[0m\e[1;33m Enter Target IP\e[0m\n"
printf "\e[1;31m  [2]\e[0m\e[1;33m Scan Local Network\e[0m\n"
printf "\e[1;31m  [3]\e[0m\e[1;33m Load Targets from File\e[0m\n"
printf "\e[1;31m  [4]\e[0m\e[1;33m View TXT Files\e[0m\n"
printf "\e[1;31m  [0]\e[0m\e[1;33m Exit\e[0m\n"
printf "\e[1;33m---------------------------------------\e[0m\n"
read -p $'  \e[1;31mSELECT>\e[0m\e[1;96m ' main_option

case $main_option in
    1) 
        read -p $'  \e[1;31mTARGET IP:\e[0m\e[1;96m ' target_ip
        scan_menu
        ;;
    2) 
        printf "\n\e[1;33m[*] Scanning Local Network...\e[0m\n"
        nmap -sn 192.168.1.0/24 | tee /dev/tty
        find_next_available_file
        printf "\e[1;33m[*] Save results to $result_file? (y/n): \e[0m"
        read save_choice
        if [[ $save_choice == "y" || $save_choice == "Y" ]]; then
            nmap -sn 192.168.1.0/24 > "$result_file"
            printf "\e[1;33m[*] Results saved to $result_file\e[0m\n"
        fi
        sleep 2
        main_menu
        ;;
    3)
        read -p $'  \e[1;31mFile with IPs:\e[0m\e[1;96m ' ip_file
        if [ -f "$ip_file" ]; then
            printf "\n\e[1;33m[*] Scanning multiple targets...\e[0m\n"
            while read -r line; do
                target_ip=$line
                printf "\n\e[1;33m[*] Scanning $target_ip...\e[0m\n"
                nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip | tee /dev/tty
                printf "\n\e[1;33m[*] Vulnerability Analysis for $target_ip:\e[0m\n"
                nmap --script vulners $target_ip | tee /dev/tty
                
                printf "\n\e[1;33m[*] Save results for $target_ip? (y/n): \e[0m"
                read save_choice
                if [[ $save_choice == "y" || $save_choice == "Y" ]]; then
                    find_next_available_file
                    nmap -T4 -A -v -Pn -p- -sS --script vuln,exploit $target_ip > "$result_file"
                    nmap --script vulners $target_ip >> "$result_file"
                    printf "\e[1;33m[*] Results saved to $result_file\e[0m\n"
                fi
            done < "$ip_file"
        else
            printf "\e[1;91m[!] File not found!\e[0m\n"
            sleep 1
        fi
        main_menu
        ;;
    4)
        view_txt_files
        ;;
    0)
        exit 0
        ;;
    *)
        printf " \e[1;91m[!] Invalid option\e[0m\n"
        sleep 1
        main_menu
        ;;
esac
}

initialize

if [ "$(id -u)" != "0" ]; then
    printf "\e[1;91m[!] This script must be run as root!\e[0m\n"
    exit 1
fi

if ! command -v nmap &> /dev/null; then
    printf "\e[1;91m[!] Nmap is not installed! Run: sudo apt install nmap\e[0m\n"
    exit 1
fi

target_ip=""
main_menu
