# Veridity POC API Reference

## 🧠 Fraud Detection API

### Base URL
```
http://localhost:5000
```

### Endpoints

#### GET /health
Health check endpoint
```bash
curl http://localhost:5000/health
```

**Response:**
```json
{
  "status": "healthy",
  "service": "Veridity Fraud Detection API",
  "version": "1.0.0"
}
```

#### POST /analyze
Analyze paper for fraud indicators
```bash
curl -X POST http://localhost:5000/analyze \
  -H "Content-Type: application/json" \
  -d '{
    "content": "paper content here",
    "metadata": {
      "title": "Paper Title",
      "author": "author.eth"
    }
  }'
```

**Response:**
```json
{
  "success": true,
  "fraud_score": 0.15,
  "confidence": 0.92,
  "flagged_sections": [],
  "details": {
    "statistical_flags": 0,
    "text_flags": 1,
    "content_length": 1250,
    "methodology": "Cross-modal academic fraud detection v1.0"
  },
  "breakdown": {
    "statistical_anomalies": 0.0,
    "text_inconsistencies": 0.2,
    "cross_modal_consistency": 0.1
  }
}
```

#### GET /test
Test endpoint with sample data
```bash
curl http://localhost:5000/test
```

## 🔧 n8n Webhook API

### Base URL
```
http://localhost:5678/webhook
```

### Endpoints

#### POST /submit-paper
Submit academic paper (requires workflow to be active)
```bash
curl -X POST http://localhost:5678/webhook/submit-paper \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Paper Title",
    "author_ens": "researcher.eth",
    "author_address": "0x1234...",
    "abstract": "Paper abstract",
    "content": "Full paper content",
    "keywords": ["keyword1", "keyword2"]
  }'
```

**Response:**
```json
{
  "success": true,
  "paper_id": 123,
  "ipfs_hash": "QmXxXxXx...",
  "fraud_score": 0.15,
  "message": "Paper submitted successfully"
}
```

## 📋 NocoDB API

### Base URL
```
http://localhost:8080/api/v1
```

### Authentication
Get API token from NocoDB interface: Settings > API Tokens

### Endpoints

#### GET /api/v1/db/data/v1/{projectId}/academic_papers
List academic papers
```bash
curl -H "xc-auth: YOUR_API_TOKEN" \
  http://localhost:8080/api/v1/db/data/v1/PROJECT_ID/academic_papers
```

#### POST /api/v1/db/data/v1/{projectId}/academic_papers
Create academic paper
```bash
curl -X POST \
  -H "xc-auth: YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New Paper",
    "author_ens": "author.eth",
    "abstract": "Paper abstract"
  }' \
  http://localhost:8080/api/v1/db/data/v1/PROJECT_ID/academic_papers
```

## 🗄️ PostgreSQL Direct Access

### Connection
```bash
docker exec -it veridity-postgres psql -U veridity -d veridity
```

### Common Queries

#### List all papers
```sql
SELECT id, title, author_ens, fraud_score, status, created_at 
FROM academic_papers 
ORDER BY created_at DESC;
```

#### Get paper with reviews
```sql
SELECT p.title, p.author_ens, r.quality_score, r.comments, r.recommendation
FROM academic_papers p
LEFT JOIN reviews r ON p.id = r.paper_id
WHERE p.id = 1;
```

#### Fraud detection stats
```sql
SELECT 
  AVG(fraud_score) as avg_fraud_score,
  COUNT(*) as total_papers,
  COUNT(*) FILTER (WHERE fraud_score > 0.5) as high_risk_papers
FROM academic_papers;
```

## 🔗 External APIs Used

### Pinata IPFS API
```bash
# Test authentication
curl -X GET https://api.pinata.cloud/data/testAuthentication \
  -H "pinata_api_key: YOUR_KEY" \
  -H "pinata_secret_api_key: YOUR_SECRET"

# Pin JSON to IPFS  
curl -X POST https://api.pinata.cloud/pinning/pinJSONToIPFS \
  -H "pinata_api_key: YOUR_KEY" \
  -H "pinata_secret_api_key: YOUR_SECRET" \
  -H "Content-Type: application/json" \
  -d '{
    "pinataContent": {"title": "Test Paper"},
    "pinataMetadata": {"name": "academic-paper"}
  }'
```

### Ethereum Sepolia RPC
```bash
# Get latest block
curl -X POST https://sepolia.infura.io/v3/YOUR_PROJECT_ID \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "eth_blockNumber",
    "params": [],
    "id": 1
  }'

# Get account balance
curl -X POST https://sepolia.infura.io/v3/YOUR_PROJECT_ID \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "eth_getBalance",
    "params": ["0x1234...", "latest"],
    "id": 1
  }'
```

## 📊 Response Codes

### Success Codes
- `200` - Success
- `201` - Created

### Error Codes  
- `400` - Bad Request (missing required fields)
- `401` - Unauthorized (invalid API token)
- `404` - Not Found
- `500` - Internal Server Error

### Common Error Responses
```json
{
  "error": "Missing required field: content",
  "code": 400
}
```

```json
{
  "error": "Analysis failed: Invalid input format",
  "code": 500
}
```
