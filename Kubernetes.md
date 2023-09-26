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

命令式：yml 创建

    - kubectl create -f nginxpod.yaml # 根据配置文件创建资源
    - kubectl get ns dev # 查看资源，dev的命名空间
    - kubectl get pod -n dev # dev的命名空间下有多少个pod
    - kubectl delete -f nginxpod.yaml # 资源的都删除
    - kubetcl get -f nginxpod.yaml

声明式对象配置

    - kubectl apply -f nginxpod.yaml

    总结:
        其实声明式对象配置就是使用 apply 描述一个资源最终的状态（在 yaml 中定义状态）
        使用 apply 操作资源：
        如果资源不存在，就创建，相当于 kubectl create
        如果资源已存在，就更新，相当于 kubectl patch

    创建/更新资源 使用声明式对象配置 kubectl apply -f XXX.yaml

    删除资源 使用命令式对象配置 kubectl delete -f XXX.yaml

    查询资源 使用命令式对象管理 kubectl get(describe) 资源名称

# kubernets 实战

1.  namespace(多环境的隔离，开发，测试，生产)

    - Namespace 是 kubernetes 系统中的一种非常重要资源，它的主要作用是用来实现多套环境的资源隔离或者多租户的资源隔离。
    - 默认情况下，kubernetes 集群中的所有的 Pod 都是可以相互访问的。但是在实际中，可能不想让两个 Pod 之间进行互相的访问，那此时就可以将两个 Pod 划分到不同的 namespace 下。kubernetes 通过将集群内部的资源分配到不同的 Namespace 中，可以形成逻辑上的"组"，以方便不同的组的资源进行隔离使用和管理。

    - 可以通过 kubernetes 的授权机制，将不同的 namespace 交给不同租户进行管理，这样就实现了多租户的资源隔离。此时还能结合 kubernetes 的资源配额机制，限定不同租户能占用的资源，例如 CPU 使用量、内存使用量等等，来实现租户可用资源的管理。

    - kubernetes 在集群启动之后，会默认创建几个 namespace

    - kubectl get namespace
      default Active 45h # 所有未指定 Namespace 的对象都会被分配在 default 命名空间
      kube-node-lease Active 45h # 集群节点之间的心跳维护，v1.13 开始引入
      kube-public Active 45h # 此命名空间下的资源可以被所有人访问（包括未认证用户）
      kube-system Active 45h # 所有由 Kubernetes 系统创建的资源都处于这个命名空间
    - kubectl get pods -n kube-system

      1.1 具体操作

    - kubectl get ns
    - kubectl get ns default
    - kubectl describe ns default

    - kubectl create ns dev
    - kubectl get ns dev
    - kubectl delete ns dev

    - kubectl create -f nginxpod.yaml
    - kubectl delete -f nginxpod.yaml

2.  pod

    - Pod 是 kubernetes 集群进行管理的最小单元，程序要运行必须部署在容器中，而容器必须存在于 Pod 中。

    - Pod 可以认为是容器的封装，一个 Pod 中可以存在一个或者多个容器。

    - kubernetes 在集群启动之后，集群中的各个组件也都是以 Pod 方式运行的。可以通过下面命令查看：

      kubectl get pod -n kube-system

            NAME READY STATUS RESTARTS AGE

            coredns-78fcd69978-65kql                1/1 Running 0 7d1h
            coredns-78fcd69978-tvzdf                1/1 Running 0 7d1h
            etcd-docker-desktop                     1/1 Running 0 7d1h
            kube-apiserver-docker-desktop           1/1 Running 0 7d1h
            kube-controller-manager-docker-desktop  1/1 Running 0 7d1h
            kube-proxy-ldzqw                        1/1 Running 0 7d1h
            kube-scheduler-docker-desktop           1/1 Running 0 7d1h
            storage-provisioner                     1/1 Running 0 7d1h
            vpnkit-controller                       1/1 Running 224 (12m ago) 7d1h

    - kubernetes 没有提供单独运行 Pod 的命令，都是通过 Pod 控制器来实现的
      kubectl run nginx --image=nginx:latest --port=80 --namespace dev

            deployment.apps/nginx created

    - kubectl get pod -n dev
    - kubectl describe pod nginx -n dev
    - kubectl get pod -n dev -o wide

    - kubectl delete pod nginx -n dev

