对 openEuler RISC-V 镜像执行 SBOM 测试

#### 1. 什么是 SBOM

SBOM 是软件材料清单（Software Bill of Materials）的缩写。它是一份详细记录软件构建过程中使用的所有组件、库和依赖项的清单。

SBOM 类似于产品的配方清单，它列出了构成软件应用程序的各种元素，包括开源软件组件、第三方库、框架、工具等。每个元素在 SBOM 中都会有详细的信息，如名称、版本号、许可证信息、依赖关系等。

SBOM 的目的是增加软件供应链的可见性和透明度，并提供更好的风险管理和安全性。它可以帮助软件开发者、供应商和用户了解其软件中使用的组件和依赖项，以便更好地管理潜在的漏洞、安全风险和合规性问题。通过 SBOM 用户可以识别和跟踪软件中存在的任何潜在漏洞或已知的安全问题，并及时采取相应的补救措施。

SBOM 还可以用于软件审计、合规性要求和法规遵从性等方面。一些行业标准和法规（如软件供应链安全框架（SSCF）和欧盟网络和信息安全指令（NIS指令））已经要求软件供应商提供 SBOM，以提高软件供应链的安全性和可信度。

总之，SBOM 是一份记录软件构建过程中使用的所有组件和依赖项的清单，它提供了对软件供应链的可见性，有助于管理风险、提高安全性，并满足合规性要求。

#### 2. 生成 SBOM 清单

环境：ubuntu x86 22.04

准备 golang 环境，参考 [go 官网](https://go.dev/doc/install)

````
$ wget https://go.dev/dl/go1.22.4.linux-amd64.tar.gz
$ tar zxvf go1.22.4.linux-amd64.tar.gz
$ export PATH=$PATH:/opt/cloudroot/sbom/go/bin        //将go安装路径写入环境变量
$ go version
go version go1.22.4 linux/amd64
````

如果获取从 Github 获取 go 的模块比较慢，可以设置 CDN 加速代理

````
$ go env -w GO111MODULE=on      //启用 Go Modules 功能
$ go env -w  GOPROXY=https://goproxy.cn,direct     //配置 GOPROXY 环境变量，设置七牛 CND
````

使用 sbom-tools 生成 sbom 清单

````
$ git clone https://gitee.com/jean9823/sbom-tools.git
$ cd sbom-tools/sbom-generator/
````

编译生成可用二进制

````
$ go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64
$ go build -o sbom-amd64-linux cmd/syft/main.go
````

会在当前目录下生成 sbom-amd64-linux 即为用做生成 sbom 清单的工具

生成 sbom 清单

````
$ ./sbom-amd64-linux /opt/cloudroot/sbom/openEuler-24.03-LTS-riscv64-dvd.iso -o spdx-json=/opt/cloudroot/sbom/sbom.json
repodata temp dir: /tmp/syft-repodata618706164/repodata 
 ✔ Indexed /opt/cloudroot/sbom/openEuler-24.03-LTS-riscv64-dvd.iso 
 ✔ Cataloged packages      [2492 packages]
````

其中

/opt/cloudroot/sbom/openEuler-24.03-LTS-riscv64-dvd.iso ：用来解析生成 sbom 清单的镜像所在路径

spdx-json：生成的 sbom 清单的格式，还支持其他格式，包括 syft-json cyclonedx-xml cyclonedx-json github github-json spdx-tag-value spdx-json table text

/opt/cloudroot/sbom/sbom.json：生成 sbom 清单所在路径





