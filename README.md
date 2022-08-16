# Mongo-Shake-Docker

基于阿里巴巴开源项目 [MongoShake](https://github.com/alibaba/MongoShake) 构建的镜像

具体用法和说明文档可以参考[MongoShake官方文档](https://github.com/alibaba/MongoShake/wiki/%E7%AC%AC%E4%B8%80%E6%AC%A1%E4%BD%BF%E7%94%A8%EF%BC%8C%E5%A6%82%E4%BD%95%E8%BF%9B%E8%A1%8C%E9%85%8D%E7%BD%AE%EF%BC%9F)

DockerHub地址: [monkeyray/mongo-shake](https://hub.docker.com/r/monkeyray/mongo-shake)

---

## 构建状态

[![构建状态](https://monkeyray.coding.net/badges/github/job/1481393/build.svg)](https://monkeyray.coding.net/p/github/ci/job)

---

## 使用方法

### 1.下载并修改官方样例配置文件

```bash
# 下载最新的配置文件
curl -oL https://github.com/alibaba/MongoShake/blob/develop/conf/collector.conf
```

因为不同MongoShake版本对应的配置文件版本也可能不一样,推荐下载修改对应MongoShake版本配置文件:

```bash
# 下载指定release版本的配置文件
curl -oL https://github.com/alibaba/MongoShake/blob/release-v2.7.4-20220615/conf/collector.conf
```

### 2.运行容器服务

容器版本号可以在[DockerHub](https://hub.docker.com/r/monkeyray/mongo-shake/tags)中查询.

运行时可以指定版本号或者直接使用latest版本.

---

### 2.1.直接用docker运行

先自行[安装docker](https://docs.docker.com/engine/install/)

```bash
# 使用最新镜像
sudo docker run monkeyray/mongo-shake:latest

# 使用指定版本镜像
sudo docker run monkeyray/mongo-shake:v2.7.4

# 使用root用户运行容器(默认使用uid和gid均为1000的普通用户)
sudo docker run -u root monkeyray/mongo-shake:latest

# 后台运行并设置自启动
sudo docker run -d --restart on-failure monkeyray/mongo-shake:latest

# 监听指定端口
# 格式为-p host_port:image_port
# host_port为宿主机监听端口
# image_port为镜像内监听端口
sudo docker run -p 9100:9100 -p 9101:9100 -p 9200:9200 monkeyray/mongo-shake:latest

# 使用自定义配置文件
sudo docker run -v /path/of/collector.conf:/opt/mongo-shake/collector.conf monkeyray/mongo-shake:latest

# 使用自定义参数运行
sudo docker run monkeyray/mongo-shake:latest -conf=/opt/mongo-shake/collector.conf -verbose=2

# 汇总拼凑一下...
sudo docker run -d \
    --restart on-failure \
    -p 9100:9100 \
    -p 9101:9100 \
    -p 9200:9200 \
    -v /path/of/collector.conf:/opt/mongo-shake/collector.conf \
    monkeyray/mongo-shake:v2.7.4 \
    -conf=/opt/mongo-shake/collector.conf \
    -verbose=2
```

---

### 2.2.使用docker-compose运行

先自行[安装Docker-compose](https://docs.docker.com/compose/install/)

```bash
mkdir mongo-shake && cd mongo-shake

# 下载docker-compose文件
curl -oL https://github.com/MR-MonkeyRay/mongo-shake-docker/raw/master/docker-compose.yaml

# 启动服务并在后台运行
sudo docker-compose up -d

# 关闭服务
sudo docker-compose down

# 更新服务(若有配置文件变更,则需提前修改好配置文件)
sudo docker-compose pull && sudo docker-compose up -d

# 查看日志
sudo docker-compose logs
```
