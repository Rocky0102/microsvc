#!/bin/bash

echo "==================================="
echo "    微服务项目 Linux 脚本帮助"
echo "==================================="
echo
echo "📋 可用脚本："
echo
echo "🔨 构建和部署："
echo "  ./build-all.sh      - 构建所有微服务JAR文件"
echo "  ./start-all.sh      - 启动所有微服务"
echo "  ./stop-all.sh       - 停止所有微服务"
echo "  ./deploy-docker.sh  - 使用Docker部署微服务"
echo
echo "🧪 测试和监控："
echo "  ./test-services.sh  - 测试所有微服务功能"
echo "  ./status.sh         - 检查微服务状态"
echo
echo "🧹 清理："
echo "  ./cleanup.sh        - 清理构建产物和日志"
echo "  ./cleanup.sh --help - 查看清理选项"
echo
echo "📖 文档："
echo "  cat LINUX_DEPLOYMENT.md - 查看完整部署指南"
echo "  ./help.sh               - 显示此帮助信息"
echo
echo "==================================="
echo "🚀 快速开始："
echo "==================================="
echo
echo "1. 首次使用，设置权限："
echo "   chmod +x *.sh"
echo
echo "2. 构建项目："
echo "   ./build-all.sh"
echo
echo "3. 启动服务："
echo "   ./start-all.sh"
echo
echo "4. 测试服务："
echo "   ./test-services.sh"
echo
echo "5. 检查状态："
echo "   ./status.sh"
echo
echo "6. 停止服务："
echo "   ./stop-all.sh"
echo
echo "==================================="
echo "🌐 服务信息："
echo "==================================="
echo
echo "端口："
echo "  User Service:    8081"
echo "  Order Service:   8082"
echo "  Product Service: 8083"
echo
echo "API端点："
echo "  http://localhost:8081/api/users"
echo "  http://localhost:8082/api/orders"
echo "  http://localhost:8083/api/products"
echo
echo "健康检查："
echo "  http://localhost:8081/api/users/health"
echo "  http://localhost:8082/api/orders/health"
echo "  http://localhost:8083/api/products/health"
echo
echo "H2 控制台："
echo "  http://localhost:8081/h2-console"
echo "  http://localhost:8082/h2-console"
echo "  http://localhost:8083/h2-console"
echo
echo "==================================="
echo "🔧 故障排除："
echo "==================================="
echo
echo "查看日志："
echo "  tail -f *.log"
echo "  tail -f user-service.log"
echo
echo "检查端口："
echo "  netstat -tuln | grep 808"
echo "  lsof -i :8081"
echo
echo "杀死进程："
echo "  pkill -f 'user-service-1.0.0.jar'"
echo "  kill -9 <PID>"
echo
echo "Docker相关："
echo "  docker-compose ps"
echo "  docker-compose logs -f"
echo "  docker-compose down"
echo
echo "==================================="
echo "📞 需要帮助？"
echo "==================================="
echo
echo "详细文档: cat LINUX_DEPLOYMENT.md"
echo "检查状态: ./status.sh"
echo "清理重试: ./cleanup.sh && ./build-all.sh"
echo
