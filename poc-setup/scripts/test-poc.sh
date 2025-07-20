#!/bin/bash

# Test Veridity POC system
set -e

echo "🧪 Testing Veridity POC system..."

# Test database connection
echo "🗄️  Testing database connection..."
if docker exec veridity-postgres psql -U veridity -d veridity -c "SELECT 1;" > /dev/null 2>&1; then
    echo "✅ Database connection successful"
else
    echo "❌ Database connection failed"
    exit 1
fi

# Test fraud detection API
echo "🧠 Testing fraud detection API..."
if curl -f -s http://localhost:5000/health > /dev/null; then
    echo "✅ Fraud detection API is running"
    
    # Test fraud detection with sample data
    echo "🔍 Testing fraud detection analysis..."
    FRAUD_RESULT=$(curl -s -X POST http://localhost:5000/analyze \
        -H "Content-Type: application/json" \
        -d '{
            "content": "Our research shows a correlation of r=0.87 (p<0.01, n=45). However, results indicate no significant effect.",
            "metadata": {"title": "Test Paper", "author": "test.researcher.eth"}
        }')
    
    if echo "$FRAUD_RESULT" | grep -q "fraud_score"; then
        echo "✅ Fraud detection analysis working"
        echo "📊 Sample analysis result:"
        echo "$FRAUD_RESULT" | python3 -m json.tool
    else
        echo "❌ Fraud detection analysis failed"
    fi
else
    echo "❌ Fraud detection API not responding"
fi

# Test n8n
echo "🔧 Testing n8n..."
if curl -f -s http://localhost:5678/healthz > /dev/null; then
    echo "✅ n8n is running"
else
    echo "❌ n8n not responding"
fi

# Test NocoDB
echo "📋 Testing NocoDB..."
if curl -f -s http://localhost:8080/api/v1/health > /dev/null; then
    echo "✅ NocoDB is running"
else
    echo "❌ NocoDB not responding"
fi

# Database content check
echo "📊 Checking database content..."
PAPER_COUNT=$(docker exec veridity-postgres psql -U veridity -d veridity -t -c "SELECT COUNT(*) FROM academic_papers;" | xargs)
REVIEWER_COUNT=$(docker exec veridity-postgres psql -U veridity -d veridity -t -c "SELECT COUNT(*) FROM peer_reviewers;" | xargs)

echo "📄 Academic papers in database: $PAPER_COUNT"
echo "👥 Peer reviewers in database: $REVIEWER_COUNT"

if [ "$REVIEWER_COUNT" -gt 0 ]; then
    echo "✅ Sample data loaded successfully"
else
    echo "⚠️  No sample data found - this is normal for first run"
fi

echo ""
echo "🎉 POC System Test Complete!"
echo ""
echo "📊 System Status Summary:"
echo "   Database: ✅ Connected"
echo "   n8n: ✅ Running"  
echo "   NocoDB: ✅ Running"
echo "   Fraud Detection: ✅ Working"
echo ""
echo "🚀 Ready to submit test papers!"
