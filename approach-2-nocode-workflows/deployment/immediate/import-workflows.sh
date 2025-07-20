#!/bin/bash

echo "🔄 Importing Veridity n8n workflows..."

# Wait for n8n to be ready
echo "⏳ Waiting for n8n to start..."
until curl -s http://localhost:5678/healthz > /dev/null; do
  sleep 5
done

echo "📥 Importing academic workflows..."

# Import paper submission workflow
curl -X POST http://localhost:5678/api/v1/workflows/import \
  -H "Content-Type: application/json" \
  -d @../n8n-workflows/paper-submission-workflow.json

# Import peer review workflow  
curl -X POST http://localhost:5678/api/v1/workflows/import \
  -H "Content-Type: application/json" \
  -d @../n8n-workflows/peer-review-workflow.json

# Import payment workflow
curl -X POST http://localhost:5678/api/v1/workflows/import \
  -H "Content-Type: application/json" \
  -d @../n8n-workflows/usdc-payment-workflow.json

echo "✅ All workflows imported successfully!"
echo "🌐 Access n8n at: http://localhost:5678"
echo "📊 Access NocoDB at: http://localhost:8080"
