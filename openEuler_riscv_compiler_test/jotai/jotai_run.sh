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
    if [ -d "./anghaLeaves_failure_log" ]; then
        rm -rf anghaLeaves_failure_log
    fi
	if [ -d "./anghaMath_failure_log" ]; then
        rm -rf anghaMath_failure_log
    fi
    
    mkdir nghaLeaves_failure_log
	mkdir anghaMath_failure_log
}

run() {
    anghaleaves_array=($(ls benchmarks/anghaLeaves))
    anghamath_array=($(ls benchmarks/anghaMath))
    echo "anghaLeaves test case num: ${#anghaleaves_array[@]}"
    echo "anghaMath test case num: ${#anghamath_array[@]}"
    echo "total test case num: $[${#anghaleaves_array[@]}+${#anghamath_array[@]}]"

    for src in ${anghaleaves_array[@]}
    do
        if ! $CC $src -o ${src}.out &> ./nghaLeaves_failure_log/$(basename $src).log; then
            echo "${RED}Compilation Error${NONE} $src"
            failed=$(($failed + 1))
        elif ! (${src}.out && ${src}.out 0) &>> ./nghaLeaves_failure_log/$(basename $src).log; then
              echo "${RED}Test Run Failed${NONE} $src"
              failed=$(($failed + 1))
        else
              echo "${GREEN}Passed${NONE} $src"
              rm -rf ${src}.out
              rm -rf ./nghaLeaves_failure_log/$(basename $src).log
              passed=$(($passed + 1))
        fi
        total=$(($total + 1))
	    summary
    done
    
    for src in ${anghamath_array[@]}
    do
        if ! $CC $src -o ${src}.out &> ./anghaMath_failure_log/$(basename $src).log; then
            echo "${RED}Compilation Error${NONE} $src"
            failed=$(($failed + 1))
        elif ! (${src}.out && ${src}.out 0) &>> ./anghaMath_failure_log/$(basename $src).log; then
              echo "${RED}Test Run Failed${NONE} $src"
              failed=$(($failed + 1))
        else
              echo "${GREEN}Passed${NONE} $src"
              rm -rf ${src}.out
              rm -rf ./anghaMath_failure_log/$(basename $src).log
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