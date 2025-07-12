@echo off
echo Building all microservices...
echo.

echo Building parent project...
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo Failed to build parent project
    exit /b 1
)

echo.
echo Building user-service...
cd user-service
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo Failed to build user-service
    exit /b 1
)
cd ..

echo.
echo Building order-service...
cd order-service
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo Failed to build order-service
    exit /b 1
)
cd ..

echo.
echo Building product-service...
cd product-service
call mvn clean package -DskipTests
if %errorlevel% neq 0 (
    echo Failed to build product-service
    exit /b 1
)
cd ..

echo.
echo All services built successfully!
echo Fat JARs are located in:
echo - user-service/target/user-service-1.0.0.jar
echo - order-service/target/order-service-1.0.0.jar
echo - product-service/target/product-service-1.0.0.jar
