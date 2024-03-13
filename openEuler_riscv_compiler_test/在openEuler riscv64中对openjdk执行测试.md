在openEuler riscv64中对使用 Jtreg 对 OpenJDK 执行测试回归测试

#### 1. Jtreg 介绍

jtreg 全称 Java Test Registry，是 openjdk 测试框架使用的测试工具，该测试框架主要用于单元测试和回归测试。

#### 2. Jtreg 使用方法

##### 2.1 安装

测试环境：使用 [openEuler riscv64 23.09](https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.09-V1-riscv64/QEMU/) 镜像的 QEMU

安装 openjdk17

````
$ yum install -y java-17-openjdk*
$ java -version
openjdk version "17.0.8" 2023-07-18
OpenJDK Runtime Environment 21.9 (build 17.0.8+7)
OpenJDK 64-Bit Server VM 21.9 (build 17.0.8+7, mixed mode, sharing)
````

下载对应版本的openjdk源码 https://github.com/openjdk/jdk17u-dev/releases/tag/jdk-17.0.8%2B7， 并解压

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
##### 2.2 执行测试
执行一个测试用例

````
$ jtreg -va jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java
--------------------------------------------------
TEST: gc/g1/TestLargePageUseForAuxMemory.java
TEST JDK: /usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64

ACTION: build -- Passed. Build successful
REASON: User specified action: run build sun.hotspot.WhiteBox 
TIME:   31.706 seconds
messages:
command: build sun.hotspot.WhiteBox
reason: User specified action: run build sun.hotspot.WhiteBox 
started: Wed Mar 13 19:29:37 CST 2024
Library /test/lib:
  compile: sun.hotspot.WhiteBox
finished: Wed Mar 13 19:30:09 CST 2024
elapsed time (seconds): 31.706

ACTION: compile -- Passed. Compilation successful
REASON: .class file out of date or does not exist
TIME:   31.548 seconds
messages:
command: compile /root/jdk17u-dev-jdk-17.0.8-7/test/lib/sun/hotspot/WhiteBox.java
reason: .class file out of date or does not exist
started: Wed Mar 13 19:29:37 CST 2024
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
Mode: othervm
finished: Wed Mar 13 19:30:09 CST 2024
elapsed time (seconds): 31.548
configuration:
javac compilation environment
  add modules: java.base                   
  add exports: java.base/jdk.internal.misc ALL-UNNAMED
  source path: /root/jdk17u-dev-jdk-17.0.8-7/test/lib 
  class path:  /root/JTwork/classes/test/lib 

rerun:
cd /root/JTwork/scratch && \
HOME=/root \
LANG=C.UTF-8 \
PATH=/bin:/usr/bin:/usr/sbin \
    /usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/javac \
        -J-Dtest.vm.opts= \
        -J-Dtest.tool.vm.opts= \
        -J-Dtest.compiler.opts= \
        -J-Dtest.java.opts= \
        -J-Dtest.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -J-Dcompile.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -J-Dtest.timeout.factor=1.0 \
        -J-Dtest.root=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg \
        -J-Dtest.name=gc/g1/TestLargePageUseForAuxMemory.java \
        -J-Dtest.file=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java \
        -J-Dtest.src=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 \
        -J-Dtest.src.path=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/jdk17u-dev-jdk-17.0.8-7/test/lib \
        -J-Dtest.classes=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d \
        -J-Dtest.class.path=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/JTwork/classes/test/lib \
        -J-Dtest.modules=java.base/jdk.internal.misc \
        @/root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/compile.0.jta
STDOUT:
STDERR:

ACTION: build -- Passed. Build successful
REASON: Named class compiled on demand
TIME:   25.784 seconds
messages:
command: build jdk.test.lib.helpers.ClassFileInstaller
reason: Named class compiled on demand
started: Wed Mar 13 19:30:09 CST 2024
Library /test/lib:
  compile: jdk.test.lib.helpers.ClassFileInstaller
