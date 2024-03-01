#!/bin/sh

RED=$(printf "\033[31m")
GREEN=$(printf "\033[32m")
NONE=$(printf "\033[39m")
CC=g++

total=0
passed=0
failed=0

summary() {
	echo "Total: $total Passed: $passed Failed: $failed"
}

gcc_install() {
    yum install -y gcc gcc-g++
}

create_logdir() {
    if [ -d "./yarpgen_failure_log" ]; then
        rm -rf yarpgen_failure_log
    fi
    if [ -d "./testdir" ]; then
        rm -rf testdir
    fi
    mkdir yarpgen_failure_log
    mkdir testdir && cd testdir
}

run() {
    for i in `seq $1`
        string=$(../yarpgen)
        pattern='[0-9]+'
        dirname=seed_$(echo $string | grep -oE "$pattern")
        cat init.h func.cpp driver.cpp > test_random.cpp
        optlevel_array=(O0 O3)
        result_array=()
        for optlevel in ${optlevel_array[@]}
        do
            echo "$compiler -$optlevel test_random.cpp -o ${compiler}_${optlevel}.out" > log.txt
            $compiler -$optlevel test_random.cpp -o ${compiler}_${optlevel}.out &>> log.txt
            if [ ! -e ${compiler}_${optlevel}.out ]; then
                echo "${RED}Compilation Error${NONE} $dirname"
            else
                echo "./${compiler}_${optlevel}.out" >> log.txt
                if ./${compiler}_${optlevel}.out &>> log.txt
                    result_array+=$(./${compiler}_${optlevel}.out)
                    echo "./${compiler}_${optlevel}.out : $(./${compiler}_${optlevel}.out)" >> log.txt
                else
                    echo "${RED}Test Run Failed${NONE} $dirname"
                fi
            fi
        done
       
        if [ ${#result_array[@]} == 2 ]; then 
            if [ ${result_array[0]} == ${result_array[1]} ]; then
                echo "${GREEN}Passed${NONE} $src"
                rm -rf ./*
                passed=$(($passed + 1))
            else
                echo "${RED}Output Mismatch${NONE} $dirname"
                echo "Output Mismatch" >> log.txt
                mkdir ../yarpgen_failure_log/$dirname/
                mv ./* ../yarpgen_failure_log/$dirname/
                failed=$(($failed + 1))
            fi
        else
            echo "${RED}Test Error${NONE} $dirname"
            echo "Test Error" >> log.txt
            mkdir ../yarpgen_failure_log/$dirname/
            mv ./* ../yarpgen_failure_log/$dirname/
            failed=$(($failed + 1))
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