openEuler RISC-V docker 镜像运行启动

#### 1. 下载docker镜像

````
$ wget http://121.36.84.172/dailybuild/EBS-openEuler-24.09/openeuler-2024-09-27-08-33-57/docker_img/riscv64/openEuler-docker.riscv64.tar.xz
````

#### 2. 解压镜像并加载镜像

````
$ xz -d openEuler-docker.riscv64.tar.xz
$ docker load -i openEuler-docker.riscv64.tar
$ docker image ls
REPOSITORY        TAG       IMAGE ID       CREATED      SIZE
openeuler-24.09   latest    1a77bf414c81   2 days ago   149MB
````

#### 3. 创建 docker 容器

````
$ docker run -itd --name oerv_2409 1a77bf414c81
$ docker ps
CONTAINER ID   IMAGE          COMMAND       CREATED          STATUS          PORTS     NAMES
94949f716871   1a77bf414c81   "/bin/bash"   18 seconds ago   Up 16 seconds             oerv_2409
````

#### 4. 进入 docker 容器

````
$ docker exec -it oerv_2409 /bin/bash

Welcome to 6.5.0-41-generic

System information as of time:  Sun Sep 29 17:52:56 CST 2024

System load:    0.25
Memory used:    23.4%
Swap used:      12.6%
Usage On:       76%
Users online:   0


[root@94949f716871 /]# uname -a
Linux 94949f716871 6.5.0-41-generic #41~22.04.2-Ubuntu SMP PREEMPT_DYNAMIC Mon Jun  3 11:32:55 UTC 2 riscv64 riscv64 riscv64 GNU/Linux
````