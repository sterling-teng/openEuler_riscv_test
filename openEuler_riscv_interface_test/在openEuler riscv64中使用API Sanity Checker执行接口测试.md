在openEuler riscv64中使用API Sanity Checker执行接口测试

#### 1. api sanity checker 介绍

API Sanity Checker — an automatic generator of basic unit tests for a C/C++ library API 

该工具是C/C++库应用程序接口基本单元测试自动生成器。通过分析头文件中的声明，该工具能够生成合理的参数输入数据（在大多数情况下，但并非所有情况下），并为应用程序接口(API)中的每个函数编写简单（"健全 "或 "浅层 "质量）的测试用例。

根据生成测试的质量，可以检查简单用例中是否存在关键错误。该工具能够构建和执行生成的测试，并检测崩溃（segfaults）、各种发射信号、非零程序返回代码和程序挂起。

该工具可被视为对程序库应用程序接口进行开箱即用的低成本正常性检查（模糊检查）的工具，也可被视为初步生成高级测试模板的测试开发框架。此外，它还支持通用的 T2C 测试格式、随机测试生成模式、专用数据类型和其他实用功能

#### 2. 安装

安装环境：D1开发版烧入 openEuler riscv64 23.03 v1 版本 https://repo.tarsier-infra.com/openEuler-RISC-V/preview/openEuler-23.03-V1-riscv64/

依赖包：ABI Compliance Checker，Perl 5，G++，GNU Binutils，Ctags

openEuler riscv64 23.03 v1镜像中，除了ABI Compliance Checker，其余依赖包都已预安装

安装 ABI Compliance Checker

````
$ git clone https://github.com/lvc/abi-compliance-checker.git
$ cd abi-compliance-checker
$ make install prefix=/usr
````

安装api sanity checker

````
$ git clone https://github.com/lvc/api-sanity-checker.git
$ cd api-sanity-checker
$ make install prefix=/usr
````

执行以下命令来确认api sanity checker是否可以正常运行

````
$ api-sanity-checker -test
````

#### 3. 执行测试

为了生成，构建和运行测试，需要提供所要测试的C/C++库版本的XML描述符。这是一个简单的XML文件，其中指定了版本号、头文件和共享库的路径，以及其他一些可选信息，例如：VERSION.xml是一个XML描述符，内容如下：

````
<version>
    1.0
</version>

<headers>
    /path/to/headers/
</headers>

<libs>
    /path/to/libraries/
</libs>
````

执行 api-sanity-checker -h 可以查到该工具的使用方法

````
$ api-sanity-checker -h
NAME:
  API Sanity Checker (api-sanity-checker)
  Generate basic unit tests for a C/C++ library API

DESCRIPTION:
  API Sanity Checker is an automatic generator of basic unit tests for a C/C++
  library. It helps to quickly generate simple ("sanity" or "shallow"
  quality) tests for every function in an API using their signatures, data type
  definitions and relationships between functions straight from the library
  header files ("Header-Driven Generation"). Each test case contains a function
  call with reasonable (in most, but unfortunately not all, cases) input
  parameters. The quality of generated tests allows to check absence of critical
  errors in simple use cases and can be greatly improved by involving of highly
  reusable specialized types for the library.

  The tool can execute generated tests and detect crashes, aborts, all kinds of
  emitted signals, non-zero program return code, program hanging and requirement
  failures (if specified). The tool can be considered as a tool for out-of-box
  low-cost sanity checking of library API or as a test development framework for
  initial generation of templates for advanced tests. Also it supports universal
  Template2Code format of tests, splint specifications, random test generation
  mode and other useful features.

  This tool is free software: you can redistribute it and/or modify it
  under the terms of the GNU LGPL or GNU GPL.

USAGE:
  api-sanity-checker [options]

EXAMPLE:
  api-sanity-checker -lib NAME -d VER.xml -gen -build -run

  VERSION.xml is XML-descriptor:

    <version>
        1.0
    </version>

    <headers>
        /path1/to/header(s)/
        /path2/to/header(s)/
         ...
    </headers>

    <libs>
        /path1/to/library(ies)/
        /path2/to/library(ies)/
         ...
    </libs>

INFORMATION OPTIONS:
  -h|-help
      Print this help.

  -info
      Print complete info.

  -v|-version
      Print version information.

  -dumpversion
      Print the tool version (1.98.8) and don't do anything else.

GENERAL OPTIONS:
  -l|-lib|-library NAME
      Library name (without version).

  -d|-descriptor PATH
      Path to the library descriptor (VER.xml file):
      
        <version>
            1.0
        </version>

        <headers>
            /path1/to/header(s)/
            /path2/to/header(s)/
            ...
        </headers>

        <libs>
            /path1/to/library(ies)/
            /path2/to/library(ies)/
            ...
        </libs>

      For more information, please see:
        http://lvc.github.com/api-sanity-checker/Xml-Descriptor.html

  -gen|-generate
      Generate test(s). Options -l and -d should be specified.
      To generate test for the particular function use it with -f option.
      Exit code: number of test cases failed to build.

  -build|-make
      Build test(s). Options -l and -d should be specified.
      To build test for the particular function use it with -f option.
      Exit code: number of test cases failed to generate.

  -run
      Run test(s), create test report. Options -l and -d should be specified.
      To run test for the particular function use it with -f option.
      Exit code: number of failed test cases.

  -clean
      Clean test(s). Options -l and -d should be specified.
      To clean test for the particular function use it with -f option.

MORE INFO:
     api-sanity-checker --info
````

测试gcc库API，创建VERSION.xml文件内容如下：

````
<version>
    10.3.1
</version>

<headers>
    /usr/lib/gcc/riscv64-linux-gnu/10.3.1/include/
</headers>

<libs>
    /usr/lib/gcc/riscv64-linux-gnu/10.3.1/
</libs>
````

执行以下命令生成 test suite

````
$ api-sanity-checker -lib NAME -d VERSION.xml -gen
````

可以通过查看当前目录下的 tests/NAME/VERSION/view_tests.html 文件，查看有哪些测试项目

执行以下命令构建测试

````
$ api-sanity-checker -l NAME -d VERSION.xml -build
````

执行以下命令执行测试

````
$ api-sanity-checker -l NAME -d VERSION.xml -run
````

以上三条命令也可以用一个命令来代替，一次完成生成，构建和执行测试这3个步骤

````
$ api-sanity-checker -lib NAME -d VERSION.xml -gen -build -run
````

执行完测试后，会自动生成测试报告，存放在当前目录下的 test_results/NAME/10.3.1/test_results.html



参考：

https://lvc.github.io/api-sanity-checker/

https://github.com/lvc/api-sanity-checker

https://github.com/lvc/abi-compliance-checker

