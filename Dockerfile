FROM centos:7
LABEL maintainer="jxx<1043479536@qq.com>"

ENV MYPATH /usr/local

WORKDIR ${MYPATH}

RUN yum list glibc.i686
RUN yum update

#安装vim编辑器
RUN yum -y install vim
#安装ifconfig命令查看网络IP
RUN yum -y install net-tools
#安装java8及lib库
# RUN yum -y install glibc.i686
# RUN yum -y install openjdk8
RUN yum install java-1.8.0-openjdk  java-1.8.0-openjdk-devel



RUN mkdir /usr/local/java


#ADD 是相对路径jar,把jdk-8u171-linux-x64.tar.gz添加到容器中,安装包必须要和Dockerfile文件在同一位置
ADD jdk-8u171-linux-x64.tar.gz /usr/local/java/


#配置java环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_171
ENV JRE_HOME $JAVA_HOME/jre

ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib:$CLASSPATH
ENV PATH $JAVA_HOME/bin:$PATH

EXPOSE 80
CMD echo $MYPATH
CMD echo "success--------------ok"
CMD /bin/bash



