# 尚硅谷学习 （https://www.bilibili.com/video/BV1gr4y1U7CY/?spm_id_from=333.999.0.0&vd_source=7f59eb599765afcad560d7047f30c765）

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

二、docker 高级篇
