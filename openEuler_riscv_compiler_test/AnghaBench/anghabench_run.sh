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
	exit
}
array=($(find . -type f -path *.c))
echo "array length: ${#array[@]}"
for src in `find . -type f -path *.c`
do
	if ! ${CC} $src -c -o ${src}.o &> ./log/$(basename $src).log; then
		echo "${RED}Compilation Error${NONE} $src"
		failed=$(($failed + 1))
    else
        echo "${GREEN}Passed${NONE} $src"
		rm ${src}.o
		passed=$(($passed + 1))
	fi
	total=$(($total + 1))
	summary
done
summary