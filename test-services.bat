@echo off
echo Testing microservices...
echo.

echo Testing User Service Health...
curl -s http://localhost:8081/api/users/health
echo.

echo Testing Order Service Health...
curl -s http://localhost:8082/api/orders/health
echo.

echo Testing Product Service Health...
curl -s http://localhost:8083/api/products/health
echo.

echo.
echo Creating test data...
echo.

echo Creating a user...
curl -X POST http://localhost:8081/api/users ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"张三\",\"email\":\"zhangsan@example.com\",\"phone\":\"13800138000\"}"
echo.

echo Creating a product...
curl -X POST http://localhost:8083/api/products ^
  -H "Content-Type: application/json" ^
  -d "{\"name\":\"iPhone 15\",\"description\":\"最新款iPhone\",\"price\":7999.00,\"stock\":100,\"category\":\"电子产品\"}"
echo.

echo Creating an order...
curl -X POST http://localhost:8082/api/orders ^
  -H "Content-Type: application/json" ^
  -d "{\"userId\":1,\"productId\":1,\"quantity\":2,\"totalAmount\":15998.00}"
echo.

echo.
echo Getting all users...
curl -s http://localhost:8081/api/users
echo.

echo.
echo Getting all products...
curl -s http://localhost:8083/api/products
echo.

echo.
echo Getting all orders...
curl -s http://localhost:8082/api/orders
echo.

echo.
echo Test completed!
pause
