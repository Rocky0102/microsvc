#!/bin/bash

echo "Building all microservices..."
echo

echo "Building parent project..."
mvn clean install -DskipTests
if [ $? -ne 0 ]; then
    echo "Failed to build parent project"
    exit 1
fi

echo
echo "Building user-service..."
cd user-service
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "Failed to build user-service"
    exit 1
fi
cd ..

echo
echo "Building order-service..."
cd order-service
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "Failed to build order-service"
    exit 1
fi
cd ..

echo
echo "Building product-service..."
cd product-service
mvn clean package -DskipTests
if [ $? -ne 0 ]; then
    echo "Failed to build product-service"
    exit 1
fi
cd ..

echo
echo "All services built successfully!"
echo "Fat JARs are located in:"
echo "- user-service/target/user-service-1.0.0.jar"
echo "- order-service/target/order-service-1.0.0.jar"
echo "- product-service/target/product-service-1.0.0.jar"
