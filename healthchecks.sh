#!/bin/bash

### Common parameters ###
SYSTEM_NAME="MY VM"
hostname="$(hostname)"
pre_check_path="/root/precheck"
post_check_path="/root/postcheck"

### header ###
header () {
    clear
    echo ""
    echo -e "\e[1;37m   ---------------------------------------------------------- \e[0m"
    echo -e "\e[1;32m   |                       ${SYSTEM_NAME}                        |\e[0m"
    echo -e "\e[1;37m   ---------------------------------------------------------- \e[0m"
    echo ""
    echo -e "\e[1;37m   |                   ${hostname}                      |\e[0m"
    echo -e "\e[1;37m   ---------------------------------------------------------- \e[0m"
    echo ""
}

### Main page ###
main_page () {
    header
    echo -e "\e[1;35m  Content \e[0m"
    echo -e "\e[1;92m"
    echo "1. Precheck"
    echo "2. Postcheck"
    echo "3. Recent updated Log"
    echo "4. Comparison between Pre & Post checks"
    echo "5. EXIT"
    echo -e "\e[0m"
}

selecting () {
    while true; do
        main_page
        echo -e "\e[1;33m" 
        read -p "Enter the Number : " num
        echo -e "\e[0m"
        
        case "${num}" in
            1 )
                Server_pre_health_check "${pre_check_path}" ;;
            2 )
                Server_pre_health_check "${post_check_path}" ;;
            3 )
                log
                exit ;;
            4 )
                echo "Not implemented yet"
                exit ;;
            5 )
                exit ;;
            * )
                continue ;;
        esac
    done
}

### Pre-health check ###
Server_pre_health_check () {
    local file="$1"
    header
    ### Check the pre/post check directory availability ###
    if [ -d "${file}" ]; then
        echo -e "\e[1;41m ${file} already exists \e[0m"
        echo -e "\e[1;32m Listing contents of ${file} \e[0m"
        echo -e "\e[1;33m"
        ls -ltr "${file}"
        echo -e "\e[0m"
        
        while true; do
            echo -e "\e[1;41m"
            read -p "Do you want to recreate directory to continue? Press y/Y or exit with n/N: " a
            echo -e "\e[0m"
            
            if [[ "${a}" == 'y' || "${a}" == 'Y' ]]; then
                echo -e "\e[1;32m Removing ${file} Directory \e[0m"
                rm -rf "${file}"
                echo ""
                echo -e "\e[1;32m Creating ${file} Directory \e[0m"
                mkdir "${file}"
                ls -ltr "${file}"
                break
            elif [[ "${a}" == 'n' || "${a}" == 'N' ]]; then
                exit
            else
                echo -e "\e[1;31m Please enter y/Y or n/N \e[0m"
                continue
            fi
        done
    else
        echo -e "\e[1;32m Creating ${file} Directory \e[0m"
        mkdir "${file}"
        ls -ltr "${file}"
    fi
    
    # Continue with system checks
    system_checks "${file}"
}

system_checks () {
    local file="$1"
    header
    echo -e "\e[1;32m Server Space - output of the df -h \e[0m"
    df -h > "${file}/df-h.out"
    df -h

    echo ""
    read -p "Press enter to continue"

    echo -e "\e[1;32m Server Space - output of the df -i \e[0m"
    df -i > "${file}/df-i.out"
    df -i

    echo ""
    read -p "Press enter to continue"

    # Add similar checks for other commands like top, free, netstat, etc.
}

### Log Finding ###
logs_find () {
    clear
    header
    echo -e "\e[1;31m Recent updated logs \e[0m"
    echo ""
    echo -e "\e[1;32m TIME                  PATH \e[0m"
    find /scratch/www/pub/log/ -type f -mtime -1 -exec ls -ltr {} \; | awk '{print $8"-"$9"-"$10 "        "$11}'
    echo ""
    find /var/log/ -type f -mtime -1 -exec ls -ltr {} \; | awk '{print $8"-"$9"-"$10 "        "$11}'
    echo ""
}

log () {
    while true; do
        logs_find
        echo -e "\e[1;33m"
        read -p "Enter correct log path (example - /scratch/www/pub/log/radius/radius.log): " log_path
        echo -e "\e[0m"
        
        if [[ "${log_path}" == "/scratch/www/pub/log/"* ]] || [[ "${log_path}" == "/var/log/"* ]]; then
            tail -100 "${log_path}"
        else
            echo -e "\e[1;31m !!!!! Log path is wrong, please enter correct path !!!! \e[0m"
            sleep 2
            logs_find
        fi
        
        echo ""
        echo -e "\e[1;32m"
        read -p "Do you want to continue? Press y to continue, n to exit: " a
        echo -e "\e[0m"
        
        if [[ "${a}" == 'y' ]]; then
            continue
        elif [[ "${a}" == 'n' ]]; then
            selecting
        else
            echo -e "\e[1;31m Please enter y or n \e[0m"
            sleep 1
            continue
        fi
    done
}

# Script starts here
selecting
