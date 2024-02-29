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

gcc_install() {
    yum install -y gcc
}

create_logdir() {
    if [ -d "./anghaLeaves_failure_log" ]; then
        rm -rf anghaLeaves_failure_log
    fi
	if [ -d "./anghaMath_failure_log" ]; then
        rm -rf anghaMath_failure_log
    fi
    
    mkdir anghaLeaves_failure_log
	mkdir anghaMath_failure_log
}

run() {
    anghaleaves_array=($(find benchmarks/anghaLeaves -type f))
    anghamath_array=($(find benchmarks/anghaMath -type f))
    echo "anghaLeaves test case num: ${#anghaleaves_array[@]}"
    echo "anghaMath test case num: ${#anghamath_array[@]}"
    echo "total test case num: $[${#anghaleaves_array[@]}+${#anghamath_array[@]}]"

    for src in ${anghaleaves_array[@]}
    do
        $CC $src -o ${src}.out &> ./anghaLeaves_failure_log/$(basename $src).log
        if [ ! -e ${src}.out ]; then
            echo "${RED}Compilation Error${NONE} $src"
            failed=$(($failed + 1))
        else 
            ${src}.out &>> ./anghaLeaves_failure_log/$(basename $src).log
            if ${src}.out 0 &>> ./anghaLeaves_failure_log/$(basename $src).log; then
                echo "${GREEN}Passed${NONE} $src"
                rm -rf ${src}.out
                rm -rf ./nghaLeaves_failure_log/$(basename $src).log
                passed=$(($passed + 1))
            else
                echo "${RED}Test Run Failed${NONE} $src"
                failed=$(($failed + 1))
            fi
        fi
        total=$(($total + 1))
	    summary
    done
    
    for src in ${anghamath_array[@]}
    do
        $CC $src -o ${src}.out &> ./anghaMath_failure_log/$(basename $src).log
        if [ ! -e ${src}.out ]; then
            echo "${RED}Compilation Error${NONE} $src"
            failed=$(($failed + 1))
        else
            ${src}.out &>> ./anghaMath_failure_log/$(basename $src).log
            if ${src}.out 0 &>> ./anghaMath_failure_log/$(basename $src).log; then
                echo "${GREEN}Passed${NONE} $src"
                rm -rf ${src}.out
                rm -rf ./anghaMath_failure_log/$(basename $src).log
                passed=$(($passed + 1))
            else
                echo "${RED}Test Run Failed${NONE} $src"
                failed=$(($failed + 1))
            fi
        fi
        total=$(($total + 1))
	    summary
    done
}

gcc_install
create_logdir
run
summary
exit