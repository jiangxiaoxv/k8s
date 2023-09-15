# Kubernets（https://gitee.com/yooome/golang/blob/main/21-k8s%E8%AF%A6%E7%BB%86%E6%95%99%E7%A8%8B/Kubernetes%E8%AF%A6%E7%BB%86%E6%95%99%E7%A8%8B.md#13-kubernetes%E7%BB%84%E4%BB%B6）

（https://www.bilibili.com/video/BV1Qv41167ck/?p=3&spm_id_from=pageDriver&vd_source=5e17c856bfb7fe8e3c8387a111dcc329）

Kubernetes 是谷歌开源的容器集群管理系统，是 Google 多年大规模容器管理技术 Borg 的开源版本，也是 CNCF 最重要的项目之一，主要功能包括：

    - 基于容器的应用部署、维护和滚动升级
    - 负载均衡和服务发现
    - 跨机器和跨地区的集群调度
    - 自动伸缩
    - 无状态服务和有状态服务
    - 广泛的Volume支持
    - 插件机制保证扩展性

特点：

    - 轻量级：消耗资源小
    - 开源
    - 弹性伸缩
    - 负载均衡：ipvs

核心组件：
一个 kubernetes 集群主要是由控制节点(master)、**工作节点(node)**构成，每个节点上都会安装不同的组件

    - etcd 保存了整个集群的状态；
    - apiserver 提供了资源操作的唯一入口，并提供认证、授权、访问控制、API 注册和发现等机制；
    - controller manager 负责维护集群的状态，比如故障检测、自动扩展、滚动更新等；
    - scheduler 负责资源的调度，按照预定的调度策略将 Pod 调度到相应的机器上；
    - kubelet 负责维护容器的生命周期，同时也负责 Volume（CVI）和网络（CNI）的管理；
    - Container runtime 负责镜像管理以及 Pod 和容器的真正运行（CRI）；
    - kube-proxy 负责为 Service 提供 cluster 内部的服务发现和负载均衡

服务分类

    - 有状态服务：DBMS（有缺失）
    - 无状态服务: LVS APACHE

etcd 的官方将它定义为成一个可信赖的分布式键值存储服务，它能够为整个分布式集群存储一些共建数据，协助分布式集群的正常运转

Kubernetes 基本概念

    - Container：（容器）是一种便携式、轻量级的操作系统级虚拟化技术。它使用 namespace 隔离不同的软件运行环境，并通过镜像自包含软件的运行环境，从而使得容器可以很方便的在任何地方运行。
    - Pod：Kubernetes 使用 Pod 来管理容器，每个 Pod 可以包含一个或多个紧密关联的容器；Pod 是一组紧密关联的容器集合，它们共享 IPC 和 Network namespace，是 Kubernetes 调度的基本单位。Pod 内的多个容器共享网络和文件系统，可以通过进程间通信和文件共享这种简单高效的方式组合完成服务。kubernetes的最小控制单元，容器都是运行在pod中的，一个pod中可以有1个或者多个容器
    - Node 是 Pod 真正运行的主机，可以是物理机，也可以是虚拟机。为了管理 Pod，每个 Node 节点上至少要运行 container runtime（比如 docker 或者 rkt）、kubelet 和 kube-proxy 服务。工作负载节点，由master分配容器到这些node工作节点上，然后node节点上的docker负责容器的运行
    - Namespace：是对一组资源和对象的抽象集合，比如可以用来将系统内部的对象划分为不同的项目组或用户组。常见的 pods, services, replication controllers 和 deployments 等都是属于某一个 namespace 的（默认是 default），而 node, persistentVolumes 等则不属于任何 namespace。命名空间，用来隔离pod的运行环境
    - Service 是应用服务的抽象，通过 labels 为应用提供负载均衡和服务发现。匹配 labels 的 Pod IP 和端口列表组成 endpoints，由 kube-proxy 负责将服务 IP 负载均衡到这些 endpoints 上。pod对外服务的统一入口，下面可以维护者同一类的多个pod
    - Label 是识别 Kubernetes 对象的标签，以 key/value 的方式附加到对象上（key 最长不能超过 63 字节，value 可以为空，也可以是不超过 253 字节的字符串）。标签，用于对pod进行分类，同一类pod会拥有相同的标签
    - Annotations 是 key/value 形式附加于对象的注解。不同于 Labels 用于标志和选择对象，Annotations 则是用来记录一些附加信息，用来辅助应用部署、安全策略以及调度策略等。比如 deployment 使用 annotations 来记录 rolling update 的状态。
    - Master：集群控制节点，每个集群需要至少一个master节点负责集群的管控
    - Controller：控制器，通过它来实现对pod的管理，比如启动pod、停止pod、伸缩pod的数量等等

master：集群的控制平面，负责集群的决策 ( 管理 ) - 组件如下：

    - ApiServer : 资源操作的唯一入口，接收用户输入的命令，提供认证、授权、API 注册和发现等机制

    - Scheduler : 负责集群资源调度，按照预定的调度策略将 Pod 调度到相应的 node 节点上

    - ControllerManager : 负责维护集群的状态，比如程序部署安排、故障检测、自动扩展、滚动更新等

    - Etcd ：负责存储集群中各种资源对象的信息

node：集群的数据平面，负责为容器提供运行环境 ( 干活 )

    - Kubelet : 负责维护容器的生命周期，即通过控制docker，来创建、更新、销毁容器

    - KubeProxy : 负责提供集群内部的服务发现和负载均衡

    - Docker : 负责节点上容器的各种操作

集群类型：

    - 一主多从
    - 多主多从