3.  Label

        - Label 是 kubernetes 系统中的一个重要概念。它的作用就是在资源上添加标识，用来对它们进行区分和选择。
          Label 的特点：

                一个 Label 会以 key/value 键值对的形式附加到各种对象上，如 Node、Pod、Service 等等
                一个资源对象可以定义任意数量的 Label ，同一个 Label 也可以被添加到任意数量的资源对象上去
                Label 通常在资源对象定义时确定，当然也可以在对象创建后动态添加或者删除

        - 可以通过 Label 实现资源的多维度分组，以便灵活、方便地进行资源分配、调度、配置、部署等管理工作。
        - 标签定义完毕之后，还要考虑到标签的选择，这就要使用到 Label Selector，即：
          基于等式的 Label Selector
          基于集合的 Label Selector

        - kubectl get pod -n dev --show-labels
        - kubectl label pod nginx -n dev version=1.0
          kubectl label pod nginx-pod version=2.0 -n dev --overwrite
        - kubectl get pod -n dev -l version=2.0  --show-labels
        - kubectl label pod nginx -n dev version-

4.  deployment
    在 kubernetes 中，Pod 是最小的控制单元，但是 kubernetes 很少直接控制 Pod，一般都是通过 Pod 控制器来完成的。Pod 控制器用于 pod 的管理，确保 pod 资源符合预期的状态，当 pod 的资源出现故障时，会尝试进行重启或重建 pod。
    - kubectl run nginx --image=nginx:latest --port=80 --replicas=3 -n dev
    - kubectl get pods -n dev
    - kubectl describe deploy nginx -n dev
    - kubectl delte deploy nginx -n dev
5.  Service
    虽然每个 Pod 都会分配一个单独的 Pod IP，然而却存在如下两问题：

        Pod IP 会随着 Pod 的重建产生变化
        Pod IP 仅仅是集群内可见的虚拟 IP，外部无法访问
        这样对于访问这个服务带来了难度。因此，kubernetes 设计了 Service 来解决这个问题。

    Service 可以看作是一组同类 Pod 对外的访问接口。借助 Service，应用可以方便地实现服务发现和负载均衡

    - kubectl expose deploy nginx --name=svc-nginx1 --type=ClusterIP --port=80 --target-port=80 -n dev # 集群内部能访问 service
    - kubectl get service -n dev
    - kubectl get svc svc-nginx1 -n dev -o wide
    - kubectl expose deploy nginx --name=svc-nginx2 --type=NodePort --port=80 --target-port=80 -n dev #集群外部可以访问 #http://localhost:31888/
    - kubectl svc svc-nginx1 -n dev

    然后就可以执行对应的创建和删除命令了：

    创建：kubectl create -f svc-nginx.yaml

    删除：kubectl delete -f svc-nginx.yaml

# POD 详解

1. pod 结构
   每个 Pod 中都可以包含一个或者多个容器，这些容器可以分为两类：
   用户程序所在的容器，数量可多可少

   Pause 容器，这是每个 Pod 都会有的一个根容器，它的作用有两个：

   可以以它为依据，评估整个 Pod 的健康状态

   可以在根容器上设置 Ip 地址，其它容器都此 Ip（Pod IP），以实现 Pod 内部的网路通信

   - kubectl explain pod（一级属性）
   - kubectl explain pod.metadata(二级属性)
   - kubectl get pods nginx-658f4cf99f-cm8kd -n dev -o yaml # 以 yaml 文件显示 pod 信息

在 kubernetes 中基本所有资源的一级属性都是一样的，主要包含 5 部分：

apiVersion 版本，由 kubernetes 内部定义，版本号必须可以用 kubectl api-versions 查询到
kind 类型，由 kubernetes 内部定义，版本号必须可以用 kubectl api-resources 查询到
metadata 元数据，主要是资源标识和说明，常用的有 name、namespace、labels 等
spec 描述，这是配置中最重要的一部分，里面是对各种资源配置的详细描述
status 状态信息，里面的内容不需要定义，由 kubernetes 自动生成

