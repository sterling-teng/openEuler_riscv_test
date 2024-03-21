### 在openEuler riscv64中测试clang

#### 1. 测试环境

openEuler RISC-V 23.09镜像

#### 1. 安装clang

````
$ yum install -y clang
````

查看clang版本

````
$ clang --version
````

#### 2. 用clang编译helloworld

创建 hello.c 文件，文件内容如下

````
#include <stdio.h>
 
int main() {
    printf("Hello, World!\n");
    return 0;
}
````

用 clang 编译 hello.c

````
$ clang -o hello hello.c
````

运行 hello

````
$ ./hello
Hello, World!
````