finished: Wed Mar 13 19:30:35 CST 2024
elapsed time (seconds): 25.784

ACTION: compile -- Passed. Compilation successful
REASON: .class file out of date or does not exist
TIME:   25.749 seconds
messages:
command: compile /root/jdk17u-dev-jdk-17.0.8-7/test/lib/jdk/test/lib/helpers/ClassFileInstaller.java
reason: .class file out of date or does not exist
started: Wed Mar 13 19:30:09 CST 2024
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
Mode: othervm
finished: Wed Mar 13 19:30:35 CST 2024
elapsed time (seconds): 25.749
configuration:
javac compilation environment
  add modules: java.base                   
  add exports: java.base/jdk.internal.misc ALL-UNNAMED
  source path: /root/jdk17u-dev-jdk-17.0.8-7/test/lib 
  class path:  /root/JTwork/classes/test/lib 

rerun:
cd /root/JTwork/scratch && \
HOME=/root \
LANG=C.UTF-8 \
PATH=/bin:/usr/bin:/usr/sbin \
    /usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/javac \
        -J-Dtest.vm.opts= \
        -J-Dtest.tool.vm.opts= \
        -J-Dtest.compiler.opts= \
        -J-Dtest.java.opts= \
        -J-Dtest.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -J-Dcompile.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -J-Dtest.timeout.factor=1.0 \
        -J-Dtest.root=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg \
        -J-Dtest.name=gc/g1/TestLargePageUseForAuxMemory.java \
        -J-Dtest.file=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java \
        -J-Dtest.src=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 \
        -J-Dtest.src.path=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/jdk17u-dev-jdk-17.0.8-7/test/lib \
        -J-Dtest.classes=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d \
        -J-Dtest.class.path=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/JTwork/classes/test/lib \
        -J-Dtest.modules=java.base/jdk.internal.misc \
        @/root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/compile.1.jta
STDOUT:
STDERR:

ACTION: driver -- Passed. Execution successful
REASON: User specified action: run driver jdk.test.lib.helpers.ClassFileInstaller sun.hotspot.WhiteBox 
TIME:   4.672 seconds
messages:
command: driver jdk.test.lib.helpers.ClassFileInstaller sun.hotspot.WhiteBox
reason: User specified action: run driver jdk.test.lib.helpers.ClassFileInstaller sun.hotspot.WhiteBox 
started: Wed Mar 13 19:30:35 CST 2024
Mode: othervm
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
finished: Wed Mar 13 19:30:39 CST 2024
elapsed time (seconds): 4.672
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
CLASSPATH=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar \
    /usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java \
        -Dtest.vm.opts= \
        -Dtest.tool.vm.opts= \
        -Dtest.compiler.opts= \
        -Dtest.java.opts= \
        -Dtest.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -Dcompile.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
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
        com.sun.javatest.regtest.agent.MainWrapper /root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/driver.2.jta sun.hotspot.WhiteBox

ACTION: build -- Passed. Build successful
REASON: Named class compiled on demand
TIME:   50.857 seconds
messages:
command: build gc.g1.TestLargePageUseForAuxMemory
reason: Named class compiled on demand
started: Wed Mar 13 19:30:39 CST 2024
Test directory:
  compile: gc.g1.TestLargePageUseForAuxMemory
finished: Wed Mar 13 19:31:30 CST 2024
elapsed time (seconds): 50.857

ACTION: compile -- Passed. Compilation successful
REASON: .class file out of date or does not exist
TIME:   50.826 seconds
messages:
command: compile /root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java
reason: .class file out of date or does not exist
started: Wed Mar 13 19:30:39 CST 2024
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
Mode: othervm
finished: Wed Mar 13 19:31:30 CST 2024
elapsed time (seconds): 50.826
configuration:
javac compilation environment
  add modules: java.base                   
  add exports: java.base/jdk.internal.misc ALL-UNNAMED
  source path: /root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 
               /root/jdk17u-dev-jdk-17.0.8-7/test/lib 
  class path:  /root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 
               /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d 
               /root/JTwork/classes/test/lib 

