# 微服务项目

这是一个包含3个Java Web微服务的项目，使用Spring Boot框架开发。

## 项目结构

```
microsvc/
├── pom.xml                    # 父级Maven配置
├── build-all.bat             # Windows构建脚本
├── start-all.bat             # Windows启动脚本
├── stop-all.bat              # Windows停止脚本
├── test-services.bat         # Windows测试脚本
├── build-all.sh              # Linux构建脚本
├── start-all.sh              # Linux启动脚本
├── stop-all.sh               # Linux停止脚本
├── test-services.sh          # Linux测试脚本
├── deploy-docker.sh          # Docker部署脚本
├── status.sh                 # 服务状态检查脚本
├── cleanup.sh                # 清理脚本
├── help.sh                   # 帮助脚本
├── LINUX_DEPLOYMENT.md       # Linux部署指南
├── user-service/             # 用户服务 (端口: 8081)
├── order-service/            # 订单服务 (端口: 8082)
└── product-service/          # 产品服务 (端口: 8083)
```

## 微服务说明

### 1. User Service (用户服务) - 端口 8081
- 管理用户信息
- API端点: `/api/users`
- 功能: 创建、查询、更新、删除用户

### 2. Order Service (订单服务) - 端口 8082
- 管理订单信息
- API端点: `/api/orders`
- 功能: 创建、查询、更新订单状态

### 3. Product Service (产品服务) - 端口 8083
- 管理产品信息
- API端点: `/api/products`
- 功能: 创建、查询、更新、删除产品

## 快速开始

### 前置要求
- Java 17 或更高版本
- Maven 3.6 或更高版本

### Windows 环境

#### 1. 构建所有服务
```cmd
build-all.bat
```

#### 2. 启动所有服务
```cmd
start-all.bat
```

#### 3. 停止所有服务
```cmd
stop-all.bat
```

#### 4. 测试所有服务
```cmd
test-services.bat
```

### Linux 环境

#### 1. 设置脚本权限
```bash
chmod +x *.sh
```

#### 2. 构建所有服务
```bash
./build-all.sh
```

#### 3. 启动所有服务
```bash
./start-all.sh
```

#### 4. 测试所有服务
```bash
./test-services.sh
```

#### 5. 检查服务状态
```bash
./status.sh
```

#### 6. 停止所有服务
```bash
./stop-all.sh
```

#### 7. Docker部署 (可选)
```bash
./deploy-docker.sh
```

#### 8. 获取帮助
```bash
./help.sh
```

> 📖 **Linux用户**: 详细的Linux部署指南请查看 [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md)

## 服务访问地址

### API端点
- User Service: http://localhost:8081/api/users
- Order Service: http://localhost:8082/api/orders
- Product Service: http://localhost:8083/api/products

### 健康检查
- User Service: http://localhost:8081/api/users/health
- Order Service: http://localhost:8082/api/orders/health
- Product Service: http://localhost:8083/api/products/health

### H2 数据库控制台
- User Service: http://localhost:8081/h2-console
- Order Service: http://localhost:8082/h2-console
- Product Service: http://localhost:8083/h2-console

数据库连接信息:
- JDBC URL: jdbc:h2:mem:userdb (或 orderdb, productdb)
- 用户名: sa
- 密码: (空)

## API 使用示例

### User Service API

#### 创建用户
```bash
curl -X POST http://localhost:8081/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "张三",
    "email": "zhangsan@example.com",
    "phone": "13800138000"
  }'
```

#### 获取所有用户
```bash
curl http://localhost:8081/api/users
```

#### 根据ID获取用户
```bash
curl http://localhost:8081/api/users/1
```

### Product Service API

#### 创建产品
```bash
curl -X POST http://localhost:8083/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "iPhone 15",
    "description": "最新款iPhone",
    "price": 7999.00,
    "stock": 100,
    "category": "电子产品"
  }'
```

#### 获取所有产品
```bash
curl http://localhost:8083/api/products
```

### Order Service API

#### 创建订单
```bash
curl -X POST http://localhost:8082/api/orders \
  -H "Content-Type: application/json" \
  -d '{
    "userId": 1,
    "productId": 1,
    "quantity": 2,
    "totalAmount": 15998.00
  }'
```

#### 获取所有订单
```bash
curl http://localhost:8082/api/orders
```

#### 根据用户ID获取订单
```bash
curl http://localhost:8082/api/orders/user/1
```

## 技术栈

- **框架**: Spring Boot 2.7.14
- **数据库**: H2 (内存数据库)
- **ORM**: Spring Data JPA
- **构建工具**: Maven
- **Java版本**: 17
- **容器化**: Docker & Docker Compose (可选)

## 项目特性

- **Fat JAR**: 每个服务都可以打包成独立的可执行JAR文件
- **内存数据库**: 使用H2数据库，无需额外安装
- **RESTful API**: 标准的REST接口设计
- **健康检查**: 每个服务都提供健康检查端点
- **数据库控制台**: 可通过Web界面查看数据库内容
- **跨平台**: 支持Windows和Linux环境
- **容器化支持**: 提供Docker部署方案
- **自动化脚本**: 完整的构建、部署、测试脚本
- **服务监控**: 状态检查和日志管理

## 开发说明

### 手动构建单个服务
```bash
cd user-service
mvn clean package
java -jar target/user-service-1.0.0.jar
```

### 修改端口
如需修改服务端口，请编辑对应服务的 `src/main/resources/application.yml` 文件中的 `server.port` 配置。

### 添加新功能
每个服务都遵循标准的Spring Boot项目结构:
- `entity/`: 实体类
- `repository/`: 数据访问层
- `service/`: 业务逻辑层
- `controller/`: 控制器层

## 部署选项

### 1. 传统部署
使用提供的shell脚本在Linux服务器上直接运行JAR文件。

### 2. Docker部署
使用Docker容器化部署，支持一键部署和管理。

### 3. 生产环境
建议使用systemd管理服务，配置负载均衡和监控。

详细部署指南请参考 [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md)

## 故障排除

### 常见问题
1. **端口被占用**: 使用 `./status.sh` 检查端口状态
2. **服务启动失败**: 查看日志文件 `*.log`
3. **构建失败**: 运行 `./cleanup.sh` 后重新构建

### 获取帮助
- 运行 `./help.sh` 查看所有可用命令
- 查看 [LINUX_DEPLOYMENT.md](LINUX_DEPLOYMENT.md) 获取详细指南
- 使用 `./status.sh` 检查系统状态
