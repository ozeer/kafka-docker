# 1、创建网络
## 创建，注意不能使用hadoop_network，要不然启动hs2服务的时候会有问题！！！
docker network create hadoop-network

## 查看
docker network ls

# 2、Kafka部署
## 下载Kafka
```
wget https://downloads.apache.org/kafka/3.4.0/kafka_2.12-3.4.0.tgz --no-check-certificate
```
## 配置Kafka


# 参考博客
- https://www.cnblogs.com/liugp/p/17418924.html