rerun:
cd /root/JTwork/scratch && \
HOME=/root \
LANG=C.UTF-8 \
PATH=/bin:/usr/bin:/usr/sbin \
    /usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/javac \
        -J-Dtest.vm.opts= \
        -J-Dtest.tool.vm.opts= \
        -J-Dtest.compiler.opts= \
        -J-Dtest.java.opts= \
        -J-Dtest.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -J-Dcompile.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -J-Dtest.timeout.factor=1.0 \
        -J-Dtest.root=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg \
        -J-Dtest.name=gc/g1/TestLargePageUseForAuxMemory.java \
        -J-Dtest.file=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java \
        -J-Dtest.src=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1 \
        -J-Dtest.src.path=/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/jdk17u-dev-jdk-17.0.8-7/test/lib \
        -J-Dtest.classes=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d \
        -J-Dtest.class.path=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/JTwork/classes/test/lib \
        -J-Dtest.modules=java.base/jdk.internal.misc \
        @/root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/compile.3.jta
STDOUT:
STDERR:
/root/jdk17u-dev-jdk-17.0.8-7/test/lib/jdk/test/lib/process/ProcessTools.java:450: warning: [removal] AccessController in java.security has been deprecated and marked for removal
                AccessController.doPrivileged((PrivilegedExceptionAction<Void>) () -> {
                ^
/root/jdk17u-dev-jdk-17.0.8-7/test/lib/jdk/test/lib/process/ProcessTools.java:605: warning: [removal] AccessController in java.security has been deprecated and marked for removal
            return AccessController.doPrivileged(
                   ^
/root/jdk17u-dev-jdk-17.0.8-7/test/lib/jdk/test/lib/NetworkConfiguration.java:466: warning: [removal] AccessController in java.security has been deprecated and marked for removal
        AccessController.doPrivileged(pa);
        ^
Note: /root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1/TestLargePageUseForAuxMemory.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
3 warnings

ACTION: main -- Passed. Execution successful
REASON: User specified action: run main/othervm -Xbootclasspath/a:. -XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -XX:+IgnoreUnrecognizedVMOptions -XX:+UseLargePages gc.g1.TestLargePageUseForAuxMemory 
TIME:   37.819 seconds
messages:
command: main -Xbootclasspath/a:. -XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -XX:+IgnoreUnrecognizedVMOptions -XX:+UseLargePages gc.g1.TestLargePageUseForAuxMemory
reason: User specified action: run main/othervm -Xbootclasspath/a:. -XX:+UseG1GC -XX:+UnlockDiagnosticVMOptions -XX:+WhiteBoxAPI -XX:+IgnoreUnrecognizedVMOptions -XX:+UseLargePages gc.g1.TestLargePageUseForAuxMemory 
started: Wed Mar 13 19:31:30 CST 2024
Mode: othervm [/othervm specified]
Additional options from @modules: --add-modules java.base --add-exports java.base/jdk.internal.misc=ALL-UNNAMED
finished: Wed Mar 13 19:32:08 CST 2024
elapsed time (seconds): 37.819
configuration:
Boot Layer
  add modules: java.base                   
  add exports: java.base/jdk.internal.misc ALL-UNNAMED

STDOUT:
[0.051s][warning][pagesize] UseLargePages disabled, no large pages configured and available on the system.
case1: card table and bitmap use large pages (barely) heapsize 1073741824 card table should use large pages true bitmaps should use large pages true
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1073741824 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:36.744446361Z] Gathering output for process 1206
[2024-03-13T11:31:39.087354551Z] Waiting for completion for process 1206
[2024-03-13T11:31:39.096539133Z] Waiting for completion finished for process 1206
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1073741824 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:39.158026487Z] Gathering output for process 1227
[2024-03-13T11:31:41.520757555Z] Waiting for completion for process 1227
[2024-03-13T11:31:41.524157586Z] Waiting for completion finished for process 1227
case2: card table and bitmap use large pages (extra slack) heapsize 1075838976 card table should use large pages true bitmaps should use large pages true
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1075838976 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:41.589962078Z] Gathering output for process 1247
[2024-03-13T11:31:44.156669683Z] Waiting for completion for process 1247
[2024-03-13T11:31:44.158718301Z] Waiting for completion finished for process 1247
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1075838976 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:44.222991080Z] Gathering output for process 1267
[2024-03-13T11:31:46.643103665Z] Waiting for completion for process 1267
[2024-03-13T11:31:46.646953899Z] Waiting for completion finished for process 1267
case3: only bitmap uses large pages (barely not) heapsize 1071644672 card table should use large pages false bitmaps should use large pages true
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1071644672 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:46.723329687Z] Gathering output for process 1287
[2024-03-13T11:31:49.162798146Z] Waiting for completion for process 1287
[2024-03-13T11:31:49.184519224Z] Waiting for completion finished for process 1287
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx1071644672 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:49.260938251Z] Gathering output for process 1307
[2024-03-13T11:31:51.976809627Z] Waiting for completion for process 1307
[2024-03-13T11:31:51.982655574Z] Waiting for completion finished for process 1307
case4: only bitmap uses large pages (barely) heapsize 134217728 card table should use large pages false bitmaps should use large pages true
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx134217728 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:52.038937336Z] Gathering output for process 1327
[2024-03-13T11:31:54.688757570Z] Waiting for completion for process 1327
[2024-03-13T11:31:54.700195964Z] Waiting for completion finished for process 1327
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx134217728 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:54.759944254Z] Gathering output for process 1347
[2024-03-13T11:31:57.262947784Z] Waiting for completion for process 1347
[2024-03-13T11:31:57.266670815Z] Waiting for completion finished for process 1347
case5: only bitmap uses large pages (extra slack) heapsize 136314880 card table should use large pages false bitmaps should use large pages true
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx136314880 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:57.331113143Z] Gathering output for process 1367
[2024-03-13T11:31:59.858718275Z] Waiting for completion for process 1367
[2024-03-13T11:31:59.860485289Z] Waiting for completion finished for process 1367
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx136314880 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:31:59.921015086Z] Gathering output for process 1387
[2024-03-13T11:32:02.948572418Z] Waiting for completion for process 1387
[2024-03-13T11:32:02.962704834Z] Waiting for completion finished for process 1387
case6: nothing uses large pages (barely not) heapsize 132120576 card table should use large pages false bitmaps should use large pages false
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx132120576 -Xlog:pagesize,gc+init,gc+heap+coops=debug -XX:+UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:32:03.061501745Z] Gathering output for process 1407
[2024-03-13T11:32:05.623769961Z] Waiting for completion for process 1407
[2024-03-13T11:32:05.627111488Z] Waiting for completion finished for process 1407
Command line: [/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java -cp /root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar -XX:+UseG1GC -XX:G1HeapRegionSize=1048576 -Xmx132120576 -Xlog:pagesize -XX:-UseLargePages -XX:+IgnoreUnrecognizedVMOptions -XX:ObjectAlignmentInBytes=8 -version ]
[2024-03-13T11:32:05.741787029Z] Gathering output for process 1427
[2024-03-13T11:32:08.343663070Z] Waiting for completion for process 1427
[2024-03-13T11:32:08.344823479Z] Waiting for completion finished for process 1427
STDERR:
STATUS:Passed.
rerun:
cd /root/JTwork/scratch && \
HOME=/root \
LANG=C.UTF-8 \
PATH=/bin:/usr/bin:/usr/sbin \
CLASSPATH=/root/JTwork/classes/gc/g1/TestLargePageUseForAuxMemory.d:/root/jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg/gc/g1:/root/JTwork/classes/test/lib:/root/jdk17u-dev-jdk-17.0.8-7/test/lib:/root/jtreg/lib/javatest.jar:/root/jtreg/lib/jtreg.jar \
    /usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64/bin/java \
        -Dtest.vm.opts= \
        -Dtest.tool.vm.opts= \
        -Dtest.compiler.opts= \
        -Dtest.java.opts= \
        -Dtest.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
        -Dcompile.jdk=/usr/lib/jvm/java-17-openjdk-17.0.8.7-2.oe2309.riscv64 \
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
        com.sun.javatest.regtest.agent.MainWrapper /root/JTwork/gc/g1/TestLargePageUseForAuxMemory.d/main.4.jta

