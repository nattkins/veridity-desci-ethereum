# Veridity POC: Pinata + n8n Academic Publishing

🚀 **Rapid deployment of academic publishing system using existing Ethereum infrastructure**

## ⚡ Quick Start (15 minutes)

```bash
# 1. Check prerequisites
cd scripts
./check-environment.sh

# 2. Setup POC environment  
./setup-poc.sh

# 3. Import n8n workflows
./import-workflows.sh

# 4. Test the system
./test-poc.sh

# 5. Submit test paper
./submit-test-paper.sh
```

## 🎯 What You Get

✅ **Real blockchain integration** (Sepolia testnet)  
✅ **Production IPFS storage** (Pinata)  
✅ **Visual workflow automation** (n8n)  
✅ **Academic fraud detection** (Custom API)  
✅ **Spreadsheet interface** (NocoDB)  
✅ **Complete academic workflow** (Submit → Review → Pay)

## 📊 Architecture

```
Academic Paper Submission
         ↓
    n8n Workflow
    ↓     ↓     ↓
  IPFS  Fraud  Database
(Pinata) (API) (PostgreSQL)
         ↓
   EAS Attestation
   (Sepolia Testnet)
```

## 🌐 Access Points

- **n8n Workflows**: http://localhost:5678
- **NocoDB Interface**: http://localhost:8080
- **Fraud Detection**: http://localhost:5000
- **Database**: localhost:5432

## 📚 Documentation

- [Setup Guide](docs/poc-setup-guide.md) - Complete setup instructions
- [API Reference](docs/api-reference.md) - All API endpoints
- [Troubleshooting](docs/poc-setup-guide.md#troubleshooting) - Common issues

## 🔧 Key Features

### Paper Submission Workflow
1. **Validate** - Check required fields
2. **Store** - Upload to IPFS via Pinata
3. **Analyze** - Run fraud detection
4. **Record** - Save to PostgreSQL
5. **Attest** - Create blockchain verification

### Fraud Detection
- Cross-modal consistency analysis
- Statistical anomaly detection  
- Text-data alignment verification
- Confidence scoring

### Academic Interface
- Spreadsheet-like paper management
- Review assignment tracking
- Payment status monitoring
- Fraud score visualization

## 🚀 From POC to Production

### What Works Immediately
- Real IPFS storage on Pinata
- Sepolia testnet transactions
- Complete academic workflow
- Fraud detection analysis

### Production Migration Path
1. **Mainnet deployment** - Switch to Ethereum mainnet
2. **Custom contracts** - Deploy optimized smart contracts
3. **Enterprise features** - Add multi-signature controls
4. **Scale infrastructure** - Production-grade hosting

## 💡 Cost Analysis

### POC Costs (Free!)
- Pinata: Free tier (1GB)
- Sepolia: Free test ETH
- n8n: Self-hosted (free)
- PostgreSQL: Local (free)

### Production Estimates
- Pinata Pro: $20/month (100GB)
- Ethereum mainnet: ~$50/month gas
- Hosting: $100/month infrastructure
- **Total: ~$170/month** vs $25,000 traditional publishing

## 🎓 University Benefits

### Immediate Value
- 48-hour deployment time
- Zero blockchain expertise required
- Visual workflow management
- Real-time fraud detection

### Strategic Value  
- Blockchain technology adoption
- Academic workflow innovation
- Cost reduction (99%+ savings)
- International collaboration enablement

---

**Ready to revolutionize academic publishing?** 🚀

Start with: `cd scripts && ./check-environment.sh`
