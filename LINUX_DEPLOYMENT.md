# Linux 部署指南

本文档提供了在Linux环境下构建和部署微服务项目的完整指南。

## 📋 前置要求

在开始之前，请确保Linux系统已安装以下软件：

```bash
# Java 17 或更高版本
java -version

# Maven 3.6 或更高版本
mvn -version

# curl (用于测试)
curl --version

# Docker (可选，用于容器化部署)
docker --version
docker-compose --version
```

## 🚀 快速开始

### 1. 设置脚本权限

首先为所有shell脚本添加执行权限：

```bash
chmod +x *.sh
```

### 2. 构建项目

```bash
# 构建所有微服务
./build-all.sh
```

### 3. 启动服务

```bash
# 启动所有微服务
./start-all.sh
```

### 4. 测试服务

```bash
# 测试所有服务
./test-services.sh
```

### 5. 检查状态

```bash
# 检查服务状态
./status.sh
```

### 6. 停止服务

```bash
# 停止所有服务
./stop-all.sh
```

## 📜 脚本说明

### build-all.sh
构建所有微服务的JAR文件。

**功能：**
- 构建父项目
- 构建user-service
- 构建order-service  
- 构建product-service
- 生成可执行的Fat JAR文件

**使用方法：**
```bash
./build-all.sh
```

### start-all.sh
启动所有微服务。

**功能：**
- 检查JAR文件是否存在
- 使用nohup后台启动服务
- 保存进程PID到文件
- 生成日志文件
- 显示服务URL和状态信息

**使用方法：**
```bash
./start-all.sh
```

**生成的文件：**
- `user-service.log` - 用户服务日志
- `order-service.log` - 订单服务日志
- `product-service.log` - 产品服务日志
- `user-service.pid` - 用户服务进程ID
- `order-service.pid` - 订单服务进程ID
- `product-service.pid` - 产品服务进程ID

### stop-all.sh
停止所有微服务。

**功能：**
- 通过PID文件优雅停止服务
- 如果优雅停止失败，强制终止
- 通过端口查找并停止服务
- 清理PID文件
- 保留日志文件

**使用方法：**
```bash
./stop-all.sh
```

### test-services.sh
测试所有微服务功能。

**功能：**
- 健康检查所有服务
- 创建测试数据
- 验证CRUD操作
- 显示测试结果

**使用方法：**
```bash
./test-services.sh
```

### status.sh
检查微服务状态。

**功能：**
- 检查端口监听状态
- 健康检查
- 进程状态检查
- Docker容器状态
- 日志文件状态
- 系统资源使用情况

**使用方法：**
```bash
./status.sh
```

### deploy-docker.sh
使用Docker部署微服务。

**功能：**
- 自动创建Dockerfile
- 构建Docker镜像
- 生成docker-compose.yml
- 启动容器化服务

**使用方法：**
```bash
./deploy-docker.sh
```

**Docker命令：**
```bash
# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down

# 重启服务
docker-compose restart

# 查看状态
docker-compose ps
```

### cleanup.sh
清理项目构建产物和日志。

**功能：**
- 清理Maven target目录
- 清理Docker资源
- 清理日志和PID文件
- 可选清理Maven缓存

**使用方法：**
```bash
# 完整清理
./cleanup.sh

# 仅清理Docker
./cleanup.sh --docker

# 仅清理日志
./cleanup.sh --logs

# 仅清理Maven缓存
./cleanup.sh --maven

# 查看帮助
./cleanup.sh --help
```

## 🌐 服务信息

### 服务端口
- **User Service**: 8081
- **Order Service**: 8082  
- **Product Service**: 8083

### API端点
- **User Service**: http://localhost:8081/api/users
- **Order Service**: http://localhost:8082/api/orders
- **Product Service**: http://localhost:8083/api/products

### 健康检查
- **User Service**: http://localhost:8081/api/users/health
- **Order Service**: http://localhost:8082/api/orders/health
- **Product Service**: http://localhost:8083/api/products/health

### H2 数据库控制台
- **User Service**: http://localhost:8081/h2-console
- **Order Service**: http://localhost:8082/h2-console
- **Product Service**: http://localhost:8083/h2-console

## 🔧 故障排除

### 常见问题

1. **端口被占用**
```bash
# 查看端口使用情况
netstat -tuln | grep 808

# 杀死占用端口的进程
sudo lsof -ti:8081 | xargs kill -9
```

2. **Java进程未正常停止**
```bash
# 查找Java进程
ps aux | grep java

# 强制终止特定进程
kill -9 <PID>

# 或使用脚本清理
pkill -f "user-service-1.0.0.jar"
```

3. **权限问题**
```bash
# 确保脚本有执行权限
chmod +x *.sh

# 如果需要sudo权限
sudo ./script-name.sh
```

4. **Maven构建失败**
```bash
# 清理Maven缓存
rm -rf ~/.m2/repository

# 重新构建
./build-all.sh
```

5. **Docker问题**
```bash
# 检查Docker状态
sudo systemctl status docker

# 启动Docker
sudo systemctl start docker

# 清理Docker资源
docker system prune -f
```

### 日志查看

```bash
# 实时查看日志
tail -f user-service.log
tail -f order-service.log
tail -f product-service.log

# 查看所有日志
tail -f *.log

# 搜索错误日志
grep -i error *.log
grep -i exception *.log
```

## 🚀 生产环境部署建议

### 1. 系统配置
```bash
# 增加文件描述符限制
echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf

# 优化JVM参数
export JAVA_OPTS="-Xms512m -Xmx1024m -XX:+UseG1GC"
```

### 2. 服务管理
建议使用systemd管理服务：

```bash
# 创建服务文件
sudo tee /etc/systemd/system/user-service.service > /dev/null <<EOF
[Unit]
Description=User Service
After=network.target

[Service]
Type=simple
User=app
WorkingDirectory=/opt/microsvc
ExecStart=/usr/bin/java -jar user-service/target/user-service-1.0.0.jar
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启用并启动服务
sudo systemctl enable user-service
sudo systemctl start user-service
```

### 3. 监控和日志
```bash
# 使用logrotate管理日志
sudo tee /etc/logrotate.d/microsvc > /dev/null <<EOF
/opt/microsvc/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    copytruncate
}
EOF
```

### 4. 负载均衡
使用Nginx进行负载均衡：

```nginx
upstream user-service {
    server localhost:8081;
}

upstream order-service {
    server localhost:8082;
}

upstream product-service {
    server localhost:8083;
}

server {
    listen 80;
    
    location /api/users {
        proxy_pass http://user-service;
    }
    
    location /api/orders {
        proxy_pass http://order-service;
    }
    
    location /api/products {
        proxy_pass http://product-service;
    }
}
```

## 📞 支持

如果遇到问题，请检查：
1. 日志文件中的错误信息
2. 服务状态 (`./status.sh`)
3. 系统资源使用情况
4. 网络连接和端口状态

更多信息请参考项目README.md文件。
