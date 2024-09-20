## 使用  secureguardian 进行 openEuler RISC-V 安全测试

### 1. secureguardian 介绍

secureguardian 是一款基于《openEuler 安全配置基线》开发的 Linux 系统安全检查工具，旨在针对Linux系统配置进行系统性的安全性评估。它通过模块化脚本方法操作，允许进行广泛的定制和扩展。主要组件包括：

- 检查脚本：为每项安全检查提供的单独脚本，易于更新，以适应新标准或发现。
- 配置文件：定义执行哪些检查，它们的参数，并管理异常，使得针对不同环境的评估能够量身定制。
- 执行引擎：协调检查脚本的运行，收集结果，并管理输出格式，支持详细报告以便分析和摘要以便快速概览。
- 用户界面：基于命令行，允许用户指定检查，查看报告和配置设置。

此结构支持灵活且可扩展的安全审计方法，适应广泛的系统环境和安全要求。

功能特性：

- 支持灵活的配置，可以根据需要启用或禁用特定的检查项。
- 提供详细的安全检查报告，包括检查成功、失败项及失败原因，以及对应的解决方案链接。
- 自动生成 HTML 报告，方便在 Web 浏览器中查看。
- 支持通过命令行参数指定特定的配置文件进行检查。
- 检查脚本的执行结果会被存储在 JSON 文件中，并用于生成 HTML 报告。

### 2. 使用方法

下载 secureguardian rpm 包

````
$ wget https://eulermaker.compass-ci.openeuler.openatom.cn/api/ems5/repositories/openEuler-24.09:epol/openEuler:24.09/x86_64/history/223fa6b8-65fc-11ef-9cf1-324c421ef8df/steps/upload/cbs.6161130/secureguardian-1.0.0-1.oe2409.noarch.rpm
````

安装 secureguardian rpm 包：

````
$ yum install jq
$ rpm -i secureguardian-1.0.0-1.oe2409.noarch.rpm
````

执行所有检查

````
$ run_checks
````

命令将执行所有配置文件 /usr/local/secureguardian/conf/all_checks.json 中启用的检查项，并生成报告 /usr/local/secureguardian/reports/all_checks.results.html

配置文件位于 /usr/local/secureguardian/conf 目录，可以编辑这些文件来启用或禁用特定的检查项。 检查脚本存放在 /usr/local/secureguardian/scripts/checks 目录下，根据不同的检查项组织在不同的子目录中。检查完成后，可以在/usr/local/secureguardian/reports目录下找到HTML格式的报告文件。

可以通过 -c 或 --config 指定一个特定的配置文件进行检查

````
$ run_checks -c <配置文件名>
````

可以通过 -r 来指定只执行配置文件中 level 是"要求"的检查项

````
run_checks -r
````





参考：

https://gitee.com/openeuler/secureguardian