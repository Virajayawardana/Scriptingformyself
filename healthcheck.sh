#!/bin/bash

 

### Common parameters ###

SYSTEM_NAME="MY VM"

hostname="$(hostname)"

pre_check_path=/root/precheck

post_check_path=/root/postcheck

 

### header ###

header () {

clear

 

echo ""

echo -e "\e[1;37m   ---------------------------------------------------------- \e[0m"

echo -e "\e[1;32m   |                       $SYSTEM_NAME                        |\e[0m"

echo -e "\e[1;37m   ---------------------------------------------------------- \e[0m"

echo ""

echo -e "\e[1;37m   |                   ${hostname}                      |\e[0m"

echo -e "\e[1;37m   ---------------------------------------------------------- \e[0m"

echo ""

}

 

### Main page ####

main_page (){

 

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

while true

do

main_page

echo -e "\e[1;33m" ; read -p "Enter the Number : " num; echo -e "\e[0m"

 

case $num in

 

        1 )     Server_pre_heath_check $pre_check_path ;

                ;;

        2 )

                Server_pre_heath_check $post_check_path;

                ;;

        3 )

                log ;

                exit ;

                ;;

        4 )

                echo "not implement yet";

                exit ;

                ;;

        5 )

                exit ;

                ;;              

        * )     continue ;

                ;;

esac

 

done

}

 

### Pre heath check ###

Server_pre_heath_check (){

 

file=$1

header

### Check the pre/post check directoty avaliability ###

 

if [ -d "$file" ]; then

    echo -e "\e[1;41m $file already exist \e[0m"

    echo -e "\e[1;32m ls -ltr $file \e[0m"

    echo -e "\e[1;33m" ; ls -ltr $file  ; echo -e "\e[0m"

 

    while true

    do

     echo -e "\e[1;41m" ; read -p "Do you want to recreate directory to continue. Then y/Y or exit press n/N : " a; echo -e "\e[0m"

        if [ $a == 'y' ] || [ $a == 'Y' ]

        then

            echo -e "\e[1;32m Removing $file Directory \e[0m" ;rm -rf $file ; echo ""

            echo -e "\e[1;32m Creating $file Directory \e[0m" ; mkdir $file

            echo -e "\e[1;32m ls -ltr $file \e[0m"

            echo -e "\e[1;33m" ; ls -ltr $file  ; echo -e "\e[0m"

            break

        elif [ $a == 'n' ] || [ $a == 'N' ]

        then

            exit

        else

            echo -e "\e[1;31m please enter y/Y or n/N \e[0m"

            continue

        fi

    done        

else

    echo -e "\e[1;32m Creating $file Directory \e[0m" ; mkdir $file

    echo -e "\e[1;32m ls -ltr $file \e[0m"

    echo -e "\e[1;33m" ; ls -ltr $file  ; echo -e "\e[0m"

fi

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Server Space - output of the df -h \e[0m"

df -h > $file/df-h.out

echo -e "\e[1;33m" ; df -h ; echo -e "\e[0m"

echo ""

echo -e "\e[1;32m Server Space - output of the df -i \e[0m"

df -i > $file/df-i.out

echo -e "\e[1;33m" ; df -i ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Running process - output of the top \e[0m"

ps -eo pid,ppid,cmd,comm,%mem,%cpu --sort=-%mem | head -15 > $file/top.out

echo -e "\e[1;33m" ; ps -eo pid,ppid,cmd,comm,%mem,%cpu --sort=-%mem | head -15 ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Free Memory space - output of the free -m \e[0m"

free -m > $file/free-m.out

echo -e "\e[1;33m" ; free -m ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Routing table - output of the netstat -nr  \e[0m"

netstat -nr > $file/netstat-nr.out

echo -e "\e[1;33m" ; netstat -nr; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Output of the show state \e[0m"

/usr/local/antlabs/bin/sudo_show state > $file/state.out

echo -e "\e[1;33m" ; /usr/local/antlabs/bin/sudo_show state ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Output of the show state HA\e[0m"

/usr/local/antlabs/bin/sudo_show state HA> $file/state-HA.out

echo -e "\e[1;33m" ; /usr/local/antlabs/bin/sudo_show state HA ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Output of the show state SERVICE \e[0m"

/usr/local/antlabs/bin/sudo_show state SERVICE> $file/SERVICE.out

echo -e "\e[1;33m" ; /usr/local/antlabs/bin/sudo_show state SERVICE ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Output of the show state NETWORK \e[0m"

/usr/local/antlabs/bin/sudo_show state NETWORK> $file/NETWORK.out

echo -e "\e[1;33m" ; /usr/local/antlabs/bin/sudo_show state NETWORK ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Output of the show state SYSTEM \e[0m"

/usr/local/antlabs/bin/sudo_show state SYSTEM > $file/SYSTEM.out

echo -e "\e[1;33m" ; /usr/local/antlabs/bin/sudo_show state SYSTEM ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Output of the /proc/DRBD \e[0m"

cat /proc/drbd > $file/drbd.out

echo -e "\e[1;33m" ; cat /proc/drbd ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

header

echo -e "\e[1;32m Saving all output in $file \e[0m"

sleep 3

echo -e "\e[1;32m ls -ltr $file \e[0m"

echo -e "\e[1;33m" ; ls -ltr $file  ; echo -e "\e[0m"

 

echo ""

read -p "Press enter to continue"

 

}

 

logs_find () {

 

clear

header

echo -e "\e[1;31m Recent updated logs \e[0m"  

echo ""

echo -e "\e[1;32m TIME                  PATH \e[0m"

find /scratch/www/pub/log/ -type f -mtime -1 -"ls" | awk '{print $8"-"$9"-"$10 "        "$11}'

echo ""

find /var/log/ -type f -mtime -1 -"ls" | awk '{print $8"-"$9"-"$10 "        "$11}'

echo ""

}

 

log () {

while true

do

    logs_find

    echo -e "\e[1;33m" ; read -p "Enter correct log path : example - /scratch/www/pub/log/radius/radius.log : " log_path ; echo -e "\e[0m"

        if [[ "$log_path" == "/scratch/www/pub/log/"* ]] || [[ "$log_path" == "/var/log/"* ]]

        then

            tail -100 $log_path

        else

            echo -e "\e[1;31m !!!!! Log path is wrong please enter correct path !!!! \e[0m"

            sleep 2

            logs_find

        fi

 

    echo ""

    echo -e "\e[1;32m" ; read -p "Do you want to continue press y or exit press n : " a; echo -e "\e[0m"

        if [ $a == 'y' ]

        then

            continue

        elif [ $a == 'n' ]

        then

            selecting

        else

            echo -e "\e[1;31m please enter y or n \e[0m"

            sleep 1

            continue

        fi

done

}
