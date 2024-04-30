在openEuler riscv64中使用Trinity执行kernel模糊测试

#### 1. Trinity介绍

Trinity 是一款用于 Linux 内核的系统调用模糊(fuzz)测试工具，它采用了一些技术，向被调用的系统调用传递半智能参数。模糊测试是一种安全技术，它将随机参数输入函数，以查看会发生什么故障。Trinity目前已支持 riscv64 架构

智能功能包括：

- 如果系统调用需要某种数据类型作为参数（例如文件描述符），它会被传递一个。这就是初始启动缓慢的原因，因为它会生成可以从 /sys、/proc 和 /dev 读取的文件的 fd 列表，然后用 fd 对各种网络协议套接字进行补充。（关于哪些协议成功/失败的信息在第一次运行时被缓存，大大提高了后续运行的速度
- 如果系统调用只接受某些值作为参数（例如“标志”字段），Trinity 会列出所有可以传递的有效标志。为了增加趣味性，偶尔，它会翻转其中一个标志，只是为了让事情变得更有趣。
- 如果系统调用只接受一定范围的值，那么所传递的随机值通常会偏向于在该范围内。

Trinity 会将输出记录到一个文件（每个子进程一个）中，并在实际执行系统调用前同步文件。这样，如果你触发了内核慌乱的情况，你应该可以通过查看日志找出到底发生了什么。

提供了多个测试框架，可以在不同模式下运行Trinity，并处理诸如CPU亲和性等问题，确保它从tmp目录中运行。（便于清理命名为 tmp 的垃圾文件；之后只需 rm -rf tmp 即可）

#### 2. Trinity编译安装

安装环境：D1开发版烧入 openEuler riscv64 23.03 v1 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.03-V1-riscv64/

从 https://github.com/kernelslacker/trinity 获取源码，进行编译和安装

````
$ git clone https://github.com/kernelslacker/trinity.git
$ cd trinity
$ ./configure
$ make
$ make install
````

#### 3. 执行测试

由于 Trinity 不能以 root 身份运行，所以需要创建一个非root的新用户

````
$ useradd test    //创建用户test
$ passwd test     //设置用户test密码
$ su test         //切换到用户test
````

对splice系统调用进行压力测试

````
$ ./trinity -c splice
````

调用除 splice 以外的所有系统调用

````
$ ./trinity -x splice
````

关闭日志记录，抑制大部分输出，以尽可能快的速度运行。使用 16 个子进程

````
$ ./trinity -qq -l off -C16
````

参数说明：

````
--quiet/-q: reduce verbosity.
   Specify once to not output register values, or twice to also suppress syscall count.

 --verbose: increase verbosity.

 -D: Debug mode.
     This is useful for catching core dumps if trinity is segfaulting, as by default
     the child processes ignore those signals.

 -sN: use N as random seed.  (Omitting this uses time of day as a seed).
  Note: There are currently a few bugs that mean no two runs are necessary 100%
  identical with the same seed. See the TODO for details.

 --kernel_taint/-T: controls which kernel taint flags should be considered.
	The following flag names are supported: PROPRIETARY_MODULE, FORCED_MODULE, UNSAFE_SMP,
	FORCED_RMMOD, MACHINE_CHECK, BAD_PAGE, USER, DIE, OVERRIDDEN_ACPI_TABLE, WARN, CRAP,
	FIRMWARE_WORKAROUND, and OOT_MODULE. For instance, to set trinity to monitor only BAD,
	WARN and MACHINE_CHECK flags one should specify "-T BAD,WARN,MACHINE_CHECK" parameter.

 --list/-L: list known syscalls and their offsets

 --proto/-P: For network sockets, only use a specific packet family.

 --victims/-V: Victim file/dirs.  By default, on startup trinity tree-walks /dev, /sys and /proc.
     Using this option you can specify a different path.
     (Currently limited to just one path)

 -p: Pause after making a syscall

 --children/-C: Number of child processes.

 -x: Exclude a syscall from being called.  Useful when there's a known kernel bug
     you keep hitting that you want to avoid.
     Can be specified multiple times.

 -cN: do syscall N with random inputs.
     Good for concentrating on a certain syscall, if for eg, you just added one.
     Can be specified multiple times.

 --group/-g
   Used to specify enabling a group of syscalls. Current groups defined are 'vm' and 'vfs'.

 --logging/-l <arg>
  off: This disables logging to files. Useful if you have a serial console, though you
         will likely lose any information about what system call was being called,
         what maps got set up etc. Does make things go considerably faster however,
         as it no longer fsync()'s after every syscall
  <hostname> : sends packets over udp to a trinity server running on another host.
         Note: Still in development. Enabling this feature disables log-to-file.
  <dir> : Specify a directory where trinity will dump its log files.

 --ioctls/-I will dump all available ioctls.

 --arch/-a Explicit selection of 32 or 64 bit variant of system calls.
````



参考：

https://github.com/kernelslacker/trinity

https://www.jianshu.com/p/744f7f9468f5