#!/bin/bash

echo "Cleaning up microservices project..."
echo

# Function to clean service directory
clean_service() {
    local service_name=$1
    echo "Cleaning $service_name..."
    
    if [ -d "$service_name" ]; then
        cd "$service_name"
        
        # Clean Maven target directory
        if [ -d "target" ]; then
            rm -rf target
            echo "  ✓ Removed target directory"
        fi
        
        # Remove Dockerfile if exists
        if [ -f "Dockerfile" ]; then
            rm -f Dockerfile
            echo "  ✓ Removed Dockerfile"
        fi
        
        cd ..
    else
        echo "  ✗ $service_name directory not found"
    fi
}

# Function to clean Docker resources
clean_docker() {
    echo "Cleaning Docker resources..."
    
    if command -v docker &> /dev/null; then
        if docker info &> /dev/null 2>&1; then
            # Stop and remove containers
            containers=$(docker ps -aq --filter "name=user-service\|order-service\|product-service")
            if [ ! -z "$containers" ]; then
                echo "  Stopping and removing containers..."
                docker stop $containers 2>/dev/null
                docker rm $containers 2>/dev/null
                echo "  ✓ Containers removed"
            fi
            
            # Remove images
            images=$(docker images --filter "reference=microsvc-*" -q)
            if [ ! -z "$images" ]; then
                echo "  Removing images..."
                docker rmi $images 2>/dev/null
                echo "  ✓ Images removed"
            fi
            
            # Remove docker-compose.yml
            if [ -f "docker-compose.yml" ]; then
                rm -f docker-compose.yml
                echo "  ✓ Removed docker-compose.yml"
            fi
            
            # Clean up unused Docker resources
            echo "  Cleaning up unused Docker resources..."
            docker system prune -f > /dev/null 2>&1
            echo "  ✓ Docker cleanup completed"
        else
            echo "  Docker is not running, skipping Docker cleanup"
        fi
    else
        echo "  Docker is not installed, skipping Docker cleanup"
    fi
}

# Function to clean log files and PID files
clean_logs_and_pids() {
    echo "Cleaning log files and PID files..."
    
    # Remove log files
    for log_file in *.log; do
        if [ -f "$log_file" ]; then
            rm -f "$log_file"
            echo "  ✓ Removed $log_file"
        fi
    done
    
    # Remove PID files
    for pid_file in *.pid; do
        if [ -f "$pid_file" ]; then
            rm -f "$pid_file"
            echo "  ✓ Removed $pid_file"
        fi
    done
    
    # Remove temporary files
    if [ -f "/tmp/health_response" ]; then
        rm -f /tmp/health_response
        echo "  ✓ Removed temporary health response file"
    fi
}

# Function to clean Maven cache (optional)
clean_maven_cache() {
    echo "Cleaning Maven cache (optional)..."
    
    if [ -d "$HOME/.m2/repository" ]; then
        read -p "Do you want to clean Maven local repository cache? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$HOME/.m2/repository"
            echo "  ✓ Maven cache cleaned"
        else
            echo "  - Maven cache preserved"
        fi
    else
        echo "  - No Maven cache found"
    fi
}

# Parse command line arguments
CLEAN_ALL=false
CLEAN_DOCKER=false
CLEAN_LOGS=false
CLEAN_MAVEN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            CLEAN_ALL=true
            shift
            ;;
        --docker)
            CLEAN_DOCKER=true
            shift
            ;;
        --logs)
            CLEAN_LOGS=true
            shift
            ;;
        --maven)
            CLEAN_MAVEN=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --all     Clean everything (default if no options specified)"
            echo "  --docker  Clean Docker containers and images only"
            echo "  --logs    Clean log and PID files only"
            echo "  --maven   Clean Maven cache only"
            echo "  --help    Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# If no specific options, clean all
if [ "$CLEAN_ALL" = false ] && [ "$CLEAN_DOCKER" = false ] && [ "$CLEAN_LOGS" = false ] && [ "$CLEAN_MAVEN" = false ]; then
    CLEAN_ALL=true
fi

# Execute cleanup based on options
if [ "$CLEAN_ALL" = true ]; then
    echo "Performing complete cleanup..."
    echo
    
    # Stop services first
    if [ -f "stop-all.sh" ]; then
        echo "Stopping services first..."
        ./stop-all.sh > /dev/null 2>&1
        sleep 2
    fi
    
    clean_service "user-service"
    clean_service "order-service"
    clean_service "product-service"
    echo
    
    clean_docker
    echo
    
    clean_logs_and_pids
    echo
    
    clean_maven_cache
    
elif [ "$CLEAN_DOCKER" = true ]; then
    clean_docker
    
elif [ "$CLEAN_LOGS" = true ]; then
    clean_logs_and_pids
    
elif [ "$CLEAN_MAVEN" = true ]; then
    clean_maven_cache
fi

echo
echo "Cleanup completed!"
echo
echo "To rebuild the project, run:"
echo "  ./build-all.sh"
echo
echo "To start services, run:"
echo "  ./start-all.sh"
echo "  or"
echo "  ./deploy-docker.sh"
