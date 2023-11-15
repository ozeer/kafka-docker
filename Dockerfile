FROM centos:7

RUN rm -f /etc/localtime && ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN export LANG=zh_CN.UTF-8

# 创建用户和用户组，跟yaml编排里的user: 10000:10000
RUN groupadd --system --gid=10000 hadoop && useradd --system --home-dir /home/hadoop --uid=10000 --gid=hadoop hadoop -m

# 安装sudo
RUN yum -y install sudo; chmod 640 /etc/sudoers

# 创建sudoers文件
RUN echo "hadoop ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 安装必要的工具
RUN yum -y install net-tools telnet wget nc less

# 创建Apache目录
RUN mkdir /opt/apache

# 添加配置 JDK(Jdk下载地址：https://www.oracle.com/java/technologies/downloads/)
ADD jdk-8u391-linux-x64.tar.gz /opt/apache/
ENV JAVA_HOME /opt/apache/jdk1.8.0_391
ENV PATH $JAVA_HOME/bin:$PATH

# 添加配置 kafka server(Kafka下载地址：https://downloads.apache.org/kafka/3.6.0/)
ENV KAFKA_VERSION 2.12-3.6.0
ADD kafka_${KAFKA_VERSION}.tgz /opt/apache/
ENV KAFKA_HOME /opt/apache/kafka
RUN ls -l /opt/apache
RUN ln -s /opt/apache/kafka_${KAFKA_VERSION} $KAFKA_HOME

# 创建数据存储目录
RUN mkdir -p ${KAFKA_HOME}/data/logs

# 复制bootstrap.sh
COPY bootstrap.sh /opt/apache/
RUN chmod +x /opt/apache/bootstrap.sh

# 设置所有权
RUN chown -R hadoop:hadoop /opt/apache

# 创建工作目录
WORKDIR $KAFKA_HOME
