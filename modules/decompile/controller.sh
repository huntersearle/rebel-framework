#!/bin/bash

normal='\e[0m'
arr[0]='\e[1;94m' ; blue=${arr[0]}
arr[1]='\e[1;31m' ; red=${arr[1]}
arr[2]='\e[1;33m' ; yellow=${arr[2]}
arr[3]='\e[1;35m' ; purp=${arr[3]}
arr[4]='\e[1;32m' ; green=${arr[4]}
arr[5]='\e[97m'   ; white=${arr[5]}
grayterm='\e[1;40m'

module=$(echo $1 | cut -d '/' -f 2 )

if [[ $module != "jd" ]] && [[ $module != "pyc" ]] ; then
   echo -e "${red}[x] Wrong module name"
   exit
fi   

misc(){
    if [[ $1 == "back" ]] || [[ $1 == "exit" ]] || [[ $1 == "quit" ]] ; then
        exit
    elif [[ $1 == '!' ]] ; then
        $2
    elif [[ $1 == "clear" ]] || [[ $1 == "reset" ]] ; then
        clear   
    elif [[ $1 == "help" ]] || [[ $1 == "?" ]] ; then
        bash print_help_modules.sh help 
    elif [[ $1 == "banner" ]] ; then
        rand="$[ $RANDOM % 6 ]"
        color="${arr[$rand]}" # select random color
        echo -e $color
        python print_banner.py  
    elif [[ $1 == "" ]] ; then
        :               
    else
       echo -e "${purp}[-] Invalid parameter use show 'help' for more information"         
    fi    
}

file=""
log="INFO"
flags=""
output="."

while IFS= read -e -p "$( echo -e $white ; echo -e ${grayterm}{REBEL}➤[${white}$1]~#${normal} ) " cmd1 ; do
    history -s "$cmd1"
    if [[ ${1} =~ 'decompile/jd' ]] ; then
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
          {
            echo -e "  Option\t\t\t\t|Value"
            echo -e "  ======\t\t\t\t|====="
            echo -e "  file\t\t\t\t|$file"
            echo -e "  log\t\t\t\t|$log"
            echo -e "  flags\t\t\t\t|$flags"
          } | column -t -s "|"
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash print_help_modules.sh modules
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash print_help_modules.sh help
        fi 
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
          if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'file' ]] ; then
             file=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'log' ]] ; then
             log=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'flags' ]] ; then
             flags=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          fi
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
          echo -e "bash jd-cli -g $log $flags $file"
          bash jd/jd-cli $flags -g $log $file
      else 
         misc $cmd1  
      fi
   elif [[ ${1} =~ 'decompile/pyc' ]] ; then
      if [[ $( echo $cmd1 | cut -d " " -f 1 ) == "show" ]] ; then
        if [[ $( echo $cmd1 | cut -d " " -f 2 ) == "options" ]] ; then
          {
            echo -e "  Option\t\t\t\t|Value"
            echo -e "  ======\t\t\t\t|====="
            echo -e "  file\t\t\t\t|$file"
            echo -e "  flags\t\t\t\t|$flags"
            echo -e "  output\t\t\t\t|$output"
          } | column -t -s "|"
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "modules" ]] ; then
          bash print_help_modules.sh modules
        elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == "help" ]] ; then
          bash print_help_modules.sh help
        fi 
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'set' ]] ; then
          if [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'file' ]] ; then
             file=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'flags' ]] ; then
             flags=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          elif [[ $( echo $cmd1 | cut -d " " -f 2 ) == 'output' ]] ; then
             output=$( echo $cmd1 | cut -d " " -f 3- | sed "s/'//g")
          fi
      elif [[ $( echo $cmd1 | cut -d " " -f 1 ) == 'run' ]] ; then
          uncompyle6 $flags -o $output $file
      else 
         misc $cmd1  
      fi
   fi
done    
