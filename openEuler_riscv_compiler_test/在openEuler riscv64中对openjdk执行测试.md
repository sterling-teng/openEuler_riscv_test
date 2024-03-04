在openEuler riscv64中对使用 Jtreg 对 OpenJDK 执行测试回归测试

#### 1. Jtreg 介绍

jtreg 是 openjdk 测试框架使用的测试工具，该测试框架主要用于单元测试和回归测试。

#### 2. Jtreg 使用方法

##### 2.1 安装

测试环境：使用 [openEuler riscv64 23.09](https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/) 镜像的 QEMU

安装 openjdk17

````
$ yum install -y java-17-openjdk
$ java -version
openjdk version "17.0.8" 2023-07-18
OpenJDK Runtime Environment 21.9 (build 17.0.8+7)
OpenJDK 64-Bit Server VM 21.9 (build 17.0.8+7, mixed mode, sharing)
````

下载对应版本的openjdk源码 https://github.com/openjdk/jdk17u-dev/releases/tag/jdk-17.0.8%2B7，并解压

````
$ wget https://github.com/openjdk/jdk17u-dev/archive/refs/tags/jdk-17.0.8+7.zip
$ unzip jdk-17.0.8+7.zip
$ ls jdk17u-dev-jdk-17.0.8-7/test
failure_handler  jaxp  jtreg-ext  lib       make
hotspot          jdk   langtools  lib-test  micro
````

测试用例在源码根目录下的 test 目录下