2.  pod 定义
3.  pod 配置
    镜像拉取策略
    imagePullPolicy，用于设置镜像拉取策略，kubernetes 支持配置三种拉取策略：

    Always：总是从远程仓库拉取镜像（一直远程下载）
    IfNotPresent：本地有则使用本地镜像，本地没有则从远程仓库拉取镜像（本地有就本地 本地没远程下载）
    Never：只使用本地镜像，从不去远程仓库拉取，本地没有就报错 （一直使用本地）

    - kubectl exec pod-command -n dev -it -c busybox /bin/sh

    资源配额
    容器中的程序要运行，肯定是要占用一定资源的，比如 cpu 和内存等，如果不对某个容器的资源做限制，那么它就可能吃掉大量资源，导致其它容器无法运行。针对这种情况，kubernetes 提供了对内存和 cpu 的资源进行配额的机制，这种机制主要通过 resources 选项实现，他有两个子选项：

    limits：用于限制运行时容器的最大占用资源，当容器占用资源超过 limits 时会被终止，并进行重启
    requests ：用于设置容器需要的最小资源，如果环境资源不够，容器将无法启动

4.  pod 生命周期

    我们一般将 pod 对象从创建至终的这段时间范围称为 pod 的生命周期，它主要包含下面的过程：
    pod 创建过程
    运行初始化容器（init container）过程
    运行主容器（main container）
    容器启动后钩子（post start）、容器终止前钩子（pre stop）
    容器的存活性探测（liveness probe）、就绪性探测（readiness probe）
    pod 终止过程

    在整个生命周期中，Pod 会出现 5 种状态（相位），分别如下：

    挂起（Pending）：apiserver 已经创建了 pod 资源对象，但它尚未被调度完成或者仍处于下载镜像的过程中
    运行中（Running）：pod 已经被调度至某节点，并且所有容器都已经被 kubelet 创建完成
    成功（Succeeded）：pod 中的所有容器都已经成功终止并且不会被重启
    失败（Failed）：所有容器都已经终止，但至少有一个容器终止失败，即容器返回了非 0 值的退出状态
    未知（Unknown）：apiserver 无法正常获取到 pod 对象的状态信息，通常由网络通信失败所导致

    - 容器探测
      容器探测用于检测容器中的应用实例是否正常工作，是保障业务可用性的一种传统机制。如果经过探测，实例的状态不符合预期，那么 kubernetes 就会把该问题实例" 摘除 "，不承担业务流量。kubernetes 提供了两种探针来实现容器探测，分别是：

      liveness probes：存活性探针，用于检测应用实例当前是否处于正常运行状态，如果不是，k8s 会重启容器
      readiness probes：就绪性探针，用于检测应用实例当前是否可以接收请求，如果不能，k8s 不会转发流量

    - 容器重启策略
      一旦容器探测出现了问题，kubernetes 就会对容器所在的 Pod 进行重启，其实这是由 pod 的重启策略决定的，pod 的重启策略有 3 种，分别如下：

      Always ：容器失效时，自动重启该容器，这也是默认值。
      OnFailure ： 容器终止运行且退出码不为 0 时重启
      Never ： 不论状态为何，都不重启该容器

