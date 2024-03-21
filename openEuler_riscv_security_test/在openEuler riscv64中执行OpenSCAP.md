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
$ ls /usr/share/xml/scap/ssg/content | grep openeuler
ssg-openeuler2203-cpe-dictionary.xml
ssg-openeuler2203-cpe-oval.xml
ssg-openeuler2203-ds-1.2.xml
ssg-openeuler2203-ds.xml
ssg-openeuler2203-ocil.xml
ssg-openeuler2203-oval.xml
ssg-openeuler2203-xccdf.xml
ssg-openeuler-cpe-dictionary.xml
ssg-openeuler-cpe-oval.xml
ssg-openeuler-ds-1.2.xml
ssg-openeuler-ds.xml
ssg-openeuler-ocil.xml
ssg-openeuler-oval.xml
ssg-openeuler-xccdf.xml
````

根据列出的内容，当前系统为 openEuler，所以选择 ssg-openeuler2203-ds.xml

查看所选择的 SCAP 文件内容

````
$ oscap info /usr/share/xml/scap/ssg/content/ssg-openeuler2203-ds.xml
Document type: Source Data Stream
Imported: 2023-09-08T08:00:00

Stream: scap_org.open-scap_datastream_from_xccdf_ssg-openeuler2203-xccdf.xml
Generated: (null)
Version: 1.3
Checklists:
        Ref-Id: scap_org.open-scap_cref_ssg-openeuler2203-xccdf.xml
                Status: draft
                Generated: 2023-10-07
                Resolved: true
                Profiles:
                        Title: Standard System Security Profile for openEuler 22.03 LTS
                                Id: xccdf_org.ssgproject.content_profile_standard
                Referenced check files:
                        ssg-openeuler2203-oval.xml
                                system: http://oval.mitre.org/XMLSchema/oval-definitions-5
                        ssg-openeuler2203-ocil.xml
                                system: http://scap.nist.gov/schema/ocil/2
Checks:
        Ref-Id: scap_org.open-scap_cref_ssg-openeuler2203-oval.xml
        Ref-Id: scap_org.open-scap_cref_ssg-openeuler2203-ocil.xml
        Ref-Id: scap_org.open-scap_cref_ssg-openeuler2203-cpe-oval.xml
Dictionaries:
        Ref-Id: scap_org.open-scap_cref_ssg-openeuler2203-cpe-dictionary.xml
````

里面有一个 XCCDF 基准，Id为 xccdf_org.ssgproject.content_profile_standard，这个 Id 在执行合规检查时会用到

Document type：文档类型

Imported：文档导入时间

Status：XCCDF基准状态。常用的值包括"accepted已接受"、"draft草案"、"deprecated已弃用"和"incomplete不完整"

Profiles：可用的配置文件

选择合适的 XCCDF 基准，执行 SCAP 合规检查，并生成报告

````
$ oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_standard --results scan_results.xml --report scan_report.html /usr/share/xml/scap/ssg/content/ssg-openeuler-ds.xml
````

--profile：指定 XCCDF 配置文件的(基线标准)Id

--results-arf：指定生成的 SCAP 结果数据流格式(arf)的结果的文件路径

--report：指定生成的  HTML 格式的报告的文件路径

检查完成后，会在命令执行路径(如果不指定就在当前目录下)生成测试结果和测试报告

执行 SCAP 漏洞评估

````
$ oscap oval eval --results oval_result.xml --report oval_report.html /usr/share/xml/scap/ssg/content/ssg-openeuler-ds.xml
````



参考：

https://zhuanlan.zhihu.com/p/138233344

https://blog.csdn.net/KeyarchOS/article/details/132247999

[OpenSCAP 官网](https://static.open-scap.org/openscap-1.3/oscap_user_manual.html#_installing_openscap)
