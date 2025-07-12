#!/bin/bash

echo "Building and deploying microservices with Docker..."
echo

# Function to create Dockerfile for a service
create_dockerfile() {
    local service_name=$1
    local jar_name=$2
    local port=$3
    
    cat > "$service_name/Dockerfile" << EOF
FROM openjdk:17-jre-slim

WORKDIR /app

COPY target/$jar_name app.jar

EXPOSE $port

ENTRYPOINT ["java", "-jar", "app.jar"]
EOF
    echo "Created Dockerfile for $service_name"
}

# Function to build Docker image
build_docker_image() {
    local service_name=$1
    local jar_name=$2
    
    echo "Building Docker image for $service_name..."
    cd "$service_name"
    
    if [ ! -f "target/$jar_name" ]; then
        echo "JAR file not found for $service_name. Please run build-all.sh first."
        cd ..
        return 1
    fi
    
    docker build -t "microsvc-$service_name:latest" .
    if [ $? -eq 0 ]; then
        echo "✓ Docker image built successfully for $service_name"
    else
        echo "✗ Failed to build Docker image for $service_name"
        cd ..
        return 1
    fi
    cd ..
}

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker first."
    exit 1
fi

if ! docker info &> /dev/null; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Build JAR files first
echo "Building JAR files..."
./build-all.sh
if [ $? -ne 0 ]; then
    echo "Failed to build JAR files. Exiting."
    exit 1
fi

echo
echo "Creating Dockerfiles..."
create_dockerfile "user-service" "user-service-1.0.0.jar" "8081"
create_dockerfile "order-service" "order-service-1.0.0.jar" "8082"
create_dockerfile "product-service" "product-service-1.0.0.jar" "8083"

echo
echo "Building Docker images..."
build_docker_image "user-service" "user-service-1.0.0.jar"
build_docker_image "order-service" "order-service-1.0.0.jar"
build_docker_image "product-service" "product-service-1.0.0.jar"

echo
echo "Creating Docker Compose file..."
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  user-service:
    image: microsvc-user-service:latest
    container_name: user-service
    ports:
      - "8081:8081"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
    networks:
      - microsvc-network
    restart: unless-stopped

  order-service:
    image: microsvc-order-service:latest
    container_name: order-service
    ports:
      - "8082:8082"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
    networks:
      - microsvc-network
    restart: unless-stopped
    depends_on:
      - user-service

  product-service:
    image: microsvc-product-service:latest
    container_name: product-service
    ports:
      - "8083:8083"
    environment:
      - SPRING_PROFILES_ACTIVE=docker
    networks:
      - microsvc-network
    restart: unless-stopped

networks:
  microsvc-network:
    driver: bridge
EOF

echo "✓ Docker Compose file created"

echo
echo "Starting services with Docker Compose..."
docker-compose up -d

if [ $? -eq 0 ]; then
    echo
    echo "✓ All services deployed successfully!"
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
    echo "Docker commands:"
    echo "- View logs:       docker-compose logs -f"
    echo "- Stop services:   docker-compose down"
    echo "- Restart:         docker-compose restart"
    echo "- View status:     docker-compose ps"
else
    echo "✗ Failed to start services with Docker Compose"
    exit 1
fi
