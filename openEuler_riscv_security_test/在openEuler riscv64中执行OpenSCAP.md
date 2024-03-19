### 在openEuler RISC-V 中执行 OpenSCAP

#### 1. OpenSCAP介绍

OpenSCAP 是一个获得`SCAP`认证的、免费开源的工具，目前由Redhat 进行维护，主要功能是为Linux操作系统提供安全合规检查和漏洞评估。

其中，安全合规是指，系统要能在不断变化的计算机安全领域里，始终符合特定安全策略。并且对于不断变化的安全策略进行评估、检测和调整，以满足新的合规需求。漏洞评估是指，系统具有识别和分类风险漏洞的能力。

#### 2. OpenSCAP使用

使用环境：openEuler RISC-V 23.09 镜像

安装 openscap 工具

````
$ yum install -y openscap-scanner
````

安装SCAP内容 scap-security-guide，简称 SSG。使用OpenSCAP执行合规检查或漏洞评估任务时，需要指定SCAP格式的安全策略，称之为 SCAP 内容

````
$ yum install -y scap-security-guide
````

选择合适的 SCAP 文件

````
$ ls /usr/share/xml/scap/ssg/content | grep xccdf
ssg-alinux2-xccdf.xml
ssg-alinux3-xccdf.xml
ssg-anolis8-xccdf.xml
ssg-centos7-xccdf.xml
ssg-centos8-xccdf.xml
ssg-chromium-xccdf.xml
ssg-cs9-xccdf.xml
ssg-debian10-xccdf.xml
ssg-debian11-xccdf.xml
ssg-eks-xccdf.xml
ssg-fedora-xccdf.xml
ssg-firefox-xccdf.xml
ssg-macos1015-xccdf.xml
ssg-ocp4-xccdf.xml
ssg-ol7-xccdf.xml
ssg-ol8-xccdf.xml
ssg-ol9-xccdf.xml
ssg-openeuler2203-xccdf.xml
ssg-openeuler-xccdf.xml
ssg-opensuse-xccdf.xml
ssg-rhcos4-xccdf.xml
ssg-rhel7-xccdf.xml
ssg-rhel8-xccdf.xml
ssg-rhel9-xccdf.xml
ssg-rhv4-xccdf.xml
ssg-sl7-xccdf.xml
ssg-sle12-xccdf.xml
ssg-sle15-xccdf.xml
ssg-ubuntu1604-xccdf.xml
ssg-ubuntu1804-xccdf.xml
ssg-ubuntu2004-xccdf.xml
ssg-ubuntu2204-xccdf.xml
ssg-uos20-xccdf.xml
````

根据列出的内容，当前系统为 openEuler，所以选择 ssg-openeuler-xccdf.xml

查看所选择的 SCAP 文件内容

````
$ oscap info /usr/share/xml/scap/ssg/content/ssg-openeuler-xccdf.xml
Document type: XCCDF Checklist
Checklist version: 1.2
Imported: 2023-09-08T08:00:00
Status: draft
Generated: 2023-10-07
Resolved: true
Profiles:
        Title: Standard System Security Profile for openEuler
                Id: xccdf_org.ssgproject.content_profile_standard
Referenced check files:
        ssg-openeuler-oval.xml
                system: http://oval.mitre.org/XMLSchema/oval-definitions-5
        ssg-openeuler-ocil.xml
                system: http://scap.nist.gov/schema/ocil/2
````

里面有一个 XCCDF 基准，Id为 xccdf_org.ssgproject.content_profile_standard，这个 Id 在执行合规检查时会用到

Document type：文档类型

Imported：文档导入时间

Status：XCCDF基准状态。常用的值包括"accepted已接受"、"draft草案"、"deprecated已弃用"和"incomplete不完整"

Profiles：可用的配置文件

选择合适的 XCCDF 基准，执行 SCAP 合规检查，并生成报告

````
$ oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard --results-arf arf.xml --report report.html /usr/share/xml/scap/ssg/content/ssg-openeuler-xccdf.xml
````

--profile：指定 XCCDF 配置文件的(基线标准)Id

--results-arf：指定生成的 SCAP 结果数据流格式(arf)的结果的文件路径

--report：指定生成的  HTML 格式的报告的文件路径

检查完成后，会在命令执行路径(如果不指定就在当前目录下)生成测试结果和测试报告

执行 SCAP 漏洞评估

````
$ oscap oval eval --results oval_result.xml --report oval_report.html /usr/share/xml/scap/ssg/content/ssg-openeuler-oval.xml
````



参考：

https://zhuanlan.zhihu.com/p/138233344

https://blog.csdn.net/KeyarchOS/article/details/132247999

[OpenSCAP 官网](https://static.open-scap.org/openscap-1.3/oscap_user_manual.html#_installing_openscap)