TEST RESULT: Passed. Execution successful
--------------------------------------------------
Test results: passed: 1
Report written to /root/JTreport/html/report.html
Results written to /root/JTwork
````

JTreport 和 JTwork文件夹将在用例执行完成后生成，执行日志将存放在JTwork目录下的.jtr文件中，统计结果将存放在JTreport目录下的.html文件中

如果要执行一个测试套jdk17u-dev-jdk-17.0.8-7

````
$ jtreg -va /root/jdk17u-dev-jdk-17.0.8-7/test/langtools:tier1
````

jdk的测试分了4个层次：

tier1：最基本的测试层次，这个层次的测试包括 HotSpot、java.base 模块中的核心 API 和 javac 编译器的测试。这些测试都经过精心挑选和优化，可以快速运行，并以最稳定的方式运行。测试失败通常会快速跟进，要么修复，要么将相关测试添加到问题列表中。GitHub Actions 工作流程（如果启用）将运行第 1 层测试。

tier2：这个测试组涵盖了更多的领域。 除其他外，其中包含运行时间太长而无法在 tier1 运行的测试，或者可能需要特殊配置的测试，或者不太稳定的测试，或者涵盖更广泛的非核心 JVM 和 JDK 功能的测试

tier3：该测试组包括压力更大的测试、先前层未涵盖的极端情况的测试以及需要 GUI 的测试。 因此，该套件应该以低并发运行 (TEST_JOBS=1)，或者不进行 headful 测试 (JTREG_KEYWORDS=\!headful)，或者两者兼而有之。

