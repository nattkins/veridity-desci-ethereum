# Veridity POC Setup Guide

## 🎯 Overview

This guide helps you set up a complete Veridity academic publishing POC using:
- **Pinata IPFS** for decentralized paper storage
- **n8n** for visual workflow automation
- **Sepolia testnet** for blockchain integration
- **PostgreSQL** for fast academic data queries
- **NocoDB** for spreadsheet-like academic interfaces

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- 2GB+ available disk space
- Pinata account (free tier: 1GB storage)
- Infura account (free tier: 100k requests/day)

### 1. Environment Check
```bash
cd poc-setup/scripts
./check-environment.sh
```

### 2. Setup POC
```bash
./setup-poc.sh
```

### 3. Configure API Keys
Edit `poc-setup/docker/.env`:
```env
PINATA_API_KEY=your_actual_pinata_api_key
PINATA_SECRET_API_KEY=your_actual_pinata_secret
ETHEREUM_RPC_URL=https://sepolia.infura.io/v3/YOUR_PROJECT_ID
```

### 4. Import Workflows
```bash
./import-workflows.sh
```

### 5. Test System
```bash
./test-poc.sh
./submit-test-paper.sh
```

## 📊 Accessing Your POC

### Service URLs
- **n8n Workflows**: http://localhost:5678
- **NocoDB Interface**: http://localhost:8080  
- **Fraud Detection API**: http://localhost:5000
- **PostgreSQL**: localhost:5432

### Default Credentials
- **Database**: veridity / veridity123
- **NocoDB**: Set up during first access
- **n8n**: No authentication by default

## 🔧 Workflow Configuration

### Paper Submission Workflow
1. Open n8n: http://localhost:5678
2. Import workflow: `poc-setup/n8n-workflows/paper-submission/academic-paper-workflow.json`
3. Configure Pinata credentials in HTTP Request nodes
4. Activate workflow

### Workflow Steps
1. **Webhook Trigger** - Receives paper submission
2. **Validation** - Checks required fields
3. **IPFS Upload** - Stores paper on Pinata
4. **Fraud Detection** - Analyzes paper content
5. **Database Storage** - Records submission
6. **Response** - Returns success with IPFS hash

## 🧪 Testing

### Submit Test Paper
```bash
curl -X POST http://localhost:5678/webhook/submit-paper \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Academic Paper",
    "author_ens": "researcher.eth",
    "abstract": "This is a test paper...",
    "content": "Paper content here...",
    "keywords": ["test", "blockchain", "academic"]
  }'
```

### Check Results
```bash
# Database
docker exec veridity-postgres psql -U veridity -d veridity -c "SELECT * FROM academic_papers;"

# IPFS
curl "https://gateway.pinata.cloud/ipfs/YOUR_IPFS_HASH"

# Fraud Detection
curl -X POST http://localhost:5000/analyze \
  -H "Content-Type: application/json" \
  -d '{"content": "test paper content", "metadata": {"title": "Test"}}'
```

## 🛠️ Troubleshooting

### Services Won't Start
```bash
# Check Docker status
docker-compose ps

# View logs
docker-compose logs -f

# Restart services
docker-compose restart
```

### Port Conflicts
```bash
# Stop all services
docker-compose down

# Check what's using ports
lsof -i :5432  # PostgreSQL
lsof -i :5678  # n8n
lsof -i :8080  # NocoDB
lsof -i :5000  # Fraud Detection
```

### API Connection Issues
```bash
# Test Pinata connection
curl -X GET https://api.pinata.cloud/data/testAuthentication \
  -H "pinata_api_key: YOUR_KEY" \
  -H "pinata_secret_api_key: YOUR_SECRET"

# Test Ethereum RPC
curl -X POST https://sepolia.infura.io/v3/YOUR_PROJECT_ID \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```

## 📈 Scaling to Production

### Mainnet Migration
1. Update RPC URL to mainnet
2. Replace test USDC with mainnet USDC
3. Configure production Pinata account
4. Add SSL certificates
5. Implement proper authentication

### Custom Smart Contracts
- Use POC learnings to design custom contracts
- Migrate workflows to smart contract automation
- Add advanced features like batch payments
- Implement institutional multi-signature controls

## 🔐 Security Notes

### POC Security (Development Only)
- Default passwords (change for production)
- No authentication on n8n (add for production)
- HTTP only (add HTTPS for production)
- Test networks only (audit for mainnet)

### Production Security Checklist
- [ ] Change all default passwords
- [ ] Enable authentication on all services  
- [ ] Configure HTTPS/TLS
- [ ] Audit smart contracts
- [ ] Implement rate limiting
- [ ] Add monitoring and alerting
