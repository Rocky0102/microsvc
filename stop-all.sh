#!/bin/bash

echo "Stopping all microservices..."
echo

# Function to stop service by PID file
stop_service() {
    local service_name=$1
    local pid_file=$2
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if ps -p $pid > /dev/null 2>&1; then
            echo "Stopping $service_name (PID: $pid)..."
            kill $pid
            # Wait for graceful shutdown
            sleep 3
            # Force kill if still running
            if ps -p $pid > /dev/null 2>&1; then
                echo "Force killing $service_name (PID: $pid)..."
                kill -9 $pid
            fi
            echo "$service_name stopped."
        else
            echo "$service_name is not running (PID: $pid not found)."
        fi
        rm -f "$pid_file"
    else
        echo "$service_name PID file not found. Trying to find and kill by port..."
        # Try to find and kill by port
        case $service_name in
            "User Service")
                local port_pid=$(lsof -ti:8081)
                ;;
            "Order Service")
                local port_pid=$(lsof -ti:8082)
                ;;
            "Product Service")
                local port_pid=$(lsof -ti:8083)
                ;;
        esac
        
        if [ ! -z "$port_pid" ]; then
            echo "Found $service_name running on port (PID: $port_pid), stopping..."
            kill $port_pid
            sleep 2
            if ps -p $port_pid > /dev/null 2>&1; then
                kill -9 $port_pid
            fi
            echo "$service_name stopped."
        else
            echo "$service_name is not running."
        fi
    fi
}

# Stop all services
stop_service "User Service" "user-service.pid"
stop_service "Order Service" "order-service.pid"
stop_service "Product Service" "product-service.pid"

# Alternative method: Kill all Java processes containing our jar names
echo
echo "Checking for any remaining Java processes..."
pkill -f "user-service-1.0.0.jar" 2>/dev/null
pkill -f "order-service-1.0.0.jar" 2>/dev/null
pkill -f "product-service-1.0.0.jar" 2>/dev/null

# Clean up log files (optional)
echo
echo "Log files are preserved:"
[ -f "user-service.log" ] && echo "- user-service.log"
[ -f "order-service.log" ] && echo "- order-service.log"
[ -f "product-service.log" ] && echo "- product-service.log"

echo
echo "All microservices stopped."
echo "To clean up log files, run: rm -f *.log"
