###  openEuler riscv64中使用libmicro进行对各种系统调用和lib调用性能测试

#### 1. libmicro介绍

libmicro是用来衡量各种系统调用和库调用性能的微基准工具

#### 2. 在openEuler riscv64中使用libmicro

硬件环境：D1开发板烧入openEuler riscv64 22.03 v2 版本 [https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/D1/](https://gitee.com/link?target=https%3A%2F%2Frepo.tarsier-infra.com%2FopenEuler-RISC-V%2Fpreview%2FopenEuler-22.03-V2-riscv64%2FD1%2F)

##### 2.1 安装编译

安装所需软件包

````
$ yum install unzip
````

下载libmicro源码并进行编译

````
$ wget https://github.com/redhat-performance/libMicro/archive/refs/heads/0.4.0-rh.zip   //下载0.4.0-rh分支
$ unzip 0.4.0-rh.zip
$ cd libMicro-0.4.0-rh
$ make
````

执行测试

````
$ ./bench
````

或者

````
$ sh bench.sh
````

测试结果

````
!Libmicro_#:                            0.4.0
!Options:                  -E -C 200 -L -S -W
!Machine_name:              openEuler-riscv64
!OS_name:                               Linux
!OS_release:     6.1.0-0.rc3.8.oe2203.riscv64
!OS_build:                 #1 PREEMPT Tue Dec
!Processor:                           riscv64
!#CPUs:                                     1
!CPU_MHz:                                    
!CPU_NAME:                                   
!IP_address:        fe80::1967:e7dd:7ecd:ad63
!Run_by:                                 root
!Date:	                       05/31/23 17:26
!Compiler:                                gcc
!Compiler Ver.:                        10.3.1
!sizeof(long):                              8
!extra_CFLAGS:                         [none]
!TimerRes:                         1000 nsecs
# 
# Obligatory null system call: use very short time
# for default since SuSe implements this "syscall" in userland
# 
# bin/getpid -E -C 200 -L -S -W -N getpid -I 1 
             prc thr   usecs/call      samples   errors cnt/samp 
getpid         1   1      0.61324          191        0   100000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.58835                 0.59439
#                    max      1.26912                 0.63381
#                   mean      0.62084                 0.61258
#                 median      0.61387                 0.61324
#                 stddev      0.05409                 0.00740
#         standard error      0.00381                 0.00054
#   99% confidence level      0.00885                 0.00124
#                   skew      9.28760                -0.18497
#               kurtosis    101.80999                -0.26434
#       time correlation      0.00004                 0.00004
#
#           elasped time     12.54524
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      0.00000 |********************************     0.61181
#
#                 10        > 95% |*                                    0.62645
#
#        mean of 95%      0.61181
#          95th %ile      0.62339
 
# bin/getenv -E -C 200 -L -S -W -N getenv -s 100 -I 50 
             prc thr   usecs/call      samples   errors cnt/samp 
getenv         1   1      0.91151          190        0     2000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.90332                 0.90332
#                    max      1.67439                 0.94940
#                   mean      0.93121                 0.91833
#                 median      0.91190                 0.91151
#                 stddev      0.07104                 0.01193
#         standard error      0.00500                 0.00087
#   99% confidence level      0.01163                 0.00201
#                   skew      7.35189                 0.90742
#               kurtosis     64.74705                 0.06373
#       time correlation     -0.00022                -0.00001
#
#           elasped time      0.38055
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          210
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                180      0.00000 |********************************     0.91674
#
#                 10        > 95% |*                                    0.94693
#
#        mean of 95%      0.91674
#          95th %ile      0.94594
# bin/getenv -E -C 200 -L -S -W -N getenvT2 -s 100 -I 50 -T 2 
             prc thr   usecs/call      samples   errors cnt/samp 
getenvT2       1   2      1.87393          193        0     2000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.83989                 1.83989
#                    max      2.05096                 1.90145
#                   mean      1.88023                 1.87451
#                 median      1.87483                 1.87393
#                 stddev      0.03060                 0.01175
#         standard error      0.00215                 0.00085
#   99% confidence level      0.00501                 0.00197
#                   skew      3.92257                 0.01886
#               kurtosis     17.16687                 0.00179
#       time correlation     -0.00000                 0.00001
#
#           elasped time      0.79618
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          229
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                183      1.00000 |********************************     1.87321
#
#                 10        > 95% |*                                    1.89832
#
#        mean of 95%      1.87321
#          95th %ile      1.89582
 
# bin/gettimeofday -E -C 200 -L -S -W -N gettimeofday 
             prc thr   usecs/call      samples   errors cnt/samp 
gettimeofday   1   1      0.19964          194        0    20000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.19569                 0.19569
#                    max      0.21549                 0.20298
#                   mean      0.19986                 0.19932
#                 median      0.19984                 0.19964
#                 stddev      0.00300                 0.00129
#         standard error      0.00021                 0.00009
#   99% confidence level      0.00049                 0.00021
#                   skew      3.46283                -0.39965
#               kurtosis     13.77709                -0.04788
#       time correlation     -0.00001                -0.00001
#
#           elasped time      0.81110
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                184      0.00000 |********************************     0.19919
#
#                 10        > 95% |*                                    0.20158
#
#        mean of 95%      0.19919
#          95th %ile      0.20069
 
# bin/log -E -C 200 -L -S -W -N log -I 20 
             prc thr   usecs/call      samples   errors cnt/samp 
log            1   1      0.09877          174        0     5000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.09852                 0.09852
#                    max      0.15678                 0.09877
#                   mean      0.10010                 0.09873
#                 median      0.09877                 0.09877
#                 stddev      0.00618                 0.00008
#         standard error      0.00043                 0.00001
#   99% confidence level      0.00101                 0.00001
#                   skew      7.16661                -1.73488
#               kurtosis     56.38776                 1.62760
#       time correlation     -0.00000                -0.00000
#
#           elasped time      0.10458
#      number of samples          174
#     number of outliers           28
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                165      0.00000 |********************************     0.09873
#
#                  9        > 95% |*                                    0.09877
#
#        mean of 95%      0.09873
#          95th %ile      0.09877
# bin/exp -E -C 200 -L -S -W -N exp -I 10 
             prc thr   usecs/call      samples   errors cnt/samp 
exp            1   1      0.09309          193        0    10000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.09296                 0.09296
#                    max      0.12478                 0.09588
#                   mean      0.09405                 0.09350
#                 median      0.09309                 0.09309
#                 stddev      0.00350                 0.00081
#         standard error      0.00025                 0.00006
#   99% confidence level      0.00057                 0.00014
#                   skew      6.95005                 1.40650
#               kurtosis     53.27055                 0.12439
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.19337
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                183      0.00000 |********************************     0.09340
#
#                 10        > 95% |*                                    0.09529
#
#        mean of 95%      0.09340
#          95th %ile      0.09506
# bin/lrand48 -E -C 200 -L -S -W -N lrand48 
             prc thr   usecs/call      samples   errors cnt/samp 
lrand48        1   1      0.08359          194        0    10000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.08346                 0.08346
#                    max      0.11438                 0.08579
#                   mean      0.08427                 0.08389
#                 median      0.08359                 0.08359
#                 stddev      0.00281                 0.00068
#         standard error      0.00020                 0.00005
#   99% confidence level      0.00046                 0.00011
#                   skew      8.43073                 1.62786
#               kurtosis     79.37471                 0.72295
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.17348
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                184      0.00000 |********************************     0.08381
#
#                 10        > 95% |*                                    0.08545
#
#        mean of 95%      0.08381
#          95th %ile      0.08528
 
# bin/memset -E -C 200 -L -S -W -N memset_10 -s 10 -I 3 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_10      1   1      0.06247          192        0    33333       10          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.06190                 0.06190
#                    max      0.08517                 0.06313
#                   mean      0.06258                 0.06224
#                 median      0.06247                 0.06247
#                 stddev      0.00205                 0.00033
#         standard error      0.00014                 0.00002
#   99% confidence level      0.00034                 0.00005
#                   skew      7.91885                 0.27387
#               kurtosis     75.02534                -1.26948
#       time correlation      0.00000                 0.00000
#
#           elasped time      0.42515
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                182      0.00000 |********************************     0.06220
#
#                 10        > 95% |*                                    0.06289
#
#        mean of 95%      0.06220
#          95th %ile      0.06274
# bin/memset -E -C 200 -L -S -W -N memset_256 -s 256 -I 10 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_256     1   1      0.09168          189        0    10000      256          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.09158                 0.09158
#                    max      0.13136                 0.09398
#                   mean      0.09280                 0.09208
#                 median      0.09168                 0.09168
#                 stddev      0.00417                 0.00076
#         standard error      0.00029                 0.00006
#   99% confidence level      0.00068                 0.00013
#                   skew      7.08797                 1.48186
#               kurtosis     54.35993                 0.23715
#       time correlation     -0.00001                 0.00000
#
#           elasped time      0.19094
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                179      0.00000 |********************************     0.09199
#
#                 10        > 95% |*                                    0.09371
#
#        mean of 95%      0.09199
#          95th %ile      0.09360
# bin/memset -E -C 200 -L -S -W -N memset_256_u -s 256 -a 1 -I 10 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_256_u   1   1      0.15327          189        0    10000      256           1
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.15317                 0.15317
#                    max      0.18376                 0.15647
#                   mean      0.15476                 0.15399
#                 median      0.15330                 0.15327
#                 stddev      0.00414                 0.00099
#         standard error      0.00029                 0.00007
#   99% confidence level      0.00068                 0.00017
#                   skew      5.66694                 0.62299
#               kurtosis     34.16876                -1.37469
#       time correlation     -0.00000                -0.00000
#
#           elasped time      0.31622
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                179      0.00000 |********************************     0.15388
#
#                 10        > 95% |*                                    0.15584
#
#        mean of 95%      0.15388
#          95th %ile      0.15547
# bin/memset -E -C 200 -L -S -W -N memset_1k -s 1k -I 12 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_1k      1   1      0.21579          195        0     8333     1024          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.21567                 0.21567
#                    max      0.25478                 0.22083
#                   mean      0.21765                 0.21694
#                 median      0.21582                 0.21579
#                 stddev      0.00480                 0.00141
#         standard error      0.00034                 0.00010
#   99% confidence level      0.00079                 0.00024
#                   skew      6.30826                 0.47216
#               kurtosis     43.84340                -1.26633
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.37044
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      0.00000 |********************************     0.21679
#
#                 10        > 95% |*                                    0.21974
#
#        mean of 95%      0.21679
#          95th %ile      0.21880
# bin/memset -E -C 200 -L -S -W -N memset_4k -s 4k -I 62 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_4k      1   1      0.68885          188        0     1612     4096          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.68806                 0.68806
#                    max      0.92083                 0.70734
#                   mean      0.69771                 0.69197
#                 median      0.68885                 0.68885
#                 stddev      0.02923                 0.00570
#         standard error      0.00206                 0.00042
#   99% confidence level      0.00478                 0.00097
#                   skew      5.66041                 1.19035
#               kurtosis     34.41694                -0.47686
#       time correlation     -0.00005                 0.00000
#
#           elasped time      0.23199
#      number of samples          188
#     number of outliers           14
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                178      0.00000 |********************************     0.69132
#
#                 10        > 95% |*                                    0.70353
#
#        mean of 95%      0.69132
#          95th %ile      0.70228
# bin/memset -E -C 200 -L -S -W -N memset_4k_uc -s 4k -u -I 100 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_4k_uc   1   1      1.93079          189        0     1000     4096          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.92695                 1.92695
#                    max      2.86493                 1.97584
#                   mean      1.95534                 1.94053
#                 median      1.94871                 1.93079
#                 stddev      0.08417                 0.01205
#         standard error      0.00592                 0.00088
#   99% confidence level      0.01377                 0.00204
#                   skew      7.72360                 0.39600
#               kurtosis     71.13931                -1.19970
#       time correlation     -0.00006                -0.00000
#
#           elasped time      2.02213
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                179      1.00000 |********************************     1.93923
#
#                 10        > 95% |*                                    1.96379
#
#        mean of 95%      1.93923
#          95th %ile      1.95664
 
# bin/memset -E -C 200 -L -S -W -N memset_10k -s 10k -I 150 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_10k     1   1      1.64151          196        0      666    10240          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.63960                 1.63960
#                    max      2.21312                 1.70150
#                   mean      1.65946                 1.65251
#                 median      1.64151                 1.64151
#                 stddev      0.05630                 0.01808
#         standard error      0.00396                 0.00129
#   99% confidence level      0.00921                 0.00300
#                   skew      7.78259                 1.09307
#               kurtosis     68.78339                -0.65096
#       time correlation      0.00003                 0.00000
#
#           elasped time      0.22844
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      1.00000 |********************************     1.65055
#
#                 10        > 95% |*                                    1.68901
#
#        mean of 95%      1.65055
#          95th %ile      1.68201
# bin/memset -E -C 200 -L -S -W -N memset_1m -s 1m -I 200000 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_1m      1   1    369.48870          173        0        1  1048576          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    366.77510               367.49190
#                    max    409.85990               371.38310
#                   mean    371.43721               369.50379
#                 median    369.59110               369.48870
#                 stddev      7.28991                 0.68950
#         standard error      0.51292                 0.05242
#   99% confidence level      1.19304                 0.12193
#                   skew      3.74561                -0.18269
#               kurtosis     13.12242                 1.24190
#       time correlation      0.00406                -0.00074
#
#           elasped time      0.78598
#      number of samples          173
#     number of outliers           29
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  8    367.00000 |**                                 367.69350
#                 23    368.00000 |******                             368.80640
#                111    369.00000 |********************************   369.50484
#                 22    370.00000 |******                             370.24623
#
#                  9        > 95% |**                                 371.06737
#
#        mean of 95%    369.41799
#          95th %ile    370.87110
# bin/memset -E -C 200 -L -S -W -N memset_10m -s 10m -I 2000000 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memset_10m     1   1   3522.28150          196        0        1 10485760          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   3511.96470              3511.96470
#                    max   3764.99510              3559.88790
#                   mean   3531.53932              3528.49734
#                 median   3522.87030              3522.28150
#                 stddev     25.12174                14.37078
#         standard error      1.76756                 1.02648
#   99% confidence level      4.11134                 2.38760
#                   skew      4.84876                 0.44932
#               kurtosis     37.99343                -1.44205
#       time correlation     -0.02176                -0.01090
#
#           elasped time      7.39136
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   3510.00000 |*                                 3511.96470
#                 22   3512.00000 |********************              3513.10390
#                 35   3514.00000 |********************************  3514.97892
#                 17   3516.00000 |***************                   3516.64498
#                  6   3518.00000 |*****                             3519.25643
#                 17   3520.00000 |***************                   3520.94729
#                 12   3522.00000 |**********                        3523.07510
#                  6   3524.00000 |*****                             3524.82443
#                  1   3526.00000 |*                                 3526.99190
#                  2   3528.00000 |*                                 3528.68150
#                  1   3530.00000 |*                                 3530.67830
#                  1   3532.00000 |*                                 3532.77750
#                  3   3534.00000 |**                                3534.75723
#                  2   3536.00000 |*                                 3537.73110
#                  1   3538.00000 |*                                 3539.76630
#                  2   3540.00000 |*                                 3541.28950
#                 17   3542.00000 |***************                   3543.36385
#                 21   3544.00000 |*******************               3545.18375
#                 15   3546.00000 |*************                     3546.50251
#                  2   3548.00000 |*                                 3548.93110
#                  2   3550.00000 |*                                 3550.53110
#
#                 10        > 95% |*********                         3554.81142
#
#        mean of 95%   3527.08260
#          95th %ile   3551.08150
# bin/memset -E -C 200 -L -S -W -N memsetP2_10m -s 10m -P 2 -I 2000000 
             prc thr   usecs/call      samples   errors cnt/samp     size       alignment
memsetP2_10m   2   1   7092.96980          177        0        1 10485760          4k
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   7052.88020              7052.88020
#                    max   7843.89460              7152.66900
#                   mean   7133.29905              7090.95073
#                 median   7094.55700              7092.96980
#                 stddev    136.98414                20.90126
#         standard error      9.63817                 1.57103
#   99% confidence level     22.41838                 3.65423
#                   skew      3.38143                 0.22472
#               kurtosis     11.31678                -0.14540
#       time correlation     -0.74299                -0.04128
#
#           elasped time     14.94556
#      number of samples          177
#     number of outliers           25
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   7050.00000 |*                                 7052.88020
#                  0   7053.00000 |                                           -
#                  9   7056.00000 |***********                       7057.63896
#                 12   7059.00000 |***************                   7060.46633
#                  9   7062.00000 |***********                       7063.56962
#                  8   7065.00000 |**********                        7066.33620
#                  4   7068.00000 |*****                             7068.91860
#                  3   7071.00000 |***                               7071.74740
#                  0   7074.00000 |                                           -
#                  2   7077.00000 |**                                7078.48020
#                  2   7080.00000 |**                                7081.83380
#                  2   7083.00000 |**                                7085.87860
#                 11   7086.00000 |**************                    7087.56820
#                 19   7089.00000 |************************          7090.55801
#                 25   7092.00000 |********************************  7093.72449
#                 12   7095.00000 |***************                   7096.51967
#                 13   7098.00000 |****************                  7099.50765
#                 12   7101.00000 |***************                   7102.20287
#                  2   7104.00000 |**                                7104.78420
#                  7   7107.00000 |********                          7108.84911
#                  4   7110.00000 |*****                             7111.45940
#                  1   7113.00000 |*                                 7114.47380
#                  1   7116.00000 |*                                 7118.87700
#                  3   7119.00000 |***                               7120.18260
#                  1   7122.00000 |*                                 7122.25620
#                  2   7125.00000 |**                                7126.82580
#                  3   7128.00000 |***                               7129.08287
#
#                  9        > 95% |***********                       7137.25496
#
#        mean of 95%   7088.47014
#          95th %ile   7129.68020
 
# bin/memrand -E -C 200 -L -S -W -N memrand -s 128m -B 10000 
             prc thr   usecs/call      samples   errors cnt/samp     size
memrand        1   1      0.15778          193        0    10000 134217728 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.15737                 0.15737
#                    max      0.19377                 0.16098
#                   mean      0.15926                 0.15853
#                 median      0.15778                 0.15778
#                 stddev      0.00456                 0.00106
#         standard error      0.00032                 0.00008
#   99% confidence level      0.00075                 0.00018
#                   skew      6.13385                 0.55801
#               kurtosis     39.10525                -1.48730
#       time correlation     -0.00000                 0.00000
#
#           elasped time      1.34552
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                183      0.00000 |********************************     0.15843
#
#                 10        > 95% |*                                    0.16035
#
#        mean of 95%      0.15843
#          95th %ile      0.15998
#
# benchmark cachetocache not compiled/supported on this platform
#
 
# bin/isatty -E -C 200 -L -S -W -N isatty_yes 
             prc thr   usecs/call      samples   errors cnt/samp 
isatty_yes     1   1      2.43454          186        0    20000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      2.38119                 2.38119
#                    max      2.81804                 2.64479
#                   mean      2.47823                 2.45649
#                 median      2.44549                 2.43454
#                 stddev      0.09708                 0.06366
#         standard error      0.00683                 0.00467
#   99% confidence level      0.01589                 0.01086
#                   skew      1.54867                 1.08640
#               kurtosis      1.84653                 0.33453
#       time correlation     -0.00005                -0.00016
#
#           elasped time     10.01662
#      number of samples          186
#     number of outliers           16
#      getnsecs overhead          227
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                176      2.00000 |********************************     2.44740
#
#                 10        > 95% |*                                    2.61659
#
#        mean of 95%      2.44740
#          95th %ile      2.58805
# bin/isatty -E -C 200 -L -S -W -N isatty_no -f /tmp/libmicro.289520/ifile 
             prc thr   usecs/call      samples   errors cnt/samp 
isatty_no      1   1      0.82953          200        0    20000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.81369                 0.81369
#                    max      0.86899                 0.85674
#                   mean      0.83100                 0.83067
#                 median      0.82979                 0.82953
#                 stddev      0.00962                 0.00907
#         standard error      0.00068                 0.00064
#   99% confidence level      0.00157                 0.00149
#                   skew      0.70116                 0.44402
#               kurtosis      0.47218                -0.47709
#       time correlation     -0.00002                -0.00002
#
#           elasped time      3.36141
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                190      0.00000 |********************************     0.82963
#
#                 10        > 95% |*                                    0.85039
#
#        mean of 95%      0.82963
#          95th %ile      0.84835
 
# bin/malloc -E -C 200 -L -S -W -N malloc_10 -s 10 -g 10 -I 50 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
malloc_10      1   1      0.30409          191        0     2000     10 10 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.29989                 0.29989
#                    max      0.33034                 0.31154
#                   mean      0.30532                 0.30447
#                 median      0.30419                 0.30409
#                 stddev      0.00449                 0.00253
#         standard error      0.00032                 0.00018
#   99% confidence level      0.00073                 0.00043
#                   skew      2.70642                 0.64015
#               kurtosis     10.04103                -0.08144
#       time correlation     -0.00000                -0.00000
#
#           elasped time      1.23726
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      0.00000 |********************************     0.30414
#
#                 10        > 95% |*                                    0.31044
#
#        mean of 95%      0.30414
#          95th %ile      0.30953
# bin/malloc -E -C 200 -L -S -W -N malloc_100 -s 100 -g 10 -I 50 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
malloc_100     1   1      0.30380          183        0     2000     10 100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.29969                 0.29969
#                    max      0.52974                 0.31094
#                   mean      0.30664                 0.30401
#                 median      0.30394                 0.30380
#                 stddev      0.01695                 0.00236
#         standard error      0.00119                 0.00017
#   99% confidence level      0.00277                 0.00041
#                   skew     11.46033                 0.45838
#               kurtosis    145.90421                -0.31912
#       time correlation     -0.00001                 0.00000
#
#           elasped time      1.24275
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          228
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                173      0.00000 |********************************     0.30371
#
#                 10        > 95% |*                                    0.30908
#
#        mean of 95%      0.30371
#          95th %ile      0.30805
# bin/malloc -E -C 200 -L -S -W -N malloc_1k -s 1k -g 10 -I 50 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
malloc_1k      1   1      0.37639          184        0     2000     10 1024 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.37124                 0.37124
#                    max      0.41169                 0.38364
#                   mean      0.37801                 0.37657
#                 median      0.37664                 0.37639
#                 stddev      0.00547                 0.00253
#         standard error      0.00038                 0.00019
#   99% confidence level      0.00089                 0.00043
#                   skew      2.55204                 0.18539
#               kurtosis      8.94826                -0.43950
#       time correlation      0.00000                 0.00000
#
#           elasped time      1.53121
#      number of samples          184
#     number of outliers           18
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                174      0.00000 |********************************     0.37628
#
#                 10        > 95% |*                                    0.38162
#
#        mean of 95%      0.37628
#          95th %ile      0.38079
# bin/malloc -E -C 200 -L -S -W -N malloc_10k -s 10k -g 10 -I 50 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
malloc_10k     1   1      0.59369          169        0     2000     10 10240 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.58915                 0.58915
#                    max      0.65564                 0.59994
#                   mean      0.59647                 0.59376
#                 median      0.59414                 0.59369
#                 stddev      0.00741                 0.00223
#         standard error      0.00052                 0.00017
#   99% confidence level      0.00121                 0.00040
#                   skew      3.38442                 0.35702
#               kurtosis     19.27772                 0.01607
#       time correlation      0.00001                 0.00000
#
#           elasped time      2.41374
#      number of samples          169
#     number of outliers           33
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                160      0.00000 |********************************     0.59347
#
#                  9        > 95% |*                                    0.59890
#
#        mean of 95%      0.59347
#          95th %ile      0.59739
# bin/malloc -E -C 200 -L -S -W -N malloc_100k -s 100k -g 10 -I 2000 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
malloc_100k    1   1     55.29147          196        0       50     10 102400 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     55.00577                55.00577
#                    max    149.24193                56.51361
#                   mean     56.39293                55.47081
#                 median     55.30324                55.29147
#                 stddev      8.28939                 0.36448
#         standard error      0.58324                 0.02603
#   99% confidence level      1.35661                 0.06056
#                   skew      9.77611                 0.83799
#               kurtosis     97.84634                -0.64189
#       time correlation     -0.00828                 0.00075
#
#           elasped time      5.70027
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                175     55.00000 |********************************    55.39016
#                 11     56.00000 |**                                  56.04476
#
#                 10        > 95% |*                                   56.25080
#
#        mean of 95%     55.42888
#          95th %ile     56.09940
 
# bin/malloc -E -C 200 -L -S -W -N mallocT2_10 -s 10 -g 10 -T 2 -I 200 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
mallocT2_10    1   2      0.63617          193        0      500     10 10 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.62373                 0.62373
#                    max      0.72193                 0.65593
#                   mean      0.63970                 0.63691
#                 median      0.63637                 0.63617
#                 stddev      0.01502                 0.00727
#         standard error      0.00106                 0.00052
#   99% confidence level      0.00246                 0.00122
#                   skew      3.06931                 0.18453
#               kurtosis     11.17752                -0.63444
#       time correlation      0.00000                 0.00002
#
#           elasped time      0.67941
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                183      0.00000 |********************************     0.63611
#
#                 10        > 95% |*                                    0.65163
#
#        mean of 95%      0.63611
#          95th %ile      0.64912
# bin/malloc -E -C 200 -L -S -W -N mallocT2_100 -s 100 -g 10 -T 2 -I 200 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
mallocT2_100   1   2      0.63632          191        0      500     10 100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.62496                 0.62496
#                    max      0.71153                 0.65056
#                   mean      0.63994                 0.63692
#                 median      0.63653                 0.63632
#                 stddev      0.01418                 0.00455
#         standard error      0.00100                 0.00033
#   99% confidence level      0.00232                 0.00077
#                   skew      3.75667                 0.37778
#               kurtosis     14.51827                -0.01573
#       time correlation     -0.00001                -0.00001
#
#           elasped time      0.68601
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      0.00000 |********************************     0.63638
#
#                 10        > 95% |*                                    0.64665
#
#        mean of 95%      0.63638
#          95th %ile      0.64497
# bin/malloc -E -C 200 -L -S -W -N mallocT2_1k -s 1k -g 10 -T 2 -I 200 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
mallocT2_1k    1   2      0.78915          186        0      500     10 1024 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.77676                 0.77676
#                    max      0.92038                 0.80236
#                   mean      0.79326                 0.78887
#                 median      0.78997                 0.78915
#                 stddev      0.01848                 0.00457
#         standard error      0.00130                 0.00034
#   99% confidence level      0.00302                 0.00078
#                   skew      4.32915                 0.01651
#               kurtosis     21.19770                -0.15079
#       time correlation      0.00002                -0.00001
#
#           elasped time      0.84193
#      number of samples          186
#     number of outliers           16
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                176      0.00000 |********************************     0.78834
#
#                 10        > 95% |*                                    0.79824
#
#        mean of 95%      0.78834
#          95th %ile      0.79637
# bin/malloc -E -C 200 -L -S -W -N mallocT2_10k -s 10k -g 10 -T 2 -I 200 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
mallocT2_10k   1   2      1.30115          182        0      500     10 10240 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.28073                 1.28073
#                    max      1.76800                 1.32256
#                   mean      1.31194                 1.30182
#                 median      1.30300                 1.30115
#                 stddev      0.04473                 0.00754
#         standard error      0.00315                 0.00056
#   99% confidence level      0.00732                 0.00130
#                   skew      7.09958                -0.00555
#               kurtosis     61.95986                -0.04682
#       time correlation     -0.00007                -0.00003
#
#           elasped time      1.36394
#      number of samples          182
#     number of outliers           20
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                172      1.00000 |********************************     1.30095
#
#                 10        > 95% |*                                    1.31673
#
#        mean of 95%      1.30095
#          95th %ile      1.31375
# bin/malloc -E -C 200 -L -S -W -N mallocT2_100k -s 100k -g 10 -T 2 -I 10000 
             prc thr   usecs/call      samples   errors cnt/samp   glob  sizes
mallocT2_100k   1   2     91.01863          179        0       10     10 102400 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     90.42727                90.42727
#                    max     96.58663                92.11687
#                   mean     91.46192                91.09218
#                 median     91.07751                91.01863
#                 stddev      1.13190                 0.37492
#         standard error      0.07964                 0.02802
#   99% confidence level      0.18524                 0.06518
#                   skew      2.26775                 0.38102
#               kurtosis      4.54938                -0.62307
#       time correlation      0.00170                 0.00236
#
#           elasped time      1.89377
#      number of samples          179
#     number of outliers           23
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 87     90.00000 |********************************    90.78067
#                 83     91.00000 |******************************      91.33548
#
#                  9        > 95% |***                                 91.85973
#
#        mean of 95%     91.05155
#          95th %ile     91.71751
 
# bin/close -E -C 200 -L -S -W -N close_bad -B 1800 -b 
             prc thr   usecs/call      samples   errors cnt/samp 
close_bad      1   1      0.71255          195        0     1800 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.66377                 0.67984
#                    max      0.87440                 0.74199
#                   mean      0.71496                 0.71348
#                 median      0.71269                 0.71255
#                 stddev      0.02193                 0.01303
#         standard error      0.00154                 0.00093
#   99% confidence level      0.00359                 0.00217
#                   skew      3.53213                -0.06946
#               kurtosis     23.32669                -0.51688
#       time correlation     -0.00005                -0.00003
#
#           elasped time      0.27846
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      0.00000 |********************************     0.71215
#
#                 10        > 95% |*                                    0.73801
#
#        mean of 95%      0.71215
#          95th %ile      0.73488
# bin/close -E -C 200 -L -S -W -N close_tmp -B 640 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
close_tmp      1   1      6.89686          201        0      640 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.26206                 6.26206
#                    max      7.77326                 7.62766
#                   mean      6.91333                 6.90906
#                 median      6.89966                 6.89686
#                 stddev      0.24966                 0.24274
#         standard error      0.01757                 0.01712
#   99% confidence level      0.04086                 0.03983
#                   skew      0.38143                 0.24846
#               kurtosis      0.53271                 0.20445
#       time correlation     -0.00011                -0.00013
#
#           elasped time      3.29623
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                135      6.00000 |********************************     6.77846
#                 55      7.00000 |*************                        7.12032
#
#                 11        > 95% |**                                   7.45548
#
#        mean of 95%      6.87742
#          95th %ile      7.29806
# bin/close -E -C 200 -L -S -W -N close_usr -B 640 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
close_usr      1   1      6.43407          183        0      640 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.13887                 6.13887
#                    max      7.09007                 6.72927
#                   mean      6.48385                 6.43459
#                 median      6.45287                 6.43407
#                 stddev      0.19058                 0.11606
#         standard error      0.01341                 0.00858
#   99% confidence level      0.03119                 0.01996
#                   skew      1.32116                 0.07895
#               kurtosis      1.68134                -0.51115
#       time correlation     -0.00047                -0.00043
#
#           elasped time      3.46550
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                173      6.00000 |********************************     6.42114
#
#                 10        > 95% |*                                    6.66723
#
#        mean of 95%      6.42114
#          95th %ile      6.62167
# bin/close -E -C 200 -L -S -W -N close_zero -B 640 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp 
close_zero     1   1      6.32924          191        0      640 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.06684                 6.06684
#                    max      7.39484                 6.60724
#                   mean      6.36104                 6.33558
#                 median      6.33564                 6.32924
#                 stddev      0.14632                 0.09123
#         standard error      0.01030                 0.00660
#   99% confidence level      0.02395                 0.01535
#                   skew      2.69422                 0.61063
#               kurtosis     12.80170                 0.78389
#       time correlation     -0.00012                -0.00017
#
#           elasped time      3.58684
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          228
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      6.00000 |********************************     6.32292
#
#                 10        > 95% |*                                    6.56460
#
#        mean of 95%      6.32292
#          95th %ile      6.50884
 
# bin/memcpy -E -C 200 -L -S -W -N memcpy_10 -s 10 -I 5 
             prc thr   usecs/call      samples   errors cnt/samp     size
memcpy_10      1   1      0.11203          190        0    20000       10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.11108                 0.11108
#                    max      0.12494                 0.11319
#                   mean      0.11216                 0.11171
#                 median      0.11204                 0.11203
#                 stddev      0.00216                 0.00055
#         standard error      0.00015                 0.00004
#   99% confidence level      0.00035                 0.00009
#                   skew      4.62582                 0.33351
#               kurtosis     22.80960                -0.79120
#       time correlation     -0.00000                -0.00000
#
#           elasped time      0.45684
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                180      0.00000 |********************************     0.11164
#
#                 10        > 95% |*                                    0.11294
#
#        mean of 95%      0.11164
#          95th %ile      0.11268
# bin/memcpy -E -C 200 -L -S -W -N memcpy_1k -s 1k -I 25 
             prc thr   usecs/call      samples   errors cnt/samp     size
memcpy_1k      1   1      0.56571          195        0     4000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.55470                 0.55470
#                    max      0.65121                 0.57671
#                   mean      0.56689                 0.56482
#                 median      0.56571                 0.56571
#                 stddev      0.01317                 0.00590
#         standard error      0.00093                 0.00042
#   99% confidence level      0.00215                 0.00098
#                   skew      4.17112                -0.35802
#               kurtosis     21.67742                -0.93474
#       time correlation     -0.00004                -0.00003
#
#           elasped time      0.46181
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      0.00000 |********************************     0.56432
#
#                 10        > 95% |*                                    0.57407
#
#        mean of 95%      0.56432
#          95th %ile      0.57172
# bin/memcpy -E -C 200 -L -S -W -N memcpy_10k -s 10k -I 200 
             prc thr   usecs/call      samples   errors cnt/samp     size
memcpy_10k     1   1      6.21524          200        0      500    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      5.39553                 5.39553
#                    max      8.19566                 7.22184
#                   mean      6.10401                 6.08541
#                 median      6.22344                 6.21524
#                 stddev      0.48756                 0.45217
#         standard error      0.03430                 0.03197
#   99% confidence level      0.07979                 0.07437
#                   skew      0.48963                 0.01461
#               kurtosis      0.76126                -1.00161
#       time correlation      0.00029                -0.00011
#
#           elasped time      0.62062
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 85      5.00000 |*************************            5.61962
#                105      6.00000 |********************************     6.37708
#
#                 10        > 95% |***                                  6.98217
#
#        mean of 95%      6.03822
#          95th %ile      6.75131
# bin/memcpy -E -C 200 -L -S -W -N memcpy_1m -s 1m -I 31250 
             prc thr   usecs/call      samples   errors cnt/samp     size
memcpy_1m      1   1    770.57100          194        0        3  1048576
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    756.57633               756.57633
#                    max   3873.88833               787.29633
#                   mean    784.58045               765.87723
#                 median    770.57100               770.57100
#                 stddev    219.33903                 7.38312
#         standard error     15.43264                 0.53008
#   99% confidence level     35.89632                 1.23296
#                   skew     13.83315                -0.01030
#               kurtosis    191.81923                -1.37216
#       time correlation     -0.47140                -0.01097
#
#           elasped time      0.48064
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 21    756.00000 |*****************                  756.80795
#                 34    757.00000 |****************************       757.71829
#                 24    758.00000 |********************               758.43944
#                  6    759.00000 |*****                              759.27856
#                  0    760.00000 |                                           -
#                  0    761.00000 |                                           -
#                  0    762.00000 |                                           -
#                  0    763.00000 |                                           -
#                  0    764.00000 |                                           -
#                  0    765.00000 |                                           -
#                  0    766.00000 |                                           -
#                  0    767.00000 |                                           -
#                  0    768.00000 |                                           -
#                  7    769.00000 |*****                              769.80300
#                 22    770.00000 |******************                 770.67185
#                 38    771.00000 |********************************   771.64665
#                 27    772.00000 |**********************             772.47362
#                  5    773.00000 |****                               773.64300
#
#                 10        > 95% |********                           777.55980
#
#        mean of 95%    765.24230
#          95th %ile    773.98433
# bin/memcpy -E -C 200 -L -S -W -N memcpy_10m -s 10m -I 5000000 
             prc thr   usecs/call      samples   errors cnt/samp     size
memcpy_10m     1   1   8102.95800          165        0        1 10485760
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   8085.80600              8085.80600
#                    max  14329.64600              8146.73400
#                   mean   8178.74794              8107.69788
#                 median   8113.71000              8102.95800
#                 stddev    447.39478                13.45911
#         standard error     31.47859                 1.04779
#   99% confidence level     73.21919                 2.43716
#                   skew     12.88424                 0.60943
#               kurtosis    173.87922                -0.47837
#       time correlation     -0.84748                -0.00806
#
#           elasped time      1.65984
#      number of samples          165
#     number of outliers           37
#      getnsecs overhead          210
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2   8084.00000 |***                               8085.80600
#                  0   8086.00000 |                                           -
#                  3   8088.00000 |*****                             8089.39000
#                  8   8090.00000 |*************                     8090.79800
#                 10   8092.00000 |****************                  8093.48600
#                 15   8094.00000 |*************************         8095.56813
#                 19   8096.00000 |********************************  8097.25863
#                 10   8098.00000 |****************                  8099.16920
#                 14   8100.00000 |***********************           8101.36714
#                  6   8102.00000 |**********                        8103.51267
#                  4   8104.00000 |******                            8104.81400
#                  1   8106.00000 |*                                 8106.79800
#                  3   8108.00000 |*****                             8108.67533
#                  1   8110.00000 |*                                 8111.91800
#                  8   8112.00000 |*************                     8113.42200
#                 10   8114.00000 |****************                  8115.29720
#                 13   8116.00000 |*********************             8117.25462
#                  9   8118.00000 |***************                   8119.22822
#                  8   8120.00000 |*************                     8121.13400
#                  4   8122.00000 |******                            8122.73400
#                  1   8124.00000 |*                                 8124.71800
#                  2   8126.00000 |***                               8126.76600
#                  2   8128.00000 |***                               8129.19800
#                  0   8130.00000 |                                           -
#                  3   8132.00000 |*****                             8132.82467
#
#                  9        > 95% |***************                   8137.66022
#
#        mean of 95%   8105.96928
#          95th %ile   8132.91000
 
# bin/strcpy -E -C 200 -L -S -W -N strcpy_10 -s 10 -I 5 
             prc thr   usecs/call      samples   errors cnt/samp     size
strcpy_10      1   1      0.15173          185        0    20000       10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.15079                 0.15079
#                    max      0.17943                 0.15290
#                   mean      0.15227                 0.15158
#                 median      0.15173                 0.15173
#                 stddev      0.00311                 0.00050
#         standard error      0.00022                 0.00004
#   99% confidence level      0.00051                 0.00009
#                   skew      5.49283                -0.15285
#               kurtosis     35.33182                -0.15935
#       time correlation      0.00000                -0.00000
#
#           elasped time      0.61912
#      number of samples          185
#     number of outliers           17
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                175      0.00000 |********************************     0.15151
#
#                 10        > 95% |*                                    0.15268
#
#        mean of 95%      0.15151
#          95th %ile      0.15240
# bin/strcpy -E -C 200 -L -S -W -N strcpy_1k -s 1k -I 25 
             prc thr   usecs/call      samples   errors cnt/samp     size
strcpy_1k      1   1      1.61140          169        0     4000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.60666                 1.60666
#                    max      1.78119                 1.62215
#                   mean      1.62118                 1.61152
#                 median      1.61172                 1.61140
#                 stddev      0.02695                 0.00378
#         standard error      0.00190                 0.00029
#   99% confidence level      0.00441                 0.00068
#                   skew      2.93159                 0.78780
#               kurtosis      8.82231                 0.24484
#       time correlation      0.00003                 0.00000
#
#           elasped time      1.31402
#      number of samples          169
#     number of outliers           33
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                160      1.00000 |********************************     1.61099
#
#                  9        > 95% |*                                    1.62093
#
#        mean of 95%      1.61099
#          95th %ile      1.61972
 
# bin/strlen -E -C 200 -L -S -W -N strlen_10 -s 10 -I 5 
             prc thr   usecs/call      samples   errors cnt/samp     size
strlen_10      1   1      0.06540          194        0    20000       10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.06533                 0.06533
#                    max      0.08019                 0.06690
#                   mean      0.06591                 0.06570
#                 median      0.06540                 0.06540
#                 stddev      0.00155                 0.00047
#         standard error      0.00011                 0.00003
#   99% confidence level      0.00025                 0.00008
#                   skew      7.49525                 0.88545
#               kurtosis     63.92943                -1.01260
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.26994
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          210
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                184      0.00000 |********************************     0.06565
#
#                 10        > 95% |*                                    0.06661
#
#        mean of 95%      0.06565
#          95th %ile      0.06640
# bin/strlen -E -C 200 -L -S -W -N strlen_1k -s 1k -I 100 
             prc thr   usecs/call      samples   errors cnt/samp     size
strlen_1k      1   1      1.06576          191        0     1000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.06473                 1.06473
#                    max      1.39856                 1.09469
#                   mean      1.07605                 1.07040
#                 median      1.06576                 1.06576
#                 stddev      0.03468                 0.00837
#         standard error      0.00244                 0.00061
#   99% confidence level      0.00568                 0.00141
#                   skew      7.03769                 1.27404
#               kurtosis     55.64252                -0.27347
#       time correlation     -0.00003                 0.00001
#
#           elasped time      0.22104
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      1.00000 |********************************     1.06947
#
#                 10        > 95% |*                                    1.08739
#
#        mean of 95%      1.06947
#          95th %ile      1.08573
 
# bin/strchr -E -C 200 -L -S -W -N strchr_10 -s 10 -I 5 
             prc thr   usecs/call      samples   errors cnt/samp     size
strchr_10      1   1      0.07583          191        0    20000       10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.07578                 0.07578
#                    max      0.09348                 0.07719
#                   mean      0.07651                 0.07611
#                 median      0.07584                 0.07583
#                 stddev      0.00229                 0.00042
#         standard error      0.00016                 0.00003
#   99% confidence level      0.00038                 0.00007
#                   skew      6.23472                 0.67778
#               kurtosis     39.99745                -1.32657
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.31278
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      0.00000 |********************************     0.07607
#
#                 10        > 95% |*                                    0.07689
#
#        mean of 95%      0.07607
#          95th %ile      0.07675
# bin/strchr -E -C 200 -L -S -W -N strchr_1k -s 1k -I 50 
             prc thr   usecs/call      samples   errors cnt/samp     size
strchr_1k      1   1      1.46050          188        0     2000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.45141                 1.45141
#                    max      1.61397                 1.47342
#                   mean      1.46492                 1.45899
#                 median      1.46088                 1.46050
#                 stddev      0.02690                 0.00498
#         standard error      0.00189                 0.00036
#   99% confidence level      0.00440                 0.00085
#                   skew      4.55506                 0.04027
#               kurtosis     20.69613                 0.18918
#       time correlation      0.00000                -0.00001
#
#           elasped time      0.59572
#      number of samples          188
#     number of outliers           14
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                178      1.00000 |********************************     1.45835
#
#                 10        > 95% |*                                    1.47040
#
#        mean of 95%      1.45835
#          95th %ile      1.46536
 
# bin/strcmp -E -C 200 -L -S -W -N strcmp_10 -s 10 -I 3 
             prc thr   usecs/call      samples   errors cnt/samp     size
strcmp_10      1   1      0.10323          196        0    33333       10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.09854                 0.09854
#                    max      0.11445                 0.10745
#                   mean      0.10271                 0.10243
#                 median      0.10325                 0.10323
#                 stddev      0.00235                 0.00172
#         standard error      0.00017                 0.00012
#   99% confidence level      0.00038                 0.00029
#                   skew      1.28406                -1.13338
#               kurtosis      6.31395                 0.38517
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.69547
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      0.00000 |********************************     0.10230
#
#                 10        > 95% |*                                    0.10477
#
#        mean of 95%      0.10230
#          95th %ile      0.10358
# bin/strcmp -E -C 200 -L -S -W -N strcmp_1k -s 1k -I 50 
             prc thr   usecs/call      samples   errors cnt/samp     size
strcmp_1k      1   1      6.16194          143        0     2000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.15835                 6.15835
#                    max      6.49730                 6.16898
#                   mean      6.18884                 6.16281
#                 median      6.16283                 6.16194
#                 stddev      0.05739                 0.00211
#         standard error      0.00404                 0.00018
#   99% confidence level      0.00939                 0.00041
#                   skew      2.37672                 1.51835
#               kurtosis      5.28185                 1.60724
#       time correlation      0.00001                 0.00000
#
#           elasped time      2.50430
#      number of samples          143
#     number of outliers           59
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                135      6.00000 |********************************     6.16247
#
#                  8        > 95% |*                                    6.16854
#
#        mean of 95%      6.16247
#          95th %ile      6.16795
 
# bin/strcasecmp -E -C 200 -L -S -W -N scasecmp_10 -s 10 -I 6 
             prc thr   usecs/call      samples   errors cnt/samp     size
scasecmp_10    1   1      0.18312          190        0    16666       10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.18184                 0.18184
#                    max      0.20273                 0.18444
#                   mean      0.18354                 0.18289
#                 median      0.18312                 0.18312
#                 stddev      0.00306                 0.00062
#         standard error      0.00022                 0.00004
#   99% confidence level      0.00050                 0.00010
#                   skew      4.67947                -0.45100
#               kurtosis     22.63000                -0.27903
#       time correlation     -0.00000                -0.00000
#
#           elasped time      0.62175
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                180      0.00000 |********************************     0.18282
#
#                 10        > 95% |*                                    0.18411
#
#        mean of 95%      0.18282
#          95th %ile      0.18372
# bin/strcasecmp -E -C 200 -L -S -W -N scasecmp_1k -s 1k -I 155 
             prc thr   usecs/call      samples   errors cnt/samp     size
scasecmp_1k    1   1     13.41526          158        0      645     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     13.41208                13.41208
#                    max     14.07093                13.44026
#                   mean     13.47255                13.41876
#                 median     13.41684                13.41526
#                 stddev      0.14098                 0.00790
#         standard error      0.00992                 0.00063
#   99% confidence level      0.02307                 0.00146
#                   skew      2.73156                 1.57018
#               kurtosis      6.14641                 1.03529
#       time correlation     -0.00001                 0.00003
#
#           elasped time      1.75942
#      number of samples          158
#     number of outliers           44
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                150     13.00000 |********************************    13.41769
#
#                  8        > 95% |*                                   13.43887
#
#        mean of 95%     13.41769
#          95th %ile     13.43709
# bin/strtol -E -C 200 -L -S -W -N strtol -I 20 
             prc thr   usecs/call      samples   errors cnt/samp 
strtol         1   1      0.21034          196        0     5000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.19754                 0.19754
#                    max      0.31996                 0.23993
#                   mean      0.21347                 0.21175
#                 median      0.21039                 0.21034
#                 stddev      0.01432                 0.00952
#         standard error      0.00101                 0.00068
#   99% confidence level      0.00234                 0.00158
#                   skew      3.17242                 0.88922
#               kurtosis     16.70324                 0.45036
#       time correlation     -0.00004                -0.00004
#
#           elasped time      0.21894
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      0.00000 |********************************     0.21053
#
#                 10        > 95% |*                                    0.23444
#
#        mean of 95%      0.21053
#          95th %ile      0.23118
 
# bin/getcontext -E -C 200 -L -S -W -N getcontext -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
getcontext     1   1      0.77879          195        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.74065                 0.74065
#                    max      1.42980                 0.82564
#                   mean      0.78596                 0.77930
#                 median      0.77879                 0.77879
#                 stddev      0.05362                 0.01681
#         standard error      0.00377                 0.00120
#   99% confidence level      0.00877                 0.00280
#                   skew      9.18330                 0.59167
#               kurtosis    102.61176                 0.44645
#       time correlation     -0.00003                 0.00001
#
#           elasped time      0.16235
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      0.00000 |********************************     0.77709
#
#                 10        > 95% |*                                    0.82024
#
#        mean of 95%      0.77709
#          95th %ile      0.81566
# bin/setcontext -E -C 200 -L -S -W -N setcontext -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
setcontext     1   1      0.84893          197        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.82564                 0.82564
#                    max      0.99280                 0.89680
#                   mean      0.85395                 0.85120
#                 median      0.84970                 0.84893
#                 stddev      0.02368                 0.01568
#         standard error      0.00167                 0.00112
#   99% confidence level      0.00388                 0.00260
#                   skew      2.91810                 0.70799
#               kurtosis     12.68461                 0.05848
#       time correlation     -0.00014                -0.00012
#
#           elasped time      0.17622
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                187      0.00000 |********************************     0.84914
#
#                 10        > 95% |*                                    0.88976
#
#        mean of 95%      0.84914
#          95th %ile      0.88272
 
# bin/mutex -E -C 200 -L -S -W -N mutex_st -I 10 
             prc thr   usecs/call      samples   errors cnt/samp holdtime
mutex_st       1   1      0.12609          192        0    10000        0
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.12498                 0.12498
#                    max      0.15860                 0.12936
#                   mean      0.12698                 0.12635
#                 median      0.12609                 0.12609
#                 stddev      0.00381                 0.00102
#         standard error      0.00027                 0.00007
#   99% confidence level      0.00062                 0.00017
#                   skew      6.37446                 0.62597
#               kurtosis     45.02060                -0.52142
#       time correlation     -0.00000                -0.00000
#
#           elasped time      0.26013
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          206
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                182      0.00000 |********************************     0.12624
#
#                 10        > 95% |*                                    0.12847
#
#        mean of 95%      0.12624
#          95th %ile      0.12808
# bin/mutex -E -C 200 -L -S -W -N mutex_mt -t -I 10 
             prc thr   usecs/call      samples   errors cnt/samp holdtime
mutex_mt       1   1      0.14288          190        0    10000        0
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.14277                 0.14277
#                    max      0.17598                 0.14608
#                   mean      0.14424                 0.14353
#                 median      0.14288                 0.14288
#                 stddev      0.00393                 0.00092
#         standard error      0.00028                 0.00007
#   99% confidence level      0.00064                 0.00015
#                   skew      6.03141                 0.87640
#               kurtosis     39.84193                -0.77414
#       time correlation     -0.00000                 0.00000
#
#           elasped time      0.29716
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                180      0.00000 |********************************     0.14342
#
#                 10        > 95% |*                                    0.14550
#
#        mean of 95%      0.14342
#          95th %ile      0.14477
# bin/mutex -E -C 200 -L -S -W -N mutex_T2 -T 2 -I 25 
             prc thr   usecs/call      samples   errors cnt/samp holdtime
mutex_T2       1   2      0.29422          197        0     4000        0
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.29114                 0.29114
#                    max      0.37114                 0.30714
#                   mean      0.29704                 0.29600
#                 median      0.29422                 0.29422
#                 stddev      0.00876                 0.00424
#         standard error      0.00062                 0.00030
#   99% confidence level      0.00143                 0.00070
#                   skew      5.79549                 0.85415
#               kurtosis     43.83181                -0.70369
#       time correlation      0.00001                 0.00001
#
#           elasped time      0.26372
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                187      0.00000 |********************************     0.29554
#
#                 10        > 95% |*                                    0.30462
#
#        mean of 95%      0.29554
#          95th %ile      0.30369
 
# bin/longjmp -E -C 200 -L -S -W -N longjmp -I 5 
             prc thr   usecs/call      samples   errors cnt/samp 
longjmp        1   1      0.10698          187        0    20000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.10613                 0.10613
#                    max      0.12209                 0.10769
#                   mean      0.10716                 0.10663
#                 median      0.10698                 0.10698
#                 stddev      0.00243                 0.00045
#         standard error      0.00017                 0.00003
#   99% confidence level      0.00040                 0.00008
#                   skew      4.76421                 0.08176
#               kurtosis     23.13856                -1.70511
#       time correlation     -0.00000                -0.00000
#
#           elasped time      0.43629
#      number of samples          187
#     number of outliers           15
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                177      0.00000 |********************************     0.10659
#
#                 10        > 95% |*                                    0.10735
#
#        mean of 95%      0.10659
#          95th %ile      0.10714
# bin/siglongjmp -E -C 200 -L -S -W -N siglongjmp -I 20 
             prc thr   usecs/call      samples   errors cnt/samp 
siglongjmp     1   1      1.48634          196        0     5000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.34114                 1.38174
#                    max      1.97459                 1.61014
#                   mean      1.49890                 1.49431
#                 median      1.48972                 1.48634
#                 stddev      0.05869                 0.04240
#         standard error      0.00413                 0.00303
#   99% confidence level      0.00960                 0.00704
#                   skew      2.91195                 0.46560
#               kurtosis     20.08436                -0.54335
#       time correlation      0.00005                 0.00008
#
#           elasped time      1.51794
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      1.00000 |********************************     1.48941
#
#                 10        > 95% |*                                    1.58539
#
#        mean of 95%      1.48941
#          95th %ile      1.57098
 
# bin/getrusage -E -C 200 -L -S -W -N getrusage -I 200 
             prc thr   usecs/call      samples   errors cnt/samp 
getrusage      1   1      2.47764          188        0      500 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      2.42952                 2.42952
#                    max      3.10126                 2.58107
#                   mean      2.49436                 2.47731
#                 median      2.48123                 2.47764
#                 stddev      0.08389                 0.03578
#         standard error      0.00590                 0.00261
#   99% confidence level      0.01373                 0.00607
#                   skew      4.32468                 0.66030
#               kurtosis     24.69172                -0.57011
#       time correlation      0.00018                -0.00008
#
#           elasped time      0.25567
#      number of samples          188
#     number of outliers           14
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                178      2.00000 |********************************     2.47297
#
#                 10        > 95% |*                                    2.55465
#
#        mean of 95%      2.47297
#          95th %ile      2.54369
 
# bin/times -E -C 200 -L -S -W -N times -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
times          1   1      2.66269          196        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      2.45073                 2.45073
#                    max      3.28861                 2.92663
#                   mean      2.65539                 2.64346
#                 median      2.66397                 2.66269
#                 stddev      0.12189                 0.10055
#         standard error      0.00858                 0.00718
#   99% confidence level      0.01995                 0.01671
#                   skew      0.95752                -0.17822
#               kurtosis      3.65907                 0.09831
#       time correlation      0.00104                 0.00093
#
#           elasped time      0.54010
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      2.00000 |********************************     2.63251
#
#                 10        > 95% |*                                    2.84717
#
#        mean of 95%      2.63251
#          95th %ile      2.75485
# bin/time -E -C 200 -L -S -W -N time -I 2 
             prc thr   usecs/call      samples   errors cnt/samp 
time           1   1      0.11668          195        0    50000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.11540                 0.11540
#                    max      0.14762                 0.12288
#                   mean      0.11782                 0.11742
#                 median      0.11672                 0.11668
#                 stddev      0.00317                 0.00185
#         standard error      0.00022                 0.00013
#   99% confidence level      0.00052                 0.00031
#                   skew      4.86315                 1.02958
#               kurtosis     38.28227                -0.10386
#       time correlation      0.00001                 0.00001
#
#           elasped time      1.19367
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      0.00000 |********************************     0.11719
#
#                 10        > 95% |*                                    0.12174
#
#        mean of 95%      0.11719
#          95th %ile      0.12066
# bin/localtime_r -E -C 200 -L -S -W -N localtime_r -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
localtime_r    1   1      0.96081          191        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.94161                 0.94161
#                    max      2.18474                 1.00868
#                   mean      0.98387                 0.96411
#                 median      0.96183                 0.96081
#                 stddev      0.12780                 0.01534
#         standard error      0.00899                 0.00111
#   99% confidence level      0.02092                 0.00258
#                   skew      7.86667                 0.75776
#               kurtosis     65.67359                 0.20288
#       time correlation     -0.00006                 0.00006
#
#           elasped time      0.20214
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                181      0.00000 |********************************     0.96203
#
#                 10        > 95% |*                                    1.00177
#
#        mean of 95%      0.96203
#          95th %ile      0.99383
# bin/strftime -E -C 200 -L -S -W -N strftime -I 250 
             prc thr   usecs/call      samples   errors cnt/samp   format
strftime       1   1      3.10982          188        0      400       %c
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      3.05158                 3.05158
#                    max      4.02182                 3.22438
#                   mean      3.15049                 3.12536
#                 median      3.11174                 3.10982
#                 stddev      0.12460                 0.03444
#         standard error      0.00877                 0.00251
#   99% confidence level      0.02039                 0.00584
#                   skew      5.13207                 0.88186
#               kurtosis     29.04299                -0.36684
#       time correlation     -0.00003                -0.00003
#
#           elasped time      0.25991
#      number of samples          188
#     number of outliers           14
#      getnsecs overhead          231
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                178      3.00000 |********************************     3.12104
#
#                 10        > 95% |*                                    3.20217
#
#        mean of 95%      3.12104
#          95th %ile      3.18662
 
# bin/mktime -E -C 200 -L -S -W -N mktime -I 500 
             prc thr   usecs/call      samples   errors cnt/samp 
mktime         1   1     43.11445          183        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     42.63446                42.63446
#                    max     45.69878                43.98486
#                   mean     43.35368                43.18568
#                 median     43.14389                43.11445
#                 stddev      0.60235                 0.28558
#         standard error      0.04238                 0.02111
#   99% confidence level      0.09858                 0.04910
#                   skew      2.03409                 0.75128
#               kurtosis      3.75776                 0.00303
#       time correlation     -0.00169                -0.00199
#
#           elasped time      1.75953
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 54     42.00000 |**************                      42.89676
#                119     43.00000 |********************************    43.26035
#
#                 10        > 95% |**                                  43.85724
#
#        mean of 95%     43.14686
#          95th %ile     43.72886
# bin/mktime -E -C 200 -L -S -W -N mktimeT2 -T 2 -I 1000 
             prc thr   usecs/call      samples   errors cnt/samp 
mktimeT2       1   2     86.30824          181        0      100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     84.97704                84.97704
#                    max     99.54856                88.28712
#                   mean     86.95426                86.40742
#                 median     86.39784                86.30824
#                 stddev      1.94960                 0.68396
#         standard error      0.13717                 0.05084
#   99% confidence level      0.31907                 0.11825
#                   skew      3.28799                 0.43988
#               kurtosis     13.61516                -0.22486
#       time correlation      0.00038                 0.00299
#
#           elasped time      1.79880
#      number of samples          181
#     number of outliers           21
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     84.00000 |*                                   84.97704
#                 53     85.00000 |******************                  85.67408
#                 90     86.00000 |********************************    86.43066
#                 27     87.00000 |*********                           87.26758
#
#                 10        > 95% |***                                 87.90542
#
#        mean of 95%     86.31981
#          95th %ile     87.57800
 
# bin/cascade_mutex -E -C 200 -L -S -W -N c_mutex_1 -I 25 
             prc thr   usecs/call      samples   errors cnt/samp 
c_mutex_1      1   1      0.37044          192        0     4000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.37018                 0.37018
#                    max      0.46964                 0.37998
#                   mean      0.37402                 0.37214
#                 median      0.37044                 0.37044
#                 stddev      0.01110                 0.00264
#         standard error      0.00078                 0.00019
#   99% confidence level      0.00182                 0.00044
#                   skew      6.36969                 0.87653
#               kurtosis     44.90072                -0.71252
#       time correlation      0.00001                 0.00000
#
#           elasped time      0.30595
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                182      0.00000 |********************************     0.37181
#
#                 10        > 95% |*                                    0.37804
#
#        mean of 95%      0.37181
#          95th %ile      0.37639
# bin/cascade_mutex -E -C 200 -L -S -W -N c_mutex_10 -T 10 -I 5000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_mutex_10     1  10    227.79060          197        0       20 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    209.00020               209.00020
#                    max    262.74740               248.09140
#                   mean    228.02271               227.32967
#                 median    227.94420               227.79060
#                 stddev      8.20895                 7.00789
#         standard error      0.57758                 0.49929
#   99% confidence level      1.34345                 1.16135
#                   skew      0.51167                -0.48217
#               kurtosis      2.66368                 0.86192
#       time correlation      0.05924                 0.05299
#
#           elasped time      1.12478
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  6    209.00000 |********                           209.35860
#                  3    210.00000 |****                               210.24180
#                  2    211.00000 |**                                 211.63060
#                  1    212.00000 |*                                  212.87860
#                  2    213.00000 |**                                 213.32020
#                  0    214.00000 |                                           -
#                  2    215.00000 |**                                 215.58580
#                  1    216.00000 |*                                  216.24500
#                  1    217.00000 |*                                  217.79380
#                  4    218.00000 |*****                              218.60980
#                  2    219.00000 |**                                 219.54100
#                  3    220.00000 |****                               220.81887
#                  3    221.00000 |****                               221.47593
#                  7    222.00000 |*********                          222.79311
#                 11    223.00000 |**************                     223.60151
#                 12    224.00000 |****************                   224.45833
#                 10    225.00000 |*************                      225.42516
#                  9    226.00000 |************                       226.45229
#                 24    227.00000 |********************************   227.43433
#                 15    228.00000 |********************               228.48436
#                 16    229.00000 |*********************              229.51220
#                 14    230.00000 |******************                 230.60203
#                  8    231.00000 |**********                         231.42740
#                  3    232.00000 |****                               232.63327
#                 11    233.00000 |**************                     233.50987
#                  8    234.00000 |**********                         234.50100
#                  1    235.00000 |*                                  235.84180
#                  4    236.00000 |*****                              236.47540
#                  4    237.00000 |*****                              237.44500
#
#                 10        > 95% |*************                      241.19092
#
#        mean of 95%    226.58843
#          95th %ile    237.88980
# bin/cascade_mutex -E -C 200 -L -S -W -N c_mutex_200 -T 200 -I 2000000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_mutex_200    1 200   9679.37850          170        0        1 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   9566.35450              9566.35450
#                    max  12601.87450              9967.37850
#                   mean   9881.00004              9703.67215
#                 median   9688.33850              9679.37850
#                 stddev    486.46690                92.58066
#         standard error     34.22769                 7.10061
#   99% confidence level     79.61361                16.51602
#                   skew      2.80067                 0.92318
#               kurtosis      8.06590                -0.17671
#       time correlation     -0.25550                 0.01549
#
#           elasped time      9.21493
#      number of samples          170
#     number of outliers           32
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  5   9560.00000 |******                            9572.70330
#                  7   9580.00000 |********                          9590.54650
#                 11   9600.00000 |**************                    9610.00250
#                 22   9620.00000 |****************************      9631.79741
#                 18   9640.00000 |***********************           9650.44339
#                 25   9660.00000 |********************************  9669.34842
#                 25   9680.00000 |********************************  9688.25146
#                 11   9700.00000 |**************                    9710.41268
#                  4   9720.00000 |*****                             9727.73050
#                  0   9740.00000 |                                           -
#                  3   9760.00000 |***                               9768.72250
#                  5   9780.00000 |******                            9793.01690
#                  4   9800.00000 |*****                             9813.68250
#                  4   9820.00000 |*****                             9830.00250
#                  7   9840.00000 |********                          9851.70307
#                 10   9860.00000 |************                      9866.46330
#
#                  9        > 95% |***********                       9907.92961
#
#        mean of 95%   9692.25403
#          95th %ile   9877.39450
 
# bin/cascade_cond -E -C 200 -L -S -W -N c_cond_1 -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
c_cond_1       1   1      0.70302          166        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.70071                 0.70071
#                    max      1.04478                 0.70481
#                   mean      0.71170                 0.70320
#                 median      0.70378                 0.70302
#                 stddev      0.03539                 0.00105
#         standard error      0.00249                 0.00008
#   99% confidence level      0.00579                 0.00019
#                   skew      7.52919                -0.06588
#               kurtosis     62.93293                -1.03184
#       time correlation     -0.00003                 0.00000
#
#           elasped time      0.14746
#      number of samples          166
#     number of outliers           36
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                157      0.00000 |********************************     0.70311
#
#                  9        > 95% |*                                    0.70481
#
#        mean of 95%      0.70311
#          95th %ile      0.70481
# bin/cascade_cond -E -C 200 -L -S -W -N c_cond_10 -T 10 -I 3000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_cond_10      1  10    313.72929          171        0       33 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    280.96129               302.11141
#                    max    343.99000               325.37729
#                   mean    311.55158               313.85734
#                 median    313.14200               313.72929
#                 stddev      9.57965                 3.97564
#         standard error      0.67402                 0.30403
#   99% confidence level      1.56777                 0.70716
#                   skew     -1.15650                 0.29557
#               kurtosis      2.82134                 0.85619
#       time correlation      0.07139                 0.01325
#
#           elasped time      2.35748
#      number of samples          171
#     number of outliers           31
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    302.00000 |*                                  302.11141
#                  1    303.00000 |*                                  303.70012
#                  1    304.00000 |*                                  304.40035
#                  1    305.00000 |*                                  305.46200
#                  2    306.00000 |**                                 306.30153
#                  2    307.00000 |**                                 307.50624
#                  8    308.00000 |**********                         308.59612
#                  7    309.00000 |*********                          309.33212
#                 15    310.00000 |********************               310.60258
#                 12    311.00000 |****************                   311.48553
#                 24    312.00000 |********************************   312.56631
#                 16    313.00000 |*********************              313.52271
#                 17    314.00000 |**********************             314.36619
#                 19    315.00000 |*************************          315.34812
#                 16    316.00000 |*********************              316.47659
#                 12    317.00000 |****************                   317.33149
#                  3    318.00000 |****                               318.41510
#                  1    319.00000 |*                                  319.22576
#                  3    320.00000 |****                               320.75675
#                  1    321.00000 |*                                  321.52224
#
#                  9        > 95% |************                       323.52171
#
#        mean of 95%    313.32043
#          95th %ile    321.95894
# bin/cascade_cond -E -C 200 -L -S -W -N c_cond_200 -T 200 -I 2000000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_cond_200     1 200  11593.87350          179        0        1 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min  11442.96150             11442.96150
#                    max  15439.88950             11910.41750
#                   mean  11801.76641             11621.84972
#                 median  11605.90550             11593.87350
#                 stddev    590.59662               100.61711
#         standard error     41.55423                 7.52048
#   99% confidence level     96.65515                17.49263
#                   skew      3.44855                 0.78520
#               kurtosis     12.56167                -0.14076
#       time correlation     -0.11235                -0.32400
#
#           elasped time     10.15473
#      number of samples          179
#     number of outliers           23
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1  11440.00000 |*                                11442.96150
#                  4  11460.00000 |******                           11474.06550
#                  8  11480.00000 |************                     11493.39350
#                  8  11500.00000 |************                     11510.84950
#                 17  11520.00000 |***************************      11530.31021
#                 18  11540.00000 |****************************     11552.44417
#                 20  11560.00000 |******************************** 11571.40310
#                 19  11580.00000 |******************************   11589.11055
#                 16  11600.00000 |*************************        11608.45750
#                  6  11620.00000 |*********                        11629.62817
#                 11  11640.00000 |*****************                11650.25168
#                  4  11660.00000 |******                           11672.52950
#                  4  11680.00000 |******                           11691.50550
#                  9  11700.00000 |**************                   11713.93750
#                  6  11720.00000 |*********                        11731.94283
#                  5  11740.00000 |********                         11751.18550
#                  9  11760.00000 |**************                   11772.12061
#                  4  11780.00000 |******                           11791.72950
#                  1  11800.00000 |*                                11814.92950
#
#                  9        > 95% |**************                   11859.06106
#
#        mean of 95%  11609.29148
#          95th %ile  11815.82550
 
# bin/cascade_lockf -E -C 200 -L -S -W -N c_lockf_1 -I 1000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_lockf_1      1   1     24.37667          194        0      100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     22.54883                23.09667
#                    max     28.34723                25.51843
#                   mean     24.42582                24.34796
#                 median     24.37923                24.37667
#                 stddev      0.74662                 0.47075
#         standard error      0.05253                 0.03380
#   99% confidence level      0.12219                 0.07861
#                   skew      2.14187                -0.01151
#               kurtosis      8.89027                -0.36834
#       time correlation     -0.00180                -0.00156
#
#           elasped time      0.49917
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 50     23.00000 |************                        23.74066
#                129     24.00000 |********************************    24.48145
#                  5     25.00000 |*                                   25.06787
#
#                 10        > 95% |**                                  25.30237
#
#        mean of 95%     24.29609
#          95th %ile     25.16003
# bin/cascade_lockf -E -C 200 -L -S -W -N c_lockf_10 -P 10 -I 50000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_lockf_10    10   1   1073.94300          194        0        2 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1038.35900              1038.35900
#                    max   2358.42300              1122.96700
#                   mean   1082.84914              1071.09269
#                 median   1076.37500              1073.94300
#                 stddev     96.94128                18.13235
#         standard error      6.82076                 1.30183
#   99% confidence level     15.86510                 3.02805
#                   skew     11.44261                 0.14423
#               kurtosis    145.77931                -0.87322
#       time correlation     -0.17428                -0.03210
#
#           elasped time      0.76564
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          210
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2   1038.00000 |***                               1038.42300
#                  3   1040.00000 |*****                             1041.21767
#                  1   1042.00000 |*                                 1042.96700
#                  3   1044.00000 |*****                             1044.71633
#                  9   1046.00000 |****************                  1047.33322
#                 11   1048.00000 |********************              1049.09936
#                 17   1050.00000 |********************************  1051.09876
#                  5   1052.00000 |*********                         1052.89980
#                  6   1054.00000 |***********                       1055.21233
#                  9   1056.00000 |****************                  1057.50211
#                  4   1058.00000 |*******                           1059.12700
#                  6   1060.00000 |***********                       1060.97233
#                  3   1062.00000 |*****                             1062.59367
#                  2   1064.00000 |***                               1065.62300
#                  6   1066.00000 |***********                       1067.32967
#                  5   1068.00000 |*********                         1068.61820
#                  1   1070.00000 |*                                 1071.38300
#                  5   1072.00000 |*********                         1073.40540
#                  3   1074.00000 |*****                             1075.39367
#                  5   1076.00000 |*********                         1076.57980
#                 10   1078.00000 |******************                1079.30620
#                 16   1080.00000 |******************************    1081.08700
#                  8   1082.00000 |***************                   1083.20700
#                  8   1084.00000 |***************                   1085.09500
#                 10   1086.00000 |******************                1087.03740
#                 11   1088.00000 |********************              1088.95391
#                  8   1090.00000 |***************                   1091.33500
#                  4   1092.00000 |*******                           1092.88700
#                  2   1094.00000 |***                               1094.80700
#                  1   1096.00000 |*                                 1097.87900
#
#                 10        > 95% |******************                1107.49180
#
#        mean of 95%   1069.11448
#          95th %ile   1098.90300
# bin/cascade_lockf -E -C 200 -L -S -W -N c_lockf_200 -P 200 -I 5000000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_lockf_200  200   1  24075.28500          148        0        1 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min  23747.98900             23747.98900
#                    max  50206.35700             24531.34900
#                   mean  24715.06385             24099.21668
#                 median  24153.36500             24075.28500
#                 stddev   2048.75630               151.53447
#         standard error    144.14999                12.45606
#   99% confidence level    335.29288                28.97279
#                   skew      9.69653                 0.57753
#               kurtosis    115.88344                 0.22077
#       time correlation     -3.85873                 0.56629
#
#           elasped time     16.83241
#      number of samples          148
#     number of outliers           54
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1  23730.00000 |*                                23747.98900
#                  0  23760.00000 |                                           -
#                  2  23790.00000 |***                              23798.67700
#                  1  23820.00000 |*                                23827.86100
#                  3  23850.00000 |*****                            23861.56767
#                  1  23880.00000 |*                                23895.95700
#                 11  23910.00000 |******************               23926.65373
#                  9  23940.00000 |***************                  23957.01300
#                 10  23970.00000 |****************                 23981.49940
#                 12  24000.00000 |********************             24017.55700
#                 19  24030.00000 |******************************** 24045.68332
#                 10  24060.00000 |****************                 24072.27700
#                  9  24090.00000 |***************                  24102.79078
#                 11  24120.00000 |******************               24132.93155
#                 14  24150.00000 |***********************          24164.34557
#                  7  24180.00000 |***********                      24194.56271
#                  2  24210.00000 |***                              24227.09300
#                  5  24240.00000 |********                         24250.84980
#                  3  24270.00000 |*****                            24279.70100
#                  5  24300.00000 |********                         24316.64180
#                  4  24330.00000 |******                           24341.52500
#                  1  24360.00000 |*                                24387.86100
#
#                  8        > 95% |*************                    24459.07700
#
#        mean of 95%  24078.65323
#          95th %ile  24393.87700
 
# bin/cascade_flock -E -C 200 -L -S -W -N c_flock -I 500 
             prc thr   usecs/call      samples   errors cnt/samp 
c_flock        1   1     12.75924          202        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     11.45876                11.45876
#                    max     14.94932                14.94932
#                   mean     12.82346                12.82346
#                 median     12.75924                12.75924
#                 stddev      0.74264                 0.74264
#         standard error      0.05225                 0.05225
#   99% confidence level      0.12154                 0.12154
#                   skew      0.45557                 0.45557
#               kurtosis      0.33687                 0.33687
#       time correlation      0.00223                 0.00223
#
#           elasped time      0.52343
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 38     11.00000 |*************                       11.78495
#                 92     12.00000 |********************************    12.63951
#                 61     13.00000 |*********************               13.41585
#
#                 11        > 95% |***                                 14.66434
#
#        mean of 95%     12.71744
#          95th %ile     14.03411
# bin/cascade_flock -E -C 200 -L -S -W -N c_flock_10 -P 10 -I 6250 
             prc thr   usecs/call      samples   errors cnt/samp 
c_flock_10    10   1    165.79475          201        0       16 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    156.67475               156.67475
#                    max    242.17875               174.80275
#                   mean    166.22770               165.84983
#                 median    165.85875               165.79475
#                 stddev      6.71844                 4.04683
#         standard error      0.47271                 0.28544
#   99% confidence level      1.09952                 0.66394
#                   skew      7.10593                 0.06637
#               kurtosis     78.14416                -0.82444
#       time correlation      0.00364                 0.01503
#
#           elasped time      0.84290
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    156.00000 |*                                  156.67475
#                  2    157.00000 |***                                157.70675
#                  5    158.00000 |*******                            158.62675
#                  8    159.00000 |************                       159.67275
#                  6    160.00000 |*********                          160.56808
#                 18    161.00000 |***************************        161.56453
#                 14    162.00000 |*********************              162.39361
#                 21    163.00000 |********************************   163.57913
#                 15    164.00000 |**********************             164.53715
#                 15    165.00000 |**********************             165.55048
#                 21    166.00000 |********************************   166.56504
#                  9    167.00000 |*************                      167.46053
#                 10    168.00000 |***************                    168.26035
#                 19    169.00000 |****************************       169.54801
#                 16    170.00000 |************************           170.48875
#                  6    171.00000 |*********                          171.43475
#                  4    172.00000 |******                             172.28275
#
#                 11        > 95% |****************                   173.37002
#
#        mean of 95%    165.41446
#          95th %ile    172.61075
# bin/cascade_flock -E -C 200 -L -S -W -N c_flock_200 -P 200 -I 5000000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_flock_200  200   1  10170.38900          199        0        1 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   9804.94900              9804.94900
#                    max  32724.50100             10535.95700
#                   mean  10279.63193             10161.80592
#                 median  10171.41300             10170.38900
#                 stddev   1593.92496               134.48096
#         standard error    112.14817                 9.53310
#   99% confidence level    260.85664                22.17400
#                   skew     13.82126                 0.01946
#               kurtosis    191.64653                -0.18446
#       time correlation     -3.03839                 0.19582
#
#           elasped time     10.72813
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   9800.00000 |**                                9804.94900
#                  1   9820.00000 |**                                9827.34900
#                  0   9840.00000 |                                           -
#                  1   9860.00000 |**                                9879.44500
#                  2   9880.00000 |****                              9890.19700
#                  1   9900.00000 |**                                9917.46100
#                  3   9920.00000 |******                            9926.37833
#                  4   9940.00000 |********                          9953.52500
#                  6   9960.00000 |************                      9968.89567
#                  5   9980.00000 |**********                        9988.32180
#                  7  10000.00000 |**************                   10009.01757
#                  9  10020.00000 |*******************              10028.50811
#                  6  10040.00000 |************                     10049.02367
#                  7  10060.00000 |**************                   10069.30557
#                 10  10080.00000 |*********************            10089.49300
#                 11  10100.00000 |***********************          10109.39118
#                 11  10120.00000 |***********************          10129.88282
#                 10  10140.00000 |*********************            10150.44660
#                 12  10160.00000 |*************************        10170.18633
#                 15  10180.00000 |******************************** 10189.33300
#                 12  10200.00000 |*************************        10208.72500
#                  9  10220.00000 |*******************              10227.53389
#                  8  10240.00000 |*****************                10247.20500
#                 10  10260.00000 |*********************            10269.71700
#                  5  10280.00000 |**********                       10288.43060
#                  8  10300.00000 |*****************                10309.57300
#                 10  10320.00000 |*********************            10328.55860
#                  4  10340.00000 |********                         10350.35700
#                  0  10360.00000 |                                           -
#                  1  10380.00000 |**                               10384.91700
#
#                 10        > 95% |*********************            10441.09620
#
#        mean of 95%  10147.02866
#          95th %ile  10391.31700
 
# bin/cascade_fcntl -E -C 200 -L -S -W -N c_fcntl_1 -I 1000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_fcntl_1      1   1     27.26701          191        0      100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     26.34797                26.34797
#                    max     31.19661                28.32685
#                   mean     27.36701                27.21147
#                 median     27.29773                27.26701
#                 stddev      0.78337                 0.39956
#         standard error      0.05512                 0.02891
#   99% confidence level      0.12820                 0.06725
#                   skew      2.71650                -0.23454
#               kurtosis      9.60120                 0.03745
#       time correlation     -0.00044                 0.00000
#
#           elasped time      0.55875
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 55     26.00000 |*************                       26.72955
#                126     27.00000 |********************************    27.35915
#
#                 10        > 95% |**                                  28.00122
#
#        mean of 95%     27.16783
#          95th %ile     27.89933
# bin/cascade_fcntl -E -C 200 -L -S -W -N c_fcntl_10 -P 10 -I 20000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_fcntl_10    10   1    907.78350          176        0        5 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    813.10617               873.60750
#                    max   1066.46083               943.28217
#                   mean    904.83781               907.48483
#                 median    907.27150               907.78350
#                 stddev     31.78083                14.19849
#         standard error      2.23609                 1.07025
#   99% confidence level      5.20115                 2.48940
#                   skew     -0.10342                -0.22425
#               kurtosis      4.61125                 0.08204
#       time correlation      0.09821                -0.04711
#
#           elasped time      1.39915
#      number of samples          176
#     number of outliers           26
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    872.00000 |**                                 873.60750
#                  3    874.00000 |*******                            875.17194
#                  4    876.00000 |*********                          877.62883
#                  4    878.00000 |*********                          878.98350
#                  2    880.00000 |****                               881.71417
#                  1    882.00000 |**                                 882.14083
#                  1    884.00000 |**                                 884.78617
#                  1    886.00000 |**                                 886.32217
#                  2    888.00000 |****                               888.64750
#                  3    890.00000 |*******                            890.90172
#                  2    892.00000 |****                               892.55150
#                  5    894.00000 |************                       895.00057
#                  3    896.00000 |*******                            897.35861
#                 11    898.00000 |***************************        898.76920
#                 13    900.00000 |********************************   900.87478
#                 12    902.00000 |*****************************      902.97283
#                 11    904.00000 |***************************        905.09938
#                 10    906.00000 |************************           907.08377
#                 13    908.00000 |********************************   909.02412
#                  8    910.00000 |*******************                910.87683
#                 10    912.00000 |************************           912.99310
#                  8    914.00000 |*******************                914.82350
#                  7    916.00000 |*****************                  916.82274
#                  8    918.00000 |*******************                919.06883
#                  9    920.00000 |**********************             920.63091
#                  6    922.00000 |**************                     923.00128
#                  4    924.00000 |*********                          925.34083
#                  2    926.00000 |****                               926.87683
#                  2    928.00000 |****                               929.13817
#                  1    930.00000 |**                                 930.26883
#
#                  9        > 95% |**********************             935.77283
#
#        mean of 95%    905.96033
#          95th %ile    930.26883
# bin/cascade_fcntl -E -C 200 -L -S -W -N c_fcntl_200 -P 200 -I 5000000 
             prc thr   usecs/call      samples   errors cnt/samp 
c_fcntl_200  200   1  81097.36300          201        0        1 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min  75538.32300             75538.32300
#                    max  99214.86700             85865.36300
#                   mean  80589.84300             80497.18119
#                 median  81106.83500             81097.36300
#                 stddev   2930.10719              2623.99867
#         standard error    206.16162               185.08260
#   99% confidence level    479.53193               430.50212
#                   skew      1.10047                -0.13376
#               kurtosis      6.14901                -1.35859
#       time correlation     -7.13781                -4.46503
#
#           elasped time     41.31614
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1  75300.00000 |**                               75538.32300
#                  1  75600.00000 |**                               75778.83500
#                  2  75900.00000 |****                             76114.89900
#                  5  76200.00000 |**********                       76365.43340
#                  6  76500.00000 |************                     76743.12300
#                  8  76800.00000 |*****************                76991.71500
#                 15  77100.00000 |******************************** 77272.45847
#                 10  77400.00000 |*********************            77504.95340
#                 10  77700.00000 |*********************            77853.95820
#                  2  78000.00000 |****                             78099.09100
#                  5  78300.00000 |**********                       78445.10060
#                  6  78600.00000 |************                     78730.96300
#                  2  78900.00000 |****                             79103.37900
#                  4  79200.00000 |********                         79375.28300
#                  3  79500.00000 |******                           79630.69633
#                  3  79800.00000 |******                           79935.37900
#                  9  80100.00000 |*******************              80179.88744
#                  3  80400.00000 |******                           80499.90167
#                  5  80700.00000 |**********                       80834.80940
#                  7  81000.00000 |**************                   81161.87500
#                  8  81300.00000 |*****************                81468.56300
#                 10  81600.00000 |*********************            81780.42220
#                  8  81900.00000 |*****************                82039.23500
#                  9  82200.00000 |*******************              82351.09456
#                  8  82500.00000 |*****************                82638.91500
#                  9  82800.00000 |*******************              82980.20033
#                 10  83100.00000 |*********************            83283.29580
#                 14  83400.00000 |*****************************    83558.81214
#                  5  83700.00000 |**********                       83825.88780
#                  2  84000.00000 |****                             84023.89100
#
#                 11        > 95% |***********************          84550.57027
#
#        mean of 95%  80262.51129
#          95th %ile  84031.89100
 
# bin/file_lock -E -C 200 -L -S -W -N file_lock -I 500 
             prc thr   usecs/call      samples   errors cnt/samp 
file_lock      1   1     12.85910          197        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     12.39446                12.39446
#                    max     14.60374                13.43894
#                   mean     12.88708                12.85434
#                 median     12.86422                12.85910
#                 stddev      0.28850                 0.19511
#         standard error      0.02030                 0.01390
#   99% confidence level      0.04722                 0.03233
#                   skew      2.63633                 0.07554
#               kurtosis     12.23316                -0.36833
#       time correlation     -0.00096                -0.00089
#
#           elasped time      0.52428
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                150     12.00000 |********************************    12.77388
#                 37     13.00000 |*******                             13.07421
#
#                 10        > 95% |**                                  13.24784
#
#        mean of 95%     12.83330
#          95th %ile     13.18422
 
# bin/getsockname -E -C 200 -L -S -W -N getsockname -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
getsockname    1   1      1.92977          194        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.85476                 1.86679
#                    max      2.28074                 1.99863
#                   mean      1.93961                 1.93302
#                 median      1.93182                 1.92977
#                 stddev      0.04806                 0.02234
#         standard error      0.00338                 0.00160
#   99% confidence level      0.00787                 0.00373
#                   skew      4.39665                 0.06840
#               kurtosis     25.07460                 0.02521
#       time correlation      0.00011                 0.00009
#
#           elasped time      0.39559
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                184      1.00000 |********************************     1.93046
#
#                 10        > 95% |*                                    1.98010
#
#        mean of 95%      1.93046
#          95th %ile      1.96970
# bin/getpeername -E -C 200 -L -S -W -N getpeername -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
getpeername    1   1      1.95792          197        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.89674                 1.89674
#                    max      2.31171                 2.01680
#                   mean      1.95956                 1.95265
#                 median      1.95869                 1.95792
#                 stddev      0.05360                 0.02841
#         standard error      0.00377                 0.00202
#   99% confidence level      0.00877                 0.00471
#                   skew      3.98858                -0.21551
#               kurtosis     21.75531                -0.87810
#       time correlation      0.00004                 0.00003
#
#           elasped time      0.39950
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                187      1.00000 |********************************     1.94991
#
#                 10        > 95% |*                                    2.00380
#
#        mean of 95%      1.94991
#          95th %ile      1.99683
 
# bin/chdir -E -C 200 -L -S -W -N chdir_tmp -I 1000 /tmp/libmicro.289520/0/1/2/3/4/5/6/7/8/9 /tmp/libmicro.289520/1/2/3/4/5/6/7/8/9/0 
             prc thr   usecs/call      samples   errors cnt/samp  dirs  gets
chdir_tmp      1   1     12.15773          198        0      100     2     n
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     12.04765                12.04765
#                    max     13.52733                12.67741
#                   mean     12.29022                12.26815
#                 median     12.15773                12.15773
#                 stddev      0.25223                 0.19951
#         standard error      0.01775                 0.01418
#   99% confidence level      0.04128                 0.03298
#                   skew      1.93196                 0.84299
#               kurtosis      5.24215                -1.03980
#       time correlation      0.00025                 0.00051
#
#           elasped time      0.25188
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          227
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                188     12.00000 |********************************    12.24763
#
#                 10        > 95% |*                                   12.65386
#
#        mean of 95%     12.24763
#          95th %ile     12.62877
# bin/chdir -E -C 200 -L -S -W -N chdir_usr -I 1000 /var/tmp/libmicro.289520/0/1/2/3/4/5/6/7/8/9 /var/tmp/libmicro.289520/1/2/3/4/5/6/7/8/9/0 
             prc thr   usecs/call      samples   errors cnt/samp  dirs  gets
chdir_usr      1   1     13.15878          197        0      100     2     n
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     13.08710                13.08710
#                    max     17.34694                13.93702
#                   mean     13.33840                13.28410
#                 median     13.15878                13.15878
#                 stddev      0.47037                 0.21858
#         standard error      0.03310                 0.01557
#   99% confidence level      0.07698                 0.03622
#                   skew      6.20635                 0.77164
#               kurtosis     49.08136                -1.09740
#       time correlation     -0.00106                -0.00019
#
#           elasped time      0.27320
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                187     13.00000 |********************************    13.26219
#
#                 10        > 95% |*                                   13.69382
#
#        mean of 95%     13.26219
#          95th %ile     13.62982
 
# bin/chdir -E -C 200 -L -S -W -N chgetwd_tmp -I 1500 -g /tmp/libmicro.289520/0/1/2/3/4/5/6/7/8/9 /tmp/libmicro.289520/1/2/3/4/5/6/7/8/9/0 
             prc thr   usecs/call      samples   errors cnt/samp  dirs  gets
chgetwd_tmp    1   1     21.54329          196        0       66     2     y
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     20.93820                20.93820
#                    max     28.26911                22.49747
#                   mean     21.68786                21.58425
#                 median     21.55880                21.54329
#                 stddev      0.79308                 0.40054
#         standard error      0.05580                 0.02861
#   99% confidence level      0.12979                 0.06655
#                   skew      4.98232                 0.53371
#               kurtosis     34.20782                -0.90722
#       time correlation     -0.00155                -0.00130
#
#           elasped time      0.29274
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  5     20.00000 |*                                   20.97311
#                149     21.00000 |********************************    21.42617
#                 32     22.00000 |******                              22.17662
#
#                 10        > 95% |**                                  22.34969
#
#        mean of 95%     21.54310
#          95th %ile     22.28414
# bin/chdir -E -C 200 -L -S -W -N chgetwd_usr -I 1500 -g /var/tmp/libmicro.289520/0/1/2/3/4/5/6/7/8/9 /var/tmp/libmicro.289520/1/2/3/4/5/6/7/8/9/0 
             prc thr   usecs/call      samples   errors cnt/samp  dirs  gets
chgetwd_usr    1   1     22.40448          201        0       66     2     y
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     21.63261                21.63261
#                    max     28.52521                23.72327
#                   mean     22.59253                22.56301
#                 median     22.40448                22.40448
#                 stddev      0.58069                 0.40252
#         standard error      0.04086                 0.02839
#   99% confidence level      0.09503                 0.06604
#                   skew      5.33612                 0.39070
#               kurtosis     51.44405                -0.71053
#       time correlation     -0.00005                -0.00036
#
#           elasped time      0.30518
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 11     21.00000 |**                                  21.88790
#                161     22.00000 |********************************    22.49714
#                 18     23.00000 |***                                 23.06776
#
#                 11        > 95% |**                                  23.37630
#
#        mean of 95%     22.51593
#          95th %ile     23.16473
 
# bin/realpath -E -C 200 -L -S -W -N realpath_tmp -I 3000 -f /tmp/libmicro.289520/0/1/2/3/4/5/6/7/8/9 
             prc thr   usecs/call      samples   errors cnt/samp 
realpath_tmp   1   1    107.54458          193        0       33 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    102.19961               102.19961
#                    max    121.36082               113.14555
#                   mean    107.79650               107.29428
#                 median    107.66094               107.54458
#                 stddev      3.24592                 2.27907
#         standard error      0.22838                 0.16405
#   99% confidence level      0.53122                 0.38158
#                   skew      1.52470                -0.04448
#               kurtosis      3.95023                -0.56114
#       time correlation     -0.00244                -0.00154
#
#           elasped time      0.72252
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2    102.00000 |*                                  102.23064
#                 21    103.00000 |****************                   103.67613
#                 15    104.00000 |************                       104.61066
#                 23    105.00000 |******************                 105.50973
#                 12    106.00000 |*********                          106.40357
#                 40    107.00000 |********************************   107.44062
#                 32    108.00000 |*************************          108.51136
#                 33    109.00000 |**************************         109.53216
#                  5    110.00000 |****                               110.25507
#
#                 10        > 95% |********                           111.75849
#
#        mean of 95%    107.05034
#          95th %ile    110.39161
# bin/realpath -E -C 200 -L -S -W -N realpath_usr -I 3000 -f /var/tmp/libmicro.289520/0/1/2/3/4/5/6/7/8/9 
             prc thr   usecs/call      samples   errors cnt/samp 
realpath_usr   1   1    118.56791          195        0       33 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    114.35555               114.35555
#                    max    144.66439               121.60112
#                   mean    118.63139               118.18480
#                 median    118.69203               118.56791
#                 stddev      2.95729                 1.42352
#         standard error      0.20807                 0.10194
#   99% confidence level      0.48398                 0.23711
#                   skew      4.60213                -0.23015
#               kurtosis     32.01312                -0.05439
#       time correlation      0.00876                 0.00987
#
#           elasped time      0.79472
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  5    114.00000 |**                                 114.52001
#                  6    115.00000 |***                                115.57090
#                 31    116.00000 |****************                   116.64803
#                 43    117.00000 |**********************             117.43260
#                 60    118.00000 |********************************   118.73069
#                 32    119.00000 |*****************                  119.31530
#                  8    120.00000 |****                               120.28330
#
#                 10        > 95% |*****                              121.01232
#
#        mean of 95%    118.03197
#          95th %ile    120.78658
 
# bin/stat -E -C 200 -L -S -W -N stat_tmp -I 500 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
stat_tmp       1   1     12.97813          188        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     12.01430                12.70933
#                    max     15.05302                13.33909
#                   mean     13.01116                12.98085
#                 median     12.97813                12.97813
#                 stddev      0.33249                 0.14533
#         standard error      0.02339                 0.01060
#   99% confidence level      0.05441                 0.02465
#                   skew      3.19426                 0.22051
#               kurtosis     15.77631                -0.65231
#       time correlation     -0.00020                -0.00008
#
#           elasped time      0.52962
#      number of samples          188
#     number of outliers           14
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                108     12.00000 |********************************    12.87973
#                 70     13.00000 |********************                13.09575
#
#                 10        > 95% |**                                  13.26869
#
#        mean of 95%     12.96468
#          95th %ile     13.23925
# bin/stat -E -C 200 -L -S -W -N stat_usr -I 500 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
stat_usr       1   1     11.13875          193        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     10.78803                10.78803
#                    max     13.00371                11.43827
#                   mean     11.18109                11.11835
#                 median     11.14899                11.13875
#                 stddev      0.33134                 0.13903
#         standard error      0.02331                 0.01001
#   99% confidence level      0.05423                 0.02328
#                   skew      3.57141                -0.08325
#               kurtosis     14.83302                -0.45434
#       time correlation     -0.00066                -0.00095
#
#           elasped time      0.45558
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 49     10.00000 |***********                         10.94526
#                134     11.00000 |********************************    11.16147
#
#                 10        > 95% |**                                  11.38861
#
#        mean of 95%     11.10358
#          95th %ile     11.36915
 
# bin/fcntl -E -C 200 -L -S -W -N fcntl_tmp -I 100 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
fcntl_tmp      1   1      0.81079          197        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.78878                 0.78878
#                    max      0.95876                 0.84868
#                   mean      0.81611                 0.81422
#                 median      0.81182                 0.81079
#                 stddev      0.01853                 0.01313
#         standard error      0.00130                 0.00094
#   99% confidence level      0.00303                 0.00218
#                   skew      3.02743                 0.56935
#               kurtosis     17.62660                -0.47298
#       time correlation     -0.00002                 0.00000
#
#           elasped time      0.16824
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                187      0.00000 |********************************     0.81277
#
#                 10        > 95% |*                                    0.84133
#
#        mean of 95%      0.81277
#          95th %ile      0.83972
# bin/fcntl -E -C 200 -L -S -W -N fcntl_usr -I 100 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
fcntl_usr      1   1      0.79978          194        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.77879                 0.77879
#                    max      1.11978                 0.83562
#                   mean      0.80800                 0.80083
#                 median      0.79978                 0.79978
#                 stddev      0.04408                 0.01339
#         standard error      0.00310                 0.00096
#   99% confidence level      0.00721                 0.00224
#                   skew      5.63082                 0.64975
#               kurtosis     35.18018                -0.40628
#       time correlation      0.00001                 0.00004
#
#           elasped time      0.16668
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                184      0.00000 |********************************     0.79921
#
#                 10        > 95% |*                                    0.83065
#
#        mean of 95%      0.79921
#          95th %ile      0.82691
# bin/fcntl_ndelay -E -C 200 -L -S -W -N fcntl_ndelay -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
fcntl_ndelay   1   1      0.91781          198        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.87685                 0.87685
#                    max      1.22194                 0.97285
#                   mean      0.92349                 0.91893
#                 median      0.91781                 0.91781
#                 stddev      0.03880                 0.01941
#         standard error      0.00273                 0.00138
#   99% confidence level      0.00635                 0.00321
#                   skew      4.95712                 0.25124
#               kurtosis     32.46892                -0.25931
#       time correlation      0.00005                 0.00008
#
#           elasped time      0.19008
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          206
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                188      0.00000 |********************************     0.91663
#
#                 10        > 95% |*                                    0.96217
#
#        mean of 95%      0.91663
#          95th %ile      0.95570
 
# bin/lseek -E -C 200 -L -S -W -N lseek_t8k -s 8k -I 50 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
lseek_t8k      1   1      0.73691          196        0     2000     8192
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.70491                 0.70491
#                    max      0.93595                 0.78030
#                   mean      0.74056                 0.73643
#                 median      0.73742                 0.73691
#                 stddev      0.02943                 0.01488
#         standard error      0.00207                 0.00106
#   99% confidence level      0.00482                 0.00247
#                   skew      4.09975                 0.22517
#               kurtosis     21.87027                -0.32785
#       time correlation     -0.00008                -0.00007
#
#           elasped time      0.30293
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      0.00000 |********************************     0.73474
#
#                 10        > 95% |*                                    0.76777
#
#        mean of 95%      0.73474
#          95th %ile      0.75931
# bin/lseek -E -C 200 -L -S -W -N lseek_u8k -s 8k -I 50 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
lseek_u8k      1   1      0.75637          199        0     2000     8192
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.72450                 0.72450
#                    max      0.93339                 0.78043
#                   mean      0.75871                 0.75629
#                 median      0.75637                 0.75637
#                 stddev      0.02277                 0.01138
#         standard error      0.00160                 0.00081
#   99% confidence level      0.00373                 0.00188
#                   skew      5.13893                -0.25224
#               kurtosis     34.62692                -0.29132
#       time correlation      0.00006                 0.00005
#
#           elasped time      0.31035
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                189      0.00000 |********************************     0.75516
#
#                 10        > 95% |*                                    0.77771
#
#        mean of 95%      0.75516
#          95th %ile      0.77339
 
# bin/open -E -C 200 -L -S -W -N open_tmp -B 256 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
open_tmp       1   1     19.11615          202        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     16.98315                16.98315
#                    max     22.57415                22.57415
#                   mean     19.19263                19.19263
#                 median     19.11615                19.11615
#                 stddev      1.50812                 1.50812
#         standard error      0.10611                 0.10611
#   99% confidence level      0.24681                 0.24681
#                   skew      0.14029                 0.14029
#               kurtosis     -1.46206                -1.46206
#       time correlation      0.00031                 0.00031
#
#           elasped time      1.33711
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     16.00000 |*                                   16.99115
#                 66     17.00000 |********************************    17.54295
#                 30     18.00000 |**************                      18.30905
#                 21     19.00000 |**********                          19.51605
#                 63     20.00000 |******************************      20.56970
#                  9     21.00000 |****                                21.15182
#
#                 11        > 95% |*****                               21.79351
#
#        mean of 95%     19.04284
#          95th %ile     21.32715
# bin/open -E -C 200 -L -S -W -N open_usr -B 256 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp 
open_usr       1   1     19.54616          202        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     17.61216                17.61216
#                    max     22.92516                22.92516
#                   mean     19.57280                19.57280
#                 median     19.54616                19.54616
#                 stddev      1.27914                 1.27914
#         standard error      0.09000                 0.09000
#   99% confidence level      0.20934                 0.20934
#                   skew      0.18412                 0.18412
#               kurtosis     -1.20459                -1.20459
#       time correlation      0.00140                 0.00140
#
#           elasped time      1.37074
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 18     17.00000 |*********                           17.91521
#                 56     18.00000 |******************************      18.22144
#                 40     19.00000 |**********************              19.39828
#                 58     20.00000 |********************************    20.53133
#                 19     21.00000 |**********                          21.20074
#
#                 11        > 95% |******                              21.93361
#
#        mean of 95%     19.43684
#          95th %ile     21.57316
# bin/open -E -C 200 -L -S -W -N open_zero -B 256 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp 
open_zero      1   1     20.77312          201        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     19.02612                19.02612
#                    max     26.56912                23.45212
#                   mean     20.81303                20.78439
#                 median     20.80012                20.77312
#                 stddev      0.98465                 0.89883
#         standard error      0.06928                 0.06340
#   99% confidence level      0.16114                 0.14746
#                   skew      0.98869                 0.09476
#               kurtosis      4.39293                -0.66156
#       time correlation     -0.00025                -0.00037
#
#           elasped time      1.45959
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 48     19.00000 |*********************               19.61666
#                 65     20.00000 |*****************************       20.50770
#                 71     21.00000 |********************************    21.45351
#                  6     22.00000 |**                                  22.09145
#
#                 11        > 95% |****                                22.48312
#
#        mean of 95%     20.68604
#          95th %ile     22.19812
 
# bin/dup -E -C 200 -L -S -W -N dup -B 1024 
             prc thr   usecs/call      samples   errors cnt/samp 
dup            1   1      2.13353          202        0     1024 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.68128                 1.68128
#                    max      2.51353                 2.51353
#                   mean      2.02955                 2.02955
#                 median      2.13353                 2.13353
#                 stddev      0.19167                 0.19167
#         standard error      0.01349                 0.01349
#   99% confidence level      0.03137                 0.03137
#                   skew     -0.40569                -0.40569
#               kurtosis     -0.67136                -0.67136
#       time correlation      0.00011                 0.00011
#
#           elasped time      0.59900
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 74      1.00000 |********************                 1.80962
#                117      2.00000 |********************************     2.13874
#
#                 11        > 95% |***                                  2.34767
#
#        mean of 95%      2.01123
#          95th %ile      2.22453
 
# bin/socket -E -C 200 -L -S -W -N socket_u -B 256 
             prc thr   usecs/call      samples   errors cnt/samp 
socket_u       1   1     40.58913          184        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     37.70613                39.49513
#                    max     43.60813                42.03113
#                   mean     40.58016                40.62366
#                 median     40.57313                40.58913
#                 stddev      0.77589                 0.48979
#         standard error      0.05459                 0.03611
#   99% confidence level      0.12698                 0.08399
#                   skew     -0.15765                 0.65996
#               kurtosis      2.91546                 0.61357
#       time correlation     -0.00067                -0.00098
#
#           elasped time      3.81748
#      number of samples          184
#     number of outliers           18
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 14     39.00000 |***                                 39.82706
#                137     40.00000 |********************************    40.51975
#                 23     41.00000 |*****                               41.18461
#
#                 10        > 95% |**                                  41.87233
#
#        mean of 95%     40.55190
#          95th %ile     41.69013
# bin/socket -E -C 200 -L -S -W -N socket_i -B 256 -f PF_INET 
             prc thr   usecs/call      samples   errors cnt/samp 
socket_i       1   1     44.42115          201        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     40.80715                40.80715
#                    max     49.08915                46.73315
#                   mean     43.87653                43.85060
#                 median     44.44115                44.42115
#                 stddev      1.36709                 1.31975
#         standard error      0.09619                 0.09309
#   99% confidence level      0.22373                 0.21652
#                   skew      0.11878                -0.11520
#               kurtosis     -0.26055                -1.05227
#       time correlation     -0.00106                -0.00062
#
#           elasped time      4.35370
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     40.00000 |*                                   40.80715
#                 18     41.00000 |******                              41.76771
#                 55     42.00000 |********************                42.56632
#                 15     43.00000 |*****                               43.40709
#                 86     44.00000 |********************************    44.62968
#                 14     45.00000 |*****                               45.46365
#                  1     46.00000 |*                                   46.00315
#
#                 11        > 95% |****                                46.22215
#
#        mean of 95%     43.71329
#          95th %ile     46.01415
 
# bin/socketpair -E -C 200 -L -S -W -N socketpair -B 256 
             prc thr   usecs/call      samples   errors cnt/samp 
socketpair     1   1     76.32633          176        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     70.35033                75.19433
#                    max     80.24033                77.99833
#                   mean     76.65296                76.38095
#                 median     76.42833                76.32633
#                 stddev      1.25329                 0.58948
#         standard error      0.08818                 0.04443
#   99% confidence level      0.20511                 0.10335
#                   skew      0.29159                 0.28010
#               kurtosis      4.23859                -0.30646
#       time correlation     -0.00166                -0.00231
#
#           elasped time      3.64071
#      number of samples          176
#     number of outliers           26
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 49     75.00000 |***************                     75.69412
#                100     76.00000 |********************************    76.46061
#                 18     77.00000 |*****                               77.17322
#
#                  9        > 95% |**                                  77.65077
#
#        mean of 95%     76.31252
#          95th %ile     77.35833
 
# bin/setsockopt -E -C 200 -L -S -W -N setsockopt -I 200 
             prc thr   usecs/call      samples   errors cnt/samp 
setsockopt     1   1      2.62356          198        0      500 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      2.42337                 2.42337
#                    max      3.33319                 2.95380
#                   mean      2.59355                 2.58175
#                 median      2.62356                 2.62356
#                 stddev      0.16858                 0.14701
#         standard error      0.01186                 0.01045
#   99% confidence level      0.02759                 0.02430
#                   skew      1.08811                 0.47266
#               kurtosis      1.83916                -0.78731
#       time correlation      0.00042                 0.00056
#
#           elasped time      0.28537
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                188      2.00000 |********************************     2.56493
#
#                 10        > 95% |*                                    2.89784
#
#        mean of 95%      2.56493
#          95th %ile      2.84372
 
# bin/bind -E -C 200 -L -S -W -N bind -B 200 
             prc thr   usecs/call      samples   errors cnt/samp 
bind           1   1     13.84854          194        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     12.68886                12.68886
#                    max     33.52343                15.06839
#                   mean     13.84228                13.65224
#                 median     13.85494                13.84854
#                 stddev      1.55550                 0.48309
#         standard error      0.10944                 0.03468
#   99% confidence level      0.25457                 0.08067
#                   skew     10.16863                -0.36101
#               kurtosis    124.30746                -0.28413
#       time correlation      0.00171                -0.00096
#
#           elasped time     14.89222
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 32     12.00000 |*******                             12.87018
#                130     13.00000 |********************************    13.71447
#                 22     14.00000 |*****                               14.04369
#
#                 10        > 95% |**                                  14.48470
#
#        mean of 95%     13.60700
#          95th %ile     14.08278
 
# bin/listen -E -C 200 -L -S -W -N listen -B 800 
             prc thr   usecs/call      samples   errors cnt/samp 
listen         1   1      1.39204          193        0      800 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.35332                 1.35332
#                    max      1.81604                 1.44612
#                   mean      1.40008                 1.39234
#                 median      1.39492                 1.39204
#                 stddev      0.04975                 0.02024
#         standard error      0.00350                 0.00146
#   99% confidence level      0.00814                 0.00339
#                   skew      5.51319                 0.47077
#               kurtosis     38.01988                -0.47952
#       time correlation     -0.00006                 0.00002
#
#           elasped time      0.22975
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                183      1.00000 |********************************     1.38992
#
#                 10        > 95% |*                                    1.43656
#
#        mean of 95%      1.38992
#          95th %ile      1.43236
 
# bin/connection -E -C 200 -L -S -W -N connection -B 256 
             prc thr   usecs/call      samples   errors cnt/samp 
connection     1   1    381.71416          192        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    379.14016               379.14016
#                    max    390.24516               384.40916
#                   mean    382.03754               381.73053
#                 median    381.73816               381.71416
#                 stddev      1.73787                 1.07995
#         standard error      0.12228                 0.07794
#   99% confidence level      0.28441                 0.18129
#                   skew      2.02937                -0.05638
#               kurtosis      6.13882                -0.21299
#       time correlation      0.00237                 0.00141
#
#           elasped time     41.58402
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 15    379.00000 |******                             379.65383
#                 31    380.00000 |**************                     380.61697
#                 69    381.00000 |********************************   381.53115
#                 52    382.00000 |************************           382.42226
#                 15    383.00000 |******                             383.15990
#
#                 10        > 95% |****                               383.93236
#
#        mean of 95%    381.60955
#          95th %ile    383.52716
 
# bin/poll -E -C 200 -L -S -W -N poll_10 -n 10 -I 250 
             prc thr   usecs/call      samples   errors cnt/samp     nfds flags
poll_10        1   1      5.77928          200        0      400       10   ---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      4.53448                 4.85192
#                    max      6.99208                 6.63944
#                   mean      5.74281                 5.74260
#                 median      5.77928                 5.77928
#                 stddev      0.37581                 0.35704
#         standard error      0.02644                 0.02525
#   99% confidence level      0.06150                 0.05872
#                   skew     -0.15478                -0.20097
#               kurtosis      0.41131                -0.17645
#       time correlation     -0.00252                -0.00241
#
#           elasped time      0.46797
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  9      4.00000 |*                                    4.92275
#                147      5.00000 |********************************     5.65424
#                 34      6.00000 |*******                              6.14329
#
#                 10        > 95% |**                                   6.41704
#
#        mean of 95%      5.70711
#          95th %ile      6.28488
# bin/poll -E -C 200 -L -S -W -N poll_100 -n 100 -I 1000 
             prc thr   usecs/call      samples   errors cnt/samp     nfds flags
poll_100       1   1    186.48870          199        0      100      100   ---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    184.29734               184.29734
#                    max    202.08934               190.57702
#                   mean    187.03247               186.89499
#                 median    186.48870               186.48870
#                 stddev      1.92358                 1.48649
#         standard error      0.13534                 0.10537
#   99% confidence level      0.31481                 0.24510
#                   skew      3.02134                 0.98588
#               kurtosis     17.62233                 0.14855
#       time correlation      0.00258                 0.00059
#
#           elasped time      3.78252
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  8    184.00000 |***                                184.62886
#                 48    185.00000 |******************                 185.62657
#                 82    186.00000 |********************************   186.47602
#                 21    187.00000 |********                           187.37860
#                 11    188.00000 |****                               188.53693
#                 16    189.00000 |******                             189.41350
#                  3    190.00000 |*                                  190.14353
#
#                 10        > 95% |***                                190.40601
#
#        mean of 95%    186.70923
#          95th %ile    190.20838
# bin/poll -E -C 200 -L -S -W -N poll_1000 -n 1000 -I 5000 
             prc thr   usecs/call      samples   errors cnt/samp     nfds flags
poll_1000      1   1   1933.28840          197        0       20     1000   ---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1917.54440              1917.54440
#                    max   2016.62920              1960.93640
#                   mean   1936.17087              1935.03570
#                 median   1933.54440              1933.28840
#                 stddev     12.31106                 9.71479
#         standard error      0.86620                 0.69215
#   99% confidence level      2.01479                 1.60994
#                   skew      1.89479                 0.33679
#               kurtosis      8.42137                -0.85551
#       time correlation     -0.01226                -0.00553
#
#           elasped time      7.82759
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2   1916.00000 |***                               1917.73640
#                  3   1918.00000 |*****                             1919.47720
#                  9   1920.00000 |***************                   1921.48680
#                  9   1922.00000 |***************                   1923.20769
#                 17   1924.00000 |****************************      1924.93151
#                 19   1926.00000 |********************************  1926.90861
#                 19   1928.00000 |********************************  1929.06103
#                 12   1930.00000 |********************              1931.03880
#                 13   1932.00000 |*********************             1932.82366
#                 10   1934.00000 |****************                  1935.07784
#                  7   1936.00000 |***********                       1937.02600
#                  7   1938.00000 |***********                       1938.64611
#                 11   1940.00000 |******************                1941.23255
#                 14   1942.00000 |***********************           1943.20931
#                 13   1944.00000 |*********************             1945.09886
#                 15   1946.00000 |*************************         1947.07741
#                  7   1948.00000 |***********                       1948.77091
#
#                 10        > 95% |****************                  1954.66312
#
#        mean of 95%   1933.98610
#          95th %ile   1950.38920
 
# bin/poll -E -C 200 -L -S -W -N poll_w10 -n 10 -I 250 -w 1 
             prc thr   usecs/call      samples   errors cnt/samp     nfds flags
poll_w10       1   1      6.63177          200        0      400       10   -w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      5.88681                 5.88681
#                    max      7.54953                 7.38185
#                   mean      6.58668                 6.57736
#                 median      6.63177                 6.63177
#                 stddev      0.29254                 0.27860
#         standard error      0.02058                 0.01970
#   99% confidence level      0.04788                 0.04582
#                   skew     -0.07613                -0.36420
#               kurtosis      0.70327                 0.23300
#       time correlation     -0.00062                -0.00064
#
#           elasped time      0.53618
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 10      5.00000 |*                                    5.92893
#                180      6.00000 |********************************     6.58316
#
#                 10        > 95% |*                                    7.12144
#
#        mean of 95%      6.54873
#          95th %ile      6.97417
# bin/poll -E -C 200 -L -S -W -N poll_w100 -n 100 -I 2000 -w 10 
             prc thr   usecs/call      samples   errors cnt/samp     nfds flags
poll_w100      1   1    186.19460          179        0       50      100   -w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    184.55620               184.55620
#                    max    207.91364               188.69316
#                   mean    187.17123               186.31353
#                 median    186.35844               186.19460
#                 stddev      2.87706                 0.83022
#         standard error      0.20243                 0.06205
#   99% confidence level      0.47085                 0.14434
#                   skew      3.59925                 0.40548
#               kurtosis     17.13997                -0.39349
#       time correlation     -0.00039                 0.00204
#
#           elasped time      1.89476
#      number of samples          179
#     number of outliers           23
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  5    184.00000 |**                                 184.78558
#                 64    185.00000 |*****************************      185.56748
#                 70    186.00000 |********************************   186.42156
#                 31    187.00000 |**************                     187.32942
#
#                  9        > 95% |****                               188.12825
#
#        mean of 95%    186.21746
#          95th %ile    187.92004
# bin/poll -E -C 200 -L -S -W -N poll_w1000 -n 1000 -I 20000 -w 100 
             prc thr   usecs/call      samples   errors cnt/samp     nfds flags
poll_w1000     1   1   1930.40040          183        0        5     1000   -w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1915.34760              1915.34760
#                    max   2154.70760              1950.98280
#                   mean   1937.32279              1930.45943
#                 median   1931.73160              1930.40040
#                 stddev     26.33990                 7.38155
#         standard error      1.85327                 0.54566
#   99% confidence level      4.31070                 1.26921
#                   skew      4.40456                 0.30090
#               kurtosis     26.18531                -0.38995
#       time correlation     -0.03735                -0.01105
#
#           elasped time      1.96170
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1915.00000 |**                                1915.34760
#                  2   1916.00000 |****                              1916.75560
#                  0   1917.00000 |                                           -
#                  5   1918.00000 |**********                        1918.71656
#                  4   1919.00000 |********                          1919.75080
#                  7   1920.00000 |**************                    1920.40909
#                 10   1921.00000 |********************              1921.40968
#                  5   1922.00000 |**********                        1922.48488
#                  6   1923.00000 |************                      1923.62493
#                 10   1924.00000 |********************              1924.60456
#                  4   1925.00000 |********                          1925.45960
#                 13   1926.00000 |**************************        1926.58797
#                  6   1927.00000 |************                      1927.54173
#                  6   1928.00000 |************                      1928.71080
#                  8   1929.00000 |****************                  1929.45960
#                  8   1930.00000 |****************                  1930.38760
#                 10   1931.00000 |********************              1931.54728
#                  9   1932.00000 |******************                1932.52236
#                  9   1933.00000 |******************                1933.48947
#                 10   1934.00000 |********************              1934.43496
#                 16   1935.00000 |********************************  1935.49800
#                  4   1936.00000 |********                          1936.59560
#                  4   1937.00000 |********                          1937.70920
#                  2   1938.00000 |****                              1938.74600
#                  6   1939.00000 |************                      1939.47987
#                  2   1940.00000 |****                              1940.43560
#                  3   1941.00000 |******                            1941.27187
#                  1   1942.00000 |**                                1942.73960
#                  2   1943.00000 |****                              1943.35400
#
#                 10        > 95% |********************              1946.40552
#
#        mean of 95%   1929.53769
#          95th %ile   1943.76360
 
# bin/select -E -C 200 -L -S -W -N select_10 -n 10 -I 250 
             prc thr   usecs/call      samples   errors cnt/samp    maxfd flags
select_10      1   1      6.28681          199        0      400       10   ---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.00457                 6.00457
#                    max      8.52489                 7.59945
#                   mean      6.50094                 6.47764
#                 median      6.29449                 6.28681
#                 stddev      0.42566                 0.38122
#         standard error      0.02995                 0.02702
#   99% confidence level      0.06966                 0.06286
#                   skew      1.08983                 0.55676
#               kurtosis      1.57561                -1.11094
#       time correlation      0.00259                 0.00266
#
#           elasped time      0.53727
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                172      6.00000 |********************************     6.38040
#                 17      7.00000 |***                                  7.04254
#
#                 10        > 95% |*                                    7.18998
#
#        mean of 95%      6.43995
#          95th %ile      7.08681
# bin/select -E -C 200 -L -S -W -N select_100 -n 100 -I 1000 
             prc thr   usecs/call      samples   errors cnt/samp    maxfd flags
select_100     1   1    181.15615          168        0      100      100   ---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    179.92991               179.92991
#                    max    528.23839               182.76895
#                   mean    184.48559               181.18788
#                 median    181.29695               181.15615
#                 stddev     27.34574                 0.53813
#         standard error      1.92404                 0.04152
#   99% confidence level      4.47532                 0.09657
#                   skew     11.05375                 0.48743
#               kurtosis    128.22950                 0.63120
#       time correlation     -0.07608                -0.00061
#
#           elasped time      3.73484
#      number of samples          168
#     number of outliers           34
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    179.00000 |*                                  179.92991
#                 62    180.00000 |**********************             180.69626
#                 90    181.00000 |********************************   181.34562
#                  6    182.00000 |**                                 182.11103
#
#                  9        > 95% |***                                182.52148
#
#        mean of 95%    181.11239
#          95th %ile    182.20831
# bin/select -E -C 200 -L -S -W -N select_1000 -n 1000 -I 5000 
             prc thr   usecs/call      samples   errors cnt/samp    maxfd flags
select_1000    1   1   1874.49760          194        0       20     1000   ---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1862.33760              1862.33760
#                    max   2141.88960              1902.18400
#                   mean   1880.33415              1877.18547
#                 median   1874.94560              1874.49760
#                 stddev     22.76129                 8.41954
#         standard error      1.60148                 0.60449
#   99% confidence level      3.72504                 1.40604
#                   skew      8.02232                 0.64029
#               kurtosis     84.95872                -0.36272
#       time correlation     -0.03443                 0.00110
#
#           elasped time      7.60171
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3   1862.00000 |*****                             1862.60213
#                  0   1863.00000 |                                           -
#                  2   1864.00000 |***                               1864.28960
#                  4   1865.00000 |*******                           1865.61440
#                  7   1866.00000 |*************                     1866.59817
#                  9   1867.00000 |****************                  1867.48036
#                  4   1868.00000 |*******                           1868.50400
#                  6   1869.00000 |***********                       1869.62933
#                  9   1870.00000 |****************                  1870.79556
#                 15   1871.00000 |****************************      1871.56555
#                 11   1872.00000 |********************              1872.56713
#                 17   1873.00000 |********************************  1873.53308
#                 15   1874.00000 |****************************      1874.42933
#                 12   1875.00000 |**********************            1875.29973
#                  7   1876.00000 |*************                     1876.54377
#                  5   1877.00000 |*********                         1877.46464
#                  2   1878.00000 |***                               1878.38880
#                  3   1879.00000 |*****                             1879.60053
#                  2   1880.00000 |***                               1880.36640
#                  1   1881.00000 |*                                 1881.89600
#                  5   1882.00000 |*********                         1882.82272
#                  3   1883.00000 |*****                             1883.47467
#                  8   1884.00000 |***************                   1884.56640
#                  5   1885.00000 |*********                         1885.38784
#                  5   1886.00000 |*********                         1886.34016
#                  8   1887.00000 |***************                   1887.29760
#                  7   1888.00000 |*************                     1888.74583
#                  5   1889.00000 |*********                         1889.27904
#                  1   1890.00000 |*                                 1890.03680
#                  3   1891.00000 |*****                             1891.29120
#
#                 10        > 95% |******************                1895.99008
#
#        mean of 95%   1876.16348
#          95th %ile   1891.88000
 
# bin/select -E -C 200 -L -S -W -N select_w10 -n 10 -I 250 -w 1 
             prc thr   usecs/call      samples   errors cnt/samp    maxfd flags
select_w10     1   1      6.25162          195        0      400       10   -w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.03658                 6.03658
#                    max      7.33194                 6.63434
#                   mean      6.29870                 6.26623
#                 median      6.25930                 6.25162
#                 stddev      0.21105                 0.12335
#         standard error      0.01485                 0.00883
#   99% confidence level      0.03454                 0.02055
#                   skew      2.80076                 0.67950
#               kurtosis      9.82965                 0.06640
#       time correlation      0.00042                 0.00045
#
#           elasped time      0.51272
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      6.00000 |********************************     6.25028
#
#                 10        > 95% |*                                    6.56125
#
#        mean of 95%      6.25028
#          95th %ile      6.52490
# bin/select -E -C 200 -L -S -W -N select_w100 -n 100 -I 2000 -w 10 
             prc thr   usecs/call      samples   errors cnt/samp    maxfd flags
select_w100    1   1    186.23546          177        0       50      100   -w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    185.07322               185.07322
#                    max    199.57306               188.23738
#                   mean    187.09641               186.28466
#                 median    186.43514               186.23546
#                 stddev      2.41871                 0.73635
#         standard error      0.17018                 0.05535
#   99% confidence level      0.39584                 0.12874
#                   skew      2.44440                 0.41736
#               kurtosis      5.95675                -0.58856
#       time correlation     -0.00229                -0.00324
#
#           elasped time      1.89392
#      number of samples          177
#     number of outliers           25
#      getnsecs overhead          227
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 72    185.00000 |******************************     185.56837
#                 75    186.00000 |********************************   186.50989
#                 21    187.00000 |********                           187.24117
#
#                  9        > 95% |***                                187.90629
#
#        mean of 95%    186.19779
#          95th %ile    187.65882
# bin/select -E -C 200 -L -S -W -N select_w1000 -n 1000 -I 20000 -w 100 
             prc thr   usecs/call      samples   errors cnt/samp    maxfd flags
select_w1000   1   1   1874.33680          174        0        5     1000   -w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1863.94320              1863.94320
#                    max   2016.92880              1891.74480
#                   mean   1884.11701              1875.34903
#                 median   1875.15600              1874.33680
#                 stddev     24.17593                 5.84571
#         standard error      1.70101                 0.44316
#   99% confidence level      3.95655                 1.03079
#                   skew      2.47241                 0.41355
#               kurtosis      6.24148                -0.60172
#       time correlation      0.01001                 0.02113
#
#           elasped time      1.90783
#      number of samples          174
#     number of outliers           28
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1863.00000 |*                                 1863.94320
#                  1   1864.00000 |*                                 1864.55760
#                  3   1865.00000 |*****                             1865.71813
#                  1   1866.00000 |*                                 1866.19600
#                 10   1867.00000 |*****************                 1867.58352
#                  8   1868.00000 |**************                    1868.57680
#                 10   1869.00000 |*****************                 1869.52400
#                 15   1870.00000 |**************************        1870.46267
#                  7   1871.00000 |************                      1871.56469
#                 13   1872.00000 |***********************           1872.50935
#                 11   1873.00000 |*******************               1873.76429
#                 18   1874.00000 |********************************  1874.51031
#                  8   1875.00000 |**************                    1875.38640
#                  3   1876.00000 |*****                             1876.35067
#                 11   1877.00000 |*******************               1877.37622
#                  5   1878.00000 |********                          1878.65808
#                  7   1879.00000 |************                      1879.47143
#                  5   1880.00000 |********                          1880.55248
#                  4   1881.00000 |*******                           1881.70960
#                 15   1882.00000 |**************************        1882.51173
#                  5   1883.00000 |********                          1883.56304
#                  4   1884.00000 |*******                           1884.80720
#
#                  9        > 95% |****************                  1887.65449
#
#        mean of 95%   1874.67782
#          95th %ile   1885.54960
 
# bin/semop -E -C 200 -L -S -W -N semop -I 200 
             prc thr   usecs/call      samples   errors cnt/samp 
semop          1   1      1.07119          198   201798      500 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.01743                 1.01743
#                    max      1.67740                 1.14543
#                   mean      1.07720                 1.06992
#                 median      1.07170                 1.07119
#                 stddev      0.06628                 0.02788
#         standard error      0.00466                 0.00198
#   99% confidence level      0.01085                 0.00461
#                   skew      6.79096                 0.13067
#               kurtosis     56.66355                -0.56851
#       time correlation      0.00006                 0.00007
#
#           elasped time      0.11283
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                188      1.00000 |********************************     1.06684
#
#                 10        > 95% |*                                    1.12787
#
#        mean of 95%      1.06684
#          95th %ile      1.11727
#
# WARNINGS
#     Errors occured during benchmark.
 
# bin/sigaction -E -C 200 -L -S -W -N sigaction -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
sigaction      1   1      1.79383          195        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.72881                 1.72881
#                    max      2.11076                 1.88087
#                   mean      1.79878                 1.79034
#                 median      1.79665                 1.79383
#                 stddev      0.05589                 0.03166
#         standard error      0.00393                 0.00227
#   99% confidence level      0.00915                 0.00527
#                   skew      3.00594                -0.21239
#               kurtosis     13.01187                -0.76348
#       time correlation     -0.00001                 0.00002
#
#           elasped time      0.36708
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      1.00000 |********************************     1.78738
#
#                 10        > 95% |*                                    1.84519
#
#        mean of 95%      1.78738
#          95th %ile      1.83479
# bin/signal -E -C 200 -L -S -W -N signal -I 500 
             prc thr   usecs/call      samples   errors cnt/samp 
signal         1   1     18.38357          191        0      200 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     17.77301                17.77301
#                    max     20.52373                18.98901
#                   mean     18.43319                18.35857
#                 median     18.39893                18.38357
#                 stddev      0.40869                 0.25404
#         standard error      0.02876                 0.01838
#   99% confidence level      0.06689                 0.04276
#                   skew      2.04407                 0.01534
#               kurtosis      6.36354                -0.25051
#       time correlation      0.00016                -0.00050
#
#           elasped time      0.74883
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 18     17.00000 |***                                 17.89731
#                163     18.00000 |********************************    18.37696
#
#                 10        > 95% |*                                   18.88904
#
#        mean of 95%     18.32926
#          95th %ile     18.77013
# bin/sigprocmask -E -C 200 -L -S -W -N sigprocmask -I 100 
             prc thr   usecs/call      samples   errors cnt/samp 
sigprocmask    1   1      1.29873          195        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      1.25086                 1.25086
#                    max      1.64970                 1.36068
#                   mean      1.30625                 1.29881
#                 median      1.29975                 1.29873
#                 stddev      0.04883                 0.02139
#         standard error      0.00344                 0.00153
#   99% confidence level      0.00799                 0.00356
#                   skew      4.62638                 0.29157
#               kurtosis     26.39222                -0.24640
#       time correlation     -0.00006                -0.00002
#
#           elasped time      0.26735
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                185      1.00000 |********************************     1.29635
#
#                 10        > 95% |*                                    1.34427
#
#        mean of 95%      1.29635
#          95th %ile      1.33585
 
# bin/pthread_create -E -C 200 -L -S -W -N pthread_16 -B 16 
             prc thr   usecs/call      samples   errors cnt/samp 
pthread_16     1   1   1247.48994          194        0       16 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1231.98594              1231.98594
#                    max   1649.66594              1275.55394
#                   mean   1253.85192              1249.86421
#                 median   1247.98594              1247.48994
#                 stddev     32.34518                 9.26160
#         standard error      2.27580                 0.66494
#   99% confidence level      5.29351                 1.54666
#                   skew      9.68573                 0.82522
#               kurtosis    110.81767                -0.04155
#       time correlation     -0.05546                -0.00810
#
#           elasped time      7.16277
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1230.00000 |*                                 1231.98594
#                  1   1232.00000 |*                                 1232.24194
#                  1   1234.00000 |*                                 1234.41794
#                  5   1236.00000 |*****                             1237.57954
#                 10   1238.00000 |***********                       1238.75074
#                 14   1240.00000 |****************                  1241.09679
#                 24   1242.00000 |***************************       1243.07994
#                 28   1244.00000 |********************************  1244.95222
#                 18   1246.00000 |********************              1247.18949
#                 20   1248.00000 |**********************            1248.87074
#                 12   1250.00000 |*************                     1251.20327
#                 10   1252.00000 |***********                       1252.84514
#                  6   1254.00000 |******                            1254.70327
#                  6   1256.00000 |******                            1257.27927
#                  4   1258.00000 |****                              1259.34594
#                  5   1260.00000 |*****                             1261.08674
#                  8   1262.00000 |*********                         1262.94794
#                  6   1264.00000 |******                            1265.04727
#                  4   1266.00000 |****                              1267.12194
#                  1   1268.00000 |*                                 1269.05794
#
#                 10        > 95% |***********                       1271.58274
#
#        mean of 95%   1248.68385
#          95th %ile   1269.36194
# bin/pthread_create -E -C 200 -L -S -W -N pthread_32 -B 32 
             prc thr   usecs/call      samples   errors cnt/samp 
pthread_32     1   1   1445.56094          199        0       32 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1430.68094              1430.68094
#                    max   1651.76894              1465.99294
#                   mean   1447.45733              1446.12628
#                 median   1445.71294              1445.56094
#                 stddev     16.21895                 6.72096
#         standard error      1.14116                 0.47644
#   99% confidence level      2.65434                 1.10819
#                   skew      9.94123                 0.32478
#               kurtosis    121.85942                -0.27852
#       time correlation     -0.02867                 0.00347
#
#           elasped time     16.38776
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1430.00000 |*                                 1430.68094
#                  1   1431.00000 |*                                 1431.92894
#                  0   1432.00000 |                                           -
#                  1   1433.00000 |*                                 1433.61694
#                  2   1434.00000 |**                                1434.47694
#                  4   1435.00000 |*****                             1435.44694
#                  5   1436.00000 |******                            1436.49694
#                  4   1437.00000 |*****                             1437.26494
#                 12   1438.00000 |****************                  1438.58627
#                  9   1439.00000 |************                      1439.41605
#                  6   1440.00000 |********                          1440.35427
#                 23   1441.00000 |********************************  1441.57589
#                  8   1442.00000 |***********                       1442.62294
#                 11   1443.00000 |***************                   1443.56457
#                  6   1444.00000 |********                          1444.66494
#                 13   1445.00000 |******************                1445.55909
#                  6   1446.00000 |********                          1446.39560
#                  5   1447.00000 |******                            1447.53214
#                 12   1448.00000 |****************                  1448.36960
#                  9   1449.00000 |************                      1449.50138
#                  8   1450.00000 |***********                       1450.49494
#                 13   1451.00000 |******************                1451.48401
#                  7   1452.00000 |*********                         1452.23865
#                 10   1453.00000 |*************                     1453.52414
#                  6   1454.00000 |********                          1454.34227
#                  2   1455.00000 |**                                1455.33694
#                  3   1456.00000 |****                              1456.28627
#                  2   1457.00000 |**                                1457.28894
#
#                 10        > 95% |*************                     1460.77054
#
#        mean of 95%   1445.35146
#          95th %ile   1457.77694
# bin/pthread_create -E -C 200 -L -S -W -N pthread_128 -B 128 
             prc thr   usecs/call      samples   errors cnt/samp 
pthread_128    1   1   1585.52822          192        0      128 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1576.63222              1576.63222
#                    max   1984.31022              1597.18622
#                   mean   1588.96496              1585.71719
#                 median   1585.65422              1585.52822
#                 stddev     29.02432                 4.04029
#         standard error      2.04214                 0.29158
#   99% confidence level      4.75003                 0.67822
#                   skew     12.57097                 0.49535
#               kurtosis    167.51964                 0.23493
#       time correlation     -0.04513                -0.00542
#
#           elasped time     71.91025
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          228
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2   1576.00000 |**                                1576.64722
#                  1   1577.00000 |*                                 1577.52222
#                  2   1578.00000 |**                                1578.63522
#                  6   1579.00000 |********                          1579.65289
#                  9   1580.00000 |************                      1580.36022
#                 14   1581.00000 |*******************               1581.52322
#                 18   1582.00000 |*************************         1582.48633
#                 16   1583.00000 |**********************            1583.53834
#                 16   1584.00000 |**********************            1584.60422
#                 23   1585.00000 |********************************  1585.47804
#                 21   1586.00000 |*****************************     1586.60117
#                 19   1587.00000 |**************************        1587.53264
#                 14   1588.00000 |*******************               1588.52950
#                  6   1589.00000 |********                          1589.34489
#                  5   1590.00000 |******                            1590.62462
#                  4   1591.00000 |*****                             1591.56172
#                  5   1592.00000 |******                            1592.35822
#                  1   1593.00000 |*                                 1593.16222
#
#                 10        > 95% |*************                     1595.45482
#
#        mean of 95%   1585.18215
#          95th %ile   1593.57622
# bin/pthread_create -E -C 200 -L -S -W -N pthread_512 -B 512 
             prc thr   usecs/call      samples   errors cnt/samp 
pthread_512    1   1    926.70656          199        0      512 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    916.17556               916.17556
#                    max   1101.58156               936.33556
#                   mean    928.26471               926.30014
#                 median    926.73406               926.70656
#                 stddev     17.97713                 3.79291
#         standard error      1.26487                 0.26887
#   99% confidence level      2.94208                 0.62540
#                   skew      8.73434                -0.22748
#               kurtosis     80.11268                 0.15885
#       time correlation     -0.01086                 0.02569
#
#           elasped time    169.10375
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          227
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2    916.00000 |**                                 916.48906
#                  5    917.00000 |*****                              917.10826
#                  1    918.00000 |*                                  918.74156
#                  1    919.00000 |*                                  919.07006
#                  8    920.00000 |*********                          920.70318
#                  9    921.00000 |**********                         921.43895
#                 11    922.00000 |*************                      922.57819
#                 15    923.00000 |*****************                  923.48479
#                 19    924.00000 |**********************             924.48787
#                 17    925.00000 |********************               925.63903
#                 17    926.00000 |********************               926.46067
#                 27    927.00000 |********************************   927.54241
#                 19    928.00000 |**********************             928.45874
#                 20    929.00000 |***********************            929.51246
#                 12    930.00000 |**************                     930.30418
#                  6    931.00000 |*******                            931.47606
#
#                 10        > 95% |***********                        934.01086
#
#        mean of 95%    925.89217
#          95th %ile    932.16956
 
# bin/fork -E -C 200 -L -S -W -N fork_10 -B 10 
             prc thr   usecs/call      samples   errors cnt/samp 
fork_10        1   1   2628.68830          202        0       10 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   2287.56830              2287.56830
#                    max   3109.37950              3109.37950
#                   mean   2631.15756              2631.15756
#                 median   2628.68830              2628.68830
#                 stddev    161.21690               161.21690
#         standard error     11.34318                11.34318
#   99% confidence level     26.38424                26.38424
#                   skew      0.33026                 0.33026
#               kurtosis     -0.29074                -0.29074
#       time correlation      0.13569                 0.13569
#
#           elasped time      6.43200
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2   2280.00000 |**                                2294.17310
#                  2   2310.00000 |**                                2323.38270
#                  1   2340.00000 |*                                 2345.57790
#                  2   2370.00000 |**                                2384.87390
#                  6   2400.00000 |*******                           2418.80670
#                 27   2430.00000 |********************************  2441.75046
#                 15   2460.00000 |*****************                 2474.67870
#                  4   2490.00000 |****                              2508.02910
#                  6   2520.00000 |*******                           2542.24990
#                  9   2550.00000 |**********                        2564.23319
#                 17   2580.00000 |********************              2594.12679
#                 13   2610.00000 |***************                   2621.22098
#                 15   2640.00000 |*****************                 2656.21171
#                 15   2670.00000 |*****************                 2684.96734
#                 20   2700.00000 |***********************           2714.02206
#                  7   2730.00000 |********                          2744.29424
#                 10   2760.00000 |***********                       2779.76158
#                  9   2790.00000 |**********                        2802.54359
#                  4   2820.00000 |****                              2837.07230
#                  2   2850.00000 |**                                2873.11710
#                  3   2880.00000 |***                               2901.51603
#                  2   2910.00000 |**                                2917.17470
#
#                 11        > 95% |*************                     2980.11346
#
#        mean of 95%   2611.06062
#          95th %ile   2920.65630
# bin/fork -E -C 200 -L -S -W -N fork_100 -B 100 -C 100 
             prc thr   usecs/call      samples   errors cnt/samp 
fork_100       1   1   2929.42623          101        0      100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   2763.95807              2763.95807
#                    max   3994.48607              3208.82719
#                   mean   2983.97172              2973.96663
#                 median   2929.46975              2929.42623
#                 stddev    159.43650               123.94234
#         standard error     15.78657                12.33272
#   99% confidence level     36.71955                28.68591
#                   skew      2.63179                 0.53196
#               kurtosis     13.47442                -1.05851
#       time correlation     -0.59848                -0.44068
#
#           elasped time     32.97150
#      number of samples          101
#     number of outliers            1
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3   2760.00000 |*******                           2772.98804
#                  1   2780.00000 |**                                2793.44671
#                  0   2800.00000 |                                           -
#                  4   2820.00000 |*********                         2832.08735
#                  8   2840.00000 |*******************               2852.79359
#                 10   2860.00000 |************************          2870.58975
#                  8   2880.00000 |*******************               2889.03135
#                  9   2900.00000 |**********************            2907.56724
#                 13   2920.00000 |********************************  2928.43689
#                  7   2940.00000 |*****************                 2950.48735
#                  2   2960.00000 |****                              2965.84223
#                  1   2980.00000 |**                                2997.20735
#                  2   3000.00000 |****                              3013.95231
#                  3   3020.00000 |*******                           3031.54463
#                  0   3040.00000 |                                           -
#                  4   3060.00000 |*********                         3070.10079
#                  3   3080.00000 |*******                           3089.24276
#                  2   3100.00000 |****                              3112.45343
#                  1   3120.00000 |**                                3136.69663
#                  8   3140.00000 |*******************               3151.32703
#                  5   3160.00000 |************                      3171.15986
#                  1   3180.00000 |**                                3183.38847
#
#                  6        > 95% |**************                    3197.86783
#
#        mean of 95%   2959.82550
#          95th %ile   3187.01599
# bin/fork -E -C 200 -L -S -W -N fork_1000 -B 1000 -C 50 
             prc thr   usecs/call      samples   errors cnt/samp 
fork_1000      1   1   2860.26986           48        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   2833.00279              2833.00279
#                    max   3024.03972              2915.63063
#                   mean   2872.66953              2864.56017
#                 median   2862.19985              2860.26986
#                 stddev     35.40955                19.94900
#         standard error      4.91042                 2.87939
#   99% confidence level     11.42164                 6.69746
#                   skew      2.11561                 0.85625
#               kurtosis      5.26531                 0.03177
#       time correlation     -0.24405                -0.01078
#
#           elasped time    174.08373
#      number of samples           48
#     number of outliers            4
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   2832.00000 |*****                             2833.00279
#                  0   2835.00000 |                                           -
#                  2   2838.00000 |**********                        2839.62666
#                  2   2841.00000 |**********                        2842.61930
#                  5   2844.00000 |**************************        2846.14916
#                  2   2847.00000 |**********                        2848.74577
#                  4   2850.00000 |*********************             2850.88862
#                  2   2853.00000 |**********                        2855.76196
#                  6   2856.00000 |********************************  2856.82897
#                  2   2859.00000 |**********                        2861.07934
#                  3   2862.00000 |****************                  2863.18809
#                  3   2865.00000 |****************                  2866.39108
#                  1   2868.00000 |*****                             2870.79479
#                  3   2871.00000 |****************                  2872.69192
#                  0   2874.00000 |                                           -
#                  2   2877.00000 |**********                        2878.35242
#                  2   2880.00000 |**********                        2880.78442
#                  0   2883.00000 |                                           -
#                  0   2886.00000 |                                           -
#                  3   2889.00000 |****************                  2890.87543
#                  2   2892.00000 |**********                        2893.82980
#
#                  3        > 95% |****************                  2912.92582
#
#        mean of 95%   2861.33579
#          95th %ile   2908.82487
 
# bin/exit -E -C 200 -L -S -W -N exit_10 -B 10 
             prc thr   usecs/call      samples   errors cnt/samp 
exit_10        1   1   1891.69030          200        0       10 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1400.57990              1731.28070
#                    max   2104.68230              2035.58790
#                   mean   1883.62820              1884.93817
#                 median   1891.69030              1891.69030
#                 stddev     79.67129                70.65048
#         standard error      5.60565                 4.99574
#   99% confidence level     13.03875                11.62010
#                   skew     -1.10068                -0.20463
#               kurtosis      5.38865                -0.69107
#       time correlation      0.03578                -0.00798
#
#           elasped time      6.27437
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3   1728.00000 |*******                           1733.48230
#                  4   1737.00000 |*********                         1743.68390
#                  4   1746.00000 |*********                         1748.65030
#                  1   1755.00000 |**                                1756.47110
#                  0   1764.00000 |                                           -
#                  3   1773.00000 |*******                           1777.83857
#                  7   1782.00000 |*****************                 1787.75064
#                 11   1791.00000 |***************************       1794.69423
#                  3   1800.00000 |*******                           1805.94737
#                  4   1809.00000 |*********                         1815.25510
#                  5   1818.00000 |************                      1821.05478
#                  1   1827.00000 |**                                1834.78150
#                  8   1836.00000 |*******************               1840.82950
#                 12   1845.00000 |*****************************     1849.09617
#                 11   1854.00000 |***************************       1859.76245
#                  7   1863.00000 |*****************                 1867.66287
#                  7   1872.00000 |*****************                 1876.28641
#                  9   1881.00000 |**********************            1884.47679
#                  8   1890.00000 |*******************               1894.89990
#                  8   1899.00000 |*******************               1902.25350
#                 13   1908.00000 |********************************  1912.23922
#                 10   1917.00000 |************************          1922.26950
#                 11   1926.00000 |***************************       1931.08405
#                  7   1935.00000 |*****************                 1938.25304
#                  4   1944.00000 |*********                         1947.68390
#                  7   1953.00000 |*****************                 1956.63750
#                  6   1962.00000 |**************                    1966.07110
#                  8   1971.00000 |*******************               1974.04870
#                  8   1980.00000 |*******************               1984.06470
#
#                 10        > 95% |************************          2009.46822
#
#        mean of 95%   1878.38396
#          95th %ile   1988.99590
# bin/exit -E -C 200 -L -S -W -N exit_100 -B 100 
             prc thr   usecs/call      samples   errors cnt/samp 
exit_100       1   1   1781.46849          200        0      100 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1210.62689              1714.20705
#                    max   1826.49889              1826.49889
#                   mean   1774.26389              1777.46176
#                 median   1781.27905              1781.46849
#                 stddev     46.05223                22.50451
#         standard error      3.24022                 1.59131
#   99% confidence level      7.53676                 3.70138
#                   skew     -9.11795                -0.59793
#               kurtosis    108.27604                 0.00627
#       time correlation      0.04893                -0.03366
#
#           elasped time     65.75412
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1712.00000 |*                                 1714.20705
#                  1   1716.00000 |*                                 1719.07617
#                  0   1720.00000 |                                           -
#                  5   1724.00000 |********                          1726.90516
#                  3   1728.00000 |****                              1731.21484
#                  5   1732.00000 |********                          1734.05166
#                  4   1736.00000 |******                            1737.71169
#                  2   1740.00000 |***                               1742.26337
#                  2   1744.00000 |***                               1747.68417
#                  9   1748.00000 |**************                    1749.89146
#                  5   1752.00000 |********                          1753.59009
#                  6   1756.00000 |*********                         1758.11788
#                  2   1760.00000 |***                               1760.87201
#                  7   1764.00000 |***********                       1766.23649
#                 10   1768.00000 |****************                  1769.65281
#                 13   1772.00000 |********************              1773.79893
#                 19   1776.00000 |******************************    1777.80890
#                 17   1780.00000 |***************************       1781.99404
#                 20   1784.00000 |********************************  1785.72692
#                 15   1788.00000 |************************          1789.69616
#                 19   1792.00000 |******************************    1793.77630
#                 10   1796.00000 |****************                  1798.48404
#                 10   1800.00000 |****************                  1801.74471
#                  4   1804.00000 |******                            1806.28769
#                  1   1808.00000 |*                                 1808.52769
#
#                 10        > 95% |****************                  1817.29390
#
#        mean of 95%   1775.36533
#          95th %ile   1810.22753
# bin/exit -E -C 200 -L -S -W -N exit_1000 -B 1000 -C 50 
             prc thr   usecs/call      samples   errors cnt/samp 
exit_1000      1   1   1742.53086           51        0     1000 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1225.72702              1722.71364
#                    max   1771.42379              1771.42379
#                   mean   1733.22588              1743.17684
#                 median   1742.53086              1742.53086
#                 stddev     72.66680                11.57452
#         standard error     10.07707                 1.62076
#   99% confidence level     23.43927                 3.76988
#                   skew     -6.53696                 0.32453
#               kurtosis     42.75555                -0.49956
#       time correlation      1.09575                -0.03262
#
#           elasped time    172.20571
#      number of samples           51
#     number of outliers            1
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1722.00000 |********                          1722.71364
#                  2   1724.00000 |****************                  1724.54289
#                  1   1726.00000 |********                          1726.05572
#                  3   1728.00000 |************************          1728.93478
#                  3   1730.00000 |************************          1730.98552
#                  2   1732.00000 |****************                  1732.98219
#                  3   1734.00000 |************************          1735.26012
#                  3   1736.00000 |************************          1736.95083
#                  2   1738.00000 |****************                  1739.29489
#                  4   1740.00000 |********************************  1740.86033
#                  4   1742.00000 |********************************  1742.77880
#                  4   1744.00000 |********************************  1745.32651
#                  4   1746.00000 |********************************  1746.92734
#                  2   1748.00000 |****************                  1749.38628
#                  0   1750.00000 |                                           -
#                  4   1752.00000 |********************************  1752.87902
#                  2   1754.00000 |****************                  1755.51121
#                  2   1756.00000 |****************                  1757.08727
#                  0   1758.00000 |                                           -
#                  2   1760.00000 |****************                  1760.71479
#
#                  3        > 95% |************************          1767.57619
#
#        mean of 95%   1741.65188
#          95th %ile   1762.59588
 
# bin/exit -E -C 200 -L -S -W -N exit_10_nolibc -e -B 10 
             prc thr   usecs/call      samples   errors cnt/samp 
exit_10_nolibc   1   1   1472.77240          201        0       10 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1113.47640              1257.96280
#                    max   1712.46520              1712.46520
#                   mean   1479.66678              1481.48863
#                 median   1472.77240              1472.77240
#                 stddev     86.49066                82.72983
#         standard error      6.08546                 5.83531
#   99% confidence level     14.15478                13.57294
#                   skew     -0.34240                -0.02748
#               kurtosis      0.51527                -0.68996
#       time correlation      0.13564                 0.08302
#
#           elasped time      5.59852
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1240.00000 |*                                 1257.96280
#                  0   1260.00000 |                                           -
#                  0   1280.00000 |                                           -
#                  0   1300.00000 |                                           -
#                 12   1320.00000 |***********                       1335.84653
#                  6   1340.00000 |*****                             1347.31533
#                  0   1360.00000 |                                           -
#                  8   1380.00000 |*******                           1390.11000
#                 33   1400.00000 |********************************  1412.46888
#                 10   1420.00000 |*********                         1424.96952
#                  9   1440.00000 |********                          1451.21720
#                 31   1460.00000 |******************************    1469.55836
#                  3   1480.00000 |**                                1484.07053
#                  8   1500.00000 |*******                           1510.44280
#                 31   1520.00000 |******************************    1528.87686
#                  6   1540.00000 |*****                             1547.18307
#                 10   1560.00000 |*********                         1574.70136
#                 21   1580.00000 |********************              1588.35274
#                  1   1600.00000 |*                                 1604.89400
#
#                 11        > 95% |**********                        1626.04891
#
#        mean of 95%   1473.11935
#          95th %ile   1606.76280
 
# bin/exec -E -C 200 -L -S -W -N exec -B 10 
             prc thr   usecs/call      samples   errors cnt/samp 
exec           1   1   5275.77950          198        0       10 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   5164.88030              5164.88030
#                    max   5651.97150              5383.47870
#                   mean   5283.02531              5278.99502
#                 median   5278.67230              5275.77950
#                 stddev     51.69479                41.30973
#         standard error      3.63723                 2.93575
#   99% confidence level      8.46020                 6.82856
#                   skew      2.04762                 0.15086
#               kurtosis     11.81875                -0.29298
#       time correlation      0.02790                 0.01177
#
#           elasped time     10.69318
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   5160.00000 |*                                 5164.88030
#                  0   5166.00000 |                                           -
#                  0   5172.00000 |                                           -
#                  0   5178.00000 |                                           -
#                  1   5184.00000 |*                                 5189.37950
#                  2   5190.00000 |***                               5194.42270
#                  0   5196.00000 |                                           -
#                  2   5202.00000 |***                               5204.88030
#                  4   5208.00000 |******                            5210.09630
#                  1   5214.00000 |*                                 5216.59230
#                  7   5220.00000 |***********                       5223.42384
#                  7   5226.00000 |***********                       5229.76533
#                 11   5232.00000 |******************                5234.83346
#                  5   5238.00000 |********                          5240.15454
#                  8   5244.00000 |*************                     5247.42750
#                 10   5250.00000 |****************                  5252.87518
#                 13   5256.00000 |*********************             5258.81458
#                  4   5262.00000 |******                            5265.39870
#                 19   5268.00000 |********************************  5271.54742
#                 10   5274.00000 |****************                  5276.88798
#                 16   5280.00000 |**************************        5283.39390
#                  7   5286.00000 |***********                       5288.51367
#                 10   5292.00000 |****************                  5294.91294
#                  4   5298.00000 |******                            5298.72350
#                  7   5304.00000 |***********                       5307.17607
#                  8   5310.00000 |*************                     5312.34270
#                  9   5316.00000 |***************                   5319.33932
#                  8   5322.00000 |*************                     5324.30110
#                  2   5328.00000 |***                               5330.61470
#                  6   5334.00000 |**********                        5337.37310
#                  6   5340.00000 |**********                        5342.05790
#
#                 10        > 95% |****************                  5365.90942
#
#        mean of 95%   5274.37191
#          95th %ile   5348.27870
 
# bin/system -E -C 200 -L -S -W -N system -I 1000000 
             prc thr   usecs/call      samples   errors cnt/samp  command
system         1   1  17779.74300          199        0        1     A=$$
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min  17371.93500             17371.93500
#                    max  18855.71100             18452.76700
#                   mean  17834.15314             17820.48559
#                 median  17781.79100             17779.74300
#                 stddev    245.62549               220.23668
#         standard error     17.28215                15.61216
#   99% confidence level     40.19828                36.31389
#                   skew      0.94898                 0.44420
#               kurtosis      1.39412                -0.55934
#       time correlation      0.15613                 0.27275
#
#           elasped time      3.60686
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1  17370.00000 |**                               17371.93500
#                  1  17400.00000 |**                               17419.80700
#                  3  17430.00000 |******                           17446.77233
#                  1  17460.00000 |**                               17474.84700
#                  3  17490.00000 |******                           17509.74833
#                  8  17520.00000 |*****************                17535.39100
#                  7  17550.00000 |**************                   17565.50757
#                 12  17580.00000 |*************************        17595.01767
#                  9  17610.00000 |*******************              17625.11900
#                 13  17640.00000 |***************************      17655.01192
#                 11  17670.00000 |***********************          17678.62300
#                 15  17700.00000 |******************************** 17714.87260
#                 12  17730.00000 |*************************        17746.80433
#                  8  17760.00000 |*****************                17778.81500
#                  7  17790.00000 |**************                   17798.90643
#                  6  17820.00000 |************                     17834.74033
#                  5  17850.00000 |**********                       17865.70780
#                  8  17880.00000 |*****************                17894.81500
#                  7  17910.00000 |**************                   17927.19900
#                  7  17940.00000 |**************                   17953.09157
#                 11  17970.00000 |***********************          17987.52191
#                  7  18000.00000 |**************                   18013.32471
#                  3  18030.00000 |******                           18046.23900
#                  5  18060.00000 |**********                       18065.74620
#                  9  18090.00000 |*******************              18102.70122
#                  4  18120.00000 |********                         18135.00700
#                  3  18150.00000 |******                           18162.46300
#                  1  18180.00000 |**                               18192.92700
#                  2  18210.00000 |****                             18218.27100
#
#                 10        > 95% |*********************            18298.27100
#
#        mean of 95%  17795.20594
#          95th %ile  18221.85500
 
# bin/recurse -E -C 200 -L -S -W -N recurse -B 512 
             prc thr   usecs/call      samples   errors cnt/samp 
recurse        1   1      3.51908          190        0      512 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      3.51708                 3.51708
#                    max      4.33158                 3.58158
#                   mean      3.55258                 3.53554
#                 median      3.51908                 3.51908
#                 stddev      0.09528                 0.02053
#         standard error      0.00670                 0.00149
#   99% confidence level      0.01559                 0.00346
#                   skew      6.05259                 0.37704
#               kurtosis     39.30868                -1.70135
#       time correlation     -0.00008                 0.00001
#
#           elasped time      0.37101
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                180      3.00000 |********************************     3.53366
#
#                 10        > 95% |*                                    3.56928
#
#        mean of 95%      3.53366
#          95th %ile      3.56208
 
# bin/read -E -C 200 -L -S -W -N read_t1k -s 1k -B 800 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_t1k       1   1      5.54341          192        0      800     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      5.06341                 5.30853
#                    max      6.53349                 5.76581
#                   mean      5.53183                 5.50950
#                 median      5.54501                 5.54341
#                 stddev      0.15829                 0.09674
#         standard error      0.01114                 0.00698
#   99% confidence level      0.02591                 0.01624
#                   skew      2.20950                -0.56080
#               kurtosis     10.99541                -0.68050
#       time correlation     -0.00061                -0.00062
#
#           elasped time      0.89916
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                182      5.00000 |********************************     5.50096
#
#                 10        > 95% |*                                    5.66482
#
#        mean of 95%      5.50096
#          95th %ile      5.63461
# bin/read -E -C 200 -L -S -W -N read_t10k -s 10k -B 200 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_t10k      1   1     21.40822          178        0      200    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     20.83863                21.12918
#                    max     27.51894                21.73334
#                   mean     21.51846                21.40210
#                 median     21.41463                21.40822
#                 stddev      0.61904                 0.11305
#         standard error      0.04356                 0.00847
#   99% confidence level      0.10131                 0.01971
#                   skew      6.14066                 0.22685
#               kurtosis     48.40015                 1.03738
#       time correlation     -0.00157                -0.00042
#
#           elasped time      0.87466
#      number of samples          178
#     number of outliers           24
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                169     21.00000 |********************************    21.38698
#
#                  9        > 95% |*                                   21.68598
#
#        mean of 95%     21.38698
#          95th %ile     21.63863
# bin/read -E -C 200 -L -S -W -N read_t100k -s 100k -B 20 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_t100k     1   1    174.03080          191        0       20   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    170.93320               170.93320
#                    max    214.49160               176.79560
#                   mean    174.65439               173.80087
#                 median    174.04360               174.03080
#                 stddev      4.36824                 1.03456
#         standard error      0.30735                 0.07486
#   99% confidence level      0.71489                 0.17412
#                   skew      5.55282                -1.27794
#               kurtosis     38.33661                 2.05460
#       time correlation     -0.00566                -0.00074
#
#           elasped time      0.71100
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2    170.00000 |*                                  170.95880
#                 22    171.00000 |********                           171.41320
#                  1    172.00000 |*                                  172.03400
#                 68    173.00000 |************************           173.82318
#                 88    174.00000 |********************************   174.28127
#
#                 10        > 95% |***                                175.41960
#
#        mean of 95%    173.71144
#          95th %ile    174.73480
 
# bin/read -E -C 200 -L -S -W -N read_u1k -s 1k -B 500 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_u1k       1   1      7.34728          166        0      500     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      7.23157                 7.31196
#                    max      8.70767                 7.37340
#                   mean      7.37833                 7.34463
#                 median      7.34728                 7.34728
#                 stddev      0.17200                 0.01453
#         standard error      0.01210                 0.00113
#   99% confidence level      0.02815                 0.00262
#                   skew      4.52471                -0.19036
#               kurtosis     23.39601                -0.63994
#       time correlation     -0.00040                 0.00010
#
#           elasped time      0.75029
#      number of samples          166
#     number of outliers           36
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                157      7.00000 |********************************     7.34318
#
#                  9        > 95% |*                                    7.36981
#
#        mean of 95%      7.34318
#          95th %ile      7.36776
# bin/read -E -C 200 -L -S -W -N read_u10k -s 10k -B 200 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_u10k      1   1     23.17971          186        0      200    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     23.03378                23.03378
#                    max     29.62451                23.50867
#                   mean     23.34710                23.20960
#                 median     23.18483                23.17971
#                 stddev      0.62861                 0.09988
#         standard error      0.04423                 0.00732
#   99% confidence level      0.10288                 0.01703
#                   skew      6.34022                 1.34687
#               kurtosis     51.52813                 0.96705
#       time correlation     -0.00152                 0.00009
#
#           elasped time      0.94882
#      number of samples          186
#     number of outliers           16
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                176     23.00000 |********************************    23.19506
#
#                 10        > 95% |*                                   23.46540
#
#        mean of 95%     23.19506
#          95th %ile     23.43314
# bin/read -E -C 200 -L -S -W -N read_u100k -s 100k -B 20 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_u100k     1   1    170.39555          190        0       20   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    167.64355               167.64355
#                    max    208.38595               172.63555
#                   mean    171.05608               170.13221
#                 median    170.39555               170.39555
#                 stddev      4.43254                 0.92904
#         standard error      0.31187                 0.06740
#   99% confidence level      0.72542                 0.15677
#                   skew      5.12753                -1.45297
#               kurtosis     30.96763                 1.74371
#       time correlation     -0.00705                -0.00167
#
#           elasped time      0.69657
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 12    167.00000 |**                                 167.84835
#                 15    168.00000 |***                                168.10691
#                  2    169.00000 |*                                  169.99235
#                151    170.00000 |********************************   170.43293
#
#                 10        > 95% |**                                 171.39779
#
#        mean of 95%    170.06190
#          95th %ile    170.93315
 
# bin/read -E -C 200 -L -S -W -N read_z1k -s 1k -B 600 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_z1k       1   1      2.98930          196        0      600     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      2.91634                 2.91634
#                    max      3.56999                 3.08487
#                   mean      2.99932                 2.98720
#                 median      2.98972                 2.98930
#                 stddev      0.08561                 0.03781
#         standard error      0.00602                 0.00270
#   99% confidence level      0.01401                 0.00628
#                   skew      4.79482                 0.35925
#               kurtosis     27.64534                -0.73278
#       time correlation     -0.00005                -0.00008
#
#           elasped time      0.36760
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                124      2.00000 |********************************     2.96389
#                 62      3.00000 |****************                     3.02080
#
#                 10        > 95% |**                                   3.06789
#
#        mean of 95%      2.98286
#          95th %ile      3.05970
# bin/read -E -C 200 -L -S -W -N read_z10k -s 10k -B 200 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_z10k      1   1      6.86869          195        0      200    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.72789                 6.72789
#                    max      8.95508                 7.18356
#                   mean      6.97083                 6.92461
#                 median      6.86869                 6.86869
#                 stddev      0.27745                 0.08640
#         standard error      0.01952                 0.00619
#   99% confidence level      0.04541                 0.01439
#                   skew      5.15620                 0.77224
#               kurtosis     29.13198                -0.90001
#       time correlation     -0.00003                -0.00001
#
#           elasped time      0.28579
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                132      6.00000 |********************************     6.86763
#                 53      7.00000 |************                         7.03393
#
#                 10        > 95% |**                                   7.09742
#
#        mean of 95%      6.91527
#          95th %ile      7.04917
# bin/read -E -C 200 -L -S -W -N read_z100k -s 100k -B 40 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_z100k     1   1     63.02143          191        0       40   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     62.11903                62.11903
#                    max     96.24383                63.99423
#                   mean     63.49075                62.93598
#                 median     63.06622                63.02143
#                 stddev      3.20917                 0.40328
#         standard error      0.22580                 0.02918
#   99% confidence level      0.52520                 0.06787
#                   skew      7.57922                -0.22326
#               kurtosis     65.64427                -0.77322
#       time correlation     -0.00638                -0.00254
#
#           elasped time      0.51744
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          231
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 94     62.00000 |********************************    62.58684
#                 87     63.00000 |*****************************       63.23218
#
#                 10        > 95% |***                                 63.64095
#
#        mean of 95%     62.89703
#          95th %ile     63.44382
# bin/read -E -C 200 -L -S -W -N read_zw100k -s 100k -B 40 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
read_zw100k    1   1     68.02015          191        0       40   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     66.97055                66.97055
#                    max     84.51935                69.11455
#                   mean     68.24973                67.87520
#                 median     68.02015                68.02015
#                 stddev      1.87684                 0.43093
#         standard error      0.13205                 0.03118
#   99% confidence level      0.30716                 0.07253
#                   skew      5.28925                -0.21955
#               kurtosis     33.45748                -0.55516
#       time correlation     -0.00162                 0.00020
#
#           elasped time      0.55623
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     66.00000 |*                                   66.97055
#                 90     67.00000 |********************************    67.52195
#                 90     68.00000 |********************************    68.14630
#
#                 10        > 95% |***                                 68.70495
#
#        mean of 95%     67.82935
#          95th %ile     68.49375
 
# bin/write -E -C 200 -L -S -W -N write_t1k -s 1k -B 200 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_t1k      1   1     10.25813          197        0      200     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      9.41461                 9.41461
#                    max     12.88853                11.48437
#                   mean     10.32183                10.26957
#                 median     10.27989                10.25813
#                 stddev      0.54029                 0.42937
#         standard error      0.03801                 0.03059
#   99% confidence level      0.08842                 0.07116
#                   skew      1.43039                 0.16231
#               kurtosis      4.55119                -0.23949
#       time correlation     -0.00181                -0.00216
#
#           elasped time      0.42179
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 51      9.00000 |************                         9.71654
#                134     10.00000 |********************************    10.39977
#                  2     11.00000 |*                                   11.02357
#
#                 10        > 95% |**                                  11.19458
#
#        mean of 95%     10.22011
#          95th %ile     11.04917
# bin/write -E -C 200 -L -S -W -N write_t10k -s 10k -B 100 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_t10k     1   1     26.55778          195        0      100    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     25.70786                25.70786
#                    max     30.75874                27.68674
#                   mean     26.65728                26.54427
#                 median     26.56802                26.55778
#                 stddev      0.74243                 0.42145
#         standard error      0.05224                 0.03018
#   99% confidence level      0.12150                 0.07020
#                   skew      2.97673                 0.06590
#               kurtosis     12.22324                -0.54522
#       time correlation      0.00273                 0.00200
#
#           elasped time      0.54354
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 27     25.00000 |******                              25.88118
#                137     26.00000 |********************************    26.53233
#                 21     27.00000 |****                                27.07624
#
#                 10        > 95% |**                                  27.38108
#
#        mean of 95%     26.49904
#          95th %ile     27.21826
# bin/write -E -C 200 -L -S -W -N write_t100k -s 100k -B 10 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_t100k    1   1    205.77610          198        0       10   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    199.86250               199.86250
#                    max    255.97770               214.17290
#                   mean    205.66115               204.92548
#                 median    205.77610               205.77610
#                 stddev      6.42816                 3.64664
#         standard error      0.45228                 0.25916
#   99% confidence level      1.05201                 0.60280
#                   skew      4.18083                 0.50878
#               kurtosis     25.00339                -0.40312
#       time correlation     -0.03839                -0.02873
#
#           elasped time      0.42080
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    199.00000 |*                                  199.86250
#                 27    200.00000 |*****************                  200.62576
#                 50    201.00000 |********************************   201.39696
#                  4    202.00000 |**                                 202.33290
#                  0    203.00000 |                                           -
#                  3    204.00000 |*                                  204.83743
#                 25    205.00000 |****************                   205.67677
#                 32    206.00000 |********************               206.60410
#                 32    207.00000 |********************               207.48730
#                  9    208.00000 |*****                              208.32188
#                  0    209.00000 |                                           -
#                  0    210.00000 |                                           -
#                  0    211.00000 |                                           -
#                  5    212.00000 |***                                212.65738
#
#                 10        > 95% |******                             213.37674
#
#        mean of 95%    204.47595
#          95th %ile    212.86730
 
# bin/write -E -C 200 -L -S -W -N write_u1k -s 1k -B 200 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_u1k      1   1     11.77874          196        0      200     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     11.09394                11.09394
#                    max     14.06354                12.60306
#                   mean     11.82766                11.77180
#                 median     11.78770                11.77874
#                 stddev      0.43013                 0.28374
#         standard error      0.03026                 0.02027
#   99% confidence level      0.07039                 0.04714
#                   skew      2.43503                 0.15810
#               kurtosis      9.48074                -0.34099
#       time correlation     -0.00138                -0.00104
#
#           elasped time      0.48301
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                153     11.00000 |********************************    11.66479
#                 33     12.00000 |******                              12.08706
#
#                 10        > 95% |**                                  12.36882
#
#        mean of 95%     11.73971
#          95th %ile     12.22930
# bin/write -E -C 200 -L -S -W -N write_u10k -s 10k -B 100 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_u10k     1   1     28.80811          194        0      100    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     27.12875                27.12875
#                    max     41.69771                29.82699
#                   mean     28.83850                28.63340
#                 median     28.83883                28.80811
#                 stddev      1.36568                 0.59101
#         standard error      0.09609                 0.04243
#   99% confidence level      0.22350                 0.09870
#                   skew      5.64848                -0.67811
#               kurtosis     45.10029                -0.44659
#       time correlation     -0.00356                 0.00031
#
#           elasped time      0.58801
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 37     27.00000 |***********                         27.65078
#                100     28.00000 |********************************    28.66104
#                 47     29.00000 |***************                     29.15681
#
#                 10        > 95% |***                                 29.53259
#
#        mean of 95%     28.58453
#          95th %ile     29.35851
# bin/write -E -C 200 -L -S -W -N write_u100k -s 100k -B 10 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_u100k    1   1    230.58260          197        0       10   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    220.39380               220.39380
#                    max    288.28500               242.17940
#                   mean    229.88215               228.93809
#                 median    230.96660               230.58260
#                 stddev      8.29808                 5.55282
#         standard error      0.58385                 0.39562
#   99% confidence level      1.35804                 0.92022
#                   skew      2.78246                -0.09444
#               kurtosis     14.64919                -1.25551
#       time correlation     -0.00245                 0.00491
#
#           elasped time      0.47007
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 14    220.00000 |*****************                  220.53460
#                 21    221.00000 |*************************          221.39586
#                  9    222.00000 |***********                        222.37922
#                  4    223.00000 |****                               223.64500
#                 17    224.00000 |********************               224.50938
#                 11    225.00000 |*************                      225.42769
#                  7    226.00000 |********                           226.52683
#                  6    227.00000 |*******                            227.40393
#                  1    228.00000 |*                                  228.86740
#                  4    229.00000 |****                               229.69300
#                  8    230.00000 |*********                          230.51220
#                  9    231.00000 |***********                        231.64073
#                 26    232.00000 |********************************   232.49669
#                 15    233.00000 |******************                 233.48905
#                 22    234.00000 |***************************        234.48078
#                 13    235.00000 |****************                   235.18666
#
#                 10        > 95% |************                       238.17812
#
#        mean of 95%    228.44397
#          95th %ile    235.39540
 
# bin/write -E -C 200 -L -S -W -N write_n1k -s 1k -I 100 -B 0 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_n1k      1   1      0.97668          199        0     1000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.94878                 0.94878
#                    max      1.27876                 1.01457
#                   mean      0.97945                 0.97734
#                 median      0.97668                 0.97668
#                 stddev      0.02623                 0.01432
#         standard error      0.00185                 0.00101
#   99% confidence level      0.00429                 0.00236
#                   skew      7.44907                 0.26355
#               kurtosis     81.44610                -0.62433
#       time correlation      0.00005                 0.00004
#
#           elasped time      0.20198
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      0.00000 |********************************     0.97536
#                  3      1.00000 |*                                    1.00219
#
#                 10        > 95% |*                                    1.00676
#
#        mean of 95%      0.97578
#          95th %ile      1.00279
# bin/write -E -C 200 -L -S -W -N write_n10k -s 10k -I 100 -B 0 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_n10k     1   1      0.97796          198        0     1000    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.94571                 0.94571
#                    max      1.31767                 1.02788
#                   mean      0.98504                 0.98110
#                 median      0.97873                 0.97796
#                 stddev      0.03775                 0.01833
#         standard error      0.00266                 0.00130
#   99% confidence level      0.00618                 0.00303
#                   skew      6.22399                 0.53301
#               kurtosis     50.16020                -0.33747
#       time correlation      0.00001                -0.00003
#
#           elasped time      0.20299
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                164      0.00000 |********************************     0.97469
#                 24      1.00000 |****                                 1.00804
#
#                 10        > 95% |*                                    1.02151
#
#        mean of 95%      0.97895
#          95th %ile      1.01483
# bin/write -E -C 200 -L -S -W -N write_n100k -s 100k -I 100 -B 0 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size
write_n100k    1   1      0.98898          197        0     1000   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.94981                 0.94981
#                    max      1.35583                 1.04786
#                   mean      0.99555                 0.98945
#                 median      0.99179                 0.98898
#                 stddev      0.04701                 0.02024
#         standard error      0.00331                 0.00144
#   99% confidence level      0.00769                 0.00335
#                   skew      5.42079                 0.27298
#               kurtosis     35.70068                -0.69231
#       time correlation      0.00008                 0.00006
#
#           elasped time      0.20524
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          207
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                143      0.00000 |********************************     0.97967
#                 44      1.00000 |*********                            1.01193
#
#                 10        > 95% |**                                   1.03045
#
#        mean of 95%      0.98726
#          95th %ile      1.02379
 
# bin/writev -E -C 200 -L -S -W -N writev_t1k -s 1k -B 200 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_t1k     1   1     45.60403          189        0      200     1024   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     44.94867                44.94867
#                    max     53.70899                46.40915
#                   mean     45.81970                45.62028
#                 median     45.62451                45.60403
#                 stddev      0.99384                 0.30456
#         standard error      0.06993                 0.02215
#   99% confidence level      0.16265                 0.05153
#                   skew      5.12449                 0.46885
#               kurtosis     31.06217                -0.08835
#       time correlation     -0.00077                 0.00031
#
#           elasped time      1.85647
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     44.00000 |*                                   44.96339
#                163     45.00000 |********************************    45.54392
#                 14     46.00000 |**                                  46.11256
#
#                 10        > 95% |*                                   46.30713
#
#        mean of 95%     45.58191
#          95th %ile     46.20947
# bin/writev -E -C 200 -L -S -W -N writev_t10k -s 10k -B 10 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_t10k    1   1    226.87160          197        0       10    10240   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    220.57400               220.57400
#                    max    264.88760               236.19000
#                   mean    227.38829               226.71501
#                 median    226.97400               226.87160
#                 stddev      5.57816                 3.22238
#         standard error      0.39248                 0.22959
#   99% confidence level      0.91290                 0.53402
#                   skew      3.83567                -0.09291
#               kurtosis     22.17802                -0.84212
#       time correlation      0.01354                 0.01907
#
#           elasped time      0.46512
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  6    220.00000 |******                             220.74467
#                 16    221.00000 |****************                   221.42040
#                  5    222.00000 |*****                              222.65272
#                 14    223.00000 |**************                     223.60577
#                 32    224.00000 |********************************   224.61240
#                 16    225.00000 |****************                   225.41880
#                 16    226.00000 |****************                   226.74680
#                 12    227.00000 |************                       227.43053
#                 11    228.00000 |***********                        228.48905
#                 32    229.00000 |********************************   229.62840
#                 27    230.00000 |***************************        230.33139
#
#                 10        > 95% |**********                         232.00696
#
#        mean of 95%    226.43202
#          95th %ile    230.76280
# bin/writev -E -C 200 -L -S -W -N writev_t100k -s 100k -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_t100k   1   1   1953.81600          198        0        1   102400   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1926.93600              1926.93600
#                    max   6051.60800              2047.76800
#                   mean   1991.96253              1965.58941
#                 median   1976.85600              1953.81600
#                 stddev    293.30320                27.64018
#         standard error     20.63674                 1.96430
#   99% confidence level     48.00106                 4.56897
#                   skew     13.17628                 0.22027
#               kurtosis    178.79034                -1.32924
#       time correlation     -0.69424                 0.03940
#
#           elasped time      0.40871
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          232
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2   1926.00000 |***                               1927.83200
#                  8   1929.00000 |************                      1930.52000
#                 11   1932.00000 |****************                  1933.66182
#                 21   1935.00000 |********************************  1936.60305
#                 19   1938.00000 |****************************      1939.64168
#                 20   1941.00000 |******************************    1942.80800
#                  8   1944.00000 |************                      1945.36800
#                  6   1947.00000 |*********                         1948.48267
#                  3   1950.00000 |****                              1952.10933
#                  3   1953.00000 |****                              1953.73067
#                  0   1956.00000 |                                           -
#                  0   1959.00000 |                                           -
#                  0   1962.00000 |                                           -
#                  0   1965.00000 |                                           -
#                  0   1968.00000 |                                           -
#                  0   1971.00000 |                                           -
#                  1   1974.00000 |*                                 1976.85600
#                  4   1977.00000 |******                            1979.03200
#                  5   1980.00000 |*******                           1982.53920
#                 12   1983.00000 |******************                1984.96267
#                 15   1986.00000 |**********************            1987.91520
#                 21   1989.00000 |********************************  1990.91162
#                 16   1992.00000 |************************          1993.94400
#                  6   1995.00000 |*********                         1996.95200
#                  7   1998.00000 |**********                        1999.20114
#
#                 10        > 95% |***************                   2013.48960
#
#        mean of 95%   1963.04153
#          95th %ile   2000.92000
 
# bin/writev -E -C 200 -L -S -W -N writev_u1k -s 1k -B 100 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_u1k     1   1     51.87629          194        0      100     1024   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     50.25837                50.25837
#                    max     60.07853                54.14701
#                   mean     52.14747                51.95754
#                 median     51.89677                51.87629
#                 stddev      1.27280                 0.78964
#         standard error      0.08955                 0.05669
#   99% confidence level      0.20830                 0.13187
#                   skew      2.89255                 0.47779
#               kurtosis     13.32459                 0.09379
#       time correlation      0.00109                 0.00074
#
#           elasped time      1.05932
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 18     50.00000 |******                              50.66257
#                 94     51.00000 |********************************    51.57917
#                 62     52.00000 |*********************               52.39907
#                 10     53.00000 |***                                 53.25869
#
#                 10        > 95% |***                                 53.80653
#
#        mean of 95%     51.85705
#          95th %ile     53.57869
# bin/writev -E -C 200 -L -S -W -N writev_u10k -s 10k -B 10 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_u10k    1   1    247.68370          196        0       10    10240   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    235.57490               235.57490
#                    max    286.77490               259.07570
#                   mean    246.46555               245.49059
#                 median    247.88850               247.68370
#                 stddev      7.75312                 5.36108
#         standard error      0.54551                 0.38293
#   99% confidence level      1.26885                 0.89071
#                   skew      1.94783                -0.42347
#               kurtosis      7.58979                -1.17034
#       time correlation     -0.00726                -0.00129
#
#           elasped time      0.50382
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2    235.00000 |**                                 235.72850
#                 15    236.00000 |*****************                  236.59378
#                 16    237.00000 |******************                 237.53650
#                  2    238.00000 |**                                 238.07090
#                 13    239.00000 |***************                    239.76936
#                 13    240.00000 |***************                    240.45465
#                  3    241.00000 |***                                241.45437
#                  2    242.00000 |**                                 242.78130
#                  3    243.00000 |***                                243.30610
#                  5    244.00000 |*****                              244.53490
#                 10    245.00000 |***********                        245.53330
#                  3    246.00000 |***                                246.48050
#                 18    247.00000 |*********************              247.54859
#                 27    248.00000 |********************************   248.53988
#                 15    249.00000 |*****************                  249.52007
#                 27    250.00000 |********************************   250.68174
#                 12    251.00000 |**************                     251.24850
#
#                 10        > 95% |***********                        252.62194
#
#        mean of 95%    245.10718
#          95th %ile    251.57490
# bin/writev -E -C 200 -L -S -W -N writev_u100k -s 100k -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_u100k   1   1   2136.86700          190        0        1   102400   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   2092.83500              2092.83500
#                    max   7037.98700              2170.65900
#                   mean   2167.91144              2132.86936
#                 median   2137.63500              2136.86700
#                 stddev    349.49119                18.38567
#         standard error     24.59011                 1.33384
#   99% confidence level     57.19661                 3.10250
#                   skew     13.41515                -0.35265
#               kurtosis    183.68097                -0.80778
#       time correlation     -0.64991                 0.01927
#
#           elasped time      0.44420
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3   2091.00000 |****                              2093.51767
#                  0   2094.00000 |                                           -
#                  3   2097.00000 |****                              2099.40567
#                  8   2100.00000 |************                      2101.89100
#                 13   2103.00000 |********************              2104.53223
#                  3   2106.00000 |****                              2108.10967
#                  7   2109.00000 |***********                       2110.90129
#                  8   2112.00000 |************                      2113.25100
#                  3   2115.00000 |****                              2117.06967
#                  4   2118.00000 |******                            2120.03500
#                  6   2121.00000 |*********                         2122.78700
#                  3   2124.00000 |****                              2124.83500
#                  9   2127.00000 |**************                    2128.61811
#                  8   2130.00000 |************                      2132.03500
#                 17   2133.00000 |***************************       2135.25571
#                 10   2136.00000 |****************                  2137.58380
#                 16   2139.00000 |*************************         2140.61100
#                 20   2142.00000 |********************************  2143.56140
#                 11   2145.00000 |*****************                 2146.31573
#                  7   2148.00000 |***********                       2150.06929
#                 15   2151.00000 |************************          2152.46593
#                  5   2154.00000 |********                          2156.16940
#                  1   2157.00000 |*                                 2159.90700
#
#                 10        > 95% |****************                  2164.54060
#
#        mean of 95%   2131.10984
#          95th %ile   2160.67500
 
# bin/writev -E -C 200 -L -S -W -N writev_n1k -s 1k -I 100 -B 0 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_n1k     1   1      3.72279          192        0     1000     1024   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      3.57175                 3.57175
#                    max      4.30288                 3.98672
#                   mean      3.75839                 3.74018
#                 median      3.72893                 3.72279
#                 stddev      0.11849                 0.08704
#         standard error      0.00834                 0.00628
#   99% confidence level      0.01939                 0.01461
#                   skew      1.59651                 0.69580
#               kurtosis      3.48268                 0.07737
#       time correlation     -0.00007                -0.00007
#
#           elasped time      0.76386
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                182      3.00000 |********************************     3.72871
#
#                 10        > 95% |*                                    3.94894
#
#        mean of 95%      3.72871
#          95th %ile      3.90275
# bin/writev -E -C 200 -L -S -W -N writev_n10k -s 10k -I 100 -B 0 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_n10k    1   1      3.77195          199        0     1000    10240   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      3.58481                 3.58481
#                    max      4.21483                 4.10782
#                   mean      3.79839                 3.79276
#                 median      3.77374                 3.77195
#                 stddev      0.11408                 0.10513
#         standard error      0.00803                 0.00745
#   99% confidence level      0.01867                 0.01733
#                   skew      1.07375                 0.86017
#               kurtosis      1.24034                 0.61175
#       time correlation     -0.00023                -0.00030
#
#           elasped time      0.77191
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                189      3.00000 |********************************     3.77843
#
#                 10        > 95% |*                                    4.06368
#
#        mean of 95%      3.77843
#          95th %ile      3.99672
# bin/writev -E -C 200 -L -S -W -N writev_n100k -s 100k -I 100 -B 0 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size  vec
writev_n100k   1   1      3.77195          195        0     1000   102400   10
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      3.61784                 3.61784
#                    max      8.42680                 4.12779
#                   mean      3.82490                 3.78463
#                 median      3.77988                 3.77195
#                 stddev      0.36145                 0.11920
#         standard error      0.02543                 0.00854
#   99% confidence level      0.05915                 0.01985
#                   skew     10.36359                 1.00695
#               kurtosis    127.43085                 0.53003
#       time correlation      0.00020                 0.00006
#
#           elasped time      0.77765
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                180      3.00000 |********************************     3.76073
#                  5      4.00000 |*                                    4.02559
#
#                 10        > 95% |*                                    4.09435
#
#        mean of 95%      3.76789
#          95th %ile      4.05176
 
# bin/pread -E -C 200 -L -S -W -N pread_t1k -s 1k -I 150 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_t1k      1   1      4.02688          180        0      666     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      3.94539                 3.94539
#                    max     22.25208                 4.34207
#                   mean      4.74988                 4.06901
#                 median      4.03572                 4.02688
#                 stddev      2.64965                 0.11147
#         standard error      0.18643                 0.00831
#   99% confidence level      0.43363                 0.01932
#                   skew      4.33757                 1.28544
#               kurtosis     19.50618                 0.35998
#       time correlation      0.01503                 0.00036
#
#           elasped time      0.64306
#      number of samples          180
#     number of outliers           22
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 45      3.00000 |***********                          3.97101
#                126      4.00000 |********************************     4.08488
#
#                  9        > 95% |**                                   4.33682
#
#        mean of 95%      4.05491
#          95th %ile      4.33131
# bin/pread -E -C 200 -L -S -W -N pread_t10k -s 10k -I 500 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_t10k     1   1     13.21876          195        0      200    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     12.59924                12.59924
#                    max     15.50356                13.79860
#                   mean     13.26725                13.20410
#                 median     13.22388                13.21876
#                 stddev      0.39876                 0.21285
#         standard error      0.02806                 0.01524
#   99% confidence level      0.06526                 0.03545
#                   skew      3.11178                -0.09602
#               kurtosis     12.84610                 0.24537
#       time correlation      0.00094                 0.00110
#
#           elasped time      0.53995
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 30     12.00000 |******                              12.85946
#                155     13.00000 |********************************    13.24139
#
#                 10        > 95% |**                                  13.66010
#
#        mean of 95%     13.17945
#          95th %ile     13.56308
# bin/pread -E -C 200 -L -S -W -N pread_t100k -s 100k -I 5000 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_t100k    1   1    167.43900          189        0       20   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    164.20060               164.20060
#                    max    213.08380               169.48700
#                   mean    168.06329               167.09638
#                 median    167.43900               167.43900
#                 stddev      4.72189                 1.03108
#         standard error      0.33223                 0.07500
#   99% confidence level      0.77277                 0.17445
#                   skew      5.85121                -1.43277
#               kurtosis     43.73433                 0.92961
#       time correlation     -0.00654                 0.00155
#
#           elasped time      0.68318
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 22    164.00000 |****                               164.78940
#                  9    165.00000 |**                                 165.16060
#                  6    166.00000 |*                                  166.86727
#                141    167.00000 |********************************   167.49692
#                  1    168.00000 |*                                  168.00220
#
#                 10        > 95% |**                                 168.31324
#
#        mean of 95%    167.02840
#          95th %ile    168.04060
 
# bin/pread -E -C 200 -L -S -W -N pread_u1k -s 1k -I 150 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_u1k      1   1      5.28649          183        0      666     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      5.18732                 5.22806
#                    max      5.85269                 5.35107
#                   mean      5.31410                 5.28733
#                 median      5.28764                 5.28649
#                 stddev      0.10689                 0.02284
#         standard error      0.00752                 0.00169
#   99% confidence level      0.01749                 0.00393
#                   skew      3.77547                -0.36316
#               kurtosis     14.14639                 0.72170
#       time correlation     -0.00008                -0.00011
#
#           elasped time      0.71902
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                173      5.00000 |********************************     5.28468
#
#                 10        > 95% |*                                    5.33312
#
#        mean of 95%      5.28468
#          95th %ile      5.32377
# bin/pread -E -C 200 -L -S -W -N pread_u10k -s 10k -I 500 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_u10k     1   1     14.61402          190        0      200    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     13.73850                13.93946
#                    max     18.92890                15.24890
#                   mean     14.65810                14.57925
#                 median     14.61914                14.61402
#                 stddev      0.51145                 0.25932
#         standard error      0.03599                 0.01881
#   99% confidence level      0.08370                 0.04376
#                   skew      3.80634                -0.05371
#               kurtosis     24.91619                -0.09988
#       time correlation     -0.00062                 0.00015
#
#           elasped time      0.59629
#      number of samples          190
#     number of outliers           12
#      getnsecs overhead          204
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     13.00000 |*                                   13.94906
#                177     14.00000 |********************************    14.55388
#                  1     15.00000 |*                                   15.00442
#
#                 10        > 95% |*                                   15.11181
#
#        mean of 95%     14.54966
#          95th %ile     15.01850
# bin/pread -E -C 200 -L -S -W -N pread_u100k -s 100k -I 5000 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_u100k    1   1    164.99390          187        0       20   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    162.13950               162.13950
#                    max    207.13150               167.14430
#                   mean    165.63403               164.61065
#                 median    164.99390               164.99390
#                 stddev      4.60869                 0.98770
#         standard error      0.32427                 0.07223
#   99% confidence level      0.75424                 0.16800
#                   skew      5.30053                -1.44000
#               kurtosis     35.72656                 0.86241
#       time correlation     -0.00954                -0.00088
#
#           elasped time      0.67358
#      number of samples          187
#     number of outliers           15
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 31    162.00000 |************                       162.52144
#                  2    163.00000 |*                                  163.16350
#                 78    164.00000 |********************************   164.88182
#                 66    165.00000 |***************************        165.15332
#
#                 10        > 95% |****                               165.67998
#
#        mean of 95%    164.55024
#          95th %ile    165.33950
 
# bin/pread -E -C 200 -L -S -W -N pread_z1k -s 1k -I 150 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_z1k      1   1      2.35096          196        0      666     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      2.17991                 2.17991
#                    max      2.95483                 2.70383
#                   mean      2.37948                 2.36622
#                 median      2.35135                 2.35096
#                 stddev      0.13854                 0.11697
#         standard error      0.00975                 0.00835
#   99% confidence level      0.02267                 0.01943
#                   skew      1.28255                 0.84911
#               kurtosis      1.57823                -0.21406
#       time correlation      0.00081                 0.00070
#
#           elasped time      0.32382
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                186      2.00000 |********************************     2.35220
#
#                 10        > 95% |*                                    2.62703
#
#        mean of 95%      2.35220
#          95th %ile      2.61234
# bin/pread -E -C 200 -L -S -W -N pread_z10k -s 10k -I 500 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_z10k     1   1      6.27858          193        0      200    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      6.16338                 6.16338
#                    max      8.17426                 6.62290
#                   mean      6.36711                 6.32255
#                 median      6.27858                 6.27858
#                 stddev      0.26216                 0.10347
#         standard error      0.01845                 0.00745
#   99% confidence level      0.04290                 0.01732
#                   skew      4.83077                 0.58457
#               kurtosis     28.20491                -0.52314
#       time correlation     -0.00046                -0.00003
#
#           elasped time      0.26120
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                183      6.00000 |********************************     6.31027
#
#                 10        > 95% |*                                    6.54712
#
#        mean of 95%      6.31027
#          95th %ile      6.51281
# bin/pread -E -C 200 -L -S -W -N pread_z100k -s 100k -I 2000 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_z100k    1   1     63.11510          189        0       50   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     62.29590                62.29590
#                    max     84.31702                63.81654
#                   mean     63.37711                63.03846
#                 median     63.13558                63.11510
#                 stddev      1.85955                 0.27164
#         standard error      0.13084                 0.01976
#   99% confidence level      0.30433                 0.04596
#                   skew      8.01857                -0.77158
#               kurtosis     79.66621                 0.42605
#       time correlation     -0.00269                 0.00006
#
#           elasped time      0.64412
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 58     62.00000 |***************                     62.69632
#                121     63.00000 |********************************    63.16380
#
#                 10        > 95% |**                                  63.50627
#
#        mean of 95%     63.01233
#          95th %ile     63.31478
# bin/pread -E -C 200 -L -S -W -N pread_zw100k -s 100k -w -I 2500 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size
pread_zw100k   1   1     67.79625          187        0       40   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     66.81705                66.81705
#                    max     87.16905                68.37225
#                   mean     68.08770                67.64275
#                 median     67.81545                67.79625
#                 stddev      2.09340                 0.37002
#         standard error      0.14729                 0.02706
#   99% confidence level      0.34260                 0.06294
#                   skew      5.73245                -0.51357
#               kurtosis     39.55843                -1.04295
#       time correlation     -0.00360                 0.00012
#
#           elasped time      0.55430
#      number of samples          187
#     number of outliers           15
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  9     66.00000 |*                                   66.91874
#                159     67.00000 |********************************    67.62659
#                  9     68.00000 |*                                   68.03589
#
#                 10        > 95% |**                                  68.19753
#
#        mean of 95%     67.61141
#          95th %ile     68.12265
 
# bin/pwrite -E -C 200 -L -S -W -N pwrite_t1k -s 1k -I 500 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_t1k     1   1      9.07791          198        0      200     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      8.28431                 8.28431
#                    max     11.19375                 9.97903
#                   mean      9.13516                 9.10112
#                 median      9.08815                 9.07791
#                 stddev      0.40958                 0.33262
#         standard error      0.02882                 0.02364
#   99% confidence level      0.06703                 0.05498
#                   skew      1.45898                 0.22696
#               kurtosis      4.93333                -0.02043
#       time correlation     -0.00322                -0.00336
#
#           elasped time      0.37290
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 83      8.00000 |*************************            8.80050
#                105      9.00000 |********************************     9.26823
#
#                 10        > 95% |***                                  9.84169
#
#        mean of 95%      9.06173
#          95th %ile      9.66799
# bin/pwrite -E -C 200 -L -S -W -N pwrite_t10k -s 10k -I 1000 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_t10k    1   1     19.62784          194        0      100    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     18.85984                18.85984
#                    max     23.90816                20.83616
#                   mean     19.77761                19.66218
#                 median     19.63808                19.62784
#                 stddev      0.73356                 0.41149
#         standard error      0.05161                 0.02954
#   99% confidence level      0.12005                 0.06872
#                   skew      3.15756                 0.29610
#               kurtosis     13.83186                -0.26749
#       time correlation     -0.00181                -0.00077
#
#           elasped time      0.40360
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  5     18.00000 |*                                   18.92230
#                144     19.00000 |********************************    19.51260
#                 35     20.00000 |*******                             20.12148
#
#                 10        > 95% |**                                  20.57837
#
#        mean of 95%     19.61238
#          95th %ile     20.41888
# bin/pwrite -E -C 200 -L -S -W -N pwrite_t100k -s 100k -I 10000 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_t100k   1   1    192.87380          193        0       10   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    190.97940               190.97940
#                    max    262.99220               202.26900
#                   mean    196.17151               194.73544
#                 median    196.58580               192.87380
#                 stddev      8.35482                 2.91971
#         standard error      0.58784                 0.21017
#   99% confidence level      1.36732                 0.48884
#                   skew      5.11472                 0.16936
#               kurtosis     31.49946                -1.59570
#       time correlation     -0.01189                 0.00024
#
#           elasped time      0.40048
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    190.00000 |*                                  190.97940
#                 52    191.00000 |*************************          191.64549
#                 45    192.00000 |*********************              192.32596
#                  0    193.00000 |                                           -
#                  0    194.00000 |                                           -
#                  1    195.00000 |*                                  195.28020
#                 13    196.00000 |******                             196.78863
#                 66    197.00000 |********************************   197.48490
#                  5    198.00000 |**                                 198.13204
#
#                 10        > 95% |****                               199.45300
#
#        mean of 95%    194.47765
#          95th %ile    198.19860
 
# bin/pwrite -E -C 200 -L -S -W -N pwrite_u1k -s 1k -I 500 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_u1k     1   1      9.81903          194        0      200     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      9.16367                 9.16367
#                    max     18.87888                10.78416
#                   mean      9.94950                 9.82887
#                 median      9.84335                 9.81903
#                 stddev      0.83822                 0.35644
#         standard error      0.05898                 0.02559
#   99% confidence level      0.13718                 0.05952
#                   skew      6.69129                 0.30706
#               kurtosis     63.47037                -0.40995
#       time correlation     -0.00003                 0.00072
#
#           elasped time      0.40596
#      number of samples          194
#     number of outliers            8
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                139      9.00000 |********************************     9.65378
#                 45     10.00000 |**********                          10.19646
#
#                 10        > 95% |**                                  10.60841
#
#        mean of 95%      9.78650
#          95th %ile     10.46415
# bin/pwrite -E -C 200 -L -S -W -N pwrite_u10k -s 10k -I 1000 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_u10k    1   1     21.28674          196        0      100    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     19.65602                19.65602
#                    max     29.98818                23.18626
#                   mean     21.35682                21.22597
#                 median     21.35842                21.28674
#                 stddev      1.06728                 0.68035
#         standard error      0.07509                 0.04860
#   99% confidence level      0.17467                 0.11303
#                   skew      3.39393                 0.02608
#               kurtosis     21.80905                -0.71066
#       time correlation     -0.00267                -0.00200
#
#           elasped time      0.43558
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3     19.00000 |*                                   19.78402
#                 79     20.00000 |****************************        20.57668
#                 88     21.00000 |********************************    21.54611
#                 16     22.00000 |*****                               22.13042
#
#                 10        > 95% |***                                 22.52348
#
#        mean of 95%     21.15621
#          95th %ile     22.29794
# bin/pwrite -E -C 200 -L -S -W -N pwrite_u100k -s 100k -I 10000 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_u100k   1   1    220.88020          196        0       10   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    211.48500               211.48500
#                    max    274.89620               235.77940
#                   mean    221.16471               219.95599
#                 median    222.08340               220.88020
#                 stddev      8.80789                 5.39425
#         standard error      0.61972                 0.38530
#   99% confidence level      1.44147                 0.89622
#                   skew      2.76022                -0.09387
#               kurtosis     11.77794                -1.30022
#       time correlation     -0.00691                 0.00335
#
#           elasped time      0.45125
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  8    211.00000 |********                           211.77940
#                 25    212.00000 |***************************        212.42503
#                  2    213.00000 |**                                 213.07220
#                 15    214.00000 |****************                   214.75327
#                 21    215.00000 |***********************            215.38230
#                  4    216.00000 |****                               216.42580
#                  8    217.00000 |********                           217.74420
#                  4    218.00000 |****                               218.24340
#                  7    219.00000 |*******                            219.42100
#                  5    220.00000 |*****                              220.47060
#                  1    221.00000 |*                                  221.18740
#                  7    222.00000 |*******                            222.65026
#                 18    223.00000 |*******************                223.48856
#                 25    224.00000 |***************************        224.52257
#                 29    225.00000 |********************************   225.45024
#                  7    226.00000 |*******                            226.27449
#
#                 10        > 95% |***********                        227.95348
#
#        mean of 95%    219.52602
#          95th %ile    226.48660
 
# bin/pwrite -E -C 200 -L -S -W -N pwrite_n1k -s 1k -I 100 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_n1k     1   1      1.42596          143        0     1000     1024
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.93162                 1.39498
#                    max      1.71882                 1.46180
#                   mean      1.37642                 1.43262
#                 median      1.42570                 1.42596
#                 stddev      0.13533                 0.01262
#         standard error      0.00952                 0.00106
#   99% confidence level      0.02215                 0.00245
#                   skew     -2.03209                 0.17789
#               kurtosis      3.92678                 0.09664
#       time correlation      0.00056                 0.00003
#
#           elasped time      0.28174
#      number of samples          143
#     number of outliers           59
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                135      1.00000 |********************************     1.43118
#
#                  8        > 95% |*                                    1.45687
#
#        mean of 95%      1.43118
#          95th %ile      1.45182
# bin/pwrite -E -C 200 -L -S -W -N pwrite_n10k -s 10k -I 100 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_n10k    1   1      1.42571          168        0     1000    10240
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.92676                 1.33790
#                    max      1.61361                 1.48484
#                   mean      1.37856                 1.41661
#                 median      1.42468                 1.42571
#                 stddev      0.11510                 0.02727
#         standard error      0.00810                 0.00210
#   99% confidence level      0.01884                 0.00489
#                   skew     -2.44706                -1.07627
#               kurtosis      6.14367                 0.98597
#       time correlation      0.00020                -0.00002
#
#           elasped time      0.28228
#      number of samples          168
#     number of outliers           34
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                159      1.00000 |********************************     1.41422
#
#                  9        > 95% |*                                    1.45888
#
#        mean of 95%      1.41422
#          95th %ile      1.44901
# bin/pwrite -E -C 200 -L -S -W -N pwrite_n100k -s 100k -I 100 -f /dev/null 
             prc thr   usecs/call      samples   errors cnt/samp     size
pwrite_n100k   1   1      1.42698          164        0     1000   102400
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      0.95389                 1.38397
#                    max      1.72573                 1.48586
#                   mean      1.39588                 1.43519
#                 median      1.42596                 1.42698
#                 stddev      0.12222                 0.01752
#         standard error      0.00860                 0.00137
#   99% confidence level      0.02000                 0.00318
#                   skew     -2.18000                 0.43814
#               kurtosis      4.95299                 0.94612
#       time correlation     -0.00012                 0.00002
#
#           elasped time      0.28566
#      number of samples          164
#     number of outliers           38
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                155      1.00000 |********************************     1.43282
#
#                  9        > 95% |*                                    1.47599
#
#        mean of 95%      1.43282
#          95th %ile      1.47076
 
# bin/mmap -E -C 200 -L -S -W -N mmap_z8k -l 8k -I 300 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_z8k       1   1     37.02326          197        0      333     8192  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     35.35964                36.07767
#                    max     40.42583                38.56694
#                   mean     37.10353                37.06831
#                 median     37.02633                37.02326
#                 stddev      0.60581                 0.50396
#         standard error      0.04262                 0.03591
#   99% confidence level      0.09915                 0.08352
#                   skew      1.37149                 0.70998
#               kurtosis      4.49011                 0.34836
#       time correlation     -0.00070                -0.00055
#
#           elasped time      5.12215
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 93     36.00000 |********************************    36.66016
#                 93     37.00000 |********************************    37.33039
#                  1     38.00000 |*                                   38.00497
#
#                 10        > 95% |***                                 38.33308
#
#        mean of 95%     37.00067
#          95th %ile     38.09569
# bin/mmap -E -C 200 -L -S -W -N mmap_z128k -l 128k -I 300 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_z128k     1   1     35.57565          196        0      333   131072  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     34.06810                34.06810
#                    max     46.78046                37.15855
#                   mean     35.69338                35.58441
#                 median     35.59026                35.57565
#                 stddev      1.02942                 0.58081
#         standard error      0.07243                 0.04149
#   99% confidence level      0.16847                 0.09650
#                   skew      6.33050                 0.12532
#               kurtosis     64.43998                 0.18037
#       time correlation      0.00264                 0.00173
#
#           elasped time      4.97252
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 29     34.00000 |*******                             34.65753
#                127     35.00000 |********************************    35.54071
#                 30     36.00000 |*******                             36.22967
#
#                 10        > 95% |**                                  36.89156
#
#        mean of 95%     35.51413
#          95th %ile     36.71728
# bin/mmap -E -C 200 -L -S -W -N mmap_t8k -l 8k -I 300 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_t8k       1   1     37.98111          200        0      333     8192  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     36.44050                36.44050
#                    max     44.08975                40.04449
#                   mean     38.05660                38.01483
#                 median     37.98188                37.98111
#                 stddev      0.83635                 0.70340
#         standard error      0.05885                 0.04974
#   99% confidence level      0.13687                 0.11569
#                   skew      2.05970                 0.33975
#               kurtosis     12.20743                 0.10454
#       time correlation      0.00198                 0.00136
#
#           elasped time      5.16822
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 14     36.00000 |****                                36.73472
#                 91     37.00000 |********************************    37.61864
#                 73     38.00000 |*************************           38.35643
#                 12     39.00000 |****                                39.09102
#
#                 10        > 95% |***                                 39.62720
#
#        mean of 95%     37.92997
#          95th %ile     39.28187
# bin/mmap -E -C 200 -L -S -W -N mmap_t128k -l 128k -I 300 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_t128k     1   1     37.56676          199        0      333   131072  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     35.87624                35.87624
#                    max     41.27607                39.13120
#                   mean     37.63497                37.58914
#                 median     37.58444                37.56676
#                 stddev      0.74439                 0.64398
#         standard error      0.05238                 0.04565
#   99% confidence level      0.12183                 0.10618
#                   skew      1.15942                 0.25890
#               kurtosis      3.68089                -0.04298
#       time correlation      0.00098                 0.00133
#
#           elasped time      5.08804
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     35.00000 |*                                   35.90929
#                 31     36.00000 |********                            36.70413
#                122     37.00000 |********************************    37.50934
#                 34     38.00000 |********                            38.36874
#
#                 10        > 95% |**                                  38.99144
#
#        mean of 95%     37.51494
#          95th %ile     38.76143
# bin/mmap -E -C 200 -L -S -W -N mmap_u8k -l 8k -I 300 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_u8k       1   1     39.30880          197        0      333     8192  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     37.73513                38.03802
#                    max     41.40216                40.89708
#                   mean     39.39989                39.37092
#                 median     39.33801                39.30880
#                 stddev      0.58923                 0.52111
#         standard error      0.04146                 0.03713
#   99% confidence level      0.09643                 0.08636
#                   skew      0.71975                 0.49257
#               kurtosis      1.27073                 0.48835
#       time correlation      0.00057                 0.00056
#
#           elasped time      5.37816
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 39     38.00000 |*********                           38.72684
#                133     39.00000 |********************************    39.37172
#                 15     40.00000 |***                                 40.21497
#
#                 10        > 95% |**                                  40.60617
#
#        mean of 95%     39.30486
#          95th %ile     40.44965
# bin/mmap -E -C 200 -L -S -W -N mmap_u128k -l 128k -I 300 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_u128k     1   1     38.31177          197        0      333   131072  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     37.30007                37.30007
#                    max     49.49813                39.98154
#                   mean     38.47994                38.37476
#                 median     38.32100                38.31177
#                 stddev      1.02209                 0.56286
#         standard error      0.07191                 0.04010
#   99% confidence level      0.16727                 0.09328
#                   skew      6.52223                 0.73708
#               kurtosis     64.88893                 0.29784
#       time correlation     -0.00136                -0.00131
#
#           elasped time      5.13752
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          196
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 52     37.00000 |*************                       37.76299
#                119     38.00000 |********************************    38.41188
#                 16     39.00000 |****                                39.19807
#
#                 10        > 95% |**                                  39.79696
#
#        mean of 95%     38.29871
#          95th %ile     39.56102
# bin/mmap -E -C 200 -L -S -W -N mmap_a8k -l 8k -I 200 -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_a8k       1   1     20.04591          200        0      500     8192  a---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     19.65986                19.65986
#                    max     21.53532                21.26754
#                   mean     20.22104                20.20866
#                 median     20.04744                20.04591
#                 stddev      0.39753                 0.37946
#         standard error      0.02797                 0.02683
#   99% confidence level      0.06506                 0.06241
#                   skew      1.06456                 0.98211
#               kurtosis      0.02805                -0.35461
#       time correlation     -0.00023                -0.00010
#
#           elasped time      7.96910
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 77     19.00000 |*********************               19.90683
#                113     20.00000 |********************************    20.33937
#
#                 10        > 95% |**                                  21.05567
#
#        mean of 95%     20.16408
#          95th %ile     20.91784
# bin/mmap -E -C 200 -L -S -W -N mmap_a128k -l 128k -I 200 -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_a128k     1   1     20.77347          182        0      500   131072  a---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     20.34749                20.34749
#                    max     24.01187                21.30134
#                   mean     20.89258                20.79779
#                 median     20.78576                20.77347
#                 stddev      0.37203                 0.16804
#         standard error      0.02618                 0.01246
#   99% confidence level      0.06089                 0.02897
#                   skew      3.76931                 0.67379
#               kurtosis     24.03297                 0.77631
#       time correlation     -0.00046                -0.00059
#
#           elasped time      8.12900
#      number of samples          182
#     number of outliers           20
#      getnsecs overhead          209
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                159     20.00000 |********************************    20.75248
#                 13     21.00000 |**                                  21.02699
#
#                 10        > 95% |**                                  21.22019
#
#        mean of 95%     20.77323
#          95th %ile     21.10985
 
# bin/mmap -E -C 200 -L -S -W -N mmap_rz8k -l 8k -I 1000 -r -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_rz8k      1   1     70.65887          193        0      100     8192  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     69.63743                69.63743
#                    max     75.04927                71.86975
#                   mean     70.86779                70.73188
#                 median     70.68703                70.65887
#                 stddev      0.77234                 0.39609
#         standard error      0.05434                 0.02851
#   99% confidence level      0.12640                 0.06632
#                   skew      3.14578                 0.23745
#               kurtosis     12.50793                -0.27175
#       time correlation     -0.00025                -0.00017
#
#           elasped time      2.58975
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  4     69.00000 |*                                   69.84863
#                130     70.00000 |********************************    70.54292
#                 49     71.00000 |************                        71.13712
#
#                 10        > 95% |**                                  71.55589
#
#        mean of 95%     70.68685
#          95th %ile     71.32703
# bin/mmap -E -C 200 -L -S -W -N mmap_rz128k -l 128k -I 1000 -r -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_rz128k    1   1    375.84935          199        0      100   131072  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    369.57735               369.57735
#                    max    748.35751               383.36807
#                   mean    379.86190               376.17266
#                 median    375.96967               375.84935
#                 stddev     36.48033                 2.54823
#         standard error      2.56675                 0.18064
#   99% confidence level      5.97025                 0.42017
#                   skew      9.75004                 0.32772
#               kurtosis     94.07964                -0.27831
#       time correlation     -0.08838                -0.00335
#
#           elasped time      8.92697
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    369.00000 |*                                  369.57735
#                  0    370.00000 |                                           -
#                  6    371.00000 |******                             371.59591
#                 10    372.00000 |**********                         372.44609
#                 22    373.00000 |**********************             373.54023
#                 31    374.00000 |*******************************    374.49841
#                 32    375.00000 |********************************   375.42863
#                 28    376.00000 |****************************       376.54850
#                 25    377.00000 |*************************          377.50168
#                 12    378.00000 |************                       378.41490
#                 13    379.00000 |*************                      379.43808
#                  9    380.00000 |*********                          380.32366
#
#                 10        > 95% |**********                         381.62061
#
#        mean of 95%    375.88440
#          95th %ile    380.68775
# bin/mmap -E -C 200 -L -S -W -N mmap_rt8k -l 8k -I 1000 -r -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_rt8k      1   1     76.48805          185        0      100     8192  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     75.26693                75.63813
#                    max     80.35877                77.49669
#                   mean     76.70455                76.46857
#                 median     76.51877                76.48805
#                 stddev      0.93364                 0.37920
#         standard error      0.06569                 0.02788
#   99% confidence level      0.15280                 0.06485
#                   skew      2.46775                 0.12697
#               kurtosis      6.12492                -0.16707
#       time correlation     -0.00017                -0.00027
#
#           elasped time      2.81302
#      number of samples          185
#     number of outliers           17
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 24     75.00000 |*****                               75.85637
#                148     76.00000 |********************************    76.50016
#                  3     77.00000 |*                                   77.07429
#
#                 10        > 95% |**                                  77.28856
#
#        mean of 95%     76.42171
#          95th %ile     77.13829
# bin/mmap -E -C 200 -L -S -W -N mmap_rt128k -l 128k -I 10000 -r -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_rt128k    1   1    229.45600          195        0       10   131072  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    222.46720               222.46720
#                    max    267.67680               237.77600
#                   mean    230.23072               229.27483
#                 median    229.68640               229.45600
#                 stddev      6.18911                 3.28072
#         standard error      0.43546                 0.23494
#   99% confidence level      1.01289                 0.54646
#                   skew      3.36643                -0.25897
#               kurtosis     15.77630                -0.94562
#       time correlation     -0.00574                -0.00032
#
#           elasped time      0.63912
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3    222.00000 |**                                 222.74880
#                 19    223.00000 |**************                     223.56126
#                  3    224.00000 |**                                 224.59200
#                  1    225.00000 |*                                  225.97440
#                 33    226.00000 |************************           226.64078
#                 22    227.00000 |****************                   227.48364
#                  9    228.00000 |******                             228.61404
#                 17    229.00000 |************                       229.51021
#                 10    230.00000 |*******                            230.80000
#                 19    231.00000 |**************                     231.53229
#                 43    232.00000 |********************************   232.60301
#                  6    233.00000 |****                               233.14667
#
#                 10        > 95% |*******                            234.20224
#
#        mean of 95%    229.00848
#          95th %ile    233.27040
# bin/mmap -E -C 200 -L -S -W -N mmap_ru8k -l 8k -I 1000 -r -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_ru8k      1   1     74.16870          181        0      100     8192  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     73.17542                73.17542
#                    max     78.53862                75.26694
#                   mean     74.57171                74.23830
#                 median     74.24806                74.16870
#                 stddev      1.10087                 0.44135
#         standard error      0.07746                 0.03280
#   99% confidence level      0.18016                 0.07630
#                   skew      2.14684                 0.15900
#               kurtosis      4.18190                -0.62520
#       time correlation     -0.00058                -0.00128
#
#           elasped time      2.76712
#      number of samples          181
#     number of outliers           21
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 59     73.00000 |****************                    73.76101
#                112     74.00000 |********************************    74.41309
#
#                 10        > 95% |**                                  75.09670
#
#        mean of 95%     74.18810
#          95th %ile     74.96742
# bin/mmap -E -C 200 -L -S -W -N mmap_ru128k -l 128k -I 10000 -r -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_ru128k    1   1    241.38460          198        0       10   131072  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    235.18940               235.18940
#                    max    272.97500               250.16540
#                   mean    241.31616               240.84338
#                 median    241.46140               241.38460
#                 stddev      4.72186                 3.25295
#         standard error      0.33223                 0.23118
#   99% confidence level      0.77276                 0.53772
#                   skew      2.83614                 0.08952
#               kurtosis     14.96807                -0.41245
#       time correlation     -0.00253                -0.00214
#
#           elasped time      0.67103
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          234
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 19    235.00000 |*******************                235.73913
#                 18    236.00000 |******************                 236.25607
#                  1    237.00000 |*                                  237.97980
#                 31    238.00000 |********************************   238.64045
#                 13    239.00000 |*************                      239.49611
#                  8    240.00000 |********                           240.69020
#                 30    241.00000 |******************************     241.54076
#                 20    242.00000 |********************               242.38428
#                 24    243.00000 |************************           243.65020
#                 24    244.00000 |************************           244.48647
#
#                 10        > 95% |**********                         247.13436
#
#        mean of 95%    240.50875
#          95th %ile    245.07100
# bin/mmap -E -C 200 -L -S -W -N mmap_ra8k -l 8k -I 500 -r -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_ra8k      1   1     61.93940          198        0      200     8192  ar--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     60.88852                60.88852
#                    max     67.10292                64.19348
#                   mean     62.14506                62.07887
#                 median     61.94324                61.93940
#                 stddev      0.86170                 0.71348
#         standard error      0.06063                 0.05071
#   99% confidence level      0.14102                 0.11794
#                   skew      1.94383                 1.07403
#               kurtosis      6.07430                 0.72583
#       time correlation     -0.00042                 0.00047
#
#           elasped time      6.07399
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     60.00000 |*                                   60.93908
#                108     61.00000 |********************************    61.61014
#                 62     62.00000 |******************                  62.31097
#                 16     63.00000 |****                                63.32452
#
#                 10        > 95% |**                                  63.93710
#
#        mean of 95%     61.98003
#          95th %ile     63.66484
# bin/mmap -E -C 200 -L -S -W -N mmap_ra128k -l 128k -I 5000 -r -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_ra128k    1   1    364.68750          183        0       20   131072  ar--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    358.14670               360.29710
#                    max    389.58350               370.33230
#                   mean    366.00184               364.66833
#                 median    364.84110               364.68750
#                 stddev      5.46057                 1.94076
#         standard error      0.38420                 0.14347
#   99% confidence level      0.89366                 0.33370
#                   skew      2.61293                 0.37652
#               kurtosis      6.81948                 0.28957
#       time correlation     -0.00483                -0.00606
#
#           elasped time      1.86070
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          202
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3    360.00000 |**                                 360.67257
#                 12    361.00000 |*********                          361.47790
#                 21    362.00000 |****************                   362.51577
#                 30    363.00000 |***********************            363.53849
#                 40    364.00000 |*******************************    364.56942
#                 41    365.00000 |********************************   365.44051
#                 18    366.00000 |**************                     366.45461
#                  6    367.00000 |****                               367.49283
#                  2    368.00000 |*                                  368.06670
#
#                 10        > 95% |*******                            369.24558
#
#        mean of 95%    364.40375
#          95th %ile    368.43790
 
# bin/mmap -E -C 200 -L -S -W -N mmap_wz8k -l 8k -I 1250 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wz8k      1   1    111.61006          171        0       80     8192  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    110.62126               110.62126
#                    max    121.93646               113.33486
#                   mean    112.35954               111.72448
#                 median    111.76046               111.61006
#                 stddev      1.71997                 0.59384
#         standard error      0.12102                 0.04541
#   99% confidence level      0.28149                 0.10563
#                   skew      2.20998                 0.59917
#               kurtosis      5.57776                -0.41393
#       time correlation     -0.00055                 0.00043
#
#           elasped time      3.18846
#      number of samples          171
#     number of outliers           31
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 17    110.00000 |*****                              110.90474
#                104    111.00000 |********************************   111.48742
#                 41    112.00000 |************                       112.37666
#
#                  9        > 95% |**                                 113.04117
#
#        mean of 95%    111.65133
#          95th %ile    112.86126
# bin/mmap -E -C 200 -L -S -W -N mmap_wz128k -l 128k -I 25000 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wz128k    1   1    805.45125          188        0        4   131072  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    776.97125               788.68325
#                    max    980.17125               823.94725
#                   mean    808.69022               803.93193
#                 median    805.70725               805.45125
#                 stddev     22.26731                 6.75269
#         standard error      1.56672                 0.49249
#   99% confidence level      3.64420                 1.14553
#                   skew      4.20163                -0.29026
#               kurtosis     21.96301                 0.85230
#       time correlation     -0.01009                -0.00222
#
#           elasped time      0.78478
#      number of samples          188
#     number of outliers           14
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2    788.00000 |**                                 788.81125
#                  2    789.00000 |**                                 789.19525
#                  5    790.00000 |*****                              790.75685
#                  9    791.00000 |**********                         791.61303
#                  5    792.00000 |*****                              792.48485
#                  6    793.00000 |*******                            793.56858
#                  3    794.00000 |***                                794.76325
#                  2    795.00000 |**                                 795.21125
#                  4    796.00000 |****                               796.57125
#                  0    797.00000 |                                           -
#                  1    798.00000 |*                                  798.47525
#                  0    799.00000 |                                           -
#                  0    800.00000 |                                           -
#                  2    801.00000 |**                                 801.57925
#                  8    802.00000 |*********                          802.67525
#                 17    803.00000 |********************               803.70443
#                 19    804.00000 |**********************             804.63946
#                 27    805.00000 |********************************   805.55318
#                 21    806.00000 |************************           806.53011
#                 19    807.00000 |**********************             807.62051
#                 17    808.00000 |********************               808.50443
#                  5    809.00000 |*****                              809.66245
#                  4    810.00000 |****                               810.61925
#
#                 10        > 95% |***********                        817.86725
#
#        mean of 95%    803.14905
#          95th %ile    811.14725
# bin/mmap -E -C 200 -L -S -W -N mmap_wt8k -l 8k -I 1250 -w -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wt8k      1   1    137.09815          193        0       80     8192  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    134.63735               134.63735
#                    max    148.82295               141.76055
#                   mean    137.58190               137.30338
#                 median    137.14615               137.09815
#                 stddev      1.99779                 1.49139
#         standard error      0.14056                 0.10735
#   99% confidence level      0.32695                 0.24970
#                   skew      1.87695                 0.97254
#               kurtosis      5.40879                 0.68606
#       time correlation     -0.00336                -0.00359
#
#           elasped time      3.56309
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3    134.00000 |*                                  134.80588
#                 30    135.00000 |****************                   135.61239
#                 58    136.00000 |********************************   136.46725
#                 53    137.00000 |*****************************      137.43403
#                 28    138.00000 |***************                    138.42284
#                  4    139.00000 |**                                 139.64375
#                  7    140.00000 |***                                140.25792
#
#                 10        > 95% |*****                              141.14391
#
#        mean of 95%    137.09352
#          95th %ile    140.47415
# bin/mmap -E -C 200 -L -S -W -N mmap_wt128k -l 128k -I 25000 -w -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wt128k    1   1   1147.40125          182        0        4   131072  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1137.73725              1137.73725
#                    max   1248.71325              1165.44925
#                   mean   1153.74992              1148.81804
#                 median   1147.97725              1147.40125
#                 stddev     18.58850                 5.64016
#         standard error      1.30788                 0.41808
#   99% confidence level      3.04213                 0.97245
#                   skew      3.48614                 0.93394
#               kurtosis     12.72364                 0.41317
#       time correlation      0.00376                -0.00096
#
#           elasped time      1.07015
#      number of samples          182
#     number of outliers           20
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1137.00000 |*                                 1137.73725
#                  1   1138.00000 |*                                 1138.95325
#                  0   1139.00000 |                                           -
#                  2   1140.00000 |**                                1140.29725
#                  8   1141.00000 |**********                        1141.48125
#                  9   1142.00000 |************                      1142.57281
#                  8   1143.00000 |**********                        1143.46525
#                 15   1144.00000 |********************              1144.55112
#                 17   1145.00000 |**********************            1145.51890
#                 24   1146.00000 |********************************  1146.52125
#                 18   1147.00000 |************************          1147.58969
#                 16   1148.00000 |*********************             1148.40125
#                  6   1149.00000 |********                          1149.58792
#                  5   1150.00000 |******                            1150.49885
#                  9   1151.00000 |************                      1151.44747
#                  5   1152.00000 |******                            1152.70045
#                  6   1153.00000 |********                          1153.45992
#                  5   1154.00000 |******                            1154.44125
#                  4   1155.00000 |*****                             1155.70525
#                  4   1156.00000 |*****                             1156.74525
#                  3   1157.00000 |****                              1157.27858
#                  4   1158.00000 |*****                             1158.56925
#                  1   1159.00000 |*                                 1159.17725
#                  1   1160.00000 |*                                 1160.20125
#
#                 10        > 95% |*************                     1163.04285
#
#        mean of 95%   1147.99102
#          95th %ile   1160.90525
# bin/mmap -E -C 200 -L -S -W -N mmap_wu8k -l 8k -I 1250 -w -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wu8k      1   1    131.15892          181        0       80     8192  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    129.76053               129.76053
#                    max    140.78772               133.31252
#                   mean    131.69833               131.16395
#                 median    131.28373               131.15892
#                 stddev      1.80336                 0.72143
#         standard error      0.12688                 0.05362
#   99% confidence level      0.29513                 0.12473
#                   skew      2.35575                 0.54604
#               kurtosis      5.70003                 0.38654
#       time correlation      0.00255                -0.00199
#
#           elasped time      3.44758
#      number of samples          181
#     number of outliers           21
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  7    129.00000 |**                                 129.84738
#                 74    130.00000 |****************************       130.59733
#                 82    131.00000 |********************************   131.47986
#                  8    132.00000 |***                                132.16693
#
#                 10        > 95% |***                                132.88565
#
#        mean of 95%    131.06326
#          95th %ile    132.38773
# bin/mmap -E -C 200 -L -S -W -N mmap_wu128k -l 128k -I 12500 -w -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wu128k    1   1   1112.70913          175        0        8   131072  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min   1100.86912              1100.86912
#                    max   1289.22113              1130.59713
#                   mean   1120.10952              1113.71557
#                 median   1114.11712              1112.70913
#                 stddev     19.95971                 5.64211
#         standard error      1.40436                 0.42650
#   99% confidence level      3.26654                 0.99205
#                   skew      4.03118                 0.79192
#               kurtosis     25.38812                 0.35046
#       time correlation      0.01422                -0.02108
#
#           elasped time      2.06443
#      number of samples          175
#     number of outliers           27
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1   1100.00000 |**                                1100.86912
#                  0   1101.00000 |                                           -
#                  0   1102.00000 |                                           -
#                  0   1103.00000 |                                           -
#                  1   1104.00000 |**                                1104.61313
#                  3   1105.00000 |******                            1105.80779
#                  9   1106.00000 |******************                1106.73935
#                 14   1107.00000 |****************************      1107.59370
#                 14   1108.00000 |****************************      1108.59712
#                 10   1109.00000 |********************              1109.67873
#                  9   1110.00000 |******************                1110.58290
#                 14   1111.00000 |****************************      1111.49541
#                 16   1112.00000 |********************************  1112.44712
#                  9   1113.00000 |******************                1113.74024
#                 15   1114.00000 |******************************    1114.45206
#                 12   1115.00000 |************************          1115.56246
#                  9   1116.00000 |******************                1116.55624
#                  7   1117.00000 |**************                    1117.33084
#                  3   1118.00000 |******                            1118.51179
#                  1   1119.00000 |**                                1119.33313
#                  5   1120.00000 |**********                        1120.47232
#                  6   1121.00000 |************                      1121.55713
#                  5   1122.00000 |**********                        1122.37313
#                  2   1123.00000 |****                              1123.78112
#                  1   1124.00000 |**                                1124.10112
#
#                  9        > 95% |******************                1127.80601
#
#        mean of 95%   1112.95163
#          95th %ile   1125.22113
# bin/mmap -E -C 200 -L -S -W -N mmap_wa8k -l 8k -I 1500 -w -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wa8k      1   1     92.19161          186        0       66     8192  a-w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     90.99694                90.99694
#                    max    100.32930                94.72058
#                   mean     92.69477                92.29360
#                 median     92.25367                92.19161
#                 stddev      1.64174                 0.88516
#         standard error      0.11551                 0.06490
#   99% confidence level      0.26868                 0.15096
#                   skew      2.00093                 0.53931
#               kurtosis      4.34842                -0.67568
#       time correlation     -0.00097                 0.00058
#
#           elasped time      2.81704
#      number of samples          186
#     number of outliers           16
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     90.00000 |*                                   90.99694
#                 76     91.00000 |********************************    91.47740
#                 64     92.00000 |**************************          92.40488
#                 34     93.00000 |**************                      93.44434
#
#                 10        > 95% |****                                94.13139
#
#        mean of 95%     92.18918
#          95th %ile     93.80130
# bin/mmap -E -C 200 -L -S -W -N mmap_wa128k -l 128k -I 25000 -w -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp   length flags
mmap_wa128k    1   1    788.23300          192        0        4   131072  a-w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    769.67300               769.67300
#                    max    882.44100               804.68100
#                   mean    790.02849               787.01300
#                 median    788.42500               788.23300
#                 stddev     15.97405                 6.56190
#         standard error      1.12393                 0.47356
#   99% confidence level      2.61426                 1.10151
#                   skew      3.85107                -0.48707
#               kurtosis     17.91679                 0.34285
#       time correlation     -0.01336                 0.00594
#
#           elasped time      0.79329
#      number of samples          192
#     number of outliers           10
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    769.00000 |*                                  769.67300
#                  1    770.00000 |*                                  770.95300
#                  1    771.00000 |*                                  771.65700
#                  1    772.00000 |*                                  772.68100
#                  8    773.00000 |************                       773.76100
#                  0    774.00000 |                                           -
#                  8    775.00000 |************                       775.63300
#                  8    776.00000 |************                       776.61700
#                  2    777.00000 |***                                777.44900
#                  2    778.00000 |***                                778.56900
#                  0    779.00000 |                                           -
#                  1    780.00000 |*                                  780.42500
#                  3    781.00000 |****                               781.57700
#                  3    782.00000 |****                               782.77167
#                  6    783.00000 |*********                          783.75300
#                  5    784.00000 |*******                            784.52100
#                  9    785.00000 |*************                      785.45967
#                 15    786.00000 |**********************             786.52633
#                 20    787.00000 |******************************     787.56100
#                 21    788.00000 |********************************   788.55910
#                 17    789.00000 |*************************          789.54312
#                 16    790.00000 |************************           790.57300
#                  8    791.00000 |************                       791.59300
#                 13    792.00000 |*******************                792.54562
#                  9    793.00000 |*************                      793.47389
#                  3    794.00000 |****                               794.71833
#                  1    795.00000 |*                                  795.40100
#
#                 10        > 95% |***************                    799.67620
#
#        mean of 95%    786.31722
#          95th %ile    795.46500
 
# bin/munmap -E -C 200 -L -S -W -N unmap_z8k -l 8k -I 250 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_z8k      1   1     40.06218          199        0      400     8192  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     39.01897                39.01897
#                    max     42.08393                41.47978
#                   mean     40.11682                40.09056
#                 median     40.06730                40.06218
#                 stddev      0.52795                 0.48556
#         standard error      0.03715                 0.03442
#   99% confidence level      0.08640                 0.08006
#                   skew      0.81522                 0.50566
#               kurtosis      1.13063                 0.28489
#       time correlation      0.00028                 0.00073
#
#           elasped time      6.27845
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 87     39.00000 |***************************         39.68152
#                100     40.00000 |********************************    40.31131
#                  2     41.00000 |*                                   41.10442
#
#                 10        > 95% |***                                 41.23894
#
#        mean of 95%     40.02980
#          95th %ile     41.11433
# bin/munmap -E -C 200 -L -S -W -N unmap_z128k -l 128k -I 250 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_z128k    1   1     38.65482          201        0      400   131072  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     36.45706                36.45706
#                    max     42.79242                40.83466
#                   mean     38.53760                38.51643
#                 median     38.67402                38.65482
#                 stddev      1.00128                 0.95739
#         standard error      0.07045                 0.06753
#   99% confidence level      0.16387                 0.15707
#                   skew      0.16019                -0.18653
#               kurtosis      0.49016                -0.76395
#       time correlation      0.00258                 0.00207
#
#           elasped time      6.13088
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 16     36.00000 |******                              36.84214
#                 40     37.00000 |****************                    37.39691
#                 79     38.00000 |********************************    38.58290
#                 55     39.00000 |**********************              39.37294
#
#                 11        > 95% |****                                40.26273
#
#        mean of 95%     38.41533
#          95th %ile     39.94442
# bin/munmap -E -C 200 -L -S -W -N unmap_t8k -l 8k -I 250 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_t8k      1   1     39.82664          197        0      400     8192  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     38.83208                38.83208
#                    max     96.89416                41.44904
#                   mean     40.48305                39.88305
#                 median     39.86184                39.82664
#                 stddev      5.11359                 0.53444
#         standard error      0.35979                 0.03808
#   99% confidence level      0.83687                 0.08857
#                   skew      9.21642                 0.63527
#               kurtosis     89.25457                 0.20065
#       time correlation      0.01568                -0.00139
#
#           elasped time      6.53087
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  6     38.00000 |*                                   38.93746
#                112     39.00000 |********************************    39.56960
#                 69     40.00000 |*******************                 40.28698
#
#                 10        > 95% |**                                  41.17397
#
#        mean of 95%     39.81402
#          95th %ile     40.89160
# bin/munmap -E -C 200 -L -S -W -N unmap_t128k -l 128k -I 250 -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_t128k    1   1     38.60170          198        0      400   131072  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     37.52970                37.52970
#                    max     42.15434                40.20938
#                   mean     38.72087                38.67012
#                 median     38.61450                38.60170
#                 stddev      0.63169                 0.51512
#         standard error      0.04445                 0.03661
#   99% confidence level      0.10338                 0.08515
#                   skew      1.76718                 0.66467
#               kurtosis      6.00166                 0.42400
#       time correlation      0.00061                -0.00008
#
#           elasped time      6.32649
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 13     37.00000 |**                                  37.84537
#                142     38.00000 |********************************    38.52007
#                 33     39.00000 |*******                             39.25332
#
#                 10        > 95% |**                                  39.94832
#
#        mean of 95%     38.60213
#          95th %ile     39.67434
# bin/munmap -E -C 200 -L -S -W -N unmap_u8k -l 8k -I 250 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_u8k      1   1     39.58475          200        0      400     8192  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     37.06955                37.06955
#                    max     49.12971                42.06923
#                   mean     39.29420                39.21461
#                 median     39.58475                39.58475
#                 stddev      1.39592                 1.13567
#         standard error      0.09822                 0.08030
#   99% confidence level      0.22845                 0.18679
#                   skew      1.83168                -0.37124
#               kurtosis     11.94920                -0.91330
#       time correlation     -0.00379                -0.00270
#
#           elasped time      6.39459
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 42     37.00000 |*******************                 37.44619
#                 31     38.00000 |**************                      38.56331
#                 70     39.00000 |********************************    39.56920
#                 47     40.00000 |*********************               40.31183
#
#                 10        > 95% |****                                41.02193
#
#        mean of 95%     39.11948
#          95th %ile     40.76683
# bin/munmap -E -C 200 -L -S -W -N unmap_u128k -l 128k -I 250 -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_u128k    1   1     37.54698          202        0      400   131072  ----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     35.15914                35.15914
#                    max     39.67946                39.67946
#                   mean     37.22939                37.22939
#                 median     37.54698                37.54698
#                 stddev      1.12439                 1.12439
#         standard error      0.07911                 0.07911
#   99% confidence level      0.18401                 0.18401
#                   skew     -0.30929                -0.30929
#               kurtosis     -0.98057                -0.98057
#       time correlation     -0.00155                -0.00155
#
#           elasped time      6.23979
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 48     35.00000 |********************                35.55052
#                 26     36.00000 |***********                         36.68485
#                 75     37.00000 |********************************    37.61220
#                 42     38.00000 |*****************                   38.30685
#
#                 11        > 95% |****                                39.11842
#
#        mean of 95%     37.12060
#          95th %ile     38.85898
# bin/munmap -E -C 200 -L -S -W -N unmap_a8k -l 8k -I 250 -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_a8k      1   1     59.81636          201        0      400     8192  a---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     58.59652                58.59652
#                    max     62.74693                61.73445
#                   mean     59.89487                59.88068
#                 median     59.81957                59.81636
#                 stddev      0.64909                 0.61851
#         standard error      0.04567                 0.04363
#   99% confidence level      0.10623                 0.10147
#                   skew      0.68357                 0.37469
#               kurtosis      1.15116                -0.15793
#       time correlation     -0.00069                -0.00103
#
#           elasped time      6.50753
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          238
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 13     58.00000 |***                                 58.81831
#                109     59.00000 |********************************    59.55273
#                 68     60.00000 |*******************                 60.38821
#
#                 11        > 95% |***                                 61.24839
#
#        mean of 95%     59.80150
#          95th %ile     60.95172
# bin/munmap -E -C 200 -L -S -W -N unmap_a128k -l 128k -I 250 -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_a128k    1   1     58.51467          197        0      400   131072  a---
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     57.83179                57.83179
#                    max     64.43915                59.93227
#                   mean     58.68557                58.61110
#                 median     58.52235                58.51467
#                 stddev      0.69921                 0.46924
#         standard error      0.04920                 0.03343
#   99% confidence level      0.11443                 0.07776
#                   skew      3.58138                 0.76191
#               kurtosis     22.90191                 0.07710
#       time correlation      0.00082                 0.00031
#
#           elasped time      6.41786
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 17     57.00000 |***                                 57.92745
#                149     58.00000 |********************************    58.50688
#                 21     59.00000 |****                                59.38014
#
#                 10        > 95% |**                                  59.71128
#
#        mean of 95%     58.55227
#          95th %ile     59.59947
 
# bin/munmap -E -C 200 -L -S -W -N unmap_rz8k -l 8k -I 250 -r -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_rz8k     1   1     61.68201          199        0      400     8192  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     59.68969                59.68969
#                    max     72.19721                64.22217
#                   mean     61.65685                61.56195
#                 median     61.71657                61.68201
#                 stddev      1.52299                 1.26800
#         standard error      0.10716                 0.08989
#   99% confidence level      0.24925                 0.20907
#                   skew      1.76083                 0.07142
#               kurtosis      9.70574                -1.37500
#       time correlation      0.00288                 0.00138
#
#           elasped time     11.43848
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 24     59.00000 |*************                       59.86257
#                 58     60.00000 |********************************    60.37426
#                 30     61.00000 |****************                    61.58780
#                 58     62.00000 |********************************    62.51429
#                 19     63.00000 |**********                          63.24220
#
#                 10        > 95% |*****                               63.73558
#
#        mean of 95%     61.44695
#          95th %ile     63.51689
# bin/munmap -E -C 200 -L -S -W -N unmap_rz128k -l 128k -I 500 -r -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_rz128k   1   1     64.54418          196        0      200   131072  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     63.55986                63.55986
#                    max    150.30930                66.39890
#                   mean     65.20777                64.72166
#                 median     64.55442                64.54418
#                 stddev      6.05777                 0.57571
#         standard error      0.42622                 0.04112
#   99% confidence level      0.99139                 0.09565
#                   skew     13.72527                 1.56780
#               kurtosis    189.81897                 2.10261
#       time correlation      0.01077                 0.00132
#
#           elasped time     18.31043
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  7     63.00000 |*                                   63.78971
#                158     64.00000 |********************************    64.53765
#                 12     65.00000 |**                                  65.32573
#                  9     66.00000 |*                                   66.10948
#
#                 10        > 95% |**                                  66.30751
#
#        mean of 95%     64.63640
#          95th %ile     66.23378
# bin/munmap -E -C 200 -L -S -W -N unmap_rt8k -l 8k -I 500 -r -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_rt8k     1   1     64.58385          177        0      200     8192  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     63.85938                63.85938
#                    max     69.40434                65.33393
#                   mean     64.84394                64.59837
#                 median     64.63889                64.58385
#                 stddev      0.76061                 0.27405
#         standard error      0.05352                 0.02060
#   99% confidence level      0.12448                 0.04791
#                   skew      2.64576                 0.41498
#               kurtosis      8.89210                 0.13609
#       time correlation     -0.00021                 0.00020
#
#           elasped time      5.89221
#      number of samples          177
#     number of outliers           25
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     63.00000 |*                                   63.85938
#                158     64.00000 |********************************    64.54113
#                  9     65.00000 |*                                   65.03954
#
#                  9        > 95% |*                                   65.24419
#
#        mean of 95%     64.56377
#          95th %ile     65.08433
# bin/munmap -E -C 200 -L -S -W -N unmap_rt128k -l 128k -I 1500 -r -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_rt128k   1   1     86.75356          183        0       66   131072  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     84.75598                84.75598
#                    max     94.87574                89.80229
#                   mean     87.38415                86.86730
#                 median     86.82726                86.75356
#                 stddev      1.91463                 0.99188
#         standard error      0.13471                 0.07332
#   99% confidence level      0.31334                 0.17055
#                   skew      1.90592                 0.43971
#               kurtosis      3.78160                -0.12812
#       time correlation      0.00108                 0.00043
#
#           elasped time      4.40110
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          217
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3     84.00000 |*                                   84.83485
#                 36     85.00000 |****************                    85.69131
#                 71     86.00000 |********************************    86.52575
#                 49     87.00000 |**********************              87.49338
#                 14     88.00000 |******                              88.25631
#
#                 10        > 95% |****                                89.12311
#
#        mean of 95%     86.73690
#          95th %ile     88.81320
# bin/munmap -E -C 200 -L -S -W -N unmap_ru8k -l 8k -I 500 -r -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_ru8k     1   1     65.15474          195        0      200     8192  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     64.42897                64.42897
#                    max     75.95793                67.20913
#                   mean     65.50452                65.35431
#                 median     65.16882                65.15474
#                 stddev      1.14151                 0.62882
#         standard error      0.08032                 0.04503
#   99% confidence level      0.18682                 0.10474
#                   skew      5.00430                 1.39436
#               kurtosis     37.17780                 1.20827
#       time correlation      0.00165                 0.00119
#
#           elasped time      5.84914
#      number of samples          195
#     number of outliers            7
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 65     64.00000 |*******************                 64.83355
#                105     65.00000 |********************************    65.34297
#                 15     66.00000 |****                                66.57775
#
#                 10        > 95% |***                                 67.02315
#
#        mean of 95%     65.26410
#          95th %ile     66.87505
# bin/munmap -E -C 200 -L -S -W -N unmap_ru128k -l 128k -I 1500 -r -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_ru128k   1   1     88.08774          191        0       66   131072  -r--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     86.43926                86.43926
#                    max    114.43635                90.48095
#                   mean     88.66597                88.16526
#                 median     88.16144                88.08774
#                 stddev      2.84283                 0.98167
#         standard error      0.20002                 0.07103
#   99% confidence level      0.46525                 0.16522
#                   skew      6.02002                 0.23539
#               kurtosis     46.08258                -0.82655
#       time correlation     -0.00222                -0.00027
#
#           elasped time      4.36433
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 32     86.00000 |****************                    86.78435
#                 56     87.00000 |****************************        87.57553
#                 62     88.00000 |********************************    88.48232
#                 31     89.00000 |****************                    89.39489
#
#                 10        > 95% |*****                               90.10898
#
#        mean of 95%     88.05787
#          95th %ile     89.86035
# bin/munmap -E -C 200 -L -S -W -N unmap_ra8k -l 8k -I 250 -r -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_ra8k     1   1     87.87212          198        0      400     8192  ar--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     86.92428                86.92428
#                    max     92.40972                89.80684
#                   mean     88.04335                87.98031
#                 median     87.87404                87.87212
#                 stddev      0.77211                 0.62625
#         standard error      0.05433                 0.04451
#   99% confidence level      0.12636                 0.10352
#                   skew      1.74128                 0.56691
#               kurtosis      5.85572                -0.34414
#       time correlation      0.00061                 0.00111
#
#           elasped time     12.14477
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          208
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     86.00000 |*                                   86.95308
#                109     87.00000 |********************************    87.52555
#                 77     88.00000 |**********************              88.46863
#
#                 10        > 95% |**                                  89.38246
#
#        mean of 95%     87.90572
#          95th %ile     89.01964
# bin/munmap -E -C 200 -L -S -W -N unmap_ra128k -l 128k -I 500 -r -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_ra128k   1   1     92.70418          198        0      200   131072  ar--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     91.94387                91.94387
#                    max    110.89938                94.67410
#                   mean     93.06853                92.92592
#                 median     92.70802                92.70418
#                 stddev      1.49690                 0.66302
#         standard error      0.10532                 0.04712
#   99% confidence level      0.24498                 0.10960
#                   skew      8.70068                 1.30029
#               kurtosis     97.67492                 0.55041
#       time correlation     -0.00124                 0.00032
#
#           elasped time     18.49251
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          219
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  2     91.00000 |*                                   91.95091
#                141     92.00000 |********************************    92.58610
#                 31     93.00000 |*******                             93.41013
#                 14     94.00000 |***                                 94.24695
#
#                 10        > 95% |**                                  94.56185
#
#        mean of 95%     92.83890
#          95th %ile     94.43859
 
# bin/connection -E -C 200 -L -S -W -N conn_connect -B 256 -c 
             prc thr   usecs/call      samples   errors cnt/samp 
conn_connect   1   1    113.05317          189        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    112.12417               112.12417
#                    max    312.99517               115.48817
#                   mean    120.01463               113.28015
#                 median    113.15517               113.05317
#                 stddev     35.07193                 0.74916
#         standard error      2.46765                 0.05449
#   99% confidence level      5.73976                 0.12675
#                   skew      5.10301                 0.79012
#               kurtosis     24.35021                -0.04958
#       time correlation     -0.16587                 0.00273
#
#           elasped time     12.33404
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 87    112.00000 |********************************   112.65610
#                 64    113.00000 |***********************            113.42606
#                 28    114.00000 |**********                         114.24092
#
#                 10        > 95% |***                                115.08547
#
#        mean of 95%    113.17930
#          95th %ile    114.77617
 
# bin/munmap -E -C 200 -L -S -W -N unmap_wz8k -l 8k -I 500 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wz8k     1   1     86.56278          197        0      200     8192  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     85.68982                85.68982
#                    max     93.77302                88.60950
#                   mean     86.83126                86.73464
#                 median     86.57302                86.56278
#                 stddev      0.92322                 0.64759
#         standard error      0.06496                 0.04614
#   99% confidence level      0.15109                 0.10732
#                   skew      3.20182                 1.22083
#               kurtosis     16.82519                 0.95665
#       time correlation      0.00015                -0.00000
#
#           elasped time      8.13593
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 13     85.00000 |**                                  85.88704
#                139     86.00000 |********************************    86.49744
#                 30     87.00000 |******                              87.39533
#                  5     88.00000 |*                                   88.15408
#
#                 10        > 95% |**                                  88.44169
#
#        mean of 95%     86.64335
#          95th %ile     88.30998
# bin/munmap -E -C 200 -L -S -W -N unmap_wz128k -l 128k -I 4000 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wz128k   1   1    148.58380          177        0       25   131072  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    145.62444               147.71340
#                    max    235.39852               149.87404
#                   mean    149.78350               148.58021
#                 median    148.66572               148.58380
#                 stddev      6.81921                 0.51477
#         standard error      0.47980                 0.03869
#   99% confidence level      1.11601                 0.09000
#                   skew     10.10494                 0.22322
#               kurtosis    120.59686                -0.93204
#       time correlation      0.00353                 0.00149
#
#           elasped time      4.86042
#      number of samples          177
#     number of outliers           25
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 33    147.00000 |**********                         147.89524
#                101    148.00000 |********************************   148.51790
#                 34    149.00000 |**********                         149.15513
#
#                  9        > 95% |**                                 149.61918
#
#        mean of 95%    148.52455
#          95th %ile    149.43372
# bin/munmap -E -C 200 -L -S -W -N unmap_wt8k -l 8k -I 500 -w -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wt8k     1   1     86.23896          197        0      200     8192  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     84.56856                84.56856
#                    max     94.47960                89.08824
#                   mean     86.46267                86.35014
#                 median     86.32344                86.23896
#                 stddev      1.20119                 0.93160
#         standard error      0.08452                 0.06637
#   99% confidence level      0.19658                 0.15439
#                   skew      2.07244                 0.34914
#               kurtosis      9.79676                -0.55096
#       time correlation     -0.00510                -0.00387
#
#           elasped time      9.19688
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          208
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 10     84.00000 |****                                84.77630
#                 75     85.00000 |********************************    85.57094
#                 59     86.00000 |*************************           86.52175
#                 43     87.00000 |******************                  87.37575
#
#                 10        > 95% |****                                88.34546
#
#        mean of 95%     86.24344
#          95th %ile     87.82872
# bin/munmap -E -C 200 -L -S -W -N unmap_wt128k -l 128k -I 5000 -w -f /tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wt128k   1   1    149.04500          191        0       20   131072  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    145.74260               145.74260
#                    max    169.44820               151.89940
#                   mean    149.24137               148.53675
#                 median    149.13460               149.04500
#                 stddev      3.52439                 1.34883
#         standard error      0.24797                 0.09760
#   99% confidence level      0.57679                 0.22701
#                   skew      3.78105                -0.71921
#               kurtosis     16.53338                -0.72836
#       time correlation      0.00065                -0.00131
#
#           elasped time      5.11377
#      number of samples          191
#     number of outliers           11
#      getnsecs overhead          220
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  6    145.00000 |**                                 145.90687
#                 43    146.00000 |**************                     146.49304
#                  2    147.00000 |*                                  147.03540
#                 38    148.00000 |*************                      148.74689
#                 92    149.00000 |********************************   149.40326
#
#                 10        > 95% |***                                150.43252
#
#        mean of 95%    148.43201
#          95th %ile    149.92820
# bin/munmap -E -C 200 -L -S -W -N unmap_wu8k -l 8k -I 500 -w -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wu8k     1   1     87.13365          200        0      200     8192  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     85.48373                85.48373
#                    max    106.93397                89.89333
#                   mean     87.35134                87.23851
#                 median     87.13365                87.13365
#                 stddev      1.68627                 0.94209
#         standard error      0.11865                 0.06662
#   99% confidence level      0.27597                 0.15495
#                   skew      7.82968                 0.64347
#               kurtosis     87.35951                 0.05662
#       time correlation     -0.00050                -0.00004
#
#           elasped time      9.06901
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 14     85.00000 |*****                               85.78334
#                 70     86.00000 |***************************         86.53031
#                 81     87.00000 |********************************    87.42223
#                 22     88.00000 |********                            88.46316
#                  3     89.00000 |*                                   89.10613
#
#                 10        > 95% |***                                 89.49039
#
#        mean of 95%     87.11999
#          95th %ile     89.20469
# bin/munmap -E -C 200 -L -S -W -N unmap_wu128k -l 128k -I 5000 -w -f /var/tmp/libmicro.289520/data 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wu128k   1   1    150.88805          186        0       20   131072  --w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    147.04805               147.04805
#                    max    185.08965               154.53605
#                   mean    151.89900               150.47804
#                 median    150.93925               150.88805
#                 stddev      5.32220                 1.48900
#         standard error      0.37447                 0.10918
#   99% confidence level      0.87101                 0.25395
#                   skew      3.22214                -0.66939
#               kurtosis     11.33391                 0.18583
#       time correlation     -0.00179                 0.00243
#
#           elasped time      5.15662
#      number of samples          186
#     number of outliers           16
#      getnsecs overhead          223
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 21    147.00000 |**********                         147.45034
#                 13    148.00000 |******                             148.60670
#                 15    149.00000 |*******                            149.36229
#                 59    150.00000 |****************************       150.66134
#                 66    151.00000 |********************************   151.48558
#                  2    152.00000 |*                                  152.05925
#
#                 10        > 95% |****                               152.89509
#
#        mean of 95%    150.34070
#          95th %ile    152.12965
# bin/munmap -E -C 200 -L -S -W -N unmap_wa8k -l 8k -I 500 -w -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wa8k     1   1    117.26354          196        0      200     8192  a-w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    115.70449               115.70449
#                    max    123.87474               119.77362
#                   mean    117.63320               117.52150
#                 median    117.32882               117.26354
#                 stddev      1.09800                 0.88118
#         standard error      0.07726                 0.06294
#   99% confidence level      0.17970                 0.14640
#                   skew      1.67275                 0.72201
#               kurtosis      4.84296                -0.41761
#       time correlation     -0.00159                -0.00182
#
#           elasped time      8.50946
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          221
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    115.00000 |*                                  115.70449
#                 61    116.00000 |**********************             116.68265
#                 85    117.00000 |********************************   117.38137
#                 31    118.00000 |***********                        118.59123
#                  8    119.00000 |***                                119.11697
#
#                 10        > 95% |***                                119.41880
#
#        mean of 95%    117.41950
#          95th %ile    119.18482
# bin/munmap -E -C 200 -L -S -W -N unmap_wa128k -l 128k -I 5000 -w -f MAP_ANON 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
unmap_wa128k   1   1    184.24540          171        0       20   131072  a-w-
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    180.84060               183.23420
#                    max    250.38300               185.39740
#                   mean    185.20306               184.25131
#                 median    184.24540               184.24540
#                 stddev      5.83015                 0.38615
#         standard error      0.41021                 0.02953
#   99% confidence level      0.95414                 0.06869
#                   skew      7.73832                -0.11451
#               kurtosis     76.66608                -0.03133
#       time correlation      0.00338                -0.00036
#
#           elasped time      3.93005
#      number of samples          171
#     number of outliers           31
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 41    183.00000 |**********                         183.73840
#                121    184.00000 |********************************   184.37107
#
#                  9        > 95% |**                                 184.97784
#
#        mean of 95%    184.21095
#          95th %ile    184.83420
 
# bin/mprotect -E -C 200 -L -S -W -N mprot_z8k -l 8k -I 300 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_z8k      1   1     40.44656          189        0      333     8192 -----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     32.30299                39.51558
#                    max    149.58174                41.65122
#                   mean     41.82701                40.46362
#                 median     40.47116                40.44656
#                 stddev      9.21841                 0.40203
#         standard error      0.64861                 0.02924
#   99% confidence level      1.50866                 0.06802
#                   skew      8.98266                 0.33464
#               kurtosis     93.69776                 0.41539
#       time correlation     -0.03250                 0.00018
#
#           elasped time      2.81918
#      number of samples          189
#     number of outliers           13
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 26     39.00000 |*****                               39.83754
#                148     40.00000 |********************************    40.48975
#                  5     41.00000 |*                                   41.03405
#
#                 10        > 95% |**                                  41.41951
#
#        mean of 95%     40.41022
#          95th %ile     41.08617
# bin/mprotect -E -C 200 -L -S -W -N mprot_z128k -l 128k -I 500 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_z128k    1   1     39.42421          183        0      200   131072 -----
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     30.55894                38.67925
#                    max     42.27350                40.16918
#                   mean     39.53942                39.42560
#                 median     39.45365                39.42421
#                 stddev      0.85721                 0.25359
#         standard error      0.06031                 0.01875
#   99% confidence level      0.14029                 0.04360
#                   skew     -4.94096                 0.16877
#               kurtosis     58.46051                 0.34213
#       time correlation      0.00287                 0.00141
#
#           elasped time      1.60253
#      number of samples          183
#     number of outliers           19
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 10     38.00000 |*                                   38.92566
#                163     39.00000 |********************************    39.42195
#
#                 10        > 95% |*                                   39.98498
#
#        mean of 95%     39.39327
#          95th %ile     39.84918
# bin/mprotect -E -C 200 -L -S -W -N mprot_wz8k -l 8k -I 500 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_wz8k     1   1     67.99889          197        0      200     8192 --w--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     52.54417                66.44497
#                    max     92.53777                70.41937
#                   mean     68.30629                68.17301
#                 median     68.02961                67.99889
#                 stddev      2.36230                 0.75357
#         standard error      0.16621                 0.05369
#   99% confidence level      0.38661                 0.12488
#                   skew      4.63879                 0.87309
#               kurtosis     65.60754                 0.73175
#       time correlation      0.01050                 0.00399
#
#           elasped time      2.76593
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3     66.00000 |*                                   66.66428
#                 97     67.00000 |********************************    67.64663
#                 72     68.00000 |***********************             68.42271
#                 15     69.00000 |****                                69.38291
#
#                 10        > 95% |***                                 70.11883
#
#        mean of 95%     68.06895
#          95th %ile     69.74353
# bin/mprotect -E -C 200 -L -S -W -N mprot_wz128k -l 128k -I 500 -w -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_wz128k   1   1     75.89396          198        0      200   131072 --w--
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     64.44948                74.29909
#                    max     89.22901                78.66900
#                   mean     76.11518                76.05192
#                 median     75.91828                75.89396
#                 stddev      1.63941                 0.88916
#         standard error      0.11535                 0.06319
#   99% confidence level      0.26830                 0.14698
#                   skew      1.49531                 0.83403
#               kurtosis     33.38072                 0.28955
#       time correlation      0.00295                 0.00140
#
#           elasped time      3.08517
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 15     74.00000 |*****                               74.78634
#                 93     75.00000 |********************************    75.51148
#                 60     76.00000 |********************                76.38493
#                 20     77.00000 |******                              77.39720
#
#                 10        > 95% |***                                 78.28782
#
#        mean of 95%     75.93299
#          95th %ile     77.90357
# bin/mprotect -E -C 200 -L -S -W -N mprot_twz8k -l 8k -I 500 -w -t -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_twz8k    1   1     68.16916          198        0      200     8192 --w-t
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     66.86357                66.86357
#                    max     81.65909                70.43476
#                   mean     68.41044                68.30350
#                 median     68.17941                68.16916
#                 stddev      1.24319                 0.75374
#         standard error      0.08747                 0.05357
#   99% confidence level      0.20346                 0.12459
#                   skew      6.20056                 0.72991
#               kurtosis     61.51579                 0.01176
#       time correlation     -0.00270                -0.00082
#
#           elasped time      2.77013
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     66.00000 |*                                   66.86357
#                 70     67.00000 |************************            67.60233
#                 91     68.00000 |********************************    68.34759
#                 26     69.00000 |*********                           69.41835
#
#                 10        > 95% |***                                 70.05588
#
#        mean of 95%     68.21029
#          95th %ile     69.85877
# bin/mprotect -E -C 200 -L -S -W -N mprot_tw128k -l 128k -I 1000 -w -t -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_tw128k   1   1     73.81805          184        0      100   131072 --w-t
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     71.71885                72.25901
#                    max     86.11885                75.86861
#                   mean     74.18940                73.85698
#                 median     73.86669                73.81805
#                 stddev      1.46703                 0.68389
#         standard error      0.10322                 0.05042
#   99% confidence level      0.24009                 0.11727
#                   skew      3.57513                 0.52250
#               kurtosis     21.64236                 0.29752
#       time correlation      0.00428                 0.00462
#
#           elasped time      1.50584
#      number of samples          184
#     number of outliers           18
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 18     72.00000 |******                              72.78353
#                 95     73.00000 |********************************    73.55712
#                 59     74.00000 |*******************                 74.34997
#                  2     75.00000 |*                                   75.00845
#
#                 10        > 95% |***                                 75.49895
#
#        mean of 95%     73.76261
#          95th %ile     75.02637
# bin/mprotect -E -C 200 -L -S -W -N mprot_tw4m -l 4m -w -t -B 10 -f /dev/zero 
             prc thr   usecs/call      samples   errors cnt/samp     size flags
mprot_tw4m     1   1    241.38670          193        0       10  4194304 --w-t
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    235.19150               235.19150
#                    max    792.19630               253.49550
#                   mean    246.07568               241.88504
#                 median    241.46350               241.38670
#                 stddev     39.69398                 4.08912
#         standard error      2.79286                 0.29434
#   99% confidence level      6.49619                 0.68464
#                   skew     12.94421                -0.03896
#               kurtosis    174.48166                -0.89215
#       time correlation     -0.08451                 0.00257
#
#           elasped time      0.50508
#      number of samples          193
#     number of outliers            9
#      getnsecs overhead          213
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 32    235.00000 |********************               235.70030
#                 10    236.00000 |******                             236.28462
#                  0    237.00000 |                                           -
#                  0    238.00000 |                                           -
#                  1    239.00000 |*                                  239.87630
#                 29    240.00000 |******************                 240.59751
#                 51    241.00000 |********************************   241.45597
#                  6    242.00000 |***                                242.35523
#                  0    243.00000 |                                           -
#                  0    244.00000 |                                           -
#                  8    245.00000 |*****                              245.85390
#                 41    246.00000 |*************************          246.48859
#                  5    247.00000 |***                                247.17230
#
#                 10        > 95% |******                             248.42414
#
#        mean of 95%    241.52771
#          95th %ile    247.27470
 
# bin/pipe -E -C 200 -L -S -W -N pipe_pst1 -s 1 -I 500 -x pipe -m st 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_pst1      1   1      8.37775          198        0      200 st pipe
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min      7.84910                 7.84910
#                    max     10.39886                 9.53358
#                   mean      8.47818                 8.44367
#                 median      8.45838                 8.37775
#                 stddev      0.46898                 0.40368
#         standard error      0.03300                 0.02869
#   99% confidence level      0.07675                 0.06673
#                   skew      1.00970                 0.26375
#               kurtosis      1.92242                -0.92122
#       time correlation     -0.00089                -0.00077
#
#           elasped time      0.37455
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          227
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 27      7.00000 |*****                                7.87523
#                159      8.00000 |********************************     8.48081
#                  2      9.00000 |*                                    9.04078
#
#                 10        > 95% |**                                   9.26850
#
#        mean of 95%      8.39980
#          95th %ile      9.09455
# bin/pipe -E -C 200 -L -S -W -N pipe_pmt1 -s 1 -I 2000 -x pipe -m mt 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_pmt1      1   1     41.25778          199        0       50 mt pipe
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     37.19762                37.19762
#                    max     49.93618                47.45298
#                   mean     41.43546                41.31554
#                 median     41.33458                41.25778
#                 stddev      2.32462                 2.12365
#         standard error      0.16356                 0.15054
#   99% confidence level      0.38044                 0.35016
#                   skew      0.67988                 0.27502
#               kurtosis      0.77248                -0.47653
#       time correlation      0.00221                 0.00026
#
#           elasped time      0.55577
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  7     37.00000 |******                              37.68987
#                 24     38.00000 |*********************               38.49874
#                 35     39.00000 |********************************    39.49650
#                 27     40.00000 |************************            40.60640
#                 27     41.00000 |************************            41.50866
#                 31     42.00000 |****************************        42.55710
#                 30     43.00000 |***************************         43.39197
#                  8     44.00000 |*******                             44.42322
#
#                 10        > 95% |*********                           45.80946
#
#        mean of 95%     41.07777
#          95th %ile     44.65746
# bin/pipe -E -C 200 -L -S -W -N pipe_pmp1 -s 1 -I 2000 -x pipe -m mp 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_pmp1      1   1     43.89456          197        0       50 mp pipe
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     38.25232                38.25232
#                    max     67.27760                48.97360
#                   mean     44.10195                43.81316
#                 median     44.15568                43.89456
#                 stddev      2.91747                 2.09473
#         standard error      0.20527                 0.14924
#   99% confidence level      0.47746                 0.34714
#                   skew      2.83569                -0.11090
#               kurtosis     19.17654                -0.48209
#       time correlation     -0.00267                -0.00171
#
#           elasped time      1.11108
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     38.00000 |*                                   38.25232
#                  6     39.00000 |*****                               39.66117
#                 12     40.00000 |**********                          40.39248
#                 24     41.00000 |********************                41.55301
#                 26     42.00000 |*********************               42.56769
#                 30     43.00000 |*************************           43.46567
#                 38     44.00000 |********************************    44.47891
#                 26     45.00000 |*********************               45.38921
#                 24     46.00000 |********************                46.44155
#
#                 10        > 95% |********                            47.73456
#
#        mean of 95%     43.60346
#          95th %ile     46.97680
# bin/pipe -E -C 200 -L -S -W -N pipe_pst4k -s 4k -I 500 -x pipe -m st 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_pst4k     1   1     13.52852          196        0      200 st pipe
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     12.38420                12.38420
#                    max     37.55924                14.26964
#                   mean     13.56969                13.40919
#                 median     13.54388                13.52852
#                 stddev      1.75673                 0.38119
#         standard error      0.12360                 0.02723
#   99% confidence level      0.28750                 0.06333
#                   skew     12.60650                -0.31950
#               kurtosis    169.17568                -0.54806
#       time correlation     -0.00218                 0.00133
#
#           elasped time      0.58476
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 37     12.00000 |*******                             12.83334
#                149     13.00000 |********************************    13.50710
#
#                 10        > 95% |**                                  14.08097
#
#        mean of 95%     13.37308
#          95th %ile     13.95348
# bin/pipe -E -C 200 -L -S -W -N pipe_pmt4k -s 4k -I 2000 -x pipe -m mt 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_pmt4k     1   1     67.25196          200        0       50 mt pipe
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     57.53420                59.71532
#                    max     82.55564                75.29548
#                   mean     66.95781                66.92694
#                 median     67.25196                67.25196
#                 stddev      3.18359                 2.92700
#         standard error      0.22400                 0.20697
#   99% confidence level      0.52102                 0.48141
#                   skew      0.36769                -0.08046
#               kurtosis      2.40143                 0.06158
#       time correlation     -0.00675                -0.00653
#
#           elasped time      0.82819
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          218
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     59.00000 |*                                   59.71532
#                  5     60.00000 |****                                60.23449
#                  6     61.00000 |*****                               61.55596
#                  3     62.00000 |**                                  62.65591
#                 18     63.00000 |****************                    63.49872
#                 20     64.00000 |******************                  64.52454
#                 27     65.00000 |************************            65.47153
#                 14     66.00000 |************                        66.51505
#                 20     67.00000 |******************                  67.42630
#                 35     68.00000 |********************************    68.62207
#                 30     69.00000 |***************************         69.40048
#                 11     70.00000 |**********                          70.41379
#
#                 10        > 95% |*********                           72.79231
#
#        mean of 95%     66.61824
#          95th %ile     70.93836
# bin/pipe -E -C 200 -L -S -W -N pipe_pmp4k -s 4k -I 2000 -x pipe -m mp 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_pmp4k     1   1     67.25712          200        0       50 mp pipe
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     58.79888                58.79888
#                    max     82.95504                75.31600
#                   mean     67.18747                67.06389
#                 median     67.25712                67.25712
#                 stddev      3.14572                 2.88582
#         standard error      0.22133                 0.20406
#   99% confidence level      0.51482                 0.47464
#                   skew      0.49269                -0.19216
#               kurtosis      2.71405                 0.18621
#       time correlation      0.00277                 0.00056
#
#           elasped time      1.37421
#      number of samples          200
#     number of outliers            2
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1     58.00000 |*                                   58.79888
#                  1     59.00000 |*                                   59.65392
#                  3     60.00000 |**                                  60.78203
#                  6     61.00000 |****                                61.42544
#                  9     62.00000 |*******                             62.69349
#                 11     63.00000 |*********                           63.35009
#                 13     64.00000 |**********                          64.40095
#                 15     65.00000 |************                        65.59175
#                 29     66.00000 |***********************             66.55762
#                 39     67.00000 |********************************    67.45667
#                 30     68.00000 |************************            68.53456
#                 13     69.00000 |**********                          69.44730
#                 16     70.00000 |*************                       70.48784
#                  4     71.00000 |***                                 71.27632
#
#                 10        > 95% |********                            72.85021
#
#        mean of 95%     66.75935
#          95th %ile     71.61424
 
# bin/pipe -E -C 200 -L -S -W -N pipe_sst1 -s 1 -I 500 -x sock -m st 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_sst1      1   1     27.21935          197        0      200 st sock
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     26.19407                26.19407
#                    max     31.85423                28.76943
#                   mean     27.31001                27.24871
#                 median     27.24879                27.21935
#                 stddev      0.66307                 0.51800
#         standard error      0.04665                 0.03691
#   99% confidence level      0.10852                 0.08584
#                   skew      2.13450                 0.50027
#               kurtosis     10.37127                 0.03970
#       time correlation      0.00113                 0.00070
#
#           elasped time      1.15135
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          226
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 66     26.00000 |******************                  26.71185
#                116     27.00000 |********************************    27.41154
#                  5     28.00000 |*                                   28.10921
#
#                 10        > 95% |**                                  28.47298
#
#        mean of 95%     27.18324
#          95th %ile     28.21775
# bin/pipe -E -C 200 -L -S -W -N pipe_smt1 -s 1 -I 2000 -x sock -m mt 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_smt1      1   1    111.19696          202        0       50 mt sock
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    106.29200               106.29200
#                    max    132.49616               132.49616
#                   mean    114.20009               114.20009
#                 median    111.19696               111.19696
#                 stddev      6.19566                 6.19566
#         standard error      0.43593                 0.43593
#   99% confidence level      1.01396                 1.01396
#                   skew      0.98212                 0.98212
#               kurtosis      0.20180                 0.20180
#       time correlation      0.00519                 0.00519
#
#           elasped time      1.31593
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          216
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  4    106.00000 |****                               106.71568
#                  7    107.00000 |*******                            107.59321
#                 31    108.00000 |********************************   108.56693
#                 27    109.00000 |***************************        109.45161
#                 28    110.00000 |****************************       110.33077
#                 16    111.00000 |****************                   111.39024
#                  2    112.00000 |**                                 112.24912
#                  1    113.00000 |*                                  113.27568
#                  3    114.00000 |***                                114.58299
#                  3    115.00000 |***                                115.51653
#                 10    116.00000 |**********                         116.49770
#                 12    117.00000 |************                       117.52784
#                 13    118.00000 |*************                      118.34409
#                  9    119.00000 |*********                          119.28201
#                 11    120.00000 |***********                        120.42785
#                  3    121.00000 |***                                121.27653
#                  1    122.00000 |*                                  122.47632
#                  4    123.00000 |****                               123.65520
#                  4    124.00000 |****                               124.24528
#                  2    125.00000 |**                                 125.62512
#
#                 11        > 95% |***********                        129.71553
#
#        mean of 95%    113.30653
#          95th %ile    125.77872
# bin/pipe -E -C 200 -L -S -W -N pipe_smp1 -s 1 -I 2000 -x sock -m mp 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_smp1      1   1    114.57604          198        0       50 mp sock
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    108.33476               108.33476
#                    max    126.47492               123.03428
#                   mean    115.14314               114.92257
#                 median    114.69380               114.57604
#                 stddev      3.37466                 3.02455
#         standard error      0.23744                 0.21495
#   99% confidence level      0.55229                 0.49996
#                   skew      0.70846                 0.26900
#               kurtosis      0.83639                -0.33743
#       time correlation     -0.00021                 0.00085
#
#           elasped time      1.87044
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3    108.00000 |***                                108.47471
#                  5    109.00000 |*****                              109.66289
#                 13    110.00000 |***************                    110.76834
#                 16    111.00000 |******************                 111.56004
#                 15    112.00000 |*****************                  112.53487
#                 27    113.00000 |********************************   113.41285
#                 26    114.00000 |******************************     114.41358
#                 20    115.00000 |***********************            115.52759
#                 23    116.00000 |***************************        116.32975
#                 18    117.00000 |*********************              117.40200
#                 12    118.00000 |**************                     118.46937
#                  9    119.00000 |**********                         119.39168
#                  1    120.00000 |*                                  120.33604
#
#                 10        > 95% |***********                        121.51927
#
#        mean of 95%    114.57168
#          95th %ile    120.43332
# bin/pipe -E -C 200 -L -S -W -N pipe_sst4k -s 4k -I 500 -x sock -m st 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_sst4k     1   1     57.45814          199        0      200 st sock
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     54.15958                54.15958
#                    max     65.14838                60.23958
#                   mean     57.49350                57.41302
#                 median     57.46454                57.45814
#                 stddev      1.28796                 1.09739
#         standard error      0.09062                 0.07779
#   99% confidence level      0.21078                 0.18094
#                   skew      1.20564                -0.07030
#               kurtosis      6.02463                 0.26208
#       time correlation      0.00557                 0.00441
#
#           elasped time      2.38512
#      number of samples          199
#     number of outliers            3
#      getnsecs overhead          212
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  4     54.00000 |*                                   54.62038
#                 17     55.00000 |******                              55.61968
#                 42     56.00000 |****************                    56.57622
#                 83     57.00000 |********************************    57.51212
#                 36     58.00000 |*************                       58.32623
#                  7     59.00000 |**                                  59.18395
#
#                 10        > 95% |***                                 59.74371
#
#        mean of 95%     57.28971
#          95th %ile     59.32310
# bin/pipe -E -C 200 -L -S -W -N pipe_smt4k -s 4k -I 2000 -x sock -m mt 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_smt4k     1   1    187.85362          202        0       50 mt sock
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    177.89522               177.89522
#                    max    200.05458               200.05458
#                   mean    187.24495               187.24495
#                 median    187.85362               187.85362
#                 stddev      5.09112                 5.09112
#         standard error      0.35821                 0.35821
#   99% confidence level      0.83320                 0.83320
#                   skew      0.04583                 0.04583
#               kurtosis     -0.77050                -0.77050
#       time correlation     -0.00479                -0.00479
#
#           elasped time      2.08572
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          215
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    177.00000 |**                                 177.89522
#                  5    178.00000 |**********                         178.54239
#                 15    179.00000 |******************************     179.65479
#                 11    180.00000 |**********************             180.49199
#                 10    181.00000 |********************               181.48229
#                 13    182.00000 |**************************         182.40633
#                  9    183.00000 |******************                 183.65522
#                  7    184.00000 |**************                     184.62729
#                  4    185.00000 |********                           185.43058
#                 13    186.00000 |**************************         186.45547
#                 15    187.00000 |******************************     187.47986
#                 16    188.00000 |********************************   188.55122
#                 16    189.00000 |********************************   189.49234
#                 15    190.00000 |******************************     190.30439
#                 16    191.00000 |********************************   191.42866
#                 14    192.00000 |****************************       192.46089
#                  9    193.00000 |******************                 193.52374
#                  2    194.00000 |****                               194.61458
#
#                 11        > 95% |**********************             197.44431
#
#        mean of 95%    186.65755
#          95th %ile    195.73842
# bin/pipe -E -C 200 -L -S -W -N pipe_smp4k -s 4k -I 2000 -x sock -m mp 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_smp4k     1   1    199.31716          198        0       50 mp sock
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    192.01092               192.01092
#                    max    217.37540               210.19716
#                   mean    199.55676               199.23428
#                 median    199.67556               199.31716
#                 stddev      4.58889                 4.01718
#         standard error      0.32287                 0.28549
#   99% confidence level      0.75100                 0.66405
#                   skew      0.82490                 0.17692
#               kurtosis      1.35525                -0.84500
#       time correlation     -0.00376                -0.00106
#
#           elasped time      2.76205
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  8    192.00000 |********                           192.59012
#                  8    193.00000 |********                           193.48228
#                 19    194.00000 |*******************                194.51352
#                 20    195.00000 |********************               195.50839
#                 24    196.00000 |************************           196.50180
#                  9    197.00000 |*********                          197.44893
#                  7    198.00000 |*******                            198.47455
#                  7    199.00000 |*******                            199.29595
#                  8    200.00000 |********                           200.56708
#                 26    201.00000 |**************************         201.53806
#                 31    202.00000 |********************************   202.48776
#                 16    203.00000 |****************                   203.47844
#                  5    204.00000 |*****                              204.54058
#
#                 10        > 95% |**********                         207.64023
#
#        mean of 95%    198.78716
#          95th %ile    205.35876
 
# bin/pipe -E -C 200 -L -S -W -N pipe_tst1 -s 1 -I 500 -x tcp -m st 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_tst1      1   1    147.38833          198        0      200 st  tcp
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    145.04849               145.04849
#                    max    167.47793               151.10801
#                   mean    147.71982               147.52682
#                 median    147.40369               147.38833
#                 stddev      2.04408                 1.28884
#         standard error      0.14382                 0.09159
#   99% confidence level      0.33453                 0.21305
#                   skew      4.91471                 0.55186
#               kurtosis     41.92414                -0.19549
#       time correlation      0.00175                 0.00042
#
#           elasped time      6.19933
#      number of samples          198
#     number of outliers            4
#      getnsecs overhead          222
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 21    145.00000 |***********                        145.69166
#                 55    146.00000 |*****************************      146.51535
#                 59    147.00000 |********************************   147.48507
#                 35    148.00000 |******************                 148.47106
#                 17    149.00000 |*********                          149.34462
#                  1    150.00000 |*                                  150.03281
#
#                 10        > 95% |*****                              150.54430
#
#        mean of 95%    147.36631
#          95th %ile    150.14417
# bin/pipe -E -C 200 -L -S -W -N pipe_tmt1 -s 1 -I 2000 -x tcp -m mt 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_tmt1      1   1    272.97344          201        0       50 mt  tcp
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    269.37408               269.37408
#                    max    282.61440               280.99648
#                   mean    273.72552               273.68130
#                 median    272.97856               272.97344
#                 stddev      2.83742                 2.77384
#         standard error      0.19964                 0.19565
#   99% confidence level      0.46436                 0.45509
#                   skew      1.24612                 1.22430
#               kurtosis      0.72173                 0.64707
#       time correlation      0.00542                 0.00631
#
#           elasped time      3.15000
#      number of samples          201
#     number of outliers            1
#      getnsecs overhead          224
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  3    269.00000 |**                                 269.54133
#                 19    270.00000 |**************                     270.70285
#                 38    271.00000 |****************************       271.56733
#                 43    272.00000 |********************************   272.53300
#                 37    273.00000 |***************************        273.46607
#                 25    274.00000 |******************                 274.54446
#                  5    275.00000 |***                                275.61536
#                  3    276.00000 |**                                 276.27584
#                  0    277.00000 |                                           -
#                  5    278.00000 |***                                278.59827
#                 12    279.00000 |********                           279.34187
#
#                 11        > 95% |********                           280.51194
#
#        mean of 95%    273.28584
#          95th %ile    279.71648
# bin/pipe -E -C 200 -L -S -W -N pipe_tmp1 -s 1 -I 2000 -x tcp -m mp 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_tmp1      1   1    274.49918          197        0       50 mp  tcp
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    269.33822               269.33822
#                    max    311.49630               283.31582
#                   mean    275.54097               275.11769
#                 median    274.67838               274.49918
#                 stddev      4.21508                 2.91212
#         standard error      0.29657                 0.20748
#   99% confidence level      0.68983                 0.48260
#                   skew      3.77413                 1.10396
#               kurtosis     25.46590                 0.83778
#       time correlation      0.00242                -0.00106
#
#           elasped time      3.70959
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    269.00000 |*                                  269.33822
#                  4    270.00000 |**                                 270.54142
#                 11    271.00000 |********                           271.56123
#                 24    272.00000 |*****************                  272.49193
#                 34    273.00000 |*************************          273.44446
#                 43    274.00000 |********************************   274.47298
#                 31    275.00000 |***********************            275.49064
#                 16    276.00000 |***********                        276.49086
#                  7    277.00000 |*****                              277.49219
#                  1    278.00000 |*                                  278.37502
#                  4    279.00000 |**                                 279.45278
#                  4    280.00000 |**                                 280.29630
#                  7    281.00000 |*****                              281.49529
#
#                 10        > 95% |*******                            282.59032
#
#        mean of 95%    274.71808
#          95th %ile    282.17406
# bin/pipe -E -C 200 -L -S -W -N pipe_tst4k -s 4k -I 500 -x tcp -m st 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_tst4k     1   1    142.19918          196        0      200 st  tcp
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    140.73358               140.73358
#                    max    152.14478               144.99854
#                   mean    142.60680               142.46768
#                 median    142.22350               142.19918
#                 stddev      1.28709                 0.94544
#         standard error      0.09056                 0.06753
#   99% confidence level      0.21064                 0.15708
#                   skew      2.59280                 0.53061
#               kurtosis     14.07215                -0.82020
#       time correlation      0.00053                -0.00026
#
#           elasped time      5.99742
#      number of samples          196
#     number of outliers            6
#      getnsecs overhead          228
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    140.00000 |*                                  140.73358
#                 80    141.00000 |********************************   141.60881
#                 55    142.00000 |**********************             142.41624
#                 44    143.00000 |*****************                  143.47415
#                  6    144.00000 |**                                 144.07395
#
#                 10        > 95% |****                               144.40270
#
#        mean of 95%    142.36365
#          95th %ile    144.16398
# bin/pipe -E -C 200 -L -S -W -N pipe_tmt4k -s 4k -I 2000 -x tcp -m mt 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_tmt4k     1   1    333.99358          178        0       50 mt  tcp
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    331.53598               331.53598
#                    max    348.13502               337.75678
#                   mean    335.06475               334.15526
#                 median    334.23422               333.99358
#                 stddev      2.83877                 1.23773
#         standard error      0.19974                 0.09277
#   99% confidence level      0.46458                 0.21579
#                   skew      1.95498                 0.30867
#               kurtosis      3.86645                -0.10682
#       time correlation     -0.00501                -0.00072
#
#           elasped time      3.79309
#      number of samples          178
#     number of outliers           24
#      getnsecs overhead          225
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  6    331.00000 |***                                331.71262
#                 27    332.00000 |**************                     332.64247
#                 58    333.00000 |********************************   333.58778
#                 41    334.00000 |**********************             334.51732
#                 34    335.00000 |******************                 335.41001
#                  3    336.00000 |*                                  336.11497
#
#                  9        > 95% |****                               336.93644
#
#        mean of 95%    334.00715
#          95th %ile    336.21566
# bin/pipe -E -C 200 -L -S -W -N pipe_tmp4k -s 4k -I 2000 -x tcp -m mp 
             prc thr   usecs/call      samples   errors cnt/samp md xprt
pipe_tmp4k     1   1    337.33722          197        0       50 mp  tcp
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    332.78042               332.78042
#                    max    368.89178               346.81434
#                   mean    338.15338               337.68117
#                 median    337.39866               337.33722
#                 stddev      4.48462                 3.04867
#         standard error      0.31554                 0.21721
#   99% confidence level      0.73394                 0.50523
#                   skew      3.34665                 0.90011
#               kurtosis     18.25135                 0.61631
#       time correlation      0.00343                 0.00488
#
#           elasped time      4.38059
#      number of samples          197
#     number of outliers            5
#      getnsecs overhead          211
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  1    332.00000 |*                                  332.78042
#                 17    333.00000 |***************                    333.50806
#                 25    334.00000 |**********************             334.60068
#                 17    335.00000 |***************                    335.53498
#                 26    336.00000 |***********************            336.55012
#                 36    337.00000 |********************************   337.46309
#                 24    338.00000 |*********************              338.55898
#                 17    339.00000 |***************                    339.36143
#                  9    340.00000 |********                           340.40239
#                  6    341.00000 |*****                              341.45882
#                  2    342.00000 |*                                  342.56730
#                  6    343.00000 |*****                              343.43258
#                  1    344.00000 |*                                  344.08026
#
#                 10        > 95% |********                           345.59424
#
#        mean of 95%    337.25801
#          95th %ile    344.61786
 
# bin/connection -E -C 200 -L -S -W -N conn_accept -B 256 -a 
             prc thr   usecs/call      samples   errors cnt/samp 
conn_accept    1   1     36.31116          180        0      256 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min     35.68616                35.68616
#                    max     38.56216                36.98016
#                   mean     36.43381                36.29390
#                 median     36.33916                36.31116
#                 stddev      0.47358                 0.24183
#         standard error      0.03332                 0.01803
#   99% confidence level      0.07750                 0.04193
#                   skew      1.71606                 0.10046
#               kurtosis      3.17336                -0.17279
#       time correlation     -0.00069                -0.00061
#
#           elasped time     41.09745
#      number of samples          180
#     number of outliers           22
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                 24     35.00000 |*****                               35.90321
#                147     36.00000 |********************************    36.32687
#
#                  9        > 95% |*                                   36.79728
#
#        mean of 95%     36.26741
#          95th %ile     36.68616
 
# bin/close_tcp -E -C 200 -L -S -W -N close_tcp -B 32 
             prc thr   usecs/call      samples   errors cnt/samp 
close_tcp      1   1    149.58531          202        0       32 
#
# STATISTICS         usecs/call (raw)          usecs/call (outliers removed)
#                    min    114.11331               114.11331
#                    max    193.05731               193.05731
#                   mean    145.87010               145.87010
#                 median    149.58531               149.58531
#                 stddev     17.75649                17.75649
#         standard error      1.24934                 1.24934
#   99% confidence level      2.90597                 2.90597
#                   skew      0.14569                 0.14569
#               kurtosis     -0.71770                -0.71770
#       time correlation      0.01890                 0.01890
#
#           elasped time      5.28183
#      number of samples          202
#     number of outliers            0
#      getnsecs overhead          214
#
# DISTRIBUTION
#	      counts   usecs/call                                         means
#                  8    114.00000 |*****************                  114.94531
#                  3    116.00000 |******                             116.67865
#                  1    118.00000 |**                                 118.64931
#                  2    120.00000 |****                               121.61731
#                  4    122.00000 |********                           122.72731
#                 13    124.00000 |***************************        124.85116
#                  8    126.00000 |*****************                  126.73031
#                 15    128.00000 |********************************   128.94051
#                  6    130.00000 |************                       131.19331
#                  8    132.00000 |*****************                  133.18231
#                  3    134.00000 |******                             134.79598
#                  7    136.00000 |**************                     137.00703
#                  4    138.00000 |********                           138.72131
#                  5    140.00000 |**********                         140.95651
#                  7    142.00000 |**************                     143.04246
#                  3    144.00000 |******                             145.02265
#                  3    146.00000 |******                             146.74265
#                  5    148.00000 |**********                         149.45091
#                  9    150.00000 |*******************                150.70265
#                  8    152.00000 |*****************                  153.26631
#                 13    154.00000 |***************************        155.07147
#                 12    156.00000 |*************************          156.62265
#                  9    158.00000 |*******************                158.67598
#                  9    160.00000 |*******************                160.87865
#                  5    162.00000 |**********                         162.75011
#                  7    164.00000 |**************                     165.37274
#                  9    166.00000 |*******************                167.06887
#                  2    168.00000 |****                               168.94531
#                  3    170.00000 |******                             171.44931
#
#                 11        > 95% |***********************            181.06531
#
#        mean of 95%    143.84316
#          95th %ile    172.18531
 for      5.32092 seconds
````



参考：

https://github.com/redhat-performance/libMicro

https://blog.csdn.net/redrose2100/article/details/129954880