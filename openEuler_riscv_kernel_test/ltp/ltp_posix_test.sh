#!/usr/bin/bash

cd /opt/ltp/testcases/open_posix_testsuite
./configure
make all

echo "---- start posix conformance test ----"
make conformance-test > /opt/posix_conformance_result.txt
pcnt=$(grep PASS /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
fcnt=$(grep FAIL /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
tcnt=$(grep TOTAL /opt/posix_conformance_result.txt | awk '{print $2}' | awk '{sum +=$1}; END {print sum}')
echo "posix conformance PASS:'$pcnt', FAIL:'$fcnt', TOTAL:'$tcnt'"
echo "the success rate is:"
awk 'BEGIN{printf "%.3f%\n", ('$pcnt'/'$tcnt')*100}'
echo "---- End All confromance test ----"

cd bin
echo "---- start posix option test ----"
./run-all-posix-option-group-tests.sh >/opt/posix_option_group_result.txt
pcnt=`expr $(grep -o 'Test PASSED' /opt/posix_option_group_result.txt | wc -l) + $(grep -o 'Test passed' /opt/posix_option_group_result.txt | wc -l)`
fcnt=$(grep -o 'Test FAILED' /opt/posix_option_group_result.txt | wc -l)
scnt=$(grep -o 'Test skipped' /opt/posix_option_group_result.txt | wc -l)
tcnt=`expr $pcnt + $fcnt + $scnt`
echo "posix option PASS:'$pcnt', FAIL:'$fcnt', SKIP:'$scnt', TOTAL:'$tcnt'"
echo "the success rate is:"
awk 'BEGIN{printf "%.3f%\n", ('$pcnt'/'$tcnt')*100}'
echo "---- End posix option test ----"
