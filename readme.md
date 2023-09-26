# 尚硅谷学习 （https://www.bilibili.com/video/BV1gr4y1U7CY/?spm_id_from=333.999.0.0&vd_source=7f59eb599765afcad560d7047f30c765）

（https://yeasy.gitbook.io/docker_practice/）

# Docker 与微服务实战

一、docker 基础篇

1. Docker 简介
   是基于 linux 内核的

- 是什么（一套环境的集合）
- 能干嘛
- 下载、安装
- 怎么用
- helloworld
- image 镜像
- 配置阿里云加速器

  1.1. networker 网络驱动
  1.2. docker 容器编排
  1.3. exec 退出

2.  Docker 常用命令
    2.1 启动 docker
    2.2 镜像命令

        - docker images 列出本地的镜像
        - docker iamges -a 本地
        - docker images -q 只显示主键字段
        - docker run -d ubuntu

        - docker search hello-world --limit 5
        - docker pull hello-world 拉取景象
        - docerk system df 查看 docker 资源占有（镜像多少个，容器多少个....）
        - docker rmi hello-world （删除镜像）（-f 不管有没有容器，强制删除）
        - docker rmi -f e6a0117ec169:latest 6a7735c5dff2
        - docker rmi -f $(docker images -qa)

    2.3 docker 虚悬镜像是什么

        - 仓库名、标签都是<none>的镜像，俗称虚悬镜像 dangling image

    2.4 容器命令

        - 新建 + 启动容器
        - docker run --name="容器新名字" -it（等待前台输入）/bin/bash
          docker run -it --name="ucontainer" ubuntu:18.04  /bin/bash(正确写法)
          -i 以交互模式运行容器，通常与-t同时使用
          -t 为容器重新分配一个伪输入终端，通常与-i一起使用
          -d 后台运行容器并返回容器id，也即启动守护式容器（后台运行）
          -P 随机端口映射，大写P
          -p 制定端口映射，小写p

        - docker ps (查看所有启动容器)
          -a 列出历史上所有的容器
          -l 显示最近创建的容器
          -n 显示最近n个创建的容器
          -q 显示容器id

        - 退出容器
          ctrl + p + q
          exit
        - 启动已经停止的容器
          docker start ucontainer
        - 强制停止容器
          docker kill ucontainer
        - 删除已停止的容器
          docker rm ucontainer
          docker rm -f $(docker ps -a -q)

        - 重要部分
          进入容器
          docker容器后台运行，就必须有一个前台进程
          容器运行的命令如果不是一直挂起的命令，就会自动退出的
          docker run -it redis:6.0.8  前台交互式启动
          docker run -d redis:6.0.8  后台运行，守护式进程
          docker logs 容器
          docker top 容器 （容器内部运行程序状况）
          docker inspect 容器

        - 进入正在运行的容器 docker exec -it 容器
          docker exec -it con /bin/bash (exit 退出，会导致容器的停止，不会启动新的进程)
          docker attach con（打开新的终端，并且可以启动新的进程，exit退出，不会导致容器的停止）

    2.5 从容器拷贝文件到主机

        - docker cp 容器 id:容器路径 目标主机路径
        - export 到处容器的内容留作为一个tar归档文件
        - import 从tar包中的内容创建一个新的文件系统再导入为镜像

3.  Docker 镜像
    是一种轻量级、可执行的独立软件包，它包含运行某个软件所需的所有内容，我们把应用程序和配置依赖打包好行程一个可交付的运行环境（包括代码、运行时需要的库、环境变量和配置文件等），这个打包好的运行环境就是 image 镜像文件

    只有通过这个镜像文件才能生成 docker 容器实例

    3.1 分层的镜像

    3.2 unionFS(联合文件系统)：union 文件系统是一种分层、轻量级并且高性能的文件系统，它支持文件系统的修改作为一次提交来一层层的叠加，同事可以将不同目录挂载到同一个虚拟文件系统下。union 文件系统是 docker 镜像的基础，镜像可以通过分层来进行集成，基于基础镜像（没有父镜像），可以制作各种具体的应用镜像

        - 特性：一次同时加载多个文件系统，但从外面看起来，只能看到一个文件系统，联合加载会把各种文件系统叠加起来，这样最终的文件系统会抱憾所有底层的文件和目录

    3.3 docker 镜像都是只读的，容器层是可写的

        - 当容器启动时，一个新的可写层被加载到镜像的顶部

    3.4 commit

        - 加一个vi命令，进行发布
        docker commit -m="提交的信息" -a="作者" 容器id 要创建的目标镜像名:[标签名]
        - apt-get update
        - apt-get install vim -y
        - docker commit -m="add vim cmd" -a="jxx" 3d55ccc49cf2 jxx/ubuntu-vim:0.1
        - 发布到阿里云

