#!/bin/bash

echo "Testing microservices..."
echo

# Function to check if service is running
check_service() {
    local service_name=$1
    local url=$2
    
    echo "Testing $service_name Health..."
    response=$(curl -s -w "%{http_code}" -o /dev/null "$url")
    if [ "$response" = "200" ]; then
        echo "✓ $service_name is healthy"
    else
        echo "✗ $service_name is not responding (HTTP: $response)"
        return 1
    fi
}

# Check all services health
check_service "User Service" "http://localhost:8081/api/users/health"
check_service "Order Service" "http://localhost:8082/api/orders/health"
check_service "Product Service" "http://localhost:8083/api/products/health"

echo
echo "Creating test data..."
echo

echo "Creating a user..."
user_response=$(curl -s -X POST http://localhost:8081/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"张三","email":"zhangsan@example.com","phone":"13800138000"}')
echo "Response: $user_response"
echo

echo "Creating a product..."
product_response=$(curl -s -X POST http://localhost:8083/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"iPhone 15","description":"最新款iPhone","price":7999.00,"stock":100,"category":"电子产品"}')
echo "Response: $product_response"
echo

echo "Creating an order..."
order_response=$(curl -s -X POST http://localhost:8082/api/orders \
  -H "Content-Type: application/json" \
  -d '{"userId":1,"productId":1,"quantity":2,"totalAmount":15998.00}')
echo "Response: $order_response"
echo

echo
echo "Getting all users..."
users=$(curl -s http://localhost:8081/api/users)
echo "Users: $users"
echo

echo
echo "Getting all products..."
products=$(curl -s http://localhost:8083/api/products)
echo "Products: $products"
echo

echo
echo "Getting all orders..."
orders=$(curl -s http://localhost:8082/api/orders)
echo "Orders: $orders"
echo

echo
echo "Test completed!"
echo
echo "Additional test commands you can run manually:"
echo "# Get specific user by ID"
echo "curl -s http://localhost:8081/api/users/1"
echo
echo "# Get specific product by ID"
echo "curl -s http://localhost:8083/api/products/1"
echo
echo "# Get specific order by ID"
echo "curl -s http://localhost:8082/api/orders/1"
echo
echo "# Update user"
echo 'curl -X PUT http://localhost:8081/api/users/1 -H "Content-Type: application/json" -d '"'"'{"name":"李四","email":"lisi@example.com","phone":"13900139000"}'"'"
echo
echo "# Delete user"
echo "curl -X DELETE http://localhost:8081/api/users/1"
