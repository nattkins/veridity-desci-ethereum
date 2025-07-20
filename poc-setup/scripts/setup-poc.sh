#!/bin/bash

# Veridity POC Setup Script
set -e

echo "🚀 Setting up Veridity POC environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if required ports are available
check_port() {
    if lsof -i :$1 > /dev/null 2>&1; then
        echo "❌ Port $1 is already in use. Please free it and try again."
        exit 1
    fi
}

echo "🔍 Checking port availability..."
check_port 5432  # PostgreSQL
check_port 5678  # n8n
check_port 8080  # NocoDB
check_port 5000  # Fraud Detection API

# Create environment file
if [ ! -f "../docker/.env" ]; then
    echo "📝 Creating environment configuration..."
    cat > ../docker/.env << 'ENV_EOF'
# Veridity POC Environment Configuration
# Copy this file and update with your actual API keys

# Pinata IPFS Configuration
PINATA_API_KEY=your_pinata_api_key_here
PINATA_SECRET_API_KEY=your_pinata_secret_key_here

# Ethereum Sepolia Configuration  
ETHEREUM_RPC_URL=https://sepolia.infura.io/v3/YOUR_INFURA_PROJECT_ID
ETHERSCAN_API_KEY=your_etherscan_api_key_here

# Database Configuration
POSTGRES_DB=veridity
POSTGRES_USER=veridity
POSTGRES_PASSWORD=veridity123

# n8n Configuration
N8N_ENCRYPTION_KEY=veridity-poc-secret-key-2024

# NocoDB Configuration
NC_AUTH_JWT_SECRET=veridity-jwt-secret-2024

# Security (change these for production!)
JWT_SECRET=your-jwt-secret-change-this
WEBHOOK_SECRET=your-webhook-secret-change-this
ENV_EOF

    echo "⚠️  IMPORTANT: Edit poc-setup/docker/.env with your actual API keys!"
    echo "   You need to sign up for:"
    echo "   - Pinata (pinata.cloud) for IPFS storage"
    echo "   - Infura (infura.io) for Ethereum RPC access"
    echo "   - Etherscan (etherscan.io) for blockchain data"
fi

# Start services
echo "🐳 Starting Docker services..."
cd ../docker
docker-compose up -d

echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service health
echo "🔍 Checking service health..."
check_service() {
    local service=$1
    local url=$2
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if curl -f -s "$url" > /dev/null 2>&1; then
            echo "✅ $service is ready"
            return 0
        fi
        echo "⏳ Waiting for $service... (attempt $attempt/$max_attempts)"
        sleep 2
        ((attempt++))
    done
    
    echo "❌ $service failed to start"
    return 1
}

check_service "PostgreSQL" "http://localhost:5432"
check_service "n8n" "http://localhost:5678/healthz"
check_service "NocoDB" "http://localhost:8080/api/v1/health"
check_service "Fraud Detection API" "http://localhost:5000/health"

echo "🎉 All services are running!"
echo ""
echo "📊 Access your POC environment:"
echo "   🔧 n8n Workflows:     http://localhost:5678"
echo "   📋 NocoDB Interface:  http://localhost:8080"
echo "   🧠 Fraud Detection:   http://localhost:5000"
echo "   🗄️  PostgreSQL:       localhost:5432"
echo ""
echo "🚀 Next steps:"
echo "   1. Import n8n workflows: ./import-workflows.sh"
echo "   2. Test the system: ./test-poc.sh"
echo "   3. Submit a test paper: ./submit-test-paper.sh"
echo ""
echo "📚 Documentation:"
echo "   - POC Guide: ../docs/poc-setup-guide.md"
echo "   - API Reference: ../docs/api-reference.md"
