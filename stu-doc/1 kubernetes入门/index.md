# 集群类

1. 集群表示一个由 Master 和 Node 组成的 Kubernetes 集群
   - Master：指的是集群的控制节点， 在每个 kubernetes 集群中都需要有一个或一组被称为 master 的节点，来负责整个集群的管理和控制。master 通常占据一个独立的服务器（在高可用部署中建议至少使用 3 台服务器），是整个集群的“大脑”，如果它发生宕机或者不可用，那么对集群内容器应用的管理都将无法实施。
   - 在 master 节点运行着一下进程
     - kubernetes api server，是其对所有资源进行增、删、改、查等操作的唯一入口，也是集群控制的入口进程
     - kubernetes controller manager，所以资源对象的自动化控制中心，可以将其理解为资源对象的“大总管”
     - kubernetes scheduler 负责资源调度（pod 调度）的进程，相当于公交公司的调度室
   - Node： kubernetes 集3群中除 maser 外的其他服务器被称为 node
   - 在 Node 上都运行着以下进程
     - kubelet 负责 pod 对容器的创建、启停等任务，同时与 master 密切协作，实现集群管理等基本功能
     - kube-proxy 实现 kubernetes service 的通信与负载均衡机制的服务
     - 容器运行时 负责本机的容器创建和管理

2. pod： 每个pod都有一个“pause”根容器，，每个pod除了根容器还包含一个或多个紧密相连的用户业务容器
   - 在kubernetes里，一个pod里的容器与另外主机上的pod容器能够直接通信
3. Endpoint 代表pod里的一个服务进程的对外通信地址
4. Label：可以被附加到各种资源对象上，一个资源对象可以定义任意数量的Label,同一个label也可以被添加到任意数量的资源对象上。以便灵活、方便地进行资源分配、调度、配置、部署等管理工作。
   - 标签分类：
     版本标签
     环境标签
     架构标签
     分区标签
     质量管控标签
5. development 对象J: 创建pod副本
6. operator: 部署主流的有状态服务

