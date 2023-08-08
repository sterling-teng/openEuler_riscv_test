### 在openEuler riscv64中使用stream进行内存带宽的性能测试

#### 1. stream介绍

stream是内存带宽性能测试的基准工具，它支持复制（Copy）、尺寸变换（Scale）、矢量求和（Add）、复合矢量求和（Triad）四种运算方式测试内存带宽的性能

Copy：最简单的操作，即从一个内存单元中读取一个数，并复制到另一个内存单元，有2次访存操作

Scale：乘法操作，从一个内存单元中读取一个数，与常数scale相乘，得到的结果写入另一个内存单元，有2次访存

Add：加法操作，从两个内存单元中分别读取两个数，将其进行加法操作，得到的结果写入另一个内存单元中，有2次读和1次写共3次访存

Triad：前面三种的结合，先从内存中读取一个数，与scale相乘得到一个乘积，然后从另一个内存单元中读取一个数与之前的乘积相加，得到的结果再写入内存。所以，有2次读和1次写共3次访存操作

#### 2. 在openEuler riscv64中使用stream

硬件环境：D1开发板烧入openEuler riscv64 22.03 v2 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/D1/

##### 2.1 stream安装编译

从官网下载源码

````
$ wget https://www.cs.virginia.edu/stream/FTP/Code/stream.c
````

 单线程编译

````
$ gcc -O3 -DSTREAM_ARRAY_SIZE=10000000 -DNTIMES=30 stream.c -o stream
````

多线程编译(一般采用多线程编译)

````
$ gcc -O3 -fopenmp -DSTREAM_ARRAY_SIZE=10000000 -DNTIMES=30 stream.c -o stream
````

参数说明：

-O3：编译器编译优化级别设置为最高级别3

-fopenmp：启用OpenMP, 适应多处理器环境，更能得到内存带宽实际最大值。开启后，程序默认运行线程为CPU线程数。也可以运行时动态指定运行的线程数。

-DSTREAM_ARRAY_SIZE：指定测试数组大小，这个参数对测试结果影响较大，默认值是10000000，这个值可以由公式计算出：最高级缓存（单位：MB)x1024x1024x4.1xCPU路数/8，结果取整。例如：测试机器是双路CPU，最高级缓存32MB，则计算值为32×1024×1024×4.1×2/8≈34393292

最高级缓存和cpu路数可以从通过执行命令lscpu查到

````
$ lscpu
Architecture:           riscv64
  CPU op-mode(s):       32-bit, 64-bit
  Address sizes:        46 bits physical, 57 bits virtual
  Byte Order:           Little Endian
CPU(s):                 2
  On-line CPU(s) list:  0,1
Vendor ID:              GenuineIntel
  Model name:           Intel(R) Xeon(R) Platinum 8369B CPU @ 2.70GHz
    CPU family:         6
    Model:              106
    Thread(s) per core: 2
    Core(s) per socket: 1
    Socket(s):          1
    Stepping:           6
    BogoMIPS:           5399.99
    Flags:              fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ss ht syscall nx pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_ts
                        c cpuid tsc_known_freq pni pclmulqdq monitor ssse3 fma cx16 pcid sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand hypervisor lahf_lm abm 3dnowprefetch cpuid_fa
                        ult invpcid_single ibrs_enhanced fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid avx512f avx512dq rdseed adx smap avx512ifma clflushopt clwb avx512cd sha_ni avx512bw
                         avx512vl xsaveopt xsavec xgetbv1 xsaves wbnoinvd arat avx512vbmi pku ospke avx512_vbmi2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg avx512_vpopcntdq rdpid arch_capabi
                        lities
Caches (sum of all):    
  L1d:                  48 KiB (1 instance)
  L1i:                  32 KiB (1 instance)
  L2:                   1.3 MiB (1 instance)
  L3:                   48 MiB (1 instance)
NUMA:                   
  NUMA node(s):         1
  NUMA node0 CPU(s):    0,1
Vulnerabilities:        
  Itlb multihit:        Not affected
  L1tf:                 Not affected
  Mds:                  Not affected
  Meltdown:             Not affected
  Mmio stale data:      Vulnerable: Clear CPU buffers attempted, no microcode; SMT Host state unknown
  Spec store bypass:    Vulnerable
  Spectre v1:           Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:           Mitigation; Enhanced IBRS, RSB filling
  Srbds:                Not affected
  Tsx async abort:      Not affected
````

其中Socket(s)显示的是CPU路数，最高级缓存一般是L3 Cache

也可以通过以下命令查询到CPU路数和最高缓存：

````
$ cat /proc/cpuinfo |grep 'physical id'|sort -u|wc -l   //查询CPU路数
1
````

````
$ root@9a3ad9248030:/home/stream# cat /sys/devices/system/cpu/cpu0/cache/index3/size
49152K
````

-DNTIMES：执行的次数，默认值是10，所有测试结束后从结果中选取最优值

stream.c：待编译的源码文件

stream：输出的可执行文件

##### 2.2 stream运行

运行stream前可以通过 export OMP_NUM_THREADS=n 来指定运行的线程数为n

运行stream

````
$ ./stream
````

运行结果

````
$ ./stream 
-------------------------------------------------------------
STREAM version $Revision: 5.10 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Array size = 10000000 (elements), Offset = 0 (elements)
Memory per array = 76.3 MiB (= 0.1 GiB).
Total memory required = 228.9 MiB (= 0.2 GiB).
Each kernel will be executed 30 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
-------------------------------------------------------------
Number of Threads requested = 1
Number of Threads counted = 1
-------------------------------------------------------------
Your clock granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 88562 microseconds.
   (= 88562 clock ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 clock ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:            2647.8     0.060520     0.060427     0.060832
Scale:           1833.4     0.087498     0.087268     0.089030
Add:             2109.7     0.114164     0.113760     0.116661
Triad:           2072.6     0.115989     0.115795     0.116595
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
````

测试结果显示了每项测试的最高速率，平均响应时间，最短响应时间，最长响应时间。

参考：https://www.cs.virginia.edu/stream/ref.html#start