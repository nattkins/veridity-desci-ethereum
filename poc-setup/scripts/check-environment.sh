#!/bin/bash

# Check Veridity POC environment requirements
set -e

echo "🔍 Checking Veridity POC environment..."

# Check Docker
echo "🐳 Checking Docker..."
if command -v docker > /dev/null 2>&1; then
    echo "✅ Docker is installed: $(docker --version)"
    if docker info > /dev/null 2>&1; then
        echo "✅ Docker daemon is running"
    else
        echo "❌ Docker daemon is not running"
        echo "   Please start Docker and try again"
        exit 1
    fi
else
    echo "❌ Docker is not installed"
    echo "   Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check Docker Compose
echo "🔧 Checking Docker Compose..."
if command -v docker-compose > /dev/null 2>&1; then
    echo "✅ Docker Compose is installed: $(docker-compose --version)"
elif docker compose version > /dev/null 2>&1; then
    echo "✅ Docker Compose (plugin) is available: $(docker compose version)"
else
    echo "❌ Docker Compose is not available"
    echo "   Please install Docker Compose or use Docker with Compose plugin"
    exit 1
fi

# Check curl
echo "🌐 Checking curl..."
if command -v curl > /dev/null 2>&1; then
    echo "✅ curl is available: $(curl --version | head -n1)"
else
    echo "❌ curl is not installed"
    echo "   Please install curl for API testing"
fi

# Check Python (for fraud detection)
echo "🐍 Checking Python..."
if command -v python3 > /dev/null 2>&1; then
    echo "✅ Python 3 is available: $(python3 --version)"
else
    echo "⚠️  Python 3 not found - fraud detection container will install it"
fi

# Check available disk space
echo "💾 Checking disk space..."
AVAILABLE_SPACE=$(df . | awk 'NR==2 {print $4}')
if [ "$AVAILABLE_SPACE" -gt 2000000 ]; then  # 2GB in KB
    echo "✅ Sufficient disk space available"
else
    echo "⚠️  Low disk space - Docker images require ~1-2GB"
fi

# Check required ports
echo "🔌 Checking port availability..."
check_port() {
    local port=$1
    local service=$2
    if lsof -i :$port > /dev/null 2>&1; then
        echo "⚠️  Port $port is in use (needed for $service)"
        echo "   Process using port: $(lsof -i :$port | tail -n1 | awk '{print $1, $2}')"
        return 1
    else
        echo "✅ Port $port is available ($service)"
        return 0
    fi
}

ALL_PORTS_AVAILABLE=true
check_port 5432 "PostgreSQL" || ALL_PORTS_AVAILABLE=false
check_port 5678 "n8n" || ALL_PORTS_AVAILABLE=false
check_port 8080 "NocoDB" || ALL_PORTS_AVAILABLE=false
check_port 5000 "Fraud Detection API" || ALL_PORTS_AVAILABLE=false

if [ "$ALL_PORTS_AVAILABLE" = false ]; then
    echo ""
    echo "⚠️  Some required ports are in use. Please stop the conflicting services or:"
    echo "   docker-compose down  # Stop any existing Veridity containers"
fi

# Check environment file
echo "📝 Checking environment configuration..."
if [ -f "../docker/.env" ]; then
    echo "✅ Environment file exists: ../docker/.env"
    
    # Check if API keys are configured
    if grep -q "your_pinata_api_key_here" ../docker/.env; then
        echo "⚠️  Pinata API keys not configured"
        echo "   Edit poc-setup/docker/.env with your Pinata API keys"
    else
        echo "✅ Pinata API keys appear to be configured"
    fi
else
    echo "⚠️  Environment file not found"
    echo "   Will be created during setup"
fi

echo ""
echo "🎯 Environment Check Summary:"
if [ "$ALL_PORTS_AVAILABLE" = true ]; then
    echo "✅ Ready to run Veridity POC!"
    echo "   Execute: cd poc-setup/scripts && ./setup-poc.sh"
else
    echo "⚠️  Please resolve port conflicts before running setup"
fi
echo ""
echo "📚 Next steps:"
echo "   1. Get Pinata API keys: https://pinata.cloud"
echo "   2. Run setup: ./setup-poc.sh"
echo "   3. Import workflows: ./import-workflows.sh"
echo "   4. Test system: ./test-poc.sh"
