针对 2403 发版，目前测试流水线状态如下：

| 测试类型       | 测试项目                | 是否能测试 | 是否已包含在测试平台中 | 目前状态                 | 说明                                                         |
| -------------- | ----------------------- | ---------- | ---------------------- | ------------------------ | ------------------------------------------------------------ |
| 功能测试       | mugen                   | Yes        | Yes                    | 测试平台中正在适配RISC-V | 已完成：                                                     |
|                | LTP                     | Yes        | Yes                    |                          |                                                              |
| 基础性能测试   | unixbench               | Yes        | Yes                    |                          |                                                              |
|                | netperf                 | Yes        | Yes                    |                          |                                                              |
|                | iozone                  | Yes        | No                     | 已调研                   |                                                              |
|                | fio                     | Yes        | No                     | 已调研                   |                                                              |
|                | stream                  | Yes        | Yes                    | 测试平台中已适配RISC-V   |                                                              |
|                | lmbench                 | Yes        | Yes                    |                          |                                                              |
| 安全测试       | oss-fuzz                | No         | No                     |                          | 安装部署依赖的 Docker 镜像缺少 riscv64 架构适配，2403暂时不测试该项 |
|                | syzkaller               | Yes        | No                     | 需调研                   |                                                              |
|                | nmap                    | Yes        | Yes                    | 测试平台中已适配RISC-V   |                                                              |
|                | mugen/security_test     | Yes        | Yes                    |                          |                                                              |
| 虚拟化测试     | virttest-avocado-vt     | Yes        | No                     | 需调研                   | 目前没有支持部署测试工具的硬件设备(支持gcc H扩展)，只有 QEMU 支持 |
| 内核测试       | trinity                 | Yes        | No                     | 已调研                   |                                                              |
|                | LTP                     | Yes        | Yes                    |                          |                                                              |
|                | posix                   | Yes        | Yes                    |                          | ltp open_posix_testsuite                                     |
|                | long stress             | Yes        | Yes                    |                          | ltpstress                                                    |
|                | syzkaller               | Yes        | No                     | 需调研                   |                                                              |
|                | mmtests                 | Yes        | No                     | 已调研                   |                                                              |
| 接口测试       | api sanity checker      | Yes        | No                     | 已调研                   |                                                              |
| 长稳测试       | long stress（ltpstress) | Yes        | Yes                    |                          |                                                              |
| GUI测试        | openQA                  | Yes        | No                     | 需调研                   |                                                              |
| 编译器测试     | dejagnu                 | Yes        | Yes                    | 需调研                   |                                                              |
|                | llvmcase                | Yes        | No                     | 需调研                   |                                                              |
|                | Anghabench              | Yes        | No                     | 需调研                   |                                                              |
|                | jotai                   | Yes        | No                     | 需调研                   |                                                              |
|                | csmith                  | Yes        | No                     | 需调研                   |                                                              |
|                | yarpgen                 | Yes        | No                     | 需调研                   |                                                              |
|                | jdk                     |            | No                     | 需调研                   |                                                              |
| 自编译测试     | compile_mock            | No         | No                     | 需调研                   | https://gitee.com/openeuler/test-tools/tree/master/compile_mock , 脚本中缺少适配riscv64的配置文件，需要做适配 |
| 北向兼容性测试 | oecp                    | No         | Yes                    |                          | 1. oerv目前没有 iso 镜像文件，无法测试<br>2. 缺少适配 riscv64 的 python 第三方包 pandas<br>3. 2403暂时不测试该项 |
| 南向兼容性测试 | oec-hardware            | No         | No                     | 需调研                   | 未适配 riscv64，需构建出 oec-hardware rpm 包后再做调研       |
| 软件包专项测试 | mugen/pkgmanager-test   | Yes        | Yes                    |                          |                                                              |
| 资料测试       |                         | Yes        | No                     |                          | 该项需要手动测试                                             |