由于 jtreg 是跨平台的，所以可以直接下载编译好的对应版本的 [jtreg](https://builds.shipilev.net/jtreg/)，并解压

````
$ wget https://builds.shipilev.net/jtreg/jtreg-7.3.1%2B1.zip
$ unzip jtreg-7.3.1+1.zip
````

设置环境变量

````
$ export JAVA_HOME=$(ls -lr $(ls -lr /usr/bin/java | awk '{print $NF}') |awk '{print $NF}' | awk -F/ '{print $1"/"$2"/"$3"/"$4"/"$5}')     //path/to/JDK
$ export PATH=$JAVA_HOME/bin:$PATH
$ export JT_HOME=$(pwd)/jtreg      //path/to/jtreg
$ export PATH=$JT_HOME/bin:$PATH
````

安装测试所需软件包

````
$ yum install -y git subversion screen samba samba-client gcc gdb cmake automake lrzsz expect libX11* libxt* libXtst* libXt* libXrender* cache* cups* unzip* zip* freetype* mercurial numactl vim tar dejavu-fonts unix2dos dos2unix bc lsof net-tools
````

执行一个测试用例

````
$ jtreg -va jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java
Directory "JTwork" not found: creating
Directory "JTreport" not found: creating
Error: Compilation of extra property definition files failed.
````

无法正常执行测试

下载一个编译好的 [riscv64 openjdk 17](https://builds.shipilev.net/openjdk-jdk17-dev/)，测试相同的测试用例：

````
$ wget https://builds.shipilev.net/openjdk-jdk17-dev/openjdk-jdk17-dev-linux-riscv64-server-release-gcc12-glibc2.36.tar.xz
$ tar -xvf openjdk-jdk17-dev-linux-riscv64-server-release-gcc12-glibc2.36.tar.xz
$ /root/jtreg/bin/jtreg -jdk:/root/jdk -va /root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java
failed to get value for vm.cds.archived.java.heap
java.lang.UnsatisfiedLinkError: 'boolean jdk.test.whitebox.WhiteBox.isJavaHeapArchiveSupported()'
        at jdk.test.whitebox.WhiteBox.isJavaHeapArchiveSupported(Native Method)
        at requires.VMProps.vmCDSForArchivedJavaHeap(VMProps.java:394)
        at requires.VMProps$SafeMap.put(VMProps.java:72)
        at requires.VMProps.call(VMProps.java:114)
        at requires.VMProps.call(VMProps.java:60)
        at com.sun.javatest.regtest.agent.GetJDKProperties.run(GetJDKProperties.java:80)
        at com.sun.javatest.regtest.agent.GetJDKProperties.main(GetJDKProperties.java:54)
--------------------------------------------------
TEST: gc/g1/TestLargePageUseForAuxMemory.java
TEST JDK: /root/jdk

ACTION: build -- Passed. All files up to date
REASON: User specified action: run build sun.hotspot.WhiteBox 
TIME:   0.039 seconds
messages:
command: build sun.hotspot.WhiteBox
reason: User specified action: run build sun.hotspot.WhiteBox 
started: Mon Mar 04 16:20:23 CST 2024
finished: Mon Mar 04 16:20:23 CST 2024
elapsed time (seconds): 0.039

ACTION: build -- Passed. All files up to date
REASON: Named class compiled on demand
TIME:   0.005 seconds
messages:
command: build jdk.test.lib.helpers.ClassFileInstaller
reason: Named class compiled on demand
started: Mon Mar 04 16:20:23 CST 2024
finished: Mon Mar 04 16:20:23 CST 2024
elapsed time (seconds): 0.005

ACTION: driver -- Passed. Execution successful
REASON: User specified action: run driver jdk.test.lib.helpers.ClassFileInstaller sun.hotspot.WhiteBox 
TIME:   5.581 seconds
messages:
command: driver jdk.test.lib.helpers.ClassFileInstaller sun.hotspot.WhiteBox
reason: User specified action: run driver jdk.test.lib.helpers.ClassFileInstaller sun.hotspot.WhiteBox 
started: Mon Mar 04 16:20:23 CST 2024
Mode: othervm
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
finished: Mon Mar 04 16:20:28 CST 2024
elapsed time (seconds): 5.581
configuration:
Boot Layer
  add modules: java.base                   
  add exports: java.base/jdk.internal.misc ALL-UNNAMED

STDOUT:
STDERR:
STATUS:Passed.
rerun:
cd /root/JTwork/scratch && \
HOME=/root \
LANG=C.UTF-8 \
PATH=/bin:/usr/bin:/usr/sbin \
CLASSPATH=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar \
    /root/jdk/bin/java \
        -Dtest.vm.opts= \
        -Dtest.tool.vm.opts= \
        -Dtest.compiler.opts= \
        -Dtest.java.opts= \
        -Dtest.jdk=/root/jdk \
        -Dcompile.jdk=/root/jdk \
        -Dtest.timeout.factor=1.0 \
        -Dtest.root=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg \
        -Dtest.name=gc/g1/TestLargePageUseForAuxMemory.java \
        -Dtest.file=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java \
        -Dtest.src=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 \
        -Dtest.src.path=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/jdk17u-dev-jdk-17.0.8-7/test/lib \
        -Dtest.classes=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d \
        -Dtest.class.path=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/JTwork/classes/test/lib \
        -Dtest.modules=java.base/jdk.internal.misc \
        --add-modules java.base \
        --add-exports java.base/jdk.internal.misc=ALL-UNNAMED \
        com.sun.javatest.regtest.agent.MainWrapper /root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/driver.0.jta sun.hotspot.WhiteBox

ACTION: build -- Passed. All files up to date
REASON: Named class compiled on demand
TIME:   0.003 seconds
messages:
command: build gc.g1.TestLargePageUseForAuxMemory
reason: Named class compiled on demand
started: Mon Mar 04 16:20:28 CST 2024
finished: Mon Mar 04 16:20:28 CST 2024
elapsed time (seconds): 0.003

ACTION: main -- Passed. Execution successful
REASON: User specified action: run main/othervm -Xbootclasspath/a:. -XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -XX:+IgnoreUnrecognizedVMOptions -XX:+UseLargePages gc.g1.TestLargePageUseForAuxMemory 
TIME:   38.397 seconds
messages:
command: main -Xbootclasspath/a:. -XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -XX:+IgnoreUnrecognizedVMOptions -XX:+UseLargePages gc.g1.TestLargePageUseForAuxMemory
reason: User specified action: run main/othervm -Xbootclasspath/a:. -XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -XX:+IgnoreUnrecognizedVMOptions -XX:+UseLargePages gc.g1.TestLargePageUseForAuxMemory 
started: Mon Mar 04 16:20:28 CST 2024
Mode: othervm [/othervm specified]
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
finished: Mon Mar 04 16:21:07 CST 2024
elapsed time (seconds): 38.397
configuration:
Boot Layer
  add modules: java.base                   
  add exports: java.base/jdk.internal.misc ALL-UNNAMED

STDOUT:
[0.075s][warning][pagesize] UseLargePages disabled, no large pages configured and available on the system.
Warning: 'NoSuchMethodError' on register of sun.hotspot.WhiteBox::canWriteJavaHeapArchive()Z
Warning: 'NoSuchMethodError' on register of sun.hotspot.WhiteBox::hostPhysicalMemory()J
Warning: 'NoSuchMethodError' on register of sun.hotspot.WhiteBox::hostPhysicalSwap()J
Warning: 'NoSuchMethodError' on register of sun.hotspot.WhiteBox::preTouchMemory(JJ)V
Warning: 'NoSuchMethodError' on register of sun.hotspot.WhiteBox::cleanMetaspaces()V
case1: card table and bitmap use large pages (barely) heapsize 1073741824 card table should use large pages true bitmaps should use large pages true
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1073741824 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:35.221406173Z] Gathering output for process 2306
[2024-03-04T08:20:37.451320932Z] Waiting for completion for process 2306
[2024-03-04T08:20:37.452770363Z] Waiting for completion finished for process 2306
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1073741824 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:37.511657768Z] Gathering output for process 2327
[2024-03-04T08:20:40.117313094Z] Waiting for completion for process 2327
[2024-03-04T08:20:40.118979715Z] Waiting for completion finished for process 2327
case2: card table and bitmap use large pages (extra slack) heapsize 1075838976 card table should use large pages true bitmaps should use large pages true
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1075838976 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:40.180278605Z] Gathering output for process 2347
[2024-03-04T08:20:42.865750943Z] Waiting for completion for process 2347
[2024-03-04T08:20:42.866974285Z] Waiting for completion finished for process 2347
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1075838976 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:42.941810433Z] Gathering output for process 2367
[2024-03-04T08:20:45.618944365Z] Waiting for completion for process 2367
[2024-03-04T08:20:45.620191706Z] Waiting for completion finished for process 2367
case3: only bitmap uses large pages (barely not) heapsize 1071644672 card table should use large pages false bitmaps should use large pages true
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1071644672 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:45.694391284Z] Gathering output for process 2387
[2024-03-04T08:20:48.307166672Z] Waiting for completion for process 2387
[2024-03-04T08:20:48.310422118Z] Waiting for completion finished for process 2387
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1071644672 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:48.387330567Z] Gathering output for process 2407
[2024-03-04T08:20:50.881756072Z] Waiting for completion for process 2407
[2024-03-04T08:20:50.883151706Z] Waiting for completion finished for process 2407
case4: only bitmap uses large pages (barely) heapsize 134217728 card table should use large pages false bitmaps should use large pages true
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx134217728 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:50.965680989Z] Gathering output for process 2427
[2024-03-04T08:20:53.419099240Z] Waiting for completion for process 2427
[2024-03-04T08:20:53.420373480Z] Waiting for completion finished for process 2427
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx134217728 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:53.472156222Z] Gathering output for process 2447
[2024-03-04T08:20:56.390361913Z] Waiting for completion for process 2447
[2024-03-04T08:20:56.397741562Z] Waiting for completion finished for process 2447
case5: only bitmap uses large pages (extra slack) heapsize 136314880 card table should use large pages false bitmaps should use large pages true
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx136314880 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:56.512172131Z] Gathering output for process 2467
[2024-03-04T08:20:59.182289797Z] Waiting for completion for process 2467
[2024-03-04T08:20:59.183521338Z] Waiting for completion finished for process 2467
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx136314880 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:20:59.256483875Z] Gathering output for process 2487
[2024-03-04T08:21:01.748155011Z] Waiting for completion for process 2487
[2024-03-04T08:21:01.749989724Z] Waiting for completion finished for process 2487
case6: nothing uses large pages (barely not) heapsize 132120576 card table should use large pages false bitmaps should use large pages false
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx132120576 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:21:01.815106233Z] Gathering output for process 2507
[2024-03-04T08:21:04.430249909Z] Waiting for completion for process 2507
[2024-03-04T08:21:04.432989878Z] Waiting for completion finished for process 2507
Command line: [/root/jdk/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx132120576 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-04T08:21:04.491518800Z] Gathering output for process 2527
[2024-03-04T08:21:07.092143265Z] Waiting for completion for process 2527
[2024-03-04T08:21:07.094321961Z] Waiting for completion finished for process 2527
STDERR:
STATUS:Passed.
rerun:
cd /root/JTwork/scratch && \
HOME=/root \
LANG=C.UTF-8 \
PATH=/bin:/usr/bin:/usr/sbin \
CLASSPATH=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar \
    /root/jdk/bin/java \
        -Dtest.vm.opts= \
        -Dtest.tool.vm.opts= \
        -Dtest.compiler.opts= \
        -Dtest.java.opts= \
        -Dtest.jdk=/root/jdk \
        -Dcompile.jdk=/root/jdk \
        -Dtest.timeout.factor=1.0 \
        -Dtest.root=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg \
        -Dtest.name=gc/g1/TestLargePageUseForAuxMemory.java \
        -Dtest.file=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java \
        -Dtest.src=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 \
        -Dtest.src.path=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/jdk17u-dev-jdk-17.0.8-7/test/lib \
        -Dtest.classes=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d \
        -Dtest.class.path=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/JTwork/classes/test/lib \
        -Dtest.modules=java.base/jdk.internal.misc \
        --add-modules java.base \
        --add-exports java.base/jdk.internal.misc=ALL-UNNAMED \
        -Xbootclasspath/a:. \
        -XX:+UseG1GC \
        -XX:+UnlockDiagnosticVMOptions \
        -XX:+WhiteBoxAPI \
        -XX:+IgnoreUnrecognizedVMOptions \
        -XX:+UseLargePages \
        com.sun.javatest.regtest.agent.MainWrapper /root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/main.1.jta