4.  Docker 容器数据卷
    卷就是目录或文件，存在于一个或多个容器中，由 docker 挂载到容器，但不属于联合文件系统，因此能够染过 union file system 提供一些用于持续存储或共享数据的特性

    卷设计的目的就是数据的持久化，完全独立于容器的生存周期，因此 docker 不会在容器删除时删除其余挂载的数据卷

    就是将 docker 容器内的数据保存进宿主机的磁盘中，运行一个带有容器卷存储功能的容器实例

    4.1 容器卷记得加上 --privileged=true(结局挂载目录没有权限的问题)
    4.2 映射，容器内的数据备份+持久化到本地主机目录
    4.3 启动

        -  docker run -it --privileged=true -v /宿主机绝对路径目录:/容器内目录 镜像名
        - 数据卷可在容器之间共享或重用数据
        - 卷中的更改可以直接实时生效，爽
        - 数据卷中的更改不会包含在镜像的更新中
        - 数据卷的生命周期一直持续到没有容器使用它为止

    4.4 示例

        - docker run -it --privileged=true -v /tmp/host_data:/tmp/docker_data --name=u1 ubuntu

    4.5 查看数据卷是否挂载成功，挂在哪（容器和宿主机之间数据共享）

        - docker inspect u1

    4.6 挂载规则(限制容器)

        - docker run -it --privileged=true -v /tmp/host_data:/tmp/docker_data:rw --name=u1 ubuntu
        - 只读、只写，如何配置(:rw)
        - read-only
          docker run -it --privileged=true -v /tmp/host_data:/tmp/docker_data:r0 --name=u1 ubuntu

    4.7 卷的继承和共享

        - docker run -it --privileged=true --volumes-from u1 --name="u2" ubuntu
        - --volumes 就是-v
        - 继承u1

5.  Docker 常规安装简介

    5.1 搜索镜像

        - docker search tomcat

    5.2 拉取景象

        - dokcer pull tomcat
        - docker pull mysql

    5.3 查看镜像

        - dokcer images tomcat

    5.4 启动镜像

        - docker run -d -p 8080:8080 --name t1 tomcat
        - 404
        - 没有映射端口、没有关闭防火墙
        - docker exec -it t1 /bin/bash
        - rm -r webapps
        - mv webapps.dist webapps

        - docker run -d -p 8080:8080 --name mytomcat8 billygoo/tomcat8-jdk8 // (不用修改目录)
        - docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456  mysql

    5.5 停止镜像

        - docker stop t1

    5.6 移除容器

        - docker rm -f t1

二、docker 高级篇(docker 与 微服务)

1. Docker 复杂安装详述
2. 开启集群

   - docker run -d --name redis-node-1 --net host --privileged=true -v /data/redis/share/redis-node-1:/data redis:6.0.8 --cluster-enabled yes --appendonly yes --port 6381
     --cluster-enabled yes // 是否开启 redis 集群
     --appendonly yes // 开启持久化

   - docker run -d --name redis-node-2 --net host --privileged=true -v /data/redis/share/redis-node-2:/data redis:6.0.8 --cluster-enabled yes --appendonly yes --port 6382

3. 主从机器，容器

   - docer exec -it redis-node-1 /bin/bash
   - redis-cli --cluster create 192.168.111.147:6381 192.168.111.147:6382 192.168.111.147:6383 192.168.111.147:6384 192.168.111.147:6385 192.168.111.147:6386 --cluster-replicas 1
   - --cluster-replicas 1 表示为每个 master 创建一个 slave 节点

4. 集群内查看节点状态

   - cluster info
   - cluser nodes
   -

三、 dockerfile

1.  是什么
    是用来构建 Docker 镜像的文本文件，是由一条条构建镜像所需的指令和参数构成的脚本。
    - 写 dockerfile
    - docker build 构建镜像
    - docker run 依据镜像运行容器实例
