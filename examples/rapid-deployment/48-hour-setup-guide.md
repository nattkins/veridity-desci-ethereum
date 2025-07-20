# 48-Hour Veridity Setup Guide: From Zero to Live Academic Publishing

## 🎯 Goal
Deploy a fully functional academic publishing system on Ethereum in 48 hours using no-code workflows.

## ⏰ Hour-by-Hour Timeline

### **Hours 1-4: Infrastructure Setup**

#### Hour 1: Repository Setup
```bash
git clone https://github.com/veridity/veridity-desci-ethereum
cd veridity-desci-ethereum/approach-2-nocode-workflows
```

#### Hour 2: Docker Infrastructure  
```bash
cd deployment/immediate
docker-compose up -d
# Wait for all services to start
docker-compose logs -f
```

#### Hour 3: Database Initialization
```bash
# Import academic schema
docker exec veridity-postgres psql -U veridity -d veridity -f /init-scripts/academic-schema.sql

# Verify tables created
docker exec veridity-postgres psql -U veridity -d veridity -c "\dt"
```

#### Hour 4: Service Configuration
```bash
# Configure NocoDB for academic workflows
curl -X POST http://localhost:8080/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@university.edu", "password": "secure_password"}'

# Import academic project template
./import-nocodb-academic-template.sh
```

### **Hours 5-12: Workflow Development**

#### Hours 5-6: n8n Setup and Workflow Import
```bash
# Import pre-built academic workflows
./import-workflows.sh

# Access n8n interface
open http://localhost:5678

# Verify workflows imported:
# - Paper Submission Workflow
# - Peer Review Assignment
# - USDC Payment Processing
# - Fraud Detection Analysis
# - EAS Attestation Creation
```

#### Hours 7-8: External API Configuration
```bash
# Configure Pinata IPFS API
export PINATA_API_KEY="your_pinata_key"
export PINATA_SECRET_KEY="your_pinata_secret"

# Configure ENS API access
export ENS_API_KEY="your_ens_api_key"

# Configure EAS API
export EAS_API_KEY="your_eas_api_key"

# Test external connections
./test-external-apis.sh
```

#### Hours 9-10: Fraud Detection Service
```bash
cd ../fraud-detection
pip install -r requirements.txt
python setup_fraud_detection.py

# Test fraud detection API
curl -X POST http://localhost:5000/analyze \
  -H "Content-Type: application/json" \
  -d '{"ipfs_hash": "QmTestPaper123", "content": "test academic paper"}'
```

#### Hours 11-12: USDC Payment Integration
```bash
# Configure USDC contract interaction
export USDC_CONTRACT_ADDRESS="0xA0b86a33E6441d95847c07C34e6bcCAC50fF3A9F" # Ethereum Sepolia
export ETHEREUM_RPC_URL="https://sepolia.infura.io/v3/YOUR_PROJECT_ID"
export PAYMENT_WALLET_PRIVATE_KEY="your_wallet_private_key"

# Test USDC payment workflow
./test-usdc-payments.sh
```

### **Hours 13-24: University Integration**

#### Hours 13-16: ENS Domain Setup
```bash
# Register university ENS domain (or use existing)
# Example: cardiff.eth for Cardiff University

# Configure ENS delegation for academics
# Subdomain pattern: researcher-name.cardiff.eth

# Test ENS resolution
curl "https://api.ensideas.com/ens/resolve/researcher.cardiff.eth"
```

#### Hours 17-20: Academic Interface Configuration
```bash
# Customize NocoDB for university branding
# Configure academic paper submission forms
# Setup peer reviewer registration interface
# Create admin dashboards for university staff

# Access NocoDB interface:
open http://localhost:8080

# Import university-specific configurations
./configure-university-interface.sh cardiff
```

#### Hours 21-24: Testing and Validation
```bash
# Run comprehensive system test
./test-complete-workflow.sh

# Test paper submission flow:
# 1. Academic submits paper via NocoDB
# 2. n8n workflow processes submission  
# 3. IPFS upload via Pinata
# 4. Fraud detection analysis
# 5. EAS attestation creation
# 6. Database update
# 7. Email notifications

# Verify all components working
./verify-system-health.sh
```

### **Hours 25-36: User Onboarding**

#### Hours 25-28: Academic User Setup
```bash
# Create test academic accounts
./create-test-academics.sh

# Configure ENS names for test users:
# - alice.cardiff.eth
# - bob.cardiff.eth  
# - carol.cardiff.eth

# Fund test wallets with Sepolia ETH and USDC
./fund-test-wallets.sh
```

