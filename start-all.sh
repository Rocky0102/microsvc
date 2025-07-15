#!/bin/bash

echo "Starting all microservices..."
echo

echo "Checking if JAR files exist..."
if [ ! -f "user-service/target/user-service-1.0.0.jar" ]; then
    echo "user-service JAR not found. Please run build-all.sh first."
    exit 1
fi

if [ ! -f "order-service/target/order-service-1.0.0.jar" ]; then
    echo "order-service JAR not found. Please run build-all.sh first."
    exit 1
fi

if [ ! -f "product-service/target/product-service-1.0.0.jar" ]; then
    echo "product-service JAR not found. Please run build-all.sh first."
    exit 1
fi

echo
echo "Starting User Service on port 8081..."
nohup /usr/lib/jvm/java-8-openjdk-amd64/bin/java -jar user-service/target/user-service-1.0.0.jar > user-service.log 2>&1 &
USER_PID=$!
echo "User Service started with PID: $USER_PID"

echo "Waiting 5 seconds before starting next service..."
sleep 5

echo "Starting Order Service on port 8082..."
nohup /usr/lib/jvm/java-8-openjdk-amd64/bin/java -jar order-service/target/order-service-1.0.0.jar > order-service.log 2>&1 &
ORDER_PID=$!
echo "Order Service started with PID: $ORDER_PID"

echo "Waiting 5 seconds before starting next service..."
sleep 5

echo "Starting Product Service on port 8083..."
nohup /usr/lib/jvm/java-8-openjdk-amd64/bin/java -jar product-service/target/product-service-1.0.0.jar > product-service.log 2>&1 &
PRODUCT_PID=$!
echo "Product Service started with PID: $PRODUCT_PID"

# Save PIDs to file for stop script
echo $USER_PID > user-service.pid
echo $ORDER_PID > order-service.pid
echo $PRODUCT_PID > product-service.pid

echo
echo "All services are starting..."
echo
echo "Service URLs:"
echo "- User Service:    http://localhost:8081/api/users"
echo "- Order Service:   http://localhost:8082/api/orders"
echo "- Product Service: http://localhost:8083/api/products"
echo
echo "Health Check URLs:"
echo "- User Service:    http://localhost:8081/api/users/health"
echo "- Order Service:   http://localhost:8082/api/orders/health"
echo "- Product Service: http://localhost:8083/api/products/health"
echo
echo "H2 Console URLs:"
echo "- User Service:    http://localhost:8081/h2-console"
echo "- Order Service:   http://localhost:8082/h2-console"
echo "- Product Service: http://localhost:8083/h2-console"
echo
echo "Log files:"
echo "- User Service:    user-service.log"
echo "- Order Service:   order-service.log"
echo "- Product Service: product-service.log"
echo
echo "PID files:"
echo "- User Service:    user-service.pid"
echo "- Order Service:   order-service.pid"
echo "- Product Service: product-service.pid"
echo
echo "Use stop-all.sh to stop all services."