5.  pod 调度

    在默认情况下，一个 Pod 在哪个 Node 节点上运行，是由 Scheduler 组件采用相应的算法计算出来的，这个过程是不受人工控制的。但是在实际使用中，这并不满足的需求，因为很多情况下，我们想控制某些 Pod 到达某些节点上，那么应该怎么做呢？这就要求了解 kubernetes 对 Pod 的调度规则，kubernetes 提供了四大类调度方式：

         自动调度：运行在哪个节点上完全由 Scheduler 经过一系列的算法计算得出
         定向调度：NodeName、NodeSelector
         亲和性调度：NodeAffinity、PodAffinity、PodAntiAffinity
         污点（容忍）调度：Taints、Toleration

    - 定向调度
      定向调度，指的是利用在 pod 上声明 nodeName 或者 nodeSelector，以此将 Pod 调度到期望的 node 节点上。注意，这里的调度是强制的，这就意味着即使要调度的目标 Node 不存在，也会向上面进行调度，只不过 pod 运行失败而已。
    - 亲和性调度
      它在 NodeSelector 的基础之上的进行了扩展，可以通过配置的形式，实现优先选择满足条件的 Node 进行调度，如果没有，也可以调度到不满足条件的节点上，使调度更加灵活。
      Affinity（亲和性） 主要分为三类：
      nodeAffinity(node 亲和性）: 以 node 为目标，解决 pod 可以调度到哪些 node 的问题
      podAffinity(pod 亲和性) : 以 pod 为目标，解决 pod 可以和哪些已存在的 pod 部署在同一个拓扑域中的问题
      podAntiAffinity(pod 反亲和性) : 以 pod 为目标，解决 pod 不能和哪些已存在 pod 部署在同一个拓扑域中的问题

    - 污点和容忍
      Node 被设置上污点之后就和 Pod 之间存在了一种相斥的关系，进而拒绝 Pod 调度进来，甚至可以将已经存在的 Pod 驱逐出去。
      污点就是拒绝，容忍就是忽略，Node 通过污点拒绝 pod 调度上去，Pod 通过容忍忽略拒绝

# pod 控制器

1.  控制器介绍
    Pod 是 kubernetes 的最小管理单元，在 kubernetes 中，按照 pod 的创建方式可以将其分为两类：

    自主式 pod：kubernetes 直接创建出来的 Pod，这种 pod 删除后就没有了，也不会重建
    控制器创建的 pod：kubernetes 通过控制器创建的 pod，这种 pod 删除了之后还会自动重建

    Pod 控制器是管理 pod 的中间层，使用 Pod 控制器之后，只需要告诉 Pod 控制器，想要多少个什么样的 Pod 就可以了，它会创建出满足条件的 Pod 并确保每一个 Pod 资源处于用户期望的目标状态。如果 Pod 资源在运行中出现故障，它会基于指定策略重新编排 Pod。

    在 kubernetes 中，有很多类型的 pod 控制器，每种都有自己的适合的场景，常见的有下面这些：

    ReplicationController：比较原始的 pod 控制器，已经被废弃，由 ReplicaSet 替代
    ReplicaSet：保证副本数量一直维持在期望值，并支持 pod 数量扩缩容，镜像版本升级
    Deployment：通过控制 ReplicaSet 来控制 Pod，并支持滚动升级、回退版本
    Horizontal Pod Autoscaler：可以根据集群负载自动水平调整 Pod 的数量，实现削峰填谷
    DaemonSet：在集群中的指定 Node 上运行且仅运行一个副本，一般用于守护进程类的任务
    Job：它创建出来的 pod 只要完成任务就立即退出，不需要重启或重建，用于执行一次性任务
    Cronjob：它创建的 Pod 负责周期性任务控制，不需要持续后台运行
    StatefulSet：管理有状态应用

    - ReplicaSet
      ReplicaSet 的主要作用是保证一定数量的 pod 正常运行，它会持续监听这些 Pod 的运行状态，一旦 Pod 发生故障，就会重启或重建。同时它还支持对 pod 数量的扩缩容和镜像版本的升降级。

    - Deployment(Deploy)
      为了更好的解决服务编排的问题，kubernetes 在 V1.2 版本开始，引入了 Deployment 控制器。值得一提的是，这种控制器并不直接管理 pod，而是通过管理 ReplicaSet 来简介管理 Pod，即：Deployment 管理 ReplicaSet，ReplicaSet 管理 Pod。所以 Deployment 比 ReplicaSet 功能更加强大。

          Deployment 主要功能有下面几个：

                  支持 ReplicaSet 的所有功能
                  支持发布的停止、继续
                  支持滚动升级和回滚版本

          镜像更新

          deployment 支持两种更新策略:重建更新和滚动更新,可以通过 strategy 指定策略类型,支持两个属性:

                strategy：指定新的Pod替换旧的Pod的策略， 支持两个属性：
                type：指定策略类型，支持两种策略
                Recreate：在创建出新的 Pod 之前会先杀掉所有已存在的 Pod
                RollingUpdate：滚动更新，就是杀死一部分，就启动一部分，在更新过程中，存在两个版本 Pod
                rollingUpdate：当 type 为 RollingUpdate 时生效，用于为 RollingUpdate 设置参数，支持两个属性：
                maxUnavailable：用来指定在升级过程中不可用 Pod 的最大数量，默认为 25%。
                max 违规词汇： 用来指定在升级过程中可以超过期望的 Pod 的最大数量，默认为 25%。

      金丝雀发布
      Deployment 控制器支持控制更新过程中的控制，如“暂停(pause)”或“继续(resume)”更新操作。

      比如有一批新的 Pod 资源创建完成后立即暂停更新过程，此时，仅存在一部分新版本的应用，主体部分还是旧的版本。然后，再筛选一小部分的用户请求路由到新版本的 Pod 应用，继续观察能否稳定地按期望的方式运行。确定没问题之后再继续完成余下的 Pod 资源滚动更新，否则立即回滚更新操作。这就是所谓的金丝雀发布。

    - Horizontal Pod Autoscaler(HPA)
      Kubernetes 的定位目标--自动化、智能化。 Kubernetes 期望可以实现通过监测 Pod 的使用情况，实现 pod 数量的自动调整，于是就产生了 Horizontal Pod Autoscaler（HPA）这种控制器。

      HPA 可以获取每个 Pod 利用率，然后和 HPA 中定义的指标进行对比，同时计算出需要伸缩的具体值，最后实现 Pod 的数量的调整。其实 HPA 与之前的 Deployment 一样，也属于一种 Kubernetes 资源对象，它通过追踪分析 RC 控制的所有目标 Pod 的负载变化情况，来确定是否需要针对性地调整目标 Pod 的副本数，这是 HPA 的实现原理。

    - DaemonSet 类型的控制器可以保证在集群中的每一台（或指定）节点上都运行一个副本。一般适用于日志收集、节点监控等场景。也就是说，如果一个 Pod 提供的功能是节点级别的（每个节点都需要且只需要一个），那么这类 Pod 就适合使用 DaemonSet 类型的控制器创建。

# Service 详解

1.  介绍
    在 kubernetes 中，pod 是应用程序的载体，我们可以通过 pod 的 ip 来访问应用程序，但是 pod 的 ip 地址不是固定的，这也就意味着不方便直接采用 pod 的 ip 对服务进行访问。

    为了解决这个问题，kubernetes 提供了 Service 资源，Service 会对提供同一个服务的多个 pod 进行聚合，并且提供一个统一的入口地址。通过访问 Service 的入口地址就能访问到后面的 pod 服务。

    Service 在很多情况下只是一个概念，真正起作用的其实是 kube-proxy 服务进程，每个 Node 节点上都运行着一个 kube-proxy 服务进程。当创建 Service 的时候会通过 api-server 向 etcd 写入创建的 service 的信息，而 kube-proxy 会基于监听的机制发现这种 Service 的变动，然后它会将最新的 Service 信息转换成对应的访问规则。

    - kube-proxy 目前支持三种工作模式:
      serspace 模式
      userspace 模式下，kube-proxy 会为每一个 Service 创建一个监听端口，发向 Cluster IP 的请求被 Iptables 规则重定向到 kube-proxy 监听的端口上，kube-proxy 根据 LB 算法选择一个提供服务的 Pod 并和其建立链接，以将请求转发到 Pod 上。 该模式下，kube-proxy 充当了一个四层负责均衡器的角色。由于 kube-proxy 运行在 userspace 中，在进行转发处理时会增加内核和用户空间之间的数据拷贝，虽然比较稳定，但是效率比较低

      iptables 模式
      iptables 模式下，kube-proxy 为 service 后端的每个 Pod 创建对应的 iptables 规则，直接将发向 Cluster IP 的请求重定向到一个 Pod IP。 该模式下 kube-proxy 不承担四层负责均衡器的角色，只负责创建 iptables 规则。该模式的优点是较 userspace 模式效率更高，但不能提供灵活的 LB 策略，当后端 Pod 不可用时也无法进行重试。

    ClusterIP：默认值，它是 Kubernetes 系统自动分配的虚拟 IP，只能在集群内部访问
    NodePort：将 Service 通过指定的 Node 上的端口暴露给外部，通过此方法，就可以在集群外部访问服务
    LoadBalancer：使用外接负载均衡器完成到服务的负载分发，注意此模式需要外部云环境支持
    ExternalName： 把集群外部的服务引入集群内部，直接使用

2.  Ingress 介绍
    NodePort 方式的缺点是会占用很多集群机器的端口，那么当集群服务变多的时候，这个缺点就愈发明显
    LB 方式的缺点是每个 service 需要一个 LB，浪费、麻烦，并且需要 kubernetes 之外设备的支持
    Ingress 只需要一个 NodePort 或者一个 LB 就可以满足暴露多个 Service 的需求
    Ingress 里建立诸多映射规则，Ingress Controller 通过监听这些配置规则并转化成 Nginx 的反向代理配置 , 在这里有两个核心概念：

         ingress：kubernetes 中的一个对象，作用是定义请求如何转发到 service 的规则
         ingress controller：具体实现反向代理及负载均衡的程序，对 ingress 定义的规则进行解析，根据配置的规则来实现请求转发，实现方式有很多，比如 Nginx, Contour, Haproxy 等等

# 数据存储

Volume 是 Pod 中能够被多个容器访问的共享目录，它被定义在 Pod 上，然后被一个 Pod 里的多个容器挂载到具体的文件目录下，kubernetes 通过 Volume 实现同一个 Pod 中不同容器之间的数据共享以及数据的持久化存储。Volume 的生命容器不与 Pod 中单个容器的生命周期相关，当容器终止或者重启时，Volume 中的数据也不会丢失。

kubernetes 的 Volume 支持多种类型，比较常见的有下面几个：

简单存储：EmptyDir、HostPath、NFS
高级存储：PV、PVC
配置存储：ConfigMap、Secret

1.  基本存储

    - EmptyDir 是最基础的 Volume 类型，一个 EmptyDir 就是 Host 上的一个空目录。

    EmptyDir 是在 Pod 被分配到 Node 时创建的，它的初始内容为空，并且无须指定宿主机上对应的目录文件，因为 kubernetes 会自动分配一个目录，当 Pod 销毁时， EmptyDir 中的数据也会被永久删除。 EmptyDir 用途如下：

         临时空间，例如用于某些应用程序运行时所需的临时目录，且无须永久保留
         一个容器需要从另一个容器中获取数据的目录（多容器共享目录）

    - HostPath
      EmptyDir 中数据不会被持久化，它会随着 Pod 的结束而销毁，如果想简单的将数据持久化到主机中，可以选择 HostPath。

      HostPath 就是将 Node 主机中一个实际目录挂在到 Pod 中，以供容器使用，这样的设计就可以保证 Pod 销毁了，但是数据依据可以存在于 Node 主机上。

    - NFS
      HostPath 可以解决数据持久化的问题，但是一旦 Node 节点故障了，Pod 如果转移到了别的节点，又会出现问题了，此时需要准备单独的网络存储系统，比较常用的用 NFS、CIFS。

      NFS 是一个网络文件存储系统，可以搭建一台 NFS 服务器，然后将 Pod 中的存储直接连接到 NFS 系统上，这样的话，无论 Pod 在节点上怎么转移，只要 Node 跟 NFS 的对接没问题，数据就可以成功访问。

2.  高级存储
    前面已经学习了使用 NFS 提供存储，此时就要求用户会搭建 NFS 系统，并且会在 yaml 配置 nfs。由于 kubernetes 支持的存储系统有很多，要求客户全都掌握，显然不现实。为了能够屏蔽底层存储实现的细节，方便用户使用， kubernetes 引入 PV 和 PVC 两种资源对象。

        PV（Persistent Volume）是持久化卷的意思，是对底层的共享存储的一种抽象。一般情况下 PV 由 kubernetes 管理员进行创建和配置，它与底层具体的共享存储技术有关，并通过插件完成与共享存储的对接。

        PVC（Persistent Volume Claim）是持久卷声明的意思，是用户对于存储需求的一种声明。换句话说，PVC 其实就是用户向 kubernetes 系统发出的一种资源需求申请。

    使用了 PV 和 PVC 之后，工作可以得到进一步的细分：

    存储：存储工程师维护
    PV： kubernetes 管理员维护
    PVC：kubernetes 用户维护

3.  configMap
    ConfigMap 是一种比较特殊的存储卷，它的主要作用是用来存储配置信息的。
    在 kubernetes 中，还存在一种和 ConfigMap 非常类似的对象，称为 Secret 对象。它主要用于存储敏感信息，例如密码、秘钥、证书等等。

# 安全认证

Kubernetes 作为一个分布式集群的管理工具，保证集群的安全性是其一个重要的任务。所谓的安全性其实就是保证对 Kubernetes 的各种客户端进行认证和鉴权操作。
在 Kubernetes 集群中，客户端通常有两类：

User Account：一般是独立于 kubernetes 之外的其他服务管理的用户账号。
Service Account：kubernetes 管理的账号，用于为 Pod 中的服务进程在访问 Kubernetes 时提供身份标识。
