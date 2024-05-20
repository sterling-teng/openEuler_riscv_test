#!/bin/sh

#set -x

RED=$(printf "\033[31m")
GREEN=$(printf "\033[32m")
NONE=$(printf "\033[39m")

total=0
passed=0
failed=0

echo $1


summary() {
	echo "Total: $total Passed: $passed Failed: $failed"
}

create_logdir() {
    if [ -d "./failed_cases" ]; then
        rm -rf failed_cases
    fi
    mkdir -p failed_cases
}

run() {
    for i in `seq 1 $1`
    do
        cfile="random$i.c"
        csmith > $cfile
        gcc $cfile -I/root/csmith/install/include -o random_gcc
        clang $cfile -I/root/csmith/install/include -o random_clang
        gcc_checksum=$(./random_gcc)
        clang_checksum=$(./random_clang)
        gcc_value=${gcc_checksum:11}
        clang_value=${clang_checksum:11}
        if [ $gcc_value = $clang_value ]; then
           echo "${GREEN}Passed${NONE}"
           passed=$(($passed + 1))
        else
           echo "${RED}Failed${NONE}"
           cp $cfile ./failed_cases/
           failed=$(($failed + 1))
	fi
        total=$(($total + 1))
        rm -rf $cfile
        rm -rf random_gcc
        rm -rf random_clang
        summary
    done
}

create_logdir
run $1
summary
exit
 