2.  dockerfile 构建过程

    - 每条保留字指令都必须为大写字母且后面要跟随至少一个参数
    - 指令按照从上到下，顺序执行
    - \# 表示注解
    - 每条指令都会创建一个新的镜像层并对镜像进行提交

      2.1 Docker 执行 Dockerfile 的大致流程

            - docker从基础镜像运行一个容器
            - 执行一条指令并对容器作出修改
            - 执行类似docker commit的操作提交一个新的镜像层
            - docker再基于刚提交的镜像运行一个新容器
            - 执行dockerfile中的下一条指令直到所有指令都执行完成

      2.2 常用保留字指令

            - FROM 基础镜像，当前新镜像是基于那个镜像的，制定一个已经存在的镜像作为模版
            - MAINTAINER 镜像维护者的姓名和邮箱地址
            - RUN 可以执行shell命令;RUN是在 docker build时运行。
            - EXPOSE 当前容器对外暴漏出的端口
            - WORKDIR 指定在创建容器后，终端默认登录的进来工作目录，一个落脚点
            - USER 指定该镜像以什么样的用户去执行，如果都不指定，默认是root
            - ENV 用来在构建镜像过程中设置环境变量
            - ADD 将宿主机目录下的文件拷贝镜像且会自动处理URL和解压tar压缩包
            - COPY 类似ADD，拷贝文件和目录到镜像中；将从构建上下文目录<源路径>的文件/目录复制到新的一层镜像内的<目标路径>位置
            - VOLUME 容器卷,用于数据持久化 -v
            - CMD 指定容器启动后要干的事情；CMD ['shell', 'param1']; Dockerfile 中可以有多个 CMD 指令，但只有最后一个生效，CMD 会被 docker run 之后的参数替换; CMD是在docker run 时运行

            - ENTRYPOINT 也是用来指定一个容器启动时要运行的命令;类似于 CMD 指令，但是ENTRYPOINT不会被docker run后面的命令覆盖， 而且这些命令行参数会被当作参数送给 ENTRYPOINT 指令指定的程序 (entrypoint)

3.  构建

    - docker build -t 新镜像名字:TAG
    - docker build -t centosjava8:0.1 .

4.  虚悬镜像

    - 仓库名、标签都是<none>的镜像，俗称 dangling image
    - 产看所有虚悬镜像 docker image ls -f dangling=true
    - docker image prune(修剪，裁剪)

四、Docker 网络

Docker 服务默认会创建一个 docker0 网桥（其上有一个 docker0 内部接口），该桥接网络的名称为 docker0，它在内核层连通了其他的物理或虚拟网卡，这就将所有容器和本地主机都放到同一个物理网络。Docker 默认指定了 docker0 接口的 ip 地址和子网掩码，让主机和容器之间可以通过网桥相互通信

    默认创建 3 大网络模式
    docker network ls 就可以查看网络
    docker network COMMAND
    docker网络管理和容器调用之间的规划
    Docker

1.  常用命令

    - docker network ls
    - docker network inspect 网络名字
    - docker network rm 网络名字
    - docker inspect 容器名字
    - docker inspect u1 | tail -n 20
    - docker network create aa_network
    -

2.  容器间的互联和通信以及端口映射；容器 ip 变动时候可以通过服务名直接网络通信而不受影响
3.  网络模式

    3.1 bridge

        - 为每一个容器分配、设置ip等，并将容器连接到一个 docker0 虚拟网桥，默认为该模式

    3.2 host

        - 容器将不会虚拟出自己的网卡，配置自己的ip等，而是使用宿主机的ip和端口

    3.3 none - 容器有独立的 network namespace，但并没有对其进行任何网络设置，如分配 veth pair 和网桥连接，ip 等

    3.4 container 新创建的容器不会创建自己的网卡和配置自己的 ip，而是和一个指定的容器共享 ip，端口范围

