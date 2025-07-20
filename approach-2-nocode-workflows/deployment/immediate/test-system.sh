#!/bin/bash

echo "🧪 Testing Veridity no-code system..."

# Test database connection
echo "🔍 Testing database connection..."
docker exec veridity-postgres psql -U veridity -d veridity -c "\dt"

# Test NocoDB API
echo "🔍 Testing NocoDB API..."
curl -s http://localhost:8080/api/v1/db/meta/projects | jq .

# Test n8n API
echo "🔍 Testing n8n API..."
curl -s http://localhost:5678/api/v1/workflows | jq .

# Test fraud detection API
echo "🔍 Testing fraud detection API..."
curl -s http://localhost:5000/health | jq .

# Submit test paper
echo "📄 Submitting test academic paper..."
curl -X POST http://localhost:8080/api/v1/db/data/v1/papers \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Test Paper: Cross-Modal Fraud Detection",
    "author_ens": "researcher.eth", 
    "abstract": "This is a test paper submission",
    "content_ipfs": "QmTestHashForPaper123"
  }'

echo "✅ System test completed!"
echo "📊 Check results in NocoDB interface: http://localhost:8080"
