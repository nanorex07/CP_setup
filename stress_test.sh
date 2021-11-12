#!/bin/bash

set -e

#cmd arguments
args=("$@")

#colors
green=$(tput setaf 71);
blue=$(tput setaf 32);
orange=$(tput setaf 178);
reset=$(tput sgr0);

#counters
diff_found=0
i=0
accepted=0

#getting arguments
original_file=${args[0]}
brute_file=${args[1]}
generator_file=${args[2]}
total_tests=${args[3]}
[ -z $total_tests ] && total_tests=100

#check the validity of files provided
if [[ ! -f "$original_file" ]] || [[ ! -f "$brute_file" ]] || [[ ! -f "$generator_file" ]] 
then
	echo "[-] Invalid or Insufficent Arguments, exiting"
	exit
fi

#compile all files
g++ -std=c++17 $generator_file -o generator
g++ -std=c++17 $original_file -o original
g++ -std=c++17 $brute_file -o brute

echo "Running tests..."
while [ $i -le $total_tests ]
do
	# Generate test_case and save it in temp_input.txt
	./generator > temp_input.txt

	# run original solution, take input from above generated test case i.e. from temp_input.txt
	# and save it in original_output.txt
	./original < temp_input.txt > original_output.txt

	# run brute force solution, take input from above generated test case i.e. from temp_input.txt
	# and save it in brute_output.txt
	./brute < temp_input.txt > brute_output.txt

	# check if files original_output and brute_output
	# differs(we are ignoring spaces and then comparing files)
	if diff --tabsize=1 --side-by-side original_output.txt brute_output.txt > dont_show_on_terminal.txt; then
		accepted=$((accepted+1))
	else
		echo "${orange}[-] Wrong Answer${reset}"
		diff_found=1
		break
	fi
	i=$((i+1))
done

#give the test case where solution failed
if [ $diff_found -eq 1 ]
then
	echo "[+] ${accepted} Accepted, failed at"
	echo "${blue}Input: ${reset}"
	cat temp_input.txt

	echo "${blue}Output: ${reset}"
	cat original_output.txt

	echo "${blue}Expected: ${reset}"
	cat brute_output.txt
else
	echo "${green}[+] Accepted${reset}"
fi

#remove all the temp files created
rm temp_input.txt
rm generator
rm original
rm brute
rm original_output.txt
rm brute_output.txt
rm dont_show_on_terminal.txt