#!/bin/bash

#runner script

args=("$@")


if test -f "${args[0]}"; then

    if test -f "${args[1]}"; then
        g++ ${args[0]}
        echo "[+] file compiled successfully"
        ./a.out < ${args[1]}
    else
        g++ ${args[0]}
        echo "[+] file compiled successfully, running"
        ./a.out         
    fi

else
    echo "[-] ${args[0]} file doesn't exists." 
fi