#### Hours 29-32: Peer Reviewer Registration
```bash
# Setup peer reviewer onboarding flow
# Configure expertise domain matching
# Test reviewer assignment algorithm

# Register test reviewers via NocoDB interface
./register-test-reviewers.sh
```

#### Hours 33-36: Admin Interface Training
```bash
# Setup university admin accounts
# Configure institutional controls
# Train on payment processing oversight
# Setup fraud detection monitoring

# Create admin documentation
./generate-admin-docs.sh
```

### **Hours 37-48: Live Deployment Testing**

#### Hours 37-40: End-to-End Workflow Testing
```bash
# Test complete academic publishing workflow:

# 1. Paper Submission
curl -X POST http://localhost:8080/api/v1/db/data/v1/papers \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Cross-Modal Fraud Detection in Academic Publishing",
    "author_ens": "alice.cardiff.eth",
    "abstract": "This paper presents novel approaches...",
    "keywords": ["fraud detection", "academic integrity"],
    "file_upload": "paper.pdf"
  }'

# 2. Automated Processing
# Watch n8n workflow execution in real-time

# 3. Peer Review Assignment
# Verify reviewers automatically assigned based on expertise

# 4. Review Completion
# Test review submission and USDC payment release
```

#### Hours 41-44: Performance and Security Validation
```bash
# Load testing
./load-test-system.sh --concurrent-users=50 --duration=1h

# Security testing  
./security-scan.sh

# Fraud detection validation
./test-fraud-detection-accuracy.sh

# Gas cost analysis
./analyze-gas-costs.sh
```

#### Hours 45-48: University Stakeholder Demo
```bash
# Prepare demo environment
./setup-demo-environment.sh

# Create sample papers and reviews
./populate-demo-data.sh

# Generate university dashboard
./create-university-dashboard.sh

# Performance metrics summary
./generate-performance-report.sh
```

## 🎉 48-Hour Success Checklist

### **Technical Infrastructure ✅**
- [ ] All Docker services running (PostgreSQL, NocoDB, n8n)
- [ ] External APIs configured (Pinata, ENS, EAS)
- [ ] Fraud detection service operational
- [ ] USDC payment integration working
- [ ] Database schema deployed and populated

### **Academic Workflows ✅**
- [ ] Paper submission workflow functional
- [ ] Peer review assignment automated
- [ ] Review completion and payment processing
- [ ] EAS attestation creation verified
- [ ] Email notification system working

### **University Integration ✅**
- [ ] ENS domain configured with academic subdomains
- [ ] NocoDB interface customized for university branding
- [ ] Academic and reviewer user accounts created
- [ ] Admin interface configured for university staff
- [ ] Institutional controls and oversight mechanisms

### **Testing and Validation ✅**
- [ ] End-to-end workflow tested successfully
- [ ] Performance metrics meet requirements (<2s response)
- [ ] Security validation completed
- [ ] Fraud detection accuracy validated (>95%)
- [ ] Gas costs optimized (batch processing working)

### **Demonstration Ready ✅**
- [ ] Demo environment populated with sample data
- [ ] University stakeholder dashboard created
- [ ] Performance and cost savings report generated
- [ ] User documentation and training materials ready
- [ ] Live system capable of handling real academic workflows

## 🚀 Post-48-Hour Next Steps

### **Week 1: Pilot Deployment**
- Onboard 10 real academics from partner university
- Process 5 real academic papers through complete workflow
- Gather user feedback and optimization opportunities
- Monitor system performance under real usage

### **Week 2-4: Optimization**
- Implement user feedback improvements
- Optimize n8n workflows based on real usage patterns
- Scale infrastructure for increased load
- Add advanced features based on university requirements

### **Month 2-3: Full Production**
- Scale to full department (50+ academics)
- Implement advanced fraud detection features
- Add multi-university federation capabilities
- Plan migration to custom contracts if needed

## 💡 Success Tips

### **Pre-deployment Preparation**
- Ensure all API keys and credentials ready before starting
- Have university stakeholder availability for testing
- Prepare sample academic papers for demonstration
- Setup monitoring and alerting from hour 1

### **During Deployment**
- Follow timeline strictly - each hour builds on previous
- Test each component before moving to next phase
- Document any deviations or customizations needed
- Keep university stakeholders informed of progress

### **Common Pitfalls to Avoid**
- Don't skip testing external API connections early
- Ensure sufficient Sepolia ETH for testing transactions
- Verify ENS domain ownership before configuration
- Test fraud detection with both clean and suspicious papers

**Result: Live academic publishing system on Ethereum in 48 hours!** 🚀