TEST RESULT: Passed. Execution successful
--------------------------------------------------
Test results: passed: 1
Report written to /root/JTreport/html/report.html
Results written to /root/JTwork
````

JTreport 和 JTwork文件夹将在用例执行完成后生成，执行日志将存放在JTwork目录下的.jtr文件中，统计结果将存放在JTreport目录下的.html文件中

如果要执行一个测试套

````
$ /root/jtreg/bin/jtreg -jdk:/root/jdk -va /root/jdk17u-dev-jdk-17.0.8-7/test/langtools:tier1
````

jdk的测试分了4个层次：

tier1：最基本的测试层次，这个层次的测试包括 HotSpot、java.base 模块中的核心 API 和 javac 编译器的测试。这些测试都经过精心挑选和优化，可以快速运行，并以最稳定的方式运行。测试失败通常会快速跟进，要么修复，要么将相关测试添加到问题列表中。GitHub Actions 工作流程（如果启用）将运行第 1 层测试。

tier2：这个测试组涵盖了更多的领域。 除其他外，其中包含运行时间太长而无法在 tier1 运行的测试，或者可能需要特殊配置的测试，或者不太稳定的测试，或者涵盖更广泛的非核心 JVM 和 JDK 功能的测试

tier3：该测试组包括压力更大的测试、先前层未涵盖的极端情况的测试以及需要 GUI 的测试。 因此，该套件应该以低并发运行 (TEST_JOBS=1)，或者不进行 headful 测试 (JTREG_KEYWORDS=\!headful)，或者两者兼而有之。

tier4：该测试组包括之前各层未涵盖的所有其他测试。 例如，它包括适用于 Hotspot 的 vmTestbase 套件，即使在大型计算机上也可以运行多个小时。 它还运行 GUI 测试，因此同样的 TEST_JOBS 和 JTREG_KEYWORDS 警告也适用。

执行多个测试套

````
$ /root/jtreg/bin/jtreg -jdk:/root/jdk -va jdk17u-dev-jdk-17.0.8-7/test/jdk:tier1 jdk17u-dev-jdk-17.0.8-7/test/jaxp:tier1 jdk17u-dev-jdk-17.0.8-7/test/lib-test:tier1
````





参考：

https://openjdk.org/jtreg/build.html

https://github.com/openjdk/jtreg

https://openjdk.org/groups/build/doc/testing.html

https://github.com/openjdk/jdk17u-dev

https://gitee.com/openeuler/compiler-test/blob/master/jtreg+jcstress.md

[测试能力执行指南](https://gitee.com/openeuler/QA/blob/master/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97.md#107jdk)

