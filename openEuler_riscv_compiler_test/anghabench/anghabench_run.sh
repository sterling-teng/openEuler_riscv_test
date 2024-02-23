#!/bin/sh

RED=$(printf "\033[31m")
GREEN=$(printf "\033[32m")
NONE=$(printf "\033[39m")
CC=gcc

total=0
passed=0
failed=0

summary() {
	echo "Total: $total Passed: $passed Failed: $failed"
}

create_logdir() {
	if [ -d "./log_failure" ]; then
        rm -rf log_failure
    fi
	mkdir log_failure
}

run() {
	array=($(find . -type f -path *.c))
    echo "array length: ${#array[@]}"
	for src in ${array[@]}
	do
	    if ! $CC $src -c -o ${src}.o &> ./log_failure/$(basename $src).log; then
		    echo "${RED}Compilation Error${NONE} $src"
		    failed=$(($failed + 1))
        else
            echo "${GREEN}Passed${NONE} $src"
		    rm -rf ${src}.o
			rm -rf ./log_failure/$(basename $src).log
		    passed=$(($passed + 1))
	    fi
	    total=$(($total + 1))
	    summary
    done
}

create_logdir	
run
summary
exit