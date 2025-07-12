#!/bin/bash

echo "Checking microservices status..."
echo

# Function to check service status
check_service_status() {
    local service_name=$1
    local port=$2
    local health_url=$3
    
    echo "=== $service_name Status ==="
    
    # Check if port is listening
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
        echo "✓ Port $port is listening"
        
        # Check health endpoint
        response=$(curl -s -w "%{http_code}" -o /tmp/health_response "$health_url" 2>/dev/null)
        if [ "$response" = "200" ]; then
            echo "✓ Health check passed"
            health_data=$(cat /tmp/health_response 2>/dev/null)
            if [ ! -z "$health_data" ]; then
                echo "  Response: $health_data"
            fi
        else
            echo "✗ Health check failed (HTTP: $response)"
        fi
        
        # Check process
        pid=$(lsof -ti:$port 2>/dev/null)
        if [ ! -z "$pid" ]; then
            echo "✓ Process running (PID: $pid)"
            # Get process info
            ps_info=$(ps -p $pid -o pid,ppid,cmd --no-headers 2>/dev/null)
            echo "  Process: $ps_info"
        fi
    else
        echo "✗ Port $port is not listening"
        
        # Check if PID file exists
        pid_file="${service_name,,}.pid"
        pid_file=$(echo "$pid_file" | sed 's/ /-/g')
        if [ -f "$pid_file" ]; then
            pid=$(cat "$pid_file")
            if ps -p $pid > /dev/null 2>&1; then
                echo "  PID file exists but service not responding (PID: $pid)"
            else
                echo "  Stale PID file found (PID: $pid not running)"
            fi
        else
            echo "  No PID file found"
        fi
    fi
    echo
}

# Function to check Docker containers
check_docker_status() {
    echo "=== Docker Container Status ==="
    
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null 2>&1; then
            containers=$(docker ps -a --filter "name=user-service\|order-service\|product-service" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}")
            if [ ! -z "$containers" ]; then
                echo "$containers"
            else
                echo "No microservice containers found"
            fi
        else
            echo "Docker is installed but not running"
        fi
    else
        echo "Docker is not installed"
    fi
    echo
}

# Function to show log file status
check_log_files() {
    echo "=== Log Files Status ==="
    
    for log_file in user-service.log order-service.log product-service.log; do
        if [ -f "$log_file" ]; then
            size=$(du -h "$log_file" | cut -f1)
            modified=$(stat -c %y "$log_file" 2>/dev/null || stat -f %Sm "$log_file" 2>/dev/null)
            echo "✓ $log_file ($size, modified: $modified)"
            
            # Show last few lines if file is not empty
            if [ -s "$log_file" ]; then
                echo "  Last 2 lines:"
                tail -n 2 "$log_file" | sed 's/^/    /'
            fi
        else
            echo "✗ $log_file not found"
        fi
    done
    echo
}

# Function to show system resources
check_system_resources() {
    echo "=== System Resources ==="
    
    # Memory usage
    if command -v free &> /dev/null; then
        echo "Memory usage:"
        free -h | sed 's/^/  /'
    fi
    
    # Disk usage
    echo "Disk usage:"
    df -h . | sed 's/^/  /'
    
    # Java processes
    echo "Java processes:"
    ps aux | grep java | grep -v grep | sed 's/^/  /' || echo "  No Java processes found"
    echo
}

# Main status check
echo "Timestamp: $(date)"
echo

check_service_status "User Service" "8081" "http://localhost:8081/api/users/health"
check_service_status "Order Service" "8082" "http://localhost:8082/api/orders/health"
check_service_status "Product Service" "8083" "http://localhost:8083/api/products/health"

check_docker_status
check_log_files
check_system_resources

# Summary
echo "=== Quick Summary ==="
services_up=0
total_services=3

for port in 8081 8082 8083; do
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
        services_up=$((services_up + 1))
    fi
done

echo "Services running: $services_up/$total_services"

if [ $services_up -eq $total_services ]; then
    echo "✓ All services are running"
    exit 0
elif [ $services_up -eq 0 ]; then
    echo "✗ No services are running"
    exit 1
else
    echo "⚠ Some services are not running"
    exit 2
fi
