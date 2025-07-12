@echo off
echo Starting all microservices...
echo.

echo Checking if JAR files exist...
if not exist "user-service\target\user-service-1.0.0.jar" (
    echo user-service JAR not found. Please run build-all.bat first.
    exit /b 1
)

if not exist "order-service\target\order-service-1.0.0.jar" (
    echo order-service JAR not found. Please run build-all.bat first.
    exit /b 1
)

if not exist "product-service\target\product-service-1.0.0.jar" (
    echo product-service JAR not found. Please run build-all.bat first.
    exit /b 1
)

echo.
echo Starting User Service on port 8081...
start "User Service" java -jar user-service\target\user-service-1.0.0.jar

echo Waiting 5 seconds before starting next service...
timeout /t 5 /nobreak >nul

echo Starting Order Service on port 8082...
start "Order Service" java -jar order-service\target\order-service-1.0.0.jar

echo Waiting 5 seconds before starting next service...
timeout /t 5 /nobreak >nul

echo Starting Product Service on port 8083...
start "Product Service" java -jar product-service\target\product-service-1.0.0.jar

echo.
echo All services are starting...
echo.
echo Service URLs:
echo - User Service:    http://localhost:8081/api/users
echo - Order Service:   http://localhost:8082/api/orders
echo - Product Service: http://localhost:8083/api/products
echo.
echo Health Check URLs:
echo - User Service:    http://localhost:8081/api/users/health
echo - Order Service:   http://localhost:8082/api/orders/health
echo - Product Service: http://localhost:8083/api/products/health
echo.
echo H2 Console URLs:
echo - User Service:    http://localhost:8081/h2-console
echo - Order Service:   http://localhost:8082/h2-console
echo - Product Service: http://localhost:8083/h2-console
echo.
echo Press any key to exit...
pause >nul
