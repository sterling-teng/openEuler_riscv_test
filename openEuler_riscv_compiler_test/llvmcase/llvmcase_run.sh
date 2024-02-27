#!/bin/sh

RED=$(printf "\033[31m")
GREEN=$(printf "\033[32m")
NONE=$(printf "\033[39m")

total=0
passed=0
failed=0

summary() {
	echo "Total: $total Passed: $passed Failed: $failed"
}

install_gcc() {
	yum install -y gcc gcc-g++ gcc-fortran
}

create_logdir() {
	if [ -d "./log_failure" ]; then
        rm -rf log_failure
    fi
	mkdir log_failure
}

run_gccbuild() {
	array=($(find . -type f -path *.c))
	for src in ${array[@]}
	do
	    if ! gcc $src -c -o ${src}.o &> ./log_failure/$(basename $src).log; then
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

run_gplusbuild() {
	array=($(find . -type f -path *.cpp))
	for src in ${array[@]}
	do
	    if ! g++ $src -c -o ${src}.o &> ./log_failure/$(basename $src).log; then
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

run_gfortranbuild() {
	f_array=`find . -type f -path *.f`
    f90_array=`find . -type f -path *.f90`
    F90_array=`find . -type f -path *.F90`
    total_f_array=(${f_array[@]} ${f90_array[@]} ${F90_array[@]})
	for src in ${total_f_array[@]}
	do
	    if ! gfortran $src -c -o ${src}.o &> ./log_failure/$(basename $src).log; then
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


# for src in `find . -type f -path *.c`
# do
# 	if ! gcc $src -c -o ${src}.o &> ./log/$(basename $src).log; then
# 		echo "${RED}Compilation Error${NONE} $src"
# 		failed=$(($failed + 1))
#     else
#         echo "${GREEN}Passed${NONE} $src"
# 		rm ${src}.o
# 		passed=$(($passed + 1))
# 	fi
# 	total=$(($total + 1))
# done

# for src in `find . -type f -path *.cpp`
# do
# 	if ! g++ $src -c -o ${src}.o &> ./log/$(basename $src).log; then
# 		echo "${RED}Compilation Error${NONE} $src"
# 		failed=$(($failed + 1))
#     else
#         echo "${GREEN}Passed${NONE} $src"
# 		rm ${src}.o
# 		passed=$(($passed + 1))
# 	fi
# 	total=$(($total + 1))
# done

# f_array=`find . -type f -path *.f`
# f90_array=`find . -type f -path *.f90`
# F90_array=`find . -type f -path *.F90`
# total_f_array=(${f_array[@]} ${f90_array[@]} ${F90_array[@]})
# for src in ${total_f_array[@]}
# do
# 	if ! gfortran $src -c -o ${src}.o &> ./log/$(basename $src).log; then
# 		echo "${RED}Compilation Error${NONE} $src"
# 		failed=$(($failed + 1))
#     else
#         echo "${GREEN}Passed${NONE} $src"
# 		rm ${src}.o
# 		passed=$(($passed + 1))
# 	fi
# 	total=$(($total + 1))
# done

install_gcc
create_logdir
run_gccbuild
run_gplusbuild
run_gfortranbuild
summary
exit