tier4：该测试组包括之前各层未涵盖的所有其他测试。 例如，它包括适用于 Hotspot 的 vmTestbase 套件，即使在大型计算机上也可以运行多个小时。 它还运行 GUI 测试，因此同样的 TEST_JOBS 和 JTREG_KEYWORDS 警告也适用。

执行多个测试套

````
$ jtreg -va jdk17u-dev-jdk-17.0.8-7/test/jdk:tier1 jdk17u-dev-jdk-17.0.8-7/test/jaxp:tier1 jdk17u-dev-jdk-17.0.8-7/test/lib-test:tier1
````

在 openEuler RISC-V 中执行整个测试套：

````
$ jtreg -va -ignore:quiet -jit -conc:auto -timeout:5 -tl:3590 jdk17u-dev-jdk-17.0.8-7/test/hotspot/jtreg:tier1 jdk17u-dev-jdk-17.0.8-7/test/langtools:tier1 jdk17u-dev-jdk-17.0.8-7/test/jdk:tier1 jdk17u-dev-jdk-17.0.8-7/test/jaxp:tier1 jdk17u-dev-jdk-17.0.8-7/test/lib-test:tier1 >log 2>&1 &
````



参考：

https://openjdk.org/jtreg/build.html

https://github.com/openjdk/jtreg

https://openjdk.org/groups/build/doc/testing.html

https://github.com/openjdk/jdk17u-dev

https://gitee.com/openeuler/compiler-test/blob/master/jtreg+jcstress.md

[测试能力执行指南](https://gitee.com/openeuler/QA/blob/master/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97/openEuler%E7%A4%BE%E5%8C%BA%E6%B5%8B%E8%AF%95%E8%83%BD%E5%8A%9B%E6%89%A7%E8%A1%8C%E6%8C%87%E5%8D%97.md#107jdk)

