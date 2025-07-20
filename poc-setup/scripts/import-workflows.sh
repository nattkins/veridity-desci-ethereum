#!/bin/bash

# Import n8n workflows for Veridity POC
set -e

echo "📥 Importing n8n workflows..."

# Wait for n8n to be ready
echo "⏳ Waiting for n8n to be ready..."
while ! curl -f -s http://localhost:5678/healthz > /dev/null; do
    sleep 2
done

echo "✅ n8n is ready, importing workflows..."

# Import paper submission workflow
echo "📄 Importing paper submission workflow..."
if [ -f "../n8n-workflows/paper-submission/academic-paper-workflow.json" ]; then
    # Note: n8n import typically requires API authentication
    # For POC, users will need to manually import or use n8n CLI
    echo "📋 Workflow file ready at: n8n-workflows/paper-submission/academic-paper-workflow.json"
    echo "   To import: Copy and paste the JSON into n8n's workflow import dialog"
else
    echo "❌ Workflow file not found"
fi

echo "🎯 Manual import instructions:"
echo "   1. Open http://localhost:5678"
echo "   2. Click 'Templates' or 'Import from file'"
echo "   3. Upload: poc-setup/n8n-workflows/paper-submission/academic-paper-workflow.json"
echo "   4. Configure your Pinata API keys in the workflow settings"
echo "   5. Activate the workflow"
echo ""
echo "🔑 Required environment variables in n8n:"
echo "   - PINATA_API_KEY"
echo "   - PINATA_SECRET_API_KEY"