4.  容器实例内默认网络 ip 生成规则

        - docker 容器内部的 ip 是会发生变化的
        - 查看 bridge 网络的详细信息，并通过 grep 获取名称项 ; docker network inspect bridge | grep name
        - Docker 使用 Linux 桥接，在宿主机虚拟一个 Docker 容器网桥(docker0)，Docker 启动一个容器时会根据 Docker 网桥的网段分配给容器一个 IP 地址，称为 Container-IP，同时 Docker 网桥是每个容器的默认网关。因为在同一宿主机内的容器都接入同一个网桥，这样容器之间就能够通过容器的 Container-IP 直接通信。

          4.1 bridge

              - docker run 的时候，没有指定 network 的话默认使用的网桥模式就是 bridge，使用的就是 docker0。在宿主机 ifconfig,就可以看到 docker0 和自己 create 的 network(后面讲)eth0，eth1，eth2……代表网卡一，网卡二，网卡三……，lo 代表 127.0.0.1，即 localhost，inet addr 用来表示网卡的 IP 地址
              - 网桥 docker0 创建一对对等虚拟设备接口一个叫 veth，另一个叫 eth0，成对匹配。
              - 整个宿主机的网桥模式都是 docker0，类似一个交换机有一堆接口，每个接口叫 veth，在本地主机和容器内分别创建一个虚拟接口，并让他们彼此联通（这样一对接口叫 veth pair）；
              - 每个容器实例内部也有一块网卡，每个接口叫 eth0； - docker0 上面的每个 veth 匹配某个容器实例内部的 eth0，两两配对，一一匹配。

          4.2 host

              - docker run -d --network host --name tomcat83 tomcat

          4.3 none
          4.4 container
          4.5 自定义网络

五、 Docker-compose 容器编排

是什么：

- Compose 是 Docker 公司推出的一个工具软件，可以管理多个 Docker 容器组成一个应用。你需要定义一个 YAML 格式的配置文件 docker-compose.yml，写好多个容器之间的调用关系。然后，只要一个命令，就能同时启动/关闭这些容器

- Docker-Compose 是 Docker 官方的开源项目， 负责实现对 Docker 容器集群的快速编排

能干什么：

- docker 建议我们每一个容器中只运行一个服务,因为 docker 容器本身占用资源极少,所以最好是将每个服务单独的分割开来但是这样我们又面临了一个问题？

- 如果我需要同时部署好多个服务,难道要每个服务单独写 Dockerfile 然后在构建镜像,构建容器,这样累都累死了,所以 docker 官方给我们提供了 docker-compose 多服务部署的工具

- Compose 允许用户通过一个单独的 docker-compose.yml 模板文件（YAML 格式）来定义一组相关联的应用容器为一个项目（project）。
- 可以很容易地用一个配置文件定义一个多容器的应用，然后使用一条指令安装这个应用的所有依赖，完成构建。Docker-Compose 解决了容器与容器之间如何管理编排的问题。

1.  compose 核心概念

    - 一文件 docker-compose.yml
    - 两要素
      - 服务（service）：一个个应用容器实例
      - 工程（project）：多个服务（容器应用实例）；由一组关联的应用容器组成的一个完整业务单元，在 docker-compose.yml 文件中定义

2.  使用的三个步骤

    - 编写 Dockerfile 定义各个微服务应用并构建出对应的镜像文件
    - 使用 docker-compose.yml 定义一个完整业务单元，安排好整体应用中的各个容器服务。
    - 最后，执行 docker-compose up 命令 来启动并运行整个应用程序，完成一键部署上线

3.  docker-compose 常用命令

    - docker-compose -h                           # 查看帮助
    - docker-compose up                           # 启动所有
    - docker-compose 服务
    - docker-compose up -d                        # 启动所有 docker-compose 服务并后台运行
    - docker-compose down                         # 停止并删除容器、网络、卷、镜像。
    - docker-compose exec  yml 里面的服务 id                 # 进入容器实例内部   docker-compose exec docker-compose.yml 文件中写的服务 id /bin/bash
    - docker-compose ps                      # 展示当前 docker-compose 编排过的运行的所有容器
    - docker-compose top                     # 展示当前 docker-compose 编排过的容器进程
    - docker-compose logs  yml 里面的服务 id     # 查看容器输出日志
    - docker-compose config     # 检查配置
    - docker-compose config -q  # 检查配置，有问题才有输出
    - docker-compose restart   # 重启服务
    - docker-compose start     # 启动服务
    - docker-compose stop      # 停止服务

    docker-compose config -q # 文件语法格式检查

六、Portainer 简介与安装

1. docker 可视化工具
2. cadvisor
3. influxDb
4. granfana
5. compose 容器编排；cadvisor，influxDb,granfana
